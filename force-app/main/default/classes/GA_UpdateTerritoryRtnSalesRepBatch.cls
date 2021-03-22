/**
@Author : IDC offshore
@Name: GA_UpdateTerritoryRtnSalesRepBatch 
@CreatedDate: 05-Jan-2018  
@Description: GA_UpdateTerritoryRtnSalesRepBatch class to update territory retention sales rep as account owner
@version : 1.0  
*/
global class  GA_UpdateTerritoryRtnSalesRepBatch  implements Database.Batchable<sObject>,Database.stateful{
    private final string query ;
    private final list<id> idLst=new list<id>();
    private List<Id> idsToProcess =new List<Id>();
    private List<Account> updtAccLst = New List<Account>();
    private List<GA_Territory__c> updtTerrLst = New List<GA_Territory__c>();
    private map<id,Account>  accoldMap = New map<id,Account>();
    private Map<String,String> rsrMap=new  Map<String,String>();
    private static final String QRYUPDATECONTCTS='Select Id,AccountId,OwnerId,GA_OwnerId__c from Contact Where AccountId IN : idLst';
    private Map<Id,Id> accntOwnrToProcess =  New Map<Id,Id>();
    public static final String CLSNAME  ='GA_UpdateTerritoryRtnSalesRepBatch';
    public static final String BATCHEXECUTE ='execute';
    public static final integer OCCURENCE = 1;
    public static final String  EXCPSVRTY='ERROR';
    public static final integer UPDTACCOWNRLMT=Integer.valueof(system.label.GA_UpdateAccOwner_Limit);
    
    /**Constructor*/
    global GA_UpdateTerritoryRtnSalesRepBatch(string qrytoupdate)
    {
        query=qrytoupdate;
        
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<Account> scope)
    {   
        try{
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            for(Account acc : scope)   {
                accoldMap.put(acc.id,acc);
                Account updtAcc = New Account(Id=acc.id) ;
                updtAcc.OwnerId = acc.GA_Retention_Sales_Rep__c;
                updtAcc.GA_Is_Mass_Updating__c = true;
                updtAccLst.add(updtAcc);
                idLst.add(acc.id);
                rsrMap.put(acc.Id,acc.GA_Retention_Sales_Rep__c);
                accntOwnrToProcess.put(acc.Id,acc.GA_Retention_Sales_Rep__c);
                
                GA_Territory__c terrtyToUpdate = new GA_Territory__c(Id=acc.GA_Territory__c);
                terrtyToUpdate.GA_IsProcessed__c=true;
                updtTerrLst.add(terrtyToUpdate);
                
            }
            
            if(!updtAccLst.isEmpty())
            {
                srList = Database.update(updtAccLst,false);   
            }   
            if(!updtTerrLst.isEmpty())
            {
               //create a map that will hold the values of the list 
                map<id,GA_Territory__c> uniqueTerritoryMap = new map<id,GA_Territory__c>();
                
                //put all the values from the list to map. 
                uniqueTerritoryMap.putall(updtTerrLst);
                if(uniqueTerritoryMap.size()>0){                    
                System.debug('Updating Territory Is Processed');
                database.update(uniqueTerritoryMap.values());   
                }  
            } 
            GA_ACC_AP02_IdentifySalesRepOnAccount.acctSalesTeamMap = rsrMap;
            GA_ACC_AP02_IdentifySalesRepOnAccount.updateAccManagerOnJeoRecs();
            
            Integer iVal=0;
            if(!srList.isEmpty()){
                for(Database.SaveResult obj : srList){
                    
                    for(Database.Error objErr : obj.getErrors()){
                        if(!obj.isSuccess()){
                            ExceptionLog__c objLog = new ExceptionLog__c(
                                Object_ID__c =updtAccLst[iVal].id,
                                ExceptionDescription__c = objErr.getMessage(),
                                ExceptionCode__c =  String.valueOf(objErr.getStatusCode()),
                                NumberOfTimesOccured__c = OCCURENCE,
                                ExceptionDetails__c = objErr.getMessage(),
                                Severity__c = EXCPSVRTY);
                            excpLst.add(objLog);
                        } 
                    }
                    iVal++;
                }
            }
            if(!excpLst.isEmpty()){
                Database.insert(excpLst);
            }
            
            
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, BATCHEXECUTE);
        }
    }
    
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        GA_UpdtAccAssmntForBatch updateAccAssmntBatch=new GA_UpdtAccAssmntForBatch(idLst);
        Database.executeBatch(updateAccAssmntBatch,UPDTACCOWNRLMT); 
        
        if( !accntOwnrToProcess.isEmpty() )
        {   
            GA_AccountBatchToUpdateContactOwner updateContctsBatch=new GA_AccountBatchToUpdateContactOwner(QRYUPDATECONTCTS,accntOwnrToProcess);
            Database.executeBatch(updateContctsBatch,UPDTACCOWNRLMT);
        }
    } 
    
}