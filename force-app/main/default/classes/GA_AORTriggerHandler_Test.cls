/**
@Author : IDC offshore
@Name: GA_AORTriggerHandler_Test
@CreatedDate: 19 - June 2018 
@Description: GA_AORTriggerHandler_Test Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AORTriggerHandler_Test {
    /*******************************************************************************************************************************
@Description        :   updateAoRRecs() method 
@Name               :   updateAoRRecs
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void updateAoRRecs(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 
        
        Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        database.insert(cnt); 
        
        GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2200, 1, 1);
        agentacctRelation.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Commission_End_Date__c = Date.newInstance(2200, 1, 1);
        database.insert(agentacctRelation); 
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        database.insert(aorGSRec); 
        
        system.runAs(usr){
            
            Test.startTest();            
            agentacctRelation.GA_Service_End_Date__c = System.today() -  1;
            agentacctRelation.GA_Commission_End_Date__c = System.today()-10;
            agentacctRelation.GA_Is_Mass_Updating__c = true;
            Database.update(agentacctRelation);
            
            Test.stopTest();
            
            List<GA_AOR_Group_Segment__c> aoGsLst = [Select id from GA_AOR_Group_Segment__c where GA_AOR_Id__c=:agentacctRelation.id Limit 10];
            system.assert(aoGsLst <> null);
        }
    }
    
    private static testMethod void insertAoRRecsExcp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        system.runAs(usr){
           // map<id,GA_Aor__C>  aorOldMap = null;
            list<GA_Aor__C> aorLst = null;
            Test.startTest();            
            GA_AORTriggerHandler.beforeInsert(aorLst);
            Test.stopTest();
        }
    }    
    /*******************************************************************************************************************************
@Description        :   cloneAORrec() method 
@Name               :   cloneAORrec
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void cloneAORrec(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        
        GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_AOR_Custom_Clone__c = true;
                tcs.SetupOwnerId=usr.ProfileId;
                database.insert(tcs);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);

        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 

        Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        database.insert(cnt); 
        
        List<GA_Aor__C> aorNewLst = New  List<GA_Aor__C>();
        GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2018, 1, 1);
        agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2019, 2, 1);
        agentacctRelation.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Commission_End_Date__c= Date.newInstance(2200, 1, 1);
        aorNewLst.add(agentacctRelation);
        
         GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        //agentacctRelation1.GA_Service_Start_Date__c =  Date.newInstance(2018, 3, 1);
        //agentacctRelation1.GA_Service_End_Date__c = Date.newInstance(2018, 4, 1);
         //agentacctRelation1.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
          //agentacctRelation1.GA_Commission_End_Date__c= Date.newInstance(2000, 1, 1);
        aorNewLst.add(agentacctRelation1);
        
        database.insert(aorNewLst); 
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        database.insert(aorGSRec); 
      
        
        List<GA_Aor__C> aorLst =  New List<GA_Aor__C>();
        List<GA_Aor__C> newaorLst =  New List<GA_Aor__C>();
        map<Id,GA_AOR__c> aorOldMap =  New map<Id,GA_AOR__c>();
        system.runAs(usr){
            
            Test.startTest();
            GA_CloneAORCls.cloneAnySobjet(agentacctRelation.id);
            //GA_CloneAORCls.cloneAnySobjet('qeuifhweuit');
            GA_CloneAORCls.fetchAORClone();
            aorLst = [Select Id,Name,GA_Prevs_RecordID__c,GA_Service_Start_Date__c,
                      GA_Service_End_Date__c,GA_Agent_Contact_Name__c,GA_Agent_Code__c,
                      GA_Is_Mass_Updating__c from GA_Aor__C Limit 10 ];
            for(  GA_Aor__C aorRec:  aorLst)
            {
                if(aorRec.id <> agentacctRelation.id){
                    newaorLst.add(aorRec); 
                }
               
            }
            GA_updateAORGSSvcCls.updateAORGSInfo(newaorLst,null); 
            //
            Test.stopTest();
            
            List<GA_AOR_Group_Segment__c> aoGsLst = [Select id from GA_AOR_Group_Segment__c where GA_AOR_Id__c=:agentacctRelation.id Limit 10];
            system.assert(aoGsLst <> null);
        }
    }
    
        /*******************************************************************************************************************************
@Description        :   cloneAORrec() method 
@Name               :   cloneAORrec
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void cloneAORrecDateCheck(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        
        GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_AOR_Custom_Clone__c = true;
                tcs.SetupOwnerId=usr.ProfileId;
                database.insert(tcs);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);

        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 

        Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        database.insert(cnt); 
        
        List<GA_Aor__C> aorNewLst = New  List<GA_Aor__C>();
        GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2018, 1, 1);
        agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2019, 2, 1);
        agentacctRelation.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Commission_End_Date__c= Date.newInstance(2200, 1, 1);
        database.insert(agentacctRelation); 
        
         GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
         agentacctRelation1.GA_Service_Start_Date__c =  Date.newInstance(2018, 1, 1);
         agentacctRelation1.GA_Service_End_Date__c = Date.newInstance(2018, 4, 1);
         agentacctRelation1.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
         agentacctRelation1.GA_Commission_End_Date__c= Date.newInstance(2000, 1, 1);
       	 database.insert(agentacctRelation1); 
      
        
        GA_AOR_Group_Segment__c aorGSRec1 = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation1,gsmt);
        database.insert(aorGSRec1);

        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        database.insert(aorGSRec); 
        
        List<GA_Aor__C> aorLst =  New List<GA_Aor__C>();
        List<GA_Aor__C> newaorLst =  New List<GA_Aor__C>();
        map<Id,GA_AOR__c> aorOldMap =  New map<Id,GA_AOR__c>();
        system.runAs(usr){
            
            Test.startTest();
            
 		GA_Aor__C agentacctRelation2 = new GA_Aor__C();
        agentacctRelation2.id= agentacctRelation1.Id;
        agentacctRelation2.GA_Service_Start_Date__c = Date.newInstance(2019, 3, 1);
        agentacctRelation2.GA_Service_End_Date__c = Date.newInstance(2019, 5, 1);
        database.update(agentacctRelation2);
            Test.stopTest();
            
            
        }
    }
    
     private static testMethod void cloneAORrec1(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        
        GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_AOR_Custom_Clone__c = true;
                tcs.SetupOwnerId=usr.ProfileId;
                database.insert(tcs);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        
              
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 
        
          
        
        Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        database.insert(cnt); 
        
        List<GA_Aor__C> aorNewLst = New  List<GA_Aor__C>();
        GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2018, 1, 1);
        agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2019, 2, 1);
        agentacctRelation.GA_Commission_Start_Date__c =  Date.newInstance(2018, 1, 1);
        agentacctRelation.GA_Commission_End_Date__c= Date.newInstance(2018, 1, 1);
        aorNewLst.add(agentacctRelation);
        

        
        database.insert(aorNewLst); 
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        database.insert(aorGSRec); 
      
        List<GA_Aor__C> aorLst =  New List<GA_Aor__C>();
        List<GA_Aor__C> newaorLst =  New List<GA_Aor__C>();
        map<Id,GA_AOR__c> aorOldMap =  New map<Id,GA_AOR__c>();
        system.runAs(usr){
            
            Test.startTest();
            GA_CloneAORCls.cloneAnySobjet(agentacctRelation.id);          
            GA_CloneAORCls.fetchAORClone();
            aorLst = [Select Id,Name,GA_Prevs_RecordID__c,GA_Service_Start_Date__c,
                      GA_Service_End_Date__c,GA_Agent_Contact_Name__c,GA_Agent_Code__c,
                      GA_Is_Mass_Updating__c from GA_Aor__C Limit 10 ];
            for(  GA_Aor__C aorRec:  aorLst)
            {
                if(aorRec.id <> agentacctRelation.id){
                    newaorLst.add(aorRec); 
                }
               
            }
            GA_updateAORGSSvcCls.updateAORGSInfo(newaorLst,null); 
            //
            Test.stopTest();
            
            List<GA_AOR_Group_Segment__c> aoGsLst = [Select id from GA_AOR_Group_Segment__c where GA_AOR_Id__c=:agentacctRelation.id Limit 10];
            system.assert(aoGsLst <> null);
        }
    }
    /*******************************************************************************************************************************
@Description        :   updateAoRRecs() method 
@Name               :   updateAoRRecs
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void updateAoRRecsExcp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        system.runAs(usr){
            map<id,GA_Aor__C>  aorOldMap = null;
            list<GA_Aor__C> aorLst = null;
            Test.startTest();            
            GA_AORTriggerHandler.beforeUpdate(aorLst,aorOldMap);
            Test.stopTest();
        }
    }    
    
     private static testMethod void checkIfSameGSRecordExists(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        system.runAs(usr){
            Set<Id> newGrpSegmentIdOld = new Set<Id>();
             Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);

        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 
            GA_Group_Segment__c gsmt1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt1); 
                        GA_Group_Segment__c gsmt2 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt2); 
            newGrpSegmentIdOld.add(gsmt.id);
            newGrpSegmentIdOld.add(gsmt1.id);
            Set<Id> grpSegmentIdOld = new Set<Id>();
             grpSegmentIdOld.add(gsmt2.id);
            grpSegmentIdOld.add(gsmt1.id);
            Test.startTest();            
            GA_AORSrvcDateRangeChk.checkIfSameGSRecordExists(newGrpSegmentIdOld, grpSegmentIdOld);
            Test.stopTest();
        }
    }
}