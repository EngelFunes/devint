/*****************************************************************************************
Class Name   : ARV_Maintenance_Approval_Criteria. 
Date Created : 15-DEC-2020
Created By   : IDC Offshore
Description  :This class is used to fetch approval criteria for GWC Transaction records.
******************************************************************************************/

public without sharing class ARV_Maintenance_Approval_Criteria {
    
    public static final Id gwcTTRcrdTypId = Schema.SObjectType.ARV_GWC_Transaction_Table__c.getRecordTypeInfosByName().get('Maintenance Change').getRecordTypeId();
    public static final String result = system.label.ARV_CL42_Contract_Approved_Sucess;
    public static final String errormsg = system.label.ARV_CL43_Contract_Update_Error;
    public static final String statusCondition = 'Under Review';
    public static final String CMMA=',';
    public static final String EMPTYSTRING='';
    public static Boolean isEmailSent= true;
    public static final String COMPLETED = 'Completed';
    
    public ARV_Maintenance_Approval_Criteria(){}

    @AuraEnabled
    /*****************************************************************************************
    Method Name	 :getCriteriaRecords
    Description  :This method fetches the criteria required for approval.
    ******************************************************************************************/
    public static List<String> getCriteriaRecords(String gwctID){
        
        ARV_GWC_Transaction_Table__c gwct = [SELECT Id, ARV_Maintenance_Change_Approval_Criteria__c 
                                             FROM ARV_GWC_Transaction_Table__c WHERE Id=:gwctID];
        String criteriavalues = '';
        List<String> checkValues = new List<String> ();
        Set<String> uniquevalset = new Set<String>();
        if(!String.isBlank(gwct.ARV_Maintenance_Change_Approval_Criteria__c)){
            criteriavalues = String.valueOf(gwct.ARV_Maintenance_Change_Approval_Criteria__c);
            checkValues = criteriavalues.split(',');
            uniquevalset.addAll(checkValues);
            checkValues.clear();
            checkValues.addAll(uniquevalset);
        }
        return checkValues;
    }

    @AuraEnabled
    /*****************************************************************************************
    Method Name	 :approveRecord
    Description  :This method updates the status of the record if it has been approved
    ******************************************************************************************/
    public static string approveRecord(String gwctID){
        try {
            ARV_GWC_Transaction_Table__c gwcTTRec=[select id,Status__c,Approver__c,Approved_Date__c,RecordTypeId 
                                                   from ARV_GWC_Transaction_Table__c where Id=:gwctID ];
            if(gwcTTRec.Status__c.equals(statusCondition) && gwcTTRec.RecordTypeId == gwcTTRcrdTypId){
                gwcTTRec.Status__c=COMPLETED;
                
              update gwcTTRec;
            }
            return result;

        } catch (Exception e) {
            //GA_LogExceptionCls.LogExcpContract(e, CLSNAME, METHODNME, contractId);
            
            return errormsg;
        }
    }
        
    /********************************************************************************************************
    Description  :This method is to send email on phyiscal address update and maintainence changes aprovd
    *********************************************************************************************************/   
     public static void sendEmailMC(String accName,String accCid){
       
		try{
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String emailBody = EMPTYSTRING;
                List<string> toAddresses = system.label.ARV_MC_Email.split(CMMA) ;
                                
                mail.setToAddresses(toAddresses);
                mail.setSubject('Potential Need to Reprocess Renewal');
                emailBody += '<html> Hello,<br><br/><p> Due to processing of a rating area change prior to the effective date of the renewal contract, the current renewal will need to be reprocessed.'+accName+' '+accCid+'</p></html>';

                mail.setHTMLBody(emailBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                }
		catch(exception e){
               	//ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(contractId);    
               	GA_LogExceptionCls.LogExcp(e, ' ARV_Maintenance_Approval_Criteria','sendEmailMC');
		}
    }
}