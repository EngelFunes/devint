/*****************************************************************************************
Class Name   : ARV_AP90_GSAddressSplit_Test. 
Date Created : 18-Mar-2020
Created By   : IDC Offshore
Description  : This is the class for testing Splitting Address in Group Segments...
******************************************************************************************/
@isTest
public without sharing class ARV_AP90_GSAddressSplit_Test {
    private static final String ADDRESS='derfeferg fherfr ygeygrf gegrf dftrcrtcectec '+
        'etrectyeghgh ghhgyugyugyugtuygtyu gygyugyugyugug gyguuygiigiu guguuguggyuguguyg '+
        'gyugyugtyuguygugyugyu guyguyugugtder seserss ssses sesrs';
      
    /*****************************************************************************************
    Method Name  : splitAddresstest. 
    Date Created : 18-Mar-2020
    Created By   : IDC Offshore
    Description  : This is the method for Physical,Admin,Billing address split.
    ******************************************************************************************/ 
    private static testmethod void splitAddresstest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {        
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            testAccount.ARV_Association_Cluster_Code__c='BC';
            database.insert(testAccount);
            
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
            database.insert(gaAccount);
            
            Contact testContact =  GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
            testContact.vlocity_ins__Type__c='Agent';
            testContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(testContact);
            
            Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod.Carrier_Type__c= 'BCN';
            prod.Family = 'BCN HSA';
            database.insert(prod);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            plan.vlocity_ins__ProductId__c=prod.Id;
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
            testAccount.id,cont1.Id,city.Id,county.Id);
            locSegment.ARV_Admin_Address__c=ADDRESS;
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Medical_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            
                test.startTest();
                ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
                ARV_AP90_GSAddressSplit.splitAddress(locSegment.ARV_Admin_Address__c);
                test.stopTest();
                System.assertNotEquals(null,cont1.Id);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    /*****************************************************************************************
    Method Name  : splitAddresstest1. 
    Date Created : 18-Mar-2020
    Created By   : IDC Offshore
    Description  : This is the method for Physical,Admin,Billing address split.
    ******************************************************************************************/
    private static testmethod void splitAddresstest1()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {        
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            testAccount.ARV_Association_Cluster_Code__c='BC';
            database.insert(testAccount);
            
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
            database.insert(gaAccount);
            
            Contact testContact =  GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
            testContact.vlocity_ins__Type__c='Agent';
            testContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(testContact);
            
            Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod.Carrier_Type__c= 'BCN';
            prod.Family = 'BCN HSA';
            database.insert(prod);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            plan.vlocity_ins__ProductId__c=prod.Id;
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
            testAccount.id,cont1.Id,city.Id,county.Id);
            locSegment.ARV_Billing_Address__c=ADDRESS;
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Medical_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            
                test.startTest();
                ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
                ARV_AP90_GSAddressSplit.splitAddress(locSegment.ARV_Location_Physical_Address__c);
                test.stopTest();
                System.assertNotEquals(null,cont1.Id);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    
    /*****************************************************************************************
    Method Name  : splitAddresstest2. 
    Date Created : 18-Mar-2020
    Created By   : IDC Offshore
    Description  : This is the method for Physical,Admin,Billing address split.
    ******************************************************************************************/
    private static testmethod void splitAddresstest2()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {        
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            testAccount.ARV_Association_Cluster_Code__c='BC';
            database.insert(testAccount);
            
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
            database.insert(gaAccount);
            
            Contact testContact =  GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
            testContact.vlocity_ins__Type__c='Agent';
            testContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(testContact);
            
            Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod.Carrier_Type__c= 'BCN';
            prod.Family = 'BCN HSA';
            database.insert(prod);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            plan.vlocity_ins__ProductId__c=prod.Id;
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
            testAccount.id,cont1.Id,city.Id,county.Id);
            locSegment.ARV_Location_Physical_Address__c=ADDRESS;
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Medical_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            
                test.startTest();
                ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
                ARV_AP90_GSAddressSplit.splitAddress(locSegment.ARV_Admin_Address__c);
                test.stopTest();
                 System.assertNotEquals(null,cont1.Id);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
}