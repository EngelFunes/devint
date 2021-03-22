/**
@Author : PadmaHaarika Jayana
@Name: GA_logBCBSMWSException
@CreatedDate: 20 - Jan 2018 
@Description: GA_logBCBSMWSException class is for logging CID Service related errors.
@version : 1.0  
*/
public without Sharing class GA_logBCBSMWSException extends Exception {
    
    public static final string SuccessCode='S0000';
    public static final string updtFail='Failure';
    public static final string hyphenVal='-';
    public static final string SuccssVal='Success';
    public static final string errorIntrnl='Internal Error';
    public static final string errorCidSrvc='BCBSMWebserviceFailure';
    public static final string errorIntrnlMsg='SFDC Internal Error';
    public static final string appLabel='Group Sales';
    public static final String ClsName  ='GA_logBCBSMWSException';
    public static final String methodNmelogWSError  ='logWSError';
    public static final String methodNmeupdatelogWSError  ='updatelogWSError';
    
    
    
    /**
@Description: logWSError() method 
@Name : logWSError
@Param : Map<String,String> errRespMap 
@Return : void
@throws Exception : N/A;
*/
    public static void logWSError(Map<String,String> errRespMap,String integrationService,String invokingCmp,String errResp){
        try
        {
            if(errRespMap.size() > 0){
                for (String key : errRespMap.keySet()){
                    String status = (String.ValueOf(errRespMap.get(key)).substringBefore(hyphenVal) == SuccessCode ? SuccssVal : updtFail);
                    updatelogWSError(key, status,String.ValueOf(errRespMap.get(key)).substringBefore(hyphenVal) ,String.ValueOf(errRespMap.get(key)).substringAfter(hyphenVal),integrationService,invokingCmp,errResp);
                }
            } 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmelogWSError);
        }
        
        
    }
    
    /**
@Description: updatelogWSError() method 
@Name : updatelogWSError
@Param : String accId,String status,String errCode,String errorDes
@Return : void
@throws Exception : N/A;
*/
    public static void updatelogWSError(String accId,String status,String errCode,String errorDes,String integrationService,String invokingCmp,String errResp){
        try
        {
            List<ExceptionLog__c> expLog = [Select Id,Object_ID__c,ExceptionDescription__c,WSCallingApplication__c,WSCallingArea__c,ExceptionCode__c,NumberOfTimesOccured__c,Status__c,ContextUser__c,ExceptionLogTimestamp__c from ExceptionLog__c where Object_ID__c =: accId Limit 1];
            if(expLog.size()  > 0){            
                expLog[0].Object_ID__c =accId ;
                expLog[0].ExceptionDescription__c = errorDes;
                expLog[0].ExceptionCode__c = errCode;
                if(errCode !=errorIntrnl)
                {
                    expLog[0].NumberOfTimesOccured__c = expLog[0].NumberOfTimesOccured__c + 1;
                    expLog[0].ExceptionDetails__c = errorCidSrvc;
                }
                else
                {
                    expLog[0].ExceptionDetails__c = errorIntrnlMsg;
                }
                
                expLog[0].Status__c = status;
                expLog[0].ContextUser__c = UserInfo.getUserId();
                expLog[0].ExceptionLogTimestamp__c = System.now();
                expLog[0].WSCallingApplication__c = integrationService ;
                expLog[0].WSCallingArea__c = invokingCmp ;
                expLog[0].Error_Response__c=errResp;
                Database.update(expLog);
            }
            else{
                if(status != SuccssVal){
                    ExceptionLog__c objLog = new ExceptionLog__c();
                    objLog.Object_ID__c =accId ;
                    objLog.ExceptionDescription__c = errorDes;
                    objLog.ExceptionCode__c =  errCode;
                    if(errCode !=errorIntrnl)
                    {
                        objLog.NumberOfTimesOccured__c =  1;
                        objLog.ExceptionDetails__c = errorCidSrvc;
                    }
                    else
                    {
                        objLog.ExceptionDetails__c = errorIntrnlMsg;
                    }
                    
                    objLog.Status__c = status;
                    objLog.Application__c = appLabel;
                    objLog.ContextUser__c = UserInfo.getUserId();                    
                    objLog.ExceptionLogTimestamp__c = System.now();
                    objLog.WSCallingApplication__c = integrationService ;
                    objLog.WSCallingArea__c = invokingCmp ;
                    objLog.Error_Response__c=errResp;
                    Database.insert(objLog);    
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeupdatelogWSError);
        }
        
    }
    
}