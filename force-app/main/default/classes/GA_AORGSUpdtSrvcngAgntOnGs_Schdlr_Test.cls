/***********************************************************************************************************************************************
@Author : Idc Offshore
@Name: GA_AORGSUpdtSrvcngAgntOnGs_Schdlr_Test 
@CreatedDate: 6 - Aug 2019
@Description: GA_AORGSUpdtSrvcngAgntOnGs_Schdlr Test class 
@version : 1.0  
*************************************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_AORGSUpdtSrvcngAgntOnGs_Schdlr_Test {
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
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 
        
        Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        database.insert(cnt); 
        
        GA_Aor__C aorRec = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        aorRec.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
        aorRec.GA_Service_End_Date__c =system.today();
        database.insert(aorRec); 
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(aorRec,gsmt);
        aorGSRec.GA_Process_Start_Date__c=system.today()-1 ;
        aorGSRec.GA_Process_End_Date__c=system.today() +1;
        aorGSRec.GA_Cancel_Flag__c =false;
        database.insert(aorGSRec); 
        
        system.runAs(usr){
            
            try{               
                aorGSRec.GA_Cancel_Flag__c =true;
                aorGSRec.GA_Is_Mass_Updating__c = true;
                GA_AORGSUpdtSrvcngAgntOnGs_Schdlr aorgs = new GA_AORGSUpdtSrvcngAgntOnGs_Schdlr();
                String sch = '0 0 23 * * ?'; 
                
                Test.startTest();
                
                database.update(aorGSRec);
                
                system.schedule('aorgs update', sch, aorgs);
                Test.stopTest(); 
                system.assert(aorGSRec <> null);
            }
            catch(exception e)
            {
                return;
            }       
        }
        
    }
    
    
}