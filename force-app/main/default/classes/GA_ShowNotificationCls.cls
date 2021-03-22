/**
@Author : Prasant
@Name: GA_ShowNotificationCls
@CreatedDate: 6/27/2018 
@Description: GA_ShowNotificationCls class is for showing notifications.
@version : 1.0  
*/
public with sharing class GA_ShowNotificationCls {
    /**
@Description: getSessionId() method 
@Name : getSessionId
@Param : N/A  
@Return : String
@throws Exception : N/A;
*/  
    @AuraEnabled
    public static String getSessionId() {
       return UserInfo.getSessionId();
    }
    
}