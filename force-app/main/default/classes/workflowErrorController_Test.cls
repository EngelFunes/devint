/*****************************************************************************************
Class Name   : workflowErrorController_Test 
Date Created : 25-02-2021
Created By   : IDC Offshore
Description  : This test class if for workflowErrorController class
******************************************************************************************/

@isTest(SeeAllData=false)
public class workflowErrorController_Test {
	private static  string name12='admin';
    private static final string PROFILENAME1='System Administrator';
    private static final string IDS = 'id';
    private static final string PROFILENAME2='Small Group Underwriter';
    private static final string RECORDTYPENAMEACC='Account - Customer';
    private static final string RECORDTYPENAMECON='Enrollment';
    private static final string ERROR = 'Error to be displayed in test class';
    
    /*********************************************************************************************************
    @Description: testDataSetup() method 
    @Name : testDataSetup1
    @Param : N/A
    @Return : void
    @throws Exception : N/A;
    ***********************************************************************************************************/
    public workflowErrorController_Test(){
        system.assertEquals(name12,'admin','assertion');    
    }

    private static testmethod void runErrors() { 
        
        Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(RECORDTYPENAMEACC).getRecordTypeId();
    	Id recordTypeIdContract = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(RECORDTYPENAMECON).getRecordTypeId();
    	List<String> errorMessages1 = new List<String>();
        List<String> errorMessages2 = new List<String>();
       
    	//create Account test data
        Account acc= ARV_AP05_TestDataCreation.AccRec1(recordTypeIdAccount);
        database.insert(acc);
        
        //create Contract1 test data
        Contract cont1= ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        cont1.startdate=system.today();
        cont1.RecordTypeId = recordTypeIdContract;
        database.insert(cont1);
        
        //create Workflow1 test data
        GA_WF_Workflow__c wf1 = new GA_WF_Workflow__c();
        wf1.GA_Account__c = acc.id;
        wf1.ARV_Enrollment_Contract__c = cont1.id;
        database.insert(wf1);
        
        //create Contract2 test data
        Contract cont2= ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        cont2.startdate=system.today();
        cont2.RecordTypeId = recordTypeIdContract;
        cont2.ARV_BCN_Group_Error_Message__c = ERROR;
        cont2.ARV_BCBSM_Group_Error_Message__c=ERROR;
        cont2.ARV_BCN_Member_Error_Message__c=ERROR;
        cont2.ARV_BCBSM_Member_Error_Message__c=ERROR;
        database.insert(cont2);
        
        //create Workflow2 test data
        GA_WF_Workflow__c wf2 = new GA_WF_Workflow__c();
        wf2.GA_Account__c = acc.id;
        wf2.ARV_Enrollment_Contract__c = cont2.id;
        database.insert(wf2);
        
		//running test methods
		errorMessages1 = workflowErrorController.getErrorMessages(wf1.id);
        System.assertEquals(errorMessages1.size()>0,true);
        errorMessages2 = workflowErrorController.getErrorMessages(wf2.id);
        System.assertEquals(errorMessages2.size()>0,true);
    }    
}