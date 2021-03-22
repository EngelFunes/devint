/**
@Author : IDC offshore
@Name: GA_AP_CtrlSheetDataCls
@CreatedDate: 02 - Jan 2019 
@Description: GA_AP_CtrlSheetDataCls class is to generate control sheet
@version : 1.0  
*/
public without sharing class GA_AP_CtrlSheetDataCls {
    /* @Description    :   fetchaccName
    @Name         :   fetchaccName
    @Param         :   string accId
    @Return       :   string
    @throws Exception   :   N/A;*/
    @AuraEnabled
    public static string fetchaccName(string accId)
    {
        return [select name from account where id=:accId Limit 1].Name;
    }
}