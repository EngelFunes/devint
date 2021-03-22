/**
@Author : Prasant Kumar Satpathy
@Name: GA_ContentDocmntTrgr
@CreatedDate: 4/5/2018 
@Description: GA_ContentDocmntTrgr trigger is for implementing logic on content document DML operations.
is changed
@version : 1.0  
*/
trigger GA_ContentDocmntTrgr on ContentDocument (after update, before delete , before update) {
    static final String triggerName = 'GA_ContentDocmntTrgr';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        
        if(trigger.isAfter && trigger.isUpdate)
        {
            GA_ContentDocmntTgrHndlr.updateCntAttRecs(trigger.new);
        } 
        if(trigger.isBefore && trigger.isDelete ){
            GA_ContentDocmntTgrHndlr.restrictCaseFilesDeletion(trigger.oldMap);
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            if( !GA_CDLHelper.runOnce){
                GA_ContentDocmntTgrHndlr.restrictCaseFilesEdit(trigger.new);
            }
        } 
    }
}