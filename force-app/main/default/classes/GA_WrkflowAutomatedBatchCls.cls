/**
@Author : Prasant Kumar Satpathy
@Name: GA_WrkflowAutomatedBatchCls 
@CreatedDate: 05-Jan-2018  
@Description: GA_WrkflowAutomatedBatchCls class to create workflow process records 
@version : 1.0  
*/
global class GA_WrkflowAutomatedBatchCls implements Database.Batchable<sObject> {
    global static final string queryString = 'SELECT Id,GA_WF_Workflow_ID__c,GA_Workflow_Template_Id__c from GA_WF_Step__c where id in:wfStpIds';
    global map<id,string> wfGrpSgmntMp=new map<id,string>();
    global list<Id> wfStpIds=new list<Id>();
    global map<id,Automated_Workflow_Settings__mdt> wfTmpAutmtedwrflwMap=new map<id,Automated_Workflow_Settings__mdt>();
    global list<GA_WF_Group_Segment__c> lstWFStepGroupSegments=new list<GA_WF_Group_Segment__c>();
    public static TimeZone tz = UserInfo.getTimeZone();
    public static Datetime currenttime = system.now();
    
    
    global GA_WrkflowAutomatedBatchCls(map<id,string> wfGrpSgmntMpTmp,map<id,Automated_Workflow_Settings__mdt> wfTmpAutmtedwrflwMapTmp,list<id> wfSTpIdsTmp )
    {
        wfGrpSgmntMp.putAll(wfGrpSgmntMpTmp);
        wfTmpAutmtedwrflwMap.putAll(wfTmpAutmtedwrflwMapTmp);
        wfSTpIds.addAll(wfSTpIdsTmp);
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= queryString;
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<GA_WF_Step__c> scope)
    {
		for(GA_WF_Step__c wfSTp:scope)
                {
                    list<id> grpIds=wfGrpSgmntMp.get(wfSTp.GA_WF_Workflow_ID__c).split(',');
                    
                    for(string groupSegmentIds : grpIds){
                        lstWFStepGroupSegments.add(new GA_WF_Group_Segment__c(
                            GA_Workflow_ID__c = wfSTp.GA_WF_Workflow_ID__c, 
                            GA_Group_Segment_ID__c = groupSegmentIds, 
                            ownerid = wfTmpAutmtedwrflwMap.get(wfSTp.GA_Workflow_Template_Id__c).GA_Owner_Id__c,
                            GA_WF_Step_ID__c = wfSTp.Id, 
                            GA_Date_Opened__c = currenttime ));
                        
                    }// end of for-each   
                }
        database.insert(lstWFStepGroupSegments);
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}