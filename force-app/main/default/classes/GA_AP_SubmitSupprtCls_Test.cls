/**
@Author : Prasant K Satpathy
@Name: GA_AP_SubmitSupprtCls_Test 
@CreatedDate: 28 - Dec 2017 
@Description: GA_AP_SubmitSupprtCls Test class 
@version : 1.0  
*/
@isTest
public class GA_AP_SubmitSupprtCls_Test {
    /*******************************************************************************************************************************
@Description        :   submittoSupprt() method 
@Name               :   submittoSupprt
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static testmethod void submittoSupprt()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr)
        {
            try{
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                database.insert(cas);
                GA_Trigger_Functionality_By_Pass__c bypssErr=new GA_Trigger_Functionality_By_Pass__c();
                bypssErr.GA_Support_Request_Alert__c=true;
                database.insert(bypssErr);
                string supprtId=cas.Id;
                test.startTest();
                GA_AP_SubmitSupprtCls.updateSupprt(supprtId);
                GA_AP_SubmitSupprtCls.ShowAlrt();
                test.stopTest();
            }
            catch(exception ex)
            {
                return;
            }
        }
    }
        /*******************************************************************************************************************************
@Description        :   submittoSupprtExcp() method 
@Name               :   submittoSupprtExcp
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static testmethod void submittoSupprtExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr)
        {
            try{
                
                GA_Trigger_Functionality_By_Pass__c bypssErr=new GA_Trigger_Functionality_By_Pass__c();
                bypssErr.GA_Support_Request_Alert__c=false;
                database.insert(bypssErr);
                string supprtId='';
                test.startTest();
                GA_AP_SubmitSupprtCls.ShowAlrt();
                GA_AP_SubmitSupprtCls.updateSupprt(supprtId);
                test.stopTest();
                
            }
            catch(exception ex)
            {
                return;
            }
        }
    }
}