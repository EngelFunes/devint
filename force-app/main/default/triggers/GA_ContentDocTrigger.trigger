/**
@Author : Prasant Satpathy
@Name: GA_ContentDocTrigger 
@CreatedDate: 1/31/2018
@Description: GA_ContentDocTrigger trigger is for publishishing  ContentDocument into another Library.
@version : 1.0  
*/
trigger GA_ContentDocTrigger on ContentDocumentLink (after insert,before insert) {
    
    static final String triggerName = 'GA_ContentDocTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isAfter && trigger.isInsert)
        {
            if (!GA_CDLHelper.runOnce) {
                GA_CDLHelper.runOnce=true;
                GA_CDLHelper.shareWithLibrary(trigger.new);
            }
            ASC_AutoGenerateFiles.updateFieldsAtContractualDocument(trigger.new);
           ASC_AutoGenerateFiles.sendForSignature(trigger.new);
            
        }        
        if(trigger.isBefore && trigger.isInsert)
        {   
            GA_ContentDocmntTgrHndlr.restrictCaseFilesInsert(trigger.new); //D-1971 - Uncommented as part of defect - Dinesh
            ASC_AutoGenerateFiles.updateFiles(trigger.new);
        }
    }
}