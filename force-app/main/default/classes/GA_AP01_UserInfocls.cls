/**
@Author : Prasant Kumar Satpathy
@Name: GA_AP01_UserInfocls
@CreatedDate: 20 - Jul 2017 
@Description: GA_AP01_UserInfocls class is viewing user name in home page.
@version : 1.0  
*/
public with sharing class GA_AP01_UserInfocls {
    
    public static final String ErrMag = 'Invalid User';
    public static final string ClsName  ='GA_AP01_UserInfocls';
    public static final string methodNme  ='getUser';
    public static string CurrentUserId=userinfo.getUserId();
        /**
@Description: ValidateException
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    public with sharing class ValidateException extends Exception {}
     /**
        @Description: getUser() method 
        @Name : getUser
        @Param : N/A
        @Return : user
        @throws Exception : N/A;
        */ 
    @AuraEnabled
    public static user getUser() { 
        try
        {
          user usr=[select id,name from user where id=:CurrentUserId limit 1];
          return usr;    
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            return null;
            //throw new ValidateException(ErrMag, e);
        }
       
    } 
    
}