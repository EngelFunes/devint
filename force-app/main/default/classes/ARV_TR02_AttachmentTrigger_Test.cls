/*****************************************************************************************
Class Name   : ARV_TR02_AttachmentTrigger_Test
Date Created : 04-04-2020
Created By   : IDC Offshore
Description  : This  class is called from ARV_TR02_AttachmentTrigger to insert files of  attachments from docusign staus object into contract object.
******************************************************************************************/
@isTest
public without sharing class ARV_TR02_AttachmentTrigger_Test {
    private static final string PROFILENAME='System Administrator';
    private static final string NAME='AP80LastName';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final String CONTNAME='dsfs__DocuSign_Status__c';
    
    /*****************************************************************************************
    Method Name   : getAttachment
    Date Created : 04-04-2020
    Created By   : IDC Offshore
    Description  : This  method is used to retreive the Attachments of docusign.
    ******************************************************************************************/
    public static testmethod void getAttachment()
    {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        usr.Username=USERNAME; 
        system.Runas(usr){
            Account acc=ARV_AP05_TestDataCreation.accRec();
            database.insert(acc);
            Contract con= ARV_AP05_TestDataCreation.createContractRec(acc.id);
            con.Name=CONTNAME;
            database.insert(con);         
            Attachment attach1= ARV_AP05_TestDataCreation.attachmentRec(con.id);
            database.insert(attach1);     
            System.assertEquals(attach1.Id!=null,true);       
        }    
          
    }
   
}