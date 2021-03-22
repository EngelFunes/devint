/**
@Author : IDC Offshore
@Name: GA_ExternalAppealRecdCrtnUpdt_Test 
@CreatedDate: 21 Aug 2019
@Description: GA_ExternalAppealRecdCrtnUpdt_Test Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
public class GA_ExternalAppealRecdCrtnUpdt_Test {
    
    private static testmethod void updtNHREndDtOnExtnlAplNASCO()
    {   
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','Integration User');
     database.insert(usr);
     system.runAs(usr){
         
         Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
         acc1.GA_ERISA_Exempt__c=True;
         database.insert(acc1);           
         
         GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
         gsmt.Name = '00003_002';
         gsmt.GA_Account__c = acc1.id;
         
         gsmt.GA_Carrier__c='BCBSM';
         gsmt.Network__c='NASCO';
         gsmt.Status__c='Active';
         gsmt.GA_MTV_Group_Division__c='1225';
         gsmt.GA_Account_Type__c='Local';
         gsmt.GA_Risk_Cell__c='123';
         gsmt.GA_Current_Cluster_Code__c = '0000';
         database.insert(gsmt); 
         
         gsmt.Status__c='Canceled';
         database.update(gsmt);

         GA_Group_Segment__c gsmtNew = new GA_Group_Segment__c();
         gsmtNew.GA_Risk_Cell__c='223';
         gsmtNew.Status__c='Active';
         gsmtNew.Id=gsmt.Id;
         database.update(gsmtNew);
         
         list<GA_Group_Segment__c> gsList =  new list<GA_Group_Segment__c>();
         gsList.add(gsmtNew); 
         
         map<id,GA_Group_Segment__c> gsoldMap = new map<id,GA_Group_Segment__c>();
         gsoldMap.put(gsmtNew.id,gsmt);
         
         
         GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
         newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
         newExternalAppeal.GA_Group_Segment_Id__c = gsmt.Id; 
         newExternalAppeal.GA_NHR_Eff_Date__c =  system.today()-1;
         newExternalAppeal.GA_External_Appeal_Type__c = 'DIFS';
         newExternalAppeal.GA_NHR_Status__c='Grandfather - No';
         newExternalAppeal.GA_Package_Number__c = '030';
         newExternalAppeal.GA_Section_Number__c = '8456';
         database.insert(newExternalAppeal);
         
         GA_ExternalAppealRecdCrtnUpdt.updtNHREndDtOnExtnlApl(gsList,gsoldMap);                  
     }
   }
    
    private static testmethod void updtNHREndDtOnExtnlAplReinstation()
    {   
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','Integration User');
     database.insert(usr);
     system.runAs(usr){
         
         Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
         acc1.GA_ERISA_Exempt__c=True;
         database.insert(acc1);           
         
         GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
         gsmt.Name = '00003_002';
         gsmt.GA_Account__c = acc1.id;
         
         gsmt.GA_Carrier__c='BCBSM';
         gsmt.Network__c='NASCO';
         gsmt.Status__c='Active';
         gsmt.GA_MTV_Group_Division__c='1225';
         gsmt.GA_Account_Type__c='Local';
         gsmt.GA_Risk_Cell__c='123';
          gsmt.GA_Current_Cluster_Code__c = '0000';
         database.insert(gsmt); 
         
         gsmt.Status__c='Active';
         database.update(gsmt);

         GA_Group_Segment__c gsmtNew = new GA_Group_Segment__c();
         gsmtNew.GA_Cancellation_Date__c=system.today()-1;
         gsmtNew.Status__c='Canceled';
         gsmtNew.Id=gsmt.Id;
         gsmtNew.Network__c='NASCO';
         database.update(gsmtNew);
         
         list<GA_Group_Segment__c> gsList =  new list<GA_Group_Segment__c>();
         gsList.add(gsmtNew); 
                      
         GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
         newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
         newExternalAppeal.GA_Group_Segment_Id__c = gsmt.Id; 
         newExternalAppeal.GA_NHR_Eff_Date__c =  system.today()-1;
         newExternalAppeal.GA_External_Appeal_Type__c = 'DIFS';
         newExternalAppeal.GA_NHR_Status__c='Grandfather - No';
         newExternalAppeal.GA_Package_Number__c = '030';
         newExternalAppeal.GA_Section_Number__c = '8456';
         database.insert(newExternalAppeal);       
         GA_ExternalAppealRecdCrtnUpdt.updtNHREndDtOnExtnlApl(gsList,null);                  
     }
   }

    private static testmethod void testReactivation()
    {   
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','Integration User');
     database.insert(usr);
     system.runAs(usr){
         
         Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
         acc1.GA_ERISA_Exempt__c=True;
         database.insert(acc1);           
         
         GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
         gsmt.Name = '00003_002';
         gsmt.GA_Account__c = acc1.id;
         
         gsmt.GA_Carrier__c='BCBSM';
         gsmt.Status__c='Active';
         gsmt.GA_MTV_Group_Division__c='1225';
         gsmt.GA_Account_Type__c='Local';
         gsmt.GA_Risk_Cell__c='123';
         database.insert(gsmt); 
         
         gsmt.Status__c='Canceled';
         database.update(gsmt);

         GA_Group_Segment__c gsmtNew = new GA_Group_Segment__c();
         gsmtNew.GA_Risk_Cell__c='223';
         gsmtNew.Status__c='Active';
         gsmtNew.Network__c='MOS';
         gsmtNew.Id=gsmt.Id;
         database.update(gsmtNew);
         
         list<GA_Group_Segment__c> gsList =  new list<GA_Group_Segment__c>();
         gsList.add(gsmtNew); 
         
         map<id,GA_Group_Segment__c> gsoldMap = new map<id,GA_Group_Segment__c>();
         gsoldMap.put(gsmtNew.id,gsmt);
         
         
         GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
         newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
         newExternalAppeal.GA_Group_Segment_Id__c = gsmt.Id; 
         newExternalAppeal.GA_NHR_Eff_Date__c =  system.today()-1;
         newExternalAppeal.GA_External_Appeal_Type__c = 'DIFS';
         newExternalAppeal.GA_NHR_Status__c='Grandfather - No';
         newExternalAppeal.GA_Package_Number__c = '030';
         newExternalAppeal.GA_Section_Number__c = '8456';
         database.insert(newExternalAppeal);
         
         GA_ExternalAppealRecdCrtnUpdt.updtNHREndDtOnExtnlApl(gsList,gsoldMap);                  
     }
   }
    
      private static testmethod void testReactivatePreviousNasco()
    {   
       user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        Database.insert(usr);
        
        system.runAs(usr)
        {
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
         gsmt.GA_Carrier__c='BCBSM';
         gsmt.Network__c='MOS';
         gsmt.Status__c='Active';       
         database.insert(gsmt); 
         
         gsmt.Status__c='Active';
         database.update(gsmt);
            
             GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
         newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
         newExternalAppeal.GA_Group_Segment_Id__c = gsmt.Id; 
         newExternalAppeal.GA_NHR_Eff_Date__c =  system.today()-1;
         newExternalAppeal.GA_External_Appeal_Type__c = 'DIFS';
         newExternalAppeal.GA_NHR_Status__c='Grandfather - No';
         newExternalAppeal.GA_Package_Number__c = '030';
         newExternalAppeal.GA_Section_Number__c = '8456';
         database.insert(newExternalAppeal);
            
            GA_Plan_Package__c plnPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(gsmt);
            plnPkg.GA_Group_Segment__c=gsmt.Id;
            plnPkg.GA_ACTIVE_IND__c='ad';
            test.startTest();
            database.insert(plnPkg);           
                
            
            GA_Plan_Package__c plnNew = new GA_Plan_Package__c();
            plnNew.Id=plnPkg.Id;
            plnNew.GA_ACTIVE_IND__c='Active';
            plnNew.GA_Coverage_Begin_Date__c=system.today();
            database.update(plnNew);
            
           map<id,GA_Plan_Package__c> gsoldMap = new map<id,GA_Plan_Package__c>();
           gsoldMap.put(plnPkg.Id,plnPkg);

            List<GA_Plan_Package__c> plnList = new List<GA_Plan_Package__c>();
            plnList.add(plnNew);
                
            GA_ExternalAppealRecdCrtnUpdt.reactivatePreviousEARecordNASCO(plnList,gsoldMap);
            test.stopTest();
            //task tskQRec=[select id,GA_Call_Category__c from task where id=:tskRec.id limit 1];
            system.assert(plnPkg <> null,true);
            
     }
   }
}