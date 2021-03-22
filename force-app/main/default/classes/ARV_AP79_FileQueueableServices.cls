/*****************************************************************************************
Class Name   : ARV_AP79_FileQueueableServices 
Date Created : 19-Jan-2020
Created By   : IDC Offshore
Description  : This  class is called from ARV_TR02AttachmentTrigger to insert files of  attachments from docusign staus object into contract object.
******************************************************************************************/
public without sharing class ARV_AP79_FileQueueableServices implements Queueable, Database.AllowsCallouts {
    private set<Id> statusIdSet;
    private map<Id,Id> parentContractMap;    
    //private static final string CLASSNAME ='ARV_AP70_FileQueueableServices';
    //private static final string METHODNAME  ='execute';

/*****************************************************************************************
Constructor   : ARV_AP79_FileQueueableServices 
Date Created : 19-Jan-2020
Created By   : IDC Offshore
Description  : It is used to asign contractids,Docusign staus ids to set and map
******************************************************************************************/   
    public ARV_AP79_FileQueueableServices(set<Id> docStatIdSet,map<Id,Id> parentContMap){
        this.statusIdSet = docStatIdSet;
        this.parentContractMap= parentContMap;       
    }
    
 /*****************************************************************  
    Method name : execute method
    Params     : NA
    Return Type : NA
    Description :This method is used to execut queuable class.
 *********************************************************************/ 
    public void execute(QueueableContext context) { 
        string CLASSNAME ='ARV_AP70_FileQueueableServices';
        string METHODNAME  ='execute';
        try{
            ARV_AP78_AttachToFileQueubleClass.attachmentsConversion(statusIdSet,parentContractMap);
        }
        catch(exception e)
        {GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME);throw new AuraHandledException(e.getMessage()); }
        // if(!test.isRunningTest()){throw new AuraHandledException(e.getMessage()); }}
    }
}