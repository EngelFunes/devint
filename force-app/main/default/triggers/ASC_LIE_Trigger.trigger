/***************************************************************************************************************
@Author : Sundeep T
@Name: ASC_LIE_Trigger 
@CreatedDate: 21 - May 2020 
@Description: ASC_LIE_Trigger is for performing business logics on LIE
@version : 1.0  
***************************************************************************************************************/
trigger ASC_LIE_Trigger on Line_Item_Extension__c (before insert,before update,after insert,after update) {
    static final String triggerName = 'ASC_LIE_Trigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c)
    { 
    if(trigger.isbefore && trigger.isInsert)
    {
        ASC_LIE_TriggerHandler.beforeInsert(trigger.new);
       
    }
    if(trigger.isbefore && trigger.isUpdate)
    {
      	ASC_LIE_TriggerHandler.beforeUpdate(trigger.new);
      
    }
        if(trigger.isafter && trigger.isInsert)
    {
                //ASC_AutoGenerateFiles.invokeContractualDocumentScheduleA(trigger.new,trigger.isInsert,trigger.oldMap);
            	
    }
        if(trigger.isafter && trigger.isUpdate)
    {
        ASC_AutoGenerateFiles.invokeContractualDocumentScheduleA(trigger.new,trigger.oldMap) ;
       
    }
    }
}