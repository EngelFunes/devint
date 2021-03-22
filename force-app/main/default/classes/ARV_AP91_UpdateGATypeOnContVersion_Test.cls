@isTest(SeeAllData=false)
/***********************************************************************************************************
*Class Name   : ARV_AP91_UpdateGATypeOnContVersion_Test 
*Date Created : 27-Mar-2019
*Created By   : IDC Offshore
*Description  : It is test class for ARV_AP91_UpdateGATypeOnContVersion
***********************************************************************************************************/
public class ARV_AP91_UpdateGATypeOnContVersion_Test {
 	private static final string SYSADMIN='System Administrator';
 	private static final string USRLSTNAME='GATypeUser';
    private static final string FILE_TITLE='MLR-Agreement.pdf';
    private static final string MAIN_MTHD='updateGATypeonfile';
    private static final string CONTXTID='ContextId';
    private static final string MLR_RATIO='%Medical%';
/*********************************************************************************  
	Method name : testDataSetup
	Params     : NA
	Return Type : testmethod
	Description :  testDataSetup() method 
************************************************************************/     
    @testSetup static void testDataSetup(){
        user usr = ARV_AP05_TestDataCreation.UsrRec(SYSADMIN);
            usr.LastName=USRLSTNAME;
        	database.insert(usr); 
        Account act= ARV_AP05_TestDataCreation.accRec();
        	database.insert(act); 
   		contract contr=ARV_AP05_TestDataCreation.createContractRec(act.Id);
        	database.insert(contr);
        ContentVersion conVion1=ARV_AP05_TestDataCreation.contenntversinRec(FILE_TITLE);
        	database.insert(conVion1);       
        ContentDocument condoc=[Select Id,parentid from ContentDocument where Parentid=:conVion1.ContentDocumentId];
        ContentDocumentLink cdl=ARV_AP05_TestDataCreation.contentDocLink(condoc.Id,contr.Id );
        	database.insert(cdl);
    }
/***********************************************************************************************************
**Method Name   :updateGatypeonCvTest()
*Date Created : 27-Mar-2019
*Created By   : IDC Offshore
*Description  : this method Covers the testClass Coverage.
***********************************************************************************************************/ 
    private static testmethod void updateGatypeonCvTest(){
             User usr1 = [SELECT Id from User where LastName =:USRLSTNAME limit 1];
             Contract contrtRec=[SELECT Id from Contract limit 1];
        	 ContentVersion conver=[SELECT Id,GA_Type__c from ContentVersion limit 1];
        system.runAs(usr1){
           ARV_AP91_UpdateGATypeOnContVersion updatefile = New ARV_AP91_UpdateGATypeOnContVersion();
            Map <String, Object >options = new Map <String, Object > ();
            Map <String, Object >output = new Map <String, Object > ();
         	options.put(CONTXTID,contrtRec.Id);
            Test.startTest();
            	updatefile.invokeMethod(MAIN_MTHD,null,output,options);
            Test.stopTest();
		System.assertEquals(1,[select count() from ContentVersion where id=:conver.id and GA_Type__c Like:MLR_RATIO]);
        }
        
    }
/***********************************************************************************************************
**Method Name   :updateGatypeonCvExcepTest()
*Date Created : 27-Mar-2019
*Created By   : IDC Offshore
*Description  : this method Covers the Exception.
***********************************************************************************************************/ 
    private static testmethod void updateGatypeonCvExcepTest(){
            user usr1 = [SELECT Id from User where LastName =:USRLSTNAME limit 1];
            Contract contrtRec=[SELECT Id from Contract limit 1];
        	ContentVersion conver=[SELECT Id from ContentVersion limit 1];
        System.runAs(usr1){
           ARV_AP91_UpdateGATypeOnContVersion updatefile = New ARV_AP91_UpdateGATypeOnContVersion();
            Map <String, Object >options = new Map <String,Object > ();
            Map <String, Object >output = new Map <String,Object > ();
         	options.put('ContextId',contrtRec.Id);
            Test.startTest();
            	updatefile.invokeMethod(MAIN_MTHD,null,null,null);
            Test.stopTest();
		System.assertEquals(0,[select count() from ContentVersion where id=:conver.id and GA_Type__c Like:MLR_RATIO]);
        }      
    } 
}