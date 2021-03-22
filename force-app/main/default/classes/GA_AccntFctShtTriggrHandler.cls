/**
@Author : Prasant Kumar Satpathy
@Name: GA_AccntFctShtTrgrCls
@CreatedDate:  3- Jan 2018 
@Description: GA_AccntFctShtTriggrHandler handler class is for updating Account Factsheet information based on associated Contact Name
@version : 1.0  
*/
public with sharing class GA_AccntFctShtTriggrHandler {
public static final string ErrorMsg = 'Unable to create or update Account Factsheet record';
public static final string ClsName  ='GA_AccntFctShtTriggrHandler';
public static final string methodNme  ='beforeupdate';
public static final string methodNmeInsrt  ='beforeInsert';
public static final GA_Profile_ByPass__c profBypass = GA_Profile_ByPass__c.getInstance();
/**
@Description: beforeInsert() method 
@Name : beforeInsert
@Param : list<GA_Account_Fact_Sheet__c> actFcshtLst,map<id,GA_Account_Fact_Sheet__c> actFcshtNewmap 
@Return : void
@throws Exception : N/A;
*/
public static void beforeInsert(list<GA_Account_Fact_Sheet__c> actFcshtLst,map<id,GA_Account_Fact_Sheet__c> actFcshtNewmap)
{
try
{   
    if(!profBypass.Bypass__c){
    if(!GA_AccntFctShtTrgrCls.isExecuting)
    {
        GA_AccntFctShtTrgrCls.prepopulateFactsht(actFcshtLst,null);
        GA_AccntFctShtTrgrCls.isExecuting=true;
    }  
}
 
}
catch(exception e)
{
    GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeInsrt);
    actFcshtLst[0].adderror(ErrorMsg);
}

}

/**
@Description: beforeupdate() method 
@Name : beforeupdate
@Param : list<GA_Account_Fact_Sheet__c> actFcshtLst,map<id,GA_Account_Fact_Sheet__c> actFcshtOldmap 
@Return : void
@throws Exception : N/A;
*/
public static void beforeupdate(list<GA_Account_Fact_Sheet__c> actFcshtLst,map<id,GA_Account_Fact_Sheet__c> actFcshtOldmap)
{
try
{   
    if(!profBypass.Bypass__c){
        if(!GA_AccntFctShtTrgrCls.isExecuting)
        {
            GA_AccntFctShtTrgrCls.prepopulateFactsht(actFcshtLst,actFcshtOldmap);
            GA_AccntFctShtTrgrCls.isExecuting=true;
        }  
        
    }
    
}
catch(exception e)
{
    GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
    actFcshtLst[0].adderror(ErrorMsg);
}


}
}