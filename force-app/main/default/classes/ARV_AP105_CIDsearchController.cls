/**
@Author : Surya Peddada.
@Name: ARV_AP105_CIDsearchController
@CreatedDate: 10-March-2020
@Description: ARV_AP105_CIDsearchController List views for contract.....
@version : 1.0 
*/
public without Sharing class ARV_AP105_CIDsearchController { 
    private static final String METADATA_QRY = 'SELECT MasterLabel, QualifiedApiName,'+
                                                'Month__c FROM ARV_Renewal_Contract_List_View__mdt order by MasterLabel asc';
    private static final String CONTRACT_QRY = system.label.ARV_CONTRACT_RENEWAL_QUERY;
    private static final String PROCEDURE_NAME = 'RenewalBatch_Generate';
    public string profileName;
    private static final String RENEWALWHERECLAUSE=' where id=:paramId1';
    private static final String PROFILE_QRY = 'SELECT Id, Name FROM Profile';
    private static final String CANCELED = 'Canceled';
    private static final String C_CANCELLED = 'Cancelled';
    private static final String WITHDRAW='Withdraw';
    private static final String PEND='Pend';
    private static final String READY='Ready';
    private static final String PENDING = 'Pending';
    private static final String PROFILE_QUERY='select id,name from Profile';
    private static final String PROFILE_WHRCLS=' where id=:paramId1';
    private static final String PLANS_QUERY = 'select Id,Name,vlocity_ins__ContractId__c,'+
                        'vlocity_ins__Product2Id__r.Id,vlocity_ins__Product2Id__r.vlocity_ins__EndDate__c'+
                        ',vlocity_ins__Product2Id__r.vlocity_ins__EffectiveDate__c from vlocity_ins__ContractLineItem__c';
    private static final String PLANS_WHERE = ' where vlocity_ins__ContractId__c in:idsList';
    private static final String EXCLUDE_CONTRACT_QUERY = 'Select Id,ARV_Excluded_from_Renewal__c,'+
                        'AccountId,vlocity_ins__ExpiredContractId__c,'+
                        'Account.Renewal_month__c,ARV_Requested_Effective_Date__c from Contract';
    private static final String EXCLUDE_CONTRACT_WHERE_QUERY = ' Where id in:idsList';
    private static final String CONTRACT_QRY_LIMIT = 'LIMIT 5 OFFSET 0';
    private static final String CONTRACT_LISTVIEWS_QUERY = 'SELECT MasterLabel, QualifiedApiName,Sort_Order__c,'+
                                'Component_Name__c FROM ARV_Contract_List_View__mdt order by Sort_Order__c asc';
    private static final String TEXT_SG='SG';
    private static final String ACTIVED = 'Active';
    private static final String ACTIVATED='Activated';
    private static final String FUTURED = 'Future';
    private static final String RUNNING = 'Running';
    private static final String EMPTY_STRING = '';
    private static final String LIMIT_QRY=' limit 100';
    private static final String RENEWALBTQRY='select id,ARV_Renewal_Month__c,ARV_Completed_Date__c from  Renewal_Batch__c';
    private static final String RENBTCHWHERECLAUSE='  where id=:paramId1';
    private static final String LIMIT1=' limit 1';
    private static final String ACCQRY='select id, Renewal_month__c from account ';
    private static final String ACCWHERECLAUSE=' where id=:paramId5';
    private static final String BATCH_TITLE = 'SG Renewal_';
    private static final String COMPLETED = 'Completed';
    private static final String ID1= 'Id';
    private static final String MERGEDATA='mergeData';
    private static final String CONTRACTTYPE='ContractType';
    private static final String MULTIPLE ='Multiple';
    private static final String SINGLE='Single';
    private static final String APEXJOBID='ApexJobId';
    private static final String SUCCESS_IP = 'Success - IP';
    private static final String SUCCESS_INTEGRATION = 'Success - Integration';
    private static final String ERROR_PREVALIDATION = 'Error - Pre-validation';
    private static final String PRODUCT_ERROR = 'Product Error';
    private static final String SUCCESS_PREVALIDATION = 'Success - Pre-validation';
    private static final String NO_CROSS_WALKPRODUCT_ASSIGN = 'No Product Crosswalk assign';
    private static final String INVALID_PRODUCT_CROSSWALK = 'Invalid Product Crosswalk for '; 
    private static final String SGUNDERWRITER='Small Group Underwriter';
    private static final String SGUMANAGER='Small Group Underwriting Manager';
    private static final string ACCOUNTQUERY='Select id,ARV_BatchId__c from Account';
    private static final string ACCOUNTWHERE=' where Id in:paramId2';
    private static final string ILNUMBER='920';
    private static final string HYPHEN='-';
    private static final string COMMA=',';
    
    private static final String ACTIVE = 'Active';
    
    private static final String NONE = '';
   
    
    private static final String RELEASED = 'Released';
    
    private static final String RENEWAL ='renewal';
    /**
    @Description: listValues() method
    @Name : listValues
    @Param : NA
    @Return : ListViewWrapper
    @throws Exception : N/A;
    */
    @AuraEnabled
    public static list<ListViewWrapper> listValues(){ 
        try{
            list<ListViewWrapper> oListViewWrapper = new list<ListViewWrapper>();
            List<ARV_Renewal_Contract_List_View__mdt> listViews =ARV_AP07_QueryDataHelper.getsObjects(METADATA_QRY,
                                                                                                      NULL,NULL,LIMIT_QRY);
            for(ARV_Renewal_Contract_List_View__mdt lv : listViews){
                ListViewWrapper oWrapper = new ListViewWrapper();
                oWrapper.label = lv.MasterLabel;
                oWrapper.developerName = lv.Month__c;
                oListViewWrapper.add(oWrapper);
            }
            return oListViewWrapper;    
        } catch( Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
    @Description: listViews() method
    @Name : listViews
    @Param : NA
    @Return : ListViewWrapper
    @throws Exception : N/A;
    */
    @AuraEnabled
    public static list<ListViewWrapper> listViews(){ 
        try{
            list<ListViewWrapper> oListViewWrapper = new list<ListViewWrapper>();
            List<ARV_Contract_List_View__mdt> listViews =ARV_AP07_QueryDataHelper.getsObjects(CONTRACT_LISTVIEWS_QUERY,
                                                                                                      NULL,NULL,LIMIT_QRY);
            for(ARV_Contract_List_View__mdt lv : listViews){ 
                ListViewWrapper oWrapper = new ListViewWrapper();
                oWrapper.label = lv.MasterLabel;
                oWrapper.developerName = lv.Component_Name__c;
                oListViewWrapper.add(oWrapper);
            }
            return oListViewWrapper;    
        } catch( Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
    @Description: getListEligibleRecords() method
    @Name : getListEligibleRecords
    @Param : String MonthName
    @Return : Contract
    @throws Exception : N/A;
    */
    @AuraEnabled
    public static ContractWrapper getListEligibleRecords(Integer rowsLimit,Integer rowsOffset){
        system.debug('rowsOffset::'+rowsOffset);
        List<Id> conids=New List<Id>();
        List<Account> dcContractList=new List<Account>();
        List<List<Account>> listViews=new List<List<Account>>();
        system.debug('rowsLimit::'+rowsLimit);
        List<Account> acclist =[select id,name,(select id,GA_Account__c,GA_DC_Small_Group__c from Group_Segments__r) from Account where Account_Status__c=:'Active' and ARV_Renewal_Account_Type__c=:'SG' limit: rowsLimit ];
        system.debug('acclist::'+acclist.size());
        ContractWrapper conwrap= new ContractWrapper();
        listViews =macontracts(acclist); 
            system.debug('listViews::'+listViews.size());
            if(listViews.size()>0){
                dcContractList=listViews[0];
            }
        system.debug('dcContractList::'+dcContractList.size());
            set<id> accid=new set<id>();
            for(Account acc:dcContractList){
                accid.add(acc.id);
            }
        system.debug('accid:'+accid);
           List<contract> dcListview=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                       Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                       Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c
                                       from contract 
                                       WHERE AccountId IN:accid and recordtype.name=:RENEWAL and Account.ARV_Renewal_Account_Type__c=:'SG' 
                                        and ARV_Excluded_from_Renewal__c=false and Account.Account_Status__c=:'Active' 
                                        and (ARV_Renewal_Status__c=:READY or ARV_Renewal_Status__c=:RELEASED or ARV_Renewal_Status__c=:COMPLETED) 
                                        order by contractNumber Limit :rowsLimit ];
        system.debug('dcListview::'+dcListview.size());
        conwrap.filtercontractIds=conids;
        conwrap.totalRecords=dcListview.size();
         //system.debug('dcListview'+dcListview.size());
      
            conwrap.totalcontractsList=dcListview;
           // conwrap.contractsList=getMonthContract(listViews);
           system.debug('contractsList'+conwrap.totalcontractsList.size());
            //conwrap.totalRecords=validlistViews.size();
                  
        return conwrap;
    }
 //To return additional records based on offset
    @AuraEnabled
    public static loadContractWrapper loadwrapContractRecords(Integer rowsLimit){
		system.debug('rowsLimit load::'+rowsLimit);
         List<List<Account>> dclistViews=new List<List<Account>>();
       loadContractWrapper loadcontrwrap= new loadContractWrapper();
         string accquery='select id,name,(select id,GA_Account__c,GA_DC_Small_Group__c from Group_Segments__r) from Account';
            accquery+=' Where Account_Status__c=\'' +ACTIVE+'\'';
            accquery+=' and ARV_Renewal_Account_Type__c=\'' +TEXT_SG+'\'';
            //accquery+='limit '+rowsLimit;
         List<Account> accolist =database.query(accquery);
        List<Account> dclist=new List<Account>();
        dclistViews =macontracts(accolist); 
            
            if(dclistViews.size()>0){
                dclist=dclistViews[0];
            }
            set<id> acid=new set<id>();
            for(Account ac:dclist){
                acid.add(ac.id);
            }
           List<contract> dcListview=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                       Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                       Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c
                                       from contract 
                                       WHERE AccountId IN:acid and recordtype.name=:RENEWAL and Account.ARV_Renewal_Account_Type__c=:TEXT_SG 
                                        and ARV_Excluded_from_Renewal__c=false and Account.Account_Status__c=:ACTIVE 
                                        and (ARV_Renewal_Status__c=:READY or ARV_Renewal_Status__c=:RELEASED or ARV_Renewal_Status__c=:COMPLETED) 
                                        order by contractNumber Limit :rowsLimit ];
           loadcontrwrap.totalcontractsList=dcListview;
          system.debug('total contracts::'+loadcontrwrap.totalcontractsList.size());
           return loadcontrwrap;
        
          
    }
 
  
   /**
    @Description: ListViewWrapper wrapper class
    @Name : ListViewWrapper
    */
    public without Sharing class ListViewWrapper{
        @AuraEnabled public string label{get;set;} 
        @AuraEnabled public string developerName{get;set;} 
    } 
    /**
    @Description: BatchIPOutputWrapper wrapper class
    @Name : BatchIPOutputWrapper
    */
    public without Sharing class BatchIPOutputWrapper{
        @AuraEnabled public string batchId{get;set;} 
        @AuraEnabled public string apexJobId{get;set;} 
    }
    
    /**
     @Description:Wrapper class to hold contract data And total records
     @Name : ContractWrapper
     */
    public class ContractWrapper{
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<Contract> contractsList = new List<Contract>();
         @AuraEnabled
        public List<Contract> totalcontractsList = new List<Contract>();
         @AuraEnabled
        public List<Id> filtercontractIds = new List<Id>();
    }
     public class loadContractWrapper{
        @AuraEnabled
        public List<Contract> filtercontractsList = new List<Contract>();
        @AuraEnabled
        public List<Contract> totalcontractsList = new List<Contract>();
    }
    public class dcContractWrapper{
        @AuraEnabled
        public List<Account> dcList = new List<Account>();
        @AuraEnabled
        public List<Account> nonDCList = new List<Account>();
    }
    /**********************************************
@Description: macontracts() method
@Name : macontracts
@Return : Contract
@throws Exception : N/A;
***********************************************/
    private static List<List<Account>> macontracts(List<Account> aclist){
        system.debug('aclist::'+aclist.size());
        List<List<Account>> clist=new  List<List<Account>>();
        List<Account> dclist=new List<Account>();
        List<Account> nonDclist=new List<Account>();
        List<GA_Group_segment__C> gslist=new List<GA_Group_segment__C>();
        boolean flag=false;
        for(Account a:aclist){
            gslist=a.Group_Segments__r;
            for(GA_Group_segment__C gs:gslist){
                if(!gs.GA_DC_Small_Group__c){
                    flag=false;
                    break;
                }
                else{
                    flag=true;
                }
            }
            a.ARV_Tech_DC_SmallGroup__c=flag;
            
            if(!(!a.ARV_Tech_DC_SmallGroup__c)){         
                Dclist.add(a);
                
            }
            else{
                NonDclist.add(a); 
            }
            
            clist.add(Dclist);
            clist.add(NonDclist);
            
        }
          system.debug('Dclist::'+Dclist);
          system.debug('NonDclist::'+NonDclist);
        return clist;        
    }
  
}