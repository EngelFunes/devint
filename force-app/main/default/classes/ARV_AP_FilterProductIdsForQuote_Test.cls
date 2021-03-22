@IsTest
public class ARV_AP_FilterProductIdsForQuote_Test {

    private static testmethod void testprdfilter(){
    user usr = ARV_AP05_TestDataCreation.UsrRec('System Administrator');
      Database.insert(usr);
    Product2 sisProd= ARV_AP05_TestDataCreation.productRec();
        Date startDate = Date.parse('12/31/2021');
      sisProd.vlocity_ins__EndDate__c =startDate;
     database.insert(sisProd,true);
        String jsonResponse = '[' +
                                 '{' +
                                   '"Productid":"'+sisProd.Id+'"' +
                                 '}]' ;
       List<Object> results = (List<Object>)JSON.deserializeUntyped(jsonResponse);
        system.runAs(usr) {
        test.startTest();
               ARV_AP_FilterProductIdsForQuote prdcls=new ARV_AP_FilterProductIdsForQuote();
                Map <String, Object >inputMap = new Map <String, Object > ();
                Map <String, Object >outMap = new Map <String, Object > ();
                Map <String, Object >options = new Map <String, Object > ();
              inputMap.put('Lineitems',results);
              inputMap.put('RenewalEffDateFormat','2021-01-01');
              prdcls.invokeMethod('getfilterProdids', inputMap,outMap,options);
         test.stopTest();
        }   
    }
        
}