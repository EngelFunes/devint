/**
@Author : Prasant Satpathy
@Name: GA_ACC_AP04_UpdtCntOnAccLockUnlock
@CreatedDate: 3 - Dec 2017 
@Description: GA_ACC_AP04_UpdtCntOnAccLockUnlock class for locking and unlocking contacts based on parent account updates when account list size is less than 100
@version : 1.0  
*/
public with sharing class GA_ACC_AP04_UpdtCntOnAccLockUnlock {
    
    public static boolean isExecuting=false;
    public static final string cntLockUnLockErrMsg = 'Could not Lock/Unlock contact :';
    public static final string ClsName  ='GA_ACC_AP04_UpdtCntOnAccLockUnlock';
    public static final string methodNme  ='updateCntlockUnlock';
    public static final string selectQueryLk='select id, GA_SMART_ID__c from contact ';
    public static final string whereClauseLk='where accountid in ';
    public static final string limitClauseLk='limit 10000';
    public static final String q='select id,AccountId,GA_SMART_ID__c from contact where accountid in :accntTotalId';
    public static final string LkObj='Contact'; 
    public static final string SysRecSmrt='SMART';     
    public static integer accCntLmt=Integer.valueof(system.label.GA_Acc_Cnt_Limit);
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
    /**
@Description: updateCntlockUnlock() method 
@Name : list<account> actLst,map<id,account> acctOldMap
@Param : String q, set<id> accId,list<id> accLckIds,list<id> accunLckIds
@Return : void
@throws Exception : N/A;
*/
    public static void updateCntlockUnlock(list<account> actLst,map<id,account> acctOldMap)
    {
        list<id> accntLockLstId=new list<id>();
        list<id> accntunLockLstId=new list<id>();
        set<id> accntTotalId=new set<id>();
        list<contact> cntLstToLock=new list<contact>();
        list<contact> cntLstToUnLock=new list<contact>();
        try
        {
            for(account acc:actLst)
            {  
                account accOld=acctOldMap.get(acc.id);
                if((accOld.GA_System_of_Record__c != acc.GA_System_of_Record__c) && acc.GA_System_of_Record__c.toUpperCase()==SysRecSmrt)
                {
                    accntLockLstId.add(acc.id);
                }

                if((accOld.GA_System_of_Record__c != acc.GA_System_of_Record__c) && acc.GA_System_of_Record__c.toUpperCase()!=SysRecSmrt)
                {
                    accntunLockLstId.add(acc.id);
                }
            }
            accntTotalId.addAll(accntunLockLstId);
            accntTotalId.addAll(accntLockLstId);
            if(accntTotalId.size()<accCntLmt)
            {
                
                if(accntLockLstId.size()>0)
                {
                    set<id> CurIdSet=new set<id>();
                    CurIdSet.addAll(accntLockLstId);
                    String accntLockLstIdString = GA_Util08_FilterProcessHelper.idSet(CurIdSet);
                    
                    for(contact cnt:GA_Util11_ContactDataAccessHelper.fetchContactsMap(selectQueryLk, whereClauseLk+accntLockLstIdString, GA_Util11_ContactDataAccessHelper.BLANK, limitClauseLk).values())
                    {
                        if(!Approval.isLocked(cnt.id))
                        {
                            cntLstToLock.add(cnt);
                        }
                    }  
                }
                
                if(accntunLockLstId.size()>0)
                {
                    set<id> CurUnLkIdSet=new set<id>();
                    CurUnLkIdSet.addAll(accntunLockLstId);
                    String accntunLockLstIdString = GA_Util08_FilterProcessHelper.idSet(CurUnLkIdSet);
                    contact con;
                    for(contact cnt:GA_Util11_ContactDataAccessHelper.fetchContactsMap(selectQueryLk, whereClauseLk+accntunLockLstIdString, GA_Util11_ContactDataAccessHelper.BLANK, limitClauseLk).values())
                    {  
                        con=cnt;
                        cntLstToUnLock.add(con);
                    }   
                }
                
                if(cntLstToLock.size()>0)
                    GA_Util_lockRecords.lockRecords(cntLstToLock,LkObj);
                if(cntLstToUnLock.size()>0)
                    GA_Util_lockRecords.unlockRecords(cntLstToUnLock,LkObj);
                
            }
            else
            {
                GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch uptcntAccBtch=new GA_ACC_AP04_UpdtCntOnAccLockUnlock_batch(q,accntTotalId,accntLockLstId,accntunLockLstId);
                ID batchprocessid = Database.executeBatch(uptcntAccBtch,2000);
                
            } 
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            throw new ValidateException(cntLockUnLockErrMsg,e);
        }
        
    }
}