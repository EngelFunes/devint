/**
@Author : Prasant Kumar Satpathy
@Name: GA_UpdateAccntsPltinmStsBatch 
@CreatedDate: 05-Jan-2018  
@Description: GA_UpdateAccntsPltinmStsBatch class to update the platinum status 
@version : 1.0  
*/
global class GA_UpdateAccntsPltinmStsBatch implements Database.Batchable<sObject> {
    global static final string tdy=string.valueof(date.today());
    global static final string ystrdy=string.valueof(date.today()-1);
    global static final string queryString = 'SELECT Id,GA_Is_Active__c,GA_Account__c,GA_Agency__c,GA_StartDate__c,GA_EndDate__c,GA_Agency__r.GA_Platinum__c  from GA_AgencyRelationship__c where (GA_Is_Active__c=true and GA_EndDate__c='+ystrdy+')';
    public static final String ClsName  ='GA_UpdateAccntsPltinmStsBatch';
    public static final String batchExecute ='execute';
    
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= queryString;
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<GA_AgencyRelationship__c> scope)
    {
        try{
        list<GA_AgencyRelationship__c> agncRltUpdteStatusLst=new list<GA_AgencyRelationship__c>();
        GA_AgencyRelationship__c agncyRelTmp=new GA_AgencyRelationship__c();
        for(GA_AgencyRelationship__c agncyRel:scope)
        {
            agncyRelTmp=agncyRel;
            agncyRelTmp.GA_Is_Active__c=false;
            agncRltUpdteStatusLst.add(agncyRelTmp);
        }
        
        if(agncRltUpdteStatusLst.size()>0)
        {
            database.update(agncRltUpdteStatusLst);
            GA_AR_AP01_UpdatePlatinumStatusOnAccount.createAgencyRelation(agncRltUpdteStatusLst, null);
        }
            }
         catch(exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, batchExecute);
        }
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}