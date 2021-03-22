/*****************************************************************************************
Class Name   : GA_LocalUnionTriggerHandler
Date Created : 4/18/2018
Created By   : IDC Offshore
Description  : 1. This handler class is for Create/Update  GA_Union_Representation__c objects

Change History : 
******************************************************************************************/
public class GA_LocalUnionTriggerHandler {
    public static final GA_Profile_ByPass__c profBypass = GA_Profile_ByPass__c.getInstance();
    public static final String ClsName  ='GA_LocalUnionTriggerHandler';
    public static final String methodNmebeforeinsert  ='beforeInsert';
     /****************************************************************************************************
Method Name : beforeInsert
Parameters  : list<GA_Union_Representation__c> lclUnList
Return type : NA
Description : beforeInsert event handler
******************************************************************************************************/
    public static void beforeInsert(list<GA_Union_Representation__c> lclUnList)
    {
        try
        {   
            if(!profBypass.Bypass__c){
                if(!GA_LocalUnionServiceCls.isExecuting)
                {
                    GA_LocalUnionServiceCls.isExecuting=true;
                    GA_LocalUnionServiceCls.unionReprsntatn(lclUnList);  
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmebeforeinsert);
            lclUnList[0].adderror(e);
        }
    }
}