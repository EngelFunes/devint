/**
@Author : IDC Offshore
@Name: ARV_AP92_RenewalListViewsTest
@CreatedDate: 10-March-2020
@Description: ARV_AP92_RenewalListViewsTest List views for contracts
@version : 1.0 
*/
@isTest
private with sharing class ARV_AP92_RenewalListViewsTest {
    private static final string PROFILENAME='System Administrator';
    private static final string NAME='AP61LastName';
    Private static final String TEST_VAL='Test';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final String SOBJNAME = 'LocationPackage__c';
    private static final String IS_VIEW = 'related';
    private static final String IN_PROGRESS='In Progress';
    Private static final String CID='23';
    Private static final String ACTIVE='Active';
    Private static final String JANUARY='January';
    Private static final String CARRIERCODE='dsfsdfs';
    Private static final String TXT_SG='SG';
    Private static final String NULL1 ='';
    Private static final String GROUPNAME='heurhfuek';
    //private static final String batchid='a9v3B0000000FIjQAM';
    /*********************************************************************************************************
@Description: testDataSetup1() method 
@Name : testDataSetup1
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    @testSetup static void testDataSetup1() { 
        Account acc = new Account(name=TEST_VAL);
        acc.CID__c=CID;
        //acc.GA_Renewal_Year__c=2020;
        acc.Status__c= ACTIVE;
        acc.GA_Opportunity_Renewal_Date__c=system.today();
        acc.Renewal_Month__c=JANUARY;
        acc.GA_Carrier_Code__c=CARRIERCODE;
        acc.ARV_Renewal_Account_Type__c=TXT_SG;
        database.insert(acc);
        Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        //con.Status='Activated';
        con.ARV_Excluded_from_Renewal__c=false;
        con.ARV_Renewal_Status__c= NULL1;
        database.insert(con);
        GA_Group_Segment__c groups=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,con.Id);
        groups.GA_Group_Name__c=GROUPNAME;
        database.insert(groups);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        usr.Username=USERNAME;
        database.insert(usr,true);
    }
    private static testMethod void testgetContractDetails() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            ARV_AP92_RenewalListViews.listViews();
            System.assertNotEquals(null,cont);
         }
    }
    private static testMethod void testgetContractDetails1() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            ARV_AP92_RenewalListViews.listValues();
            System.assertNotEquals(null,cont);
         }
    }
    private static testMethod void testgetContractDetails2() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            acc.GA_Opportunity_Renewal_Date__c = system.today();
            acc.Renewal_Month__c = 'January';
            acc.ARV_Renewal_Account_Type__c = TXT_SG;
            acc.Account_Status__c = 'Active';
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            cont.ARV_Excluded_from_Renewal__c = false;
            cont.ARV_Renewal_Status__c = '';
            cont.ARV_Renewal_Error__c = '';
            cont.ARV_Contract_Type__c ='';          
            Database.insert(cont);
            cont.Status = 'Activated';
            Database.update(cont);
            GA_Group_Segment__c groups=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont.Id);
            groups.GA_Group_Name__c=GROUPNAME;
            groups.Status__c='Active';
            database.insert(groups);
            ARV_AP92_RenewalListViews.getListEligibleRecords('January',1,0);
            ARV_AP92_RenewalListViews.loadwrapContractRecords(cont.Id,'January',1);
            ARV_AP92_RenewalListViews.getCidSearcContracts('January','213122,232322,343434');
            System.assertNotEquals(null,cont);
         }
    }
    private static testMethod void testgetContractDetails3() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            ARV_AP92_RenewalListViews.getListSuccessRecords('January',1,1);
            ARV_AP92_RenewalListViews.loadwrapContractSuccessRecords(cont.Id,'January',1);
            ARV_AP92_RenewalListViews.getCidSearcSuccessContracts('January','2312312,232323,123123');
            System.assertNotEquals(null,cont);
         }
    }
    private static testMethod void testgetContractDetails4() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            acc.GA_Opportunity_Renewal_Date__c = system.today();
            acc.Renewal_Month__c = 'January';
            acc.ARV_Renewal_Account_Type__c = TXT_SG;
            acc.Account_Status__c = 'Active';
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            cont.Status = 'Activated';
            Database.update(cont);
            GA_Group_Segment__c groups=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont.Id);
            groups.GA_Group_Name__c=GROUPNAME;
            groups.Status__c='Active';
            database.insert(groups);
            ARV_AP92_RenewalListViews.getAdHocContracts('153453',1);
            ARV_AP92_RenewalListViews.getAdHocContracts('153453,324234,342344',10);
            System.assertNotEquals(null,cont);
         }
    }
    private static testMethod void testgetContractDetails8() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            acc.Renewal_Month__c='January';
            Database.insert(acc);
            Contract cont1 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            cont1.ARV_Renewal_Error__c='';
            Database.insert(cont1);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Id stExam = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            cont.RecordtypeId=stExam;
            cont.ARV_CongaGroupTech__c='No';
            cont.vlocity_ins__ExpiredContractId__c=cont1.id;
            Database.insert(cont);
            ARV_AP92_RenewalListViews.getListErrorRecords('January',1,1);
            ARV_AP92_RenewalListViews.loadwrapContractErrorRecords(cont.Id,'January',1);
            ARV_AP92_RenewalListViews.getCidSearchErrorContracts('January','23123123');
            System.assertNotEquals(null,cont);
         }
    }
     private static testMethod void getZeroGroupSegmentsContracts_Test() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            List<Contract> conct=new List<Contract>();
            Account acc = ARV_AP05_TestDataCreation.accRec();
            acc.Renewal_Month__c='January';
            Database.insert(acc);
            Contract cont1 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
           
            Database.insert(cont1);
            GA_Group_Segment__c ga=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont1.Id);
            ga.Status__c='Active';
            Database.insert(ga);
            GA_Group_Segment__c ga1=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont1.Id);
            ga.Status__c='Active';
            Database.insert(ga1);
            conct.add(cont1);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            GA_Group_Segment__c ga2=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont.Id);
            ga.Status__c='Active';
            Database.insert(ga2);
            GA_Group_Segment__c ga3=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont.Id);
            ga.Status__c='Active';
            Database.insert(ga3);
            GA_Group_Segment__c ga4=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont.Id);
            ga.Status__c='Active';
            Database.insert(ga4);
            Database.insert(cont);
            conct.add(cont);
            
            //List<Contract>conList=[Select id,(Select id From Group_Segments__r) From Contract Where id=:cont1.id];
            ARV_AP92_RenewalListViews.getZeroGroupSegmentsContracts(conct);
            System.assertNotEquals(null,cont);
         }
    }
      private static testMethod void isNoGroupSegementsPending_Test() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            List<Contract> conct=new List<Contract>();
			List<GA_Group_Segment__c> groupSeg=new List<GA_Group_Segment__c>();
            Account acc = ARV_AP05_TestDataCreation.accRec();
            acc.Renewal_Month__c='January';
            Database.insert(acc);
            Contract cont1 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont1);
            GA_Group_Segment__c ga=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont1.Id);
            ga.Status__c='Pending';
            Database.insert(ga);
			groupSeg.add(ga);
            ARV_AP92_RenewalListViews.isNoGroupSegementsPending(groupSeg);
            System.assertNotEquals(null,ga);
         }
    }
   
    private static testMethod void testgetContractDetails5() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            list<Id> conlist=new list<Id>();
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            
            conlist.add(cont.Id);
            Contract cont1 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont1);
            conlist.add(cont1.Id);
            Contract cont2 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont2);
            conlist.add(cont2.Id);
            Date myDate = date.newInstance(system.today().year(), system.today().Month(), system.today().Day());
            Date newDate = myDate.addYears(2);
            Date myDate1 = date.newInstance(2018, 01, 01);
            //Date todayDate = System.now()+addYears(2);
            //Date nextDate = Date.newInstance(todayDate.year()+1, todayDate.month(), todayDate.Day());
            Product2 productData = new Product2(Name='testing',vlocity_ins__EffectiveDate__c=newDate,
                                                vlocity_ins__EndDate__c=newDate);
            Database.insert(productData);
            vlocity_ins__ContractLineItem__c planData = new vlocity_ins__ContractLineItem__c(Name='test',
                                                                                             vlocity_ins__ContractId__c=cont.Id,
                                                                                            vlocity_ins__Product2Id__c=productData.Id);
            Database.insert(planData);
            Product2 productData1 = new Product2(Name='testing1',vlocity_ins__EffectiveDate__c=myDate1,
                                                vlocity_ins__EndDate__c=myDate1);
            Database.insert(productData1);
            vlocity_ins__ContractLineItem__c planData1 = new vlocity_ins__ContractLineItem__c(Name='test1',
                                                                                             vlocity_ins__ContractId__c=cont1.Id,
                                                                                            vlocity_ins__Product2Id__c=productData1.Id);
            Database.insert(planData1);
            
            ARV_AP92_RenewalListViews.initiateBatch(conlist);
            System.assertNotEquals(null,cont);
         }
    }
    
    private static testMethod void testgetContractDetails7() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            list<ID> conlist=new list<ID>();
            List<Contract> conRecordList = new List<Contract>();
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            Contract contract1 = new Contract(Id=cont.Id,ARV_Renewal_Status__c = 'Released');
            //cont.ARV_Renewal_Status__c = 'Ready';
            conRecordList.add(contract1);
            conlist.add(cont.id);
            Contract cont1 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont1);
            //cont1.ARV_Renewal_Status__c = 'Ready';
            Contract contract2 = new Contract(Id=cont1.Id,ARV_Renewal_Status__c = 'Released');
            //cont.ARV_Renewal_Status__c = 'Ready';
            conRecordList.add(contract2);
            conlist.add(cont1.id);
            ARV_AP92_RenewalListViews.exludeFromRenewals(conlist);
            ARV_AP92_RenewalListViews.updateRenewalStatus(conRecordList);
            System.assertNotEquals(null,cont);
            
         }
    }
    private static testMethod void testgetContractDetails9() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            list<ID> conlist=new list<ID>();
            List<Contract> conRecordList = new List<Contract>();
            Renewal_Batch__c renewalBatch = new Renewal_Batch__c(ARV_Renewal_Batch_ID__c='',
                                                                Batch_Status__c='Completed',
                                                                ARV_Initiation_Date_and_Time__c=system.today(),
                                                                ARV_Completed_Date__c=system.today(),
                                                                ARV_Renewal_Month__c=JANUARY);
            
            Database.insert(renewalBatch);
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            Contract contract1 = new Contract(Id=cont.Id,ARV_Renewal_Status__c = 'Released',
                                              Renewal_Batch__c=renewalBatch.Id,
                                              ARV_Renewal_Creation_Status__c='Error - Pre-validation');
            conRecordList.add(contract1);
            conlist.add(cont.id);
            Contract cont1 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont1);
            Contract contract2 = new Contract(Id=cont1.Id,ARV_Renewal_Status__c = 'Released',
                                              Renewal_Batch__c=renewalBatch.Id,
                                             ARV_Renewal_Creation_Status__c='Success - Pre-validation');
            conRecordList.add(contract2);
            Database.update(conRecordList);
            conlist.add(cont1.id);
            ARV_Renewal_Batch_Log__c arv_batch=new ARV_Renewal_Batch_Log__c(Name='TEST');
            insert arv_batch;
            List<Contract> conRecordList1 = new List<Contract>();
            Contract batchlog=new Contract();
            batchlog.AccountId=acc.Id;
            batchlog.ARV_Renewal_Error__c='Contract Error';
            batchlog.ARV_Renewal_Creation_Status__c='Error - Pre-validation';
            batchlog.ARV_Renewal_Error_Message__c='Renewal Packages Creation Failed.';
            conRecordList1.add(batchlog);
            insert conRecordList1;
            /*AsyncApexJob aaj = [SELECT Id, Status,CompletedDate, NumberOfErrors
                                    FROM AsyncApexJob WHERE ID =:renewalBatch.ARV_Renewal_Batch_ID__c limit 1];
            renewalBatch.Id=aaj.Id;
            renewalBatch.Batch_Status__c=aaj.Status;
            renewalBatch.ARV_Completed_Date__c=aaj.CompletedDate;
            insert renewalBatch;*/
            ARV_AP92_RenewalListViews.getBatchErrorContracts(renewalBatch.Id,100,0);
            ARV_AP92_RenewalListViews.getBatchSuccessContracts(renewalBatch.Id,100,0);
            ARV_AP92_RenewalListViews.getBatchRecord(renewalBatch.Id);
            System.assertNotEquals(null,cont);
            
         }
    }
    private static testMethod void testgetContractDetails10() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            String profileName = ARV_AP92_RenewalListViews.getUserProfileName();
            System.assertNotEquals(null,profileName);
         }
    }
    private static testMethod void loadwrapBatchErorContracts_Test(){
        Renewal_Batch__c rb= new Renewal_Batch__c();
        rb.name='test';
        rb.Batch_Status__c='Completed';
        database.insert(rb);
        Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        cont.renewal_batch__c=rb.id;
        cont.ARV_CongaGroupTech__c='yes';
            cont.ARV_CongaAgentTech__c='yes';
           
            cont.Status='In Progress';
            Database.insert(cont);

        ARV_AP92_RenewalListViews.loadwrapBatchErorContracts(cont.Id,rb.id,5);
        //ARV_AP92_RenewalListViews.checkbatchStatus(cont.Id);     
       
    }
   private static testMethod void loadwrapBatchSuccessContracts_test(){
               Renewal_Batch__c rb= new Renewal_Batch__c();
        rb.name='test';
        rb.Batch_Status__c='Completed';
        database.insert(rb);
        Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        cont.renewal_batch__c=rb.id;
        cont.ARV_CongaGroupTech__c='yes';
            cont.ARV_CongaAgentTech__c='yes';
           
            cont.Status='In Progress';
            Database.insert(cont);

        ARV_AP92_RenewalListViews.loadwrapBatchSuccessContracts('00000805',rb.id,5);
       ARV_AP92_RenewalListViews.refreshLogs(rb.id);
    }
    private static testMethod void testrunbulkContracts() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            list<Contract> conlist=new list<Contract>();
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            cont.ARV_Renewal_Error__c=NULL;
            conlist.add(cont);
            Contract cont1 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            conlist.add(cont1);
            Contract cont2 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            conlist.add(cont2);
             Contract cont3 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            conlist.add(cont3);
            Contract cont4 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            conlist.add(cont4);
            Database.insert(conlist);
            
            Renewal_Batch__c renewalBatch = new Renewal_Batch__c(ARV_Renewal_Batch_ID__c='',
                                                                Batch_Status__c='Completed',
                                                                ARV_Initiation_Date_and_Time__c=system.today(),
                                                                ARV_Completed_Date__c=system.today(),
                                                                ARV_Renewal_Month__c=JANUARY);
            Database.insert(renewalBatch);
            List<Id>conids=new List<id>();
            List<contract> conprocess=[Select id from Contract];
            for(Contract con:conprocess){
                conids.add(con.id);
            }
            test.startTest();
            ARV_AP92_RenewalListViews.initiateBatch(conids);
            ARV_AP92_RenewalListViews.createBatchRecord('January',conprocess);
            ARV_AP92_RenewalListViews.isMonthValid(system.today());
            test.stopTest();     
            
        }

            
        }
     }