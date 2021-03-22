/*****************************************************************************************************************************************************
@Author : Dinesh P
@Name: ASC_DfundUpdateDfundRequest
@CreatedDate:  10-Dec-2020 
@Description: ASC_DfundUpdateDfundRequest is used to handle request for Dfund related approval process.

@version : 1.0  
@US Number: US-4288 ,US-4287, US-4289 ,US-4101, US-4100,US-4514

*/

public class ASC_DfundUpdateDfundRequest {
    
    static Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Dfund_Request__c.fields.getMap();
    static Map<String, Dfund_Request__c> queriedFieldValues = new Map<String, Dfund_Request__c>();
   

    private static final String Status_Rejected = 'Rejected';
    private static final String Status_New = 'New';
    private static final String Status_Draft = 'Draft';
	 private static final String Statusfield = 'Status__c';
    
    public static void updateAgentOnDfundRequest(List<Dfund_Request__c> newList){
         
        Map<Id,Dfund_Request__c> accDfundReqMap = new Map<Id,Dfund_Request__c>();
        Map<Id,Id> aorMap = new Map<Id,Id>();
        Map<Id,String> accAgentMap = new Map<Id,String>();
        Set<Id> aoraccIdSet = new Set<Id>();
        Map<Id,GA_AOR__c> aorGrpSegMap = new Map<Id,GA_AOR__c>();
        
        //Fetcing the Account Id for the related Dfund Requests.
        
      try{
           
            // Assign Contact Id from Aor Record to the Dfund request related to a particular Account.
            
            if(!newList.isEmpty()){
                for(Dfund_Request__c dfReqRec: newList){
                    
                 // dfReqRec.Servicing_Agent__c = aorMap.ContainsKey(dfReqRec.Account__c) && aorMap.get(dfReqRec.Account__c) !=null?aorMap.get(dfReqRec.Account__c):null;                
                  dfReqRec.Director__c = dfReqRec.Dfund_Regional_Director__c;
                  dfReqRec.Segment_Owner__c = dfReqRec.Dfund_Segment_Owner__c;
                  
                  System.debug('************####'+dfReqRec.Dfund_Segment_Owner__c);
                  dfReqRec.Manager__c = dfReqRec.Dfund_Sales_Office_Manager__c;
                }
            }
            
            

        }
        catch(Exception e){
            
        }
    	}
    
    public static void updateDrctMgrSecOwnrOnDfundRequest(List<Dfund_Request__c> newList){  
    
             List<Dfund_Request__c> recordsToUpdate = new List<Dfund_Request__c>();         
             List<Dfund_Request__c> dfundlistofOwners =[Select id,Dfund_Regional_Director__c,Dfund_Segment_Owner__c, Dfund_Sales_Office_Manager__c,Underwriter__c,ASC_Underwriter_Approval__c,Account__r.GA_Underwriting__c from Dfund_Request__c where id in: newList];
                          
             for(Dfund_Request__c dfReqRec: dfundlistofOwners){
             
                  dfReqRec.Director__c = dfReqRec.Dfund_Regional_Director__c;
                  dfReqRec.Segment_Owner__c = dfReqRec.Dfund_Segment_Owner__c;                  
                  dfReqRec.Manager__c = dfReqRec.Dfund_Sales_Office_Manager__c;
                  dfReqRec.ASC_Underwriter_Approval__c =dfReqRec.Account__r.GA_Underwriting__c;
                  recordsToUpdate.add(dfReqRec);
             }             
             
             if(!recordsToUpdate.isEmpty()){
               Database.Update(recordsToUpdate,false);
             }
    }
    
    public static void beforeUpdate(List<Dfund_Request__c> newList,map<id,Dfund_Request__c> dfundOldMap){  
        
             List<Dfund_Request__c> recordsToUpdate = new List<Dfund_Request__c>();         
             //List<Dfund_Request__c> dfundlistofOwners =[Select id,Dfund_Regional_Director__c,Dfund_Segment_Owner__c, Dfund_Sales_Office_Manager__c,Underwriter__c,ASC_Underwriter_Approval__c,Account__r.GA_Underwriting__c from Dfund_Request__c where id in: newList];
             // newList           
             
             Map<String,String> uwIdMap = new Map<String,String>();
             List<Dfund_Request__c> dfundReqList = [Select Id,Account__r.GA_Underwriting__c from Dfund_Request__c where Id IN:newList];  
        	
        
        	for(Dfund_Request__c obj : newList){
             if(obj.Status__c == Status_New||obj.Status__c ==Status_Rejected){
            for (String fieldName: schemaFieldMap.keySet()) {
                
                    
                if((obj.get(fieldName) != dfundOldMap.get(obj.Id).get(fieldName))&& fieldName != Statusfield ){
                
                   
              	obj.put(Statusfield,Status_Draft);
                   
                }
                    
            }
        
    
		  }
        }
        
             for(Dfund_Request__c dfReqRec: dfundReqList){
               uwIdMap.put(dfReqRec.Id,dfReqRec.Account__r.GA_Underwriting__c);             
             }
        
    
             for(Dfund_Request__c dfReqRec: newList){
             
                  Dfund_Request__c oldDfund = dfundOldMap.get(dfReqRec.Id);
                  
                  dfReqRec.Director__c = dfReqRec.Dfund_Regional_Director__c;
                  dfReqRec.Segment_Owner__c = dfReqRec.Dfund_Segment_Owner__c;                  
                  dfReqRec.Manager__c = dfReqRec.Dfund_Sales_Office_Manager__c;
                  dfReqRec.ASC_Underwriter_Approval__c = uwIdMap.get(dfReqRec.Id);  //dfReqRec.Account__r.GA_Underwriting__c;
                   
                  if(String.isNotBlank(dfReqRec.Status_Text__c) && oldDfund.Status_Text__c !=dfReqRec.Status_Text__c){                     
                  dfReqRec.Status__c = dfReqRec.Status_Text__c;
                     
                  }
                 
             }             
             
             if(!recordsToUpdate.isEmpty()){
               //Database.Update(recordsToUpdate,false);
             }
        
       
       
        
    }
}