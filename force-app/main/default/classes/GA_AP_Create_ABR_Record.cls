/**
@Author : Prasant Kumar Satpathy
@Name: GA_AP_Create_ABR_Record
@CreatedDate: 7 - June 2018 
@Description: GA_AP_Create_ABR_Record class is creating Account Benifit Review list in Account record page.
@version : 1.0  
*/
public class GA_AP_Create_ABR_Record 
{
    public static final string ClsName  ='GA_AP_Create_ABR_Record';
    public static final string methodNmefetchpickValues  ='fetchpickValues';
    public static final string ErrorMsg = 'ABR records not created';
     public static final string excepSepartr = ' : ';
/**
@Description: fetchpickValues() method 
@Name : fetchpickValues
@Param : N/A
@Return : slectOptionsCls
@throws Exception : N/A;
*/ 
    @AuraEnabled
    public static slectOptionsCls fetchpickValues()
    {
        try
        {
            slectOptionsCls slctOptions=new slectOptionsCls();
            sObject sObj = Schema.getGlobalDescribe().get('GA_Account_Benefit_Review__c').newSObject() ;
            slctOptions.ABRType = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_ABR_Type__c');
            slctOptions.AccntType = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_Account_Type__c');
            slctOptions.ActRequested = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_Action_Requested__c');
            slctOptions.DrgChng = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_Drug_Change_With_GWC__c');
            slctOptions.FrthQutr = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_Fourth_Quarter_Carryover__c');
            slctOptions.LOBsImp = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_LOBs_Impacted__c');
            slctOptions.PerfGurnt = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_Performance_Guarantees__c');
            slctOptions.PrirDeductble = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_Prior_Deductible__c');
            slctOptions.PrdLinsImp = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_Product_Lines_Impacted__c');
            slctOptions.RatngTyp = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_Rating_Type__c');
            slctOptions.Retroctv = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_Retroactive__c');
            slctOptions.RFPReq = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_RFP_Required__c');
            slctOptions.ShrtLed = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_Short_Lead__c');
            slctOptions.Stats = GA_AP06_fetchPicklistValues.getselectOptions(sObj, 'GA_Status__c');
            return slctOptions;
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmefetchpickValues);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    
    public class slectOptionsCls
    {
        @AuraEnabled
        public list<string> ABRType;
        @AuraEnabled
        public list<string> AccntType;
        @AuraEnabled
        public list<string> ActRequested;
        @AuraEnabled
        public list<string> DrgChng ;
        @AuraEnabled
        public list<string> FrthQutr ;
        @AuraEnabled
        public list<string> LOBsImp ;
        @AuraEnabled
        public list<string> PerfGurnt ;
        @AuraEnabled
        public list<string> PrirDeductble ;
        @AuraEnabled
        public list<string> PrdLinsImp ;
        @AuraEnabled
        public list<string> RatngTyp ;
        @AuraEnabled
        public list<string> Retroctv ;
        @AuraEnabled
        public list<string> RFPReq ;
        @AuraEnabled
        public list<string> ShrtLed ;
        @AuraEnabled
        public list<string> Stats ;
    }
}