/**
@Author : Dinesh P
@Name: ASC_GSPStagingTriggerHelper
@CreatedDate:  15-May-2020 
@Description: ASC_GSPStagingTriggerHelper class is used to create/update the records in Group Specific Pricing Object - 
              Group Specific Pricing Staging object that will trasform the data coming from HiPS System and populate it in Group Specific Pricing Object.
@version : 1.0  
@US Number: US-2852

---Modified---
@US Number: US-3112 -Added By Dinesh - update Deleted flag to true on GSP based on data points in GSP Staging records - 06/18/2020
@US Number: US-3263 -Added By Dinesh - Transform 5 New GSP staging fields to GSP Object -Added the FACILITY FOREIGN LOB,FACILITY DOMESTIC LOB,
                                       MINIMUM AGG ATTACH POINT,AGG SPEC DED AMOUNT,ASC Funding Arrangement in the below Products - 06/18/2020
*/
public without sharing class ASC_GSPStagingTriggerHelper {
       
    public static final string CLASSNAME  ='ASC_GSPStagingTriggerHelper';
    public static final string METHODNME  ='createUpdateGSPRecords';
    public static final string METHODNME_VALGSPSREC = 'validateGSPStagingRecords';
    private static final String SOURCE_HIPS = 'HiPS';
    private static final String GSP_OBJNAME = 'ASC_Group_Specific_Pricing__c';
    private static final String UNDERSCORE = '_';
    private static final String STRING_EMPTY = '';
    
    private static final String RECTYPE_FIXEDADMINFEE = 'ASC_Fixed_Admin_Fees';
    private static final String RECTYPE_VARIABLEADMINFEE = 'ASC_Variable_Administrative_Fees';
    private static final String RECTYPE_SPECIFICSTOPLOSS = 'ASC_Specific_Stop_Loss';
    private static final String RECTYPE_AGGRSTOPLOSS = 'ASC_Aggregate_Stop_Loss';
    private static final String RECTYPE_FINANCECHRGFEE = 'ASC_Finance_Charge_Fees';
    private static final String RECTYPE_DEPOSITS = 'ASC_Deposits';
    private static final String RECTYPE_STOPLOSSOPTOUT = 'ASC_Stop_Loss_Opt_Out';
    private static final String RECTYPE_ADMINCOMPFEES = 'ASC_Administrative_Comp_Fees';
        
    private static final String FIXEDADMINFEE_PRDCODE = 'ASC_0000005';
    private static final String VARADMINFEE_PRDCODE = 'ASC_0000370';
    private static final String SPECIFIC_SL_INS_PRDCODE = 'ASC_0000415';
    private static final String AGG_SL_INS_PRDCODE = 'ASC_0000159'; 
    private static final String FINANCECHARGE_PRDCODE = 'ASC_0000006';
    private static final String HOSP_ADV_DEP_PRDCODE = 'ASC_0000004';
    private static final String TPA_STOP_LOSS_VENDORFEE_PRDCODE = 'ASC_0000078';
    private static final String ADDITIONAL_ADMIN_COMP_PRDCODE = 'ASC_0000014';
    private static final String ADVDEP_MONTHLYCAPAMOUNT_PRDCODE = 'ASC_0000010'; //US-3665
    
    private static final String TOTALMONTHLYADMFEE_FIELD = 'Total_Monthly_Admin_Fee__c';  
    private static final String ADMINFEEPERCENTCLAIMS_FIELD = 'Admin_Fee_Percent_Of_Claims__c';
    private static final String SPECIFIC_SL_INS_FIELD = 'Specific_Sl_Ins__c';
    private static final String AGG_SL_INS_FIELD = 'Agg_Sl_Ins__c';
    private static final String FINANCECHARGE_FIELD = 'Finance_Charge__c';
    private static final String HOSP_ADV_DEP_FIELD = 'Hosp_Adv_Dep__c';
    private static final String TPA_STOP_LOSS_VENDORFEE_FIELD = 'Tpa_Stop_Loss_Vendor_Fee__c';
    private static final String ADDITIONAL_ADMIN_COMP_FIELD = 'Additional_Admin_Compensation__c';
    private static final String ADVDEP_MONTHLYCAPAMOUNT_FIELD = 'Monthly_Cap_Amount__c'; //US-3665
    
    private static final String LOB_FACILITY = ';Facility ';  
    private static final String LOB_PROFESSIONAL = ';Professional ';
    private static final String LOB_DENTAL = ';Dental ';
    private static final String LOB_DRUG = ';Drug ';
    private static final String LOB_VISION = ';Vision ';
    private static final String LOB_FACILITY_FOREIGN = ';Facility Foreign ';
    private static final String LOB_FACILITY_DOMESTIC = ';Facility Domestic ';    
    
    private static final String STATUS_ACTIVATED = 'Activated';
    private static final String ERRORMSG_EFFDATE = 'Effective End Date can’t be prior to Effective Start Date.';
    private static final String ERRORMSG_CARRIER = 'Carrier should be BCBSM or BCN.';
    private static final String ERRORMSG_PLATFORM = 'Platform should be MOS, NASCO, BCN or Medicare Advantage.';
    private static final String ERRORMSG_CID = 'CID does not exist in Group CRM';
    private static final String ERRORMSG_CARRIERREQ = 'Required fields are missing: [Carrier__c].';
    private static final String ERRORMSG_EFFDATEREQ = 'Required fields are missing: [Effective_Date__c].';
    private static final String ERRORMSG_EFFENDDATEREQ = 'Required fields are missing: [Effective_End_Date__c].';
            
    private static final String SL_LOB_VAL_MED_OP 
    = 'Medical Claims and Outpatient Prescription Drug Claims covered by Stop-Loss Policy';
    private static final String SL_LOB_VAL_MED = 'Medical Claims covered by Stop-Loss Policy';
    private static final String CC_RENEWALEXISTINGCOV 
    = 'Renewal of Existing Coverage: Claims incurred on or after the Original Effective Date of Policy and paid during the Policy Period.';

            
    public static final Set<String> ACCRECORDTYPESET = new Set<String>{
         'Account_Customer','Account_Prospect'
        };
    private static final Set<String> CARRIERVALUESET = new Set<String>{
     'BCBSM','BCN'
    };
    private static final Set<String> PLATFORMVALUESET = new Set<String>{
     'MOS','NASCO','BCN','Medicare Advantage'
    };
    private static final Integer NO_OFF_ADV_DAYS = Integer.ValueOf(System.Label.ASC_Number_of_Adv_Days);    
    private static final Integer AAC_PCNT = Integer.ValueOf(System.Label.ASC_AAC_PCNT);
    
    private static final Set<String> PRODUCTCODESET = new Set<String>{
         'ASC_0000005','ASC_0000370','ASC_0000415','ASC_0000159','ASC_0000006','ASC_0000004','ASC_0000078','ASC_0000014','ASC_0000010'
    };
    private static final Set<String> PRODUCTCODESETQLI = new Set<String>{
         'ASC_0000370','ASC_0000415'
    };                        
    private static final String LOBEMPTY_STR = ' ';
    public static final string METHODNME_RECTYPE = 'getRecordTypeIdByName';
    
    /********************************************************************************************************************
    @Description        :   This method is used to create/update the records specific to Products in GSP object using
                            Group Specific Pricing Staging record coming from HiPS System.
    @Name               :   createUpdateGSPRecords
    @Param              :   List<ASC_Group_Specific_Pricing_Staging__c> gspsList
    @Return             :   void
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/   
    public static void createUpdateGSPRecords(List<ASC_Group_Specific_Pricing_Staging__c> gspsList) {

        set<String> cid = new set<String>();
        set<String> carr = new set<String>();
        set<Date> startDate = new set<Date>();
        set<Date> endDate = new set<Date>();
        set<String> prdCode = new set<String>();
        List<ASC_Group_Specific_Pricing__c> resultList = new List<ASC_Group_Specific_Pricing__c>();           
        ASC_Group_Specific_Pricing__c gspFixAdm = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspVarAdm = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspSLIns = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspAggSL = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspFncf = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspDep = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspSLOpt = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspAAC = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspAdvDep = new ASC_Group_Specific_Pricing__c();

        ASC_Group_Specific_Pricing__c gspFixAdmDupF = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspVarAdmDupF = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspSLInsDupF = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspAggSLDupF = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspFncfDupF = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspDepDupF = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspSLOptDupF = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspAACDupF = new ASC_Group_Specific_Pricing__c();
        ASC_Group_Specific_Pricing__c gspAdvDepDupF = new ASC_Group_Specific_Pricing__c();
        
        Map<String,String> gspsProductMap = new Map<String,String>();
        Map<String,String> prdIdMap = new Map<String,String>();
        Map<String,String> accIdMap = new Map<String,String>();
        Map<String,Id> existingUniqueKeySet =new Map<String,Id>();
        Set<Id> contrIdSet = new Set<Id>();
        Map<String,vlocity_ins__ContractLineItem__c> cLIMap = new Map<String,vlocity_ins__ContractLineItem__c>();              
        Map<String,Contract> cidCarrierMap = new Map<String,Contract>();
              
        for(Product2 prdRec:[Select Id,Name,ProductCode from Product2 where ProductCode IN:PRODUCTCODESET
                                                                            AND IsActive = true
                                                                            Limit :UTIL_SLB.retrieveQueryLimitValue()]){
            prdIdMap.put(prdRec.ProductCode,prdRec.Id);
        }
        for(ASC_GSPS_Product_Mapping__mdt gspmdt:[Select Id,ASC_Input_Field_Name__c,ASC_Product_Code__c
                                                             from ASC_GSPS_Product_Mapping__mdt
                                                             Limit :UTIL_SLB.retrieveQueryLimitValue()]){            
            gspsProductMap.put(gspmdt.ASC_Input_Field_Name__c,gspmdt.ASC_Product_Code__c);
        }        
                            
        try{
            if(!gspsList.isEmpty()){
                     
              for(ASC_Group_Specific_Pricing_Staging__c gspsRec:gspsList){
                 cid.add(gspsRec.CID__c);
                 carr.add(gspsRec.Carrier__c);
                 startDate.add(gspsRec.Effective_Date__c);
                 endDate.add(gspsRec.Effective_End_Date__c);
                 prdCode.addAll(PRODUCTCODESET);                 
              }

              for(Account acc:[Select Id,CID__c from Account where RecordType.DeveloperName IN:ACCRECORDTYPESET and CID__c IN:cid
                                                                   Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                 accIdMap.put(acc.CID__c,acc.Id);
              }               
              
              for(Contract contr:[Select Id,CID__c,ASC_Carrier__c,StartDate from Contract where CID__c IN:cid
                                                                                                AND ASC_Carrier__c IN:carr  
                                                                                                AND Status =:STATUS_ACTIVATED                                                                                              
                                                                                                ORDER BY StartDate DESC 
                                                                                                Limit :UTIL_SLB.retrieveQueryLimitValue()]){                 
                 String strCont = contr.CID__c+UNDERSCORE+contr.ASC_Carrier__c;  
                 if(!cidCarrierMap.containsKey(strCont)){                 
                   cidCarrierMap.put(strCont, contr);
                   contrIdSet.add(contr.Id);
                 }
              }
              
              for(vlocity_ins__ContractLineItem__c cLI:[Select Id,vlocity_ins__ContractId__r.CID__c,
                                                          vlocity_ins__ContractId__r.ASC_Carrier__c,
                                                           vlocity_ins__Product2Id__r.ProductCode,
                                                           ASC_Line_Item_Extension__c,
                                                           ASC_Line_Item_Extension__r.AAC_PCNT__c,
                                                           ASC_Line_Item_Extension__r.Deductible__c
                                                           from vlocity_ins__ContractLineItem__c 
                                                           where ASC_Line_Item_Extension__c !=null
                                                           AND vlocity_ins__ContractId__c IN:contrIdSet
                                                           AND vlocity_ins__Product2Id__c != null
                                                           AND vlocity_ins__Product2Id__r.ProductCode !=null
                                                           AND vlocity_ins__Product2Id__r.ProductCode 
                                                           IN:PRODUCTCODESETQLI                                                                                       
                                                           Limit :UTIL_SLB.retrieveQueryLimitValue()]){
    
                  String strCont = cLI.vlocity_ins__ContractId__r.CID__c+UNDERSCORE+
                                   cLI.vlocity_ins__ContractId__r.ASC_Carrier__c+UNDERSCORE+
                                   cLI.vlocity_ins__Product2Id__r.ProductCode;
                  if(!cLIMap.containsKey(strCont)){
                  cLIMap.put(strCont,cLI);
                  }
              }
              
              for(ASC_Group_Specific_Pricing__c uniqRec:[select Id,ASC_CID__c,ASC_Carrier__c,ASC_Effective_Date__c,
                                                  ASC_Effective_End_Date__c,ASC_Product__c,ASC_Product_Code__c,
                                                  ASC_Sub_Segment__c from ASC_Group_Specific_Pricing__c
                                                  Where ASC_CID__c IN:cid
                                                  AND ASC_Carrier__c IN:carr
                                                  AND ASC_Effective_Date__c IN:startdate 
                                                  AND ASC_Effective_End_Date__c IN:endDate 
                                                  AND ASC_Product_Code__c IN:prdCode
                                                  AND ASC_CID__c !=null
                                                  AND ASC_Carrier__c !=null
                                                  AND ASC_Effective_Date__c !=null
                                                  AND ASC_Effective_End_Date__c !=null
                                                  AND ASC_Sub_Segment__c = null
                                                  AND ASC_Deleted__c = false
                                                  Limit :UTIL_SLB.retrieveQueryLimitValue()]){
              existingUniqueKeySet.put(uniqRec.ASC_CID__c+UNDERSCORE+uniqRec.ASC_Carrier__c+UNDERSCORE+
                                      uniqRec.ASC_Effective_Date__c+UNDERSCORE+uniqRec.ASC_Effective_End_Date__c+
                                      UNDERSCORE+uniqRec.ASC_Product_Code__c,uniqRec.Id);                         
              }
                            
              for(ASC_Group_Specific_Pricing_Staging__c gspsRec:gspsList){                 
                                  
                 if(gspsProductMap.ContainsKey(TOTALMONTHLYADMFEE_FIELD)){ //Product1
                     String uniqueKey = gspsRec.CID__c+UNDERSCORE+gspsRec.Carrier__c+UNDERSCORE+gspsRec.Effective_Date__c+
                                        UNDERSCORE+gspsRec.Effective_End_Date__c+
                                        UNDERSCORE+FIXEDADMINFEE_PRDCODE;                                                   
                                       
                     if(gspsRec.Total_Monthly_Admin_Fee__c !=null){                                               
                        gspFixAdm = new ASC_Group_Specific_Pricing__c();
                        gspFixAdm.Id = existingUniqueKeySet.get(uniqueKey);
                        gspFixAdm.ASC_Group_Specific_Pricing_Staging_ID__c = gspsRec.Id;                    
                        gspFixAdm.RecordTypeId = getRecordTypeIdByName(RECTYPE_FIXEDADMINFEE);
                        gspFixAdm.ASC_Product__c = prdIdMap.get(gspsProductMap.get(TOTALMONTHLYADMFEE_FIELD));                 
                        gspFixAdm.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspFixAdm.ASC_Carrier__c = gspsRec.Carrier__c;
                        gspFixAdm.ASC_Effective_Date__c = gspsRec.Effective_Date__c;
                        gspFixAdm.ASC_Effective_End_Date__c = gspsRec.Effective_End_Date__c;
                        gspFixAdm.ASC_Platform__c = gspsRec.Platform__c;
                        gspFixAdm.ASC_Unit_Price__c = gspsRec.Total_Monthly_Admin_Fee__c;
                        gspFixAdm.ASC_Estimated_Monthly_Contracts__c = gspsRec.Estimated_Monthly_Contracts__c;
                        gspFixAdm.ASC_CRED_CLMS__c = gspsRec.Cred_Clms__c;
                        gspFixAdm.ASC_CRED_CLMS_Facility__c = gspsRec.Cred_Clms_Facility__c;
                        gspFixAdm.ASC_Monthly_Cap_Amount__c = gspsRec.Monthly_Cap_Amount__c;  
                        gspFixAdm.ASC_Data_Source__c = SOURCE_HIPS;
                        gspFixAdm.ASC_LOB__c = LOBEMPTY_STR;
                        gspFixAdm.ASC_LOB__c += gspsRec.Lob_Facility__c ?LOB_FACILITY:STRING_EMPTY;                                                
                        gspFixAdm.ASC_LOB__c += gspsRec.Lob_Professional__c ?LOB_PROFESSIONAL:STRING_EMPTY;                                                
                        gspFixAdm.ASC_LOB__c += gspsRec.Lob_Dental__c ?LOB_DENTAL:STRING_EMPTY;                                                
                        gspFixAdm.ASC_LOB__c += gspsRec.Lob_Drug__c ?LOB_DRUG:STRING_EMPTY;                                                
                        gspFixAdm.ASC_LOB__c += gspsRec.Lob_Vision__c ?LOB_VISION:STRING_EMPTY;                                                                            
                        gspFixAdm.ASC_LOB__c += gspsRec.Facility_Foreign_LOB__c ?LOB_FACILITY_FOREIGN:STRING_EMPTY;                        
                        gspFixAdm.ASC_LOB__c += gspsRec.Facility_Domestic_LOB__c ?LOB_FACILITY_DOMESTIC:STRING_EMPTY;                        
                        gspFixAdm.ASC_HiPS_Funding_Arrangement__c = gspsRec.Asc_Funding_Arrangement__c;                                                                                                 
                        resultList.add(gspFixAdm);
                     }
                     else{   
                        /*US-3112 - Added By Dinesh -Start  update Deleted flag to true when product critera is null or false*/
                        if(existingUniqueKeySet.get(uniqueKey) !=null){
                          gspFixAdmDupF.Id = existingUniqueKeySet.get(uniqueKey);
                          gspFixAdmDupF.ASC_Deleted__c = true;                        
                          resultList.add(gspFixAdmDupF);
                        }
                        /*US-3112 - Added By Dinesh -End*/
                     }
                 }
                 if(gspsProductMap.ContainsKey(ADMINFEEPERCENTCLAIMS_FIELD)){
                    String uniqueKey = gspsRec.CID__c+UNDERSCORE+gspsRec.Carrier__c+UNDERSCORE+
                                       gspsRec.Effective_Date__c+UNDERSCORE+gspsRec.Effective_End_Date__c+
                                       UNDERSCORE+VARADMINFEE_PRDCODE;
                 
                     if(gspsRec.Admin_Fee_Percent_Of_Claims__c !=null || gspsRec.AAC_Variable_Not_Lt_Pcpm__c !=null){
                                          
                        String uniqueKeyLineItemInfo = gspsRec.CID__c+UNDERSCORE+gspsRec.Carrier__c+UNDERSCORE+VARADMINFEE_PRDCODE;
    
                        gspVarAdm = new ASC_Group_Specific_Pricing__c();
                        gspVarAdm.Id = existingUniqueKeySet.get(uniqueKey);
                        gspVarAdm.ASC_Group_Specific_Pricing_Staging_ID__c = gspsRec.Id;
                        gspVarAdm.RecordTypeId = getRecordTypeIdByName(RECTYPE_VARIABLEADMINFEE);
                        gspVarAdm.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspVarAdm.ASC_Product__c = prdIdMap.get(gspsProductMap.get(ADMINFEEPERCENTCLAIMS_FIELD));   
                        gspVarAdm.ASC_Carrier__c = gspsRec.Carrier__c;
                        gspVarAdm.ASC_Effective_Date__c = gspsRec.Effective_Date__c;
                        gspVarAdm.ASC_Effective_End_Date__c = gspsRec.Effective_End_Date__c;
                        gspVarAdm.ASC_Platform__c = gspsRec.Platform__c;
                        gspVarAdm.ASC_Percent_of_Claims__c = gspsRec.Admin_Fee_Percent_Of_Claims__c;
                        gspVarAdm.ASC_Unit_Price_Not_GT__c = gspsRec.AAC_Variable_Not_Gt_Pcpm__c;
                        gspVarAdm.ASC_Unit_Price_Not_LT__c = gspsRec.AAC_Variable_Not_Lt_Pcpm__c;
                        gspVarAdm.ASC_Estimated_Monthly_Contracts__c = gspsRec.Estimated_Monthly_Contracts__c;
                        gspVarAdm.ASC_Unit_Price__c = gspsRec.Additional_Admin_Compensation__c;
                        gspVarAdm.ASC_CRED_CLMS__c = gspsRec.Cred_Clms__c;
                        gspVarAdm.ASC_CRED_CLMS_Facility__c = gspsRec.Cred_Clms_Facility__c;                    
                        gspVarAdm.ASC_Data_Source__c = SOURCE_HIPS;
                        gspVarAdm.ASC_LOB__c = LOBEMPTY_STR;
                        gspVarAdm.ASC_LOB__c += gspsRec.Lob_Facility__c ?LOB_FACILITY:STRING_EMPTY;                                                
                        gspVarAdm.ASC_LOB__c += gspsRec.Lob_Professional__c ?LOB_PROFESSIONAL:STRING_EMPTY;                                                
                        gspVarAdm.ASC_LOB__c += gspsRec.Lob_Dental__c ?LOB_DENTAL:STRING_EMPTY;                                                
                        gspVarAdm.ASC_LOB__c += gspsRec.Lob_Drug__c ?LOB_DRUG:STRING_EMPTY;                                                
                        gspVarAdm.ASC_LOB__c += gspsRec.Lob_Vision__c ?LOB_VISION:STRING_EMPTY;                                                                            
                        gspVarAdm.ASC_LOB__c += gspsRec.Facility_Foreign_LOB__c ?LOB_FACILITY_FOREIGN:STRING_EMPTY;                        
                        gspVarAdm.ASC_LOB__c += gspsRec.Facility_Domestic_LOB__c ?LOB_FACILITY_DOMESTIC:STRING_EMPTY;                                                
                        gspVarAdm.AAC_PCNT__c = cLIMap.ContainsKey(uniqueKeyLineItemInfo) && cLIMap.get(uniqueKeyLineItemInfo).ASC_Line_Item_Extension__r.AAC_PCNT__c !=null ?cLIMap.get(uniqueKeyLineItemInfo).ASC_Line_Item_Extension__r.AAC_PCNT__c:AAC_PCNT;
                        gspVarAdm.ASC_HiPS_Funding_Arrangement__c = gspsRec.Asc_Funding_Arrangement__c;
                        resultList.add(gspVarAdm);
                     }
                     else{
                       /*US-3112 - Added By Dinesh -Start  update Deleted flag to true when product critera is null or false*/
                        if(existingUniqueKeySet.get(uniqueKey) !=null){
                          gspVarAdmDupF.Id = existingUniqueKeySet.get(uniqueKey);
                          gspVarAdmDupF.ASC_Deleted__c = true;                        
                          resultList.add(gspVarAdmDupF);
                        }
                        /*US-3112 - Added By Dinesh -End*/
                     }
                }
                
                if(gspsProductMap.ContainsKey(SPECIFIC_SL_INS_FIELD)){
                    String uniqueKey = gspsRec.CID__c+UNDERSCORE+gspsRec.Carrier__c+
                                       UNDERSCORE+gspsRec.Effective_Date__c+UNDERSCORE+
                                       gspsRec.Effective_End_Date__c+
                                       UNDERSCORE+SPECIFIC_SL_INS_PRDCODE;
                 
                    if(gspsRec.Specific_Sl_Ins__c){                                                    
                        
                        String uniqueKeyLineItemInfo = gspsRec.CID__c+UNDERSCORE+gspsRec.Carrier__c+
                                                       UNDERSCORE+SPECIFIC_SL_INS_PRDCODE;                        
                        gspSLIns = new ASC_Group_Specific_Pricing__c();
                        gspSLIns.Id = existingUniqueKeySet.get(uniqueKey);
                        gspSLIns.ASC_Group_Specific_Pricing_Staging_ID__c = gspsRec.Id;
                        gspSLIns.RecordTypeId = getRecordTypeIdByName(RECTYPE_SPECIFICSTOPLOSS);
                        gspSLIns.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspSLIns.ASC_Product__c = prdIdMap.get(gspsProductMap.get(SPECIFIC_SL_INS_FIELD));    
                        gspSLIns.ASC_Carrier__c = gspsRec.Carrier__c;
                        gspSLIns.ASC_Effective_Date__c = gspsRec.Effective_Date__c;
                        gspSLIns.ASC_Effective_End_Date__c = gspsRec.Effective_End_Date__c;
                        gspSLIns.ASC_Platform__c = gspsRec.Platform__c;
                        gspSLIns.ASC_Estimated_Monthly_Contracts__c = gspsRec.Spec_Sl_Current_Coverage_Units__c;
                        gspSLIns.ASC_Attachment_Point__c = gspsRec.Specific_Indv_Attachment_Point__c;
                        gspSLIns.ASC_Unit_Price__c = gspsRec.Specific_Premium_Rate_Pc__c;                         
                        gspSLIns.ASC_Data_Source__c = SOURCE_HIPS;                        
                        gspSLIns.ASC_SL_LOB__c = gspsRec.Ssl_Medical_Claims_Opd__c ?SL_LOB_VAL_MED_OP:gspsRec.Ssl_Medical_Claims__c ?SL_LOB_VAL_MED:STRING_EMPTY;                       
                        gspSLIns.Aggregating_Deductible__c = gspsRec.Agg_Spec_Ded_Amount__c;
                        gspSLIns.Claims_Covered__c = CC_RENEWALEXISTINGCOV;
                        gspSLIns.ASC_LOB__c = LOBEMPTY_STR;
                        gspSLIns.ASC_LOB__c += gspsRec.Lob_Facility__c ?LOB_FACILITY:STRING_EMPTY;                                                
                        gspSLIns.ASC_LOB__c += gspsRec.Lob_Professional__c ?LOB_PROFESSIONAL:STRING_EMPTY;                                                
                        gspSLIns.ASC_LOB__c += gspsRec.Lob_Dental__c ?LOB_DENTAL:STRING_EMPTY;                                                
                        gspSLIns.ASC_LOB__c += gspsRec.Lob_Drug__c ?LOB_DRUG:STRING_EMPTY;                                                
                        gspSLIns.ASC_LOB__c += gspsRec.Lob_Vision__c ?LOB_VISION:STRING_EMPTY;                                                                            
                        gspSLIns.ASC_LOB__c += gspsRec.Facility_Foreign_LOB__c ?LOB_FACILITY_FOREIGN:STRING_EMPTY;                        
                        gspSLIns.ASC_LOB__c += gspsRec.Facility_Domestic_LOB__c ?LOB_FACILITY_DOMESTIC:STRING_EMPTY;                        
                        gspSLIns.ASC_HiPS_Funding_Arrangement__c = gspsRec.Asc_Funding_Arrangement__c;
                        resultList.add(gspSLIns);
                     }
                     else{
                        /*US-3112 - Added By Dinesh -Start  update Deleted flag to true when product critera is null or false*/
                        if(existingUniqueKeySet.get(uniqueKey) !=null){
                          gspSLInsDupF.Id = existingUniqueKeySet.get(uniqueKey);
                          gspSLInsDupF.ASC_Deleted__c = true;                        
                          resultList.add(gspSLInsDupF);
                        }
                        /*US-3112 - Added By Dinesh -End*/
                     }
                 }
                  
                 if(gspsProductMap.ContainsKey(AGG_SL_INS_FIELD)){
                    String uniqueKey = gspsRec.CID__c+UNDERSCORE+gspsRec.Carrier__c+UNDERSCORE+
                                       gspsRec.Effective_Date__c+UNDERSCORE+gspsRec.Effective_End_Date__c+
                                       UNDERSCORE+AGG_SL_INS_PRDCODE;

                     if(gspsRec.Agg_Sl_Ins__c){
                                                                        
                        gspAggSL = new ASC_Group_Specific_Pricing__c();
                        gspAggSL.Id = existingUniqueKeySet.get(uniqueKey);
                        gspAggSL.ASC_Group_Specific_Pricing_Staging_ID__c = gspsRec.Id;
                        gspAggSL.RecordTypeId = getRecordTypeIdByName(RECTYPE_AGGRSTOPLOSS);
                        gspAggSL.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspAggSL.ASC_Product__c = prdIdMap.get(gspsProductMap.get(AGG_SL_INS_FIELD));                                        
                        gspAggSL.ASC_Carrier__c = gspsRec.Carrier__c;
                        gspAggSL.ASC_Effective_Date__c = gspsRec.Effective_Date__c;
                        gspAggSL.ASC_Effective_End_Date__c = gspsRec.Effective_End_Date__c;
                        gspAggSL.ASC_Platform__c = gspsRec.Platform__c;
                        gspAggSL.ASC_Attachment_Point__c = gspsRec.Aggregate_Attachment_Point__c;
                        gspAggSL.ASC_Unit_Price__c = gspsRec.Agg_Premium_Rate_Pc__c;
                        gspAggSL.ASC_Estimated_Monthly_Contracts__c = gspsRec.Agg_Sl_Current_Coverage_Units__c;
                        gspAggSL.ASC_Percent_of_Claims__c = gspsRec.Agg_Pcnt__c;                    
                        gspAggSL.ASC_Data_Source__c = SOURCE_HIPS;
                        gspAggSL.ASC_SL_LOB__c = gspsRec.Agg_Medical_Claims_Opd__c ?SL_LOB_VAL_MED_OP:gspsRec.Agg_Medical_Claims__c ?SL_LOB_VAL_MED:STRING_EMPTY;                       
                        gspAggSL.Claims_Covered__c = CC_RENEWALEXISTINGCOV;
                        gspAggSL.ASC_LOB__c = LOBEMPTY_STR;
                        gspAggSL.ASC_LOB__c += gspsRec.Lob_Facility__c ?LOB_FACILITY:STRING_EMPTY;                                                
                        gspAggSL.ASC_LOB__c += gspsRec.Lob_Professional__c ?LOB_PROFESSIONAL:STRING_EMPTY;                                                
                        gspAggSL.ASC_LOB__c += gspsRec.Lob_Dental__c ?LOB_DENTAL:STRING_EMPTY;                                                
                        gspAggSL.ASC_LOB__c += gspsRec.Lob_Drug__c ?LOB_DRUG:STRING_EMPTY;                                                
                        gspAggSL.ASC_LOB__c += gspsRec.Lob_Vision__c ?LOB_VISION:STRING_EMPTY;                                                                            
                        gspAggSL.ASC_LOB__c += gspsRec.Facility_Foreign_LOB__c ?LOB_FACILITY_FOREIGN:STRING_EMPTY;                        
                        gspAggSL.ASC_LOB__c += gspsRec.Facility_Domestic_LOB__c ?LOB_FACILITY_DOMESTIC:STRING_EMPTY;                        
                        gspAggSL.ASC_HiPS_Funding_Arrangement__c = gspsRec.Asc_Funding_Arrangement__c;
                        gspAggSL.ASC_Aggregate_Min_Attachment_Point__c = gspsRec.Minimum_Agg_Attach_Point__c;
                        resultList.add(gspAggSL);
                     }
                     else{
                      /*US-3112 - Added By Dinesh -Start  update Deleted flag to true when product critera is null or false*/
                        if(existingUniqueKeySet.get(uniqueKey) !=null){
                          gspAggSLDupF.Id = existingUniqueKeySet.get(uniqueKey);
                          gspAggSLDupF.ASC_Deleted__c = true;                        
                          resultList.add(gspAggSLDupF);
                        }
                       /*US-3112 - Added By Dinesh -End*/
                     }
                 }   
                 
                 if(gspsProductMap.ContainsKey(FINANCECHARGE_FIELD)){
                     String uniqueKey = gspsRec.CID__c+UNDERSCORE+gspsRec.Carrier__c+UNDERSCORE+
                                        gspsRec.Effective_Date__c+UNDERSCORE+gspsRec.Effective_End_Date__c+
                                        UNDERSCORE+FINANCECHARGE_PRDCODE;
    
                     if(gspsRec.Finance_Charge__c !=null){                                                                                                                                 
                                              
                        gspFncf = new ASC_Group_Specific_Pricing__c();
                        gspFncf.Id = existingUniqueKeySet.get(uniqueKey);
                        gspFncf.ASC_Group_Specific_Pricing_Staging_ID__c = gspsRec.Id;
                        gspFncf.RecordTypeId = getRecordTypeIdByName(RECTYPE_FINANCECHRGFEE);
                        gspFncf.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspFncf.ASC_Product__c = prdIdMap.get(gspsProductMap.get(FINANCECHARGE_FIELD));    
                        gspFncf.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspFncf.ASC_Carrier__c = gspsRec.Carrier__c;
                        gspFncf.ASC_Effective_Date__c = gspsRec.Effective_Date__c;
                        gspFncf.ASC_Effective_End_Date__c = gspsRec.Effective_End_Date__c;
                        gspFncf.ASC_Platform__c = gspsRec.Platform__c;
                        gspFncf.ASC_Unit_Price__c = gspsRec.Finance_Charge__c;
                        gspFncf.ASC_Estimated_Monthly_Contracts__c = gspsRec.Estimated_Monthly_Contracts__c;
                        gspFncf.ASC_Data_Source__c = SOURCE_HIPS;
                        gspFncf.ASC_LOB__c = LOBEMPTY_STR;
                        gspFncf.ASC_LOB__c += gspsRec.Lob_Facility__c ?LOB_FACILITY:STRING_EMPTY;                                                
                        gspFncf.ASC_LOB__c += gspsRec.Lob_Professional__c ?LOB_PROFESSIONAL:STRING_EMPTY;                                                
                        gspFncf.ASC_LOB__c += gspsRec.Lob_Dental__c ?LOB_DENTAL:STRING_EMPTY;                                                
                        gspFncf.ASC_LOB__c += gspsRec.Lob_Drug__c ?LOB_DRUG:STRING_EMPTY;                                                
                        gspFncf.ASC_LOB__c += gspsRec.Lob_Vision__c ?LOB_VISION:STRING_EMPTY;                                                                            
                        gspFncf.ASC_LOB__c += gspsRec.Facility_Foreign_LOB__c ?LOB_FACILITY_FOREIGN:STRING_EMPTY;                        
                        gspFncf.ASC_LOB__c += gspsRec.Facility_Domestic_LOB__c ?LOB_FACILITY_DOMESTIC:STRING_EMPTY;                        
                        gspFncf.ASC_HiPS_Funding_Arrangement__c = gspsRec.Asc_Funding_Arrangement__c;
                        resultList.add(gspFncf);                                                                                                                          
                     }
                     else{
                      /*US-3112 - Added By Dinesh -Start  update Deleted flag to true when product critera is null or false*/
                        if(existingUniqueKeySet.get(uniqueKey) !=null){
                          gspFncfDupF.Id = existingUniqueKeySet.get(uniqueKey);
                          gspFncfDupF.ASC_Deleted__c = true;                        
                          resultList.add(gspFncfDupF);
                        }
                       /*US-3112 - Added By Dinesh -End*/
                     }                     
                 }       
                 
                 if(gspsProductMap.ContainsKey(HOSP_ADV_DEP_FIELD)){
                    String uniqueKey = gspsRec.CID__c+UNDERSCORE+gspsRec.Carrier__c+UNDERSCORE+
                                       gspsRec.Effective_Date__c+UNDERSCORE+gspsRec.Effective_End_Date__c+
                                       UNDERSCORE+HOSP_ADV_DEP_PRDCODE;
                                        
                     if(gspsRec.Hosp_Adv_Dep__c !=null || gspsRec.K_Adv_Deposit__c !=null){                                                    
                                                     
                        gspDep = new ASC_Group_Specific_Pricing__c();
                        gspDep.Id = existingUniqueKeySet.get(uniqueKey);
                        gspDep.ASC_Group_Specific_Pricing_Staging_ID__c = gspsRec.Id;
                        gspDep.RecordTypeId = getRecordTypeIdByName(RECTYPE_DEPOSITS);
                        gspDep.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspDep.ASC_Product__c = prdIdMap.get(gspsProductMap.get(HOSP_ADV_DEP_FIELD));       
                        gspDep.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspDep.ASC_Carrier__c = gspsRec.Carrier__c;
                        gspDep.ASC_Effective_Date__c = gspsRec.Effective_Date__c;
                        gspDep.ASC_Effective_End_Date__c = gspsRec.Effective_End_Date__c;
                        gspDep.ASC_Platform__c = gspsRec.Platform__c;
                        gspDep.ASC_Hosp_Ad_Dep__c = gspsRec.Hosp_Adv_Dep__c;
                        gspDep.ASC_K_Adv_Deposit__c = gspsRec.K_Adv_Deposit__c;
                        //gspDep.ASC_Monthly_Cap_Amount__c = gspsRec.Monthly_Cap_Amount__c; // commented as part of US#3665 and Req#3819
                        gspDep.ASC_Advance_Days__c = NO_OFF_ADV_DAYS;
                        gspDep.ASC_Data_Source__c = SOURCE_HIPS;
                        gspDep.ASC_LOB__c = LOBEMPTY_STR;
                        gspDep.ASC_LOB__c += gspsRec.Lob_Facility__c ?LOB_FACILITY:STRING_EMPTY;                                                
                        gspDep.ASC_LOB__c += gspsRec.Lob_Professional__c ?LOB_PROFESSIONAL:STRING_EMPTY;                                                
                        gspDep.ASC_LOB__c += gspsRec.Lob_Dental__c ?LOB_DENTAL:STRING_EMPTY;                                                
                        gspDep.ASC_LOB__c += gspsRec.Lob_Drug__c ?LOB_DRUG:STRING_EMPTY;                                                
                        gspDep.ASC_LOB__c += gspsRec.Lob_Vision__c ?LOB_VISION:STRING_EMPTY;                                                                            
                        gspDep.ASC_LOB__c += gspsRec.Facility_Foreign_LOB__c ?LOB_FACILITY_FOREIGN:STRING_EMPTY;                        
                        gspDep.ASC_LOB__c += gspsRec.Facility_Domestic_LOB__c ?LOB_FACILITY_DOMESTIC:STRING_EMPTY;                        
                        gspDep.ASC_HiPS_Funding_Arrangement__c = gspsRec.Asc_Funding_Arrangement__c;
                        resultList.add(gspDep);                                                                                                                             
                     }
                     else{
                      /*US-3112 - Added By Dinesh -Start  update Deleted flag to true when product critera is null or false*/
                        if(existingUniqueKeySet.get(uniqueKey) !=null){
                          gspDepDupF.Id = existingUniqueKeySet.get(uniqueKey);
                          gspDepDupF.ASC_Deleted__c = true;                        
                          resultList.add(gspDepDupF);
                        }
                        /*US-3112 - Added By Dinesh -End*/
                     }
                 }
                 
                 if(gspsProductMap.ContainsKey(TPA_STOP_LOSS_VENDORFEE_FIELD)){
                    String uniqueKey = gspsRec.CID__c+UNDERSCORE+gspsRec.Carrier__c+UNDERSCORE+
                                       gspsRec.Effective_Date__c+UNDERSCORE+gspsRec.Effective_End_Date__c+
                                       UNDERSCORE+TPA_STOP_LOSS_VENDORFEE_PRDCODE;
                                       
                     if(gspsRec.Tpa_Stop_Loss_Vendor_Fee__c !=null){                                                    
                        
                        gspSLOpt = new ASC_Group_Specific_Pricing__c();
                        gspSLOpt.Id = existingUniqueKeySet.get(uniqueKey);
                        gspSLOpt.ASC_Group_Specific_Pricing_Staging_ID__c = gspsRec.Id;
                        gspSLOpt.RecordTypeId = getRecordTypeIdByName(RECTYPE_STOPLOSSOPTOUT);
                        gspSLOpt.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspSLOpt.ASC_Product__c = prdIdMap.get(gspsProductMap.get(TPA_STOP_LOSS_VENDORFEE_FIELD)); 
                        gspSLOpt.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspSLOpt.ASC_Carrier__c = gspsRec.Carrier__c;
                        gspSLOpt.ASC_Effective_Date__c = gspsRec.Effective_Date__c;
                        gspSLOpt.ASC_Effective_End_Date__c = gspsRec.Effective_End_Date__c;
                        gspSLOpt.ASC_Platform__c = gspsRec.Platform__c;
                        gspSLOpt.ASC_Unit_Price__c = gspsRec.Tpa_Stop_Loss_Vendor_Fee__c;  
                        gspSLOpt.ASC_Estimated_Monthly_Contracts__c = gspsRec.Estimated_Monthly_Contracts__c;                                                  
                        gspSLOpt.ASC_Data_Source__c = SOURCE_HIPS;
                        gspSLOpt.ASC_LOB__c = LOBEMPTY_STR;
                        gspSLOpt.ASC_LOB__c += gspsRec.Lob_Facility__c ?LOB_FACILITY:STRING_EMPTY;                                                
                        gspSLOpt.ASC_LOB__c += gspsRec.Lob_Professional__c ?LOB_PROFESSIONAL:STRING_EMPTY;                                                
                        gspSLOpt.ASC_LOB__c += gspsRec.Lob_Dental__c ?LOB_DENTAL:STRING_EMPTY;                                                
                        gspSLOpt.ASC_LOB__c += gspsRec.Lob_Drug__c ?LOB_DRUG:STRING_EMPTY;                                                
                        gspSLOpt.ASC_LOB__c += gspsRec.Lob_Vision__c ?LOB_VISION:STRING_EMPTY;                                                                            
                        gspSLOpt.ASC_LOB__c += gspsRec.Facility_Foreign_LOB__c ?LOB_FACILITY_FOREIGN:STRING_EMPTY;                        
                        gspSLOpt.ASC_LOB__c += gspsRec.Facility_Domestic_LOB__c ?LOB_FACILITY_DOMESTIC:STRING_EMPTY;                        
                        gspSLOpt.ASC_HiPS_Funding_Arrangement__c = gspsRec.Asc_Funding_Arrangement__c;
                        resultList.add(gspSLOpt);    
                     }
                     else{
                     /*US-3112 - Added By Dinesh -Start  update Deleted flag to true when product critera is null or false*/
                        if(existingUniqueKeySet.get(uniqueKey) !=null){
                          gspSLOptDupF.Id = existingUniqueKeySet.get(uniqueKey);
                          gspSLOptDupF.ASC_Deleted__c = true;                        
                          resultList.add(gspSLOptDupF);
                        }
                        /*US-3112 - Added By Dinesh -End*/
                     }
                 }
                 
                 if(gspsProductMap.ContainsKey(ADDITIONAL_ADMIN_COMP_FIELD)){
                    String uniqueKey = gspsRec.CID__c+UNDERSCORE+gspsRec.Carrier__c+UNDERSCORE+
                                       gspsRec.Effective_Date__c+UNDERSCORE+gspsRec.Effective_End_Date__c+
                                       UNDERSCORE+ADDITIONAL_ADMIN_COMP_PRDCODE;
                                       
                     if(gspsRec.Additional_Admin_Compensation__c !=null){     
                                                                       
                        gspAAC = new ASC_Group_Specific_Pricing__c();
                        gspAAC.Id = existingUniqueKeySet.get(uniqueKey);
                        gspAAC.ASC_Group_Specific_Pricing_Staging_ID__c = gspsRec.Id;
                        gspAAC.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADMINCOMPFEES);
                        gspAAC.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspAAC.ASC_Product__c = prdIdMap.get(gspsProductMap.get(ADDITIONAL_ADMIN_COMP_FIELD)); 
                        gspAAC.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspAAC.ASC_Carrier__c = gspsRec.Carrier__c;
                        gspAAC.ASC_Effective_Date__c = gspsRec.Effective_Date__c;
                        gspAAC.ASC_Effective_End_Date__c = gspsRec.Effective_End_Date__c;
                        gspAAC.ASC_Platform__c = gspsRec.Platform__c;
                        gspAAC.ASC_Unit_Price__c = gspsRec.Additional_Admin_Compensation__c;  
                        gspAAC.ASC_Estimated_Monthly_Contracts__c = gspsRec.Estimated_Monthly_Contracts__c;                                                  
                        gspAAC.ASC_Data_Source__c = SOURCE_HIPS;
                        gspAAC.ASC_LOB__c = LOBEMPTY_STR;
                        gspAAC.ASC_LOB__c += gspsRec.Lob_Facility__c ?LOB_FACILITY:STRING_EMPTY;                                                
                        gspAAC.ASC_LOB__c += gspsRec.Lob_Professional__c ?LOB_PROFESSIONAL:STRING_EMPTY;                                                
                        gspAAC.ASC_LOB__c += gspsRec.Lob_Dental__c ?LOB_DENTAL:STRING_EMPTY;                                                
                        gspAAC.ASC_LOB__c += gspsRec.Lob_Drug__c ?LOB_DRUG:STRING_EMPTY;                                                
                        gspAAC.ASC_LOB__c += gspsRec.Lob_Vision__c ?LOB_VISION:STRING_EMPTY;                                                                            
                        gspAAC.ASC_LOB__c += gspsRec.Facility_Foreign_LOB__c ?LOB_FACILITY_FOREIGN:STRING_EMPTY;                        
                        gspAAC.ASC_LOB__c += gspsRec.Facility_Domestic_LOB__c ?LOB_FACILITY_DOMESTIC:STRING_EMPTY;                        
                        gspAAC.ASC_HiPS_Funding_Arrangement__c = gspsRec.Asc_Funding_Arrangement__c;
                        resultList.add(gspAAC);
                     }
                     else{
                     /*US-3112 - Added By Dinesh -Start  update Deleted flag to true when product critera is null or false*/
                        if(existingUniqueKeySet.get(uniqueKey) !=null){
                          gspAACDupF.Id = existingUniqueKeySet.get(uniqueKey);
                          gspAACDupF.ASC_Deleted__c = true;                        
                          resultList.add(gspAACDupF);
                        }
                        /*US-3112 - Added By Dinesh -End*/
                     }
                 }
                 /*US-3665 Added By Dinesh - GSP record for Advance Deposit Monthly cap amount */
                 if(gspsProductMap.ContainsKey(ADVDEP_MONTHLYCAPAMOUNT_FIELD)){
                    String uniqueKey = gspsRec.CID__c+UNDERSCORE+gspsRec.Carrier__c+UNDERSCORE+
                                       gspsRec.Effective_Date__c+UNDERSCORE+gspsRec.Effective_End_Date__c+
                                       UNDERSCORE+ADVDEP_MONTHLYCAPAMOUNT_PRDCODE;
                                       
                     if(gspsRec.Monthly_Cap_Amount__c !=null){     
                                                                       
                        gspAdvDep = new ASC_Group_Specific_Pricing__c();
                        gspAdvDep.Id = existingUniqueKeySet.get(uniqueKey);
                        gspAdvDep.ASC_Group_Specific_Pricing_Staging_ID__c = gspsRec.Id;
                        gspAdvDep.RecordTypeId = getRecordTypeIdByName(RECTYPE_DEPOSITS);  //RecordType - Deposits
                        gspAdvDep.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspAdvDep.ASC_Product__c = prdIdMap.get(gspsProductMap.get(ADVDEP_MONTHLYCAPAMOUNT_FIELD)); 
                        gspAdvDep.ASC_Group__c = accIdMap.get(gspsRec.CID__c);                      
                        gspAdvDep.ASC_Carrier__c = gspsRec.Carrier__c;
                        gspAdvDep.ASC_Effective_Date__c = gspsRec.Effective_Date__c;
                        gspAdvDep.ASC_Effective_End_Date__c = gspsRec.Effective_End_Date__c;
                        gspAdvDep.ASC_Platform__c = gspsRec.Platform__c;
                        gspAdvDep.ASC_Monthly_Cap_Amount__c = gspsRec.Monthly_Cap_Amount__c; 
                        gspAdvDep.ASC_LOB__c = LOBEMPTY_STR;
                        gspAdvDep.ASC_LOB__c += gspsRec.Lob_Facility__c ?LOB_FACILITY:STRING_EMPTY;                                                
                        gspAdvDep.ASC_LOB__c += gspsRec.Lob_Professional__c ?LOB_PROFESSIONAL:STRING_EMPTY;                                                
                        gspAdvDep.ASC_LOB__c += gspsRec.Lob_Dental__c ?LOB_DENTAL:STRING_EMPTY;                                                
                        gspAdvDep.ASC_LOB__c += gspsRec.Lob_Drug__c ?LOB_DRUG:STRING_EMPTY;                                                
                        gspAdvDep.ASC_LOB__c += gspsRec.Lob_Vision__c ?LOB_VISION:STRING_EMPTY;                                                                            
                        gspAdvDep.ASC_LOB__c += gspsRec.Facility_Foreign_LOB__c ?LOB_FACILITY_FOREIGN:STRING_EMPTY;                        
                        gspAdvDep.ASC_LOB__c += gspsRec.Facility_Domestic_LOB__c ?LOB_FACILITY_DOMESTIC:STRING_EMPTY;                        
                        gspAdvDep.ASC_HiPS_Funding_Arrangement__c = gspsRec.Asc_Funding_Arrangement__c;
                        gspAdvDep.ASC_Data_Source__c = SOURCE_HIPS;
                        resultList.add(gspAdvDep);
                     }
                     else{
                     /*US-3112 - Added By Dinesh -Start  update Deleted flag to true when product critera is null or false*/
                        if(existingUniqueKeySet.get(uniqueKey) !=null){
                          gspAdvDepDupF.Id = existingUniqueKeySet.get(uniqueKey);
                          gspAdvDepDupF.ASC_Deleted__c = true;                        
                          resultList.add(gspAdvDepDupF);
                        }
                        /*US-3112 - Added By Dinesh -End*/
                     }
                 }
              }        
            }
            if(!resultList.isEmpty()){
                Upsert resultList;
            }                                                
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNME);
        }                    
    }    
    /******************************************************************************************************************************
    * @description       Method for returning Record Type Id by reading Name
    * @param             rTypeName the sObject record type name
    * @return            Id, recordTypeId of the given sObject
    * @throws            NA
    ******************************************************************************************************************************/
    @TestVisible
    private static Id getRecordTypeIdByName(String rTypeName){  
        return Schema.getGlobalDescribe().get(GSP_OBJNAME).getDescribe().getRecordTypeInfosByDeveloperName().get(rTypeName).getRecordTypeId();
    }                      
        
    /********************************************************************************************************************
    @Description        :   This method is used to validate the data coming from HiPS and send the error response back to HiPS System.                            
    @Name               :   validateGSPStagingRecords
    @Param              :   List<ASC_Group_Specific_Pricing_Staging__c> gspsList
    @Return             :   void
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/ 
    public static void validateGSPStagingRecords(List<ASC_Group_Specific_Pricing_Staging__c> gspsList) {
        List<Database.SaveResult> result = new List<Database.SaveResult>();
        Set<String> cid = new Set<String>();
        Set<String> cidValueSet = new Set<String>();
        try{        
            if(!gspsList.isEmpty()){                 
              for(ASC_Group_Specific_Pricing_Staging__c gspsRec:gspsList){
                cid.add(gspsRec.CID__c);
              }            
              for(Account acc:[Select Id,CID__c from Account where CID__c !=null
                                                                   AND RecordType.DeveloperName IN:ACCRECORDTYPESET 
                                                                   AND CID__c IN:cid
                                                                   Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                 cidValueSet.add(acc.CID__c);
              }           
              for(ASC_Group_Specific_Pricing_Staging__c gspsRec:gspsList){         
                  if(gspsRec.Effective_Date__c > gspsRec.Effective_End_Date__c){                                               
                     gspsRec.addError(ERRORMSG_EFFDATE);
                  }
                  if(!CARRIERVALUESET.Contains(gspsRec.Carrier__c)){              
                     gspsRec.addError(ERRORMSG_CARRIER);
                  }                                             
                  if(!PLATFORMVALUESET.Contains(gspsRec.Platform__c)){              
                     gspsRec.addError(ERRORMSG_PLATFORM);
                  }                                             
                  if(!cidValueSet.Contains(gspsRec.CID__c)){              
                     gspsRec.addError(ERRORMSG_CID);
                  }                                           
                  if(gspsRec.Carrier__c == null || STRING_EMPTY.equals(gspsRec.Carrier__c)){              
                     gspsRec.addError(ERRORMSG_CARRIERREQ);
                  }                                             
                  if(gspsRec.Effective_Date__c == null){              
                     gspsRec.addError(ERRORMSG_EFFDATEREQ);
                  }    
                  if(gspsRec.Effective_End_Date__c == null){              
                     gspsRec.addError(ERRORMSG_EFFENDDATEREQ);
                  }
              }                            
            }             
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNME_VALGSPSREC);
        }                    
    }            
}