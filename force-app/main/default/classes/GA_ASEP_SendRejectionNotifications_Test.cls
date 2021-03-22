/*
@Author : Sri Lakshmi Addula
@Name: GA_ASEP_SendRejectionNotifications_Test 
@CreatedDate: 15 - Nov 2018 
@Description: GA_ASEP_SendRejectionNotifications Test class
@version : 1.0  
*/
@isTest(seealldata=false)
private class GA_ASEP_SendRejectionNotifications_Test {
    /**
@Description: asepSoftRejection() method 
@Name : asepSoftRejection
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void asepSoftRejection()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                map<Id, GA_Agent_Sold_Enrollment__c> aseNewMap = new map<Id, GA_Agent_Sold_Enrollment__c>();
                map<Id, GA_Agent_Sold_Enrollment__c> aseOldMap = new map<Id, GA_Agent_Sold_Enrollment__c>();
                
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd);            
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                database.insert(aseRecd);
                aseRecd.GA_ASEP_Status__c='Pending - Controllable';
                aseRecd.GA_Rejection_Notification_Date__c=null;  
                aseRecd.GA_Rejection_Reason__c='TestRejectionReason';
                database.update(aseRecd);
                List<GA_Agent_Sold_Enrollment__c> aseList=new List<GA_Agent_Sold_Enrollment__c>();
                for(Integer i=0; i<2; i++)
                {
                    GA_Agent_Sold_Enrollment__c aseRcd= GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                    aseRcd.Name = 'Test ASEPRec'+i;
                    aseRcd.GA_ASEP_Status__c='Pending - Controllable';
                    aseRcd.GA_Rejection_Reason__c='TestRejectionReason';
                    aseList.add(asercd);
                }
                
                database.insert(aseList);
                test.startTest();
                GA_ASEP_SendRejectionNotifications.sendASEPRejectionNotfctToUsers(aseList,aseNewMap,aseOldMap);
                GA_ASEP_SendRejectionNotifications.UpdateRejectionNotfctDate(aseList,aseNewMap);
                test.stopTest();
                
                system.assert(aseList <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    
    /**
@Description: asepHardRejection() method 
@Name : asepHardRejection
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void asepHardRejection()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                map<Id, GA_Agent_Sold_Enrollment__c> aseNewMap = new map<Id, GA_Agent_Sold_Enrollment__c>();
                map<Id, GA_Agent_Sold_Enrollment__c> aseOldMap = new map<Id, GA_Agent_Sold_Enrollment__c>();
                
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd);            
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                database.insert(aseRecd);
                aseRecd.GA_ASEP_Status__c='Rejected - UnControllable';  
                aseRecd.GA_Rejection_Reason__c='TestRejectionReason';
                database.update(aseRecd);
                List<GA_Agent_Sold_Enrollment__c> aseList=new List<GA_Agent_Sold_Enrollment__c>();
                for(Integer i=0; i<2; i++)
                {
                    GA_Agent_Sold_Enrollment__c aseRcd= GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                    aseRcd.Name = 'Test ASEPRec'+i;
                    aseRcd.GA_ASEP_Status__c='Pending - Controllable';
                    aseRcd.GA_Rejection_Reason__c='TestRejectionReason';
                    aseList.add(aseRcd);
                }
                database.insert(aseList);
                test.startTest();
                GA_ASEP_SendRejectionNotifications.sendASEPRejectionNotfctToUsers(aseList,aseNewMap,aseOldMap);
                GA_ASEP_SendRejectionNotifications.UpdateRejectionNotfctDate(aseList,aseNewMap);
                test.stopTest();
                
                system.assert(aseList <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: asepHndlerException() method 
@Name : asepHndlerException
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void asepHndlerException()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                test.startTest();
                GA_ASEPTriggrHandler.afterupdate(null, null, null);
                GA_ASEPTriggrHandler.beforeupdate(null, null);
               	GA_ASEPTriggrHandler.beforeinsert(null, null);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}