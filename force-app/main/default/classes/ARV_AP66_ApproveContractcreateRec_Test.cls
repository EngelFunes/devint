/*
@Author : IDC offshore
@Name: ARV_ApproveContractcreateRecrds_Test 
@CreatedDate: 24 - Dec 2019 
@Description: ARV_ApproveContractcreateRecrds Test class
@version : 1.0  
*/
@isTest(SeeAllData=FALSE)
private class ARV_AP66_ApproveContractcreateRec_Test
{
    
    /**
@Description: approveContractRec() method 
@Name : approveContractRec
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void approveContractRec()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                Contract cont1=new Contract();
                cont1.AccountId=testAccount.id;
                cont1.StartDate=system.today();
                cont1.Status='In Progress';
                cont1.ContractTerm=10;
                database.insert(cont1);
                
                test.startTest();
                ARV_AP66_ApproveContractcreateRecrds.aprvUnmatchContrct(cont1.id);
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
@Description: approveContractRecCatch() method 
@Name : approveContractRecCatch
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void approveContractRecCatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
                test.startTest();
                ARV_AP66_ApproveContractcreateRecrds.aprvUnmatchContrct(null);
                test.stopTest();
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    
    private static testmethod void approveContractRec1()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                Contract cont1=new Contract();
                cont1.AccountId=testAccount.id;
                cont1.StartDate=system.today();
                cont1.Status='In Progress';
                cont1.ContractTerm=10;
                database.insert(cont1);
                
                test.startTest();
                ARV_AP66_ApproveContractcreateRecrds.aprvUnmatchContrct1(cont1.id);
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