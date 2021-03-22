/**
@Author : IDC Offshore
@Name: GA_AORGSUpdtSrvcngAgntOnGs_Batch
@CreatedDate: 03 - June - 2019 
@Description: GA_AORGSUpdtSrvcngAgntOnGs_Batch batch class to update servicing agent on Group Segment reocrds.
*/
global class GA_AORGSUpdtSrvcngAgntOnGs_Batch implements Database.Batchable<sObject>{
    private string query;
    private list<id> idLst=new list<id>();
 /**
@Description: GA_AORGSUpdtSrvcngAgntOnGs_Batch() Constructer method 
@Name : GA_AORGSUpdtSrvcngAgntOnGs_Batch
@Param : string aorgsQry
@Return : void
@throws Exception : N/A;
*/  
    global GA_AORGSUpdtSrvcngAgntOnGs_Batch(string aorgsQry)
    {
        query=aorgsQry;
    }
    /**
@Description: start() method 
@Name : start
@Param : Database.BatchableContext BC
@Return : Database.QueryLocator
@throws Exception : N/A;
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query); 
    }
    /**
@Description: execute() method 
@Name : execute
@Param : Database.BatchableContext BC, List<sObject> scope
@Return : Database.QueryLocator
@throws Exception : N/A;
*/ 
    global void execute(Database.BatchableContext bc, List<GA_AOR_Group_Segment__c> scope)
    {
       GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.updtDateInfo(scope,null);
       GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.updtSrvcAgntToGS(scope,null);
    }
    /**
@Description: finish() method 
@Name : finish
@Param : Database.BatchableContext BC
@Return : Void
@throws Exception : N/A;
*/ 
    global void finish(Database.BatchableContext bc)
    {
        
    }
}