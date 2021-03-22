/**
@Author : Prasant Satpathy
@Name: GA_UpdateWFGrpSgmntsBatch
@CreatedDate: 6 - Dec 2017 
@Description: GA_UpdateWFGrpSgmntsBatch batch class for creating next steps when WF group segment result is updated
@version : 1.0  
*/ 
global class GA_UpdateWFGrpSgmntsBatch implements Database.Batchable<sObject>, Database.Stateful{
    global final String Query;
    global final list<id> wfgsSetId=new list<id>(); 
    global final map<id,GA_WF_Group_Segment__c>objOldMapRec;
    global final map<id,GA_WF_Group_Segment__c>objNewMapRec;
    global list<id> grpSgmnstToUpdate;
    global list<GA_WF_Group_Segment__c> grpSgmnstLsttoUp;
    global TimeZone tz = UserInfo.getTimeZone();
    global  Datetime currenttime = system.now();
	global final string clsVal='Closed';   
    /**
@Description: GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch() Constructer method 
@Name : GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch
@Param : String q, set<id> accId,list<id> accLckIds,list<id> accunLckIds
@Return : void
@throws Exception : N/A;
*/  
    global GA_UpdateWFGrpSgmntsBatch(String q,map<id,GA_WF_Group_Segment__c>objOldMap,map<id,GA_WF_Group_Segment__c>objNewMap,list<id> idLstVal){
        
        Query=q;
        objOldMapRec=objOldMap;
        objNewMapRec=objNewMap;
        wfgsSetId.addall(idLstVal);
        grpSgmnstToUpdate=new list<id>();
    }
    
    /**
@Description: start() method 
@Name : start
@Param : Database.BatchableContext BC
@Return : Database.QueryLocator
@throws Exception : N/A;
*/ 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    /**
@Description: execute() method 
@Name : execute
@Param : Database.BatchableContext BC, List<sObject> scope
@Return : Database.QueryLocator
@throws Exception : N/A;
*/ 
    global void execute(Database.BatchableContext BC, List<sObject> scope){

        GA_WrkFlwSldAftr3pm.wfgsLst=scope;
        GA_WrkFlwSldAftr3pm.beforeUpdate(objNewMapRec, objOldMapRec);
        GA_WrkFlwSldAftr3pm.afterUpdate(objNewMapRec, objOldMapRec);
        
        grpSgmnstLsttoUp=new list<GA_WF_Group_Segment__c>();
        for(id grpSgmntCurr:GA_WrkFlwSldAftr3pm.wfgsLsttoUpdateBtch)
        {
            
            GA_WF_Group_Segment__c grp=new GA_WF_Group_Segment__c();
            grp.id=grpSgmntCurr;
            grp.GA_Date_Closed__c = currenttime;                
            grp.GA_Status__c = clsVal; 
            grpSgmnstLsttoUp.add(grp);
        }
        for(id grpSgmntCurr:GA_WrkFlwSldAftr3pm.wfgsLsttoclnBtch.keyset())
        {
            GA_WF_Group_Segment__c grp=new GA_WF_Group_Segment__c();
            grp.id=grpSgmntCurr;
            grp.GA_Result__c='';              
            grpSgmnstLsttoUp.add(grp);
        }
        
        database.update(grpSgmnstLsttoUp,false);
    }
    /**
@Description: finish() method 
@Name : finish
@Param : Database.BatchableContext BC
@Return : Void
@throws Exception : N/A;
*/ 
    global void finish(Database.BatchableContext BC){
        
    }
}