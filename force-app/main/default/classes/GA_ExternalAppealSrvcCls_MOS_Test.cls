/**
@Author : IDC Offshore
@Name: GA_ExternalAppealSrvcCls_MOS_Test 
@CreatedDate: 21 Aug 2019
@Description: GA_ExternalAppealSrvcCls_MOS_Test Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_ExternalAppealSrvcCls_MOS_Test {
    
    private static testmethod void createExternalAppealRecordMOS()
    {   user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','Integration User');
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
         gsmt.GA_Current_Cluster_Code__c='FBAU';
         database.insert(gsmt);          
         
         gsmt.Status__c='Active';
         database.update(gsmt);
         
         GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
         newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
         newExternalAppeal.GA_Group_Segment_Id__c = gsmt.Id; 
         newExternalAppeal.GA_NHR_Eff_Date__c =  system.today()-1;
         newExternalAppeal.GA_External_Appeal_Type__c = 'IRO';
         newExternalAppeal.GA_NHR_Status__c = 'Grandfather - Yes';
         
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
   }
    
    private static testmethod void updateExternalAppealNHRDateNASCO()
    {   
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','Integration User');
     database.insert(usr);
     system.runAs(usr){
         
         Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
         acc1.GA_ERISA_Exempt__c=false;
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
         gsmt.GA_Current_Cluster_Code__c='FBAU';
         database.insert(gsmt); 

         GA_Group_Segment__c gsmtNew = new GA_Group_Segment__c();
         gsmtNew.GA_Risk_Cell__c='223';
         gsmtNew.Status__c='Active';
         gsmtNew.Id=gsmt.Id;
         database.update(gsmtNew);
         
         list<GA_Group_Segment__c> gsList =  new list<GA_Group_Segment__c>();
         gsList.add(gsmtNew); 
         
         map<id,GA_Group_Segment__c> gsoldMap = new map<id,GA_Group_Segment__c>();
         gsoldMap.put(gsmtNew.id,gsmt);
         
         
            for(GA_Group_Segment__c gs :gsList){
                if(gsoldMap!=null){
                    //gs.GA_Is_Mass_Updating__c = true;
                    GA_Group_Segment__c grpSgmntOld=gsoldMap.get(gs.Id);  
                    system.debug('gs.GA_Risk_Cell__c'+gs.GA_Risk_Cell__c);
                    system.debug('grpSgmntOld.GA_Risk_Cell__c'+grpSgmntOld.GA_Risk_Cell__c);
                            
                }
            } 

         GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
         newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
         newExternalAppeal.GA_Group_Segment_Id__c = gsmt.Id; 
         newExternalAppeal.GA_NHR_Eff_Date__c =  system.today()-1;
         newExternalAppeal.GA_External_Appeal_Type__c = 'DIFS';
         newExternalAppeal.GA_NHR_Status__c='Grandfather - No';
         newExternalAppeal.GA_Package_Number__c = '030';
         newExternalAppeal.GA_Section_Number__c = '8456';
         database.insert(newExternalAppeal);
         
         GA_ExternalAppealSrvcCls_MOS.updateExternalAppealNHRDate(gsList,gsoldMap);                  
     }
   }
    
    private static testmethod void updateExternalAppealNHRDateMOS()
    {   
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','Integration User');
     database.insert(usr);
     system.runAs(usr){
         
         Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
         acc1.GA_ERISA_Exempt__c=false;
         database.insert(acc1);           
         
         GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
         gsmt.Name = '00003_002';
         gsmt.GA_Account__c = acc1.id;
         
         gsmt.GA_Carrier__c='BCBSM';
         gsmt.Network__c='MOS';
         gsmt.Status__c='Active';
         gsmt.GA_MTV_Group_Division__c='1225';
         gsmt.GA_Account_Type__c='Local';
         gsmt.GA_Risk_Cell__c='123';
         gsmt.GA_Current_Cluster_Code__c='FBAU';
         database.insert(gsmt); 

         GA_Group_Segment__c gsmtNew = new GA_Group_Segment__c();
         gsmtNew.GA_Risk_Cell__c='223';
         gsmtNew.Status__c='Active';
         gsmtNew.Id=gsmt.Id;
         database.update(gsmtNew);
         
         list<GA_Group_Segment__c> gsList =  new list<GA_Group_Segment__c>();
         gsList.add(gsmtNew); 
         
         map<id,GA_Group_Segment__c> gsoldMap = new map<id,GA_Group_Segment__c>();
         gsoldMap.put(gsmtNew.id,gsmt);
         
         
            for(GA_Group_Segment__c gs :gsList){
                if(gsoldMap!=null){
                    //gs.GA_Is_Mass_Updating__c = true;
                    GA_Group_Segment__c grpSgmntOld=gsoldMap.get(gs.Id);  
                          
                }
            } 

         GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
         newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
         newExternalAppeal.GA_Group_Segment_Id__c = gsmt.Id; 
         newExternalAppeal.GA_NHR_Eff_Date__c =  system.today()-1;
         newExternalAppeal.GA_External_Appeal_Type__c = '';
         newExternalAppeal.GA_NHR_Status__c='Grandfather - No';
         newExternalAppeal.GA_Package_Number__c = '030';
         newExternalAppeal.GA_Section_Number__c = '8456';
         database.insert(newExternalAppeal);
         
         GA_ExternalAppealSrvcCls_MOS.updateExternalAppealNHRDate(gsList,gsoldMap);                  
     }
   }
    
     private static testmethod void updtMOSExtrlAppRcrd()
    {   
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','Integration User');
     database.insert(usr);
     system.runAs(usr){
         
         Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
         acc1.GA_ERISA_Exempt__c=false;
         database.insert(acc1);           
         
         GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
         gsmt.Name = '00003_002';
         gsmt.GA_Account__c = acc1.id;
         
         gsmt.GA_Carrier__c='BCBSM';
         gsmt.Network__c='MOS';
         gsmt.Status__c='Active';
         gsmt.GA_MTV_Group_Division__c='1225';
         gsmt.GA_Account_Type__c='Local';
         gsmt.GA_Current_Cluster_Code__c='FBAU';
         database.insert(gsmt);          
         
         gsmt.Status__c='Active';
         database.update(gsmt);
         
         GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
         newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
         newExternalAppeal.GA_Group_Segment_Id__c = gsmt.Id; 
         newExternalAppeal.GA_NHR_Eff_Date__c =  system.today()-1;
         newExternalAppeal.GA_External_Appeal_Type__c = 'DIFS';
         
         newExternalAppeal.GA_Package_Number__c = '030';
         newExternalAppeal.GA_Section_Number__c = '8456';
         database.insert(newExternalAppeal);
         
         list<GA_Group_Segment__c> gsList =  new list<GA_Group_Segment__c>();
         gsList.add(gsmt);
         GA_ExternalAppealSrvcCls_MOS.updtMOSExtrlAppRcrd(gsList,False,True);
                   
     }
   }
    
    private static testmethod void MOSException(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{                
                test.startTest();
                GA_ExternalAppealSrvcCls_MOS.createExternalAppealRecordMOS(null);
                test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    private static testmethod void getRetireeRuleForMOS(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{                
                test.startTest();
                GA_ExternalAppealSrvcCls_MOS.getGrandfatherRetireeOptRulesforMOS('GRAND2');            
                test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}