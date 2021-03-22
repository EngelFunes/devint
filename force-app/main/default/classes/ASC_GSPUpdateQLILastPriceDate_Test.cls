/**************************************************************************************************************************
@Author : Bhanu
@Name: ASC_GSPUpdateQLILastPriceDate_Test
@CreatedDate: 10 May 2020
@Description: ASC_GSPUpdateQLILastPriceDate_Test is used to cover ASC_GSPUpdateQLILastPriceDate and related Handler and Helper classes.
@version : 1.0  
@US Num: US-2955
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_GSPUpdateQLILastPriceDate_Test{

    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string NAME='TEST';
    private static final string OPP_STAG = 'Quote Request';
    private static final string ASC_OPPRECTYPE = 'Opportunity - ASC';
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final Id QTRECORDTYPEID =
    Schema.SObjectType.Quote.getRecordTypeInfosByName().get(ASC_QTRECTYPE).getRecordTypeId();   
    private static final string QTNAME = 'test quote';
    private static final Integer QUANTY_LI = 2;
    private static final Integer UNIT_PRICE = 1;            
    
    private static final string STR_TEST  ='Test';
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string ACCCID = '270139';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string PARPRD_CD_1 = 'ASC_0000370';
    private static final string PARPRD_CD_2 = 'ASC_0000415';
    private static final string PARPRD_CD_3 = 'ASC_0000159';
    private static final string PARPRD_CD_4 = 'ASC_0000006';
    private static final string PARPRD_CD_5 = 'ASC_0000004';
    private static final string PARPRD_CD_6 = 'ASC_0000078';
    private static final string PARPRD_CD_7 = 'ASC_0000014';
    private static final string PARPRD_CD_8 = 'ASC_0000007';
    private static final string PARPRD_CD_9 = 'ASC_0000164';
    private static final string PARPRD_CD_10 = 'ASC_0000166';
    private static final string PARPRD_CD_11 = 'ASC_0000167';
    private static final string PARPRD_CD_12 = 'ASC_0000168';
    private static final string PARPRD_CD_13 = 'ASC_0000169';
    private static final string PARPRD_CD_14 = 'ASC_0000170';
    private static final string PARPRD_CD_15 = 'ASC_0000171';
    private static final string PARPRD_CD_16 = 'ASC_0000172';
    private static final string PARPRD_CD_17 = 'ASC_0000346';
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
    private static final string RECTYPE_FIXEDADMINFEE = 'ASC_Fixed_Admin_Fees';
    private static final String RECTYPE_VARIABLEADMINFEE = 'ASC_Variable_Administrative_Fees';
    private static final String RECTYPE_SPECIFICSTOPLOSS = 'ASC_Specific_Stop_Loss';
    private static final String RECTYPE_AGGRSTOPLOSS = 'ASC_Aggregate_Stop_Loss';
    private static final String RECTYPE_FINANCECHRGFEE = 'ASC_Finance_Charge_Fees';
    private static final String RECTYPE_DEPOSITS = 'ASC_Deposits';
    private static final String RECTYPE_STOPLOSSOPTOUT = 'ASC_Stop_Loss_Opt_Out';
    private static final String RECTYPE_ADMINCOMPFEES = 'ASC_Administrative_Comp_Fees';
    private static final String RECTYPE_ADHOCADMINFEES = 'ASC_Adhoc_Admin_Fees_Products';
    private static final String RECTYPE_ADHOCSTOPLOSS = 'ASC_Adhoc_Stop_Loss_Products';
    private static final String GSP_OBJNAME = 'ASC_Group_Specific_Pricing__c';

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

        Product2 prd2 = new Product2();
        prd2.vlocity_ins__Type__c = TYPE;
        prd2.ProductCode = PARPRD_CD_1;
        prd2.IsActive = true;
        prd2.Name =PRODNAME;
        Database.insert(prd2, false); 

        Product2 prd3 = new Product2();
        prd3.vlocity_ins__Type__c = TYPE;
        prd3.ProductCode = PARPRD_CD_2;
        prd3.IsActive = true;
        prd3.Name =PRODNAME;
        Database.insert(prd3, false); 
        
        Product2 prd4 = new Product2();
        prd4.vlocity_ins__Type__c = TYPE;
        prd4.ProductCode = PARPRD_CD_3;
        prd4.IsActive = true;
        prd4.Name =PRODNAME;
        Database.insert(prd4, false); 

        Product2 prd5 = new Product2();
        prd5.vlocity_ins__Type__c = TYPE;
        prd5.ProductCode = PARPRD_CD_4;
        prd5.IsActive = true;
        prd5.Name =PRODNAME;
        Database.insert(prd5, false); 

        Product2 prd6 = new Product2();
        prd6.vlocity_ins__Type__c = TYPE;
        prd6.ProductCode = PARPRD_CD_5;
        prd6.IsActive = true;
        prd6.Name =PRODNAME;
        Database.insert(prd6, false); 

        Product2 prd7 = new Product2();
        prd7.vlocity_ins__Type__c = TYPE;
        prd7.ProductCode = PARPRD_CD_6;
        prd7.IsActive = true;
        prd7.Name =PRODNAME;
        Database.insert(prd7, false); 

        Product2 prd8 = new Product2();
        prd8.vlocity_ins__Type__c = TYPE;
        prd8.ProductCode = PARPRD_CD_7;
        prd8.IsActive = true;
        prd8.Name =PRODNAME;
        Database.insert(prd8, false); 

        Product2 prd9 = new Product2();
        prd9.vlocity_ins__Type__c = TYPE;
        prd9.ProductCode = PARPRD_CD_8;
        prd9.IsActive = true;
        prd9.Name =PRODNAME;
        Database.insert(prd9, false); 


        Product2 prd10 = new Product2();
        prd10.vlocity_ins__Type__c = TYPE;
        prd10.ProductCode = PARPRD_CD_9;
        prd10.IsActive = true;
        prd10.Name =PRODNAME;
        Database.insert(prd10, false); 

        Product2 prd11 = new Product2();
        prd11.vlocity_ins__Type__c = TYPE;
        prd11.ProductCode = PARPRD_CD_10;
        prd11.IsActive = true;
        prd11.Name =PRODNAME;
        Database.insert(prd11, false); 

        Product2 prd12 = new Product2();
        prd12.vlocity_ins__Type__c = TYPE;
        prd12.ProductCode = PARPRD_CD_11;
        prd12.IsActive = true;
        prd12.Name =PRODNAME;
        Database.insert(prd12, false); 

        Product2 prd13 = new Product2();
        prd13.vlocity_ins__Type__c = TYPE;
        prd13.ProductCode = PARPRD_CD_12;
        prd13.IsActive = true;
        prd13.Name =PRODNAME;
        Database.insert(prd13, false); 

        Product2 prd14 = new Product2();
        prd14.vlocity_ins__Type__c = TYPE;
        prd14.ProductCode = PARPRD_CD_13;
        prd14.IsActive = true;
        prd14.Name =PRODNAME;
        Database.insert(prd14, false); 

        Product2 prd15 = new Product2();
        prd15.vlocity_ins__Type__c = TYPE;
        prd15.ProductCode = PARPRD_CD_14;
        prd15.IsActive = true;
        prd15.Name =PRODNAME;
        Database.insert(prd15, false); 

        Product2 prd16 = new Product2();
        prd16.vlocity_ins__Type__c = TYPE;
        prd16.ProductCode = PARPRD_CD_15;
        prd16.IsActive = true;
        prd16.Name =PRODNAME;
        Database.insert(prd16, false); 


        Product2 prd17 = new Product2();
        prd17.vlocity_ins__Type__c = TYPE;
        prd17.ProductCode = PARPRD_CD_16;
        prd17.IsActive = true;
        prd17.Name =PRODNAME;
        Database.insert(prd17, false); 

        Product2 prd18 = new Product2();
        prd18.vlocity_ins__Type__c = TYPE;
        prd18.ProductCode = PARPRD_CD_17;
        prd18.IsActive = true;
        prd18.Name =PRODNAME;
        Database.insert(prd18, false); 

        opportunity opp=new opportunity();
        opp.Name = NAME;
        opp.AccountId = acc.id;
        opp.stageName = OPP_STAG;
        opp.CloseDate = system.today()+120;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ASC_OPPRECTYPE).getRecordTypeId();
        Database.insert(opp,false);

        Id pricebookId = Test.getStandardPricebookId();            
        Quote quot = new Quote();
        quot.Name = QTNAME;
        quot.opportunityId = Opp.Id;
        quot.pricebook2Id = pricebookId;
        quot.RecordTypeId = QTRECORDTYPEID;
        quot.ASC_CID__c = ACCCID;
        quot.ASC_Carrier__c = CARRBCN;
        Database.insert(quot,false);

        pricebookEntry prc=new pricebookEntry ();
        prc.product2Id = prd2.Id;
        prc.Pricebook2Id = pricebookId;
        prc.UnitPrice = UNIT_PRICE;
        prc.isActive = true;
        Database.insert(prc,false);

        QuoteLineItem qli=new QuoteLineItem();
        qli.QuoteId = quot.Id;
        qli.product2Id = prd2.Id;
        qli.UnitPrice = UNIT_PRICE ;
        qli.Quantity = QUANTY_LI;
        qli.pricebookentryid = prc.Id;
        qli.ASC_Effective_Start_Date__c = System.Today();
        qli.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(qli,false);            

        ASC_Group_Specific_Pricing__c gsp2 =new ASC_Group_Specific_Pricing__c();
        gsp2.RecordTypeId = getRecordTypeIdByName(RECTYPE_VARIABLEADMINFEE);
        gsp2.ASC_Data_Source__c = HIPS;
        gsp2.Name = GSPSNAMENEG;
        gsp2.ASC_Group__c = acc.Id;
        gsp2.ASC_Carrier__c = CARRBCN;
        gsp2.ASC_Product__c = prd2.Id;
        gsp2.ASC_LOB__c = LOB;
        gsp2.ASC_Effective_Date__c = System.Today();
        gsp2.ASC_Effective_End_Date__c = System.Today()+100;
        gsp2.ASC_Group__c = acc.Id;
        Database.insert(gsp2, false);


        ASC_Group_Specific_Pricing__c gsp =new ASC_Group_Specific_Pricing__c();
        gsp.RecordTypeId = getRecordTypeIdByName(RECTYPE_FIXEDADMINFEE);
        gsp.ASC_Data_Source__c = HIPS;
        gsp.Name = GSPSNAMENEG;     
        gsp.ASC_Group__c = acc.Id;
        gsp.ASC_Carrier__c = CARRBCN;
        gsp.ASC_Product__c = prd1.Id;
        gsp.ASC_LOB__c = LOB;
        gsp.ASC_Effective_Date__c = System.Today();
        gsp.ASC_Effective_End_Date__c = System.Today()+100;
        gsp.ASC_Unit_Price__c=10;
        gsp.ASC_MONTHLY_CAP_AMOUNT__c=14;
        gsp.ASC_Estimated_Monthly_Contracts__c=19;
        Database.insert(gsp, false);

        ASC_Group_Specific_Pricing__c gsp3 =new ASC_Group_Specific_Pricing__c();
        gsp3.RecordTypeId = getRecordTypeIdByName(RECTYPE_SPECIFICSTOPLOSS);
        gsp3.ASC_Data_Source__c = HIPS;
        gsp3.Name = GSPSNAMENEG;
        gsp3.ASC_Group__c = acc.Id;
        gsp3.ASC_Carrier__c = CARRBCN;
        gsp3.ASC_Product__c = prd3.Id;
        gsp3.ASC_LOB__c = LOB;
        gsp3.ASC_Effective_Date__c = System.Today();
        gsp3.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp3, false);

        ASC_Group_Specific_Pricing__c gsp4 =new ASC_Group_Specific_Pricing__c();
        gsp4.RecordTypeId = getRecordTypeIdByName(RECTYPE_AGGRSTOPLOSS);
        gsp4.ASC_Data_Source__c = HIPS;
        gsp4.Name = GSPSNAMENEG;
        gsp4.ASC_Group__c = acc.Id;
        gsp4.ASC_Carrier__c = CARRBCN;
        gsp4.ASC_Product__c = prd4.Id;
        gsp4.ASC_LOB__c = LOB;
        gsp4.ASC_Effective_Date__c = System.Today();
        gsp4.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp4, false);

        ASC_Group_Specific_Pricing__c gsp5 =new ASC_Group_Specific_Pricing__c();
        gsp5.RecordTypeId = getRecordTypeIdByName(RECTYPE_FINANCECHRGFEE);
        gsp5.ASC_Data_Source__c = HIPS;
        gsp5.Name = GSPSNAMENEG;
        gsp5.ASC_Group__c = acc.Id;
        gsp5.ASC_Carrier__c = CARRBCN;
        gsp5.ASC_Product__c = prd5.Id;
        gsp5.ASC_LOB__c = LOB;
        gsp5.ASC_Effective_Date__c = System.Today();
        gsp5.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp5, false);

        ASC_Group_Specific_Pricing__c gsp6 =new ASC_Group_Specific_Pricing__c();
        gsp6.RecordTypeId = getRecordTypeIdByName(RECTYPE_DEPOSITS);
        gsp6.ASC_Data_Source__c = HIPS;
        gsp6.Name = GSPSNAMENEG;
        gsp6.ASC_Group__c = acc.Id;
        gsp6.ASC_Carrier__c = CARRBCN;
        gsp6.ASC_Product__c = prd6.Id;
        gsp6.ASC_LOB__c = LOB;
        gsp6.ASC_Effective_Date__c = System.Today();
        gsp6.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp6, false);

        ASC_Group_Specific_Pricing__c gsp7 =new ASC_Group_Specific_Pricing__c();
        gsp7.RecordTypeId = getRecordTypeIdByName(RECTYPE_STOPLOSSOPTOUT);
        gsp7.ASC_Data_Source__c = HIPS;
        gsp7.Name = GSPSNAMENEG;
        gsp7.ASC_Group__c = acc.Id;
        gsp7.ASC_Carrier__c = CARRBCN;
        gsp7.ASC_Product__c = prd7.Id;
        gsp7.ASC_LOB__c = LOB;
        gsp7.ASC_Effective_Date__c = System.Today();
        gsp7.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp7, false);

        ASC_Group_Specific_Pricing__c gsp8 =new ASC_Group_Specific_Pricing__c();
        gsp8.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADMINCOMPFEES);
        gsp8.ASC_Data_Source__c = HIPS;
        gsp8.Name = GSPSNAMENEG;
        gsp8.ASC_Group__c = acc.Id;
        gsp8.ASC_Carrier__c = CARRBCN;
        gsp8.ASC_Product__c = prd8.Id;
        gsp8.ASC_LOB__c = LOB;
        gsp8.ASC_Effective_Date__c = System.Today();
        gsp8.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp8, false);

        ASC_Group_Specific_Pricing__c gsp9 =new ASC_Group_Specific_Pricing__c(); 
        gsp9.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADHOCADMINFEES);
        gsp9.ASC_Data_Source__c = HIPS;
        gsp9.Name = GSPSNAMENEG;
        gsp9.ASC_Group__c = acc.Id;
        gsp9.ASC_Carrier__c = CARRBCN;
        gsp9.ASC_Product__c = prd9.Id;
        gsp9.ASC_LOB__c = LOB;
        gsp9.ASC_Effective_Date__c = System.Today();
        gsp9.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp9, false);

        ASC_Group_Specific_Pricing__c gsp10 =new ASC_Group_Specific_Pricing__c(); 
        gsp10.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADHOCSTOPLOSS);
        gsp10.ASC_Data_Source__c = HIPS;
        gsp10.Name = GSPSNAMENEG;
        gsp10.ASC_Group__c = acc.Id;
        gsp10.ASC_Carrier__c = CARRBCN;
        gsp10.ASC_Product__c = prd10.Id;
        gsp10.ASC_LOB__c = LOB;
        gsp10.ASC_Effective_Date__c = System.Today();
        gsp10.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp10, false);

        ASC_Group_Specific_Pricing__c gsp11 =new ASC_Group_Specific_Pricing__c();
        gsp11.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADHOCSTOPLOSS);
        gsp11.ASC_Data_Source__c = HIPS;
        gsp11.Name = GSPSNAMENEG;
        gsp11.ASC_Group__c = acc.Id;
        gsp11.ASC_Carrier__c = CARRBCN;
        gsp11.ASC_Product__c = prd11.Id;
        gsp11.ASC_LOB__c = LOB;
        gsp11.ASC_Effective_Date__c = System.Today();
        gsp11.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp11, false);

        ASC_Group_Specific_Pricing__c gsp12 =new ASC_Group_Specific_Pricing__c();
        gsp12.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADHOCSTOPLOSS);
        gsp12.ASC_Data_Source__c = HIPS;
        gsp12.Name = GSPSNAMENEG;
        gsp12.ASC_Group__c = acc.Id;
        gsp12.ASC_Carrier__c = CARRBCN;
        gsp12.ASC_Product__c = prd12.Id;
        gsp12.ASC_LOB__c = LOB;
        gsp12.ASC_Effective_Date__c = System.Today();
        gsp12.ASC_Effective_End_Date__c = System.Today()+100;
        Database.Upsert(gsp12, false);

        ASC_Group_Specific_Pricing__c gsp13 =new ASC_Group_Specific_Pricing__c();
        gsp13.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADHOCSTOPLOSS);
        gsp13.ASC_Data_Source__c = HIPS;
        gsp13.Name = GSPSNAMENEG;
        gsp13.ASC_Group__c = acc.Id;
        gsp13.ASC_Carrier__c = CARRBCN;
        gsp13.ASC_Product__c = prd13.Id;
        gsp13.ASC_LOB__c = LOB;
        gsp13.ASC_Effective_Date__c = System.Today();
        gsp13.ASC_Effective_End_Date__c = System.Today()+100;
        Database.upsert(gsp13, false);

        ASC_Group_Specific_Pricing__c gsp14 =new ASC_Group_Specific_Pricing__c();
        gsp14.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADHOCSTOPLOSS);
        gsp14.ASC_Data_Source__c = HIPS;
        gsp14.Name = GSPSNAMENEG;
        gsp14.ASC_Group__c = acc.Id;
        gsp14.ASC_Carrier__c = CARRBCN;
        gsp14.ASC_Product__c = prd14.Id;
        gsp14.ASC_LOB__c = LOB;
        gsp14.ASC_Effective_Date__c = System.Today();
        gsp14.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp14, false);

        ASC_Group_Specific_Pricing__c gsp15 =new ASC_Group_Specific_Pricing__c();
        gsp15.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADHOCSTOPLOSS);
        gsp15.ASC_Data_Source__c = HIPS;
        gsp15.Name = GSPSNAMENEG;
        gsp15.ASC_Group__c = acc.Id;
        gsp15.ASC_Carrier__c = CARRBCN;
        gsp15.ASC_Product__c = prd15.Id;
        gsp15.ASC_LOB__c = LOB;
        gsp15.ASC_Effective_Date__c = System.Today();
        gsp15.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp15, false);

        ASC_Group_Specific_Pricing__c gsp16 =new ASC_Group_Specific_Pricing__c();
        gsp16.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADHOCSTOPLOSS);
        gsp16.ASC_Data_Source__c = HIPS;
        gsp16.Name = GSPSNAMENEG;
        gsp16.ASC_Group__c = acc.Id;
        gsp16.ASC_Carrier__c = CARRBCN;
        gsp16.ASC_Product__c = prd16.Id;
        gsp16.ASC_LOB__c = LOB;
        gsp16.ASC_Effective_Date__c = System.Today();
        gsp16.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp16, false);


        ASC_Group_Specific_Pricing__c gsp17 =new ASC_Group_Specific_Pricing__c();
        gsp17.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADHOCSTOPLOSS);
        gsp17.ASC_Data_Source__c = HIPS;
        gsp17.Name = GSPSNAMENEG;
        gsp17.ASC_Group__c = acc.Id;
        gsp17.ASC_Carrier__c = CARRBCN;
        gsp17.ASC_Product__c = prd17.Id;
        gsp17.ASC_LOB__c = LOB;
        gsp17.ASC_Effective_Date__c = System.Today();
        gsp17.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp17, false);

        ASC_Group_Specific_Pricing__c gsp18 =new ASC_Group_Specific_Pricing__c();
        gsp18.RecordTypeId = getRecordTypeIdByName(RECTYPE_ADHOCADMINFEES);
        gsp18.ASC_Data_Source__c = HIPS;
        gsp18.Name = GSPSNAMENEG;
        gsp18.ASC_Group__c = acc.Id;
        gsp18.ASC_Carrier__c = CARRBCN;
        gsp18.ASC_Product__c = prd18.Id;
        gsp18.ASC_LOB__c = LOB;
        gsp18.ASC_Effective_Date__c = System.Today();
        gsp18.ASC_Effective_End_Date__c = System.Today()+100;
        Database.insert(gsp18, false);
                              
    }
    /*******************************************************************************************************************************
    @Description: This test method is used to cover the ASC_Estimated_Monthly_Contracts__c criteria and to update Last Price Modified date
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
               
                list<ASC_Group_Specific_Pricing__c> gspricingLst =new list<ASC_Group_Specific_Pricing__c>(
                [SELECT Id,ASC_Carrier__c,ASC_Sub_Segment__c,ASC_Estimated_Monthly_Contracts__c,ASC_Unit_Price__c,                                  
                ASC_Product_Code__c,ASC_MONTHLY_CAP_AMOUNT__c From ASC_Group_Specific_Pricing__c Limit 100]);    
                
                Map<Id,ASC_Group_Specific_Pricing__c> oldMaps=new Map<Id,ASC_Group_Specific_Pricing__c> ();
                for(ASC_Group_Specific_Pricing__c sp:gspricingLst){
                    oldMaps.put(sp.Id,sp);
                    sp.ASC_Estimated_Monthly_Contracts__c = 20;
                    sp.ASC_Unit_Price__c = 20;
                    sp.ASC_Refund_Percent__c = 20;
                    sp.ASC_Cost_Share_Maximum__c = 20;
                    sp.ASC_SL_Identifier__c = 'test';
                    sp.ASC_Rate_Cap__c = 20;
                    sp.ASC_K_ADV_DEPOSIT__c = 10;
                    sp.ASC_Third_Year_Rate_Cap__c = 10;
                    sp.ASC_Cost_Share_Percent__c = 10;
                    sp.ASC_SL_Identifier_Data__c = 'test';
                    sp.Aggregating_Deductible__c = 20;
                }
                Database.update(gspricingLst,false);
        
                Test.startTest();
                ASC_GSPUpdateQLILastPriceDate.updateLastPriceDate(gspricingLst,oldMaps);
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
    @Description: This test method 'testmethod2' is used to cover the ASC_Unit_Price__c,ASC_Attachment_Point__c criteria 
    @Name : testmethod2
    @Param : None
    @Return : N/A
    ********************************************************************************************************************************/
    private static testmethod void testmethod2(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runAs(usr){
            try{               
                list<ASC_Group_Specific_Pricing__c> gspricingLst =new list<ASC_Group_Specific_Pricing__c>(
                [SELECT Id,ASC_Carrier__c,ASC_Sub_Segment__c,ASC_Estimated_Monthly_Contracts__c,ASC_Unit_Price__c,                 
                ASC_Product_Code__c,ASC_MONTHLY_CAP_AMOUNT__c From ASC_Group_Specific_Pricing__c Limit 100]);
                                
                Map<Id,ASC_Group_Specific_Pricing__c> oldMaps=new Map<Id,ASC_Group_Specific_Pricing__c> ();
                for(ASC_Group_Specific_Pricing__c sp:gspricingLst){
                    oldMaps.put(sp.Id,sp);
                    sp.ASC_Cost_Share_Percent__c = 20;
                    sp.ASC_Unit_Price__c = 20;
                    sp.ASC_Attachment_Point__c = 20;
                    //sp.ASC_Cost_Share_Maximum__c = 20;
                    sp.ASC_Fourth_Year_Rate_Cap__c = 20;
                    sp.ASC_Percent_of_Claims__c = 20;
  
                }
                Database.update(gspricingLst,false);
        
                Test.startTest();
                ASC_GSPUpdateQLILastPriceDate.updateLastPriceDate(gspricingLst,oldMaps);
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
    @Description: This test method 'testmethod3' is used to cover the Aggregating_Deductible__c,ASC_Percent_of_Claims__c,ASC_Cost_Share_Percent__c criteria 
    @Name : testmethod3
    @Param : None
    @Return : N/A
    ********************************************************************************************************************************/
    private static testmethod void testmethod3(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runAs(usr){
            try{
               
                list<ASC_Group_Specific_Pricing__c> gspricingLst =new list<ASC_Group_Specific_Pricing__c>(
                [SELECT Id,ASC_Carrier__c,ASC_Sub_Segment__c,ASC_Estimated_Monthly_Contracts__c,ASC_Unit_Price__c,                                  
                 ASC_Product_Code__c,ASC_MONTHLY_CAP_AMOUNT__c From ASC_Group_Specific_Pricing__c Limit 100]);
                
                Map<Id,ASC_Group_Specific_Pricing__c> oldMaps=new Map<Id,ASC_Group_Specific_Pricing__c> ();
                for(ASC_Group_Specific_Pricing__c sp:gspricingLst){
                    oldMaps.put(sp.Id,sp);
                    sp.Aggregating_Deductible__c = 20;
                    sp.ASC_Percent_of_Claims__c = 20;
                    sp.ASC_Cost_Share_Percent__c = 20;
                }
                Database.update(gspricingLst,false);
    
                Test.startTest();
                ASC_GSPUpdateQLILastPriceDate.updateLastPriceDate(gspricingLst,oldMaps);
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
    @Description: This test method 'testmethod4' is used to cover the ASC_Cost_Share_Percent__c criteria 
    @Name : testmethod4
    @Param : None
    @Return : N/A
    ********************************************************************************************************************************/
    private static testmethod void testmethod4(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runAs(usr){
            try{
               
                list<ASC_Group_Specific_Pricing__c> gspricingLst =new list<ASC_Group_Specific_Pricing__c>(
                [SELECT Id,ASC_Carrier__c,ASC_Sub_Segment__c,ASC_Estimated_Monthly_Contracts__c,ASC_Unit_Price__c,                                  
                 ASC_Product_Code__c,ASC_MONTHLY_CAP_AMOUNT__c From ASC_Group_Specific_Pricing__c Limit 100]);
                
                Map<Id,ASC_Group_Specific_Pricing__c> oldMaps=new Map<Id,ASC_Group_Specific_Pricing__c> ();
                for(ASC_Group_Specific_Pricing__c sp:gspricingLst){
                    oldMaps.put(sp.Id,sp);
                    sp.ASC_Cost_Share_Percent__c = 20;
  
                }
                Database.update(gspricingLst,false);
    
                Test.startTest();
                ASC_GSPUpdateQLILastPriceDate.updateLastPriceDate(gspricingLst,oldMaps);
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
    @Description: This method is used to get the recordtype Id
    @Name : getRecordTypeIdByName
    @Param : None
    @Return : Id
    ********************************************************************************************************************************/
    public static Id getRecordTypeIdByName(String rTypeName){ 
        Id rectypeId = null;
        try{
          rectypeId = Schema.getGlobalDescribe().get(GSP_OBJNAME).getDescribe().
                      getRecordTypeInfosByDeveloperName().get(rTypeName).getRecordTypeId();
        }
        catch(exception e){
                system.assert(e <> null);
                return null;
        }
        return rectypeId;
    }                      
}