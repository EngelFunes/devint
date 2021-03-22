/*****************************************************************************************
Class Name   : ARV_GWCTrigger_Test. 
Date Created : 25-FEB-2021
Created By   : IDC Offshore
Description  :This class is to test GWC Transaction Table trigger.
******************************************************************************************/

@isTest(seealldata=false)
public class ARV_GWCTrigger_Test {
    private static final string CntrctName='testcntrct';
    private static final string NAME2='AP33RateGrid';
    private static final string PROFILENAME1='Retention Sales';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    
        
    @istest static void transactiontable(){
         Account acc=ARV_AP05_TestDataCreation.accRec();
         database.insert(acc);
         Contract cntrct=new Contract(AccountId=acc.id,name=CntrctName,
                                             ARV_Tech_SystemCheck2__c='Remove Dental,Add Common Control',ARV_Requested_Effective_Date__c=system.Today()+90,
                                             Status='In Progress');
         database.insert(cntrct);  
         ARV_GWC_Transaction_Table__c gwc= new ARV_GWC_Transaction_Table__c(Account_ID__c=acc.id,Contract__c=cntrct.id,Status__c='In Progress',RatingAreaFlag__c=true, Is_common_control__c = true);
         database.insert(gwc);  
         gwc.Status__c='Approval Process - Approved';
         database.update(gwc);
         gwc.Status__c='Completed';
         database.update(gwc);
         user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
         usr.LastName = NAME2;
         usr.Username=USERNAME;
         database.insert(usr,true);        
    }
}