/**
@Author : Prasant Satpathy
@Name: GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch
@CreatedDate: 6 - Dec 2017 
@Description: GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch batch class for locking and unlocking contacts based on parent account updates when account list size is more than or equal to 100
@version : 1.0  
*/ 
global class GA_LockRecords_Batch implements Database.Batchable<sObject>, Database.Stateful{
    global final String Query;
    global final String DmlOp;
    global final List<id> idLst=new list<id>();
    global static final String GA_System_of_Record = 'GA_System_of_Record__c'; 
 	public static final String dmlInsrt='Insert';
    public static final String dmlUpdte='Update';    
    global final map<id,sObject>objOldMapRec;
    
    /**
@Description: GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch() Constructer method 
@Name : GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch
@Param : String q, set<id> accId,list<id> accLckIds,list<id> accunLckIds
@Return : void
@throws Exception : N/A;
*/  
    global GA_LockRecords_Batch(String q,String Dml,map<id,sObject>objOldMap,list<id> idLstVal){
        
        Query=q;
        DmlOp=Dml;
        objOldMapRec=objOldMap;
        idLst.addall(idLstVal);
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

        if(DmlOp==dmlInsrt)
        {
            GA_Util_lockRecords.onInsertlockRecords(scope, GA_System_of_Record);     
            
        }
        if(DmlOp==dmlUpdte)
        {        
             GA_Util_lockRecords.onUpdatelockorUnlockRecords(scope, objOldMapRec,GA_System_of_Record);
        }
            
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