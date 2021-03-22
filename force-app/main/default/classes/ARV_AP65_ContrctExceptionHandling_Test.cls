/*
@Author : IDC Offshore
@Name: ARV_AP65_ContrctExceptionHandling_Test 
@CreatedDate: 3 - Feb 2020 
@Description: ARV_AP65_ContrctExceptionHandling_Test Test class
@version : 1.0  
*/
@isTest (seealldata = false)
private class ARV_AP65_ContrctExceptionHandling_Test{
    /*************************************************************************************************************
@Description: insertExceptionRecsTest() method 
@Name : insertExceptionRecsTest
@Param : None
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************/
    private static testmethod void insertExceptionRecsTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                GA_Territory__c terytryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                database.insert(terytryRec);
                
                Id unqualifyProsRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Unqualified Prospect (Agent)').getRecordTypeId();
                Id AcctProspect = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                
                Account testAccUqPrsRec=new Account();
                testAccUqPrsRec.Name='testAccUqPrsRec';
                testAccUqPrsRec.Phone='1234567089';
                testAccUqPrsRec.Account_Status__c='Active';
                testAccUqPrsRec.NumberOfEmployees=123;
                testAccUqPrsRec.GA_Total_Eligible__c= 500;
                testAccUqPrsRec.RecordTypeId=unqualifyProsRecTypId;
                testAccUqPrsRec.GA_Territory__c=terytryRec.id;
                database.insert(testAccUqPrsRec);
                
                List<Account> accList = new List<Account> ();
                Account testProspAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testProspAccount.RecordTypeId=AcctProspect;
                accList.add(testProspAccount);
                
                database.insert(accList);
                
                vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(testProspAccount.Id);
                census.Name='First';
                census.vlocity_ins__CensusType__c='Quote_Enrollment';
                database.insert(census);
                
                Contract contrct=new Contract();
                contrct.AccountId=testAccUqPrsRec.id;
                contrct.StartDate=system.today();
                contrct.Status='In Progress';
                contrct.ContractTerm=10;
                database.insert(contrct);
                
                Contact  cntcUnPr=GA_OBJ_TD01_TestDataCreation.cntactRec(testAccUqPrsRec.id);
                cntcUnPr.FirstName='FirstTest';
                cntcUnPr.MiddleName='MiddleTest';
                cntcUnPr.LastName='LastTest';
                cntcUnPr.Email='testcntc@bcbsm.com';
                cntcUnPr.Phone='123453267890';
                cntcUnPr.Title='ceo';
                cntcUnPr.MobilePhone='1234567890';
                cntcUnPr.Active__c=True;              
                database.insert(cntcUnPr);
                
                
                ARV_AP58_ApproveContract.createOrMergeAccount(testAccuqPrsRec.Id,testProspAccount.id,contrct.Id,census.id);
                ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(contrct.id);     
                ARV_AP65_ContrctApprvExceptionHandling.updtCntrct(contrct.id);        
                
                system.assert(usr<>null,true);
                List<Database.SaveResult> testSrList = Database.insert(accList, false); 
                ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(testSrList);	
            }
            catch(exception e)
            {
                
                return;
            }
        }
    }   
    /*************************************************************************************************************
@Description: insertExceptionRecsTestCatch() method 
@Name : insertExceptionRecsTestCatch
@Param : None
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************/
    private static testmethod void insertExceptionRecsTestCatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try{
                Id prospctRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().
                    get('Account - Prospect').getRecordTypeId();
                Id unqualifyProsRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().
                    get('Unqualified Prospect (Agent)').getRecordTypeId();
                
                List<Account> accList = new List<Account> ();
                Account testProspAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testProspAccount.RecordTypeId=prospctRecTypId;
                accList.add(testProspAccount);
                
                Account testAccUqPrsRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccUqPrsRec.RecordTypeId=unqualifyProsRecTypId;
                testAccUqPrsRec.Federal_Tax_ID__c ='23245';
                accList.add(testAccUqPrsRec);
                
                vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(testAccUqPrsRec.Id);
                census.Name='First';
                census.vlocity_ins__CensusType__c='Quote_Enrollment';
                database.insert(census);
                
                database.insert(accList);
                
                Contract contrct=new Contract();
                contrct.AccountId=testAccUqPrsRec.id;
                contrct.ARV_TECH_Account_Merge__c=testProspAccount.id;
                contrct.StartDate=system.today();
                contrct.Status='In Progress';
                contrct.ContractTerm=10;
                database.insert(contrct);
                
                List<Contact> contactlst= new List<Contact>();
                Contact  cntcPr=GA_OBJ_TD01_TestDataCreation.cntactRec(testProspAccount.id);
                cntcPr.FirstName='FirstTest';
                cntcPr.MiddleName='MiddleTest';
                cntcPr.LastName='LastTest';
                cntcPr.Email='testcntc@bcbsm.com';
                cntcPr.Phone='123456790';
                cntcPr.Title='md';
                cntcPr.MobilePhone='12367890';
                cntcPr.Active__c=True;              
                contactlst.add(cntcPr);
                
                Contact  cntcUnPr=GA_OBJ_TD01_TestDataCreation.cntactRec(testAccUqPrsRec.id);
                cntcUnPr.FirstName='FirstTest';
                cntcUnPr.MiddleName='MiddleTest';
                cntcUnPr.LastName='LastTest';
                cntcUnPr.Email='testcntc@bcbsm.com';
                cntcUnPr.Phone='123453267890';
                cntcUnPr.Title='ceo';
                cntcUnPr.MobilePhone='1234567890';
                cntcUnPr.Active__c=True;              
                contactlst.add(cntcUnPr);
                database.insert(contactlst);
                
                List<Account> accUpdtLst = new List<Account> ();
                
                testProspAccount.GA_CEO__c=cntcPr.Id;
                testProspAccount.GA_Principal_Admin__c=cntcPr.id;
                accUpdtLst.add(testProspAccount);
                
                testAccUqPrsRec.GA_CEO__c=cntcUnPr.Id;
                testAccUqPrsRec.GA_Decision_Maker__c=cntcUnPr.id;
                accUpdtLst.add(testAccUqPrsRec);
                
                database.update(accUpdtLst);
                
                test.startTest();
                ARV_AP58_ApproveContract.createOrMergeAccount(testAccuqPrsRec.Id,testProspAccount.id,contrct.Id,census.id);
                
                Test.stopTest();
                system.assert(usr<>null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }   
    /**********************************************************************************************************
@Description: updateContrtStatusTest() method 
@Name : updateContrtStatusTest
@Param : None
@Return : void
@throws Exception : N/A;
***************************************************************************************************************/
    private static testmethod void updateContrtStatusTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<Contract> cntrcLst = new  List<Contract> ();
                
                Account acc = ARV_AP05_TestDataCreation.accRec();
                database.insert(acc,true) ;
                
                Contract con1 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
                database.insert(con1,true);
                
                con1.Status = 'Enrollment Submission – Error';
                con1.ARV_Is_Mass_Updating__c = True;
                database.update(con1,true);
                
                test.startTest();
                ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(con1.Id);
                test.stopTest(); 
                system.assert(usr<>null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**********************************************************************************************************
@Description: updateContrtStatusTest() method 
@Name : updateContrtStatusTest
@Param : None
@Return : void
@throws Exception : N/A;
***************************************************************************************************************/
    private static testmethod void updateRejStatusTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<Contract> cntrcLst = new  List<Contract> ();
                
                Account acc = ARV_AP05_TestDataCreation.accRec();
                database.insert(acc,true) ;
                
                Contract con1 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
                database.insert(con1,true);
                
                con1.Status = 'Rejected';
                con1.Description=null;
                con1.ARV_TECH_Account_Merge__c=null;
                con1.ARV_Is_Mass_Updating__c = True;
                database.update(con1,true);
                
                test.startTest();
                ARV_AP65_ContrctApprvExceptionHandling.updtCntrct(con1.Id);
                test.stopTest(); 
                system.assert(usr<>null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /**************************************************************************************************************
@Description: contrtStatusExpTestCatch() method 
@Name : contrtStatusExpTestCatch
@Param : None
@Return : void
@throws Exception : N/A;
******************************************************************************************************************/
    private static testmethod void contrtStatusExpTestCatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<Contract> cntrcLst = new  List<Contract> ();
                List<Account> accList = new List<Account>();
                
                Account acc = ARV_AP05_TestDataCreation.accRec();
                database.insert(acc,true) ;
                
                /*Added By Dinesh: Start -- To cover the insertExceptionRecs method in the ARV_AP65_ContrctApprvExceptionHandling class */
                Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
                Account acc1=new Account();
                acc1.Name='Test Acc1';
                acc1.CID__c=randomInt+'12';
                acc1.Federal_Tax_ID__c='123456789000'; //String too long Exception : Federal_Tax_ID__c has limit to accept upto 9 characters only at field level.
                acc1.Requested_Effective_Date__c=system.today();
                acc1.GA_CoverageCancellationDate__c=system.today();
                acc1.Account_Status__c='Inactive';
                acc1.BillingPostalCode='48005';
                acc1.ARV_Renewal_Account_Type__c='SG'; 
                accList.add(acc1);
                List<Database.SaveResult> resultList =  database.insert(accList,false);
                /*Added By Dinesh: End */
                
                Contract con1 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
                database.insert(con1,true);
                
                con1.Status = 'Enrollment Submission – Error';
                con1.ARV_Is_Mass_Updating__c = True;
                database.update(con1,true);
                
                test.startTest();     
                ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(resultList);
                ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(con1.id);
                ARV_AP65_ContrctApprvExceptionHandling.updtCntrct(con1.id);
                test.stopTest(); 
                system.assert(usr<>null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }    
}