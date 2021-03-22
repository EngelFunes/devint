/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_GroupSegmentTrigger 
@CreatedDate:  June 2018 
@Description: GA_GroupSegmentTrigger trigger is for performing business logics on GS.
@version : 1.0  
********************************************************************************************************************************/
trigger GA_GroupSegmentTrigger on GA_Group_Segment__c (before insert, before update,after insert,after update) {
    static final String triggerName = 'GA_GroupSegmentTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c){
        if(trigger.isbefore && trigger.isInsert)
        {
            GA_GroupSegmentTriggerHandler.beforeInsert(trigger.new);
        } 
        
        if(trigger.isbefore && trigger.isUpdate)
        {  
          if(GA_CheckRecursive.runOnce(true) || Test.isRunningTest()) 
            GA_GroupSegmentTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);
        } 
        if(trigger.isafter && trigger.isInsert)
        {  
            if(GA_CheckRecursive.runOnce(true))
            {
                system.debug('GA_GroupSegmentTrigger AFTER INSERT');
                GA_GroupSegmentTriggerHandler.afterInsert(trigger.new,trigger.newmap);  
                GA_GroupSegmentTriggerHandler.updateWFProcess(trigger.newMap, null); //for US:2146
                GA_GroupSegmentTriggerHandler.createMAH(trigger.new); //for US:2456
                GA_GroupSegmentTriggerHandler.updateAgencyOnAccount(trigger.new, null); //for US:2421
                
            }
        }
        if(trigger.isafter && trigger.isUpdate)
        {  
            system.debug('GA_GroupSegmentTrigger AFTER UPDATE');
            if(GA_GroupSegTriggerHandler.firstrun){
                GA_GroupSegTriggerHandler.firstrun = false;
                GA_GroupSegTriggerHandler.updateGroupSegment(trigger.new, trigger.oldMap); //for US:4218
            }    
            GA_GroupSegmentTriggerHandler.afterUpdate(trigger.new, trigger.oldMap);
            GA_GroupSegmentTriggerHandler.updateWFProcess(trigger.newMap, trigger.oldMap); //for US:2146
            GA_GroupSegmentTriggerHandler.updateAgencyOnAccount(trigger.new, trigger.oldMap); //for US:2421
            GA_GroupSegmentTriggerHandler.updateAddressOnRelatedGS(trigger.new, trigger.oldMap);
            GA_GroupSegmentTriggerHandler.updateGWCTransacTableRecGS(trigger.oldMap,trigger.newMap);
        }

    }
    
}