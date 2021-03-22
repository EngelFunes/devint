/*********************************************************************************************************************************
@Author : ASC Team
@Name: ASC_Quote_Trigger 
@CreatedDate: 24 - Sep 2020 
@Description: QuoteLineItem_Trigger is for performing business logics on QuoteLineItem
@version : 1.0  


******************************************************************************************************************************/
trigger QuoteLineItem_Trigger on QuoteLineItem (before delete) {

    if(trigger.isbefore && trigger.isdelete)
    {
        ASC_QuoteLineItemTriggerHandler.beforeDelete(trigger.old);
    }

   

}