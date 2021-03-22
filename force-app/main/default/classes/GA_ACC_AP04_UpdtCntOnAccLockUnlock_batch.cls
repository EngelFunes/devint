/**
@Author : Prasant Satpathy
@Name: GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch
@CreatedDate: 6 - Dec 2017 
@Description: GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch batch class for locking and unlocking contacts based on parent account updates when account list size is more than or equal to 100
@version : 1.0  
*/ 
global class GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch implements Database.Batchable<sObject>{
    global final String Query;
    global set<id> accntTotalId=new set<id>();
    global set<id> accntLockLstId=new set<id>();
    global set<id> accntunLockLstId=new set<id>();
    global list<contact> cntLstToLock=new list<contact>();
    global list<contact> cntLstToUnLock=new list<contact>();
    global static final string LkObj='Contact';           
    
    /**
@Description: GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch() Constructer method 
@Name : GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch
@Param : String q, set<id> accId,list<id> accLckIds,list<id> accunLckIds
@Return : void
@throws Exception : N/A;
*/  
    global GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch(String q, set<id> accId,list<id> accLckIds,list<id> accunLckIds){
        
        Query=q;
        accntTotalId=accId;
        accntLockLstId.addAll(accLckIds);
        accntunLockLstId.addAll(accunLckIds);
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
        
        list<contact> cntLst=scope;
        
        for(contact cnt:cntLst)
        {
            if(accntLockLstId.size()>0)
            {
                if(accntLockLstId.contains(cnt.accountid))
                {
                    if(!Approval.isLocked(cnt.id))
                    {
                        cntLstToLock.add(cnt);
                    }  
                }
            }
            if(accntunLockLstId.size()>0)
            {
                if(accntunLockLstId.contains(cnt.accountid))
                {
                        cntLstToUnLock.add(cnt);
                }   
            }
        }  
        
        
        if(cntLstToLock.size()>0)
            GA_Util_lockRecords.lockRecords(cntLstToLock,LkObj);
        if(cntLstToUnLock.size()>0)
            GA_Util_lockRecords.unlockRecords(cntLstToUnLock,LkObj);
        
        
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