/*****************************************************************************************
Class Name   : GA_AccntOwnerUpdate_Scheduler
Date Created : 01/21/2019
Created By   : IDC Offshore
Description  : 1. This is the schedule class for update account owner.
******************************************************************************************/
global class GA_AccntOwnerUpdate_Scheduler implements Schedulable {
    public static final String CUSTRCRDNAME = 'Account - Customer';
    public static final String PROSRCRDNAME = 'Account - Prospect';
    public static final Id CUSTRCRDTYPID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(CUSTRCRDNAME).getRecordTypeId();
    public static final Id PROSPECTYPID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(PROSRCRDNAME).getRecordTypeId();
    public static final integer UPTACCOWNRLMT =Integer.valueof(system.label.GA_UpdateAccOwner_Limit);
    public static final string CREATEDT=string.valueof(system.today()).split(' ')[0];
    public static final String ACCQRY = ' Select id,ownerid,GA_Territory__c,ga_territory__r.GA_RetentionSalesRepresentative__c,ga_territory__r.GA_Sales_Rep_Effective_Date__c,GA_Retention_Sales_Rep__c,GA_Is_Mass_Updating__c from Account'+
        ' where   GA_IsAccOwnerRSR__C = TRUE and ga_territory__r.GA_Sales_Rep_Effective_Date__c = '+CREATEDT +' and GA_Territory__c <> null  '+
        ' and recordtypeid in ';
    
    /****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used to update the account ownere based on 
territory retention sales rep change by running the execute method of schedule class.
******************************************************************************************************/
    global void execute(SchedulableContext SC) {
        set<id> curIdSet=new set<id>();
        curIdSet.add(CUSTRCRDTYPID);
        curIdSet.add(PROSPECTYPID);
        String actRecIdString = GA_Util08_FilterProcessHelper.idSet(curIdSet);
        String querytoUpdate  = ACCQRY +actRecIdString;
        
        GA_UpdateTerritoryRtnSalesRepBatch uptslsTmBtch=new GA_UpdateTerritoryRtnSalesRepBatch(querytoUpdate);
        Database.executeBatch(uptslsTmBtch,UPTACCOWNRLMT); 
        
        
    }
}