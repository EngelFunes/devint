/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_EventTriggerHandler
@CreatedDate: 02 - Jan 2018 
@Description: GA_EventTriggerHandler class is for creating/updating When Event is changed.
@version : 1.0  
********************************************************************************************************************************/
public with sharing class GA_EventTriggerHandler {
    public static final String ClsName  ='GA_EventTriggerHandler';
    public static final String methodNmeafterinsert  ='afterinsert';
    public static final String  qryCreateinvitees='SELECT Id, WhatId from Event where id in:idLst';
    /*******************************************************************************************************************************
@Description		: 	afterinsert() method 
@Name 				: 	afterinsert
@Param 				: 	list<Event> evtList
@Return 			: 	void
@throws Exception 	: 	N/A;
********************************************************************************************************************************/ 
    public static void afterinsert(list<Event> evtList)
    {
        try
        {	if(!evtList.isEmpty())
            {
                if((!GA_EVE_AP01_AddInvitees.isExecuting) &&(!GA_HandoverBatchForInsertingTasks.isBatchTaskInsert)){
                    GA_EVE_AP01_AddInvitees.isExecuting = true;
                    GA_EVE_AP01_AddInvitees.addInvites(evtList);
                } 
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterinsert);
            
        }
        
    }
}