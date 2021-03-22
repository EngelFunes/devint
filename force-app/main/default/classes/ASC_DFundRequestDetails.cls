/********************************************************************************************************
@Author : Sandeep
@Name: ASC_DFundRequestDetails
@CreatedDate:  26-Feb-2021 
@Description: ASC_DFundRequestDetails class is used to get DFUND Request record details.
@version : 1.0  
***************************************************************************************************************/
public without sharing class ASC_DFundRequestDetails {
    
  
    /********************************************************************************************************************
@Description        :   
@Name               :   fetchDFundRequest
@Param              :   String dfundRequestId
@throws Exception   :   N/A;    
********************************************************************************************************************************/        
    
    @AuraEnabled
    public static Dfund_Request__c fetchDFundRequest(string dfundRequestId){
        
        Dfund_Request__c dfundRequestRec = [select id,Name,Status__c,CID__c,Account__r.Name,Carrier__c,RecordType.Name,Renewal_Year__c from Dfund_Request__c where  id =: dfundRequestId and Status__c not in  ('New', 'Draft', 'Rejected', 'Canceled','Completed')limit 1];       
        return dfundRequestRec;       
    }    
}