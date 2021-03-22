/*@Author : Offshore
@Name: ASC_DfundGroupSegment_Trigger 
@CreatedDate: 23 - feb - 2021
@Description: ASC_DfundGroupSegment_Trigger is used for Delete - DML operations as required.
@version : 1.0  
*/
trigger ASC_DfundGroupSegment_Trigger on Dfund_Group_Segment__c (after insert,before delete, after update) {
   
  Profile adminId = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
  if(trigger.isdelete && (UserInfo.getProfileId() != adminId.Id))
        {
        
        for(Dfund_Group_Segment__c gs : trigger.old){
                if(!Dfund_CreateDfundGroupSegments.isDfundGrpSegDeleted){

                  gs.addError(' You cannot delete this Dfund Group Segment.  Please contact a system Administrator');
                }
             }
        }  
  if(trigger.isUpdate && trigger.isafter)
        {
          
          ASC_DfundGroupSegmentTriggerHandler.afterUpdate(trigger.new,trigger.oldmap);
            
        }   
    if(trigger.isInsert && trigger.isafter)
        {
         
          ASC_DfundGroupSegmentTriggerHandler.afterUpdate(trigger.new,trigger.oldmap);
            
        }  
  
}