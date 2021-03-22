/*****************************************************************************************************************************************************
@Author : Sreenu Ravilla
@Name: TaskSendEmailApproversBatch
@CreatedDate:  25-Feb-2021 
@Description: TaskSendEmailApproversBatch is used to send  Email notifications for task owners.

@US Number: US-3921

*/
Global class ASC_TaskSendEmailApproversBatch implements Database.Batchable<sObject>,Database.Stateful{
    global set<String> taskRecordSet;
    
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext BC) {
        taskRecordSet = new set<String>();
         string quoteValue='quote'; 
         string newValue='New';         
         string inProgressValue='In Progress';  
         string ASCValue='ASC';        
         string query;    
         final string actQuery='SELECT Id,Status,WhatId,OwnerId,owner.email,owner.Name FROM Task';  
         final string actWhere=' WHERE WhatId In (SELECT Id FROM quote)';            
         final string actwhere2 =  ' and (Status = \'New\'';      
         final string actwhere3 =  ' or Status = \'In Progress\')';          
         final string actwhere4 =  ' and Type = \'ASC\''; 
       query=actQuery+actWhere+actwhere2+actwhere3+actwhere4;
        return Database.getQueryLocator(query);
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext BC, list<task> scope) {
        List<Task> taskList=new List<Task>();
        for(task tk:scope){
            if(!taskRecordSet.contains(tk.OwnerId)){
                taskList.add(tk);
                taskRecordSet.add(tk.OwnerId);
            }
        }
        if(taskList.size()>0){
            ASC_TaskSendEmailApproversClass.emailNotificationOnTask(taskList);
        }
		
             
    }
/**method to execute post batch finishes*/
    global void finish(Database.BatchableContext BC) {
   
    }

}