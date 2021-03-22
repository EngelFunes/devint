@isTest(seealldata=false)
/***********************************************************************************************************
*Class Name   : ARV_AP22_InProgressMaintenance_Test
*Date Created : 18-August-2019
*Created By   : IDC Offshore
*Description  : It is test class for ARV_AP20_InProgressQuotesController 
***********************************************************************************************************/
public class ARV_AP22_InProgressMaintenance_Test {
    private static final string NAME='AP22Inprogress';
    private static final string PROFILENAME='System Administrator';
    private static final string ACCNAME='TestInprogress-TestBroker-10/10/1995';
    private static final string TYPE='OmniScripts';
    private static final string SUBTYPE='Enrollment';
    private static final string STATUS= 'In Progress';
    private static final string OBJECT1='Account';
    private static final string RESUMELINK='Test Link';
        
 /*********************************************************************************  
    Method name : testDataSetup
    Params      : NA
    Return Type : testmethod
    Description :  It creates the test data setup for this Class.
    ******************************************************************************/ 
     @testSetup static void testDataSetup() {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        database.insert(usr,true);        
        Account accnt=ARV_AP05_TestDataCreation.AccRec();
        accnt.Name=ACCNAME;
        database.insert(accnt); 
            //Create Omniscript record
        vlocity_ins__OmniScript__c  omniscript = New vlocity_ins__OmniScript__c();
        omniscript.Name = accnt.Name;
        omniscript.vlocity_ins__Type__c = TYPE;
        omniscript.vlocity_ins__SubType__c = SUBTYPE;
        omniscript.vlocity_ins__IsActive__c = True;
        omniscript.vlocity_ins__Version__c = 1.0;
        Database.insert(omniscript);               
        //Create Omniscript Instance records
        vlocity_ins__OmniScriptInstance__c  omniscr = New vlocity_ins__OmniScriptInstance__c();
        omniscr.Name = accnt.Name;
        omniscr.vlocity_ins__Status__c = STATUS;
        omniscr.vlocity_ins__ObjectId__c = accnt.Id;
        omniscr.vlocity_ins__ObjectLabel__c = OBJECT1;
        omniscr.vlocity_ins__ObjectName__c = accnt.Name;
        omniscr.vlocity_ins__RelativeResumeLink__c = omniscript.Id;
        omniscr.vlocity_ins__ResumeLink__c = RESUMELINK;
        omniscr.vlocity_ins__OmniScriptId__c = omniscript.Id;
        omniscr.vlocity_ins__LastSaved__c = System.now();
        Database.insert(omniscr); 
         
     }
 /*********************************************************************************  
    Method name : testInprogQuotes
    Params      : NA
    Return Type : 
    Description :  It coveres getInProcessQuotesList method 
    ******************************************************************************/ 
    private static testmethod void testInprogQuotes(){
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        List<vlocity_ins__OmniScriptInstance__c>savedOmni= New List<vlocity_ins__OmniScriptInstance__c>();
        system.runAs(usr1){
           Account act= [SELECT Id from Account where Name = 'TestInprogress-TestBroker-10/10/1995' limit 1];
            test.startTest();
           savedOmni= ARV_AP22_InProgressMaintenanceChange.getInProcessQuotesList(act.Id);
            ARV_AP22_InProgressMaintenanceChange.getCurrentUserProfile();
            test.stopTest();
            //system.assertEquals(1,savedOmni.size());          
        }
    }
     
}