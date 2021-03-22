/**
@Author : Prasant Kumar Satpathy
@Name: GA_LogExceptionTrigger 
@CreatedDate: 11 - OCT 2017 
@Description: GA_LogExceptionTrigger trigger is for creating Exception log records
@version : 1.0  
*/
trigger GA_LogExceptionTrigger on Log_Exception__e (after insert) {
    public static final String BLANK = '';
    public static final String errorMsg = 'Internal Error';
    public static final String errorVal = 'Failure';
    public static final String hyphenVal = '-';
    Log_Exception__e event = Trigger.New[0];
    if(event.GA_MethodName__c.contains(hyphenVal))
    {
       GA_logBCBSMWSException.updatelogWSError(event.GA_MethodName__c.split(hyphenVal)[1],errorVal,errorMsg,event.GA_Message__c,system.label.GA_CIDService,system.label.GA_Trigger,errorMsg); 
    }
    else
    GA_UTIL_LoggingService.logHandledException(event.GA_TypeName__c,event.GA_Message__c,event.GA_StackTrace__c, userinfo.getOrganizationId(), system.label.Group_Sales_App ,event.GA_ClassName__c, event.GA_MethodName__c,BLANK,logginglevel.ERROR );   
   
}