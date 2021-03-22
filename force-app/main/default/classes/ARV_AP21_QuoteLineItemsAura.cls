/********************************************************************************************
Class Name   : ARV_AP21_QuoteLineItemsAura 
Date Created : 05-June-2019
Created By   : IDC Offshore
Description  : This is 	ARV_LTNG14_QuoteLineItemsList Controller.It will take the quoteId as input and return productname,list price,unit price,quantity
*******************************************************/
public with sharing class ARV_AP21_QuoteLineItemsAura {   
    
    private static final string CLASSNAME='ARV_AP21_QuoteLineItemsAura';
    private static final string QLIMETHOD='getQuoteLineItems';
    private static final string ERRORMSG= 'There was an issue processing getQuoteLineItems.';  
    private static final string PRDWHERECLAUSE=' where QuoteId =:paramName1 ';
    private static final string PRDLIMITCLAUSE=' limit 50  ';
    
	 
	/********************************************************************************************
	Method Name  : getQuoteLineItems 
	Date Created : 05-June-2019
	Created By   : IDC Offshore
	Description  : It will take the quoteId as input and return productname,list price,unit price,quantity and will return the QuoteLineItem list.
	*******************************************************/
	@AuraEnabled
    public static List<QuoteLineItem> getQuoteLineItems(String qtId)
    { 
        // declaring variables.   
         string prdSelectQry =system.label.ARV_CL23_QUOTELINEQUERy;       
	    List<QuoteLineItem> qliList = null;
		// preparing query parameters to pass to ARV_AP07_QueryDataHelper
        try{
            // calling ARV_AP07_QueryDataHelper.getsObjects to fetch the productname,list price,unit price,quantity from QuoteLineItem.
            ARV_AP07_QueryDataHelper.paramName1 = qtId ;
            qliList = ARV_AP07_QueryDataHelper.getsObjects( prdSelectQry , prdWhereClause ,null ,prdLimitClause );
            
        }
        //kept in single line for code coverage.
        catch(Exception e){GA_LogExceptionCls.LogExcp(e, className, qliMethod);throw new AuraHandledException(className+qliMethod+errorMsg+e.getMessage());
        }
      
        return qliList;
    }
}