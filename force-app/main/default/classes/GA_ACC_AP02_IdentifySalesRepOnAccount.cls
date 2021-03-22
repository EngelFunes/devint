/**
@Author : Padmahaarika Jayana
@Name: GA_ACC_AP02_IdentifySalesRepOnAccount
@CreatedDate: 01-Aug-2017 
@Description: GA_ACC_AP02_IdentifySalesRepOnAccount class on updating the retention sales rep on Account  
team based on territory
@version : 1.0  
*/
public without sharing class GA_ACC_AP02_IdentifySalesRepOnAccount {
    public static boolean isExecuting = false;
    public static  List<Account>  accListFltr=new List<Account>();
    public static  List<Account>  accOwnerList=new List<Account>(); 
    public static  List<GA_Jeopardy__c>  accJeopList=new List<GA_Jeopardy__c>(); 
    public static Map<String,String> acctSalesTeamMap=new  Map<String,String>();
    public static AccountTeamMember[] newmembers;
    public static AccountTeamMember[] deletemembers;
    private static final string CUSTOMERRECTYPE = System.Label.GA_CustomerRecType;
    private static final string PROSPECTRECTYPE = System.Label.GA_ProspectRecType;
    private static final string AGENCYRECTYPE  = 'Account - Agency';
    private static  final Id CUSTOMERRECTYPEID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(CUSTOMERRECTYPE).getRecordTypeId();
    private static  final Id PROSPECTRECTYPEID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(PROSPECTRECTYPE).getRecordTypeId();
    private static final  Id AGENCYRECTYPEID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(AGENCYRECTYPE).getRecordTypeId();
    private static final  String AGENCYTIER ='PLAT';       
    private static final string TERRERRMSG = System.Label.GA_TerrErrorMsg;
    private static final string JPRDYERRMSG = 'Unable to update Jeopardy Owner Manager';
    private static final string AGENCYTIERERRMSG = 'Unable to update platinum status on Agency account';
    private static  final string TerritoryVal='GA_Territory__c';
    private static final string CLSNAME  ='GA_ACC_AP02_IdentifySalesRepOnAccount';
    private static final string METHODNMCRTSLSACC  ='createsalesTeamOnAccount';
    private static  final string METHODSLSTMONACC  ='updatesalesTeamOnAccount';
    private static final string METHODSLSREPACCTM  ='addSalesReptoAccountTeam';
    private static final string METHODUPTACCFLDINS ='UpdtAccFieldsOnInsert';
    private static final string METHODASSREPOWNR = 'assignRepasOwner';
    private static final string METHODCHNGPLTNSTS = 'changePlatinumSts';
    
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
    /**
@Description: createsalesTeamOnAccount() method 
@Name : updatesalesTeamOnAccount
@Param : list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap
@Return : void
@throws Exception : N/A;
*/ 
    public static void createsalesTeamOnAccount(list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap )
    {
        try{
            acctSalesTeamMap = New Map<String,String>();
            for(Account selAcct : accList){
                
                if((String.isNotBlank(selAcct.GA_Territory__c))
                   && (selAcct.RecordTypeId  == CUSTOMERRECTYPEID || selAcct.RecordTypeId  == PROSPECTRECTYPEID )
                   && String.isNotBlank(selAcct.GA_Retention_Sales_Rep__c)  
                   && selAcct.GA_IsAccOwnerRSR__c){
                       
                       acctSalesTeamMap.put(selAcct.Id,selAcct.GA_Retention_Sales_Rep__c);
                   }
            }           
            
            
            //addSalesReptoAccountTeam();-Commenting to prevent errors due to inactive user assignment
            
            
        }catch (Exception e){
            
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMCRTSLSACC);
            accList[0].adderror(TERRERRMSG);
        }
        
    }
    
    /**
@Description: updatesalesTeamOnAccount() method 
@Name : updatesalesTeamOnAccount
@Param : list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap
@Return : void
@throws Exception : N/A;
*/ 
    public static void updatesalesTeamOnAccount(list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap )
    {
        try{
            
            acctSalesTeamMap = New Map<String,String>();
            for(Account selAcct : accList){
                
                if((String.isNotBlank(selAcct.GA_Territory__c)) && 
                   (selAcct.RecordTypeId  == CUSTOMERRECTYPEID || selAcct.RecordTypeId  == PROSPECTRECTYPEID ) 
                   && String.isNotBlank(selAcct.GA_Retention_Sales_Rep__c)
                   && selAcct.GA_IsAccOwnerRSR__c 
                  ) {
                      
                      acctSalesTeamMap.put(selAcct.Id,selAcct.GA_Retention_Sales_Rep__c);
                  }
            }           
            
            
            //addSalesReptoAccountTeam();-Commenting to prevent errors due to inactive user assignment
            if(acctSalesTeamMap.size() > 0){
                updateAccManagerOnJeoRecs();
            }
        }
        catch (Exception e){
            
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODSLSTMONACC);
            accList[0].adderror(TERRERRMSG);
        }
    }
    
    /**
@Description: addSalesReptoAccountTeam() method 
@Name : addSalesReptoAccountTeam
@Param : none 
@Return : void
@throws Exception : N/A;
*/   
    /* public static void  addSalesReptoAccountTeam(){
newmembers = new AccountTeamMember[]{};
deletemembers = new AccountTeamMember[]{};
List<AccountTeamMember> accTeamMemberList = New List<AccountTeamMember>();



try{
accTeamMemberList = [SELECT AccountId,TeamMemberRole,UserId FROM AccountTeamMember where accountid in :acctSalesTeamMap.keySet() and TeamMemberRole = :SalesRepRole limit 2000];

if(!accTeamMemberList.isEmpty()){              
deletemembers.addAll(accTeamMemberList);
}


if(!deletemembers.isEmpty()){

Database.delete(deletemembers);

}

AccountTeamMember teammemberad=new AccountTeamMember();
for(String newaccId:acctSalesTeamMap.keySet() ) {

teammemberad=new AccountTeamMember();
teammemberad.AccountId=newaccId;
teammemberad.UserId=acctSalesTeamMap.get(newaccId);
teammemberad.TeamMemberRole = SalesRepRole;
newmembers.add(teammemberad);

}


if(!newmembers.isEmpty()){

Database.upsert(newmembers);

}



}catch (Exception e){

GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeAddSalsRpAccntTm);
throw new ValidateException(TerrErrorMsg, e); 
}

}
*/
    
    /**
@Description: updateAccManagerOnJeoRecs() method 
@Name : addSalesReptoAccountTeam
@Param : none 
@Return : void
@throws Exception : N/A;
*/   
    public static void  updateAccManagerOnJeoRecs(){
        
        List<GA_Jeopardy__c> jeoList = New List<GA_Jeopardy__c>();
        
        try{
            
            accJeopList = [SELECT Id,GA_Account_Owner_Manager_Email__c, GA_Account_Owner_Mgr_Email__c,  GA_Acc_Owner_Mngrs_Mngr_Email__c,GA_Acc_Owner_Managers_Manager__c
                           FROM GA_Jeopardy__c where     GA_Company__c in :acctSalesTeamMap.keySet() and GA_TechActive__c =: True limit 1000];
            if(!accJeopList.isEmpty()){
                for(GA_Jeopardy__c jeo :accJeopList ){
                    jeo.GA_Account_Owner_Manager_Email__c=jeo.GA_Account_Owner_Mgr_Email__c;
                    jeo.GA_Acc_Owner_Mngrs_Mngr_Email__c = jeo.GA_Acc_Owner_Managers_Manager__c;
                    jeoList.add(jeo);
                } 
            }
            
            if(!jeoList.isEmpty()){
                
                Database.update(jeoList);
                
            }
        }catch (Exception e){
            
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODSLSREPACCTM);
            throw new ValidateException(JPRDYERRMSG, e); 
        }
        
    }
    /**
@Description: assignRepasOwner() method 
@Name : assignRepasOwner
@Param : list<Account> accList 
@Return : void
@throws Exception : N/A;
*/     
    public static void assignRepasOwner(list<Account> accList){
        try{ 
            for(Account acc : accList){
                if(!string.isBlank(acc.GA_Retention_Sales_Rep__c))
                {
                    acc.OwnerId=acc.GA_Retention_Sales_Rep__c;
                } 
            }  
        }catch (Exception e){
            
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODASSREPOWNR);
            throw new ValidateException(JPRDYERRMSG, e); 
        }
        
    }
    /**
@Description: assignRepasOwner() method 
@Name : assignRepasOwner
@Param : list<Account> accList 
@Return : void
@throws Exception : N/A;
*/     
    public static void changePlatinumSts(list<Account> accList){
        try{ 
            for(Account acc : accList){
                String accAgencyTier = (acc.GA_Agency_Tier__c <> null ?acc.GA_Agency_Tier__c : '') ;
                if((accAgencyTier.equalsIgnoreCase(AGENCYTIER)) && !string.isBlank(acc.GA_Agency_Tier__c ) && (acc.RecordTypeId  == AGENCYRECTYPEID ))
                {
                    acc.GA_Platinum__c =true;
                } 
                else{
                    acc.GA_Platinum__c = false;
                }
            }  
        }catch (Exception e){
            
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODCHNGPLTNSTS);
            throw new ValidateException(AGENCYTIERERRMSG, e); 
        }
        
    }
    
    /**
@Description: UpdtAccFieldsOnInsert() method 
@Name : UpdtAccFieldsOnInsert
@Param : list<Account> accList 
@Return : void
@throws Exception : N/A;
*/   
    public static void UpdtAccFieldsOnInsert(list<Account> accList){
        try{
            for(Account acc : accList){           
                if(!string.isBlank(acc.Renewal_Month__c)&& (string.isBlank(acc.GA_Open_Enrollment_Month__c))&& (acc.RecordTypeId  == PROSPECTRECTYPEID ))
                {
                    acc.GA_Open_Enrollment_Month__c=acc.Renewal_Month__c;
                }
                if((!string.isBlank(acc.Federal_Tax_ID__c))&& (string.isBlank(acc.GA_Principal_Admin_Pin__c))&& (acc.RecordTypeId  == PROSPECTRECTYPEID ))
                {
                    acc.GA_Principal_Admin_Pin__c=(acc.Federal_Tax_ID__c).right(4);
                }           
            }
        }catch (Exception e){
            
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODUPTACCFLDINS);
            throw new ValidateException(JPRDYERRMSG, e); 
        }
        
        
    }
    
}