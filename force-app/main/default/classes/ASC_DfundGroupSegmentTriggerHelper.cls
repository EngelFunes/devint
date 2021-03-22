/************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_DfundGroupSegmentTriggerHelper
@CreatedDate: 2-23-2020
@Description: ASC_DfundGroupSegmentTriggerHelper is to handle Request from ASC_DfundGroupSegmentTriggerHandler .
@User Story- #4514
@version : 1.0  
**********************************************************************************************************************************************/
public class ASC_DfundGroupSegmentTriggerHelper { 
    
    public static final string CLASSNAME  ='ASC_DfundGroupSegmentTriggerHelper';
    public static final string METHODNME  ='editStatusField';
    private static final String Status_Rejected = 'Rejected';
    private static final String Status_New = 'New';
    private static final String Status_Draft = 'Draft';
    
    
    static Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Dfund_Group_Segment__c.fields.getMap();
 /************************************************************************************************************************
@Name: editStatusField
@CreatedDate: 2-23-2020
@Description: Status field updates on dfund request object to draft when any field is updated on dfund group segment.
@version : 1.0  
**********************************************************************************************************************************************/
    public static void editStatusField(List<Dfund_Group_Segment__c> grpSegList, Map<Id, Dfund_Group_Segment__c> oldMap){
         
       Dfund_Request__c dfundReq = new Dfund_Request__c();       
       Map<Id,Dfund_Request__c> listOfDfundrecordsToUpdate = new Map<Id,Dfund_Request__c>();
       List<Dfund_Group_Segment__c> dfundgroupSegmentList = new List<Dfund_Group_Segment__c>();
          try{
              
       if(!grpSegList.isEmpty()){
         for(Dfund_Group_Segment__c gs : grpSegList){
             if(gs.DfundRequestStatus__c == Status_Rejected || gs.DfundRequestStatus__c == Status_New){
                
            for (String fieldName: schemaFieldMap.keySet()) { 
                
                if( (oldMap == null) || (gs.get(fieldName) != oldMap.get(gs.Id).get(fieldName)) ){                  
                   dfundgroupSegmentList.add(gs); 
                    
                }
            }
          }
        }
      }
       if(!grpSegList.isEmpty()){
         for(Dfund_Group_Segment__c gs : [Select Id,Dfund_Request_Detail__r.Dfund_Request__c from Dfund_Group_Segment__c where ID IN:dfundgroupSegmentList
                                          Limit :UTIL_SLB.retrieveQueryLimitValue()]){                                                                 
                  dfundReq.Id = gs.Dfund_Request_Detail__r.Dfund_Request__c;
                  dfundReq.Status__c = Status_Draft;
                  listOfDfundrecordsToUpdate.put(dfundReq.Id,dfundReq);                                                                         
          }
       }
       
       if(!listOfDfundrecordsToUpdate.isEmpty()){
         Database.Update(listOfDfundrecordsToUpdate.Values(),false);
     	 }
      }
          catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNME);
        }              
    }
}