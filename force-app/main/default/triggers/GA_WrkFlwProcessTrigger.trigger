/**
@Author : PadmaHaarika Jayana
@Name: GA_WrkFlwProcessTrigger 
@CreatedDate: 24 - May 2017 
@Description: GA_WrkFlwProcessTrigger trigger is for updateing the workflow process.
@version : 1.0  
*/
trigger GA_WrkFlwProcessTrigger on GA_WF_Group_Segment__c (after insert,after update,before update,before insert) {
static final String triggerName = 'GA_WrkFlwProcessTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {   
        if(trigger.isbefore && trigger.isUpdate)
        {
           // GA_WrkFlwSldAftr3pm.fetchWFGSLst(trigger.newmap,trigger.oldmap);
           // GA_WrkFlwSldAftr3pm.beforeUpdate(trigger.newmap,trigger.oldmap);
            GA_WrkFlwProcessHandler.beforeupdate(trigger.new, trigger.newmap,trigger.oldmap);
         } 
        
        if(trigger.isafter && trigger.isUpdate)
        {
          //  GA_WrkFlwSldAftr3pm.afterUpdate(trigger.newmap,trigger.oldmap);
           GA_WrkFlwProcessHandler.afterupdate(trigger.new, trigger.newmap,trigger.oldmap);
            GA_WrkFlwProcessHandler.updateWrkFlwSegmentNames(trigger.new, trigger.oldMap);
        }  
        
       if(trigger.isafter && trigger.isinsert)
        {
          //  GA_WrkFlwSldAftr3pm.afterUpdate(trigger.newmap,trigger.oldmap);
           GA_WrkFlwProcessHandler.afterinsert(trigger.new, trigger.newmap,trigger.oldmap);
            GA_WrkFlwProcessHandler.updateWrkFlwSegmentNames(trigger.new, null);
        }
        
        if(trigger.isbefore && trigger.isinsert)
        {
          GA_WrkFlwProcessHandler.beforeinsert(trigger.new,trigger.newmap);
        } 
    }
}