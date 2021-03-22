/************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_DfundGroupSegmentTriggerHandler
@CreatedDate: 2-23-2020
@Description: ASC_DfundGroupSegmentTriggerHandler class is for ASC_DfundRequestDetailTrigger
@version : 1.0  
**********************************************************************************************************************************************/
public with sharing class ASC_DfundGroupSegmentTriggerHandler {
    public static final string CLSNAME  ='ASC_DfundGroupSegmentTriggerHandler';
    public static final string METHODNME  ='afterUpdate';
  
    
/*******************************************************************************************************************************
@Description        :   afterUpdate() method
@Name               :   afterUpdate
@Param              :   List<Dfund_Group_Segment__c> newList,map<id,Dfund_Group_Segment__c> dfundOldMap
@Return             :   void
********************************************************************************************************************************/ 
   public static void afterUpdate(List<Dfund_Group_Segment__c> newList,map<id,Dfund_Group_Segment__c> dfundOldMap){
      
      try
      {   
        ASC_DfundGroupSegmentTriggerHelper.editStatusField(newList,dfundOldMap);
          
      }
       catch(exception e){
           GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
       }
        
    } 

}