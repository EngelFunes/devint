@isTest
public class RemoveDuplicateExtAppTest {
    
    private static testmethod void RemoveDuplicateExtAppTest()
    {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','Integration User');
        database.insert(usr);
        system.runAs(usr){
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);           
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            
            gsmt.GA_Carrier__c='BCBSM';
            gsmt.Network__c='MOS';
            gsmt.Status__c='Active';
            gsmt.GA_MTV_Group_Division__c='1225';
            gsmt.GA_Account_Type__c='Local';
            gsmt.GA_Benefit_Effective_Date__c=system.today();
            database.insert(gsmt);          
            
            gsmt.Status__c='Active';
            database.update(gsmt);
            
            GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
            newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
            newExternalAppeal.GA_Group_Segment_Id__c = gsmt.Id; 
            newExternalAppeal.GA_NHR_Eff_Date__c =  system.today()-1;
            newExternalAppeal.GA_External_Appeal_Type__c = 'IRO';
            newExternalAppeal.GA_NHR_Status__c = 'Grandfather - Yes';
            newExternalAppeal.Max_Date_Unique_Value__c = true;
            
            newExternalAppeal.GA_Package_Number__c = '030';
            newExternalAppeal.GA_Section_Number__c = '8456';
            database.insert(newExternalAppeal);
            
            
            GA_Plan_Package__c plnPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(gsmt);
            plnPkg.GA_Coverage_Begin_Date__c=system.today();
            //plnPkg.GA_Group_Segment__c=gsmt.Id;
            database.insert(plnPkg);  
            
            Asset assRec =  GA_OBJ_TD01_TestDataCreation.soldPrdtRec(plnPkg,acc1);
            database.insert(assRec);
        }
        Test.startTest();
        
        RemoveDuplicateExtApp_Batch obj = new RemoveDuplicateExtApp_Batch();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}