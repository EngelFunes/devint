/*****************************************************************************************
Class Name   : ARV_AP_UpdatePlanPackgaeComb. 
Date Created : 12-Dec-2019
Created By   : IDC Offshore
Description  : This is the class for validating census in enrollment process.
******************************************************************************************/
global without sharing class ARV_AP_UpdatePlanPackgaeComb implements vlocity_ins.VlocityOpenInterface2{
    private static string CONTRACTID='contractId';
    private static final string CLSNAME  ='ARV_AP_UpdatePlanPackgaeComb';
    private static final string METHODNAME1  ='updatePlnPckgCmb'; 
    private static string MEDICALTYPE;
    private static string DENTALTYPE;
    private static string VISIONTYPE;
    private static boolean FreeStandingDental;
    private static boolean FreeStandingVision;
    
    
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
                updatePlnPckgCmb(input, output,options);
            }
        }catch(exception e){
            //system.debug('line number@@ '+e.getLineNumber());
            //system.debug('getMessage @@ '+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME);
            //throw new AuraHandledException(ERRORMSG+ARV_AP41_StringLiteralUtils.COLONVAL+e.getMessage());
        }
        return true;
    }
    /*****************************************************************************************
Method Name   : getContract. 
Date Created : 23-Dec-2019
Created By   : IDC Offshore
Description  : This is the method for Cencos Voluntary validation.
******************************************************************************************/
    Public void updatePlnPckgCmb(Map<String, Object> input, Map<String, Object> output, Map<String,Object> options){
       string ctId = String.valueOf(input.get(CONTRACTID));
       string fnlConcat; 
       string fnlPckgStr; 
        map<string,string> plnCombMap = new map<string,string>();
        list<ARV_CM06_PlanCombinations__mdt> plnCMDS = [select id,ARV_Dental_Type__c,Plan_Combination__c,
                                               ARV_Plan_Type__c,ARV_Vision_Type__c,ARV_Freestanding_Dental__c,ARV_Freestanding_Vision__c 
                                                       from ARV_CM06_PlanCombinations__mdt limit 500];
        for(ARV_CM06_PlanCombinations__mdt plnCMD : plnCMDS){
            fnlConcat = plnCMD.ARV_Plan_Type__c + plnCMD.ARV_Freestanding_Dental__c + plnCMD.ARV_Freestanding_Vision__c 
                        + plnCMD.ARV_Dental_Type__c + plnCMD.ARV_Vision_Type__c;
            system.debug('@@@fnlConcat@@@'+fnlConcat);
            plnCombMap.put(fnlConcat,plnCMD.Plan_Combination__c);
        }
        system.debug('@@@plnCombMap@@@'+plnCombMap);
        
        list<Package__c> pckg = [select id,ARV_Contract_Id__c,ARV_Medical_Plan__c,ARV_Contract_Id__r.ARV_Freestanding_Dental__c,
                                 ARV_Contract_Id__r.ARV_Freestanding_Vision__c,ARV_Contract_Id__r.ARV_ExistingDentalCoverage__c, ARV_Tech_Dental_Voluntary_Contributory__c
                                 ,ARV_Tech_Vision_Voluntary_Contributory__c,ARV_Dental_Plan__c,ARV_Pediatric_Dental_Plan__c,
                                 ARV_Medical_Plan__r.Carrier_Type__c,ARV_Vision_Plan__c,ARV_Standalone_Dental__c,ARV_Plan_Package_Combinations__c    
                                 from Package__c  where ARV_Contract_Id__c =:ctId]; 
        system.debug('pckglst : '+pckg);
        for(Package__c pck:pckg){
            MEDICALTYPE = pck.ARV_Medical_Plan__c !=NULL ? (pck.ARV_Medical_Plan__r.Carrier_Type__c == 'BCN' ? 'BCN' : 'BCBSM' ): NULL;
            FreeStandingDental = pck.ARV_Medical_Plan__r.Carrier_Type__c == 'BCN' ? false : pck.ARV_Contract_Id__r.ARV_Freestanding_Dental__c;
            FreeStandingVision = pck.ARV_Medical_Plan__r.Carrier_Type__c == 'BCN' ? false : pck.ARV_Contract_Id__r.ARV_Freestanding_Vision__c;
            VISIONTYPE = pck.ARV_Vision_Plan__c == NULL ? 'No Vision' : pck.ARV_Tech_Vision_Voluntary_Contributory__c == 'Not Applicable' ? 'Pediatric' : pck.ARV_Tech_Vision_Voluntary_Contributory__c ;                       
            DENTALTYPE = (pck.ARV_Dental_Plan__c == NULL ? 'No Dental' : (pck.ARV_Standalone_Dental__c ? (pck.ARV_Tech_Dental_Voluntary_Contributory__c == 'Not Applicable' ? 'Pediatric' : 'Standalone '+pck.ARV_Tech_Dental_Voluntary_Contributory__c) : pck.ARV_Tech_Dental_Voluntary_Contributory__c == 'Not Applicable' ? 'Pediatric' : pck.ARV_Tech_Dental_Voluntary_Contributory__c ));
            fnlPckgStr = MEDICALTYPE+FreeStandingDental+FreeStandingVision+DENTALTYPE+VISIONTYPE;
            system.debug('@@@fnlPckgStr@@@'+fnlPckgStr);
            //if(pck.ARV_Medical_Plan__c == 'BCBSM' && pck.ARV_Contract_Id__r.ARV_Freestanding_Dental__c == false && pck.ARV_Contract_Id__r.ARV_Freestanding_Vision__c == false && ) --- && (VISIONTYPE == 'Voluntary' || VISIONTYPE == 'Non-Voluntary') 

            pck.ARV_Plan_Package_Combinations__c = plnCombMap.get(fnlPckgStr); 
            if(MEDICALTYPE == 'BCBSM' && FreeStandingDental == false && FreeStandingVision == true && DENTALTYPE == 'Pediatric'  && VISIONTYPE.contains('Voluntary') && (pck.ARV_Contract_Id__r.ARV_ExistingDentalCoverage__c == 'No' || pck.ARV_Contract_Id__r.vlocity_ins__QuoteId__r.pedDentalAdded__c == true )){
                pck.ARV_Plan_Package_Combinations__c = plnCombMap.get(fnlPckgStr)+'Va;'; 
            }
            system.debug('@@@fnlPckgStr.ARV_Plan_Package_Combinations__c@@@'+pck.ARV_Plan_Package_Combinations__c);
        }
        Update pckg;
     
        
    }
}