@isTest(seealldata=false)
 /*****************************************************************************************
    Method Name : invokeMethod. 
    Date Created : 11-FEB-2021
    Created By   : IDC Offshore
    Description  :This is the class for deleting System census members whose end date is less than contract start date
    *******************************************************************************************/
public class ARV_AP106_DeleteSystemCensusMembers_Test {
     public static testMethod  void invokeMethodtest() { 
         Map<String, Object> inputMap=new Map < String, Object >();
         Map < String, Object > outMap=new Map < String, Object >();
          Map < String, Object > options=new Map < String, Object >();
         options.put('contractId','test');
         options.put('censusId','test');
         String methodName='deleteCensusMembers';
         ARV_AP106_DeleteSystemCensusMembers arv_ap106=new  ARV_AP106_DeleteSystemCensusMembers();
         arv_ap106.invokeMethod(methodName,inputMap,outMap,options);
     }
}