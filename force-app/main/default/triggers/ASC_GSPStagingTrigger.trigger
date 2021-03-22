/*@Author : Offshore
@Name: ASC_GSPStagingTrigger 
@CreatedDate: 15 - May - 2020 
@Description: ASC_GSPStagingTrigger is used for Create/Update/Delete - DML operations as required.
@version : 1.0  
*/
trigger ASC_GSPStagingTrigger on ASC_Group_Specific_Pricing_Staging__c(after update,after insert,before insert,before update) {
    static final String triggerName = 'ASC_GSPStagingTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isafter && trigger.isInsert){    
        
          /*US-2852 -Added By Dinesh -  after insert - Group Specific Pricing Staging object that will trasform the data from this object and populate 
            it in Group Specific Pricing Object. */
           ASC_GSPStagingTriggerHandler.afterinsert(trigger.new, trigger.newmap,trigger.oldmap);
        }
        if(trigger.isbefore && trigger.isInsert)
        { 
           /*US-2852 -Added By Dinesh -  before insert - validate the data on Group Specific Pricing Staging object that will coming from HiPS System */
           ASC_GSPStagingTriggerHandler.beforeinsert(trigger.new);
        }
    }
}