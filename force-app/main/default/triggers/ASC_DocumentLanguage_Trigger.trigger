/*@Author : Offshore
@Name: ASC_DocumentLanguage_Trigger 
@CreatedDate: 27 - July - 2020 
@Description: ASC_DocumentLanguage_Trigger is used for Create/Update/Delete - DML operations as required.
@version : 1.0  
*/
trigger ASC_DocumentLanguage_Trigger on ASC_Document_Language__c (before insert,before Update,after update,after insert) {
       
    static final String triggerName = 'ASC_DocumentLanguage_Trigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isbefore && trigger.isInsert)
        { 
           /*US-3309 -Added By Dinesh -  before insert - duplicate check - To restrict the user to create more than 1 active/draft record.*/
           ASC_DocumentLanguage_TriggerHandler.beforeinsert(trigger.new);
        }
        if(trigger.isbefore && trigger.isUpdate)
        { 
           /*US-3309 -Added By Dinesh -  before insert - duplicate check - To restrict the user to create more than 1 active/draft record.*/
           ASC_DocumentLanguage_TriggerHandler.beforeUpdate(trigger.new,trigger.oldmap);
        }
        if(trigger.isafter && trigger.isUpdate)
        { 
           
           ASC_DocumentLanguage_TriggerHandler.afterUpdate(trigger.new,trigger.oldmap);
        }
        
    }     
}