public class GA_AccOutOfBusiness {
    public static final string ClsName  ='GA_AccOutOfBusiness';
    public static final string methodNmeupdateAccountStatus  ='updateAccountStatus';
    public static final string ErrorMsg = 'Cant Change Account Status to Out of Business ';
    public static final string excepSepartr = ' : ';
    public static  GA_Workflow_Priority__c wrkFlwPrity=GA_Workflow_Priority__c.getInstance();
    
     @AuraEnabled
    public static boolean fetchOOBButtonAccess(){
        try
        {
            return GA_Trigger_Functionality_By_Pass__c.getInstance().GA_Account_OOB__c;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, 'GA_CloneGrpSegmentCls', 'fetchGroupSegmentClone');
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+': '+e.getMessage()); 
        }
    }
    
    
    
    /**
@Description: setPriority() method 
@Name : setPriority
@Param : N/A
@Return : boolean
@throws Exception : N/A
*/ 
    @AuraEnabled
    public static boolean updateAccountStatus(String accountId){ 
        
        try{
            Account acc = new Account();
            acc.Id=accountId;
            acc.Account_Status__c='Out of Business';
            acc.GA_Is_Mass_Updating__c=true;
            acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Inactive').getRecordTypeId();            
            database.update(acc);
            return true;
        }
        
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeupdateAccountStatus);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
}