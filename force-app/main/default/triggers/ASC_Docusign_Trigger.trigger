/***************************************************************************************************************
@Author : 
@Name: ASC_Docusign_Trigger 
@CreatedDate: 
@Description: ASC_Docusign_Trigger class is used to cover ASC_Docusign_Trigger and related Handler and Helper classes.
@version : 1.0  
***************************************************************************************************************/
trigger ASC_Docusign_Trigger on DocuSign_Participant__c (before insert,before update,after insert,after update) {
   if(trigger.isbefore && trigger.isinsert){
      ASC_DocuSignParticipantHelper.ValidateAORondocusign(trigger.new);
      ASC_DocuSignParticipantHelper.updateDocuSignParticipants(trigger.new,null);
    }
    if(trigger.isbefore && trigger.isUpdate)
    {
      	ASC_DocuSignParticipantHelper.updateDocuSignParticipants(trigger.new,trigger.oldmap);
        ASC_DocuSignParticipantHelper.ValidateAORondocusign(trigger.new);
    }
   	if(trigger.isafter && trigger.isinsert)
    {
      	ASC_DocuSignParticipantHelper.VPAdminCreation(trigger.new,null);
    }
    if(trigger.isafter && trigger.isUpdate)
    {
      	ASC_DocuSignParticipantHelper.VPAdminCreation(trigger.new,trigger.oldmap);
    }
}