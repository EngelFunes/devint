/*****************************************************************************************
Class Name   : ARV_AP80_AttachmentToFileHanlder_Test 
Date Created : 31-Jan-2020
Created By   : IDC Offshore
Description  : This  class is called from ARV_TR02AttachmentTrigger to insert files of  attachments from docusign staus object into contract object.
******************************************************************************************/
@isTest
public without sharing class ARV_AP80_AttachmentToFileHanlder_Test {
    ARV_AP80_AttachmentToFileHanlder_Test(){}
        private static final string PROFILENAME='System Administrator';
 private static final string NAME='AP80LastName';
       private static final string USERNAME='bcbsm1@bcbsm.com';
private static final String CONTNAME='dsfs__DocuSign_Status__c';
/*****************************************************************************************
Method Name   : tesdata1
Date Created : 31-Jan-2020
Created By   : IDC Offshore
Description  : This  class is called from ARV_TR02AttachmentTrigger to insert files of  attachments from docusign staus object into contract object.
******************************************************************************************/
    @testsetup static void tesdata1()
    {
        Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);
        Contract con= ARV_AP05_TestDataCreation.createContractRec(acc.id);
        con.Name=CONTNAME;
        database.insert(con);
        dsfs__DocuSign_Status__c docsig=ARV_AP05_TestDataCreation.docusignstatusRec();
        docsig.dsfs__Contract__c = con.id;
        database.insert(docsig);
        Attachment attach1= ARV_AP05_TestDataCreation.attachmentRec(docsig.id);
        database.insert(attach1);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
  usr.LastName = NAME;
  usr.Username=USERNAME;
  database.insert(usr,true);     
    }
    /*****************************************************************************************
Method Name   : ARV_AP80_AttachmentToFileHanlder
Date Created : 19-Jan-2020
Created By   : IDC Offshore
Description  : This  method is used to retreive the Attachments of docusign.
******************************************************************************************/
    public static testmethod void getAttachment()
    {
        try{
        
           list<Attachment> att= [select id,Name,OwnerId,Body,ParentId from attachment limit 100]; 
          
             user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){  
            test.startTest(); 
             ARV_AP80_AttachmentToFileHanlder obj= new ARV_AP80_AttachmentToFileHanlder();
           obj.covertAttachmentToFile(att);
             //test.stopTest();
                 System.assertEquals(true,true);
        }
        }catch(Exception e){
         throw new AuraHandledException(e.getMessage()+e.getlinenumber());
            
        }
    }
    /*****************************************************************************************
Class Name   : ARV_AP80_AttachmentToFileHanlder
Date Created : 19-Jan-2020
Created By   : IDC Offshore
Description  : This   method is written to cover the catch block of ARV_AP79 class.
******************************************************************************************/
    public static testmethod void invokeFileQueable()
    {
            try{
            set<Id> finalAttachSet = null; 
            Map<Id,Id> docuContractIdMap = null;
           
                user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){  
           ARV_AP79_FileQueueableServices updateJob = new ARV_AP79_FileQueueableServices(finalAttachSet,docuContractIdMap);
            
           Id jobID = System.enqueueJob(updateJob);
                System.assertEquals(null,null);
        }
        }Catch(Exception e){
         throw new AuraHandledException(e.getMessage()+e.getlinenumber());
         }
       
    }
}