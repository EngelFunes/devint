/*****************************************************************************************
Class Name   : ARV_AP_UpdateContractSatusforRenewals 
Date Created : 17-Jan-2020
Created By   : IDC Offshore
Description  : This class is used for validate contract records
******************************************************************************************/
@isTest(SeeAllData=false)
public class ARV_AP_UpdateContractSatusRenwals_Test {
  private static final string PROFILENAME1='System Administrator';
  private static final string NAME1='apupdateConRenStat';
  private static final string USERNAME='bcbsm1@bcbsm.com';
  private static final string ACT='Active';
  private static final string SGRR='SG';
  private static final string STATFUTURE='Future';
  private static final string CONNAME='Renewal';
  private static final string STATCOMP='Completed';
  private static final String COMPLETED='Completed';
  private static final String ACTIVATED='Activated'; 
  private static final String MTHDNAME ='updateFutureConStatus';
/*********************************************************************************************************
@Description: testDataSetup() method 
@Name : testDataSetup1
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
     @testSetup static void testDataSetup(){
       Account acc= ARV_AP05_TestDataCreation.accRec();
        acc.Account_Status__c=ACT;
        acc.ARV_Renewal_Account_Type__c=SGRR;
        acc.GA_Opportunity_Renewal_Date__c=system.today();
        if(Account.SObjectType.getDescribe().isAccessible()){database.insert(acc); }
        contract cont= ARV_AP05_TestDataCreation.createContractRec(acc.Id);        
        if(contract.SObjectType.getDescribe().isAccessible()){database.insert(cont); }  
        Contract con21 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        if(contract.SObjectType.getDescribe().isAccessible()){database.insert(con21);}
        con21.Name=STATFUTURE;
        con21.Status=STATFUTURE;
        if(contract.SObjectType.getDescribe().isAccessible()){database.update(con21); }
		contract cont3= ARV_AP05_TestDataCreation.createContractRec(acc.Id);        
        if(contract.SObjectType.getDescribe().isAccessible()){database.insert(cont3); }  
		 cont3.Name=STATFUTURE;
         cont3.Status=STATFUTURE;
        cont3.vlocity_ins__ExpiredContractId__c=con21.Id;
		if(contract.SObjectType.getDescribe().isAccessible()){database.update(cont3); }
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        if(user.SObjectType.getDescribe().isAccessible()){database.insert(usr,true);}
        cont.status=ACTIVATED;
        cont.ARV_Renewal_Status__c=COMPLETED;
        cont.Name=CONNAME;
        cont.vlocity_ins__ExpiredContractId__c=con21.Id;
        if(contract.SObjectType.getDescribe().isAccessible()){database.update(cont);}
     }
    /**************  
Method name : updateRenConStatusTest
Params     : NA
Return Type : testmethod
*************/ 
	private static testmethod void updateRenConStatusTest(){
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
       Contract con=[SELECT Id from contract where vlocity_ins__ExpiredContractId__c  !=null limit 1];
       Contract con2=[SELECT Id from contract where Status='Cancelled' limit 1];
		system.runAs(usr1){
			ARV_AP_UpdateContractSatusforRenewals updatestatus=new ARV_AP_UpdateContractSatusforRenewals();
            Map <String, Object >inputMap = new Map <String, Object > ();
            Map <String, Object >outMap = new Map <String, Object > ();
            Map <String, Object >options = new Map <String, Object > (); 
			options.put('previousConId',con.Id);
			options.put('generatedConId',con2.Id);
         test.startTest();
		 updatestatus.invokeMethod(MTHDNAME,inputMap,outMap,options);
		 test.stopTest();
		}
	}
}