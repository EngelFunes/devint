trigger UserTrigger on User (after insert) {
    if(trigger.isafter && trigger.isInsert)
    {
       // UserTriggerHandler.afterInsert(trigger.new, trigger.newmap);
    }
}