/*****************************************************************************************
Class Name   : ARV_AP13_SBCDocGenClass 
Date Created : 16-MAY-2019
Created By   : IDC Offshore
Description  : This  class is called from ARV_AP12_QueueableServices to call SBC services.
******************************************************************************************/
public without sharing class ARV_AP13_SBCServiceDocGen { 
    private static final String BLANKVAL='';
    private static final string CLSNAME  ='ARV_AP03_SBCServiceCls';
    private static final string METHODNAME  ='getSBCDoc';
    private static final String EXCEPSEPRATR=': ';
    private static final String ERRORMSG='Unable to retrieve SBC Document';
    
    /**************  
    Method name : getSBCDoc
    Params     : NA
    Return Type : Attachment
    Description :This method is used to call ARV_AP15_CallOutUtils webservices.
    *************/ 
    public ContentDocumentLink getSBCDoc(id prdId,id accId,Id quoteId,string carrierType){
        ARV_AP15_CallOutUtils.ResponseWrapper rwp = new ARV_AP15_CallOutUtils.ResponseWrapper(); 
        try{
             rwp = ARV_AP15_CallOutUtils.callSBCService(accId,prdId,BLANKVAL,quoteId,null,carrierType,null,null);
        }  
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPRATR+e.getMessage());
        }
        return rwp.attachRecord;
    }
}