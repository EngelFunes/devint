/**
@Author : Prasant S
@Name: GA_LogExceptionCls 
@CreatedDate: 31 - Jul 2017 
@Description: GA_LogExceptionCls class called from related classes catch block to create exception log record
@version : 1.0  
*/
public with sharing class GA_LogExceptionCls {
    
    public static final string exceLogErrMsg='Unable to create log';
    
    /**
@Description: LogExcp() method 
@Name : LogExcp
@Param : exception e,string ClsName,string MethodNme
@Return : void
@throws Exception : N/A;
*/
    public static void LogExcp(exception e,string ClsName,string MethodNme)
    {
        List<Log_Exception__e> errorMessages = new List<Log_Exception__e>();
        try{
            errorMessages.add(new Log_Exception__e(GA_Message__c = e.getMessage(),GA_StackTrace__c=e.getStackTraceString(),GA_TypeName__c=e.getTypeName(),GA_ClassName__c=ClsName,GA_MethodName__c=methodNme));
            List<Database.SaveResult> results = EventBus.publish(errorMessages);
        }
        catch(exception ex)
        {
            errorMessages[0].adderror(exceLogErrMsg);
        }
        
    }
    /**
@Description: LogExcpContract() method 
@Name : LogExcpContract
@Param : exception e,string ClsName,string MethodNme
@Return : void
@throws Exception : N/A;
*/   
    public static void LogExcpContract(exception e,string ClsName,string MethodNme,String ContractId)
    {
        List<Log_Exception__e> errorMessages = new List<Log_Exception__e>();
        try{
            String errorMessage = 'Record Id : ' + ContractId + ' - ' +e.getMessage(); 
            errorMessages.add(new Log_Exception__e(GA_Message__c = errorMessage,GA_StackTrace__c=e.getStackTraceString(),GA_TypeName__c=e.getTypeName(),GA_ClassName__c=ClsName,GA_MethodName__c=methodNme));
            List<Database.SaveResult> results = EventBus.publish(errorMessages);
        }
        catch(exception ex)
        {
            errorMessages[0].adderror(exceLogErrMsg);
        }
    }
  /**
@Description: LogExcpContractMsges() method 
@Name : LogExcpContractMsges
@Param : string msg,string ClsName,string MethodNme
@Return : void
@throws Exception : N/A;
*/   
    public static void LogExcpContractMsges(string msg,string ClsName,string MethodNme,String ContractId)
    {
        List<Log_Exception__e> errorMessages = new List<Log_Exception__e>();
        try{
            String errorMessage = 'Record Id : ' + ContractId + ' - ' +msg; 
            errorMessages.add(new Log_Exception__e(GA_Message__c = errorMessage,GA_ClassName__c=ClsName,GA_MethodName__c=methodNme));
            List<Database.SaveResult> results = EventBus.publish(errorMessages);
        }
        catch(exception ex)
        {
            errorMessages[0].adderror(exceLogErrMsg);
        }
    }   
}