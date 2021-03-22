/*****************************************************************************************
Trigger Name   : ARV_AP108_CensusMemberTriggerHandler. 
Date Created : 4-MARCH-2021
Created By   : IDC Offshore
Description  :This is the handler class for Census Member trigger.
******************************************************************************************/
 
public class ARV_AP108_CensusMemberTriggerHandler {
    public static void updateCensusMembers(List<vlocity_ins__GroupCensusMember__c> newList){
        
        Id conrecordType = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
        
        List<Contract> conList = new List<Contract>();
        List<Contract> finalconList = new List<Contract>();
        List<Id> censusIds = new List<Id>();
        List<Id> systemCensusIds = new List<Id>();
        List<vlocity_ins__GroupCensusMember__c> updatedsysCenMem = new List<vlocity_ins__GroupCensusMember__c>();
        List<vlocity_ins__GroupCensusMember__c> systemCenMem = new List<vlocity_ins__GroupCensusMember__c>();
        
        Map<String, vlocity_ins__GroupCensusMember__c> nameCenMemMap = new Map<String,vlocity_ins__GroupCensusMember__c>();
        
        for(vlocity_ins__GroupCensusMember__c cenMem : newList){
            if(cenMem.ARV_Enrollment_Census_Flag__c){
                 censusIds.add(cenMem.vlocity_ins__CensusId__c);
                nameCenMemMap.put(cenMem.Name, cenMem);   
            }
        }
        
        if(censusIds!=null && !censusIds.isEmpty()){
            conList = [select id,vlocity_ins__EnrollmentCensusId__c,ARV_TECH_Is_Census_Updated__c, vlocity_ins__FinalRatingGroupCensusId__c from Contract where vlocity_ins__EnrollmentCensusId__c IN:censusIds AND RecordTypeId =:conrecordType];
        }
        if(conList != null && !conList.isEmpty()){
            for(Contract con: conList){
                con.ARV_TECH_Is_Census_Updated__c = true;
                finalconList.add(con);
                //systemCensusIds.add(con.vlocity_ins__FinalRatingGroupCensusId__c);
            }
            if(conList != null && !conList.isEmpty()){
                //system.debug('finalList'+updatedsysCenMem);
                database.update(finalconList);
            }
            
            /*if(systemCensusIds != null && !systemCensusIds.isEmpty()){
                systemCenMem = [select id, Name, ARV_External_Id__c, BNF_PKG_PLAN_PID__c from vlocity_ins__GroupCensusMember__c where vlocity_ins__CensusId__c IN:systemCensusIds];
            }
            if(systemCenMem != null && !systemCenMem.isEmpty() && nameCenMemMap != null && !nameCenMemMap.isEmpty()){
                for(vlocity_ins__GroupCensusMember__c cenMember : systemCenMem){
                    //system.debug('nameCenMemMap'+nameCenMemMap);
                    //system.debug('nameCenMemMap.get(cenMember.Name)'+nameCenMemMap.get(cenMember.Name));
                    //system.debug('nameCenMemMap.get(cenMember.Name).Name)'+nameCenMemMap.get(cenMember.Name).Name);
                    //system.debug('cenMember.Name'+cenMember.Name);
                    if(nameCenMemMap.get(cenMember.Name) != null){
                        if(cenMember.Name.equals(nameCenMemMap.get(cenMember.Name).Name)){
                            cenMember.ARV_External_Id__c = nameCenMemMap.get(cenMember.Name).ARV_External_Id__c;
                            cenMember.BNF_PKG_PLAN_PID__c = nameCenMemMap.get(cenMember.Name).BNF_PKG_PLAN_PID__c;
                            updatedsysCenMem.add(cenMember);
                        }
                        
                    }
                }
            }
            
            if(updatedsysCenMem != null && !updatedsysCenMem.isEmpty()){
                system.debug('finalList'+updatedsysCenMem);
                database.update(updatedsysCenMem);
            }*/
        }      
    }
}