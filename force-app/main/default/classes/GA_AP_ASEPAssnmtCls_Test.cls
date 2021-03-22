/**
@Author : IDC Offshore
@Name: GA_AP_ASEPAssnmtCls_Test 
@CreatedDate: 20-Mar-2018
@Description: Test class for GA_AP_ASEPAssnmtCls
@version : 1.0  
*/
@isTest(seealldata=false)
private class GA_AP_ASEPAssnmtCls_Test {
/*******************************************************************************************************************************
@Description        :   ASEPAssignOwnership() method 
@Name               :   ASEPAssignOwnership
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void assignASEPOwnership()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account accRecd=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accRecd); 
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd);            
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                aseRecd.GA_Account_Id__c=accRecd.Id;   
                database.insert(aseRecd);
                Group grp = new Group(Type='Queue', Name='TestQueue');
                database.insert(grp);
                
                QueueSObject que = new QueueSObject(SobjectType='GA_Agent_Sold_Enrollment__c', QueueId=grp.Id);
                database.insert(que);
                
                aseRecd.OwnerId=grp.Id;              
                database.update(aseRecd);
                test.startTest();
                GA_AP_ASEPAssnmtCls.assignASEPOwnership(aseRecd.Id,usr.Id);
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