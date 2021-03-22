/**
@Author : Raj Jena
@Name: GA_WrkFlwSetPriority
@CreatedDate: 8 - June 2018 
@Description: GA_WrkFlwSetPriority class is to set Priority on Workflow record page.
@version : 1.0  
*/
public without sharing class GA_WrkFlwSetPriority {
    public static final string ClsName  ='GA_WrkFlwSetPriority';
    public static final string methodNmesetPriority  ='setPriority';
    public static final string ErrorMsg = 'Cant set Priority';
    public static final string excepSepartr = ' : ';
   public static  GA_Workflow_Priority__c wrkFlwPrity=GA_Workflow_Priority__c.getInstance();
/**
@Description: setPriority() method 
@Name : setPriority
@Param : N/A
@Return : boolean
@throws Exception : N/A
*/ 
    @AuraEnabled
    public static boolean setPriority(){ 
        
        try{
            if(wrkFlwPrity.GA_Priority__c)
            {
                return true; 
            }
            else
                return false;
        }
        
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmesetPriority);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
}