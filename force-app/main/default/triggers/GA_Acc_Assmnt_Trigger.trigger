/**
@Author : IDC Offshore
@Name: GA_Acc_Assmnt_Trigger 
@CreatedDate: 02 Feb 2018
@Description: GA_Acc_Assmnt_Trigger   trigger is for creating/Updateing Account Assessment
@version : 1.0  
*/
trigger GA_Acc_Assmnt_Trigger on Account_Plan__c (before insert) 
{
    static final String triggerName = 'GA_Acc_Assmnt_Trigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isBefore && trigger.isInsert)
        {
            GA_Acc_Assmnt_TrgrHndlr.beforeInsert(trigger.New);
            GA_Acc_Assmnt_TrgrHndlr.populateAccFields(trigger.New);
        }
    }
    
}