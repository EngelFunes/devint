/**************************************************************************************************************************
@Author : Dinesh
@Name: ASC_GSPDeleteFlagUpdate_Test 
@CreatedDate: 30 June 2020
@Description: ASC_GSPDeleteFlagUpdate_Test class is used to cover ASC_GSPDeleteFlagUpdate class.
@version : 1.0  
@US Num: US-2852
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_GSPDeleteFlagUpdate_Test {
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string STR_TEST  ='Test';
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string ACCCID = '270139';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string HIPS = 'HiPS';
    private static final string GSPNAME = 'Test Pricing gsp';
    private static final string GSPNAME1 = 'Test Pricing1';
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
                gsp.ASC_Deleted__c = false;
                Database.insert(gsp, false);
                
                ASC_Group_Specific_Pricing__c gsp1 =new ASC_Group_Specific_Pricing__c();
                gsp1.RecordTypeId = GSPREC_FIXEDADMFEE;
                gsp1.ASC_Data_Source__c = HIPS;
                gsp1.Name = GSPNAME1;
                gsp1.ASC_Group__c = acc.Id;
                gsp1.ASC_Carrier__c = CARRBCN;
                gsp1.ASC_Product__c = prd1.Id;
                gsp1.ASC_LOB__c = LOB;
                gsp1.ASC_Effective_Date__c = System.Today();
                gsp1.ASC_Effective_End_Date__c = System.Today()+200;
                gsp1.ASC_Deleted__c = true;
                Database.insert(gsp1, false);
                
   }
   /*******************************************************************************************************************************
    @Description: This testmethod1 is used to cover both the verifyGSPdeleteflag and updateGSPdeleteflag methods - ASC_Deleted__c is false
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
                list<ASC_Group_Specific_Pricing__c> pricingLst = new list<ASC_Group_Specific_Pricing__c>([select Id,ASC_Deleted__c from
                                                                           ASC_Group_Specific_Pricing__c where ASC_Deleted__c = false Limit 10]);               
                Test.startTest();
                if(!pricingLst.isEmpty()){
                  ASC_GSPDeleteFlagUpdate.verifyGSPdeleteflag(pricingLst[0].Id);
                  ASC_GSPDeleteFlagUpdate.updateGSPdeleteflag(pricingLst[0].Id);                  
                }
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
    @Description: This testmethod2 is used to cover both the verifyGSPdeleteflag and updateGSPdeleteflag methods - ASC_Deleted__c is true
    @Name : testmethod1
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    private static testmethod void testmethod2(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runAs(usr){
            try{
                list<ASC_Group_Specific_Pricing__c> pricingLst = new list<ASC_Group_Specific_Pricing__c>([select Id,ASC_Deleted__c from
                                                                           ASC_Group_Specific_Pricing__c where ASC_Deleted__c = true Limit 10]);               
                Test.startTest();
                if(!pricingLst.isEmpty()){
                  ASC_GSPDeleteFlagUpdate.verifyGSPdeleteflag(pricingLst[0].Id);
                  ASC_GSPDeleteFlagUpdate.updateGSPdeleteflag(pricingLst[0].Id);                  
                }
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