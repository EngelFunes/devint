/*
@Author : IDC Offshore
@Name: GA_Util16_MetaDataAccessLayer_Test
@CreatedDate: 26 - Nov 2018 
@Description: GA_Util16_MetaDataAccessLayer_Testclass
@version : 1.0  
*/
@isTest
public class GA_Util16_MetaDataAccessLayer_Test {
        /**
@Description: executeTest() method 
@Name : executeTest
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/  
      private static testmethod void EmailfNotifications()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                 test.startTest();
                GA_Util16_MetaDataAccessLayer.fetchWFqueueMap( 'SELECT id,GA_QueueName__c, GA_QueueType__c FROM GA_WF_Queue_Mapping__mdt',GA_Util16_MetaDataAccessLayer.BLANK,GA_Util16_MetaDataAccessLayer.BLANK,' limit 100 ');
                   GA_Util16_MetaDataAccessLayer.fetchWFqueueMap(null,GA_Util16_MetaDataAccessLayer.BLANK,GA_Util16_MetaDataAccessLayer.BLANK,'  ');
                GA_Util16_MetaDataAccessLayer.fetchUserStepRoleMap('Select id from User_Step_Role_Mapping__mdt', '', '', 'limit 100');   //( 'SELECT GA_QueueName__c, GA_QueueType__c FROM GA_WF_Queue_Mapping__mdt',GA_Util16_MetaDataAccessLayer.BLANK,GA_Util16_MetaDataAccessLayer.BLANK,' limit 100 ');
                 
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }

}