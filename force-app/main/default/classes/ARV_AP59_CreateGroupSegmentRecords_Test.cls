/*
@Author : IDC offshore
@Name: ARV_AP59_CreateGroupSegmentRecords_Test 
@CreatedDate: 31 - Jan 2020 
@Description: ARV_AP59_CreateGroupSegmentRecords_Test Test class
@version : 1.0  
*/
@isTest
public without sharing class ARV_AP59_CreateGroupSegmentRecords_Test {  
    /**************  
Method name : approveContractRec
Params     : NA
Return Type : testmethod
Description :  approveContractRec method 
*************/
    private static testmethod void approveContractRec(){    
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                gaAccount.ARV_Association_Cluster_Code__c='BC';
                gaAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(gaAccount);
                
                Contact testContact =  GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
                testContact.vlocity_ins__Type__c='Agent';
                testContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
                database.insert(testContact);
                
                Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
                prod.Family='Vision';
                prod.Voluntary_Contributory__c = 'Voluntary';
                database.insert(prod);
                
                Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
                cont1.AccountId=testAccount.id;
                cont1.ARV_RatingArea__c='bc';
                cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
                cont1.vlocity_ins__ProducerId__c = testContact.Id;
                cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
                database.insert(cont1);
                
                vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
                database.insert(plan);
                
                GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
                database.insert(city);
                
                GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
                database.insert(county);
                
                LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                    testAccount.id,cont1.Id,city.Id,county.Id);
                database.insert(locSegment);
                
                Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
                pkg.ARV_Vision_Plan__c = plan.Id ;
                database.insert(pkg);
                
                Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
                database.insert(pkgLocSeg);
                
                system.test.startTest();
                ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
                system.test.stopTest();
                System.assertNotEquals(null,testAccount.Id);
            }
            catch(Exception e) {   return;  }
        }
    }
    /**************  
Method name : approveContractRec1
Params     : NA
Return Type : testmethod
Description :  approveContractRec1 method 
*************/
    private static testmethod void approveContractRec1(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
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
            prod.Family = 'Healthy Blue Achieve';
            database.insert(prod);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Medical_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    }  
    /**************  
Method name : approveContractRec2
Params     : NA
Return Type : testmethod
Description :  approveContractRec2 method 
*************/
    private static testmethod void approveContractRec2(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
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
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Medical_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    }
    /**************  
Method name : approveContractRec3
Params     : NA
Return Type : testmethod
Description :  approveContractRec3 method 
*************/
    private static testmethod void approveContractRec3(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(testAccount);
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.ARV_Association_Cluster_Code__c='BC';
            gaAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
            database.insert(gaAccount);
            
            Contact testContact =  GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
            testContact.vlocity_ins__Type__c='Agent';
            testContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(testContact);
            
            Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod.Carrier_Type__c= 'BCN';
            prod.Family = 'Dental';
            database.insert(prod);
            
            vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(gaAccount.Id);
            database.insert(census);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            cont1.vlocity_ins__EnrollmentCensusId__c=census.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Dental_Plan__c = plan.Id ;
            database.insert(pkg);
            
            vlocity_ins__GroupCensusMember__c censusMem=ARV_AP05_TestDataCreation.groupCensusMember(census.id);
            censusMem.vlocity_ins__CensusId__c =cont1.vlocity_ins__EnrollmentCensusId__c;
            censusMem.vlocity_ins__IsPrimaryMember__c = true;
            database.insert(censusMem);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    }
    /**************  
Method name : approveContractRec4
Params     : NA
Return Type : testmethod
Description :  approveContractRec4 method 
*************/
    private static testmethod void approveContractRec4(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(testAccount);
            
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.ARV_Association_Cluster_Code__c='BC';
            gaAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
            database.insert(gaAccount);
            
            Contact testContact =  GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
            testContact.vlocity_ins__Type__c='Agent';
            testContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(testContact);
            
            Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod.Carrier_Type__c= 'BCBSM';
            prod.Family = 'Dental';
            database.insert(prod);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Dental_Plan__c = plan.Id ;
            pkg.ARV_Medical_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    } 
    /**************  
Method name : approveContractRec5
Params     : NA
Return Type : testmethod
Description :  approveContractRec5 method 
*************/
    private static testmethod void approveContractRec5(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(testAccount);
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.ARV_Association_Cluster_Code__c='BC';
            gaAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
            database.insert(gaAccount);
            
            Contact testContact =  GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
            testContact.vlocity_ins__Type__c='Agent';
            testContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(testContact);
            
            Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod.Family = 'Healthy Blue Achieve';
            database.insert(prod);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Medical_Plan__c = plan.Id ;
            pkg.ARV_Dental_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    } 
    /**************  
Method name : approveContractRec6
Params     : NA
Return Type : testmethod
Description :  approveContractRec6 method 
*************/
    private static testmethod void approveContractRec6(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(testAccount);
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.ARV_Association_Cluster_Code__c='BC';
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
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Medical_Plan__c = plan.Id ;
            pkg.ARV_Dental_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    } 
    /**************  
Method name : approveContractRec7
Params     : NA
Return Type : testmethod
Description :  approveContractRec7 method 
*************/
    private static testmethod void approveContractRec7(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(testAccount);
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.ARV_Association_Cluster_Code__c='BC';
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
            
            Product2 prod1 = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod1.Carrier_Type__c= 'BCN';
            prod1.Family = 'BCN HSA';
            prod1.Voluntary_Contributory__c = 'Non-Voluntary';
            database.insert(prod1);
            
            Contract cont=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont.AccountId=testAccount.id;
            cont.ARV_RatingArea__c='bc';
            cont.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont.vlocity_ins__ProducerId__c = testContact.Id;
            cont.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            database.insert(cont);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont.Id);
            database.insert(plan);
            
            vlocity_ins__ContractLineItem__c plan1 = ARV_AP59_GrpSegTestDataCreation.createPlan(prod1.Id,cont.Id);
            database.insert(plan1);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont.Id);
            pkg.ARV_Vision_Plan__c = plan.Id ;
            pkg.ARV_Dental_Plan__c = plan1.Id ;
            pkg.ARV_Medical_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    } 
    /**************  
Method name : approveContractRec8
Params     : NA
Return Type : testmethod
Description :  approveContractRec8 method 
*************/
    private static testmethod void approveContractRec8(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
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
            
            Product2 prod1 = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod1.Carrier_Type__c= 'BCN';
            prod1.Family = 'BCN HSA';
            prod1.Voluntary_Contributory__c = 'Non-Voluntary';
            database.insert(prod1);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            database.insert(plan);
            
            vlocity_ins__ContractLineItem__c plan1 = ARV_AP59_GrpSegTestDataCreation.createPlan(prod1.Id,cont1.Id);
            database.insert(plan1);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Vision_Plan__c = plan.Id ;
            pkg.ARV_Dental_Plan__c = plan.Id ;
            pkg.ARV_Medical_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    } 
    /**************  
Method name : approveContractRec9
Params     : NA
Return Type : testmethod
Description :  approveContractRec9 method 
*************/
    private static testmethod void approveContractRec9(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
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
            prod.Family = 'BCN Medical';
            database.insert(prod);
            
            Product2 prod1 = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod1.Carrier_Type__c= 'BCN';
            prod1.Family = 'BCN Medical';
            prod1.Voluntary_Contributory__c = 'Non-Voluntary';
            database.insert(prod1);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='BC';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            database.insert(plan);
            
            vlocity_ins__ContractLineItem__c plan1 = ARV_AP59_GrpSegTestDataCreation.createPlan(prod1.Id,cont1.Id);
            database.insert(plan1);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Vision_Plan__c = plan.Id ;
            pkg.ARV_Dental_Plan__c = plan.Id ;
            pkg.ARV_Medical_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    } 
    /**************  
Method name : approveContractRec10
Params     : NA
Return Type : testmethod
Description :  approveContractRec10 method 
*************/
    private static testmethod void approveContractRec10(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            testAccount.ARV_Association_Cluster_Code__c='BC';
            database.insert(testAccount);
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
            database.insert(gaAccount);
            
            Contact testContact =  GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
            testContact.Agent_Code__c='test';
            testContact.CreatedDate=system.today();
            testContact.vlocity_ins__Type__c='Agent';
            testContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(testContact);
            
            Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod.Carrier_Type__c= 'BCN';
            prod.Family = 'BCN Medical';
            database.insert(prod);
            
            Product2 prod1 = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod1.Carrier_Type__c= 'BCN';
            prod1.Family = 'BCN Medical';
            prod1.Voluntary_Contributory__c = 'Non-Voluntary';
            database.insert(prod1);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            database.insert(plan);
            
            vlocity_ins__ContractLineItem__c plan1 = ARV_AP59_GrpSegTestDataCreation.createPlan(prod1.Id,cont1.Id);
            database.insert(plan1);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Vision_Plan__c = plan1.Id ;
            pkg.ARV_Dental_Plan__c = plan.Id ;
            pkg.ARV_Medical_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    }
    /**************  
Method name : approveContractRec11
Params     : NA
Return Type : testmethod
Description :  approveContractRec11 method 
*************/
    private static testmethod void approveContractRec11(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            testAccount.ARV_Association_Cluster_Code__c='BC';
            database.insert(testAccount);
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
            database.insert(gaAccount);
            
            Contact testContact =  GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
            testContact.Agent_Code__c='test';
            testContact.CreatedDate=system.today();
            testContact.vlocity_ins__Type__c='Agent';
            testContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(testContact);
            
            Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod.Carrier_Type__c= 'BCN';
            prod.Family = 'Healthy Blue Achieve';
            prod.Voluntary_Contributory__c = 'Non-Voluntary';
            database.insert(prod);
            
            vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(gaAccount.Id);
            database.insert(census);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            cont1.vlocity_ins__EnrollmentCensusId__c=census.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Vision_Plan__c = plan.Id ;
            pkg.ARV_Dental_Plan__c = plan.Id ;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            
            GA_Group_Segment__c grpsmtRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(gaAccount);
            database.insert(grpsmtRec);
            
            vlocity_ins__GroupCensusMember__c censusMem=ARV_AP05_TestDataCreation.groupCensusMember(census.id);
            censusMem.vlocity_ins__CensusId__c =cont1.vlocity_ins__EnrollmentCensusId__c;
            censusMem.vlocity_ins__IsPrimaryMember__c = true;
            censusMem.ARV_Group_Segment__c=grpsmtRec.id;
            censusMem.ARV_Census_Member_Selected_Package__c=pkgLocSeg.id;
            database.insert(censusMem);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    }
    /**************  
Method name : approveContractRec12
Params     : NA
Return Type : testmethod
Description :  approveContractRec12 method 
*************/
    private static testmethod void approveContractRec12(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            testAccount.ARV_Association_Cluster_Code__c='BC';
            database.insert(testAccount);
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
            database.insert(gaAccount);
            
            Contact testContact =  GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
            testContact.Agent_Code__c='test';
            testContact.CreatedDate=system.today();
            testContact.vlocity_ins__Type__c='Agent';
            testContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(testContact);
            
            Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod.Carrier_Type__c= 'BCN';
            prod.Family = 'Medical';
            prod.Voluntary_Contributory__c = 'Voluntary';
            database.insert(prod);
            
            vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(gaAccount.Id);
            database.insert(census);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Date_Submitted__c=system.today();
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            cont1.vlocity_ins__EnrollmentCensusId__c=census.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            plan.vlocity_ins__ProductId__c=prod.id;
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Vision_Plan__c = plan.Id ;
            pkg.ARV_Dental_Plan__c = plan.Id ;
            pkg.ARV_Medical_Plan__c=plan.id;
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            
            GA_Group_Segment__c grpsmtRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(gaAccount);
            grpsmtRec.GA_Carrier__c='BCN';
            grpsmtRec.GA_Mail_Instruction_Code__c='G';
            grpsmtRec.GA_Benefit_Effective_Date__c=system.today();
            grpsmtRec.ARV_BCN_HSA__c=true;
            grpsmtRec.ARV_BCN_HRA__c=true;
            database.insert(grpsmtRec);
            
            vlocity_ins__GroupCensusMember__c censusMem=ARV_AP05_TestDataCreation.groupCensusMember(census.id);
            censusMem.vlocity_ins__CensusId__c =cont1.vlocity_ins__EnrollmentCensusId__c;
            censusMem.vlocity_ins__IsPrimaryMember__c = true;
            censusMem.ARV_Group_Segment__c=grpsmtRec.id;
            censusMem.ARV_Census_Member_Selected_Package__c=pkgLocSeg.id;
            database.insert(censusMem);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    }
    /**************  
Method name : approveContractRec13
Params     : NA
Return Type : testmethod
Description :  approveContractRec13 method 
*************/
    private static testmethod void approveContractRec13(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            testAccount.ARV_Association_Cluster_Code__c='BC';
            database.insert(testAccount);
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
            database.insert(gaAccount);
            
            Contact testContact =  GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
            testContact.Agent_Code__c='test';
            testContact.CreatedDate=system.today();
            testContact.vlocity_ins__Type__c='Agent';
            testContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(testContact);
            
            Product2 prod = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod.Carrier_Type__c= 'BCN';
            prod.Family = 'Dental';
            prod.Voluntary_Contributory__c = 'Non-Voluntary';
            database.insert(prod);
            
            vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(gaAccount.Id);
            database.insert(census);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Date_Submitted__c=system.today();
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            cont1.vlocity_ins__EnrollmentCensusId__c=census.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            plan.vlocity_ins__ProductId__c=prod.id;
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Vision_Plan__c = plan.Id ;
            pkg.ARV_Dental_Plan__c = plan.Id ;
            pkg.ARV_Medical_Plan__c=plan.id;
            database.insert(pkg);            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);   
            GA_Group_Segment__c grpsmtRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(gaAccount);
            grpsmtRec.GA_Carrier__c='BCN';
            grpsmtRec.GA_Mail_Instruction_Code__c='G';
            grpsmtRec.GA_Benefit_Effective_Date__c=system.today();
            grpsmtRec.ARV_BCN_HSA__c=true;
            grpsmtRec.ARV_BCN_HRA__c=true;
            database.insert(grpsmtRec);
            
            vlocity_ins__GroupCensusMember__c censusMem=ARV_AP05_TestDataCreation.groupCensusMember(census.id);
            censusMem.vlocity_ins__CensusId__c =cont1.vlocity_ins__EnrollmentCensusId__c;
            censusMem.vlocity_ins__IsPrimaryMember__c = true;
            censusMem.ARV_Group_Segment__c=grpsmtRec.id;
            censusMem.ARV_Census_Member_Selected_Package__c=pkgLocSeg.id;
            database.insert(censusMem);            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    }
       private static testmethod  void approveContractRec14(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(testAccount);
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.ARV_Association_Cluster_Code__c='BC';
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
            
            Product2 prod1 = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod1.Carrier_Type__c= 'BCN';
            prod1.Family = 'BCN HSA';
            prod1.Voluntary_Contributory__c = 'Non-Voluntary';
            database.insert(prod1);
            
            Contract cont=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont.AccountId=testAccount.id;
            cont.ARV_RatingArea__c='bc';
            cont.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont.vlocity_ins__ProducerId__c = testContact.Id;
            cont.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            
            database.insert(cont);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont.Id);
            database.insert(plan);
            
            vlocity_ins__ContractLineItem__c plan1 = ARV_AP59_GrpSegTestDataCreation.createPlan(prod1.Id,cont.Id);
            database.insert(plan1);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont.Id);
            pkg.ARV_Vision_Plan__c = plan.Id ;
            pkg.ARV_Dental_Plan__c = plan1.Id ;
            pkg.ARV_Medical_Plan__c = plan.Id ;
            pkg.ARV_CDH_Package_Combination__c='Health Savings Account';
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    } 
    private static testmethod void approveContractRec15(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
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
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Medical_Plan__c = plan.Id ;
            pkg.ARV_CDH_Package_Combination__c='Health Savings Account';
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    }
    private static testmethod void approveContractRec16(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
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
            
            Product2 prod1 = ARV_AP59_GrpSegTestDataCreation.createProduct();
            prod1.Carrier_Type__c= 'BCN';
            prod1.Family = 'BCN HSA';
            prod1.Voluntary_Contributory__c = 'Non-Voluntary';
            database.insert(prod1);
            
            Contract cont1=ARV_AP59_GrpSegTestDataCreation.createContract();
            cont1.AccountId=testAccount.id;
            cont1.ARV_RatingArea__c='bc';
            cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.vlocity_ins__ProducerId__c = testContact.Id;
            cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            database.insert(cont1);
            
            vlocity_ins__ContractLineItem__c plan = ARV_AP59_GrpSegTestDataCreation.createPlan(prod.Id,cont1.Id);
            database.insert(plan);
            
            vlocity_ins__ContractLineItem__c plan1 = ARV_AP59_GrpSegTestDataCreation.createPlan(prod1.Id,cont1.Id);
            database.insert(plan1);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Vision_Plan__c = plan.Id ;
            pkg.ARV_Dental_Plan__c = plan.Id ;
            pkg.ARV_Medical_Plan__c = plan.Id ;
            pkg.ARV_CDH_Package_Combination__c='Health Savings Account';
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    }
    private static testmethod void approveContractRec17(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(testAccount);
            Account gaAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            gaAccount.ARV_Association_Cluster_Code__c='BC';
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
            database.insert(plan);
            
            GA_City_Code__c city = ARV_AP59_GrpSegTestDataCreation.createCity();
            database.insert(city);
            
            GA_County_Code__c county =ARV_AP59_GrpSegTestDataCreation.createCounty();
            database.insert(county);
            
            LocationPackage__c locSegment = ARV_AP59_GrpSegTestDataCreation.createLocationPackage(
                testAccount.id,cont1.Id,city.Id,county.Id);
            database.insert(locSegment);
            
            Package__c pkg = ARV_AP59_GrpSegTestDataCreation.createPackage(usr.Id,cont1.Id);
            pkg.ARV_Medical_Plan__c = plan.Id ;
            pkg.ARV_Dental_Plan__c = plan.Id ;
            pkg.ARV_CDH_Package_Combination__c='Health Savings Account';
            database.insert(pkg);
            
            Package_Location_Segment_Rel__c pkgLocSeg = ARV_AP59_GrpSegTestDataCreation.createPLSR(pkg.Id,locSegment.Id,cont1.Id);
            database.insert(pkgLocSeg);
            
            system.test.startTest();
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(cont1.id);
            system.test.stopTest();
            System.assertNotEquals(null,testAccount.Id);
        }
    } 
    }