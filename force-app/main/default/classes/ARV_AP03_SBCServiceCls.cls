/*****************************************************************************************
Class Name   : ARV_AP03_SBCServiceCls 
Date Created : 3-MAY-2019
Created By   : IDC Offshore
Description  : This  class is used for getting SBC document from external systems on Compare Modal Screen.
******************************************************************************************/
public without sharing class ARV_AP03_SBCServiceCls {
    
    private static final string MYACCOUNTID='accId';
    private static final string MYPRODUCTID='pId';   
    private static final string CLSNAME  ='ARV_AP03_SBCServiceCls';
    private static final string METHODNAME  ='getSBCDoc';
    private static final String EXCEPSEPRATR=': ';
    private static final String ERRORMSG='Unable to retrieve SBC Document';
    public static final String TYPE='card';
    private static final String BLANKVAL='';
    /**************  
    Method name : getSBCDoc
    Params      : String accountId,String productId,string opportunityId,string carierType,string effectiveDate
    Return Type : ARV_AP15_CallOutUtils.ResponseWrapper
    Description :This method is used to call webservices class to send request to server.
    *************/
    @AuraEnabled 
    public static ARV_AP15_CallOutUtils.ResponseWrapper getSBCDoc(String accId,String prdId,string oppId,string carType,string effDate,string pediatricPlan){
        Id accountId=null;
        Id productId=null;
        Id opportunityId=null;
        string carrierType=null;
        Date effectiveDate=system.today();
        string pediatricVal=null;
        ARV_AP15_CallOutUtils.ResponseWrapper rwp =  new ARV_AP15_CallOutUtils.ResponseWrapper();
        try{
            accountId = id.valueof(accId);
            productId = id.valueof(prdId);  
            opportunityId= id.valueOf(oppId);
            carrierType=carType;
            effectiveDate=date.valueof(effDate);
            pediatricVal=pediatricPlan;
            rwp = ARV_AP15_CallOutUtils.callSBCService(accountId,productId,TYPE,BLANKVAL,opportunityId,carrierType,effectiveDate,pediatricVal);
        }  
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPRATR+e.getMessage());
        }
        return rwp;
    }
    
}