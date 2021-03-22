/**********************************************************************************************************************************
    Class Name   : ARV_CloneCensus
    Created Date : 
    Created By   : IDC Offshore
    Description  : It is used to clone Census,Census Member and GCMP.
*******************************************************************************************************************************/
Public class ARV_CloneCensus{
    
    public static final String CLASSNAME ='ARV_CloneCensus';
    public static final String SELECT_STRING ='SELECT ';
    public static final String ID='Id';
    public static final String GROUPCENMEMBER ='GroupCensusMember';
    
    @AuraEnabled
    public static String cloneGroupCensusRecord(String groupCensusrecordId,string newParentAccountId){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        String objectAPIName = 'vlocity_ins__GroupCensus__c';
        
        //String keyPrefix = groupCensusrecordId.substring(0,3);       
        //Getting the object name dynamically String accountrecordId,String newParentAccountId
        /*
for( Schema.SObjectType obj : schemaMap.Values() ){
String prefix = obj.getDescribe().getKeyPrefix();
if(prefix == keyPrefix){
objectAPIName = obj.getDescribe().getName();
break;
}
} 
*/
        
        Map<String, Schema.SObjectField> fields = schemaMap.get(objectAPIName).getDescribe().fields.getMap();
        Set<String> fieldMap = new Set<String>();
        String soqlQuery = SELECT_STRING; 
        for(Schema.SObjectField fieldRef : fields.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            if(fieldResult.createable) { //fieldResult.isUpdateable()
                fieldMap.add(fieldResult.getname());
            }
        }
        fieldMap.add(ID);    
        for (String s :fieldMap ){            
            soqlQuery +=  + s+',';          
        }
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +objectAPIName +' WHERE ID = \'' + groupCensusrecordId +'\'' ;  
        // Quering all the fields from SObject to clone
        
        System.debug(soqlQuery);
        vlocity_ins__GroupCensus__c record = Database.query(soqlQuery);        
        system.debug('record========'+record);
        vlocity_ins__GroupCensus__c  clondedParentRecordID = record.clone(false, true);
        try{             
            clondedParentRecordID.vlocity_ins__GroupId__c = newParentAccountId;
            
            insert clondedParentRecordID ; 
            //Cloning CensusMember records if Parent Records contains Censusmembers.
            
            System.debug('Cloned Census Record '+clondedParentRecordID);
            
            List< vlocity_ins__GroupCensusMember__c > gm =[select id from vlocity_ins__GroupCensusMember__c 
                                                           where vlocity_ins__CensusId__c = :groupCensusrecordId ];
            if(gm.size()>0){
                cloneGroupCensusMemberRecords(gm[0].id, clondedParentRecordID.id, groupCensusrecordId);          
                //cloneGroupCensusMemberRecords(clondedParentRecordID.id, groupCensusrecordId);          
            }
            
            return clondedParentRecordID.id ;
            
        }
        catch(Exception e){
            System.debug('Exception '+e);
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, 'cloneAnySobjet');              
            if(clondedParentRecordID.id !=null)
            {
                delete clondedParentRecordID;
            }  
            
            throw new AuraHandledException(e.getMessage());                        
        }              
    }
    
    public static void cloneGroupCensusMemberRecords(string groupMemberCensusId,string clonedCensusId, string censusId){
        List<vlocity_ins__GroupCensusMember__c> vloGMList=new List<vlocity_ins__GroupCensusMember__c>();
        Boolean isChild = False;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        String objectAPIName = 'vlocity_ins__GroupCensusMember__c';
        
        // String keyPrefix = groupMemberCensusId.substring(0,3);       
        
        //Getting the object name dynamically
        /*
for( Schema.SObjectType obj : schemaMap.Values() ){
String prefix = obj.getDescribe().getKeyPrefix();
if(prefix == keyPrefix){
objectAPIName = obj.getDescribe().getName();
break;
}
}
*/
        
        Map<String, Schema.SObjectField> fields = schemaMap.get(objectAPIName).getDescribe().fields.getMap();
        Set<String> fieldMap = new Set<String>();
        String soqlQuery = SELECT_STRING; 
        for(Schema.SObjectField fieldRef : fields.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            if(fieldResult.createable) {
                fieldMap.add(fieldResult.getname());
            }
        }
        fieldMap.add(ID);    
        for (String s :fieldMap ){            
            soqlQuery +=  + s+',';          
        }
        
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +objectAPIName +' WHERE vlocity_ins__CensusId__c = \'' + censusId +'\'' ;
        
        List<Sobject> records = Database.query(soqlQuery); 
        
        List<vlocity_ins__GroupCensusMemberPlan__c> gmp = new List<vlocity_ins__GroupCensusMemberPlan__c>();
        try{
            gmp =[select id from vlocity_ins__GroupCensusMemberPlan__c where 
                  vlocity_ins__GroupCensusMemberId__c = :groupMemberCensusId];
            
            if(gmp.size() > 0){
                isChild=true;
            }
        }
        catch(Exception e){
            System.debug('Exception '+e);
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, 'cloneAnySobjet');
            isChild=false;
        }
        
        
        try{ 
            Map<string ,Id> primarymemberMap = new Map<String, Id>();
             
                    
                
            for(Sobject srec :records){
                vlocity_ins__GroupCensusMember__c gcm = (vlocity_ins__GroupCensusMember__c)srec;
                
                if(gcm.vlocity_ins__IsPrimaryMember__c){
                    
                    Id gcmID = gcm.Id;
                    
                    vlocity_ins__GroupCensusMember__c gcmclone = gcm.clone(false, true);
                    /*if(primarymemberMap.containskey(gcmclone.vlocity_ins__PrimaryMemberIdentifier__c)){
gcmclone.vlocity_ins__RelatedCensusMemberId__c = null; //primarymemberMap.get(gcmclone.vlocity_ins__PrimaryMemberIdentifier__c);
}*/
                    
                    gcmclone.vlocity_ins__CensusId__c = clonedCensusId; 
                    System.debug(gcmclone);
                    insert gcmclone;
                    primarymemberMap.put(gcm.vlocity_ins__MemberIdentifier__c, gcmclone.id);  
                    // vlocity_ins__RelatedCensusMemberId__c replaced by vlocity_ins__MemberIdentifier__c  line uber 149 and 151
                    system.debug('groupcensusmemberafter cloned is====='+gcmclone);
                    
                    vloGMList.add(gcmclone);
                    
                    //System.debug('clondedchildID '+vloGMList);
                    if(isChild){
                        //cloneGroupCensusMemberPlanRecords(gcmclone.id ,gcmID , gmp[0].id);
                        cloneGroupCensusMemberPlanRecords(gcmclone.id ,gcmID );
                    }    
                }
            }
            for(Sobject srec :records){
                vlocity_ins__GroupCensusMember__c gcm = (vlocity_ins__GroupCensusMember__c)srec; 
                if(!gcm.vlocity_ins__IsPrimaryMember__c){ 
                    Id gcmID = gcm.Id; 
                    vlocity_ins__GroupCensusMember__c gcmclone = gcm.clone(false, true);
                    if(primarymemberMap.containskey(gcmclone.vlocity_ins__PrimaryMemberIdentifier__c)){
                        gcmclone.vlocity_ins__RelatedCensusMemberId__c = primarymemberMap.get(gcmclone.vlocity_ins__PrimaryMemberIdentifier__c);
                    }
                    gcmclone.vlocity_ins__CensusId__c = clonedCensusId; 
                    System.debug(gcmclone);
                    insert gcmclone;
                    vloGMList.add(gcmclone);
                    if(isChild){
                        cloneGroupCensusMemberPlanRecords(gcmclone.id ,gcmID );
                    }    
                }
            }
            
            // Cloning CensusMember records if Parent Records contains Censusmembers.
            System.debug('cloned child member Record '+vloGMList);
            System.debug('ChildGroup Member Size '+vloGMList.size());
            
        }
        catch(Exception e){
            System.debug('Exception '+e);
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, 'cloneAnySobjet');              
            if(vloGMList !=null)
            {
                delete vloGMList;
            }  
            
            throw new AuraHandledException(e.getMessage());                        
        }      
        
    }
    
    public static void cloneGroupCensusMemberPlanRecords(String clonedCensusGroupMemId ,String censusGroupMemId){
        
        List<vlocity_ins__GroupCensusMemberPlan__c> listGCMP = new List<vlocity_ins__GroupCensusMemberPlan__c>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        String objectAPIName = 'vlocity_ins__GroupCensusMemberPlan__c';
        
        //String keyPrefix = censusGroupMemplanId.substring(0,3);       
        
        //Getting the object name dynamically
        /*
for( Schema.SObjectType obj : schemaMap.Values() ){
String prefix = obj.getDescribe().getKeyPrefix();
if(prefix == keyPrefix){
objectAPIName = obj.getDescribe().getName();
break;
}
}
*/
        
        Map<String, Schema.SObjectField> fields = schemaMap.get(objectAPIName).getDescribe().fields.getMap();
        Set<String> fieldMap = new Set<String>();
        String soqlQuery = SELECT_STRING; 
        for(Schema.SObjectField fieldRef : fields.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            if(fieldResult.createable) {
                fieldMap.add(fieldResult.getname());
            }
        }
        
        fieldMap.add(ID);    
        for (String s :fieldMap ){            
            soqlQuery +=  + s+',';          
        }
        
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +objectAPIName +' WHERE vlocity_ins__GroupCensusMemberId__c = \'' + censusGroupMemId +'\'' ;  
        
        // Quering all the fields from SObject to clone
        List<Sobject> records = Database.query(soqlQuery);        
        
        system.debug('record========'+records);
        List<vlocity_ins__GroupCensusMemberPlan__c> sobjGCMP = new List<vlocity_ins__GroupCensusMemberPlan__c>();
        
        for(Sobject gcmp : records){
            sobjGCMP.add((vlocity_ins__GroupCensusMemberPlan__c)gcmp.clone(false, true));
            //system.debug('cloned groupmember plan rcds===='+sobjGCMP);
        }
        
        for(vlocity_ins__GroupCensusMemberPlan__c gcmprec :sobjGCMP ){
            gcmprec.vlocity_ins__GroupCensusMemberId__c = clonedCensusGroupMemId;
            listGCMP.add(gcmprec);
        }
        
        try{
            
            insert listGCMP ;
            
            system.debug('Cloned child groupcensusmemberplan '+listGCMP);
            
        }
        catch(Exception e){
            
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, 'cloneAnySobjet');              
            if(listGCMP !=null) {
                delete listGCMP;
            }            
            
            throw new AuraHandledException(e.getMessage());                        
        }              
    }
}