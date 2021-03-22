/*
@Author : IDC Offshore
@Name: GA_CON_AP01_Owner_Update_Test 
@CreatedDate: 22 - Aug 2019 
@Description: GA_CON_AP01_Owner_Update_Test Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_CON_AP01_Owner_Update_Test {
    
        /*******************************************************************************************************************************
@Description: plExcptnFutureEndDt() method 
@Name : plExcptnFutureEndDt
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updateContactOwnerOnAccChange(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{                
                user usrSB = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
                database.insert(usrSB);
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();                
                database.insert(testAccount);
                
                testAccount.OwnerId = usrSB.id;
                database.update(testAccount);
                
                Map<ID,Contact> contactOldMap = new Map<ID,Contact> (); 
                
                Contact testContact = GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
                testContact.OwnerId=usrSA.Id;
                database.insert(testContact);
                system.debug('Owner '+testContact.OwnerId+testContact.GA_OwnerId__c);
                                
                contactOldMap.put(testContact.id,testContact);
                
                List<Contact> cntList = new List<Contact>();
                cntList.add(testContact);
                               
                test.startTest();
                
                GA_CON_AP01_Owner_Update.updateContactOwnerOnAccChange(cntList,contactOldMap);
                test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    } 
    
    private static testmethod void updateContactOwnerException(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{                
                test.startTest();
                GA_CON_AP01_Owner_Update.updateContactOwner(null);
                GA_CON_AP01_Owner_Update.updateContactOwnerOnAccChange(null,null);
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