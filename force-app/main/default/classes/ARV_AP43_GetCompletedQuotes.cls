/********************************************************************************************
Class Name   : ARV_AP43_GetCompletedQuotes 
Date Created : 05-Augst-2019
Created By   : IDC Offshore
Description  : This is 	ARV_LTNG18_GetCompletedQuotes Controller.
************************************************************************************************************/
public without sharing class ARV_AP43_GetCompletedQuotes {
 // declaring variables.
 	private static final string SELECTQRY =System.label.ARV_CL26_QUOTEQUERY;	
 	private static final string ACTIVE ='Active';
    private static final Boolean ERRORCHECK =True;
 	private static final string WHERECLAUSE =' Where AccountId=:paramId1 AND Tech_QuoteStatus__c=:paramName1';
 	private static final string LIMITCLAUSE =' Limit 100';
    private static final string CLASSNAME ='ARV_AP43_GetCompletedQuotes';
    private static final string METHODNAME ='getCompletedQuotes';
    private static final string TXSELECTQRY ='select Name,ARV_Message__c,ARV_Type__c,ARV_Status__c,Error__c,'
       										 +'ARV_Contract__c from TX__c';
    private static final string TXWHERECLAUSE =' Where ARV_Contract__c=:paramId1 AND Error__c=:paramName4';
/**************************************************************************************************************
Method Name  : getCompletedQuotes 
Date Created : 05-Augst-2019
Created By   : IDC Offshore
Description  : It will take the account id as input and return Quote Fields list.
***************************************************************************************************************/
	@AuraEnabled
    public static List<Quote> getCompletedQuotes(String accId){
          List <Quote>quoteList=New List <Quote>();
            ARV_AP07_QueryDataHelper.paramId1 = accId;
            ARV_AP07_QueryDataHelper.paramName1 = ACTIVE;
        try{ 
              quoteList = ARV_AP07_QueryDataHelper.getsObjects(SELECTQRY,WHERECLAUSE,null,LIMITCLAUSE); 
		
        }   
        catch(Exception ex){throw new AuraHandledException(ex.getMessage());}
        return quoteList; 
    } 
/**************************************************************************************************************
Method Name  : getTXrecords 
Date Created : 04-June-2020
Created By   : IDC Offshore
Description  : It will take the contract id as input and return TX records list.
***************************************************************************************************************/
    @AuraEnabled
    public static List<TX__c> getTXRecords(String conId){
          List <TX__c> txList=New List <TX__c>();
            ARV_AP07_QueryDataHelper.paramId1 = conId;
            ARV_AP07_QueryDataHelper.paramName4 = ERRORCHECK;
        
        try{ 
                txList = ARV_AP07_QueryDataHelper.getsObjects(TXSELECTQRY,TXWHERECLAUSE,null,LIMITCLAUSE); 
			    
        }
        
        catch(Exception ex){throw new AuraHandledException(ex.getMessage());}
            
        return txList; 
    }
}