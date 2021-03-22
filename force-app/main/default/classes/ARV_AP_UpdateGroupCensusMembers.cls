/*****************************************************************************************
Class Name   : ARV_AP_UpdateGroupCensusMembers 
Date Created : 14-10-2020
Created By   : IDC  Offshore
Description  :This is the class for contract record updation after  submitting. 
******************************************************************************************/
global without sharing class ARV_AP_UpdateGroupCensusMembers implements vlocity_ins.VlocityOpenInterface2{  
          public static final string MTHD_UPDATEGCM='updateCensusMembers';
           public static final string CENSUSID='censusId';


     private static final String CREATESYSTEMCENSUS='createSystemCensus';
   private Static Final String CLSNAME = 'ARV_AP54_EnrollmentServiceGetRated';
    private Static Final String CLS_METHODNAME = 'getPids';
        Private Static Final String ENRLMNTCONID='ContractId';
                    private static final string GROUPINFORMATION='GroupInformation';
    private static final string EFFECTIVEDATE  = 'GWCReqEffDateFormula';

 /*****************************************************************************************
Method Name   : invokeMethod 
Date Created : Oct 2020
Created By   : IDC Offshore
Description  :This is used in to call updatecensusmembers method*/
global static Boolean invokeMethod(String methodName, Map<String,Object> inputMap,Map <String, Object> outMap, 
                                 Map<String,Object> options){
           try{
                  if(MTHD_UPDATEGCM.equals(methodName)){                                                   
                    updateCensusMembers(inputMap,outMap,options);    
                    } 
             }
            catch(Exception ex){
                     
             }
             return true;
                                           
    } 
 /*****************************************************************************************
Method Name   : updateFutureConStatus 
Date Created : Oct 2020
Created By   : IDC Offshore
Description  :This method updates census members
******************************************************************************************/   
     public static void updateCensusMembers(Map<String, Object> input,Map < String, Object > output, 
                                           Map < String, Object > options){
                                               String censusRecId=(String)options.get(CENSUSID);
                                                   List<vlocity_ins__GroupCensusMember__c> updateCensusMemList=new List<vlocity_ins__GroupCensusMember__c>();
                                               List<vlocity_ins__GroupCensusMember__c> censusMemList=[Select id,ARV_External_Id__c,BNF_PKG_PLAN_PID__c,vlocity_ins__CensusId__c from vlocity_ins__GroupCensusMember__c where vlocity_ins__CensusId__c =:censusRecId limit 500]; 
                                               vlocity_ins__GroupCensusMember__c gcem=null;
                                               for(vlocity_ins__GroupCensusMember__c cem:censusMemList){
                                                   gcem=new vlocity_ins__GroupCensusMember__c();
                                                   gcem.Id=cem.Id;
                                                   gcem.ARV_External_Id__c=null;
                                                   gcem.BNF_PKG_PLAN_PID__c=null;
                                                  
                                                   updateCensusMemList.add(gcem);
                                               }
                                               if(updateCensusMemList.size()>0){
                                                   database.update(updateCensusMemList);
                                               }
                                           }
   

}