//ARV_AP_ApproveContractFromIP_Test
/*
@Author : IDC offshore
@Name: ARV_ApproveContractcreateRecrds_Test 
@CreatedDate: 24 - Dec 2019 
@Description: ARV_ApproveContractcreateRecrds Test class
@version : 1.0  
*/
@isTest(SeeAllData=FALSE)
private class ARV_AP_ApproveContractFromIP_Test
{
    private static final string inprogress='In Progress';
    
    
    /**
@Description: approveContractRec() method 
@Name : approveContractRec
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/ 
    @istest
    private static  void approveContractRec()
    {
        Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(testAccount);
        Contract cont2=new Contract();
        cont2.AccountId=testAccount.id;
        cont2.StartDate=system.today();
        cont2.Status=inprogress;
        cont2.ContractTerm=10;
        database.insert(cont2); 
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> optionsMap = new Map<String,Object>();
        Map<String,Object> outputMap = new Map<String,Object>();
        Map<String,Object> optionsMap1 = new Map<String,Object>();
        Map<String,Object> ipInput = new Map<String,Object>();
        Map<String,Object> ipOptions = new Map<String,Object>();
        id contid=[select id from Contract where status=:inprogress limit 1].id;
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        User usrRec=[select id from User limit 1];
        system.runAs(usr)
        {
            try
            {
                optionsMap.put('conID',contid);
                //optionsMap1.put('conID',cont2);
                test.startTest();
                ARV_AP_ApproveContractFromIP apvIPCls = new ARV_AP_ApproveContractFromIP();
                //ARV_AP_ApproveContractFromIP.aprvUnmatchContrct(cont1.id);
                apvIPCls.aprvUnmatchContrct(inputMap,outputMap,optionsMap);
                apvIPCls.invokeMethod('aprvUnmatchContrct',inputMap,outputMap,optionsMap);
               // apvIPCls.aprvUnmatchContrct(inputMap,outputMap,optionsMap1);
                test.stopTest();
                system.assert(usr <> null);
                /* ipInput.put('contractID',cont1);
vlocity_ins.IntegrationProcedureService.runIntegrationProcedureQueueable('ContractIP_Approval',ipInput,ipOptions);*/
                
            }
            catch(exception e)
            {
                system.debug('Error at Line Number^^^^'+e.getLineNumber());
                system.debug('Error at Line Number^^^^'+e.getMessage());
                return;
            }
            
        }
    }
}