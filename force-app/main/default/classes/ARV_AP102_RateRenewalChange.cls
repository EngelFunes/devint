public without sharing class ARV_AP102_RateRenewalChange {
    private Id ContractId;
    private static final string IDSTRING = 'id';
    private static final string RATESQUERY='select Future_Contract__r.Account.Name,Future_Contract__r.Account.CID__c,Future_Contract__r.ARV_Requested_Effective_Date__c,Future_Contract__r.vlocity_ins__ExpiredContractId__r.ARV_Managing_Agent__r.Name,Future_Contract__r.vlocity_ins__ExpiredContractId__r.ARV_Agency_Name__c,Future_Contract__r.Account.ARV_Agent_Name__r.name,Future_Contract__r.vlocity_ins__ExpiredContractId__r.Renewal_Batch__r.createddate,Total_BCBSM_Billable_Members_Current__c,Total_BCBSM_Billable_Members_Future__c,Total_BCBSM_Med_Rx_Premium_Current__c,Total_BCBSM_Med_Rx_Premium_Future__c,Total_BCBSM_Dental_Premium_Current__c,Total_BCBSM_Dental_Premium_Future__c,Total_BCBSM_Vision_Premium_Current__c,Total_BCBSM_Vision_Premium_Future__c,Total_BCN_Billable_Members_Current__c,Total_BCN_Billable_Members_Future__c,Total_BCN_Med_Rx_Premium_Current__c,Total_BCN_Med_Rx_Premium_Future__c,Total_BCN_Dental_Premium_Current__c,Total_BCN_Dental_Premium_Future__c,Total_BCN_Vision_Premium_Current__c,Total_BCN_Vision_Premium_Future__c,Total_Billable_Members_Current__c,Total_Billable_Members_Future__c,Total_Med_Rx_Premium_Current__c,Total_Med_Rx_Premium_Future__c,Total_Dental_Premium_Current__c,Total_Dental_Premium_Future__c,Total_Vision_Premium_Current__c,Total_Vision_Premium_Future__c,BCBSM_Rate_Index_Medical__c,BCBSM_Rate_Index_Dental__c,BCBSM_Rate_Index_Vision__c,BCBSM_Medical_Product_Difference__c,BCBSM_Dental_Product_Difference__c,BCBSM_Vision_Product_Difference__c,BCBSM_Medical_Area__c,BCBSM_Dental_Area__c,BCBSM_Vision_Area__c,BCBSM_Medical_Age__c,BCBSM_Dental_Age__c,BCBSM_Vision_Age__c,BCBSM_Medical_Age_Change__c,BCBSM_Dental_Age_Change__c,BCBSM_Vision_Age_Change__c,BCBSM_Dependent_Cap_Medical__c,BCBSM_Dependent_Cap_Dental__c,BCBSM_Dependent_Cap_Vision__c,BCN_Medical_Index_Rate__c,BCN_Dental_Index_Rate__c,BCN_Vision_Index_Rate__c,BCN_Medical_Product_Difference__c,BCN_Dental_Product_Difference__c,BCN_Vision_Product_Difference__c,BCN_Medical_Area__c,BCN_Dental_Area__c,BCN_Vision_Area__c,BCN_Medical_Age__c,BCN_Dental_Age__c,BCN_Vision_Age__c,BCN_Age_Factor_Change_Medical__c,BCN_Age_Factor_Change_Dental__c,BCN_Age_Factor_Change_Vision__c,BCN_Dependent_Cap_Medical__c,BCN_Dependent_Cap_Dental__c,BCN_Dependent_Cap_Vision__c,BCN_Medical_Change__c,BCN_Dental_Change__c,BCN_Vision_Change__c,BCBSM_Medical_Change__c,BCBSM_Vision_Change__c,BCBSM_Dental_Change__c from Carrier_Rate_Comparison_';
    private static final string RATESWHERE=' where Future_Contract__c= :paramId1';
    private static final string LIMITCLAUSE  =' LIMIT 1';
    public List<Package__c> packageRec{get;set;}
    public List<Carrier_Rate_Comparison__c> rates{get;set;}
    public string effectiveDate{get;set;}
    public string medicalPlan{get;set;}
    public string dentalPlan{get;set;}
    public string visionPlan{get;set;} 
    public string createdDate{get;set;}
    public String carrierType{get;set;}
    public Decimal totalMonthlyBCBSMCurrent{get;set;}
    public String bcnMedRateIndx{get;set;}
    public Decimal totalMonthlyBCBSMRenewal{get;set;}
    public Decimal totalMonthlyBCNCurrent{get;set;}
    public Decimal totalMonthlyBCNRenewal{get;set;}
    public Decimal totalAnnualBCBSMCurrent{get;set;}
    public Decimal totalAnnualBCBSMRenewal{get;set;}
    public Decimal totalAnnualBCNRenewal{get;set;}
    public Decimal totalAnnualBCNCurrent{get;set;}
    public Decimal totalMonthlyRenewal{get;set;}
    public Decimal totalMonthlyCurrent{get;set;}
    public Decimal totalAnnualCurrent{get;set;}
    public Decimal totalAnnualRenewal{get;set;}
    public Decimal totalBCBSMMonthlyChange{get;set;}
    public Decimal totalBCNMonthlyChange{get;set;}
    public Decimal totalMonthlyChange{get;set;}
    public String medicalIndexRateBcn{get;set;}
    public String dentalIndexRateBcn{get;set;}
    public String visionIndexRateBcn{get;set;}
    public String medicalDifferenceBcn{get;set;}
    public String dentalDifferenceBcn{get;set;}
    public String visionDifferenceBcn{get;set;}
    public String medicalAreaBcn{get;set;}
    public String dentalAreaBcn{get;set;}
    public String visionAreaBcn{get;set;}
    public String medicalAgeBcn{get;set;}
    public String dentalAgeBcn{get;set;}
    public String visionAgeBcn{get;set;}
    public String medicalFactorBcn{get;set;}
    public String dentalFactorBcn{get;set;}
    public String visionFactorBcn{get;set;}
    public String medicalCapBcn{get;set;}
    public String dentalCapBcn{get;set;}
    public String visionCapBcn{get;set;}
    public String medicalIndexRateBcbs{get;set;}
    public String dentalIndexRateBcbs{get;set;}
    public String visionIndexRateBcbs{get;set;}
    public String medicalAreaBcbs{get;set;}
    public String dentalAreaBcbs{get;set;}
    public String visionAreaBcbs{get;set;}
    public String medicalAgeBcbs{get;set;}
    public String dentalAgeBcbs{get;set;}
    public String visionAgeBcbs{get;set;}
    public String medicalFactorBcbs{get;set;}
    public String dentalFactorBcbs{get;set;}
    public String visionFactorBcbs{get;set;}
    public String medicalCapBcbs{get;set;}
    public String dentalCapBcbs{get;set;}
    public String visionCapBcbs{get;set;}
     public String medicalDifferenceBcbs{get;set;}
    public String dentalDifferenceBcbs{get;set;}
    public String visionDifferenceBcbs{get;set;}
    public String medicalRateChangeBcn{get;set;}
    public String dentalRateChangeBcn{get;set;}
    public String visionRateChangeBcn{get;set;}
     public String medicalRateChangeBcbs{get;set;}
    public String dentalRateChangeBcbs{get;set;}
    public String visionRateChangeBcbs{get;set;}
    public ARV_AP102_RateRenewalChange(){   
        ContractId = ApexPages.currentPage().getParameters().get(IDSTRING);
    }
    
    public void getAccountData(){
        try{
        rates=new List<Carrier_Rate_Comparison__c>();
        packageRec=new List<Package__c>();
        effectiveDate = null;
        createdDate = null;
        packageRec=[select ARV_Medical_Plan__r.Name,ARV_Dental_Plan__r.Name,ARV_Vision_Plan__r.Name from Package__c where ARV_Contract_Id__c=:ContractId];
        medicalPlan=packageRec[0].ARV_Medical_Plan__r.Name;
        dentalPlan=packageRec[0].ARV_Dental_Plan__r.Name;
        visionPlan=packageRec[0].ARV_Vision_Plan__r.Name;    
        rates=[select Future_Contract__r.vlocity_ins__ExpiredContractId__r.ARV_Tech_Selected_Plans__c,Future_Contract__r.Account.Name,Future_Contract__r.Account.CID__c,Future_Contract__r.ARV_Requested_Effective_Date__c,Future_Contract__r.vlocity_ins__ExpiredContractId__r.ARV_Managing_Agent_Frm__c,Future_Contract__r.vlocity_ins__ExpiredContractId__r.ARV_Agency_Name__c,Future_Contract__r.vlocity_ins__ExpiredContractId__r.vlocity_ins__ProducerId__r.Name,Future_Contract__r.vlocity_ins__ExpiredContractId__r.Renewal_Batch__r.createddate,Total_BCBSM_Billable_Members_Current__c,Total_BCBSM_Billable_Members_Future__c,Total_BCBSM_Med_Rx_Premium_Current__c,Total_BCBSM_Med_Rx_Premium_Future__c,Total_BCBSM_Dental_Premium_Current__c,Total_BCBSM_Dental_Premium_Future__c,Total_BCBSM_Vision_Premium_Current__c,Total_BCBSM_Vision_Premium_Future__c,Total_BCN_Billable_Members_Current__c,Total_BCN_Billable_Members_Future__c,Total_BCN_Med_Rx_Premium_Current__c,Total_BCN_Med_Rx_Premium_Future__c,Total_BCN_Dental_Premium_Current__c,Total_BCN_Dental_Premium_Future__c,Total_BCN_Vision_Premium_Current__c,Total_BCN_Vision_Premium_Future__c,Total_Billable_Members_Current__c,Total_Billable_Members_Future__c,Total_Med_Rx_Premium_Current__c,Total_Med_Rx_Premium_Future__c,Total_Dental_Premium_Current__c,Total_Dental_Premium_Future__c,Total_Vision_Premium_Current__c,Total_Vision_Premium_Future__c,BCBSM_Rate_Index_Medical__c,BCBSM_Rate_Index_Dental__c,BCBSM_Rate_Index_Vision__c,BCBSM_Medical_Product_Difference__c,BCBSM_Dental_Product_Difference__c,BCBSM_Vision_Product_Difference__c,BCBSM_Medical_Area__c,BCBSM_Dental_Area__c,BCBSM_Vision_Area__c,BCBSM_Medical_Age__c,BCBSM_Dental_Age__c,BCBSM_Vision_Age__c,BCBSM_Age_Factor_Change_Medical__c,BCBSM_Age_Factor_Change_Dental__c,BCBSM_Age_Factor_Change_Vision__c,BCBSM_Dependent_Cap_Medical__c,BCBSM_Dependent_Cap_Dental__c,BCBSM_Dependent_Cap_Vision__c,BCN_Medical_Index_Rate__c,BCN_Dental_Index_Rate__c,BCN_Vision_Index_Rate__c,BCN_Medical_Product_Difference__c,BCN_Dental_Product_Difference__c,BCN_Vision_Product_Difference__c,BCN_Medical_Area__c,BCN_Dental_Area__c,BCN_Vision_Area__c,BCN_Medical_Age__c,BCN_Dental_Age__c,BCN_Vision_Age__c,BCN_Age_Factor_Change_Medical__c,BCN_Age_Factor_Change_Dental__c,BCN_Age_Factor_Change_Vision__c,BCN_Dependent_Cap_Medical__c,BCN_Dependent_Cap_Dental__c,BCN_Dependent_Cap_Vision__c,BCN_Medical_Change__c,BCN_Dental_Change__c,BCN_Vision_Change__c,BCBSM_Medical_Change__c,BCBSM_Vision_Change__c,BCBSM_Dental_Change__c from Carrier_Rate_Comparison__c where Future_Contract__c=:ContractId limit 1];
        effectiveDate =rates[0].Future_Contract__r.ARV_Requested_Effective_Date__c.month()
            +ARV_AP41_StringLiteralUtils.SLASH+rates[0].Future_Contract__r.ARV_Requested_Effective_Date__c.day()
            +ARV_AP41_StringLiteralUtils.SLASH+rates[0].Future_Contract__r.ARV_Requested_Effective_Date__c.year();
        if(rates[0].Future_Contract__r.vlocity_ins__ExpiredContractId__r.Renewal_Batch__r.createddate != null){
            createdDate =rates[0].Future_Contract__r.vlocity_ins__ExpiredContractId__r.Renewal_Batch__r.createddate.month()
                +ARV_AP41_StringLiteralUtils.SLASH+rates[0].Future_Contract__r.vlocity_ins__ExpiredContractId__r.Renewal_Batch__r.createddate.day()
                +ARV_AP41_StringLiteralUtils.SLASH+rates[0].Future_Contract__r.vlocity_ins__ExpiredContractId__r.Renewal_Batch__r.createddate.year(); 
        }
       
        medicalIndexRateBcn=rates[0].BCN_Medical_Index_Rate__c!=null?(rates[0].BCN_Medical_Index_Rate__c*100).setscale(2)+'%':'0.00%';
        dentalIndexRateBcn=rates[0].BCN_Dental_Index_Rate__c!=null && rates[0].Total_BCN_Dental_Premium_Current__c > 0?(rates[0].BCN_Dental_Index_Rate__c*100).setscale(2)+'%':'0.00%';
        visionIndexRateBcn=rates[0].BCN_Vision_Index_Rate__c!=null && !visionPlan.contains('Pediatric')?(rates[0].BCN_Vision_Index_Rate__c*100).setscale(2)+'%':'0.00%';
        medicalDifferenceBcn=rates[0].BCN_Medical_Product_Difference__c!=null?(rates[0].BCN_Medical_Product_Difference__c).setscale(2)+'%':'0.00%';
        dentalDifferenceBcn=rates[0].BCN_Dental_Product_Difference__c!=null && rates[0].Total_BCN_Dental_Premium_Current__c > 0?(rates[0].BCN_Dental_Product_Difference__c).setscale(2)+'%':'0.00%';
        visionDifferenceBcn=rates[0].BCN_Vision_Product_Difference__c!=null && !visionPlan.contains('Pediatric')?(rates[0].BCN_Vision_Product_Difference__c).setscale(2)+'%':'0.00%';
        medicalAreaBcn=rates[0].BCN_Medical_Area__c!=null?(rates[0].BCN_Medical_Area__c*100).setscale(2)+'%':'0.00%';
        dentalAreaBcn=rates[0].BCN_Dental_Area__c!=null && rates[0].Total_BCN_Dental_Premium_Current__c > 0?(rates[0].BCN_Dental_Area__c*100).setscale(2)+'%':'0.00%';
        visionAreaBcn=rates[0].BCN_Vision_Area__c!=null  && !visionPlan.contains('Pediatric')?(rates[0].BCN_Vision_Area__c*100).setscale(2)+'%':'0.00%';
        medicalAgeBcn=rates[0].BCN_Medical_Age__c!=null?(rates[0].BCN_Medical_Age__c*100).setscale(2)+'%':'0.00%';
        dentalAgeBcn=rates[0].BCN_Dental_Age__c!=null && rates[0].Total_BCN_Dental_Premium_Current__c > 0?(rates[0].BCN_Dental_Age__c*100).setscale(2)+'%':'0.00%';
        visionAgeBcn=rates[0].BCN_Vision_Age__c!=null  && !visionPlan.contains('Pediatric')?(rates[0].BCN_Vision_Age__c*100).setscale(2)+'%':'0.00%';
        medicalFactorBcn=rates[0].BCN_Age_Factor_Change_Medical__c!=null?(rates[0].BCN_Age_Factor_Change_Medical__c*100).setscale(2)+'%':'0.00%';
        dentalFactorBcn=rates[0].BCN_Age_Factor_Change_Dental__c!=null && rates[0].Total_BCN_Dental_Premium_Current__c > 0?(rates[0].BCN_Age_Factor_Change_Dental__c*100).setscale(2)+'%':'0.00%';
        visionFactorBcn=rates[0].BCN_Age_Factor_Change_Vision__c!=null  && !visionPlan.contains('Pediatric')?(rates[0].BCN_Age_Factor_Change_Vision__c*100).setscale(2)+'%':'0.00%';
        medicalCapBcn=rates[0].BCN_Dependent_Cap_Medical__c!=null?(rates[0].BCN_Dependent_Cap_Medical__c*100).setscale(2)+'%':'0.00%';
        dentalCapBcn=rates[0].BCN_Dependent_Cap_Dental__c!=null && rates[0].Total_BCN_Dental_Premium_Current__c > 0?(rates[0].BCN_Dependent_Cap_Dental__c*100).setscale(2)+'%':'0.00%';
        visionCapBcn=rates[0].BCN_Dependent_Cap_Vision__c!=null  && !visionPlan.contains('Pediatric')?(rates[0].BCN_Dependent_Cap_Vision__c*100).setscale(2)+'%':'0.00%';
          medicalIndexRateBcbs=rates[0].BCBSM_Rate_Index_Medical__c!=null?(rates[0].BCBSM_Rate_Index_Medical__c*100).setscale(2)+'%':'0.00%';
        dentalIndexRateBcbs=rates[0].BCBSM_Rate_Index_Dental__c!=null && rates[0].Total_BCBSM_Dental_Premium_Current__c > 0?(rates[0].BCBSM_Rate_Index_Dental__c*100).setscale(2)+'%':'0.00%';
        visionIndexRateBcbs=rates[0].BCBSM_Rate_Index_Vision__c!=null  && !visionPlan.contains('Pediatric')?(rates[0].BCBSM_Rate_Index_Vision__c*100).setscale(2)+'%':'0.00%';
        medicalDifferenceBcbs=rates[0].BCBSM_Medical_Product_Difference__c!=null?(rates[0].BCBSM_Medical_Product_Difference__c).setscale(2)+'%':'0.00%';
        dentalDifferenceBcbs=rates[0].BCBSM_Dental_Product_Difference__c!=null && rates[0].Total_BCBSM_Dental_Premium_Current__c > 0?(rates[0].BCBSM_Dental_Product_Difference__c).setscale(2)+'%':'0.00%';
        visionDifferenceBcbs=rates[0].BCBSM_Vision_Product_Difference__c!=null && !visionPlan.contains('Pediatric')?(rates[0].BCBSM_Vision_Product_Difference__c).setscale(2)+'%':'0.00%';
        medicalAreaBcbs=rates[0].BCBSM_Medical_Area__c!=null?(rates[0].BCBSM_Medical_Area__c*100).setscale(2)+'%':'0.00%';
        dentalAreaBcbs=rates[0].BCBSM_Dental_Area__c!=null && rates[0].Total_BCBSM_Dental_Premium_Current__c > 0?(rates[0].BCBSM_Dental_Area__c*100).setscale(2)+'%':'0.00%';
        visionAreaBcbs=rates[0].BCBSM_Vision_Area__c!=null  && !visionPlan.contains('Pediatric')?(rates[0].BCBSM_Vision_Area__c*100).setscale(2)+'%':'0.00%';
        medicalAgeBcbs=rates[0].BCBSM_Medical_Age__c!=null?(rates[0].BCBSM_Medical_Age__c*100).setscale(2)+'%':'0.00%';
        dentalAgeBcbs=rates[0].BCBSM_Dental_Age__c!=null && rates[0].Total_BCBSM_Dental_Premium_Current__c > 0?(rates[0].BCBSM_Dental_Age__c*100).setscale(2)+'%':'0.00%';
        visionAgeBcbs=rates[0].BCBSM_Vision_Age__c!=null  && !visionPlan.contains('Pediatric')?(rates[0].BCBSM_Vision_Age__c*100).setscale(2)+'%':'0.00%';
        medicalFactorBcbs=rates[0].BCBSM_Age_Factor_Change_Medical__c!=null?(rates[0].BCBSM_Age_Factor_Change_Medical__c*100).setscale(2)+'%':'0.00%';
        dentalFactorBcbs=rates[0].BCBSM_Age_Factor_Change_Dental__c!=null && rates[0].Total_BCBSM_Dental_Premium_Current__c > 0?(rates[0].BCBSM_Age_Factor_Change_Dental__c*100).setscale(2)+'%':'0.00%';
        visionFactorBcbs=rates[0].BCBSM_Age_Factor_Change_Vision__c!=null  && !visionPlan.contains('Pediatric')?(rates[0].BCBSM_Age_Factor_Change_Vision__c*100).setscale(2)+'%':'0.00%';
        medicalCapBcbs=rates[0].BCBSM_Dependent_Cap_Medical__c!=null?(rates[0].BCBSM_Dependent_Cap_Medical__c*100).setscale(2)+'%':'0.00%';
        dentalCapBcbs=rates[0].BCBSM_Dependent_Cap_Dental__c!=null && rates[0].Total_BCBSM_Dental_Premium_Current__c > 0?(rates[0].BCBSM_Dependent_Cap_Dental__c*100).setscale(2)+'%':'0.00%';
        visionCapBcbs=rates[0].BCBSM_Dependent_Cap_Vision__c!=null  && !visionPlan.contains('Pediatric')?(rates[0].BCBSM_Dependent_Cap_Vision__c*100).setscale(2)+'%':'0.00%'; 
        medicalRateChangeBcn=rates[0].BCN_Medical_Change__c!=null?(rates[0].BCN_Medical_Change__c).setscale(2)+'%':'0.00%';
        dentalRateChangeBcn=rates[0].BCN_Dental_Change__c!=null && rates[0].Total_BCN_Dental_Premium_Current__c > 0?(rates[0].BCN_Dental_Change__c).setscale(2)+'%':'0.00%';
        visionRateChangeBcn=rates[0].BCN_Vision_Change__c!=null  && !visionPlan.contains('Pediatric')?(rates[0].BCN_Vision_Change__c).setscale(2)+'%':'0.00%';
        medicalRateChangeBcbs=rates[0].BCBSM_Medical_Change__c!=null?(rates[0].BCBSM_Medical_Change__c).setscale(2)+'%':'0.00%';
        dentalRateChangeBcbs=rates[0].BCBSM_Dental_Change__c!=null && rates[0].Total_BCBSM_Dental_Premium_Current__c > 0?(rates[0].BCBSM_Dental_Change__c).setscale(2)+'%':'0.00%';
        visionRateChangeBcbs=rates[0].BCBSM_Vision_Change__c!=null  && !visionPlan.contains('Pediatric')?(rates[0].BCBSM_Vision_Change__c).setscale(2)+'%':'0.00%'; 
        totalMonthlyBCBSMCurrent=rates[0].Total_BCBSM_Med_Rx_Premium_Current__c+rates[0].Total_BCBSM_Dental_Premium_Current__c+rates[0].Total_BCBSM_Vision_Premium_Current__c;
        totalMonthlyBCBSMRenewal=rates[0].Total_BCBSM_Med_Rx_Premium_Future__c+rates[0].Total_BCBSM_Dental_Premium_Future__c+rates[0].Total_BCBSM_Vision_Premium_Future__c; 
        totalMonthlyBCNCurrent=rates[0].Total_BCN_Med_Rx_Premium_Current__c+rates[0].Total_BCN_Dental_Premium_Current__c+rates[0].Total_BCN_Vision_Premium_Current__c;
        totalMonthlyBCNRenewal=rates[0].Total_BCN_Med_Rx_Premium_Future__c+rates[0].Total_BCN_Dental_Premium_Future__c+rates[0].Total_BCN_Vision_Premium_Future__c; 
        totalMonthlyCurrent=totalMonthlyBCBSMCurrent+totalMonthlyBCNCurrent;
        totalMonthlyRenewal=totalMonthlyBCBSMRenewal+totalMonthlyBCNRenewal;
        totalAnnualBCBSMCurrent=totalMonthlyBCBSMCurrent*12;
        totalAnnualBCBSMRenewal=totalMonthlyBCBSMRenewal*12;
        totalAnnualBCNCurrent=totalMonthlyBCNCurrent*12;
        totalAnnualBCNRenewal=totalMonthlyBCNRenewal*12;
        totalAnnualCurrent=totalMonthlyCurrent*12;
        totalAnnualRenewal=totalMonthlyRenewal*12;
        totalBCBSMMonthlyChange=totalMonthlyBCBSMCurrent!=0?math.abs(((totalMonthlyBCBSMRenewal-totalMonthlyBCBSMCurrent)/totalMonthlyBCBSMCurrent)*100).setscale(2):0;
        totalBCNMonthlyChange=totalMonthlyBCNCurrent!=0?math.abs((((totalMonthlyBCNRenewal-totalMonthlyBCNCurrent)/totalMonthlyBCNCurrent)*100)).setscale(2):0;
        totalMonthlyChange=totalMonthlyCurrent!=0?math.abs((((totalMonthlyRenewal-totalMonthlyCurrent)/totalMonthlyCurrent)*100)).setscale(2):0;
        
       }catch(Exception e){
                 GA_LogExceptionCls.LogExcp(e, 'ARV_AP102_RateRenewalChange', e.getlinenumber()+'');
    
            } 
    }
    
}