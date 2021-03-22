trigger FeedItemTrigger on FeedItem (before insert, before update,after insert) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        FeedItemTriggerHandler.updateVisibilityForSupportRequest(trigger.new);
         FeedItemTriggerHandler.PostchatterbeforeinsertandUpdate(Trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate)
    {       
        FeedItemTriggerHandler.PostchatterbeforeinsertandUpdate(Trigger.new);
    }
   if (Trigger.isAfter && Trigger.isInsert) {
       FeedItemTriggerHandler.setRequestNumberAccountDetails(trigger.new);
       FeedItemTriggerHandler.noResponseEmailChecktoAgent(Trigger.new);
    }
}