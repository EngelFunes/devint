/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_AccTerritoryHstry_TriggerHndlr 
@CreatedDate: 21 - Dec 2018 
@Description: GA_AccTerritoryHstry_TriggerHndlr class is for updating Association Third Party Biller.
@version : 1.0  
********************************************************************************************************************************/
public with sharing class GA_AccTerritoryHstry_TriggerHndlr {
    
    public static final string ClsName  ='GA_AccTerritoryHstry_TriggerHndlr';
    public static final string methodName  ='afterInsert';
    public static final string methodName1  ='afterUpdate';
    public static boolean isExecuting=false;
    public static final string qryATH ='Select id,Name,GA_Start_Date__c,GA_End_Date__c,GA_Is_Processed__c,GA_Territory_Id__c,GA_Account_Id__c from GA_Account_Territory_History__c';
    public static integer athBatchLmt=Integer.valueof(system.label.GA_ATH_BatchLimit);
    /**
@Description: afterInsert() method 
@Name : afterInsert
@Param : List<GA_Account_Territory_History__c> athList  
@Return : void
@throws Exception : N/A;
*/     
    public static void afterInsert(List<GA_Account_Territory_History__c> athList)
    {
        try
        {
            if(athList.size()<athBatchLmt && athList.size()>0 && !System.isBatch() && !isExecuting){
                isExecuting=true;
                GA_ATH_AP01_TerritoryUpdatngToAcc.updateATHtoAcc(athList,null);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName);
        }
    }
    /**
@Description: afterUpdate() method 
@Name : afterUpdate
@Param :List<GA_Association_Third_Party_Biller__c> atPBList,Map<ID,GA_Association_Third_Party_Biller__c> atpbOldMap 
@Return : void
@throws Exception : N/A;
*/    
    public static void afterUpdate(List<GA_Account_Territory_History__c> athList,Map<ID,GA_Account_Territory_History__c> athOldMap)
    {
        try
        {
            if(athList.size()<athBatchLmt && athList.size()>0 && !isExecuting && !System.isBatch()){
                isExecuting=true;
                GA_ATH_AP01_TerritoryUpdatngToAcc.updateATHtoAcc(athList,athOldMap);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName1);
        }
    }
}