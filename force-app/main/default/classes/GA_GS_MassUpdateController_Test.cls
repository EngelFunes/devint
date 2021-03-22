/**
@Author : IDC offshore
@Name: GA_GS_MassUpdateController_Test
@CreatedDate: 8 - June 2018 
@Description: GA_GS_MassUpdateController_Test class is for GA_GS_MassUpdateController class.
@version : 1.0  
*/ 
@isTest(seealldata=false)
private class GA_GS_MassUpdateController_Test
{
    /**
@Description: GSMAssUpdate() method 
@Name : GSMAssUpdate
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/  
    private static testMethod void gsMAssUpdate()
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
               // gsRec.GA_Detailed_Rehire_Narrative__c='W/1ST BILL AFTER REHIRE DATE';
                gsRec.GA_New_Hire_Exception__c='Excep';
                gsRec.GA_Transfer_Clause_Indicator__c=True;
                gsRec.GA_HBA_Division_Link__c='www.abc.com';
                gsRec.GA_HBI_Enhanced__c=True;
                gsRec.GA_HBI_Standard__c=True;
                gsRec.GA_HBA_Level__c='Standard';
                gsRec.GA_HBA__c=True;
                gsRec.GA_MVP__c=False; 
                database.insert(gsRec);
                
                database.insert(new GA_Mass_Update_Access__c(SetupOwnerId=UserInfo.getOrganizationId(), Access__c=true));
                
                GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, True);
                
                gsRec.GA_Federal_Tax_ID_Number__c='123454';
                gsRec.GA_Is_Mass_Updating__c = True;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                database.update(gsRec);
                
                GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, True);
                gsRec.GA_Is_Mass_Updating__c = True;
                gsRec.GA_New_Hire_Change__c=False;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                database.update(gsRec);
                GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, False);
                
                List<GA_Group_Segment__c> gslist = [Select Id, GA_Federal_Tax_ID_Number__c from GA_Group_Segment__c where  GA_HBA__c= True  limit 1000];
                
                String gsStringList = '[{"gsId":"gsmid"}]';
                gsStringList = gsStringList.replace('gsmid', String.valueOf(gsRec.Id));
                //String GSCurrectSting = String.valueOf(gsRec);
                
                GA_GS_MassUpdateController.processSelectedRecords(gsStringList, gsRec.Id, True);
                GA_GS_MassUpdateController.processSelectedRecords(gsStringList, gsRec.Id, False);
                
                String gsAccStringList = '[{"gsId":"accid", "typeVal":"account"}]';
                gsAccStringList = gsAccStringList.replace('accid', String.valueOf(acc.Id));
                GA_GS_MassUpdateController.processSelectedRecords(gsAccStringList, gsRec.Id, True);
                GA_GS_MassUpdateController.grSgmntLst(accId, currentId, fetchAcc);
                GA_GS_MassUpdateController.fetchAccsgrSgmntLst(accId);
                GA_GS_MassUpdateController.processSelectedRecords(grpSegRecords, currentGrpSgmnt, fedTxId);
                GA_GS_MassUpdateController.saveFedTaxId(grpSegRecords, acFedTaxId); 
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
        
    }
    /**
@Description: AccMAssUpdate() method 
@Name : AccMAssUpdate
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/    
    private static testMethod void accMAssUpdate()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
            acc.Federal_Tax_ID__c='1234';
            database.insert(acc);
            
            GA_Mass_Update_Access__c cusset = new GA_Mass_Update_Access__c();
            cusset.Access__c=True;
            database.insert(cusset);
            
            GA_GS_MassUpdateController.fetchAccsgrSgmntLst(acc.Id);
            
            GA_Group_Segment__c gsRec = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
            database.insert(gsRec);
            
            List<GA_Group_Segment__c> gsReclst1=new List<GA_Group_Segment__c>();
            for(Integer i=0; i<2; i++)
            {
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.Name = 'Test GrpSgmnt'+i;
                grpsgmt.GA_Account__c = acc.Id;
                grpsgmt.GA_Is_Selected__c = true;
                grpsgmt.Status__c='ACtive';
                gsReclst1.add(grpsgmt);
            }
            database.insert(gsReclst1);
            
            GA_GS_MassUpdateController.fetchAccsgrSgmntLst(acc.Id);
            
            acc.Federal_Tax_ID__c='';
            database.update(acc);
            GA_GS_MassUpdateController.fetchAccsgrSgmntLst(acc.Id);
            
            system.assert(usr <> null);
        }
    }
    /**
@Description: GSFederalTaxIdIsBlank() method 
@Name : GSFederalTaxIdIsBlank
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/    
    private static testMethod void gsFederalTaxIdIsBlank()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
            acc.Federal_Tax_ID__c='';
            acc.GA_Is_Mass_Updating__c= true;
            database.insert(acc);
            
            GA_Group_Segment__c gsRec = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
            gsRec.GA_HBA__c=True;
            gsRec.Status__c='Active';
            gsRec.GA_Federal_Tax_ID_Number__c='';
            database.insert(gsRec);
            
            GA_Mass_Update_Access__c cusset = new GA_Mass_Update_Access__c();
            cusset.Access__c=True;
            database.insert(cusset);
            
            List<GA_Group_Segment__c> gsReclst1=new List<GA_Group_Segment__c>();
            for(Integer i=0; i<2; i++)
            {
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.Name = 'Test GrpSgmnt'+i;
                grpsgmt.GA_Account__c = acc.Id;
                grpsgmt.GA_Is_Selected__c = true;
                grpsgmt.Status__c='Active';
                gsReclst1.add(grpsgmt);
            }
            database.insert(gsReclst1);
            
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, True);
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, False);
            
            system.assert(usr <> null);
        }    
    }
    /**
@Description: GSAccountIsSmart() method 
@Name : GSAccountIsSmart
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/     
    private static testMethod void gsAccountIsSmart()
    {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc);
            
            List<GA_Group_Segment__c> gsLst = new List<GA_Group_Segment__c>();
            GA_Group_Segment__c gsRec = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
            gsRec.Status__c='Pending';
            gsRec.Network__c='NASCO';
            gsRec.GA_Federal_Tax_ID_Number__c='1234';
            gsRec.GA_Bill_Adj_Seq_Code__c='3';
            gsRec.GA_Bill_Period_Code__c='1';
            gsRec.GA_ID_Card_Seq_Code__c='2';
            gsRec.GA_Invoice_Code__c = '4';
            gsRec.GA_Mail_Instruction_Code__c='G';
            gsRec.GA_Type_Eligible__c='Y';
            gsRec.GA_Billing_Cycle_Day__c='13';
            gsRec.GA_Surviving_Spouse_Option__c=True;
            // gsRec.GA_Previous_Carrier__c='AIG';
            gsRec.GA_New_Hire_Change__c=True;
            gsRec.GA_Current_Cluster_Code__c = '0000';
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
            gsLst.add(gsRec);
            //  database.insert(gsRec);
            
            GA_Mass_Update_Access__c cusset = new GA_Mass_Update_Access__c();
            cusset.Access__c=True;
            database.insert(cusset);
            
            //  List<GA_Group_Segment__c> gsReclst1=new List<GA_Group_Segment__c>();
            for(Integer i=0; i<2; i++)
            {
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.Name = 'Test GrpSgmnt'+i;
                grpsgmt.GA_Account__c = acc.Id;
                grpsgmt.GA_Is_Selected__c = true;
                grpsgmt.Status__c='Active';
                // gsReclst1.add(grpsgmt);
                gsLst.add(grpsgmt);
            }
            //   database.insert(gsReclst1);
            
            //  List<GA_Group_Segment__c> gsReclst2=new List<GA_Group_Segment__c>();
            for(Integer i=3; i<5; i++)
            {
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.Name = 'Test GrpSgmnt'+i;
                grpsgmt.GA_Account__c = acc.Id;
                grpsgmt.GA_Is_Selected__c = true;
                grpsgmt.Status__c='Pending';
                //gsReclst2.add(grpsgmt);
                gsLst.add(grpsgmt);
            }
            // database.insert(gsReclst2);
            
            // List<GA_Group_Segment__c> GSReclst3=new List<GA_Group_Segment__c>();
            for(Integer i=6; i<8; i++)
            {
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.Name = 'Test GrpSgmnt'+i;
                grpsgmt.GA_Account__c = acc.Id;
                grpsgmt.GA_Is_Selected__c = true;
                grpsgmt.Status__c='Canceled';
                // GSReclst3.add(grpsgmt);
                gsLst.add(grpsgmt);
            }
            // database.insert(GSReclst3);
            database.insert(gsLst);
            
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, True);
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, False);
            
            gsRec.GA_Is_Mass_Updating__c = True;
            gsRec.Status__c='Pending';
            database.update(gsRec);
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, True);
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, False);
            
            
            gsRec.Status__c='Canceled';
            database.update(gsRec);
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, True);
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, False);
            
            
            gsRec.Status__c='Active';
            database.update(gsRec);
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, True);
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, False);
            
            acc.GA_System_of_Record__c='SMART';
            database.update(acc);
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, True); 
            GA_GS_MassUpdateController.grSgmntLst(acc.Id, gsRec.Id, False);
            
            system.assert(usr <> null);
        }
    }
    /**
@Description: GSMAssUpdateSales() method 
@Name : GSMAssUpdateSales
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/     
    private static testMethod void gsMAssUpdateSales()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Specialty Sales');
        database.insert(usr);
        system.runAs(usr)
        {
            string accid = 'test';
            string gsRecid = 'GSid';
            GA_GS_MassUpdateController.grSgmntLst(accid, gsRecid, True);
            GA_GS_MassUpdateController.fetchAccsgrSgmntLst(accid);
            
            system.assert(usr <> null);
        }
        
    }
    /**
@Description: TestSaveFEdTaxId() method 
@Name : TestSaveFEdTaxId
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/     
    private static testmethod void testSaveFEdTaxId()
    {
        {
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Support');
            database.insert(usr);
            system.runAs(usr)
            {
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.Federal_Tax_ID__c='12324';
                database.insert(acc);
                
                GA_Group_Segment__c gsRec = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gsRec.GA_HBA__c=True;
                gsRec.GA_Federal_Tax_ID_Number__c='';
                database.insert(gsRec);
                
                List<GA_Group_Segment__c> gslist = [Select Id, GA_Federal_Tax_ID_Number__c from GA_Group_Segment__c where  GA_HBA__c= True  limit 1000];
                
                String gsStringList = '[{"gsId":"gsmid"}]';
                gsStringList = gsStringList.replace('gsmid', String.valueOf(gsRec.Id));
                
                GA_GS_MassUpdateController.saveFedTaxId(gsStringList,acc.Federal_Tax_ID__c);
                
                system.assert(usr <> null);
            } 
        }
    }
}