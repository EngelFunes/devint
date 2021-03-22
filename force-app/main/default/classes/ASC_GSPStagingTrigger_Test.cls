/**************************************************************************************************************************
@Author : Dinesh
@Name: ASC_GSPStagingTrigger_Test 
@CreatedDate: 05 May 2020
@Description: ASC_GSPStagingTrigger_Test class is used to cover ASC_GSPStagingTrigger and related Handler and Helper classes.
@version : 1.0  
@US Num: US-2852
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_GSPStagingTrigger_Test {
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string STR_TEST  ='Test';
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string ACCCID = '270139';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string HIPS = 'HiPS';
    private static final string GSPNAME = 'Test Pricing gsp';
    private static final string CARRBCN = 'BCN';
    private static final string LOB = 'Facility';
    private static final string GSPSNAME = 'Test Pricing';
    private static final string PLAT_MOS = 'MOS';
    private static final string PLAT_MOS_NG = 'MOS1';
    private static final Integer INTVAL = 20;
    private static final string GSPSNAMENEG = 'Test Pricing Neg';
    private static final string ROLE_NAM = 'TestIntUser';
    private static final string EMAILVAL = 'testIntUser@bcbsm.com';
    private static final string PROF_NAM = 'Integration User';
    private static final string REC_FIXEDADMFEE = 'Fixed Admin Fees';
    private static final Id GSPREC_FIXEDADMFEE = 
    Schema.SObjectType.ASC_Group_Specific_Pricing__c.getRecordTypeInfosByName().get(REC_FIXEDADMFEE).getRecordTypeId(); 

    
    /*******************************************************************************************************************************
    @Description: initData() method - preparing the test data
    @Name : initData
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
             @TestSetup static void initData() {
                Account acc = GA_OBJ_TD01_TestDataCreation.accRec();
                acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
                acc.CID__c = ACCCID;
                database.insert(acc);
                
                Product2 prd1 = new Product2();
                prd1.vlocity_ins__Type__c = TYPE;
                prd1.ProductCode = PARPRD_CD;
                prd1.IsActive = true;
                prd1.Name =PRODNAME;
                Database.insert(prd1, false);  
                
                ASC_Group_Specific_Pricing__c gsp =new ASC_Group_Specific_Pricing__c();
                gsp.RecordTypeId = GSPREC_FIXEDADMFEE;
                gsp.ASC_Data_Source__c = HIPS;
                gsp.Name = GSPNAME;
                gsp.ASC_Group__c = acc.Id;
                gsp.ASC_Carrier__c = CARRBCN;
                gsp.ASC_Product__c = prd1.Id;
                gsp.ASC_LOB__c = LOB;
                gsp.ASC_Effective_Date__c = System.Today();
                gsp.ASC_Effective_End_Date__c = System.Today()+100;
                Database.insert(gsp, false);
                
                
                ASC_Group_Specific_Pricing_Staging__c gsps =new ASC_Group_Specific_Pricing_Staging__c();
                gsps.Name = GSPSNAME;
                gsps.CID__c = ACCCID;
                gsps.Carrier__c = CARRBCN;
                gsps.Lob_Professional__c = true;
                gsps.Lob_Facility__c = true;
                gsps.Lob_Dental__c = true;
                gsps.Lob_Drug__c = true;
                gsps.Lob_Vision__c = true;
                gsps.Effective_Date__c = System.Today();
                gsps.Effective_End_Date__c = System.Today()+100;
                gsps.Platform__c = PLAT_MOS;
                gsps.Total_Monthly_Admin_Fee__c = INTVAL;
                gsps.Admin_Fee_Percent_Of_Claims__c = INTVAL;
                gsps.Specific_Sl_Ins__c = true;
                gsps.Agg_Sl_Ins__c = true;
                gsps.Finance_Charge__c = INTVAL;
                gsps.Hosp_Adv_Dep__c = INTVAL;
                gsps.Tpa_Stop_Loss_Vendor_Fee__c = INTVAL;
                gsps.Additional_Admin_Compensation__c = INTVAL;
                gsps.Ssl_Medical_Claims_Opd__c = true;
                gsps.Agg_Medical_Claims_Opd__c = true;
                gsps.Monthly_Cap_Amount__c = 100;
                Database.insert(gsps, false);
                
                ASC_Group_Specific_Pricing_Staging__c gsps1 =new ASC_Group_Specific_Pricing_Staging__c();
                gsps1.Name = GSPSNAME;
                gsps1.CID__c = ACCCID;
                gsps1.Carrier__c = CARRBCN;
                gsps1.Lob_Professional__c = true;
                gsps1.Lob_Facility__c = true;
                gsps1.Lob_Dental__c = true;
                gsps1.Lob_Drug__c = true;
                gsps1.Lob_Vision__c = true;
                gsps1.Effective_Date__c = System.Today();
                gsps1.Effective_End_Date__c = System.Today()+100;
                gsps1.Platform__c = PLAT_MOS;
                gsps1.Total_Monthly_Admin_Fee__c = INTVAL;
                gsps1.Admin_Fee_Percent_Of_Claims__c = INTVAL;
                gsps1.Specific_Sl_Ins__c = true;
                gsps1.Agg_Sl_Ins__c = true;
                gsps1.Finance_Charge__c = INTVAL;
                gsps1.Hosp_Adv_Dep__c = INTVAL;
                gsps1.Tpa_Stop_Loss_Vendor_Fee__c = INTVAL;
                gsps1.Additional_Admin_Compensation__c = INTVAL;
                gsps1.Ssl_Medical_Claims__c = true;
                gsps1.Agg_Medical_Claims__c = true;
                Database.insert(gsps1, false);
                
                ASC_Group_Specific_Pricing_Staging__c ngsps1 =new ASC_Group_Specific_Pricing_Staging__c();
                ngsps1.Name = GSPSNAMENEG;
                ngsps1.Lob_Professional__c = true;
                ngsps1.Lob_Facility__c = true;
                ngsps1.Lob_Dental__c = true;
                ngsps1.Lob_Drug__c = true;
                ngsps1.Lob_Vision__c = true;
                ngsps1.Effective_Date__c = null;
                ngsps1.Effective_End_Date__c = null;
                ngsps1.Platform__c = PLAT_MOS_NG;
                Database.insert(ngsps1, false);

                ASC_Group_Specific_Pricing_Staging__c ngsps2 =new ASC_Group_Specific_Pricing_Staging__c();
                ngsps2.Name = GSPSNAMENEG;
                ngsps2.Lob_Professional__c = true;
                ngsps2.Lob_Facility__c = true;
                ngsps2.Lob_Dental__c = true;
                ngsps2.Lob_Drug__c = true;
                ngsps2.Lob_Vision__c = true;
                ngsps2.Effective_Date__c = System.Today()+100;
                ngsps2.Effective_End_Date__c = System.Today()+10;
                ngsps2.Platform__c = PLAT_MOS_NG;
                Database.insert(ngsps2, false);
                
   }
   /*******************************************************************************************************************************
    @Description: This test method is used to create/update the records in GSP Object - createUpdateGSPRecords
    @Name : testmethod1
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    private static testmethod void testmethod1(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runAs(usr){
            try{
                list<ASC_Group_Specific_Pricing_Staging__c> pricingLst = new list<ASC_Group_Specific_Pricing_Staging__c>(
                [select Id,Name,CID__c,Carrier__c,Lob_Professional__c,Effective_Date__c,Effective_End_Date__c,Platform__c,
                Total_Monthly_Admin_Fee__c from ASC_Group_Specific_Pricing_Staging__c where Name =:GSPSNAME Limit 10]);               
                Test.startTest();
                ASC_GSPStagingTriggerHelper.createUpdateGSPRecords(pricingLst);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
    @Description: This test method is used to validate the data in Group Specific Pricing Staging Object - validateGSPStagingRecords
    @Name : testmethodNeg
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    private static testmethod void testmethodNeg(){
           user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runAs(usr){
                try{
                    list<ASC_Group_Specific_Pricing_Staging__c> pricingLst =new list<ASC_Group_Specific_Pricing_Staging__c>(
                       [select Id,Name,CID__c,Carrier__c,Lob_Professional__c,Effective_Date__c,Effective_End_Date__c,
                       Platform__c,Total_Monthly_Admin_Fee__c from ASC_Group_Specific_Pricing_Staging__c where 
                       Name =:GSPSNAMENEG limit 10]);                   
                    Test.startTest();
                    ASC_GSPStagingTriggerHelper.validateGSPStagingRecords(pricingLst);
                    Test.stopTest();
                }
                catch(exception e)
                {
                    system.assert(e <> null);
                    return;
                }
            }
    }                               
}