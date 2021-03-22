/**************************************************************************************************************************
@Author : off shore
@Name:ASC_DocuSignParticipantHelperTest 
@CreatedDate: 29 Jan 2021
@Description: ASC_DocuSignParticipantHelperTest class is used to coverASC_DocuSignParticipantHelper class.
@version : 1.0  
@US Num: 
****************************************************************************************************************************/
@isTest(seealldata = false)
public class ASC_DocuSignParticipantHelperTest {
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final string RENW_YEAR = '2021';
    private static final Id QTRECTYPID = 
        Schema.SObjectType.Quote.getRecordTypeInfosByName().get(ASC_QTRECTYPE).getRecordTypeId();   
    private static final string OPP_STAG = 'Quote Request';
    private static final string ASC_OPPRECTYPE = 'Opportunity - ASC';
    private static final string QTNAME = 'test quote';
    private static final Integer UNIT_PRICE = 1;            
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string CON_RECORDTYPE ='Contact';
     private static final string CONAG_RECORDTYPE ='Contact - Agent';
    private static final string ACCCID = '12345';
    private static final string FEDTID = '123456789';
    private static final string BILL_PCODE = '48005';
    private static final string  NUM ='23';
     private static final string OFCCODE ='999';
     private static final string REGNCODE ='018';
    private static final string ASC_CONT = 'ASC Contract';  
    private static final Id ASCCON_RECID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(ASC_CONT).getRecordTypeId(); 
    private static final string CARR_BCN = 'BCN';
    private static final string DRAFT_STR = 'Draft';
    private static final string ACCEPTED='ACCEPTED';
     private static final string SIGNER='signer';
    private static final string GROUPPRIMARY='group primary';
    private static final string EMAIL='test@test.com';
     private static final string VIEWER='viewer';
     private static final string DOCUSIGNNAME='Test1';
    private static final string FIRST='Test';
    private static final string LAST='Test2';
     private static final string PHONENUM='(123)456-7089';
    private static final string TESTAOR='TestAor';
    private static final string TESTTERRITORY='Test Territory Name';
    private static final string ACCOUNTMANAGER='Account Manager';
    private static final string TESTREGION='Test Region';
     private static final string TESTSALESOFFICE='Test - Sales Office';
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
        //insert region
        GA_Region__c regnRec =new GA_Region__c();
        regnRec.Name =TESTREGION;
        regnRec.GA_Region_Code__c=REGNCODE;
        regnRec.ASC_Sales_Segment_Owner__c=usr.id;
        insert regnRec;
        //insert sales office
        GA_Sales_Office__c slsOfcRec =new GA_Sales_Office__c();
        slsOfcRec.Name =TESTSALESOFFICE;
        slsOfcRec.GA_Sales_Office_Code__c=OFCCODE;
        slsOfcRec.GA_Region__c=regnRec.Id;
        insert slsOfcRec;
        //insert territory
        GA_Territory__c terytoryRec=new GA_Territory__c();
        terytoryRec.Name=TESTTERRITORY;
        terytoryRec.GA_TerritoryType__c=ACCOUNTMANAGER;
        terytoryRec.GA_TerritoryCode__c=NUM;
        terytoryRec.GA_Sales_Office__c=slsOfcRec.id;
        terytoryRec.GA_Sales_Rep_Effective_Date__c = System.today();
        insert terytoryRec;
        
        //insert account
        Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(testAccount);
        //insert contact
        contact cont1 = new Contact();
        cont1.FirstName = FIRST;
        cont1.LastName = LAST;
        cont1.AccountId = testAccount.Id;
        cont1.Phone=PHONENUM;
        cont1.Email=EMAIL;
        insert Cont1;
        contact cont2 = new Contact();
        cont2.FirstName =FIRST;
        cont2.LastName =LAST;
        cont2.AccountId = testAccount.Id;
        cont2.Phone=PHONENUM;
        cont2.Email=EMAIL;
        insert Cont2;
        
        //insert account
        Account acc=new Account();
        acc.Name=NAME;
        acc.Phone=PHONE;
        acc.CID__c=ACCCID;
        acc.Federal_Tax_ID__c=ACCCID;
        acc.Requested_Effective_Date__c=system.today();
        acc.GA_CoverageCancellationDate__c=system.today();        
        acc.BillingPostalCode = BILL_PCODE;
        acc.GA_Territory__c=terytoryRec.id;
        acc.GA_Decision_Maker__c=cont1.id;
        acc.GA_CEO__c=cont1.id;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
        Database.insert(acc,false);
        acc.GA_Decision_Maker__c=cont2.id;
        update acc;
        
        //insert contact
        contact cont = new Contact();
        cont.FirstName =FIRST;
        cont.LastName =LAST;
        cont.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(CON_RECORDTYPE).getRecordTypeId();
        cont.AccountId = acc.Id;
        cont.Phone=PHONENUM;
        insert Cont;
        contact cnt = new Contact();
        cnt.FirstName =FIRST;
        cnt.LastName =LAST;
        cnt.Phone=PHONENUM;
         cnt.AccountId = acc.Id;
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(CONAG_RECORDTYPE).getRecordTypeId();
        database.insert(cnt);
        
        //insert AOR
        GA_Aor__C aorRec = New GA_Aor__C();
        aorRec.Name =TESTAOR;
        aorRec.GA_Account_Id__c = acc.id;
        aorRec.GA_Contact_Id__c =cnt.id ;
        insert aorRec;
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
        cntrcRcrd.Status = DRAFT_STR;
        cntrcRcrd.vlocity_ins__QuoteId__c=quot.id;
        cntrcRcrd.StartDate = system.today();
        cntrcRcrd.recordtypeid = ASCCON_RECID;
        database.insert(cntrcRcrd);
        
        Contract cntrcRcrd1 = new Contract ();
        cntrcRcrd1.AccountId = acc.Id;
        cntrcRcrd1.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd1.Status = DRAFT_STR;
        cntrcRcrd1.vlocity_ins__ParentContractId__c=cntrcRcrd.id;
        cntrcRcrd1.StartDate = system.today();
        cntrcRcrd1.recordtypeid = ASCCON_RECID;
        database.insert(cntrcRcrd1);
        //insert docusign participant records 
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
        DocuSign_Participant__c docu1=new DocuSign_Participant__c();
        docu1.recordtypeid=AGENT_RECTYPEID;
        docu1.Name=DOCUSIGNNAME;
        docu1.Agent__c=cnt.id;
        docu1.Email__c=EMAIL;
        docu1.Contract__c=cntrcRcrd.id;
        docu1.DocuSign_Action__c=VIEWER;
        insert docu1;
        DocuSign_Participant__c docu2=new DocuSign_Participant__c();
        docu2.recordtypeid=SEGOWNER_RECTYPEID;
        docu2.Name=DOCUSIGNNAME;
        docu2.Email__c=EMAIL;
        docu2.Segment_Owner__c=usr.id;
        docu2.Contract__c=cntrcRcrd.id;
        docu2.DocuSign_Action__c=SIGNER;
        insert docu2;
        
    }
     /*******************************************************************************************************************************
    @Description: This test method is used to create the records in quote and DocuSign_Participant__c Objects 
    @Name : createDocuSignParticipantsinsert
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    private static testMethod void createDocuSignParticipantsinsert(){
        try{
       user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runas(usr){
        test.startTest();
        List<Quote> quotlist=[select id,Name,status,opportunityId,ASC_CID__c,ASC_Renewal_Year__c from quote];
        map<id,DocuSign_Participant__c> dpmap=new map<id,DocuSign_Participant__c>([select id,name,Segment_Owner__c,Contract__c,DocuSign_Action__c 
                                                                                   from DocuSign_Participant__c ]);
        Map<id,Quote> oldmap = new Map<id,Quote>();
        oldmap.put(quotlist[0].id,quotlist[0]);
        quotlist[0].Status=ACCEPTED;
        Database.update(quotlist);
        
        
        ASC_DocuSignParticipantHelper.createDocuSignParticipants(quotlist,oldmap);
        ASC_DocuSignParticipantHelper.createDocuSignParticipants(null,null);
        
        test.stopTest();
            system.assert(quotlist <> null);
        } 
            }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }   
}   
 
     /*******************************************************************************************************************************
    @Description: This test method is used to clone the records in  DocuSign_Participant__c Objects 
    @Name : cloneDocusignParticipentsclone
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    
    private static testMethod void cloneDocusignParticipentsclone(){
        try{
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runas(usr){
        test.startTest();
        map<id,id> cntids=new map<id,id>();
            list<id> cnrtids=new list<id>();
            
        list<Contract> cntrList =[SELECT AccountId,CID__c,Id,Name,RecordTypeId,Status,SpecialTerms,vlocity_ins__ParentContractId__c FROM Contract where RecordTypeId =:ASCCON_RECID];
            
        List<DocuSign_Participant__c> dp = [select id,name,DocuSign_Action__c,Contract__c,RecordTypeId,Routing_Order__c,Email__c,Contact__c,
                                     Contract__r.vlocity_ins__QuoteId__r.ParentContractId__c,  TPA__c,Agent__c,Segment_Owner__c from DocuSign_Participant__c];
       
        ASC_DocuSignParticipantHelper.cloneDocusignParticipents(null,null,null);
        
        
        test.stopTest();
              system.assert(cntrList <> null);
        }
        }catch(exception e)
        {
            system.assert(e <> null);
            return;
        }      
    
    }
    /*******************************************************************************************************************************
    @Description: This test method is used to update the records in  DocuSign_Participant__c Objects 
    @Name : updateDocuSignParticipantstest
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/  
    private static testMethod void updateDocuSignParticipantstest(){
        try{
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runas(usr){
            test.startTest();
            List<DocuSign_Participant__c> docusign = [Select Id,Name,agent__c,Contract__c from DocuSign_Participant__c];
            map<id,DocuSign_Participant__c>oldmap =new map<id,DocuSign_Participant__c>([select id,name,Agent__c,Segment_Owner__c,Contact__c,Contract__c,DocuSign_Action__c from DocuSign_Participant__c]);
            
            list<user> usr1=[select id,Name from User limit 1];
            oldmap.put(docusign[0].id,docusign[0]);
            docusign[0].Segment_Owner__c=usr1[0].id;
            database.update(docusign);
            ASC_DocuSignParticipantHelper.updateDocuSignParticipants(docusign,oldmap);
            ASC_DocuSignParticipantHelper.updateDocuSignParticipants(null,null);
            ASC_DocuSignParticipantHelper.ValidateAORondocusign(NULL);
            
            test.stopTest();
            system.assert(docusign <> null);
        }
        }
            catch(exception e)
        {
            system.assert(e <> null);
            return;
        }      
        
    }
}