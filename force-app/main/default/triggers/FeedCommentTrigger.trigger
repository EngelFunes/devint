trigger FeedCommentTrigger on feedcomment (before insert,after insert, before update){
    if(trigger.isBefore && trigger.isInsert){
        FeedCommentValidation.feedCommentValidation(trigger.new);
        FeedCommentTriggerHandler.feedCommentBeforeIU(trigger.new);
        //FeedCommentTriggerHandler.setRequestNumberAccountDetails(trigger.new);
        FeedCommentTriggerHandler.postcommentBeforeInsertAndUpdate(Trigger.new);
        FeedCommentTriggerHandler.Deligateagentupdate(trigger.new);
        
    }
    if(trigger.isBefore && trigger.isUpdate){
        FeedCommentTriggerHandler.Deligateagentupdate(trigger.new); //added by eswararao on 30th july
        
        FeedCommentTriggerHandler.feedCommentBeforeIU(trigger.new);
    }
    if (Trigger.isBefore || Trigger.isUpdate)
    {
        FeedCommentTriggerHandler.postcommentBeforeInsertAndUpdate(Trigger.new);
    }
    if (Trigger.isAfter || Trigger.isInsert) {
        FeedCommentTriggerHandler.noResponseEmailChecktoAgent(Trigger.new);
    }
}