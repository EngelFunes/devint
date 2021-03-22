/*
@Author : IDC offshore
@Name: ARV_AP58_ApproveContract_Test 
@CreatedDate: 24 - Dec 2019 
@Description: ARV_AP58_ApproveContract_Test class
@version : 1.0  
*/
@isTest(SeeAllData=FALSE)
private class ARV_AP58_ApproveContract_Test {
    /**
@Description: mergeAccountTest() method 
@Name : mergeAccountTest
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void mergeAccountTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
                Id prospctRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().
                    get('Account - Prospect').getRecordTypeId();
                Id unqualifyProsRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().
                    get('Unqualified Prospect (Agent)').getRecordTypeId();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId=unqualifyProsRecTypId;
                database.insert(testAccount);
                
                testAccount.RecordTypeId=prospctRecTypId;
                testAccount.GA_Is_Mass_Updating__c=true;
                database.update(testAccount);
                
                Account testAccuqPrsRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccuqPrsRec.RecordTypeId=unqualifyProsRecTypId;
                testAccuqPrsRec.Federal_Tax_ID__c ='23245';
                database.insert(testAccuqPrsRec);
                
                List<Account> accList = New List<Account>();
                
                Account testAccRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccRec.RecordTypeId=prospctRecTypId;
                testAccRec.Federal_Tax_ID__c ='23245';
                accList.add(testAccRec);
                database.insert(accList);
                
                
                Contract cont1=new Contract();
                cont1.AccountId=testAccuqPrsRec.id;
                cont1.ARV_TECH_Account_Merge__c=testAccRec.id;
                cont1.StartDate=system.today();
                cont1.Status='In Progress';
                cont1.ContractTerm=10;
                database.insert(cont1);
                system.debug('Contract1::'+cont1.id);
                List<Contact> cntclst= new List<Contact>();
                Contact  cntc=GA_OBJ_TD01_TestDataCreation.cntactRec(testAccRec.id);
                cntc.FirstName='FirstTest';
                cntc.MiddleName='MiddleTest';
                cntc.LastName='LastTest';
                cntc.Email='testcntc@bcbsm.com';
                cntc.Phone='1234567890';
                cntc.MobilePhone='1234567890';
                cntc.Active__c=False;              
                cntclst.add(cntc);
                database.insert(cntclst);
                
                testAccRec.GA_Decision_Maker__c=cntc.Id;
                database.update(testAccRec);
                
                opportunity oppty=GA_OBJ_TD01_TestDataCreation.optyRec(testAccRec.id);
                list<opportunity> opptyList=new list<opportunity>();
                opptyList.add(oppty);
                database.insert(opptyList);
                
                List<LocationPackage__c> updtLctnSgmtLst = new List<LocationPackage__c> ();
                LocationPackage__c lctnSgmnt = new LocationPackage__c();
                lctnSgmnt.Name='Test';
                lctnSgmnt.ARV_AccountId__c =testAccRec.id;
                lctnSgmnt.ARV_ContractId__c = cont1.Id;
                lctnSgmnt.ARV_CC_Fed_Tax_ID__c='23245';
                lctnSgmnt.ARV_IsCommonControll__c=TRUE;
                updtLctnSgmtLst.add(lctnSgmnt);
                database.insert(updtLctnSgmtLst);
                Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            	prod.Family = 'Medical';
                prod.Carrier_Type__c= 'BCBSM';
	            database.insert(prod);
                vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
                //plan.Carrier_Type__c='BCBSM';
                plan.vlocity_ins__ContractId__c=cont1.id;
        		plan.name='medical';
        		plan.vlocity_ins__Product2Id__c = prod.id;
                database.insert(plan);
                //system.debug('plan::'+plan.Carrier_Type__c);
                Package__c pkg1 = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
                pkg1.ARV_Contract_Id__c=cont1.Id;
                pkg1.ARV_Medical_Plan__c = plan.Id ;
                pkg1.ARV_CDH_Package_Combination__c='Flexible Spending Account';
                database.insert(pkg1);
                Package__c pkg2 = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
                pkg2.ARV_Medical_Plan__c = plan.Id ;
                pkg2.ARV_Contract_Id__c=cont1.Id;
                pkg2.ARV_CDH_Package_Combination__c='Flexible Spending Account';
                database.insert(pkg2);
                List<Package__c> pckglst=new List<Package__c>();
                pckglst.add(pkg1);
                pckglst.add(pkg2);
                //system.debug('package list::'+pckglst);
                List<AccountTeamMember> insrtActMembs = New List<AccountTeamMember>();
                for(Account a :  accList){
                    AccountTeamMember act = GA_OBJ_TD01_TestDataCreation.accountTeamRec(a.Id);
                    act.UserId=usr.id;
                    act.TeamMemberRole = 'Implementation Manager';
                    insrtActMembs.add(act);
                }
                Database.insert(insrtActMembs);
                
                Account testAccRec2 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccRec2.RecordTypeId=prospctRecTypId;
                testAccRec2.Federal_Tax_ID__c ='324';
                database.insert(testAccRec2);
                
                Contact cntc2=GA_OBJ_TD01_TestDataCreation.cntactRec(testAccRec2.id);
                database.insert(cntc2);
                
                
                Contact cntc3=GA_OBJ_TD01_TestDataCreation.cntactRec(testAccRec2.id);
                database.insert(cntc3);
                
                testAccRec.GA_CEO__c=cntc3.Id;
                database.update(testAccRec);              
                testAccuqPrsRec.GA_CEO__c=cntc3.Id; 
                database.update(testAccuqPrsRec); 
                
                AccountContactRelation acr = New AccountContactRelation();
                acr.AccountId = testAccRec.id;
                acr.ContactId = cntc2.id;
                database.insert(acr);
                
                /*vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(testAccount.id);
                census.Contract__c=cont1.id;
                database.insert(census);*/
                
                List<GA_Common_Control__c> cmnctrlLst = new List<GA_Common_Control__c>();
                GA_Common_Control__c newcmnctrl = new GA_Common_Control__c();
                newcmnctrl.name=lctnSgmnt.Name;
                newcmnctrl.GA_Federal_Tax_ID_Number__c=lctnSgmnt.ARV_CC_Fed_Tax_ID__c;
                newcmnctrl.GA_AccountId__c=testAccRec.id;
                newcmnctrl.ARV_CC_LocationSegment__c=lctnSgmnt.Id;
                cmnctrlLst.add(newcmnctrl);
                database.insert(cmnctrlLst);
                vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(testAccuqPrsRec.id);
                census.Contract__c=cont1.id;
                database.insert(census);
                system.debug('Census::'+census);
                test.startTest();
                ARV_AP58_ApproveContract.createOrMergeAccount(testAccuqPrsRec.Id,testAccRec.id,cont1.Id,census.id);
                ARV_AP58_ApproveContract.commonControlCreate(cont1.Id);
                ARV_AP58_ApproveContract.sendEmailCDH(cont1.Id);
                Test.stopTest();
                  system.assert(usr<>null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
      /**
@Description: mergeAccountDuplctCntctTest() method 
@Name : mergeAccountDuplctCntctTest
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void mergeAccountDuplctCntctTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
           try
            {
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
                
                database.insert(accList);
                
                Contract contrct=new Contract();
                contrct.AccountId=testAccUqPrsRec.id;
                contrct.ARV_TECH_Account_Merge__c=testProspAccount.id;
                contrct.StartDate=system.today();
                contrct.Status='In Progress';
                contrct.ContractTerm=10;
                database.insert(contrct);
                system.debug('Contract2::'+contrct.id);
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
                
                 opportunity oppty=GA_OBJ_TD01_TestDataCreation.optyRec(testAccUqPrsRec.id);
                list<opportunity> opptyList=new list<opportunity>();
                opptyList.add(oppty);
                database.insert(opptyList);
                List<Account> accUpdtLst = new List<Account> ();
                
                testProspAccount.GA_CEO__c=cntcPr.Id;
                testProspAccount.GA_Decision_Maker__c=cntcPr.id;
                testProspAccount.GA_Principal_Admin__c=cntcPr.id;
                accUpdtLst.add(testProspAccount);
                
                testAccUqPrsRec.GA_CEO__c=cntcUnPr.Id;
                testAccUqPrsRec.GA_Decision_Maker__c=cntcUnPr.id;
                testAccUqPrsRec.GA_Principal_Admin__c=cntcUnPr.id;
                accUpdtLst.add(testAccUqPrsRec);
                
                database.update(accUpdtLst);
                
                vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(testAccuqPrsRec.id);
                census.Contract__c=contrct.id;
                database.insert(census);
                //system.debug('Census::'+census);
                test.startTest();
                ARV_AP58_ApproveContract.createOrMergeAccount(testAccuqPrsRec.Id,testProspAccount.id,contrct.Id,census.id);
                
                ARV_AP58_ApproveContract.commonControlCreate(contrct.Id);
                ARV_AP58_ApproveContract.sendEmailCDH(contrct.Id);
                Test.stopTest();
            system.assert(usr<>null);
           }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: createAccountTest() method 
@Name : createAccountTest
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void createAccountTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
                Id prospctRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().
                    get('Account - Prospect').getRecordTypeId();
                Id unqualifyProsRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().
                    get('Unqualified Prospect (Agent)').getRecordTypeId();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId=unqualifyProsRecTypId;
                database.insert(testAccount);
                
                testAccount.RecordTypeId=prospctRecTypId;
                testAccount.GA_Is_Mass_Updating__c=true;
                database.update(testAccount);
                
                Account testAccuqPrsRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccuqPrsRec.RecordTypeId=unqualifyProsRecTypId;
                testAccuqPrsRec.Federal_Tax_ID__c ='23245';
                database.insert(testAccuqPrsRec);
                
                List<Account> accList = New List<Account>();
                
                Account testAccRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccRec.RecordTypeId=prospctRecTypId;
                testAccRec.Federal_Tax_ID__c ='23245';
                accList.add(testAccRec);
                database.insert(accList);
                
                Contract cont1=new Contract();
                cont1.AccountId=testAccuqPrsRec.id;
                cont1.ARV_TECH_Account_Merge__c=null;
                cont1.StartDate=system.today();
                cont1.Status='In Progress';
                cont1.ContractTerm=10;
                database.insert(cont1);
                system.debug('Contract3::'+cont1.id);
                List<Contact> cntclst= new List<Contact>();
                Contact  cntc=GA_OBJ_TD01_TestDataCreation.cntactRec(testAccRec.id);
                cntc.FirstName='FirstTest';
                cntc.MiddleName='MiddleTest';
                cntc.LastName='LastTest';
                cntc.Email='testcntc@bcbsm.com';
                cntc.Phone='1234567890';
                cntc.MobilePhone='1234567890';
                cntc.Active__c=False;              
                cntclst.add(cntc);
                database.insert(cntclst);
                
                testAccRec.GA_Decision_Maker__c=cntc.Id;
                database.update(testAccRec);
                
                opportunity oppty=GA_OBJ_TD01_TestDataCreation.optyRec(testAccRec.id);
                list<opportunity> opptyList=new list<opportunity>();
                opptyList.add(oppty);
                database.insert(opptyList);
                
                Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            	prod.Family = 'Medical';
                prod.name='Simply Blue℠ PPO Gold $1500 W/ Elective Abortion (CRNT)';
                prod.Carrier_Type__c= 'BCBSM';
	            database.insert(prod);
                system.debug('Product::'+prod);
                system.debug('Carrier type:'+prod.Carrier_Type__c);
                vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
                //plan.Carrier_Type__c='BCBSM';
                plan.vlocity_ins__ContractId__c=cont1.id;
        		plan.name='Simply Blue℠ PPO Gold $1500 W/ Elective Abortion (CRNT)';
        		plan.vlocity_ins__Product2Id__c = prod.id;
                //plan.vlocity_ins__Product2Id__c=prod.id;
                database.insert(plan);
                system.debug('plan::'+plan.Carrier_Type__c);
                system.debug(':Plan :'+plan);
                //system.debug(':Plan carrier2:'+plan.vlocity_ins__Product2Id__r.Carrier_Type__c);
                Package__c pkg1 = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
                pkg1.ARV_Contract_Id__c=cont1.Id;
                pkg1.ARV_Medical_Plan__c = plan.Id ;
                system.debug('Medical Plan::'+pkg1.ARV_Medical_Plan__c);
                //Pkg1.ARV_Medical_Plan__r.Carrier_Type__c='BCBSM';
                pkg1.ARV_CDH_Package_Combination__c='Flexible Spending Account';
                database.insert(pkg1);
                system.debug('Carrier::'+Pkg1.ARV_Medical_Plan__r.Carrier_Type__c);
                system.debug('CDH::'+Pkg1.ARV_CDH_Package_Combination__c);
                Package__c pkg2 = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
                pkg2.ARV_Medical_Plan__c = plan.Id ;
                pkg2.ARV_Contract_Id__c=cont1.Id;
                pkg2.ARV_CDH_Package_Combination__c='Flexible Spending Account';
                database.insert(pkg2);
                List<Package__c> pckglst=new List<Package__c>();
                pckglst.add(pkg1);
                pckglst.add(pkg2);
                system.debug('package list::'+pckglst);
                
                List<LocationPackage__c> updtLctnSgmtLst = new List<LocationPackage__c> ();
                LocationPackage__c lctnSgmnt = new LocationPackage__c();
                lctnSgmnt.Name='Test';
                lctnSgmnt.ARV_AccountId__c =testAccRec.id;
                lctnSgmnt.ARV_ContractId__c = cont1.Id;
                lctnSgmnt.ARV_CC_Fed_Tax_ID__c='23245';
                lctnSgmnt.ARV_IsCommonControll__c=TRUE;
                updtLctnSgmtLst.add(lctnSgmnt);
                database.insert(updtLctnSgmtLst);
                
                
                List<AccountTeamMember> insrtActMembs = New List<AccountTeamMember>();
                for(Account a :  accList){
                    AccountTeamMember act = GA_OBJ_TD01_TestDataCreation.accountTeamRec(a.Id);
                    act.UserId=usr.id;
                    act.TeamMemberRole = 'Implementation Manager';
                    insrtActMembs.add(act);
                }
                Database.insert(insrtActMembs);
                
                Account testAccRec2 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccRec2.RecordTypeId=prospctRecTypId;
                testAccRec2.Federal_Tax_ID__c ='324';
                database.insert(testAccRec2);
                
                Contact cntc2=GA_OBJ_TD01_TestDataCreation.cntactRec(testAccRec2.id);
                database.insert(cntc2);
                
                AccountContactRelation acr = New AccountContactRelation();
                acr.AccountId = testAccRec.id;
                acr.ContactId = cntc2.id;
                database.insert(acr);
                
                List<GA_Common_Control__c> cmnctrlLst = new List<GA_Common_Control__c>();
                GA_Common_Control__c newcmnctrl = new GA_Common_Control__c();
                newcmnctrl.name=lctnSgmnt.Name;
                newcmnctrl.GA_Federal_Tax_ID_Number__c=lctnSgmnt.ARV_CC_Fed_Tax_ID__c;
                newcmnctrl.GA_AccountId__c=testAccRec.id;
                newcmnctrl.ARV_CC_LocationSegment__c=lctnSgmnt.Id;
                cmnctrlLst.add(newcmnctrl);
                database.insert(cmnctrlLst);
                
                test.startTest();
                ARV_AP58_ApproveContract.createOrMergeAccount(testAccuqPrsRec.Id,null,cont1.Id,cont1.vlocity_ins__EnrollmentCensusId__c);
                ARV_AP58_ApproveContract.commonControlCreate(cont1.Id);
                ARV_AP58_ApproveContract.sendEmailCDH(cont1.Id);
                Test.stopTest();
                  system.assert(usr<>null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: crtMrgAccountTestExcptns() method 
@Name : crtMrgAccountTestExcptns
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void crtMrgAccountTestExcptns()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
                Id prospctRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().
                    get('Account - Prospect').getRecordTypeId();
                Id unqualifyProsRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().
                    get('Unqualified Prospect (Agent)').getRecordTypeId();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId=unqualifyProsRecTypId;
                database.insert(testAccount);
                
                testAccount.RecordTypeId=prospctRecTypId;
                testAccount.GA_Is_Mass_Updating__c=true;
                database.update(testAccount);
                
                Account testAccuqPrsRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccuqPrsRec.RecordTypeId=unqualifyProsRecTypId;
                testAccuqPrsRec.Federal_Tax_ID__c ='23245';
                database.insert(testAccuqPrsRec);
                
                List<Account> accList = New List<Account>();
                
                Account testAccRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccRec.RecordTypeId=prospctRecTypId;
                testAccRec.Federal_Tax_ID__c ='23245';
                accList.add(testAccRec);
                database.insert(accList);
                
                Contract cont1=new Contract();
                cont1.AccountId=testAccuqPrsRec.id;
                cont1.StartDate=system.today();
                cont1.Status='In Progress';
                cont1.ContractTerm=10;
                database.insert(cont1);
                system.debug('Contract4::'+cont1.id);
                test.startTest();
                ARV_AP58_ApproveContract.createOrMergeAccount(null,null,null,null);
                ARV_AP58_ApproveContract.commonControlCreate(null);
                ARV_AP58_ApproveContract.sendEmailCDH(null);
                Test.stopTest();
                  system.assert(usr<>null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: crtMrgCmmnCntrlTestExcptns() method 
@Name : crtMrgCmmnCntrlTestExcptns
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void crtMrgCmmnCntrlTestExcptns()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
                Id prospctRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().
                    get('Account - Prospect').getRecordTypeId();
                Id unqualifyProsRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().
                    get('Unqualified Prospect (Agent)').getRecordTypeId();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId=unqualifyProsRecTypId;
                database.insert(testAccount);
                
                testAccount.RecordTypeId=prospctRecTypId;
                testAccount.GA_Is_Mass_Updating__c=true;
                database.update(testAccount);
                
                Account testAccuqPrsRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccuqPrsRec.RecordTypeId=unqualifyProsRecTypId;
                testAccuqPrsRec.Federal_Tax_ID__c ='23245';
                database.insert(testAccuqPrsRec);
                
                List<Account> accList = New List<Account>();
                
                Account testAccRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccRec.RecordTypeId=prospctRecTypId;
                testAccRec.Federal_Tax_ID__c ='23245';
                accList.add(testAccRec);
                database.insert(accList);
                
                Contract cont1=new Contract();
                cont1.AccountId=testAccuqPrsRec.id;
                cont1.StartDate=system.today();
                cont1.Status='In Progress';
                cont1.ContractTerm=10;
                database.insert(cont1);
                
                test.startTest();
                ARV_AP58_ApproveContract.commonControlCreate(null);
                Test.stopTest();
                  system.assert(usr<>null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}