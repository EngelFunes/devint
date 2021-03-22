/*****************************************************************************************
Class Name   : ARV_AP54_EnrollmentServiceGetRated 
Date Created : 18-Nov-2019
Created By   : IDC Offshore
Description  : --
******************************************************************************************/
global with sharing class ARV_AP54_EnrollmentServiceGetRated implements vlocity_ins.VlocityOpenInterface2 {
    Private Static Final String CENSUSID = 'censusId';
    Private Static Final String EFFECTIVEDATEFORMAT = 'EffectiveDateFormat';
    Private Static Final String ZIPCODESTR = 'Zipcode';    
    Private Static Final String ZIPCODEBLOCK = 'ZipcodeBlock';
    Private Static Final String NWACNTDTLS = 'NewAccountDetails';
    Private Static Final String ENROLLING='Enrolling';
    Private Static Final String GETPIDS='getPids';
    Private Static Final String DELETEGCMP='deleteGCMP';
    Private Static Final String ENRLMNTCONID='ContractId';
    Private Static Final String ENRLMNTCENSUSID='enrollmentCensusId';
    Private Static Final String QUOTINGUSERINPUTS='Quoting_UserInputs';
    Private Static Final String IPUSERINPUTS= 'userInputs';
    Private Static Final String SGCENSUS= 'SG-Census-RF.Id';
    Private Static Final String FILTERS= 'filters';
    Private Static Final String FILTERID= 'Id:';
    Private Static Final String FINALCOUNTY= 'FinalCountyName';
    Private Static Final String PREMIUM= 'Premium';
    Private Static Final String EFFECTIVEDATE= 'effectiveDate';
    Private Static Final String RAWPRICEDATA= 'RawPriceData';
    Private Static Final String CALCRESULTS= 'calculationResults';
    Private Static Final String GETRATED= 'Enrollment_GetRated';
    Private Static Final String RECORDS= 'records';
    Private Static Final String STRINGA= 'a';
    Private Static Final String STRINGID= 'Id';
    Private Static Final String UNDERSCORE= '_';
    Private Static Final String EFFCTVDATEUTC= 'yyyy-MM-dd\'T\'HH:mm:ss.SSSZ';
    Private Static Final String RECORDSDLTD= 'Records Deleted';
    private static Final String efESTDateFORMAT = 'T23:00:00.000+0000';
    private static String contractId;
    private static String cnty;
    private static String efESTDate;    
    private static date effdat;
    private static date renDate;
    private static String hqZipValue;
    private Static Final String CLSNAME = 'ARV_AP54_EnrollmentServiceGetRated';
    private Static Final String CLS_METHODNAME = 'getPids';
    @TestVisible private static Map<String, Object> ipOutput = new Map<String, Object>();
    @TestVisible private static Map<String, Object> ipOutputGRP = new Map<String, Object>();

    /*************************************************************************************************************  
Method name : updateCensusCountPremium
Params     : NA
Return Type : null
Description :updateCensusCountPremium() method update count employees and Premiums in realtionship object.
***********************************************************************************************************/     
    global static Boolean invokeMethod(String methodName, Map <String, Object> inputMap,Map < String, Object > outMap, 
                                Map < String, Object > options) {
        try{
            if(GETPIDS.equals(methodName)){
                getPids(inputMap,outMap,options);    
            }                
            else if(DELETEGCMP.equals(methodName)){
                deleteGCMP(inputMap,outMap,options);    
            }
            else{}    
           
        }catch(Exception e){
            system.debug('exception');
           // throw new AuraHandledException(+e.getMessage());
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CLS_METHODNAME, contractId);
        }
        return true;   
    }
    /*************************************************************************************************************  
Method name : updateCensusCountPremium
Params     : NA
Return Type : null
Description :updateCensusCountPremium() method update count employees and Premiums in realtionship object.
***********************************************************************************************************/     
    public static Boolean deleteGCMP(Map < String, Object > inputMap,Map < String, Object > outMap, 
                                      Map < String, Object > options) {
        try{
        contractId=(String)inputMap.get(ENRLMNTCONID);
        String enrollmentCensusId=(String)inputMap.get(ENRLMNTCENSUSID);        
       
        /*List<vlocity_ins__ContractLineItem__c> contractLineItems=[SELECT id, vlocity_ins__Product2Id__c from
                                                                  vlocity_ins__ContractLineItem__c where 
                                                                  vlocity_ins__ContractId__c =:contractId limit 100];*/
        //get the list of cemsus member id to query group census member plan        
        Map<Id,vlocity_ins__GroupCensusMember__c> groupCensusMemberMap=new Map<ID, vlocity_ins__GroupCensusMember__c>
            ([SELECT id , MemberAge__c , ARV_Member_Zip_Code__c , Status__c , 
              vlocity_ins__MemberType__c  from vlocity_ins__GroupCensusMember__c where 
              vlocity_ins__CensusId__c =:enrollmentCensusId limit 500]);
        
        //get the group census member plan
        List<vlocity_ins__GroupCensusMemberPlan__c > groupCensusMemberPlanList=[SELECT id,
                                                vlocity_ins__ContractLineId__r.vlocity_ins__Product2Id__c,
                                                vlocity_ins__GroupCensusMemberId__c,ARV_Member_Rate__c 
                                                from vlocity_ins__GroupCensusMemberPlan__c  where 
                                vlocity_ins__GroupCensusMemberId__c in :groupCensusMemberMap.keyset() limit 30000];
        database.delete(groupCensusMemberPlanList);
        outMap.put(RECORDSDLTD,true);
        }catch(Exception e){
             GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CLS_METHODNAME, contractId);
        } 
                                          
        return true;
    }

    /*****************************************************************************************
Method Name   : getPids 
Date Created : 18-Nov-2019
Created By   : IDC Offshore
Description  : This method is used to get product IDs.
******************************************************************************************/
    public static Boolean getPids(Map < String, Object > inputMap,Map < String, Object > outMap, Map < String, Object > options) {        
        contractId=(String)inputMap.get(ENRLMNTCONID);
        String enrollmentCensusId=(String)inputMap.get(ENRLMNTCENSUSID);
        //Written by Revanth to fetch Effectivedate  and county.
        //updated to get change effective date to renewal date.
        list<contract> ctrList = [select vlocity_ins__QuoteId__r.Requested_Renewal_Date__c,Account.GA_Mailing_County_id__r.name,
                                  Account.BillingPostalCode,ARV_Requested_Effective_Date__c from contract 
                                  where id =: contractId limit 100];
        //effdat = ctrList[0].vlocity_ins__QuoteId__r.Requested_Renewal_Date__c;
        effdat = ctrList[0].ARV_Requested_Effective_Date__c;
        renDate = ctrList[0].vlocity_ins__QuoteId__r.Requested_Renewal_Date__c;
        cnty = ctrList[0].Account.GA_Mailing_County_id__r.name;
        hqZipValue = ctrList[0].Account.BillingPostalCode;
        //get the list of contract line items
        /*List<vlocity_ins__ContractLineItem__c> contractLineItems=[SELECT id, vlocity_ins__Product2Id__c from
                                                                  vlocity_ins__ContractLineItem__c where 
                                                                  vlocity_ins__ContractId__c =:contractId limit 100];*/
        //get the list of cemsus member id to query group census member plan
        //List<Id> censusMemberIds=new List<Id>();
        Map<Id,vlocity_ins__GroupCensusMember__c> groupCensusMemberMap=new Map<ID, vlocity_ins__GroupCensusMember__c>
            ([SELECT id , MemberAge__c , ARV_Member_Zip_Code__c , Status__c , 
              vlocity_ins__MemberType__c  from vlocity_ins__GroupCensusMember__c where 
              vlocity_ins__CensusId__c =:enrollmentCensusId limit 500]);
        
        //get the group census member plan
        List<vlocity_ins__GroupCensusMemberPlan__c > groupCensusMemberPlanList=[SELECT id,
                                        vlocity_ins__ContractLineId__r.vlocity_ins__Product2Id__c,
                                        vlocity_ins__GroupCensusMemberId__c, ARV_Member_Rate__c 
                                        from vlocity_ins__GroupCensusMemberPlan__c  
                                    where vlocity_ins__GroupCensusMemberId__c in :groupCensusMemberMap.keyset() LIMIT 1000];
        Map<String,vlocity_ins__GroupCensusMemberPlan__c> groupCensusMemberPlanListMap=
            new Map<String,vlocity_ins__GroupCensusMemberPlan__c>();
        for(vlocity_ins__GroupCensusMemberPlan__c each: groupCensusMemberPlanList){
            groupCensusMemberPlanListMap.put(getGCMPKey(each),each);
        }
        //create the user gourp in order to fire getRatedProducts
        Map<String,List<Object>> censusMemberByPlan=new Map<String,List<Object>>();
        Map<id,String> planNameMap=new Map<id,String>();
        Map<String, Object> ipInputJson = new Map<String, Object>();        
        Map <String, Object> ipOptions = new Map <String, Object> ();
        List<Map<String,Object>> userInputs = null;
        ipInputJson.put(CENSUSID, enrollmentCensusId);        
        ipInputJson.put(EFFECTIVEDATEFORMAT, effdat);
        Map<String,Object> zipCodeBlockMap=new Map<String, Object>();
        Map<String,String> zipCode=new Map<String, String>();
        zipCode.put(ZIPCODESTR, hqZipValue);        
        zipCodeBlockMap.put(ZIPCODEBLOCK, zipCode);        
        zipCodeBlockMap.put(FINALCOUNTY, cnty);
        ipInputJson.put(NWACNTDTLS,zipCodeBlockMap);
        system.debug('print ipInputJson IP1 @@'+ipInputJson);
        if (!Test.isRunningTest()){
            ipOutput = (Map <String, Object>) vlocity_ins.IntegrationProcedureService.runIntegrationService('Quoting_UserInputs', ipInputJson, ipOptions);
            system.debug('print userinputs OP'+ipOutput.get(IPUSERINPUTS));
        }
        if(ipOutput.get(IPUSERINPUTS) instanceof map<string, Object>){            
            userInputs = new List<Map<String,Object>>();
            userInputs.add((Map<String,Object>)ipOutput.get(IPUSERINPUTS));
        }else{            
            userInputs=(List<Map<String,Object>>)ipOutput.get(IPUSERINPUTS);
        }
        Map<String,Object> userInputsMap=new Map<String,Object>();
        for(Map<String,Object> entry:userInputs){            
            userInputsMap.put(entry.get(SGCENSUS).toString(),entry);
        }        
        
        //create user input based on plans
        for(vlocity_ins__ContractLineItem__c cli:[SELECT id, vlocity_ins__Product2Id__c,vlocity_ins__Product2Id__r.name from
                                                                  vlocity_ins__ContractLineItem__c where 
                                                                  vlocity_ins__ContractId__c =:contractId limit 100]){
            planNameMap.put(cli.vlocity_ins__Product2Id__c,cli.vlocity_ins__Product2Id__r.name);
            for(vlocity_ins__GroupCensusMemberPlan__c gcmp:groupCensusMemberPlanList){
                if(cli.id==gcmp.vlocity_ins__ContractLineId__c && userInputsMap.containsKey(gcmp.vlocity_ins__GroupCensusMemberId__c)){
                    if(censusMemberByPlan.containsKey(cli.vlocity_ins__Product2Id__c)){
                        censusMemberByPlan.get(cli.vlocity_ins__Product2Id__c).add(userInputsMap.get(gcmp.vlocity_ins__GroupCensusMemberId__c));
                    }else{
                        List<Object> temp=new List<Object>();
                        temp.add(userInputsMap.get(gcmp.vlocity_ins__GroupCensusMemberId__c));
                        censusMemberByPlan.put(cli.vlocity_ins__Product2Id__c,temp);
                    }
                }
            }
        }    
        system.debug('censusmbrbyplan...'+censusMemberByPlan);
        List<vlocity_ins__GroupCensusMemberPlan__c> gcmpUpdate=new List<vlocity_ins__GroupCensusMemberPlan__c>();
        for(String id: censusMemberByPlan.keySet()){
            if(!planNameMap.get(id).equals('Vision PPO Plus℠ 80/50/50 Pediatric SG')){                
            Map<String, Object> ipInputJsonGRP = new Map<String, Object>();            
            Map <String, Object> ipOptionsGRP = new Map <String, Object> ();
            ipInputJsonGRP.put(FILTERS,FILTERID+id);
            ipInputJsonGRP.put(IPUSERINPUTS,censusMemberByPlan.get(id));            
            efESTDate = string.valueOf(renDate) + efESTDateFORMAT ;
            ipInputJsonGRP.put(EFFECTIVEDATE,efESTDate);
            system.debug('ipInput2 ------@@'+ipInputJsonGRP);
            if(!Test.isRunningTest()){                
                ipOutputGRP = (Map <String, Object>) vlocity_ins.IntegrationProcedureService.runIntegrationService('Enrollment_GetRated',ipInputJsonGRP, ipOptionsGRP);
                system.debug('ipOutputGRP2 ---------@@'+ipOutputGRP);
            }
            try{                
                List<Object> records= (List<Object>)ipOutputGRP.get(RECORDS);                
                Map <String, Object> record =(Map <String, Object>)records.get(0);                
                List<Object> rawPriceData= (List<Object>)record.get(RAWPRICEDATA);                
                Map <String, Object> rawPriceDataFirst=(Map <String, Object>)rawPriceData.get(0);                
                List<Object> userRatings=(List<Object>)rawPriceDataFirst.get(CALCRESULTS);                
                updateGroupCensusMemberPlan(gcmpUpdate,groupCensusMemberPlanListMap,userRatings,id);
            }catch(Exception e){
                GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CLS_METHODNAME, contractId);
            }            
            outMap.put(id+STRINGA,ipOutputGRP);
            outMap.put(id,ipInputJsonGRP);
            }
        }        
        database.update(gcmpUpdate);
        updateCensusCountPremium();             
        return true;         
    }
    /*************************************************************************************************************  
Method name : getGCMPKey
Params     : NA
Return Type : null
Description :getGCMPKey() method returns value in a specific format.
***********************************************************************************************************/     
    private static String getGCMPKey(vlocity_ins__GroupCensusMemberPlan__c gcmp){
        return gcmp.vlocity_ins__GroupCensusMemberId__c +UNDERSCORE+
            gcmp.vlocity_ins__ContractLineId__r.vlocity_ins__Product2Id__c; 
    }
    /*************************************************************************************************************  
Method name : updateGroupCensusMemberPlan
Params     : NA
Return Type : null
Description :updateGroupCensusMemberPlan() method is to update GCMP plans with the new rates.
***********************************************************************************************************/     
    private static void updateGroupCensusMemberPlan(List<vlocity_ins__GroupCensusMemberPlan__c> gcmpUpdate,
                                               Map<String,vlocity_ins__GroupCensusMemberPlan__c> groupCensusMemberPlanListMap,
                                               List<Object> rawCalcResults,String pid){
        for(Object eachList:rawCalcResults){
            Map<String,Object> each=(Map<String,Object>)eachList;
            String gcmpKey=each.get(STRINGID)+UNDERSCORE+pid;
            vlocity_ins__GroupCensusMemberPlan__c censusMemberPlan=groupCensusMemberPlanListMap.get(gcmpKey);
            censusMemberPlan.ARV_Member_Rate__c =(Decimal)each.get(PREMIUM);            
            gcmpUpdate.add(censusMemberPlan);
        }
    }
    /*************************************************************************************************************  
Method name : updateCensusCountPremium
Params     : NA
Return Type : null
Description :updateCensusCountPremium() method update count employees and Premiums in realtionship object.
***********************************************************************************************************/    
     private static void updateCensusCountPremium(){        
        List<vlocity_ins__GroupCensusMember__c> censusMember=new List<vlocity_ins__GroupCensusMember__c>();
        List<Package_Location_Segment_Rel__c> packageRelationship=new List<Package_Location_Segment_Rel__c>();
        packageRelationship=[select id,ARV_CensusMember_Premium__c, ARV_CF_CensusMember_Count__c from 
                             Package_Location_Segment_Rel__c where Contract__c=:contractId limit 500]; 
        Package_Location_Segment_Rel__c segmentrelation=null;
        List<Package_Location_Segment_Rel__c> packageRelationship1=new List<Package_Location_Segment_Rel__c>();
        List<Id> packageRelationsVar = new List<Id>();
        for(Package_Location_Segment_Rel__c relationshipTemp:packageRelationship){ 
            List<String> premiumCount = new List<String>();
            packageRelationsVar.add(relationshipTemp.Id);
        }
        censusMember=[select id,Enrollment_Medical_Premium__c,ARV_Census_Member_Selected_Package__c,
                      Enrollment_Dental_Premium__c,Enrollment_Vision_Premium__c,vlocity_ins__IsPrimaryMember__c 
                      from vlocity_ins__GroupCensusMember__c 
                      where ARV_Census_Member_Selected_Package__c in :packageRelationsVar and Status__c=:ENROLLING limit 5000];
        for(Package_Location_Segment_Rel__c relationship:packageRelationship){ 
            segmentrelation =new Package_Location_Segment_Rel__c();
            Integer censusCount=0;
            Decimal finalPremium=0;
            for(vlocity_ins__GroupCensusMember__c censusmembers:censusMember) {
                if(relationship.Id == censusmembers.ARV_Census_Member_Selected_Package__c) {
                    finalPremium+=censusmembers.Enrollment_Medical_Premium__c!=null?censusmembers.Enrollment_Medical_Premium__c:0;
                    finalPremium+=censusmembers.Enrollment_Dental_Premium__c!=null?censusmembers.Enrollment_Dental_Premium__c:0;
                    finalPremium+=censusmembers.Enrollment_Vision_Premium__c!=null?censusmembers.Enrollment_Vision_Premium__c:0;
                    relationship.ARV_CensusMember_Premium__c=finalPremium;
                    if(censusmembers.vlocity_ins__IsPrimaryMember__c){
                        censusCount=censusCount+1;
                        relationship.ARV_CF_CensusMember_Count__c=censusCount; 
                    }                
            }
        }
            segmentrelation.Id=relationship.id;
            segmentrelation.ARV_CensusMember_Premium__c=finalPremium;
            segmentrelation.ARV_CF_CensusMember_Count__c=censusCount;
            packageRelationship1.add(segmentrelation);
        }
        if(!packageRelationship1.isEmpty()){
            Database.update(packageRelationship1);
        }      
        
    }
    
}