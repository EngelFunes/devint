/**
@Author : IDC Offshore
@Name: GA_SoldProduct_Trigger
@CreatedDate: 02 July 2019
@Description: GA_SoldProduct_Trigger   trigger is for creating/Updating External Appeals on creating Sold Product.
@version : 1.0  
*/
trigger GA_SoldProduct_Trigger on Asset (after insert) {
static final String triggerName = 'GA_SoldProduct_Trigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isAfter && trigger.isInsert)
        {
            GA_ExternalAppealSrvcCls_MOS.createExternalAppealRecordMOS(trigger.New);
        }
    }
    
}