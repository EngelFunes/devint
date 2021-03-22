/** Class Name  : GA_GS_MassAddressUpdateController_Test
* Project / CR  : BCBSM
* Description   : This Test class is for GA_GS_MassAddressUpdateController class.
* Created On    : 01/13/2020

* Modification Log:
* --------------------------------------------------------------------------------------------------------------------------------------
* Date             Developer           Description
* --------------------------------------------------------------------------------------------------------------------------------------
* 01/13/2020       Rahul      			Created
*
*/ 
@isTest(seealldata=false)
public class GA_GS_MassAddressUpdateController_Test 
{
	private static testMethod void gsMAssUpdate()
    {
        //User creation and runnning as that user
    	user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                string accId=''; 
                string currentId=''; 
                Boolean fetchAcc=false;
                string grpSegRecords='';
                String currentGrpSgmnt='';
                Boolean fedTxId=false;
                String acFedTaxId='';
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gsRec = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gsRec.Status__c='Active';
                gsRec.GA_Federal_Tax_ID_Number__c='1234';
                gsRec.GA_Bill_Adj_Seq_Code__c='3';
                gsRec.GA_Bill_Period_Code__c='1';
                gsRec.GA_ID_Card_Seq_Code__c='2';
                gsRec.GA_Invoice_Code__c = '4';
                gsRec.GA_Mail_Instruction_Code__c='G';
                gsRec.GA_Type_Eligible__c='Y';
                gsRec.GA_Billing_Cycle_Day__c='13';
                gsRec.GA_Surviving_Spouse_Option__c=True;
                //gsRec.GA_Previous_Carrier__c='AIG';
                gsRec.GA_New_Hire_Change__c=True;
                gsRec.GA_New_Hire_Effective_Date__c=system.today();
                gsRec.GA_New_Hire_Rehire_Option_Id__c='S2';
                //gsRec.GA_Detailed_Rehire_Narrative__c='W/1ST BILL AFTER REHIRE DATE';
                gsRec.GA_New_Hire_Exception__c='Excep';
                gsRec.GA_Transfer_Clause_Indicator__c=True;
                gsRec.GA_HBA_Division_Link__c='www.abc.com';
                gsRec.GA_HBI_Enhanced__c=True;
                gsRec.GA_HBI_Standard__c=True;
                gsRec.GA_HBA_Level__c='Standard';
                gsRec.GA_HBA__c=True;
                gsRec.GA_MVP__c=False; 
                database.insert(gsRec);
                
                List<String> lstGrpSegments =new List<String>();
                lstGrpSegments.add(gsRec.Id);
                
                GA_GS_MassAddressUpdateController.getRelatedRecords(String.valueOf(acc.Id));
                GA_GS_MassAddressUpdateController.massUpdateGrpSegments(String.valueOf(acc.Id), lstGrpSegments, 'mailing', 'billing');
                GA_GS_MassAddressUpdateController.validateLoginUser(String.valueOf(acc.Id));
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    private static testMethod void gsMAssUpdate1()
    {
    	user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                string accId=''; 
                string currentId=''; 
                Boolean fetchAcc=false;
                string grpSegRecords='';
                String currentGrpSgmnt='';
                Boolean fedTxId=false;
                String acFedTaxId='';
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gsRec1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gsRec1.Status__c='Active';
                gsRec1.GA_Federal_Tax_ID_Number__c='1234';
                gsRec1.GA_Bill_Adj_Seq_Code__c='3';
                gsRec1.GA_Bill_Period_Code__c='1';
                gsRec1.GA_ID_Card_Seq_Code__c='2';
                gsRec1.GA_Invoice_Code__c = '4';
                gsRec1.GA_Mail_Instruction_Code__c='G';
                gsRec1.GA_Type_Eligible__c='Y';
                gsRec1.GA_Billing_Cycle_Day__c='13';
                gsRec1.GA_Surviving_Spouse_Option__c=True;
                //gsRec.GA_Previous_Carrier__c='AIG';
                gsRec1.GA_New_Hire_Change__c=True;
                gsRec1.GA_New_Hire_Effective_Date__c=system.today();
                gsRec1.GA_New_Hire_Rehire_Option_Id__c='S2';
                //gsRec1.GA_Detailed_Rehire_Narrative__c='W/1ST BILL AFTER REHIRE DATE';
                gsRec1.GA_New_Hire_Exception__c='Excep';
                gsRec1.GA_Transfer_Clause_Indicator__c=True;
                gsRec1.GA_HBA_Division_Link__c='www.abc.com';
                gsRec1.GA_HBI_Enhanced__c=True;
                gsRec1.GA_HBI_Standard__c=True;
                gsRec1.GA_HBA_Level__c='Standard';
                gsRec1.GA_HBA__c=True;
                gsRec1.GA_MVP__c=False; 
                database.insert(gsRec1);
                
                List<String> lstGrpSegments1 =new List<String>();
                lstGrpSegments1.add(gsRec1.Id);
                
                GA_GS_MassAddressUpdateController.getRelatedRecords(String.valueOf(acc.Id));
                GA_GS_MassAddressUpdateController.massUpdateGrpSegments(String.valueOf(acc.Id), lstGrpSegments1, 'mailing', 'mailing');
                GA_GS_MassAddressUpdateController.validateLoginUser(String.valueOf(acc.Id));
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    private static testMethod void gsMAssUpdate2()
    {
    	user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                string accId=''; 
                string currentId=''; 
                Boolean fetchAcc=false;
                string grpSegRecords='';
                String currentGrpSgmnt='';
                Boolean fedTxId=false;
                String acFedTaxId='';
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gsRec1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gsRec1.Status__c='Active';
                gsRec1.GA_Federal_Tax_ID_Number__c='1234';
                gsRec1.GA_Bill_Adj_Seq_Code__c='3';
                gsRec1.GA_Bill_Period_Code__c='1';
                gsRec1.GA_ID_Card_Seq_Code__c='2';
                gsRec1.GA_Invoice_Code__c = '4';
                gsRec1.GA_Mail_Instruction_Code__c='G';
                gsRec1.GA_Type_Eligible__c='Y';
                gsRec1.GA_Billing_Cycle_Day__c='13';
                gsRec1.GA_Surviving_Spouse_Option__c=True;
                //gsRec.GA_Previous_Carrier__c='AIG';
                gsRec1.GA_New_Hire_Change__c=True;
                gsRec1.GA_New_Hire_Effective_Date__c=system.today();
                gsRec1.GA_New_Hire_Rehire_Option_Id__c='S2';
               // gsRec1.GA_Detailed_Rehire_Narrative__c='W/1ST BILL AFTER REHIRE DATE';
                gsRec1.GA_New_Hire_Exception__c='Excep';
                gsRec1.GA_Transfer_Clause_Indicator__c=True;
                gsRec1.GA_HBA_Division_Link__c='www.abc.com';
                gsRec1.GA_HBI_Enhanced__c=True;
                gsRec1.GA_HBI_Standard__c=True;
                gsRec1.GA_HBA_Level__c='Standard';
                gsRec1.GA_HBA__c=True;
                gsRec1.GA_MVP__c=False; 
                database.insert(gsRec1);
                
                List<String> lstGrpSegments1 =new List<String>();
                lstGrpSegments1.add(gsRec1.Id);
                
                GA_GS_MassAddressUpdateController.getRelatedRecords(String.valueOf(acc.Id));
               	GA_GS_MassAddressUpdateController.validateLoginUser(String.valueOf(acc.Id));
                GA_GS_MassAddressUpdateController.massUpdateGrpSegments(String.valueOf(acc.Id), lstGrpSegments1, 'mailing', 'physical');
               
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    private static testMethod void gsMAssUpdate3()
    {
    	user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                string accId=''; 
                string currentId=''; 
                Boolean fetchAcc=false;
                string grpSegRecords='';
                String currentGrpSgmnt='';
                Boolean fedTxId=false;
                String acFedTaxId='';
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gsRec1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gsRec1.Status__c='Active';
                gsRec1.GA_Federal_Tax_ID_Number__c='1234';
                gsRec1.GA_Bill_Adj_Seq_Code__c='3';
                gsRec1.GA_Bill_Period_Code__c='1';
                gsRec1.GA_ID_Card_Seq_Code__c='2';
                gsRec1.GA_Invoice_Code__c = '4';
                gsRec1.GA_Mail_Instruction_Code__c='G';
                gsRec1.GA_Type_Eligible__c='Y';
                gsRec1.GA_Billing_Cycle_Day__c='13';
                gsRec1.GA_Surviving_Spouse_Option__c=True;
                //gsRec.GA_Previous_Carrier__c='AIG';
                gsRec1.GA_New_Hire_Change__c=True;
                gsRec1.GA_New_Hire_Effective_Date__c=system.today();
                gsRec1.GA_New_Hire_Rehire_Option_Id__c='S2';
               // gsRec1.GA_Detailed_Rehire_Narrative__c='W/1ST BILL AFTER REHIRE DATE';
                gsRec1.GA_New_Hire_Exception__c='Excep';
                gsRec1.GA_Transfer_Clause_Indicator__c=True;
                gsRec1.GA_HBA_Division_Link__c='www.abc.com';
                gsRec1.GA_HBI_Enhanced__c=True;
                gsRec1.GA_HBI_Standard__c=True;
                gsRec1.GA_HBA_Level__c='Standard';
                gsRec1.GA_HBA__c=True;
                gsRec1.GA_MVP__c=False; 
                database.insert(gsRec1);
                
                List<String> lstGrpSegments1 =new List<String>();
                lstGrpSegments1.add(gsRec1.Id);
                
                GA_GS_MassAddressUpdateController.getRelatedRecords(String.valueOf(acc.Id));
				GA_GS_MassAddressUpdateController.validateLoginUser(String.valueOf(acc.Id));               
                GA_GS_MassAddressUpdateController.massUpdateGrpSegments(String.valueOf(acc.Id), lstGrpSegments1, 'physical', 'billing');
               
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    private static testMethod void gsMAssUpdate4()
    {
    	user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                string accId=''; 
                string currentId=''; 
                Boolean fetchAcc=false;
                string grpSegRecords='';
                String currentGrpSgmnt='';
                Boolean fedTxId=false;
                String acFedTaxId='';
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gsRec1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gsRec1.Status__c='Active';
                gsRec1.GA_Federal_Tax_ID_Number__c='1234';
                gsRec1.GA_Bill_Adj_Seq_Code__c='3';
                gsRec1.GA_Bill_Period_Code__c='1';
                gsRec1.GA_ID_Card_Seq_Code__c='2';
                gsRec1.GA_Invoice_Code__c = '4';
                gsRec1.GA_Mail_Instruction_Code__c='G';
                gsRec1.GA_Type_Eligible__c='Y';
                gsRec1.GA_Billing_Cycle_Day__c='13';
                gsRec1.GA_Surviving_Spouse_Option__c=True;
                //gsRec.GA_Previous_Carrier__c='AIG';
                gsRec1.GA_New_Hire_Change__c=True;
                gsRec1.GA_New_Hire_Effective_Date__c=system.today();
                gsRec1.GA_New_Hire_Rehire_Option_Id__c='S2';
              //  gsRec1.GA_Detailed_Rehire_Narrative__c='W/1ST BILL AFTER REHIRE DATE';
                gsRec1.GA_New_Hire_Exception__c='Excep';
                gsRec1.GA_Transfer_Clause_Indicator__c=True;
                gsRec1.GA_HBA_Division_Link__c='www.abc.com';
                gsRec1.GA_HBI_Enhanced__c=True;
                gsRec1.GA_HBI_Standard__c=True;
                gsRec1.GA_HBA_Level__c='Standard';
                gsRec1.GA_HBA__c=True;
                gsRec1.GA_MVP__c=False; 
                database.insert(gsRec1);
                
                List<String> lstGrpSegments1 =new List<String>();
                lstGrpSegments1.add(gsRec1.Id);
                
                GA_GS_MassAddressUpdateController.getRelatedRecords(String.valueOf(acc.Id));
                GA_GS_MassAddressUpdateController.validateLoginUser(String.valueOf(acc.Id));
                GA_GS_MassAddressUpdateController.massUpdateGrpSegments(String.valueOf(acc.Id), lstGrpSegments1, 'physical', 'mailing');
               
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    private static testMethod void gsMAssUpdate5()
    {
    	user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                string accId=''; 
                string currentId=''; 
                Boolean fetchAcc=false;
                string grpSegRecords='';
                String currentGrpSgmnt='';
                Boolean fedTxId=false;
                String acFedTaxId='';
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gsRec1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gsRec1.Status__c='Active';
                gsRec1.GA_Federal_Tax_ID_Number__c='1234';
                gsRec1.GA_Bill_Adj_Seq_Code__c='3';
                gsRec1.GA_Bill_Period_Code__c='1';
                gsRec1.GA_ID_Card_Seq_Code__c='2';
                gsRec1.GA_Invoice_Code__c = '4';
                gsRec1.GA_Mail_Instruction_Code__c='G';
                gsRec1.GA_Type_Eligible__c='Y';
                gsRec1.GA_Billing_Cycle_Day__c='13';
                gsRec1.GA_Surviving_Spouse_Option__c=True;
                //gsRec.GA_Previous_Carrier__c='AIG';
                gsRec1.GA_New_Hire_Change__c=True;
                gsRec1.GA_New_Hire_Effective_Date__c=system.today();
                gsRec1.GA_New_Hire_Rehire_Option_Id__c='S2';
               // gsRec1.GA_Detailed_Rehire_Narrative__c='W/1ST BILL AFTER REHIRE DATE';
                gsRec1.GA_New_Hire_Exception__c='Excep';
                gsRec1.GA_Transfer_Clause_Indicator__c=True;
                gsRec1.GA_HBA_Division_Link__c='www.abc.com';
                gsRec1.GA_HBI_Enhanced__c=True;
                gsRec1.GA_HBI_Standard__c=True;
                gsRec1.GA_HBA_Level__c='Standard';
                gsRec1.GA_HBA__c=True;
                gsRec1.GA_MVP__c=False; 
                database.insert(gsRec1);
                
                List<String> lstGrpSegments1 =new List<String>();
                lstGrpSegments1.add(gsRec1.Id);
                
                GA_GS_MassAddressUpdateController.getRelatedRecords(String.valueOf(acc.Id));
                GA_GS_MassAddressUpdateController.validateLoginUser(String.valueOf(acc.Id));
                GA_GS_MassAddressUpdateController.massUpdateGrpSegments(String.valueOf(acc.Id), lstGrpSegments1, 'physical', 'physical');
               
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
}