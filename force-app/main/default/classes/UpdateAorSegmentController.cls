public class UpdateAorSegmentController {

    public static void updateAorSegment(List<GA_Group_Segment__c> gsLst){
        Id accId;
        Set<Id> segmentIds = new Set<Id>();
        Set<Id> aorIds = new Set<Id>();
        List<GA_AOR_Group_Segment__c> aorGroupSegmentList = new List<GA_AOR_Group_Segment__c>();
        Map<String,GA_AOR__c> newAorRecordMap = new Map<String,GA_AOR__c>(); 
        Map<String,List<GA_AOR_Group_Segment__c>> aorGroupSegmentMap = new Map<String,List<GA_AOR_Group_Segment__c>>();
        
        for(GA_Group_Segment__c segment : gsLst){
            system.debug('--segment---'+segment.name);
            segmentIds.add(segment.Id);
            accId = segment.GA_Account__c;
        }
        system.debug('--segmentIds---'+segmentIds);
        for(GA_AOR_Group_Segment__c aorSegment : [select id,GA_AOR_Id__c, GA_Group_Segment_Id__c  from GA_AOR_Group_Segment__c where GA_Group_Segment_Id__c in: segmentIds]){
            
            if(aorGroupSegmentMap.containsKey(aorSegment.GA_AOR_Id__c)){
                aorGroupSegmentMap.get(aorSegment.GA_AOR_Id__c).add(aorSegment);
            }else{
                aorGroupSegmentMap.put(aorSegment.GA_AOR_Id__c, new List<GA_AOR_Group_Segment__c>{aorSegment});
            }
            
            aorIds.add(aorSegment.GA_AOR_Id__c);
            //aorGroupSegmentmap.put(aorSegment.GA_AOR_Id__c + '-' + aorSegment.GA_Group_Segment_Id__c, aorSegment);
        }       
        System.debug('---aorGroupSegmentMap---'+aorGroupSegmentMap.size());
        System.debug('---aorGroupSegmentMap---'+aorGroupSegmentMap);
        
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get('GA_AOR__c').getDescribe().Fields.getMap();
        List<String> fields = new List<String>();
        
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    fields.add(fd.getName()); 
                }
            }
        }
        System.debug('---aorIds---'+aorIds);
        String queryString = 'SELECT id, ' + String.join(fields, ',') +' FROM GA_AOR__c where id in :aorIds'; 
        system.debug('---queryString--'+queryString);
        
        for(GA_AOR__c aor : database.query(queryString)){
            GA_AOR__c cloneAor = aor.clone(false,true);
            cloneAor.GA_Account_Id__c = accId;
            newAorRecordMap.put(aor.Id,cloneAor);
        }
        System.debug('---newAorRecordMap---'+newAorRecordMap);
        if(newAorRecordMap.size() > 0){
            insert newAorRecordMap.values();
        }
        
        for(String key : newAorRecordMap.keySet()){
            if(aorGroupSegmentMap.containsKey(Key)){
                for(GA_AOR_Group_Segment__c tempAorGrpSeg : aorGroupSegmentMap.get(key)){
                    tempAorGrpSeg.GA_AOR_Id__c = newAorRecordMap.get(Key).Id;
                    aorGroupSegmentList.add(tempAorGrpSeg);                    
                }
            }
        }
        
        System.debug('---aorGroupSegmentList---'+aorGroupSegmentList);
        if(aorGroupSegmentList.size() > 0 ){
            update aorGroupSegmentList;
        }
        
    }
}