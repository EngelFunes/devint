/**
@Author : Prasant
@Name: GA_Group_Support_RqstTriggerHndlr
@CreatedDate: 6/20/2018 
@Description: GA_Group_Support_RqstTriggerHndlr class is for Group Support Request object.
@version : 1.0  
*/
public without sharing class GA_Group_Support_RqstTriggerHndlr {
    public static final string ClsName  ='GA_Group_Support_RqstTriggerHndlr';
    public static final string methodName  ='beforeInsert';
    public static final string methodName1  ='beforeUpdate';
    /**
@Description: beforeInsert() method 
@Name : beforeInsert
@Param : list<GA_Group_Support_Request__c> grpRlnshipLst  
@Return : void
@throws Exception : N/A;
*/      
    public static void beforeInsert(list<GA_Group_Support_Request__c> grpRlnshipLst)
    {
        try{
            GA_Group_Support_RqstSrvcCls.prepopulateName(grpRlnshipLst,null);
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName);
        }
    }
    /**
@Description: beforeUpdate() method 
@Name : beforeUpdate
@Param : list<GA_Group_Support_Request__c> grpRlnshipLst,map<id,GA_Group_Support_Request__c> grpRlnshipOldMp  
@Return : void
@throws Exception : N/A;
*/      
    public static void beforeUpdate(list<GA_Group_Support_Request__c> grpRlnshipLst,map<id,GA_Group_Support_Request__c> grpRlnshipOldMp)
    {
        try{
            GA_Group_Support_RqstSrvcCls.prepopulateName(grpRlnshipLst,grpRlnshipOldMp);
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName1);
        }
        
    }
}