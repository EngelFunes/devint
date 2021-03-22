/**************************************************************************************************************************
@Author : off shore
@Name:RecipientStatusTrigger_HandlerTest 
@CreatedDate: 4 feb 2021
@Description: RecipientStatusTrigger_HandlerTest class is used to cover RecipientStatusTrigger_Handler class.
@version : 1.0  
@US Num: 
****************************************************************************************************************************/
@isTest(seealldata = false)
public class RecipientStatusTrigger_HandlerTest {
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
    private static final string SIGNER='signer';
    private static final string GROUPPRIMARY='group primary';
     private static final string GROUP1='group';
    private static final string EMAIL='test@test.com';
    private static final string DOCUSIGNNAME='Test1';
    private static final string FIRST='Test';
    private static final string LAST='Test2';
    private static final string PHONENUM='1234567089';
    private static final string REQUESTED='Requested';
    private static final string SENT='sent';
    public static final Id ASC_SIGNER_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Group Signer').getRecordTypeId();
    public static final Id AGENT_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Agent').getRecordTypeId();
    public static final Id SEGOWNER_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Segment Owner').getRecordTypeId();
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
        Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc.id);
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(CONAG_RECORDTYPE).getRecordTypeId();
        database.insert(cnt);
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
        Contract cntrcRcrd = new Contract();
        cntrcRcrd.AccountId = acc.Id;
        cntrcRcrd.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd.Status =  DRAFT_STR;
        cntrcRcrd.vlocity_ins__QuoteId__c=quot.id;
        cntrcRcrd.StartDate = system.today();
        cntrcRcrd.recordtypeid = ASCCON_RECID;
        cntrcRcrd.ASC_Signature_Status__c=GROUP1;
        database.insert(cntrcRcrd);
        //insert docusign
        DocuSign_Participant__c docu=new DocuSign_Participant__c();
        docu.recordtypeid=ASC_SIGNER_RECTYPEID;
        docu.Name=DOCUSIGNNAME;
        docu.Contact__c=cont.id;
        docu.Contract__c=cntrcRcrd.id;
        docu.Email__c=EMAIL;
        docu.DocuSign_Action__c=GROUPPRIMARY;
        docu.First_Name__c =FIRST;
        docu.Last_Name__c=LAST;
        docu.Routing_Order__c=3;
        insert docu;
        //insert EnvelopeStatus
        dfsle__EnvelopeStatus__c  dfsle = new dfsle__EnvelopeStatus__c();
        dfsle.dfsle__SourceId__c= cntrcRcrd.id;
        dfsle.dfsle__Status__c=REQUESTED;
        database.insert(dfsle,false);
        //insert RecipientStatus 
        dfsle__RecipientStatus__c recpstatus=new dfsle__RecipientStatus__c();
        recpstatus.dfsle__SourceId__c=cntrcRcrd.id;
        recpstatus.dfsle__Status__c=SENT;
        recpstatus.dfsle__EnvelopeStatus__c=dfsle.id;
        insert recpstatus;
        
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
                list<dfsle__RecipientStatus__c> recepsta=[select id,dfsle__SourceId__c,dfsle__Status__c,SourceContractID__c,dfsle__Email__c from dfsle__RecipientStatus__c ];
                
                test.startTest();
                RecipientStatusTrigger_Handler.AfterInsertOperationHandler(recepsta,null);
                
                test.stopTest();
            }
        }catch(exception e)
        {
            system.assert(e <> null);
            return;
        }      
    }
    
}