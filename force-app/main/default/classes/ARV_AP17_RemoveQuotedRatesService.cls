/*****************************************************************************************
Class Name   : ARV_AP17_RemoveQuotedRatesService 
Date Created : 21-July-2019
Created By   : Onshore
Description  : Used to clear out / delete what's deselected in the cart
******************************************************************************************/
global with sharing class ARV_AP17_RemoveQuotedRatesService implements vlocity_ins.VlocityOpenInterface2 
{    
    private static final string LIMIT_CLAUSE='  limit 5000 ';    
    private static final string QUOTELNBRKOUT_QUERY= 'SELECT Id from vlocity_ins__QuoteLineItemRateBreakout__c  ';
    private static final string QUOTELNBRKOUT_WHERE_CLAUSE=' where vlocity_ins__QuoteId__c = :paramName  ';    
    private static final string TEST='test';    
    private static final string DELETED='Deleted';    
    private static final string QUOTEID='quoteId'; 
    private static final string CLSNAME  = 'ARV_AP17_RemoveQuotedRatesService';    
    private static final string INVOKE_METHOD  = 'invokeMethod';    
    private static final String ERRORMSG=  'There was an issue processing quotelineItems to delete';											
    /*****************************************************************************************    
    Date Modified : 3rd-october-2019
    Created By   : Offshore
    Method Name  : Invoke method
	Description  : to call the deleteQLPB method
    ******************************************************************************************/
    global  Boolean  invokeMethod(String methodName, Map < String, Object > inputMap,Map < String, Object > outMap,
                                        Map < String, Object > options) {
        
        try{
            deleteQLPB(inputMap,outMap,options);
           }
        catch(Exception e){
           //GA_LogExceptionCls.LogExcp(e, CLSNAME, INVOKE_METHOD  );
		   throw e;	   
        }
        return true;     
    }
    /*****************************************************************************************    
    Date Modified : 3rd-october-2019
    Created By   : Offshore
    Method Name  : deleteQLPB method
    Description  :  To delete the quoteline items
    ******************************************************************************************/
    public static  Boolean deleteQLPB(Map < String, Object > inputMap,Map < String, Object > outMap,
                                      Map < String, Object > options) {
        try{
        String thisQuoteID = (String)inputMap.get(QUOTEID);        
        ARV_AP07_QueryDataHelper.paramName=thisQuoteID;
        List <vlocity_ins__QuoteLineItemRateBreakout__c> quoteRateList =ARV_AP07_QueryDataHelper.getsObjects(QUOTELNBRKOUT_QUERY,
                                                                                  QUOTELNBRKOUT_WHERE_CLAUSE,null, LIMIT_CLAUSE );         
        ARV_AP08_DMLHelper.insertSObjects(quoteRateList,ARV_AP41_StringLiteralUtils.TYPEDELETE,
                                          ARV_AP41_StringLiteralUtils.TRUE_VALUE);
        outMap.put(TEST,DELETED); 
        }
        catch(Exception e){
           //GA_LogExceptionCls.LogExcp(e, CLSNAME, INVOKE_METHOD  );
		   throw e; 
		    
        }
        return true;
    }   
}