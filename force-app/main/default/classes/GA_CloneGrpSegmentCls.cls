/**
@Author : Mida Komal
@Name: GA_CloneGrpSegmentCls
@CreatedDate: 19 - April 2019
@version : 1.0  
*/
public class GA_CloneGrpSegmentCls { 
 	public Static Final String CLSNAME  = 'GA_CloneGrpSegmentCls';
    public static boolean isExecuting=false;
    public static  Boolean  cloneChildExecuting=false;
/*
@Description: cloneAnySobjet() method 
@Name : gSgmtLst
@Param : string currentId
@Return : List<GA_Group_Segment__c>
@throws Exception : ValidateException;
*/ 
    @AuraEnabled
    public static String cloneAnySobjet(String recordId){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        String objectAPIName = '';
        String keyPrefix = recordId.substring(0,3);
        //Fetching the lsit of values to be excluded while cloning from custom metadata.
        Map<String, String> fetchGrpSegCloneExclusionMap = fetchGrpSegCloneExclusionMap();
        //Getting the object name dynamically
        for( Schema.SObjectType obj : schemaMap.Values() ){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix == keyPrefix){
                objectAPIName = obj.getDescribe().getName();
                break;
            }
        }
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();
        String soqlQuery = 'SELECT ' ; 
        for (String s :fieldMap ){
            //if(schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap().get(s).getDescribe().isAccessible()){
            if(!fetchGrpSegCloneExclusionMap.containsKey(s))
            {
                soqlQuery +=  + s+',';
            }            
            //}
        }
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +objectAPIName +' WHERE ID = \'' + recordId +'\'' ;  
        // Quering all the fields from SObject to clone
        SObject record = Database.query(soqlQuery); 
        system.debug('GA_CloneGrpSegmentCls: '+soqlQuery);
        system.debug('GA_CloneGrpSegmentCls: '+record);
        record.put(Schema.GA_Group_Segment__c.Status__c, 'Pending');    
        record.put(Schema.GA_Group_Segment__c.GA_Is_Mass_Updating__c, True);
        record.put(Schema.GA_Group_Segment__c.GA_Prevs_RecordID__c, recordId+'_Clone');
        
        SObject clondedParentRecordID= record.clone(false, true);
        //system.debug('All values in record ' + record);
        try{
            insert clondedParentRecordID ;   
            // Cloning DC Small Group History records if Parent Records contain suite value
            if(!fetchGrpSegCloneExclusionMap.containsKey('ga_suite__c'))
            {
                cloneChildRecords('GA_DC_Small_Grp_History__c',recordId,clondedParentRecordID.id,'GA_Group_Segment_Id__c','GA_Suite_End_Date__c');
            }
           /*** Cloning Third Party Biller History records if Parent Records contain biller account value - Removed US-2422 ***/
           // if(!fetchGrpSegCloneExclusionMap.containsKey('ga_third_party_biller_account__c'))
           // {
           //     cloneChildRecords('GA_Third_Party_Biller_History__c',recordId,clondedParentRecordID.id,'GA_Group_Segment_Id__c','GA_TPB_End_Date__c');   
           // }
           /**** Cloning GA Group Assocaition records if Parent Records contain assocaition id value - Removed US-2422 ***/
           // if(!fetchGrpSegCloneExclusionMap.containsKey('ga_association_id__c'))
           // {
           //      cloneChildRecords('GA_Group_Association__c',recordId,clondedParentRecordID.id,'GA_Group_Segment__c','GA_End_Date__c');  
           // }
           /*** Cloning Managing History records if Parent Records contain biller account value - Removed US-2917 ***/
            
           //  if(!fetchGrpSegCloneExclusionMap.containsKey('ga_managing_agency_history_id__c'))
           // {
           //      cloneChildRecords('GA_Managing_Agency_History__c',recordId,clondedParentRecordID.id,'GA_Group_Segment__c','GA_End_Date__c');  
           // }
            cloneAORGSChildRecords('GA_AOR_Group_Segment__c', recordId, clondedParentRecordID, 'GA_Group_Segment_Id__c');
            //System.debug('clondedRecordUniqueID '+clondedParentRecordID.id);
            return clondedParentRecordID.id ;
            
        }catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, 'cloneAnySobjet', 'cloneAnySobjet');
            System.debug('ExceptionCloneGP'+e);
            return '' ;             
        }        
    }    
    
    //Fetching the lsit of values to be excluded while cloning from custom metadata.
    public static Map<String, String> fetchGrpSegCloneExclusionMap()
    {
        list<GA_Case_Clone_Exclusion_List__mdt> grpSegExclusionList=[select id,Field_API_Name__c from GA_Case_Clone_Exclusion_List__mdt];
        Map<String, String> grpSegExlusionMap =  new Map <String, String>();
        if(grpSegExclusionList.size()>0)
        {
            for(integer i=0;i<grpSegExclusionList.size();i++)
            {
                String fieldValue=grpSegExclusionList[i].Field_API_Name__c;
                grpSegExlusionMap.put(fieldValue.toLowerCase(),fieldValue.toLowerCase());
            }            
        }
        return grpSegExlusionMap;
    }
    
          /**
@Description: fetchGroupSegmentClone() method 
@Name : fetchGroupSegmentClone
@Param :null
@Return : GA_Trigger_Functionality_By_Pass__c
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static boolean fetchGroupSegmentClone(){
        try
        {
            return GA_Trigger_Functionality_By_Pass__c.getInstance().GA_Group_Segment_Custom_Clone__c;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, 'GA_CloneGrpSegmentCls', 'fetchGroupSegmentClone');
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+': '+e.getMessage()); 
        }
    }
    
              /**
@Description: Cloning Group Segment Child records method 
@Name : cloneChildRecords
@Param :null
@Return : void
@throws Exception : AuraHandledException;
*/      
    public static void cloneChildRecords(String objectAPIName, string recordId, string clonedRecordId, string groupSegmentId,String endDate)
    {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        cloneChildExecuting=true;
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();
        String soqlQuery = 'SELECT ' ; 
        for (String s :fieldMap ){           
            soqlQuery +=  + s+',';          
        }
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +objectAPIName +' WHERE '+endDate+' > Today AND '+groupSegmentId+' = \'' + recordId +'\'' ;      
        List<sObject> record = Database.query(soqlQuery);     
        List<SObject> lstOfSObjectToBeInserted = new List<SObject>();
        for (sObject eachRec : record) {
            eachRec.put(groupSegmentId, clonedRecordId);
            //system.debug('Individual CHILD RECORD ' +eachRec);            
            SObject clondedChildRecordID= eachRec.clone(false, true);
            
            lstOfSObjectToBeInserted.add(clondedChildRecordID);           
        }
        try{
                insert lstOfSObjectToBeInserted ;           
            }catch(Exception e){
                System.debug('ExceptionCloneChildRecGP'+e); 
                 GA_LogExceptionCls.LogExcp(e, 'GA_CloneGrpSegmentCls', 'cloneChildRecords');
            } 
    }
    
    public static void cloneAORGSChildRecords(String objectAPIName, string recordId, SObject clonedRecord, string groupSegmentId)
    {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();
        String soqlQuery = 'SELECT ' ; 
        for (String s :fieldMap ){           
            soqlQuery +=  + s+',';          
        }
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +objectAPIName +' WHERE GA_Cancel_Flag__c = FALSE AND '+groupSegmentId+' = \'' + recordId +'\'' ; 
        soqlQuery +=' AND ((GA_AOR_Id__r.GA_Service_End_Date__c >Today AND GA_AOR_Id__r.GA_Commission_End_Date__c >Today) OR (GA_AOR_Id__r.GA_Service_End_Date__c >Today AND GA_AOR_Id__r.GA_Commissioning_Agent__c = False) OR (GA_AOR_Id__r.GA_Servicing_Agent__c =False AND GA_AOR_Id__r.GA_Commission_End_Date__c >Today))';
        List<sObject> record = Database.query(soqlQuery);     
        List<SObject> lstOfSObjectToBeInserted = new List<SObject>();
          system.debug('AOR GS RECORD ' +record);
        for (sObject eachRec : record) {
            eachRec.put(groupSegmentId, clonedRecord.get('Id'));
            eachRec.put('GA_Cancel_Date__c', null);
            eachRec.put('GA_Cancel_Flag__c', False);
            eachRec.put('OwnerId', UserInfo.getUserId());                                  
            SObject clondedChildRecordID= eachRec.clone(false, true);
            system.debug('Individual AOR GS RECORD ID ' +eachRec);  
            lstOfSObjectToBeInserted.add(clondedChildRecordID);           
        }
        try{
                insert lstOfSObjectToBeInserted ;           
            }catch(Exception e){
                System.debug('ExceptionCloneChildRecGP'+e);  
                 GA_LogExceptionCls.LogExcp(e, 'GA_CloneGrpSegmentCls', 'cloneAORGSChildRecords');
            } 
    }   
    
}