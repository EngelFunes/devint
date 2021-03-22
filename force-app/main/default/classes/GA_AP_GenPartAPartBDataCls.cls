/**
@Author : IDC offshore
@Name: GA_AP_CtrlSheetDataCls
@CreatedDate: 02 - Jan 2019 
@Description: GA_AP_CtrlSheetDataCls class is to generate control sheet
@version : 1.0  
*/
public without sharing class GA_AP_GenPartAPartBDataCls {   
  
    @AuraEnabled
    public static string fetchCaseNumber(string caseId)
    {
       return [select CaseNumber from case where id=:caseId limit 1].CaseNumber;
    }
   
    
}