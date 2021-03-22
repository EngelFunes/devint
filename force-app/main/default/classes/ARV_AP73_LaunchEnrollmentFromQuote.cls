/*****************************************************************************************
Class Name   : ARV_AP73_LaunchEnrollmentFromQuote 
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the class to fetch the contract with status other than Cancelled and Underwriting - Rejected.
******************************************************************************************/
public without sharing class ARV_AP73_LaunchEnrollmentFromQuote {
private static final string CONTRACTWHERECLAUSE=' where AccountId=:paramId5 and status!=:paramName1 and status!=:paramName2';
private static final String QUOTEWHERECLAUSE=' where id=:paramId1';
private static final String LIMIT1=' limit 1';
private static final String QUOTEQRY='select id,accountid from quote';
private static final String CONTRACTQRY='select id from contract';
private static final String CANCELLED='Cancelled';
private static final String URURJ='Underwriting - Rejected';
private static final StrinG IsALTQUOTE='Alternate Quote';
private static final String SmallGroupGWC='Small Group GWC';
private static final String GWCSubmitted='GWC Submitted';
private static final String Submitted='Submitted';
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
    /*****************************************************************************************
Class Name   : ARV_AP73_LaunchEnrollmentFromQuote 
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the class to fetch the contract with status other than Cancelled and Underwriting - Rejected.
******************************************************************************************/
    public static Contract getContracts(Id recordId){
    try{
    ARV_AP07_QueryDataHelper.paramId1=recordId;
    list<quote> quoterec=ARV_AP07_QueryDataHelper.getsObjects(QUOTEQRY,QUOTEWHERECLAUSE,null,LIMIT1);
    Quote quote=quoterec.get(0);
       // Quote quote = [SELECT Id, AccountId FROM Quote WHERE Id=:recordId];
        ARV_AP07_QueryDataHelper.paramName1=CANCELLED;
         ARV_AP07_QueryDataHelper.paramName2=URURJ;
         ARV_AP07_QueryDataHelper.paramId5=quote.AccountId;
         
       list<contract> conlist=ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQRY,CONTRACTWHERECLAUSE,null,LIMIT1);
        Contract con=conlist.get(0);
        //Contract con = [SELECT Id FROM Contract WHERE AccountId =:quote.AccountId AND (Status != 'Cancelled' AND Status != 'Underwriting - Rejected')];           

        return con;
        }catch(Exception e){  throw new AuraHandledException(e.getMessage()+e.getlinenumber());}
    }
    
    /*****************************************************************************************
Class Name   : ARV_AP73_LaunchEnrollmentFromQuote 
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the class to fetch the contract with status other than Cancelled and Underwriting - Rejected.
******************************************************************************************/
  @AuraEnabled
    public static String getQuoteStatus(Id recordId){
        String  quotstatus=[select id,Name,Tech_QuoteStatus__c,ARV_Quote_Type__c from Quote where id=:recordId and ARV_Quote_Type__c=:IsALTQUOTE ].Tech_QuoteStatus__c;
        return quotstatus;
    }
    
    @AuraEnabled
    public static string altQSGQuoteCondition(Id qId){
        String quotetype=[select id,ARV_Quote_Type__c from Quote where id=:qId].ARV_Quote_Type__c;
         return quotetype;
        
    }
    //below lines are added as a part of US-3655
    
    @AuraEnabled
    public static boolean disabledGWC (Id recordId){
        system.debug('recordId '+recordId);
        Boolean disableGWC=false;
        
        Id AccId=[select id,Name,ARV_Quote_Type__c,AccountId from quote where id=:recordId].AccountId;
        
        system.debug('AccountId '+AccId);

        Account acc=[select Id, Name, recordtypeId,recordtype.name,ARV_ACNT_CF_TECH_pndngGrupSgmnts__c from Account where id=:AccId];
        List <Account> pendingGS=[select Id, ARV_ACNT_CF_TECH_pndngGrupSgmnts__c from Account where ARV_ACNT_CF_TECH_pndngGrupSgmnts__c>0 and id=:AccId];
        List <ARV_Gwc_Transaction_Table__c> gwc=[select id,status__c from  ARV_Gwc_Transaction_Table__c where Account_ID__c=:AccId and RecordType.Name=:MaintenanceChange and status__c=:Submitted];
        //if(gwc !=null){
            //boolean disableflag = false;
            //disableGWC = GWCDISABLED(disableflag);
            //disableGWC = true;
        //}
        List <Contract> con=[select id,Status from  contract where Accountid=:AccId and ARV_Contract_Type__c=:SmallGroupGWC and ((Status =:GWCSubmitted)or(Status =:UnderReview)or(Status =:Rejected)
                                                            or(Status =:ApprovedValidate)
                                                            or(Status =:GroupSegmentSetupComplete)
                                                            or(Status =:ManualGWCSetupReady)or(Status =:ManualGWCSetupProcessing)
                                                            or(Status =:ManualGWCSetupComplete)or(Status =:AutomatedGWCSetupIntegrationReady)
                                                            or(Status =:AutomatedGWCSetupProcessing))];
        
        if(gwc.size()>0 || con.size()>0 || pendingGS.size()>0)
    	{
         disableGWC = true;
    	}
        
        system.debug('disableGWC'+disableGWC);
        return disableGWC;
      
    }
    
}