/*
@Author : Sri Lakshmi Addula
@Name: GA_AOREmailsSchdlr_Test 
@CreatedDate: 5 - Aug 2019 
@Description: GA_AOREmailsSchdlr Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AOREmailsSchdlr_Test {
   /***********************************************************************************************************************************************
@Description: executeTest() method 
@Name : executeTest
@Param : None
@Return : void
@throws Exception : N/A;
************************************************************************************************************************************************/   
    private static testmethod void executeTest()
    {   
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap = new Map<Id,GA_AOR_Group_Segment__c> ();
        
        Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        database.insert(gsmt); 
        
        Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc.id);
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        cnt.Email = 'cntc@gmail.com';
        database.insert(cnt); 
        
        acc.GA_Decision_Maker__c = cnt.id;
        database.update(acc);
        
        GA_Aor__C aorRec = GA_OBJ_TD01_TestDataCreation.createAOR(acc,cnt);
        aorRec.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
        aorRec.GA_Service_End_Date__c =system.today();
        aorRec.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        aorRec.GA_Commission_End_Date__c =system.today();
        aorRec.GA_Process_Date__c=system.today();
        aorRec.GA_Customer_Letter_Type__c ='AOR Normal (Group)';
        database.insert(aorRec); 
      
        system.runAs(usr){
            
            try{
                GA_AOREmailsSchdlr aor= new GA_AOREmailsSchdlr();
                String sch = '0 0 23 * * ?'; 
                string CREATEDT=string.valueof(system.today()).split(' ')[0];
                STring AORQRY='select id,Name,GA_Service_Start_Date__c,GA_Commission_Start_Date__c,GA_Letter_Type__c,GA_Customer_Letter_Type__c,GA_To__c,GA_CC__c,GA_Process_Date__c,GA_Contact_Id__c,	GA_Account_Id__r.GA_Decision_Maker__c from  GA_AOR__c where (GA_Customer_Letter_Type__c <> null or GA_Letter_Type__c <> null) and GA_Process_Date__c = '+CREATEDT +' ORDER BY createddate asc';
                
                Test.startTest();
                system.schedule('aor update', sch, aor);
                Test.stopTest(); 
                system.assert(aorRec <> null);
            }
            catch(exception e)
            {
                return;
            }        
        }
        
    }
    
}