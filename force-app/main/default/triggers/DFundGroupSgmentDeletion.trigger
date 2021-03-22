trigger DFundGroupSgmentDeletion on Dfund_Group_Segment__c (before delete) {

 Profile adminId = [SELECT Id from Profile where Name='System Administrator' LIMIT 1];
if(UserInfo.getProfileId() != adminId.Id)
        {
        for (Dfund_Group_Segment__c gs : trigger.old)
          
             {
                if(!Dfund_CreateDfundGroupSegments.isDfundGrpSegDeleted){

                  gs.addError(' You cannot delete this Dfund Group Segment.  Please contact a system Administrator');
                }
             }
        }             
}