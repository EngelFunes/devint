/*****************************************************************************************
Class Name   : ARV_AP70_CountofLocationSegments. 
Date Created : 07-01-2020
Created By   : IDC Offshore
Description  : This is the class for validateContract in enrollment process.
******************************************************************************************/
global without sharing class ARV_AP70_CountofLocationSegments implements vlocity_ins.VlocityOpenInterface{
    private static final string CONTRACTID='ContextId';
    
    
    global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options) 
    {           
        Boolean success = true;
        try{
            if (methodName == METHODNAME) 
            {
               locationSegementCount(input,output,options);
            }
        }catch(Exception e){
            success = false;
        }
        return success;
    }
    private static void locationSegementCount(Map<String,Object> input, Map<String,Object> output, Map<String,Object> options){
        string contId=string.valueOf(input.get(CONTRACTID));
        integer count;
        //Set<Id> pckgId = new Set<Id>();
		Set<Id> locations = new Set<Id>();
		contract cont=[select id,vlocity_ins__EnrollmentCensusId__c from contract where id=:contId];
		string censusId=cont.vlocity_ins__EnrollmentCensusId__c;
		system.debug('CensusId:: '+censusId);
        for(vlocity_ins__GroupCensusMember__c mem: [select id,ARV_Package__c,ARV_LocationPackage__c,
                                                    ARV_Package__r.ARV_Contains_BCN_HRA__c                                                    
                                                    from vlocity_ins__GroupCensusMember__c where 
                                                    vlocity_ins__CensusId__c =: censusId AND status__c='ENROLLING' AND 
                                                    vlocity_ins__IsPrimaryMember__c=true]){
            //pckgId.add(mem.ARV_Package__c);			                                          
            if(mem.ARV_Package__c != null && mem.ARV_Package__r.ARV_Contains_BCN_HRA__c){
               locations.add(mem.ARV_LocationPackage__c); 
            }                      
        }
        system.debug('locationCounttttt:: '+locations.size());
		//system.debug('Package Id::: '+pckgId);		
		count=locations.size();
        /*for(Package_Location_Segment_Rel__c plsr:[select id,Location_Segment__c from Package_Location_Segment_Rel__c where  Package__c IN:pckgId AND Contract__c=:contId AND Package__r.ARV_Contains_BCN_HRA__c = true]){
    		locations.add(plsr.Location_Segment__c);
        }
		system.debug('Locations:: '+locations);
        if(locations.size()>0){
            count=locations.size();
            system.debug('locationCount:: '+count);
        }*/
        output.put('locationCount',count);
    }

}