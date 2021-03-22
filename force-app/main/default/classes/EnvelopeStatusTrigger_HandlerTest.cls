/**************************************************************************************************************************
@Author : off shore
@Name:EnvelopeStatusTrigger_HandlerTest 
@CreatedDate: 3 feb 2021
@Description: EnvelopeStatusTrigger_HandlerTest class is used to cover EnvelopeStatusTrigger_Handler class.
@version : 1.0  
@US Num: 
****************************************************************************************************************************/
@isTest(seealldata = false)
public class EnvelopeStatusTrigger_HandlerTest {
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final string RENW_YEAR = '2021';
    private static final Id QTRECTYPID = 
        Schema.SObjectType.Quote.getRecordTypeInfosByName().get(ASC_QTRECTYPE).getRecordTypeId();   
    private static final string OPP_STAG = 'Quote Request';
    private static final string ASC_OPPRECTYPE = 'Opportunity - ASC';
    private static final string QTNAME = 'test quote';
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string CON_RECORDTYPE ='Contact';
    private static final string CONAG_RECORDTYPE ='Contact - Agent';
    private static final string ACCCID = '12345';
    private static final string ASC_CONT = 'ASC Contract';  
    private static final Id ASCCON_RECID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(ASC_CONT).getRecordTypeId(); 
    private static final string CARR_BCN = 'BCN';
    private static final string DRAFT_STR = 'Draft';
    private static final string ACCEPTED='ACCEPTED';
    private static final string DECLINED='Declined'; 
    private static final string REQUESTED='Requested';
    private static final string VOIDED='Voided';
    private static final string POSTINGTOCM='Posting to CM';
    private static final string COMPLETED='completed';
    private static final string SENT='sent';
    private static final string FIRST='Test';
    private static final string LAST='Test2';
    private static final string PHONENUM='1234567089';
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
    
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
        //insert account
        Account acc=new Account();
        acc.Name=NAME;
        acc.Phone=PHONE;
        acc.CID__c=ACCCID;
        acc.Federal_Tax_ID__c=ACCCID;
        acc.Requested_Effective_Date__c=system.today();
        acc.GA_CoverageCancellationDate__c=system.today();        
        //acc.BillingPostalCode = BILL_PCODE;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
        Database.insert(acc,false);
        //insert contact
        contact cont = new Contact();
        cont.FirstName =FIRST;
        cont.LastName =LAST;
        cont.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(CON_RECORDTYPE).getRecordTypeId();
        cont.AccountId = acc.Id;
        cont.Phone=PHONENUM;
        insert Cont;
        //insert Opportunity
        opportunity opp=new opportunity();
        opp.Name = NAME;
        opp.AccountId = acc.id;
        opp.stageName = OPP_STAG;
        opp.CloseDate = system.today()+120;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ASC_OPPRECTYPE).getRecordTypeId();
        Database.insert(opp,false);
        //insert Quote                                   
        list<Quote> quotlist = new list<Quote>();
        quote quot=new quote();
        quot.Name = QTNAME;
        quot.opportunityId = Opp.Id;
        quot.RecordTypeId = QTRECTYPID;
        quot.ASC_CID__c = ACCCID;
        quot.ASC_Carrier__c = CARR_BCN;
        quot.ASC_Renewal_Year__c = RENW_YEAR;
        quotlist.add(quot);
        Database.insert(quotlist,false);
        //insert contract records
        Contract cntrcRcrd = new Contract();
        cntrcRcrd.AccountId = acc.Id;
        cntrcRcrd.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd.Status =  DRAFT_STR;
        cntrcRcrd.vlocity_ins__QuoteId__c=quot.id;
        cntrcRcrd.StartDate = system.today();
        cntrcRcrd.recordtypeid = ASCCON_RECID;
        cntrcRcrd.ASC_Signature_Status__c=REQUESTED;
        database.insert(cntrcRcrd);
        cntrcRcrd.Status =ACCEPTED;
        update cntrcRcrd;
        Contract cntrcRcrd1 = new Contract ();
        cntrcRcrd1.AccountId = acc.Id;
        cntrcRcrd1.Status = DRAFT_STR;
        cntrcRcrd1.recordtypeid = ASCCON_RECID;
        cntrcRcrd1.ASC_Signature_Status__c=VOIDED;
        database.insert(cntrcRcrd1);
        Contract cntrcRcrd2 = new Contract ();
        cntrcRcrd2.AccountId = acc.Id;
        cntrcRcrd2.Status = DRAFT_STR;
        cntrcRcrd2.recordtypeid = ASCCON_RECID;
        cntrcRcrd2.ASC_Signature_Status__c=DECLINED;
        database.insert(cntrcRcrd2);
        Contract cntrcRcrd3 = new Contract ();
        cntrcRcrd3.AccountId = acc.Id;
        cntrcRcrd3.Status =DRAFT_STR;
        cntrcRcrd3.recordtypeid = ASCCON_RECID;
        cntrcRcrd3.ASC_Signature_Status__c=POSTINGTOCM;
        database.insert(cntrcRcrd3);
        Contract cntrcRcrd4 = new Contract();
        cntrcRcrd4.AccountId = acc.Id;
        cntrcRcrd4.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd4.Status =  DRAFT_STR;
        cntrcRcrd4.vlocity_ins__QuoteId__c=quot.id;
        cntrcRcrd4.StartDate = system.today();
        cntrcRcrd4.recordtypeid = ASCCON_RECID;
        cntrcRcrd4.ASC_Signature_Status__c=null;
        database.insert(cntrcRcrd4);
        //insert Envelopestatus 
        dfsle__EnvelopeStatus__c  dfsle = new dfsle__EnvelopeStatus__c();
        dfsle.dfsle__SourceId__c= cntrcRcrd.id;
        dfsle.dfsle__Status__c=REQUESTED;
        database.insert(dfsle,false);
        dfsle__EnvelopeStatus__c  dfsle1= new dfsle__EnvelopeStatus__c();
        dfsle1.dfsle__SourceId__c=cntrcRcrd.id;
        dfsle1.dfsle__Status__c=ACCEPTED;
        database.insert(dfsle1,false);
        dfsle__EnvelopeStatus__c  dfsle2= new dfsle__EnvelopeStatus__c();
        dfsle2.dfsle__SourceId__c=cntrcRcrd1.id;
        dfsle2.dfsle__Status__c=VOIDED;
        insert dfsle2;
        dfsle__EnvelopeStatus__c  dfsle3= new dfsle__EnvelopeStatus__c();
        dfsle3.dfsle__SourceId__c=cntrcRcrd2.id;
        dfsle3.dfsle__Status__c=DECLINED;
        insert dfsle3;
        dfsle__EnvelopeStatus__c  dfsle4= new dfsle__EnvelopeStatus__c();
        dfsle4.dfsle__SourceId__c=cntrcRcrd.id;
        dfsle4.dfsle__Status__c=COMPLETED;
        insert dfsle4;
        dfsle__EnvelopeStatus__c  dfsle5= new dfsle__EnvelopeStatus__c();
        dfsle5.dfsle__SourceId__c=cntrcRcrd4.id;
        dfsle5.dfsle__Status__c=SENT;
        insert dfsle5;
    }
     /*******************************************************************************************************************************
    @Description: 
    @Name : AfterInsertOperationHandlertest
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    private static testMethod void AfterInsertOperationHandlertest(){  
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runas(usr){
         
                list<dfsle__EnvelopeStatus__c> envelop=[select dfsle__SourceId__c,dfsle__Status__c from dfsle__EnvelopeStatus__c ];
                
                test.startTest();
                EnvelopeStatusTrigger_Handler.AfterInsertOperationHandler(envelop);
                test.stopTest();
                
            }
        }catch(exception e)
        {
            system.assert(e <> null);
            return;
        }      
    }
}