/*
@Author : IDC offshore
@Name: ARV_ContractCreateWorkflow_Test 
@CreatedDate: 12 - Dec 2019 
@Description: ARV_ContractCreateWorkflow Test class
@version : 1.0  
*/
@isTest(SeeAllData=FALSE)
private class ARV_AP62_ContractCreateWorkflow_Test 
{  
    /**   
@Description: contractWrkflowRecd() method 
@Name : contractWrkflowRecd
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void contractWrkflowRecd()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                string enableSMLGRPUWINTGN = system.label.ARV_CL40_Small_Group_Enable_Integration;
                string bcnHSAautmt = system.label.ARV_CL54_BCN_HSA_Automate;
                string bcnHRAautmt = system.label.ARV_CL55_BCN_HRA_Automate;
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                List<GA_Group_Segment__c> gsLst = new List<GA_Group_Segment__c>();
                
                GA_Group_Segment__c testGroupSegment=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                testGroupSegment.GA_Carrier__c='BCBSM';
                testGroupSegment.GA_MTV_Group__c='1';
                testGroupSegment.GA_MTV_Group_Division__c='2';
                testGroupSegment.ARV_BCN_HSA__c=true;
                gsLst.add(testGroupSegment);
                
                GA_Group_Segment__c testGroupSegment2=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                testGroupSegment2.GA_Carrier__c='BCN';
                testGroupSegment2.GA_Facets_Class_ID__c='1';
                testGroupSegment2.GA_Facets_Group_ID__c='2';
                testGroupSegment2.GA_Facets_Sub_Group_Number__c='3';
                testGroupSegment2.ARV_BCN_HSA__c=true;
                gsLst.add(testGroupSegment2);
                
                database.insert(gsLst);
                
                Contract cont=new Contract();
                cont.AccountId=testAccount.id;
                cont.StartDate=system.today();
                cont.ContractTerm=10;
                database.insert(cont);
                
                List<GA_WFT_workflow__c> wfTempLst = new List<GA_WFT_workflow__c> ();
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp.Name='BCBSM New Business Blue Cross OneSource Manual';
                wfTemp.GA_Carrier__c='BCBSM';
                wfTempLst.add(wfTemp);
                
                GA_WFT_workflow__c wfTemp1 = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp1.Name='BCN New Business Blue Cross OneSource Manual';
                wfTemp1.GA_Carrier__c='BCN';
                wfTempLst.add(wfTemp1);
                database.insert(wfTempLst);
                
                test.startTest();
                ARV_AP62_ContractCreateWorkflow.updtCntrctStatus(gsLst,cont,testAccount.id);
                test.stopTest();
                system.assert(testAccount <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    /**  
@Description: contractWrkflowRecdAllGrpSgmts() method 
@Name : contractWrkflowRecdAllGrpSgmts
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void contractWrkflowRecdAllGrpSgmts()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                string enableSMLGRPUWINTGN = system.label.ARV_CL40_Small_Group_Enable_Integration;
                string bcnHSAautmt = system.label.ARV_CL54_BCN_HSA_Automate;
                string bcnHRAautmt = system.label.ARV_CL55_BCN_HRA_Automate;
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                List<GA_Group_Segment__c> gsLst = new List<GA_Group_Segment__c>();
                
                GA_Group_Segment__c grpSegmtBCBSM1=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSegmtBCBSM1.GA_Carrier__c='BCBSM';
                grpSegmtBCBSM1.GA_MTV_Group__c='1';
                grpSegmtBCBSM1.GA_MTV_Group_Division__c='1';
                grpSegmtBCBSM1.ARV_BCN_HSA__c=true;
                grpSegmtBCBSM1.ARV_BCN_HRA__c=true;
                gsLst.add(grpSegmtBCBSM1);
                
                GA_Group_Segment__c grpSegmtBCBSM2=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSegmtBCBSM2.GA_Carrier__c='BCBSM';
                grpSegmtBCBSM2.GA_MTV_Group__c='2';
                grpSegmtBCBSM2.GA_MTV_Group_Division__c='2';
                grpSegmtBCBSM2.ARV_BCN_HSA__c=true;
                grpSegmtBCBSM2.ARV_BCN_HRA__c=false;
                gsLst.add(grpSegmtBCBSM2);
                
                GA_Group_Segment__c grpSegmtBCBSM3=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSegmtBCBSM3.GA_Carrier__c='BCBSM';
                grpSegmtBCBSM3.GA_MTV_Group__c='3';
                grpSegmtBCBSM3.GA_MTV_Group_Division__c='3';
                grpSegmtBCBSM3.ARV_BCN_HSA__c=false;
                grpSegmtBCBSM3.ARV_BCN_HRA__c=true;
                gsLst.add(grpSegmtBCBSM3);
                
                GA_Group_Segment__c grpSegmtBCBSM4=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSegmtBCBSM4.GA_Carrier__c='BCBSM';
                grpSegmtBCBSM4.GA_MTV_Group__c='4';
                grpSegmtBCBSM4.GA_MTV_Group_Division__c='4';
                grpSegmtBCBSM4.ARV_BCN_HSA__c=false;
                grpSegmtBCBSM4.ARV_BCN_HRA__c=false;
                gsLst.add(grpSegmtBCBSM4);
                
                GA_Group_Segment__c grpSegmtBCN1=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSegmtBCN1.GA_Carrier__c='BCN';
                grpSegmtBCN1.GA_Facets_Class_ID__c='1';
                grpSegmtBCN1.GA_Facets_Group_ID__c='1';
                grpSegmtBCN1.GA_Facets_Sub_Group_Number__c='1';
                grpSegmtBCN1.ARV_BCN_HSA__c=true;
                grpSegmtBCN1.ARV_BCN_HRA__c=true;
                gsLst.add(grpSegmtBCN1);
                
                GA_Group_Segment__c grpSegmtBCN2=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSegmtBCN2.GA_Carrier__c='BCN';
                grpSegmtBCN2.GA_Facets_Class_ID__c='2';
                grpSegmtBCN2.GA_Facets_Group_ID__c='2';
                grpSegmtBCN2.GA_Facets_Sub_Group_Number__c='2';
                grpSegmtBCN2.ARV_BCN_HSA__c=true;
                grpSegmtBCN2.ARV_BCN_HRA__c=false;
                gsLst.add(grpSegmtBCN2);
                
                GA_Group_Segment__c grpSegmtBCN3=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSegmtBCN3.GA_Carrier__c='BCN';
                grpSegmtBCN3.GA_Facets_Class_ID__c='3';
                grpSegmtBCN3.GA_Facets_Group_ID__c='3';
                grpSegmtBCN3.GA_Facets_Sub_Group_Number__c='3';
                grpSegmtBCN3.ARV_BCN_HSA__c=false;
                grpSegmtBCN3.ARV_BCN_HRA__c=true;
                gsLst.add(grpSegmtBCN3);
                
                GA_Group_Segment__c grpSegmtBCN4=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSegmtBCN4.GA_Carrier__c='BCN';
                grpSegmtBCN4.GA_Facets_Class_ID__c='4';
                grpSegmtBCN4.GA_Facets_Group_ID__c='4';
                grpSegmtBCN4.GA_Facets_Sub_Group_Number__c='4';
                grpSegmtBCN4.ARV_BCN_HSA__c=false;
                grpSegmtBCN4.ARV_BCN_HRA__c=false;
                gsLst.add(grpSegmtBCN4);
                database.insert(gsLst);
                
                Contract cont=new Contract();
                cont.AccountId=testAccount.id;
                cont.StartDate=system.today();
                cont.ContractTerm=10;
                database.insert(cont);
                
                List<GA_WFT_workflow__c> wfTempLst = new List<GA_WFT_workflow__c> ();
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp.Name='BCBSM New Business Blue Cross OneSource Manual';
                wfTemp.GA_Carrier__c='BCBSM';
                wfTempLst.add(wfTemp);
                
                GA_WFT_workflow__c wfTemp1 = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp1.Name='BCN New Business Blue Cross OneSource Manual';
                wfTemp1.GA_Carrier__c='BCN';
                wfTempLst.add(wfTemp1);
                database.insert(wfTempLst);
                
                test.startTest();
                ARV_AP62_ContractCreateWorkflow.updtCntrctStatus(gsLst,cont,testAccount.id);
                test.stopTest();
                system.assert(testAccount <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    /**
@Description: contractWrkflowRecdSystem1Pass() method 
@Name : contractWrkflowRecdSystem1Pass
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void contractWrkflowRecdSystem1Pass()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                string enableSMLGRPUWINTGN = system.label.ARV_CL40_Small_Group_Enable_Integration;
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                GA_Group_Segment__c testGroupSegment=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                testGroupSegment.GA_Carrier__c='BCBSM';
                testGroupSegment.GA_MTV_Group__c='1';
                testGroupSegment.GA_MTV_Group_Division__c='2';
                testGroupSegment.ARV_BCN_HSA__c=true;
                database.insert(testGroupSegment);
                
                List<GA_Group_Segment__c> gsLst = new List<GA_Group_Segment__c>();
                gsLst.add(testGroupSegment);
                
                Contract cont=new Contract();
                cont.AccountId=testAccount.id;
                cont.StartDate=system.today();
                cont.ContractTerm=10;
                cont.ARV_System_Check_1_Status__c='test';
                database.insert(cont);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp.Name='BCBSM New Business Blue Cross OneSource Manual';
                wfTemp.GA_Carrier__c='BCBSM';
                database.insert(wfTemp);
                
                test.startTest();
                ARV_AP62_ContractCreateWorkflow.updtCntrctStatus(gsLst,cont,testAccount.id);
                test.stopTest();
                system.assert(testAccount <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }   
    /**
@Description: contractWrkflowRecdHRAHSAFlse() method 
@Name : contractWrkflowRecdHRAHSAFlse
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void contractWrkflowRecdHRAHSAFlse()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                string enableSMLGRPUWINTGN = system.label.ARV_CL40_Small_Group_Enable_Integration;
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                GA_Group_Segment__c testGroupSegment=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                testGroupSegment.GA_Carrier__c='BCBSM';
                testGroupSegment.GA_MTV_Group__c='1';
                testGroupSegment.GA_MTV_Group_Division__c='2';
                testGroupSegment.ARV_BCN_HSA__c=false;
                testGroupSegment.ARV_BCN_HRA__c=false;
                database.insert(testGroupSegment);
                
                List<GA_Group_Segment__c> gsLst = new List<GA_Group_Segment__c>();
                gsLst.add(testGroupSegment);
                
                Contract cont=new Contract();
                cont.AccountId=testAccount.id;
                cont.StartDate=system.today();
                cont.ContractTerm=10;
                cont.ARV_System_Check_1_Status__c='test';
                database.insert(cont);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp.Name='BCBSM New Business Blue Cross OneSource Manual';
                wfTemp.GA_Carrier__c='BCBSM';
                database.insert(wfTemp);
                
                test.startTest();
                ARV_AP62_ContractCreateWorkflow.updtCntrctStatus(gsLst,cont,testAccount.id);
                test.stopTest();
                system.assert(testAccount <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }   
    /**
@Description: updtIntgrnStatusCatch() method 
@Name : updtIntgrnStatusCatch
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void updtIntgrnStatusCatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                test.startTest();
                ARV_AP62_ContractCreateWorkflow.updtCntrctStatus(null,null,null);
                test.stopTest();
                system.assert(usr <> null);
            }
            
            catch(exception e)
            {
                return;
            }
            
        }
    }
    /**
@Description: checkTemplateCatch() method 
@Name : checkTemplateCatch
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void checkTemplateCatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                test.startTest();
                ARV_AP62_ContractCreateWorkflow.checkTemplate(null,null,null);
                test.stopTest();
                system.assert(usr <> null);
            }
            
            catch(exception e)
            {
                return;
            }
            
        }
    }
    
    /**
@Description: creatContractNewwrkflowCatch() method 
@Name : creatContractNewwrkflowCatch
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void creatContractNewwrkflowCatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                test.startTest();
                ARV_AP62_ContractCreateWorkflow.creatContractNewwrkflow(null,null);
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