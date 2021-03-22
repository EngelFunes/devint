/**
@Author : Prasant Kumar Satpathy
@Name: GA_JEO_ReassignTaskToSME
@CreatedDate: 24- Jul 2017 
@Description: GA_JEO_ReassignTaskToSME class is for creating/updating task whenever Assigned To field in jeopardy record 
is changed
@version : 1.0  
*/
public with sharing class GA_JEO_ReassignTaskToSME {
    
    public static final String PriorityVal = 'High';
    public static final String statusVal = 'Open';
    public static final String subjectVal = 'Account in Jeopardy ';
    public static final String completeStatVal = 'Completed';
    public static final String jeoErrMag = 'Jeopardy record cannot be saved :';
    public static final string ClsName  ='GA_JEO_ReassignTaskToSME';
    public static final string methodNme  ='CreateOrUpdateTask';
    public static final string methodNmeCrtTsk  ='CreateTask';
    public static boolean isExecuting=false;
    /**
@Description: ValidateException
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    public with sharing class ValidateException extends Exception {}
    /**
@Description: CreateOrUpdateTask() method 
@Name : CreateOrUpdateTask
@Param : list<GA_Jeopardy__c> jeoprdLst,map<id,GA_Jeopardy__c> jeoprdOldMap
@Return : void
@throws Exception : N/A;
*/ 
    public static void CreateOrUpdateTask(list<GA_Jeopardy__c> jeoprdLst,map<id,GA_Jeopardy__c> jeoprdOldMap)
    {
        try{
            set<id> jeoIdset=new set<id>();
            list<GA_Jeopardy__c> jeoprdLstFltr=new list<GA_Jeopardy__c>();
            for(GA_Jeopardy__c jeoRec:jeoprdLst)
            {
                
                GA_Jeopardy__c jeoRecOld=jeoprdOldMap.get(jeoRec.id);
                if(jeoRec.GA_AssignedTo__c !=null ||(jeoRec.GA_AssignedTo__c !=jeoRecOld.GA_AssignedTo__c))
                {
                    jeoIdset.add(jeoRec.id);  
                    jeoprdLstFltr.add(jeoRec);  
                }
                
            }
            list<task> tskLst=[select id,whatid from task where whatid in :(jeoIdset) and status !=:completeStatVal limit 100];
            map<id,list<task>> jeopTskMap=new map<id,list<task>>();
            list<task> tskLsttmp;
            for(task tsk:tskLst)
            {
                if(jeopTskMap.get(tsk.whatid) !=null)
                {
                    tskLsttmp=jeopTskMap.get(tsk.whatid);
                }
                else
                {
                    tskLsttmp=new  list<task>();
                }
                tskLsttmp.add(tsk);
                jeopTskMap.put(tsk.whatid,tskLsttmp);
            }
            list<task> tskLsttoUpdte=new list<task>();
            list<task> tskLsttoCreate=new list<task>();
            task tsk=new task();
            for(GA_Jeopardy__c jeoRec:jeoprdLstFltr)
            {
                if(jeopTskMap.get(jeoRec.id) == null)
                {
                    tsk=new task();
                    tsk.Ownerid=jeoRec.GA_AssignedTo__c;
                    tsk.Description=jeoRec.GA_ResolutionDetail__c;
                    tsk.Priority=priorityVal;
                    tsk.Status=statusVal;
                    tsk.Subject=subjectVal;
                    tsk.whatid=jeoRec.id;
                    tsk.ActivityDate=system.today();
                    tskLsttoCreate.add(tsk);
                }
                else
                {
                    for(task tskUpdt:jeopTskMap.get(jeoRec.id))
                    {
                        tskUpdt.ownerid=jeoRec.GA_AssignedTo__c;
                        tskLsttoUpdte.add(tskUpdt);
                    }  
                }
                
            }
            
            GA_Util01_JEODataAccessHelper.createUpdateTsk(tskLsttoCreate, tskLsttoUpdte);  
        }catch (Exception e){
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            jeoprdLst[0].adderror(jeoErrMag);
            
        }
    }
    
       /**
@Description: jeoTaskCreate() method 
@Name : jeoTaskCreate
@Param : list<GA_Jeopardy__c> jeoprdLst
@Return : void
@throws Exception : N/A;
*/ 
    public static void jeoTaskCreate(list<GA_Jeopardy__c> jeoprdLst)
    {
        try
        {
            task tsk=new task();
            list<task> tskLstToInsert=new list<task>();
            for(GA_Jeopardy__c jeoRec:jeoprdLst)
            {
                tsk=new task();
                tsk.Ownerid=jeoRec.GA_AssignedTo__c;
                tsk.Description=jeoRec.GA_ResolutionDetail__c;
                tsk.Priority=priorityVal;
                tsk.Status=statusVal;
                tsk.Subject=subjectVal;
                tsk.whatid=jeoRec.id;
                tsk.ActivityDate=system.today();
                tskLstToInsert.add(tsk);
            }
            GA_Util01_JEODataAccessHelper.createUpdateTsk(tskLstToInsert, new list<task>());   
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeCrtTsk);
            jeoprdLst[0].adderror(jeoErrMag);
            
        }
        
    }
}