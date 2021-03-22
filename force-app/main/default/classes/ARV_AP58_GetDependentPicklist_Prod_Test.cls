/*****************************************************************************************
Class Name   : ARV_AP58_GetDependentPicklist_Prod_Test
Date Created : 22-JAN-2020
Created By   : IDC Offshore
Description  : This class is used provide test coverage...
******************************************************************************************/
@isTest(SeeAllData=FALSE)
public class ARV_AP58_GetDependentPicklist_Prod_Test {
private static final string ADMINPROFILE='System Administrator';
private static final string NAME='Test User';
private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string METHODNAME ='getDependentValPicklist2';
  /**************  
    Method name : testBooleanController
    Params     : NA
    Return Type : testmethod
    Description :  This method is used for call invokeMethod method pass Testing.
    *************/     
 private static testmethod void testBooleanController()
    {       
            //Create Admin User
            user usr = ARV_AP05_TestDataCreation.UsrRec(ADMINPROFILE);
            usr.LastName = Name;
            usr.Username=USERNAME;
            database.insert(usr,true);
		 system.runAs(usr)
        {
            map<string,object> inputMap = new map<string,object>();       
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
       		ARV_AP58_GetDependentPicklist_ProdFamily dePiclist = new ARV_AP58_GetDependentPicklist_ProdFamily();
            Test.startTest();        	
                dePiclist.invokeMethod(METHODNAME,inputMap,outMap,options);
            Test.stopTest();
		}
    }
 
}