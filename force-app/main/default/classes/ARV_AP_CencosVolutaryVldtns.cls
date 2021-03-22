/*****************************************************************************************
Class Name   : ARV_AP_CencosVolutaryVldtns. 
Date Created : 20-AUG-2020
Created By   : IDC Offshore
Description  : This is the class for validating census in enrollment process.
******************************************************************************************/
global without sharing class ARV_AP_CencosVolutaryVldtns implements vlocity_ins.VlocityOpenInterface2{ 
    private final static string METHODNAME1='getVlountaryVldnt';
    private static final string CLSNAME  ='ARV_AP_CencosVolutaryVldtns';
    private static final string METHODNAME  ='invokeMethod';   
    private final static string CONTEXTID = 'ContextId';
    private final static string VOLUNTARY ='Voluntary';
    private static boolean isCountCheck=false;
    private final static string VOLUNTARYCHECK='voluntaryCheck';
     private static boolean volCheck=false;
    /**************  
Method name : invokeMethod
Params     : map
Return Type : null
Description :invokeMethod() method 
*************/
    global Object invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output,
                               Map<String,Object> options) 
    {
        try{
            if(methodName ==METHODNAME1)
            {
                getVlountaryVldnt(input, output,options);
            }
        }catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME); }
        return true;
    }
    /*****************************************************************************************
Method Name   : getContract. 
Date Created : 23-Dec-2019
Created By   : IDC Offshore
Description  : This is the method for Cencos Voluntary validation.
******************************************************************************************/
    Public void getVlountaryVldnt(Map<String, Object> input, Map<String, Object> output, Map<String,Object> options){
        Id censusId=String.valueOf(input.get(CONTEXTID));
        List<vlocity_ins__GroupCensusMember__c> cenMemList=[SELECT Id, Name, vlocity_ins__CensusId__c,vlocity_ins__IsPrimaryMember__c, Status__c, 
                                                            ARV_Package__c,ARV_Group_Segment__c FROM vlocity_ins__GroupCensusMember__c where vlocity_ins__CensusId__c =:censusId and
                                                            vlocity_ins__IsPrimaryMember__c=true];        
        Set<Id> gsId=new set<id>();
        map<id,id> gsCem=new map<id,id>();
        if(cenMemList.size()>0){
            for(vlocity_ins__GroupCensusMember__c cem:cenMemList){
                gsId.add(cem.ARV_Package__c);
                gsCem.put(cem.ARV_Package__c,cem.Id);
            }
        }
        list<Package__c> gsList=[Select Id,Name,ARV_Dental_Plan__c,ARV_Dental_Plan__r.Voluntary_Contributory__c from Package__c where Id in:gsId];
        map<id,id> gsPck=new map<id,id>();
        if(gsList.size()>0){
            for(Package__c gsr:gsList){
                if(gsr.ARV_Dental_Plan__r.Voluntary_Contributory__c==VOLUNTARY){
                       volCheck=true;
                    gsPck.put(gsr.Id,gsr.Id);
                }  
            }
        }
        Integer finalCount=0;
        if(cenMemList.size()>0){
        for(vlocity_ins__GroupCensusMember__c pck:cenMemList){
            if(gsCem.get(gsPck.get(pck.ARV_Package__c))!=null){
                finalCount=finalCount+1;
            }
        }
        }
        if(volCheck){
        isCountCheck=finalCount<10?true:false;
        }
        output.put(VOLUNTARYCHECK,isCountCheck);
    }
}