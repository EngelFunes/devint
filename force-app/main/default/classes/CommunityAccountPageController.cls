public without sharing class CommunityAccountPageController {
    
private static final String SmallGroupGWC='Small Group GWC';
private static final  String SMALLGRP='SG';
private static final String ACCUSTOMER='Account - Customer';    
private static final String GWCSubmitted='GWC Submitted';
private static final String Submitted='Submitted';
private static final String Completed='Completed';
private static final String MaintenanceChange='Maintenance Change';    
private static final String UnderReview='Under Review';
private static final String Rejected='Rejected';
private static final String ApprovedValidate='Approved – Validate Data/Setup Group Segments';
private static final String GroupSegmentSetupComplete='Group Segment Setup Complete';
private static final String ManualGWCSetupReady='Manual GWC Setup – Ready';
private static final String ManualGWCSetupProcessing='Manual GWC Setup – Processing';
private static final String ManualGWCSetupComplete='Manual GWC Setup – Complete';
private static final String AutomatedGWCSetupIntegrationReady='Automated GWC Setup - Integration Ready';
private static final String AutomatedGWCSetupProcessing='Automated GWC Setup - Processing';
    
    @AuraEnabled
    public static Account isCustomer(id accountID){
       Account accRec = [select id, Recordtypeid, Recordtype.Name,ARV_Renewal_Account_Type__c, Name from Account where id =:accountID]; 
       System.debug('*****'+accRec);
        return accRec; 
    }
    @AuraEnabled
    public static User isPilotAgentListView(){
        User userrec= [select id, profile.name from user where id= :Userinfo.getUserId() ]; 
       // System.debug('*****'+userrec);
        return userrec; 
    }
    
      
    @AuraEnabled
    public static Boolean AltQuoteCondition(Id AccId){
       // system.debug('enter the method in class');
        Boolean returnval=True;
        Account acc=[select id,RecordType.name,ARV_Renewal_Account_Type__c from  account where id=:AccId];
        if(acc.ARV_Renewal_Account_Type__c!='SG'|| acc.RecordType.Name!='Account - Customer')
        returnval=false;
       // system.debug('returnval:::'+returnval);
      return returnval;
    }
        @AuraEnabled
    /*****************************************************************************************
Method Name   : AltQuoteCondition. 
Date Created : 27-MAY-2020
Created By   : IDC Offshore
Description  :This is the method that checks the quote record type and account record type to display alternateQuote button.
******************************************************************************************/
    public static Boolean getAccountrecord(Id AccId)
        
    {
    try{
        
        Boolean returnval=false;
        Account acc=[select id,RecordType.name,ARV_Renewal_Account_Type__c from  account where id=:AccId];
        if(acc.RecordType.Name==ACCUSTOMER && acc.ARV_Renewal_Account_Type__c==SMALLGRP )
       {
        returnval=true;
       }
        //system.debug('returnval:::'+returnval);
        return returnval;
        }catch(Exception e)
      { 
        throw new AuraHandledException(e.getMessage());
      }
       
    } 
    /* added the below block for US 3654 and 3655 */
  @AuraEnabled
    public static Boolean disabledMaintenanceChange(Id AccId){
      
        Boolean disableMaintenanceChange=false;
        
        Account acc=[select id,RecordType.name,ARV_Renewal_Account_Type__c from  account where id=:AccId];
        List <Contract> con=[select id,Status from  contract where Accountid=:AccId and ARV_Contract_Type__c=:SmallGroupGWC and ((Status =:GWCSubmitted)or(Status =:UnderReview)or(Status =:Rejected)
                                                            or(Status =:ApprovedValidate)
                                                            or(Status =:GroupSegmentSetupComplete)
                                                            or(Status =:ManualGWCSetupReady)or(Status =:ManualGWCSetupProcessing)
                                                            or(Status =:ManualGWCSetupComplete)or(Status =:AutomatedGWCSetupIntegrationReady)
                                                            or(Status =:AutomatedGWCSetupProcessing))];
        List <ARV_Gwc_Transaction_Table__c> gwc=[select id,status__c from  ARV_Gwc_Transaction_Table__c where Account_ID__c=:AccId and RecordType.Name=:MaintenanceChange and (status__c=:UnderReview)];
     
        if(gwc.size()>0 || con.size()>0)
        {
            disableMaintenanceChange = true;
        }
       
      return disableMaintenanceChange;
    }  
    
  @AuraEnabled
  public static Boolean AltQSGQuoteCondition(Id qId){
       // system.debug('enter the method in class');
        Boolean returnval=True;
        Quote quo=[select id,RecordType.name from  Quote where id=:qid];
         if(quo.RecordType.Name!='Quote')
            returnval=false;
        //system.debug('returnval:::'+returnval);
      return returnval;    
    }
    
    @AuraEnabled
    public static List<Account> getAgentAccounts(String searchTerm){
    
    System.debug('********searchTerm********'+searchTerm);
          List<Account> accounList= New List<Account>();
          String nameValue = '%'+searchTerm+'%';
           User userrec= [select id, profile.name from user where id= :Userinfo.getUserId() ];
          List<String> recList= new List<String>();
           if(userrec.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA || userrec.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA_login){
                recList= System.label.BCBSM_FSA_Allowed_Account_RecordTypes.split(','); 
           }else if(userrec.Profile.Name == System.label.User_Profile_Name_BCBSM_Both || userrec.Profile.Name == System.label.User_Profile_Name_BCBSM_Both_Login ){
                  recList=System.label.BCBSM_Both_Allowed_Account_RecordTypes.split(',') ;
           }
        try{ 
        if(String.isnotBlank(nameValue)){
            accounList= [Select id,Name,createddate,GA_RecordType__c,Renewal_Month__c from Account where Recordtype.name IN :recList and Name LIKE :nameValue  ]; 
        }else{
             accounList= [Select id,Name,createddate,GA_RecordType__c,Renewal_Month__c from Account where Recordtype.name IN :recList]; 
        }
        }   
        catch(Exception ex){throw new AuraHandledException(ex.getMessage());}
        return accounList; 
    }  
    
    @AuraEnabled
    public static CommunityAgentResponseWrapper getAgentCommunityUserAccountdetails(id accountID){
    
    CommunityAgentResponseWrapper communityAgentResponseWrapper =new CommunityAgentResponseWrapper();
        User userrec= [select id, profile.name from user where id= :Userinfo.getUserId() ]; 
        Account accRec = [select id, Recordtypeid,createddate, Recordtype.Name,ARV_Renewal_Account_Type__c, Name,Account_Status__c, ARV_Tech_DC_SmallGroup__c  from Account where id =:accountID]; 
        List <GA_Group_Segment__c> gsRec = new list <GA_Group_Segment__c>( [select id ,GA_DC_Small_Group__c from GA_Group_Segment__c where GA_Account__c = :accountID ]);
        List <Contract> conRec = new list <Contract>( [select id,ARV_Renewal_Status__c,Recordtype.Name from Contract where AccountId = :accountID ]);
        if(userrec!=null){
               if(userrec.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA || userrec.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA_login){
                   communityAgentResponseWrapper.isBCBSMFSAUser=true;
               }else if(userrec.Profile.Name == System.label.User_Profile_Name_BCBSM_Both || userrec.Profile.Name == System.label.User_Profile_Name_BCBSM_Both_Login ){
                   communityAgentResponseWrapper.isBCBSMBothUser =true;
               }else if(userrec.Profile.Name == System.label.User_Profile_Name_Agent || userrec.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA_login){
                   communityAgentResponseWrapper.isBCBSMAgentUser=true;
               }
           else if(userrec.Profile.Name == System.label.User_Profile_Name_MAUser || userrec.Profile.Name == System.label.User_Profile_Name_Agent)
            {
                communityAgentResponseWrapper.isBCBSMAUser=true;
            }
          }
        /*For 3732*/
        Boolean dc_Small_Group = true;
        for (GA_Group_Segment__c gs:gsRec)
        {
            if(gs.GA_DC_Small_Group__c!=false){
                dc_Small_Group = true;
                break;
            }
            else{
                dc_Small_Group = false;
                continue;
            }
         }
        /*Boolean renRecType = false;
        if(conRec!=null){
            for (Contract con:conRec)
            {
                if(con.Recordtype.Name=='Renewal'&& con.ARV_Renewal_Status__c!='Withdraw' && con.Status!='Cancelled'){
                    renRecType = true;
                    break;
                }
                else if(con.Recordtype.Name=='Enrollment'&& con.Status=='Activated'){
                    renRecType = true;
                    break;
                }
                else{
                    renRecType = false;
                    continue;
                }
             }
        }*/
          if(accRec  != null && gsRec != null){
               communityAgentResponseWrapper.accountName=accRec.Name;
               if((accRec.ARV_Renewal_Account_Type__c != Null && accRec.ARV_Renewal_Account_Type__c=='SG') &&  (accRec.RecordType.Name=='Account - Customer' && accRec.Account_Status__c=='Active') && (dc_Small_Group!=true)){
                   communityAgentResponseWrapper.isRenewelAccountType =true;
               }
               if(accRec.RecordType.Name=='Account - Customer'){
                   communityAgentResponseWrapper.isCustomerAccount=true;
               }else if(accRec.RecordType.Name=='Account - Prospect' || accRec.RecordType.Name=='Unqualified Prospect (Agent)' ){
                   communityAgentResponseWrapper.isProspect=true;
               }
          }
       // System.debug('*****'+userrec);
        return communityAgentResponseWrapper ; 
    }
    public class CommunityAgentResponseWrapper{
        @AuraEnabled
        public boolean isBCBSMFSAUser= false;
        
        @AuraEnabled
        public boolean isBCBSMBothUser =false;
        
        @AuraEnabled
        public boolean isBCBSMAgentUser=false;
        
        @AuraEnabled
        public boolean isCustomerAccount=false;
        
        @AuraEnabled
        public boolean isRenewelAccountType=false ;
        
        @AuraEnabled
        public String accountName;
        
        @AuraEnabled
        public boolean isProspect=false;
        
         @AuraEnabled
        public boolean isBCBSMAUser=false;

        
    }
}