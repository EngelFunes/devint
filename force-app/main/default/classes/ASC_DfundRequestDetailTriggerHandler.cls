/************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_DfundRequestDetailTriggerHandler
@CreatedDate: 2-23-2020
@Description: ASC_DfundRequestDetailTriggerHandler class is for ASC_DfundRequestDetailTrigger
@version : 1.0  
**********************************************************************************************************************************************/
public with sharing class ASC_DfundRequestDetailTriggerHandler {
    public static final string CLSNAME  ='ASC_DfundRequestDetailTriggerHandler';
    public static final string METHODNME  ='afterUpdate';
   public static final string METHODNME1  ='beforeUpdate';
    
/*******************************************************************************************************************************
@Description        :   afterUpdate() method
@Name               :   afterUpdate
@Param              :   List<Dfund_Request_Detail__c> newList,map<id,Dfund_Request_Detail__c> dfundOldMap
@Return             :   void
********************************************************************************************************************************/ 
   public static void afterUpdate(List<Dfund_Request_Detail__c> newList,map<id,Dfund_Request_Detail__c> dfundOldMap){
      
      try
      {   
        ASC_DfundRequestDetailTriggerHelper.editStatusField(newList,dfundOldMap);
          
      }
       catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);}
     
    } 
    /*******************************************************************************************************************************
@Description        :   beforeUpdate() method
@Name               :   beforeUpdate
@Param              :   List<Dfund_Request_Detail__c> newList,map<id,Dfund_Request_Detail__c> dfundOldMap
@Return             :   void
********************************************************************************************************************************/ 
 public static void beforeUpdate(List<Dfund_Request_Detail__c> newList,map<id,Dfund_Request_Detail__c> dfundOldMap){
      
      try
      {   
        ASC_DfundRequestDetailTriggerHelper.editField(newList,dfundOldMap);
          
      }
       catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1);}
        
    } 
}