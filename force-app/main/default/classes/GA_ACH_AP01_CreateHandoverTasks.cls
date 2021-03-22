/*******************************************************************************************************************************
@Author             :   Dilip Junapala
@Name               :   GA_ACH_AP01_CreateHandoverTasks
@CreatedDate        :   15 - Dec 2017 
@Description        :   GA_ACH_AP01_CreateHandoverTasks is for creating Handover Form Checklist tasks to Implementation Manager on change of prospect to Customer Account.
@version            :   1.0  
********************************************************************************************************************************/
public with sharing class GA_ACH_AP01_CreateHandoverTasks {
    public static boolean isExecuting = false;
    public static final string taskcrteErrMsg = 'Could not create tasks :';
    public static final string ClsName  ='GA_ACH_AP01_CreateHandoverTasks';
    public static final string methodNme  ='createtasks';
    public static  final Date effectiveDate = system.today() + 90;
    public static final String actmImpMan = 'Implementation Manager';
    //public static final String actmNbSc = 'New Business Sales Consultant';
    //public static final String actmRsR = 'Retention Sales Representative';
    
    /*******************************************************************************************************************************
@Description        :   createtasks() method 
@Name               :   createtasks
@Param              :   list<GA_AccountHandOver__c> achList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/
    public static List<Event> createtasks(list<GA_AccountHandOver__c> achList){
        try{
            Set<Id> setAchId = new Set<ID>();
            Id actId;
            if(!achList.isEmpty()){
                for(GA_AccountHandOver__c ach : achList){
                    actId = ach.GA_CompanyFullLegalName__c;
                    setAchId.add(actId);
                }
                
                map<id,id> acctImpMap=new map<id,id>();
                
                
                for(AccountTeamMember atmbr:([select AccountId, userId, TeamMemberRole from AccountTeamMember 
                                              Where AccountId IN : setAchId  
                                              AND (TeamMemberRole = :actmImpMan) Limit 5001]))
                    
                {
                    if(atmbr.TeamMemberRole == actmImpMan){
                        acctImpMap.put(atmbr.AccountId,atmbr.userId);
                    }
                }
                List<Sobject> tskList = new List<Sobject>();
                List<Event> EvtList = new List<Event>();
                Map<Id, GA_Handover_Form_Tasks__mdt> hndovertaskMapLst = new Map<Id, GA_Handover_Form_Tasks__mdt>([SELECT Id, GA_Days__c, GA_Subject__c, GA_Type__c, 
                                                                      GA_Priority__c, GA_Final_Task__c, GA_Status__c
                                                                      FROM GA_Handover_Form_Tasks__mdt limit 50]);
                Task tsk =  new Task();
                Event evt = new Event();
                for(GA_AccountHandOver__c ach : achList){
                    for(GA_Handover_Form_Tasks__mdt htask : hndovertaskMapLst.Values()){
                        if(htask.GA_Final_Task__c == false && !acctImpMap.values().isEmpty()){
                            tsk                 =   new Task();
                            tsk.WhatId          =   ach.id;
                            tsk.OwnerId         =   acctImpMap.Get(ach.GA_CompanyFullLegalName__c);
                            tsk.Subject         =   htask.GA_Subject__c;
                            tsk.Type            =   htask.GA_Type__c;
                            tsk.ActivityDate    =   effectiveDate - Integer.valueOf(htask.GA_Days__c);
                            tsk.Priority        =   htask.GA_Priority__c;
                            tsk.Status          =   htask.GA_Status__c;
                            tskList.add(tsk);
                        } 
                        if(htask.GA_Final_Task__c == true && !acctImpMap.values().isEmpty()){
                            
                            evt                 =   new Event();
                            evt.WhatId          =   ach.id;
                            evt.OwnerId         =   acctImpMap.Get(ach.GA_CompanyFullLegalName__c);
                            evt.Subject         =   htask.GA_Subject__c;
                            evt.Type            =   htask.GA_Type__c;
                            evt.StartDateTime   =   effectiveDate - Integer.valueOf(htask.GA_Days__c);
                            evt.EndDateTime     =   effectiveDate - Integer.valueOf(htask.GA_Days__c);
                            evt.IsAllDayEvent   =   true;
                            tskList.add(evt);
                            EvtList.add(evt);
                        }
                    }
                }
                if(!tskList.isempty()){
                    tskList.sort();
                    database.insert(tskList, true);
                }
                if(!EvtList.isEmpty()){
                     return EvtList;
                }
               
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            achList[0].adderror(taskcrteErrMsg);
        }
        return null;
    }
}