public class GA_AP_CommunityCtrlSheetDataCls {
    @AuraEnabled
    public static string fetchaccName(string accId)
    {
        return [select name from account where id=:accId Limit 1].Name;
    }
    @AuraEnabled
    public static String getBaseUrl () {
        if (Network.getNetworkId() != null) {
            return [SELECT Id, UrlPathPrefix FROM Network WHERE Id = :Network.getNetworkId()].UrlPathPrefix;
        }
        return '';
    }
    
    @AuraEnabled
    public static String getUIThemeDescription() {
        return UserInfo.getUiThemeDisplayed();
    }
}