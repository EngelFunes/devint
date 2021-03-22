/***************************************************************************************************************
@Author : IDC Offshore
@Name: Dfund_DfundRequestTriggerHandler
@CreatedDate: 12 - December 2020
@Description: DfundRequestTriggerHandler class is for Dfund_RequestAgentName_Trigger
@version : 1.0  
**************************************************************************************************************/
public with sharing class ASC_DfundRequestTriggerHandler {
    public static final string CLSNAME  ='DfundRequestTriggerHandler';
    public static final string METHODNME  ='beforeInsert';
    /**************************************************************************************************************
    @Description        :   beforeInsert() method
    @Name               :   beforeInsert
    @Param              :   list<Dfund_Request__c> newList
    @Return             :   void
    @throws Exception   :   N/A;
    **************************************************************************************************************/ 
    public static void beforeInsert(List<Dfund_Request__c> newList)
    {
      try
      {   
        ASC_DfundUpdateDfundRequest.updateAgentOnDfundRequest(newList);
      }
       catch(exception e){
           GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
       }
    }
    /*************************************************************************************************************
    @Description        :   afterInsert() method
    @Name               :   afterInsert
    @Param              :   list<Dfund_Request__c> newList
    @Return             :   void
    @throws Exception   :   N/A;
    *************************************************************************************************************/ 
    public static void afterInsert(List<Dfund_Request__c> newList)
    {
      try
      {   
        ASC_DfundUpdateDfundRequest.updateDrctMgrSecOwnrOnDfundRequest(newList);
      }
       catch(exception e){
           GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
       }
    } 
    /**************************************************************************************************************
    @Description        :   beforeUpdate() method
    @Name               :   beforeUpdate
    @Param              :   list<Dfund_Request__c> newList,map<id,Dfund_Request__c> dfundOldMap
    @Return             :   void
    @throws Exception   :   N/A;
    **************************************************************************************************************/ 
   	public static void beforeUpdate(List<Dfund_Request__c> newList,map<id,Dfund_Request__c> dfundOldMap){
      try
      {   
        ASC_DfundUpdateDfundRequest.beforeUpdate(newList,dfundOldMap);
      }
       catch(exception e){
           GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
       }
    } 
    
    
    /**************************************************************************************************************
    @Description        :   afterUpdate() method invoke on Dfund_Request__c object after update event
    @Name               :   afterUpdate
    @Param              :   Map<id,Dfund_Request__c> dfundnewMap,map<id,Dfund_Request__c> dfundOldMap
    @Return             :   void
    @throws Exception   :   N/A;
    **************************************************************************************************************/ 
   	public static void afterUpdate(Map<Id,Dfund_Request__c> dfundnewMap,map<id,Dfund_Request__c> dfundOldMap){
        set<Id> dfCompletedIdSet = new Set<Id>();
        //process the records that need to send to helper method
        for(Dfund_Request__c dfNewObj : dfundnewMap.values()){
            if(dfundOldMap.get(dfNewObj.id)!=null && dfNewObj.Status__c != dfundOldMap.get(dfNewObj.id).Status__c && dfNewObj.Status__c.equalsIgnoreCase('Completed')){
               dfCompletedIdSet.add(dfNewObj.id);
            }
        }
        if(dfCompletedIdSet.size()>0){
            ASC_DfRSendNotificationHelper.sendNotificationToProductOwner(dfCompletedIdSet);
        }
    }
}