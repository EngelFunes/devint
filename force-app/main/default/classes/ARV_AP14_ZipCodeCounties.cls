/*********************************************************************************************************
Class Name   : ARV_AP14_ZipCodeCounties
Date Created : 01-APr-2019
Created By   : IDC Offshore
Description  : This is 	used for fetching Counties when user enters Zipcode in Quotimg Omniscript.
               It is Used in ins-os-Zipcode-template.
************************************************************************************************************/
global without sharing class ARV_AP14_ZipCodeCounties implements vlocity_ins.VlocityOpenInterface2 {
	private static final String GETCOUNTYMTHD = 'fetchCounty';
	private static final String ZIPCODEVAR= 'zipcode';
	private static final String SELECTQRY= 'SELECT ZipCode__c, CountyNameFormula__c, CountyName__r.Name FROM ZipCode__c';
	private static final String WHERECLAUSE=' WHERE ZipCode__c =:paramName1 ';
	private static final String ORDERCLAUSE=' ORDER BY ZipCode__c';
	private static final String LIMITCLAUSE=' LIMIT 100';
	private static final String COUNTYNAMES='CountyNames';	
/************************************************************************************************************
Method Name   : invokeMethod
Parameters	 : String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options
Date Created : 01-APr-2019
Created By   : IDC Offshore
Description  : It invokes the All methods.
************************************************************************************************************/
   global Boolean invokeMethod(String methodName,Map<String,Object>inputMap,Map<String,Object>outMap,Map<String,Object>options){
        Boolean result = true;
       try{
           if (GETCOUNTYMTHD.equals(methodName)) {
            fetchCounty(inputMap, outMap, options);
        	}
          }
       catch(Exception ex){
           throw ex;
       }
        return result;
   }
/************************************************************************************************************
Method Name   : getcounty
Parameters	 : String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options
Date Created : 01-APr-2019
Created By   : IDC Offshore
Description  : It fethes the Counties when user enters the zipcode .
************************************************************************************************************/
    private static void fetchCounty(Map<String,Object>inputMap,Map<String,Object>outMap,Map<String,Object>options){
        List < String > countylist = New List < string > ();
        string zipcode = (string)inputMap.get(ZIPCODEVAR);
		ARV_AP07_QueryDataHelper.paramName1 =zipcode;
        List < ZipCode__c > county = ARV_AP07_QueryDataHelper.getsObjects(SELECTQRY,WHERECLAUSE,ORDERCLAUSE,LIMITCLAUSE);
        if(county.size()>0){
        for (ZipCode__c str: county){
            countylist.add(str.CountyNameFormula__c); 
        }
		outMap.put(COUNTYNAMES, countylist);
        }     
    }
        
}