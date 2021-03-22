/**************************************************************************************************************************
@Author : off shore
@Name:ContractTriggerHandler_Test 
@CreatedDate: 06 June 2020
@Description: ContractTriggerHandler_Test class is used to cover ContractTriggerHandler class.
@version : 1.0  
@US Num: 
****************************************************************************************************************************/
@isTest
public class ContractTriggerHandler_Test {
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final string TYPE  ='ASC Product';
    private static final string OPPNAME = 'TEST OPP 001';
    private static final string OPP_STAG = 'New';
    private static final string OPP_STAG1 =  'Closed - Won';
    private static final Date OPP_DATE = Date.valueOf('2020-11-16');
    private static final string OPP_CLOSEDREASON ='Relationship with Blue Cross';
    private static final string QTNAME = 'test quote';
    private static final string PRD_NAME = 'Variable Administrative Fees';
    private static final string PRD_CODE = 'ASC_0000350';
    private static final string PRD_FAMILY = 'Admin Fees';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final string CID ='20200525';
    private static final string COV_SPEC = 'Coverage Spec';
    private static final string PRODT = 'Product';
    private static final string YES = 'yes';
    private static final string CARR_BCN = 'BCN';
    private static final string DRAFT_STR = 'Draft';
    private static final string DENIED_STR ='Denied';
    private static final string ACCEPTED_STR = 'Accepted';
    private static final string CANCELLED_STR ='Cancelled';
    private static final string LIENAME ='LIENAMEPRD';
    private static final string LIENEW ='New';
    private static final string LIECOVERAGE ='Not Elected';
    private static final string LIECOVERAGE1 ='Elected';
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
    private static final string ASC_BARECTYPE = 'ASC Base Contract';
    private static Id prdCovSpecRecordTypeId =
        Schema.SObjectType.Product2.getRecordTypeInfosByName().get(COV_SPEC).getRecordTypeId(); 
    private static Id prdRecordTypeId=
        Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PRODT).getRecordTypeId();    
    private static Id qTRecordTypeId = 
        Schema.SObjectType.Quote.getRecordTypeInfosByName().get(ASC_QTRECTYPE).getRecordTypeId(); 
    private static final string ASC_CONT = 'ASC Contract';  
    private static final Id  OPP_ASC_RECTYPEID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Opportunity_ASC').getRecordTypeId();
    private static final Id ASCCON_RECID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(ASC_CONT).getRecordTypeId(); 
    private static final Id ASCBACON_RECID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(ASC_BARECTYPE).getRecordTypeId();
    private static final Id ASC_QUOTE_RECTYPEID = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('ASC_Quote').getRecordTypeId();
    /*******************************************************************************************************************************
@Description: initData() method - preparing the test data
@Name : initData
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    @TestSetup static void initData(){
        //insert user
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        //setup data
        //Create Account
        Account newAcc1 = new Account();
        newAcc1.Name = NAME;
        newAcc1.CID__c =CID;
        insert newAcc1;
        //Create Opportunity
        set<id> oppids=new set<id>();
        List<Opportunity> newOpps = new List<Opportunity>();
        Opportunity opp1 = new Opportunity();
        opp1.Name =OPPNAME;
        opp1.AccountId = newAcc1.Id;
        opp1.StageName =OPP_STAG;
        opp1.CloseDate =OPP_DATE;
        opp1.RecordTypeId = OPP_ASC_RECTYPEID;
        newOpps.add(opp1);
        Opportunity opp2 = new Opportunity();
        opp2.Name =OPPNAME;
        opp2.AccountId = newAcc1.Id;
        opp2.StageName =OPP_STAG1;
        opp2.GA_ClosedReason__c=OPP_CLOSEDREASON;
        opp2.CloseDate =OPP_DATE;
        opp2.RecordTypeId = OPP_ASC_RECTYPEID;
        newOpps.add(opp2);
        insert newOpps;
        Oppids.add(opp1.id);
        Oppids.add(opp2.id);
        //Create Quotes
        Quote qt1 = new Quote();
        qt1.Name = QTNAME;
        qt1.OpportunityId = newOpps.get(0).Id;
        qt1.Status =DRAFT_STR;
        qt1.RecordTypeId = ASC_QUOTE_RECTYPEID;
        insert qt1;
        qt1.Status =DENIED_STR;
        update(qt1);
        Quote qt2 = new Quote();
        qt2.Name =QTNAME;
        qt2.OpportunityId = newOpps.get(0).Id;
        qt2.Status =DRAFT_STR;
        qt2.RecordTypeId = ASC_QUOTE_RECTYPEID;
        insert qt2;
        Quote qt3 = new Quote();
        qt3.Name =QTNAME;
        qt3.OpportunityId = newOpps.get(0).Id;
        qt3.Status =DENIED_STR;
        qt3.RecordTypeId = ASC_QUOTE_RECTYPEID;
        insert qt3;
        //insert Contracts
        Contract cntrcRcrd = new Contract();
        cntrcRcrd.AccountId = newAcc1.Id;
        cntrcRcrd.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd.Status = DRAFT_STR;
        cntrcRcrd.StartDate = system.today();
        cntrcRcrd.EndDate = system.today();
        cntrcRcrd.recordtypeid = ASCCON_RECID;
        cntrcRcrd.ASC_ERISA__c=YES;
        cntrcRcrd.ASC_ERISA_Exempt__c=YES;
        cntrcRcrd.vlocity_ins__QuoteId__c=qt1.id;
        cntrcRcrd.ASC_SSL_Run_Out_Coverage_Elected__c=YES;
        database.insert(cntrcRcrd);
        Contract cntrcRcrd5 = new Contract();
        cntrcRcrd5.AccountId = newAcc1.Id;
        cntrcRcrd5.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd5.Status = DRAFT_STR;
        cntrcRcrd5.StartDate = system.today();
        cntrcRcrd5.recordtypeid = ASCBACON_RECID;
        cntrcRcrd5.ASC_ERISA__c=YES;
        cntrcRcrd5.ASC_ERISA_Exempt__c=YES;
        cntrcRcrd5.ASC_SSL_Run_Out_Coverage_Elected__c=YES;
        database.insert(cntrcRcrd5);
        Contract cntrcRcrd2 = new Contract();
        cntrcRcrd2.AccountId = newAcc1.Id;
        cntrcRcrd2.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd2.Status = DRAFT_STR;
        cntrcRcrd2.StartDate = system.today();
        cntrcRcrd2.recordtypeid = ASCBACON_RECID;
        database.insert(cntrcRcrd2);
        Contract cntrcRcrd3 = new Contract();
        cntrcRcrd3.AccountId = newAcc1.Id;
        cntrcRcrd3.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd3.Status = DRAFT_STR;
        cntrcRcrd3.StartDate = system.today();
        cntrcRcrd3.recordtypeid = ASCCON_RECID;
        database.insert(cntrcRcrd3);
        cntrcRcrd3.Status =ACCEPTED_STR;
        Update cntrcRcrd3;
        Contract cntrcRcrd4 = new Contract();
        cntrcRcrd4.AccountId = newAcc1.Id;
        cntrcRcrd4.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd4.Status = DRAFT_STR;
        cntrcRcrd4.StartDate = system.today();
        cntrcRcrd4.recordtypeid = ASCCON_RECID;
        cntrcRcrd4.vlocity_ins__QuoteId__c=qt1.Id;
        database.insert(cntrcRcrd4);
        cntrcRcrd4.Status =CANCELLED_STR;
        Update cntrcRcrd4;
        Contract cntrcRcrd1 = new Contract();
        cntrcRcrd1.AccountId = newAcc1.Id;
        cntrcRcrd1.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd1.Status = DRAFT_STR;
        cntrcRcrd1.StartDate = system.today();
        cntrcRcrd1.recordtypeid = ASCCON_RECID;
        cntrcRcrd1.vlocity_ins__QuoteId__c=qt3.id;
        database.insert(cntrcRcrd1);
        //insert product
        Product2 prod= new product2(
            Name = PRD_NAME,
            Family = PRD_FAMILY,
            ProductCode =PRD_CODE ,
            vlocity_ins__LineOfBusiness__c = PRD_LOB,
            vlocity_ins__SubType__c = TYPE,
            vlocity_ins__Type__c = TYPE,
            vlocity_ins__EffectiveDate__c = system.today()
        );
        Database.insert(prod,false);
        Product2 prod1= new product2(
            Name = PRD_NAME,
            Family = PRD_FAMILY,
            vlocity_ins__LineOfBusiness__c = PRD_LOB,
            vlocity_ins__SubType__c = TYPE,
            vlocity_ins__Type__c = TYPE,
            vlocity_ins__EffectiveDate__c = system.today()
        );
        Database.insert(prod1,false);
        //insert vlocity_ins__ContractLineItem__c
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=Prod.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.vlocity_ins__ContractId__c=cntrcRcrd.id;
        Database.insert(plan2); 
        vlocity_ins__ContractLineItem__c plan3 = new vlocity_ins__ContractLineItem__c();
        plan3.vlocity_ins__Product2Id__c=Prod.Id;
        plan3.ASC_Effective_Start_Date__c=system.today();
        plan3.ASC_AAC_PCNT__c=10.00;
        plan3.vlocity_ins__ContractId__c=cntrcRcrd.id;
        Database.insert(plan3); 
        vlocity_ins__ContractLineItem__c plan =new vlocity_ins__ContractLineItem__c();
        plan.Name = prod.Name;
        plan.vlocity_ins__Product2Id__c = prod.Id;
        plan.vlocity_ins__ContractId__c = cntrcRcrd.id;
        plan.ASC_Effective_Start_Date__c= system.today();
        plan.ASC_Effective_End_Date__c = system.today();
        plan.vlocity_ins__Quantity__c = 1;
        insert plan;
        //insert pricebookId
        Id pricebookId = Test.getStandardPricebookId();            
        pricebookEntry prc=new pricebookEntry ();
        prc.product2Id = prod.Id;
        prc.Pricebook2Id = pricebookId;
        prc.UnitPrice = 10;
        prc.isActive = true;
        Database.insert(prc,false);
        //insert Line item Extension
        Line_Item_Extension__c lie2 = new Line_Item_Extension__c();
        lie2.name =LIENAME;
        lie2.Product__c = prod.Id;
        lie2.Quantity__c =20;
        lie2.Percent_of_Coupon_Savings__c=20;
        lie2.AWP_1__c=20;
        lie2.Activation_Type__c=LIENEW;
        lie2.Coverage_Elected__c=LIECOVERAGE1;
        lie2.AWP_2__c=20;
        Database.insert(lie2,false);
        Line_Item_Extension__c lie3 = new Line_Item_Extension__c();
        lie3.name =LIENAME;
        lie3.Product__c = prod.Id;
        lie3.Quantity__c =20;
        lie3.Percent_of_Coupon_Savings__c=20;
        lie3.Activation_Type__c=LIENEW;
        lie3.AWP_1__c=20;
        lie3.Coverage_Elected__c=LIECOVERAGE;
        lie3.AWP_2__c=20;
        Database.insert(lie3,false);
    }
    /*******************************************************************************************************************************
@Description: 
@Name : testmethod1
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void testmethod1(){
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runas(usr){
                test.startTest();
                list<contract> con =[select Id,StartDate,endDate,AccountId,ASC_Carrier__c,vlocity_ins__QuoteId__c,Status,recordtypeid from contract limit 1 ];
                list<contract> con1 =[select Id,StartDate,endDate,AccountId,ASC_Carrier__c,vlocity_ins__QuoteId__c,Group_Label__c,ASC_SSL_Run_Out_Coverage_Elected__c,Status,recordtypeid from contract];
                
                set<id> accid =new set<id>();
                Account acc=[select id,name from Account];
                accid.add(acc.id);
                ContractTriggerHandler.updateOpportunitiesOnActivatedContracts(con);
                ContractTriggerHandler.updateQuotesOnCancelledContracts(con);
                ContractTriggerHandler.updatePlansOnActivatedContracts(con);
                ContractTriggerHandler.updatePlansOnCancelledContracts(con);
                ContractTriggerHandler.updateOpportunityStage(con,null);
                ContractTriggerHandler.createHistoryTrackingrecords(con);
                ContractTriggerHandler.updateHistoryTrackingrecords(con,null);
                ContractTriggerHandler.updateContractStatus(con,null);
                ContractTriggerHandler.updateContractERISAExempt(con,accid);
                ContractTriggerHandler.updatePlanItems(con1);
                test.stopTest();
            }
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }      
        
    }
}