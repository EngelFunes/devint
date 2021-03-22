/*****************************************************************************************
Class Name   : ARV_AP09_BAAGServiceDocGen 
Date Created : 03-MAY-2019
Created By   : IDC Offshore
Description  : This  class is called from ARV_AP18_BAAGQueueableServices to call BAAG services.
******************************************************************************************/
public without sharing class ARV_AP09_BAAGServiceDocGen {
     private static final string CLASSNAME ='ARV_AP09_BAAGServiceDocGen';
     private static final string METHODNAME  ='getBAAGDoc';
     private static final String BLANKVAL='';
    /**************  
    Method name : getBAAGDoc
    Params     : NA
    Return Type : attachment
    Description :This method is used to call webservices Class ARV_AP16_BAAGCallOutUtils.
    *************/
    public  ContentDocumentLink getBAAGDoc(String prdId,id quoteId,boolean checkBCBS){  
        try{
            ARV_AP16_BAAGCallOutUtils.ResponseWrapper rwp =  new ARV_AP16_BAAGCallOutUtils.ResponseWrapper();  
            rwp = ARV_AP16_BAAGCallOutUtils.callBAAGService(prdId,BLANKVAL,quoteId,checkBCBS);
            return rwp.attachRecord;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME);
            throw new AuraHandledException(e.getMessage()); 
        }
        
    }
   
}