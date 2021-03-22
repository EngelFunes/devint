/**
@Author : Prasant Kumar Satpathy
@Name: GA_JEO_TR01_JeoprdyTriggerhndlr
@CreatedDate: 24- Jul 2017 
@Description: GA_JEO_TR01_JeoprdyTriggerhndlr class is for creating/updating task whenever Assigned To field in jeopardy record 
is changed
@version : 1.0  
*/
public with sharing class GA_JEO_TR01_JeoprdyTriggerhndlr {
    
    public Static Final string ERRORMSG = 'Unable to create or update jeopardy task';
    public Static Final string CLSNAME  ='GA_JEO_TR01_JeoprdyTriggerhndlr';
    public Static Final string METHODNME  ='afterupdate';
    public Static Final string METHODBEFINS  ='afterupdate';
    public Static Final string METHODNMEINSRT  ='afterinsert';
    public Static Final GA_Profile_ByPass__c PROFBYPASS = GA_Profile_ByPass__c.getInstance();
    
    /**
@Description: beforeInsert() method 
@Name : beforeInsert
@Param : list<GA_Jeopardy__c> jeoprdLst    
@Return : void
@throws Exception : N/A;
*/ 
    public static void beforeInsert(list<GA_Jeopardy__c> jeoprdLst)
    {	
        try{
            for(GA_Jeopardy__c jeop:jeoprdLst)
            {
                jeop.GA_Account_Owner_Manager_Email__c=jeop.GA_Account_Owner_Mgr_Email__c;
                jeop.GA_Acc_Owner_Mngrs_Mngr_Email__c=jeop.GA_Acc_Owner_Managers_Manager__c	;
            }
        } catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODBEFINS);
        }
    }
    
    /**
@Description: afterupdate() method 
@Name : afterupdate
@Param : list<GA_Jeopardy__c> jeoprdLst, map<id,GA_Jeopardy__c> jeoprdOldMap    
@Return : void
@throws Exception : N/A;
*/ 
    public static void afterupdate(list<GA_Jeopardy__c> jeoprdLst,map<id,GA_Jeopardy__c> jeoprdOldMap)
    {
        try
        {   
            if(!PROFBYPASS.Bypass__c){
                if(!GA_JEO_ReassignTaskToSME.isExecuting)
                {
                    GA_JEO_ReassignTaskToSME.CreateOrUpdateTask(jeoprdLst, jeoprdOldMap);  
                    GA_JEO_ReassignTaskToSME.isExecuting=true;
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
            jeoprdLst[0].adderror(ERRORMSG);
        }
    }
    
    /**
@Description: afterinsert() method 
@Name : afterinsert
@Param : list<GA_Jeopardy__c> jeoprdLst    
@Return : void
@throws Exception : N/A;
*/ 
    public static void afterinsert(list<GA_Jeopardy__c> jeoprdLst)
    {
        try
        {   
            if(!PROFBYPASS.Bypass__c){
                if(!GA_JEO_ReassignTaskToSME.isExecuting)
                {
                    GA_JEO_ReassignTaskToSME.jeoTaskCreate(jeoprdLst);
                    GA_JEO_ReassignTaskToSME.isExecuting=true;
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEINSRT);
            jeoprdLst[0].adderror(ERRORMSG);
        }
        
    }
}