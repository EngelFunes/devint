@isTest(seealldata=false)
public class ARV_AP_createGSAssociationRecords_Test {
    
        
    public static testmethod void invokeMethodtest1(){
        Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
        GA_Group_Seg_AssociationTriggerHndlr.BypassTrigger = true;
        
        Map<String, Object> input=new Map < String, Object >();
        Map<String, Object> MaintenanceChange=new Map < String, Object >();
        Map<String, Object> Accountinfo=new Map < String, Object >();
        Map<String, Object> typeahead=new Map < String, Object >();
        
        Date startDate = Date.newInstance(2020, 09, 07);
        Date endDate = Date.newInstance(2020, 11, 07);
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User usr = new User(LastName = 'LIVESTON',
                           FirstName='ss',
                           Alias = 'ss',
                           Email = 'ss@ss224.com',
                           Username = 'ss@ss123.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        
        insert usr;
        
        system.runAs(usr){
         	Account acc=new Account();
            acc.Name='Test Acc';
            acc.Phone='1234567089';
            acc.Account_Status__c='Active';
            acc.Type='Customer';
            acc.NumberOfEmployees=123;
            acc.GA_Total_Eligible__c= 500;
            acc.CID__c='123456';  
            acc.GA_ContractExpirationDate__c=system.today();
            acc.Industry='Agriculture';
            acc.GA_Other__c='Test Other';
            acc.SicDesc='Test';
            acc.Status__c='Active';
            acc.Website='www.xyz.com';
            acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            acc.Description='Test';
            acc.BillingStreet = 'teststreet';
            acc.BillingCity = 'testcity';
            acc.BillingState = 'Michigan';
            acc.BillingPostalCode = '12121';  
            acc.ShippingCountry='United States';
            acc.ShippingStreet = 'shipstreet';
            acc.ShippingCity = 'FLINT';
            acc.ShippingState = 'Michigan';
            acc.ShippingStateCode='MI';
            acc.ShippingPostalCode ='48375';
            acc.GA_Platinum__c = false;
            acc.Federal_Tax_ID__c = '123456789';
            acc.GA_Union_Type__c = 'Local';
            acc.Union_Population__c = 'Yes';
            acc.Union_Code__c = '123';
            acc.Union_Category__c = 'Automobile';
            acc.Union_Acronym__c = 'abc';
            database.insert(acc);
            
            Account acc2= ARV_AP05_TestDataCreation.AccRec1(recordTypeIdAccount);
            acc2.GA_Acronym__c = 'test2acc'; 
            database.insert(acc2);
            
            Account acc3= ARV_AP05_TestDataCreation.AccRec1(recordTypeIdAccount);
            acc3.GA_Acronym__c = 'testAcc';
            database.insert(acc3);
            system.debug('third account '+acc3.id);
            
            Contract cont1 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            database.insert(cont1);
                  
            GA_Group_Segment__c gs1=ARV_AP05_TestDataCreation.groupSegmentRec2(acc.Id, cont1.Id);
            gs1.GA_Account__c = acc.Id;
            gs1.GA_Association_Id__c = acc3.Id;
            database.insert(gs1);        
            system.debug('gs status '+gs1.Status__c);
            
            GA_Group_Association__c ga1 = new GA_Group_Association__c();
            ga1.GA_Account__c = acc3.Id;
            ga1.GA_Group_Segment__c = gs1.Id;
            ga1.GA_Start_Date__c = startDate;
            ga1.GA_End_Date__c = endDate;
            database.insert(ga1);        
            
            String accId = acc2.GA_Acronym__c;
            typeahead.put('TypeAhead_SponsoredPlanAcronym', accId);
            Accountinfo.put('TypeAhead_SponsoredPlanAcronym-Block',typeahead);
            Accountinfo.put('SponsorPlanAcronymEffectiveDate','2021-10-20');
            MaintenanceChange.put('AccountInfo',AccountInfo);
            input.put('MaintenanceChange',MaintenanceChange); 
            input.put('ContextId',acc.id);
            
            //List<GA_Group_Association__c> gasList = new List<GA_Group_Association__c>([select id, GA_End_Date__c, GA_Account__c, GA_Group_Segment__c from GA_Group_Association__c]);
            //system.debug('gas++'+gasList);
            
            Map < String, Object > output=new Map < String, Object >();
            Map < String, Object > options=new Map < String, Object >();
            options.put('censusId','test');
            String methodName='createGSARecords';
            String accountStrngId= String.valueOf(input.get('ContextId'));
            List<GA_Group_Association__c> oldGAs= new List<GA_Group_Association__c>();
            oldGAs = [select id, GA_End_Date__c from GA_Group_Association__c where GA_Group_Segment__r.Status__c = 'Active' AND GA_Group_Segment__r.GA_Account__c =:accountStrngId];
            Test.startTest();
            ARV_AP_createGSAssociationRecords arv_createGSA=new  ARV_AP_createGSAssociationRecords();
            arv_createGSA.invokeMethod(methodName,input,output,options);   
            Test.stopTest();
        }
    }
}