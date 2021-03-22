@isTest(seealldata=false)
/***********************************************************************************************************
*Class Name   : ARV_AP14_ZipCodeCounties_Test 
*Date Created : 18-August-2019
*Created By   : IDC Offshore
*Description  : It is test class for ARV_AP14_ZipCodeCounties
***********************************************************************************************************/
public class ARV_AP14_ZipCodeCounties_Test {
	private static final string SYSADMIN='System Administrator';
 	private static final string ZIPCODE='zipcode';
    private static final string ZIPVAL='10001';
    private static final string MTHDNAME='fetchCounty';  
/***********************************************************************************************************
**Method Name   :complQuotesExcepTest()
*Date Created : 18-August-2019
*Created By   : IDC Offshore
*Description  : this method Covers the testClass Coverage.
***********************************************************************************************************/    
    private static testmethod void testMethod1(){
      user usr = ARV_AP05_TestDataCreation.UsrRec(SYSADMIN);
      Database.insert(usr);
      List < GA_County_Code__c > countyrec = ARV_AP05_TestDataCreation.createCounties(5);
      Database.insert(countyrec);
      List < Zipcode__c > ziprec = ARV_AP05_TestDataCreation.createZiprec(countyrec);
      Database.insert(ziprec);
      system.runAs(usr) {
            ARV_AP14_ZipCodeCounties zipCounty=new ARV_AP14_ZipCodeCounties();
            Map <String, Object >inputMap = new Map <String, Object > ();
            Map <String, Object >outMap = new Map <String, Object > ();
            Map <String, Object >options = new Map <String, Object > ();
            inputMap.put(ZIPCODE,ZIPVAL);
            Test.startTest();
            zipCounty.invokeMethod(MTHDNAME, inputMap, outMap, options);
            Test.stopTest();
            system.assertEquals(true,outMap.size()>0);
        }

    }

}