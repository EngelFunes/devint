/**
@Author : Prasant Kumar Satpathy
@Name: GA_AP_SubmitSupprtCls
@CreatedDate:  10- Aug 2018 
@Description: GA_AP_SubmitSupprtCls class is to submit case Support to ASR
@version : 1.0  
*/
public class GA_AP_SubmitSupprtCls {
    public static string SuccssMsg='Support request successfully submitted';
    public static string ErrMsg='Unable to Submit Support request';
    public static string ErrMsgShwAlrt='Something went wrong. Please contact your System Admin';
    public static string ClsName='GA_AP_SubmitSupprtCls';
    public static string methNmeUpdtSuprt='updateSupprt';
    public static string methNmeShowAlrt='ShowAlrt';
    @AuraEnabled
    public static string updateSupprt(string supprtId)
    {
        try
        {
            case cs=new case();
            cs.Id=supprtId;
            cs.GA_Submit_to_Support__c=true;
            cs.Status = 'Submitted';
            cs.submitter__c= userinfo.getFirstName() + ' ' + userinfo.getLastName();
            database.update(cs);
            return SuccssMsg;
        }
        catch(exception e)
        {
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methNmeUpdtSuprt);
            throw new AuraHandledException(ErrMsg); 
        }
        
        
    }
    @AuraEnabled
    public static boolean ShowAlrt()
    {
        try
        {
            GA_Trigger_Functionality_By_Pass__c bypssErr=GA_Trigger_Functionality_By_Pass__c.getInstance();
            if(bypssErr.GA_Support_Request_Alert__c)
            {
                return true;
            }
            else
                return false; 
        }
        catch(exception e)
        {
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methNmeShowAlrt);
            throw new AuraHandledException(ErrMsgShwAlrt); 
        }
    }
}