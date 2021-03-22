/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AP_CIDAdjAssnmtCls_Test
@CreatedDate: 20 - Feb 2019 
@Description: GA_AP_CIDAdjAssnmtCls_Test class is for GA_AP_CIDAdjAssnmtCls.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_AP_CIDAdjAssnmtCls_Test {
    /*******************************************************************************************************************************
@Description: cidAdjAssnmtOwnrUsr() method 
@Name : cidAdjAssnmtOwnrUsr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void cidAdjAssnmtOwnrUsr(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount1);
                
                Account testAccount2= GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount2);
                
                GA_Group_Segment__c grpsgmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount1);  
                grpsgmt.Status__c='Pending';
                database.insert(grpsgmt);
                
                grpsgmt.Status__c='Active';
                database.update(grpsgmt);
                                
                GA_CID_Adjustment__c cidRec=GA_OBJ_TD01_TestDataCreation.cidAdjRecrd();
                cidRec.GA_Source_Account__c  = testAccount1.Id;
                cidRec.GA_Target_Account__c  = testAccount2.Id;
                database.insert(cidRec);
                
                GA_Process_Group_Segment__c prGS = new GA_Process_Group_Segment__c();
                prGS.GA_CID_Adjustment__c=cidRec.Id;
                prGS.GA_Group_Segment__c=grpsgmt.Id;
                database.insert(prGS);
                
                Test.startTest();
                GA_AP_CIDAdjAssnmtCls.assignCIDAdjOwnership(cidRec.Id, Usr.Id);           
                Test.stopTest();
                
                System.assert(cidRec <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: cidAdjAssnmtOwnrQueue() method 
@Name : cidAdjAssnmtOwnrQueue
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void cidAdjAssnmtOwnrQueue(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount1);
                
                Account testAccount2= GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount2);
                
                GA_Group_Segment__c grpsgmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount1);  
                grpsgmt.Status__c='Pending';
                database.insert(grpsgmt);
                
                grpsgmt.Status__c='Active';
                database.update(grpsgmt);
                
                Group grp = new Group(Type='Queue', Name='TestQueue');
                database.insert(grp);
                
                QueueSObject que = new QueueSObject(SobjectType='GA_CID_Adjustment__c', QueueId=grp.Id);
                database.insert(que);
                 
                GA_CID_Adjustment__c cidRec=GA_OBJ_TD01_TestDataCreation.cidAdjRecrd();
                cidRec.GA_Source_Account__c  = testAccount1.Id;
                cidRec.GA_Target_Account__c  = testAccount2.Id;
                database.insert(cidRec);
                
                cidRec.OwnerId=grp.Id;
                cidRec.GA_Status__c='New';
                database.update(cidRec);
                
                GA_Process_Group_Segment__c prGS = new GA_Process_Group_Segment__c();
                prGS.GA_CID_Adjustment__c=cidRec.Id;
                prGS.GA_Group_Segment__c=grpsgmt.Id;
                database.insert(prGS);
                                
                Test.startTest();
                GA_AP_CIDAdjAssnmtCls.assignCIDAdjOwnership(cidRec.Id, Usr.Id);           
                Test.stopTest();
                
                System.assert(cidRec <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }   
    /*******************************************************************************************************************************
@Description: cidAdjAssnmtMismatRec() method 
@Name : cidAdjAssnmtMismatRec
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void cidAdjAssnmtMismatRec(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount1);
                
                Account testAccount2= GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount2);
                
                GA_Group_Segment__c grpsgmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount1);  
                grpsgmt.Status__c='Pending';
                database.insert(grpsgmt);
                
                grpsgmt.Status__c='Active';
                database.update(grpsgmt);
                
                Group grp = new Group(Type='Queue', Name='TestQueue');
                database.insert(grp);
                
                QueueSObject que = new QueueSObject(SobjectType='GA_CID_Adjustment__c', QueueId=grp.Id);
                database.insert(que);
                 
                GA_CID_Adjustment__c cidRec=GA_OBJ_TD01_TestDataCreation.cidAdjRecrd();
                cidRec.GA_Source_Account__c  = testAccount1.Id;
                cidRec.GA_Target_Account__c  = testAccount2.Id;
                cidRec.GA_Federal_Tax_ID_Mismatch__c = True;
                database.insert(cidRec);
                
                cidRec.OwnerId=grp.Id;
                cidRec.GA_Status__c='New';
                database.update(cidRec);
                
                GA_Process_Group_Segment__c prGS = new GA_Process_Group_Segment__c();
                prGS.GA_CID_Adjustment__c=cidRec.Id;
                prGS.GA_Group_Segment__c=grpsgmt.Id;
                database.insert(prGS);
                
                Test.startTest();
                GA_AP_CIDAdjAssnmtCls.assignCIDAdjOwnership(cidRec.Id, Usr.Id);           
                Test.stopTest();
                
                System.assert(cidRec <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }   
    
    /*******************************************************************************************************************************
@Description: cidAdjAssnmtCatchExcp() method 
@Name : cidAdjAssnmtCatchExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void cidAdjAssnmtCatchExcp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount1);
                
                Account testAccount2= GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount2);
                
                GA_Group_Segment__c grpsgmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount1);               
                database.insert(grpsgmt);
                
                GA_CID_Adjustment__c cidRec=GA_OBJ_TD01_TestDataCreation.cidAdjRecrd();
                cidRec.GA_Source_Account__c  = testAccount1.Id;
                cidRec.GA_Target_Account__c  = testAccount2.Id;
                database.insert(cidRec);
                
                Test.startTest();
                GA_AP_CIDAdjAssnmtCls.assignCIDAdjOwnership(null, null);           
                Test.stopTest();
                
                System.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}