/**
@Author : Padma J
@Name: GA_AFS_InvokeAFSEmailFlow_Test 
@CreatedDate: 31 - Jul 2017 
@Description: GA_AFS_InvokeAFSEmailFlow Test class 
@version : 1.0  
*/
@isTest
private class GA_AFS_InvokeAFSEmailFlow_Test {
    /**
@Description: agntIdentitySlsRep() method 
@Name : agntIdentitySlsRep
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    static testmethod void invokeFSTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestFSRl','testsalesrepmail@bcbsm.com','Support');
        insert usr;
        system.runAs(usr)
        {
            Account custaccnt=GA_OBJ_TD01_TestDataCreation.AccRec();
            insert custaccnt;
            contact cnt=GA_OBJ_TD01_TestDataCreation.cntactRec(custaccnt.id);
            database.insert(cnt);
            GA_Account_Fact_Sheet__c fsRec = GA_OBJ_TD01_TestDataCreation.accFactSheetRec(custaccnt,cnt);
            insert fsRec;          
            PageReference pageRef = Page.GA_VF_01_GenerateFactSheet; // Add your VF page Name here
            Test.setCurrentPage(pageRef); 
            ApexPages.StandardController stdController =new ApexPages.standardController(fsRec) ;
            GA_AFS_InvokeAFSEmailFlow invokeEmail = New GA_AFS_InvokeAFSEmailFlow(stdController);
            invokeEmail.GenerateFactsheetDoc();
            
        }    
        
    }
    /**
@Description: NegativeTest() method 
@Name : NegativeTest
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    static testmethod void NegativeTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestFSRl','testsalesrepmail@bcbsm.com','Support');
        insert usr;
        system.runAs(usr)
        {
            test.startTest();
            GA_Account_Fact_Sheet__c fsRec = new GA_Account_Fact_Sheet__c();
            PageReference pageRef = Page.GA_VF_01_GenerateFactSheet;// Add your VF page Name here
            Test.setCurrentPage(pageRef);
            ApexPages.StandardController stdController =new ApexPages.standardController(fsRec) ;
            GA_AFS_InvokeAFSEmailFlow invokeEmail = New GA_AFS_InvokeAFSEmailFlow(stdController);
            invokeEmail.p=null;
            invokeEmail.GenerateFactsheetDoc();
            test.stopTest();
        }    
        
    }
}