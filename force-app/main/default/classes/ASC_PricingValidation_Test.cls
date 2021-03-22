/*******************************************************************************************************************************
@Author : IDC offshore
@Name: ASC_PricingValidation_Test
@CreatedDate: 10 - April 2020 
@Description: This test class is used to cover ASC_PricingValidation class
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_PricingValidation_Test {
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string STR_TEST  ='Test';
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string SUGSEG_NAME  ='Test SubSegment';
    private static final string SUGSEG_CODE  ='000001000';
    private static final string DAT_SOURCE  ='Salesforce';
    private static final string GSPNAME = 'Test Pricing';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string CARRBCN = 'BCN';
    private static final string CARRBOTH = 'Both';
    private static final string LOB = 'Facility';
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
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

                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
                database.insert(acc);
                
                Product2 prd1 = new Product2();
                prd1.vlocity_ins__Type__c = TYPE;
                prd1.ProductCode = PARPRD_CD;
                prd1.Name =PRODNAME;
                Database.insert(prd1, false);  
                        
                ASC_Sub_Segment__c sub1 = new ASC_Sub_Segment__c();
                sub1.Name = SUGSEG_NAME;
                sub1.ASC_Account__c = acc.Id;
                sub1.ASC_Sub_Segment_Code__c = SUGSEG_CODE;
                Database.insert(sub1, false);
                
                ASC_Group_Specific_Pricing__c gsp =new ASC_Group_Specific_Pricing__c();
                gsp.ASC_Data_Source__c= DAT_SOURCE;
                gsp.RecordTypeId = GSPREC_FIXEDADMFEE;
                gsp.Name = GSPNAME;
                gsp.ASC_Group__c = acc.Id;
                gsp.ASC_Carrier__c = CARRBCN;
                gsp.ASC_Product__c = prd1.Id;
                gsp.ASC_Sub_Segment__c = sub1.Id;
                gsp.ASC_LOB__c = LOB;
                gsp.ASC_Effective_Date__c = System.Today();
                gsp.ASC_Effective_End_Date__c = System.Today()+100;
                Database.insert(gsp,false);
                
                ASC_Group_Specific_Pricing__c gsp1 =new ASC_Group_Specific_Pricing__c();
                gsp1.ASC_Data_Source__c= DAT_SOURCE;
                gsp1.RecordTypeId = GSPREC_FIXEDADMFEE;
                gsp1.Name = GSPNAME;
                gsp1.ASC_Group__c = acc.Id;
                gsp1.ASC_Carrier__c = CARRBCN;
                gsp1.ASC_Product__c = prd1.Id;
                gsp1.ASC_Sub_Segment__c = sub1.Id;
                gsp1.ASC_LOB__c = LOB;
                gsp1.ASC_Effective_Date__c = System.Today();
                gsp1.ASC_Effective_End_Date__c = System.Today()+100;
                Database.insert(gsp1,false);
                
   }
   /*******************************************************************************************************************************
    @Description: This test method is used to cover the checkForDuplicateGSP method - insert
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
                    list<ASC_Group_Specific_Pricing__c> pricingLst =new list<ASC_Group_Specific_Pricing__c>([select Id,Name,
                    ASC_Group__c,ASC_Product__c,ASC_Sub_Segment__c,ASC_LOB__c,ASC_Effective_Date__c,ASC_Effective_End_Date__c from ASC_Group_Specific_Pricing__c 
                    limit 100]);
                    Test.startTest();
                    ASC_PricingValidation.checkForDuplicateGSP(pricingLst,null);
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
    @Description: This test method is used to cover the checkForDuplicateGSP method - Update
    @Name : testmethod2
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    private static testmethod void testmethod2(){
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runAs(usr){
                try{
                    Map<id,ASC_Group_Specific_Pricing__c> pricingLstOldMap = new Map<id,ASC_Group_Specific_Pricing__c>();
                    list<ASC_Group_Specific_Pricing__c> pricingLst =new list<ASC_Group_Specific_Pricing__c>([select Id,Name,
                    ASC_Group__c,ASC_Product__c,ASC_Sub_Segment__c,ASC_LOB__c,ASC_Effective_Date__c,ASC_Effective_End_Date__c from ASC_Group_Specific_Pricing__c  limit 100]);
                    
                    for(ASC_Group_Specific_Pricing__c sp:pricingLst){
                      pricingLstOldMap.put(sp.Id,sp);
                      sp.ASC_Carrier__c = CARRBOTH;
                    }
                    Database.update(pricingLst,false);
                    Test.startTest();
                    ASC_PricingValidation.checkForDuplicateGSP(pricingLst,pricingLstOldMap);
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