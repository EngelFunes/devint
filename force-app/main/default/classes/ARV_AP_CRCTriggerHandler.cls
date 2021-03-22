/*****************************************************************************************
Class Name   : ARV_AP_CRCTriggerHandler
Date Created : 2020 June
Created By   : IDC Offshore
Description  :This is the class to pass setIds to CoRC IP for Renewal Calculations.
******************************************************************************************/
public without sharing class ARV_AP_CRCTriggerHandler {
    private static final String PROCEDURE_NAME = 'CORC_GoldenCopy';
    private static final String EFFECTIVEDATE = 'effectiveDate';
    private static final String PREEFFECTIVEDATE = 'preEffectiveDate';
    private static final String CENSUSID = 'censusId';
    private static final String METHODNAME = 'updateIPCoRCData';
    private static final String CONTRACTID = 'contractId';
    private static final String CORCID = 'corcId';
    private static final String AREA = 'area';
    private static final String ENROLLMENTCENSUSID = 'enrollmentCensusId';
    private static final String BCNDEPENDENTCAP = 'bcnDependentCap';
    private static final String BCBSMDEPENDENTCAP = 'bcbsmDependentCap';
    private static final String ENROLLMENTCARRIER = 'enrollmentCarrier';
    private static final String CONGAAGENT = 'CongaAgent';
    private Static Final String CLSNAME = 'ARV_AP_CRCTriggerHandler';
    private Static Final String CLS_METHODNAME1 = 'updateIPCoRCData';
    private Static Final String CLS_METHODNAME2 = 'updateContract';
    private static Boolean recursive=true;
    private static boolean boolval;
/********************************************************************************************
Constructor Name   : ARV_AP_CRCTriggerHandler.    
Description  : This constructor is used to initiation of Variables.
**************************************************************************/
    public ARV_AP_CRCTriggerHandler()
    {
        boolval=recursive;
    }
/*****************************************************************************************
Method Name   : updateIPCoRCData 
Date Created : 2020 June
Created By   : IDC Offshore
Description  :This is the method to pass setIds to CoRC IP for Renewal Calculations.
******************************************************************************************/
    public static void updateIPCoRCData(List<Carrier_Rate_Comparison__c> corcList)
    {
        try{
            if(recursive)
            {
                recursive=false;
                Boolean bcnDependentCapFuture=null;
                Boolean bcbsmDependentCapFuture=null;
                Carrier_Rate_Comparison__c corc = corcList[0];
                Id renewalContractId= id.valueOf(corc.Future_Contract__c);
                 List<Contract> conList = [select id,ARV_CongaGroupTech__c,ARV_CongaAgentTech__c from contract where id=:renewalContractId];
                conList[0].ARV_CongaGroupTech__c='No';
                conList[0].ARV_CongaAgentTech__c='No';
                database.update(conList);
                List<Contract> contractList = [select id,StartDate,ARV_Requested_Effective_Date__c,
                                               vlocity_ins__ExpiredContractId__r.vlocity_ins__EnrollmentCensusId__r.Premium_Total__c,
                                               vlocity_ins__EnrollmentCensusId__r.Premium_Total__c,ARV_RatingArea__c,vlocity_ins__ExpiredContractId__c,
                                               vlocity_ins__ExpiredContractId__r.vlocity_ins__EnrollmentCensusId__c,vlocity_ins__EnrollmentCensusId__c,
                                               ARV_CF_CNTRCT_CarrierCodes__c,vlocity_ins__EnrollmentCensusId__r.ARV_CF_Average_Age__c,vlocity_ins__EnrollmentCensusId__r.vlocity_ins__CountOfEmployees__c,
                                               vlocity_ins__EnrollmentCensusId__r.vlocity_ins__CountOfEmployeesPlusDependents__c,vlocity_ins__ExpiredContractId__r.Base_Rate_Effective_Date__c FROM Contract WHERE id=:renewalContractId];
                bcnDependentCapFuture=corc.Total_BCN_Billable_Members_Current__c==
                    corc.Total_BCN_Billable_Members_Future__c?true:false;
                bcbsmDependentCapFuture=corc.Total_BCBSM_Billable_Members_Current__c==
                    corc.Total_BCBSM_Billable_Members_Future__c?true:false;   
                Id corc_Id= corc.Id;
                Map <String, Object> ipInput = new Map <String, Object>();
                Map <String, Object> ipOutput = new Map <String, Object>();
                Map <String, Object> ipOptions = new Map <String, Object>();
                ipInput.put(CONTRACTID,renewalContractId);
                ipInput.put(CORCID,corc_Id);
                ipInput.put(EFFECTIVEDATE,contractList[0].StartDate.format());
                ipInput.put(PREEFFECTIVEDATE,contractList[0].StartDate.format());
                //ipInput.put(PREEFFECTIVEDATE,contractList[0].vlocity_ins__ExpiredContractId__r.Base_Rate_Effective_Date__c.format());
                //ipInput.put(PREEFFECTIVEDATE,System.today().toStartOfMonth().Format());
                ipInput.put(AREA,contractList[0].ARV_RatingArea__c);
                ipInput.put(ENROLLMENTCENSUSID,
                    contractList[0].vlocity_ins__ExpiredContractId__r.vlocity_ins__EnrollmentCensusId__c);
                ipInput.put(CENSUSID,contractList[0].vlocity_ins__EnrollmentCensusId__c);
                ipInput.put(BCNDEPENDENTCAP,bcnDependentCapFuture);
                ipInput.put(BCBSMDEPENDENTCAP,bcbsmDependentCapFuture);
                ipInput.put(ENROLLMENTCARRIER,
                    contractList[0].ARV_CF_CNTRCT_CarrierCodes__c);
                System.debug('ipInput '+ipInput);
                ipOutput = (Map<String, Object>) 
                vlocity_ins.IntegrationProcedureService.runIntegrationService(PROCEDURE_NAME,ipInput,ipOptions);
                updateContract(corc,contractList[0]);
            }
        }catch(Exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, CLS_METHODNAME1);}
    }
/*****************************************************************************************
Method Name   : updateContract 
Date Created : 2020 June
Created By   : IDC Offshore
Description  :This is the method to update Contract with CoRC values if required
******************************************************************************************/
Public static void updateContract(Carrier_Rate_Comparison__c crc, Contract cntrct)
    {  
        try
        {
            //Populate Premium Change values on Contract
            if(crc.Total_Med_Rx_Premium_Current__c!=0)
            {
                cntrct.ARV_CF_CNTRCT_Medical_Change__c = 
                    (100*(crc.Total_Med_Rx_Premium_Future__c - 
                          crc.Total_Med_Rx_Premium_Current__c)/crc.Total_Med_Rx_Premium_Current__c);
            }
            if(crc.Total_Dental_Premium_Current__c!=0)
            {
                cntrct.ARV_CF_CNTRCT_Dental_Change__c =
                    (100*(crc.Total_Dental_Premium_Future__c -
                          crc.Total_Dental_Premium_Current__c)/crc.Total_Dental_Premium_Current__c);
            }
            if(crc.Total_Vision_Premium_Current__c!=0)
            {
                cntrct.ARV_CF_CNTRCT_Vision_Change__c =
                    (100*(crc.Total_Vision_Premium_Future__c - 
                          crc.Total_Vision_Premium_Current__c)/crc.Total_Vision_Premium_Current__c);
            }
            cntrct.ARV_CF_CNTRCT_Last_Year_Premium__c =
                cntrct.vlocity_ins__ExpiredContractId__r.vlocity_ins__EnrollmentCensusId__r.Premium_Total__c;
            cntrct.ARV_CF_CNTRCT_Renewal_Premium__c =
                cntrct.vlocity_ins__EnrollmentCensusId__r.Premium_Total__c;
            //Popuate Average Age from Census to Contract
            cntrct.ARV_CF_CNTRCT_Average_Age__c =
                cntrct.vlocity_ins__EnrollmentCensusId__r.ARV_CF_Average_Age__c;
            cntrct.ARV_CF_Total_Members_Count__c = 
                cntrct.vlocity_ins__EnrollmentCensusId__r.vlocity_ins__CountOfEmployeesPlusDependents__c;
            cntrct.ARV_CF_Total_Subscriber_Count__c = 
                cntrct.vlocity_ins__EnrollmentCensusId__r.vlocity_ins__CountOfEmployees__c;
            database.update(cntrct);
            //This is to update Contract with CoRC values
            //if(!Test.isRunningTest()){
                ID jobID =System.enqueueJob(new ARV_AP100_GenerateRenwlPkgs(cntrct.Id,CONGAAGENT));
            //}
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, CLS_METHODNAME2);
        }
    }
}