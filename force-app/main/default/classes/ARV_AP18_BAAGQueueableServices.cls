/*****************************************************************************************
Class Name   : ARV_AP18_BAAGQueueableServices 
Date Created : 21-MAY-2019
Created By   : IDC Offshore
Description  : This  class is called from ARV_AP24_QuoteProposalServiceCall to call BAAG services.
******************************************************************************************/
public without sharing class ARV_AP18_BAAGQueueableServices implements Queueable, Database.AllowsCallouts {
    private QuoteLineItem quoteItem;
    private id quoteIds;
    private BOOLEAN checkBCBS;
    private static final string BCBSCOMP='BCBSCOMP';
    private static final string CLASSNAME  ='ARV_AP18_BAAGQueueableServices';
    private static final string METHODNAME  ='execute';
    private static final String FOLDRNAME=system.label.ARV_CL02_BCBSM_FldrNme;
    private static final string FOLDERQUERY='SELECT Id, Name FROM Folder';
    private static final string FOLDERWHERE=' where Name=:paramName'; 
    private static final String FOLDERLIMIT=' LIMIT 1';
    private static final String TYPENAME='BAAG';
    private static final String  SEPARATOR='-';
    /*Get products related to quote*/
    public ARV_AP18_BAAGQueueableServices(QuoteLineItem qlt, Id quoteId,Boolean checkSpecificBCBS){
        this.quoteItem = qlt;
        this.quoteIds = quoteId;
        this.checkBCBS= checkSpecificBCBS;
    }
     /**************  
    Method name : execute method
    Params     : NA
    Return Type : NA
    Description :This method is used to send product details to ARV_AP09_BAAGServiceDocGen.
    *************/ 
    public void execute(QueueableContext context) {                 
        try{
            ARV_AP09_BAAGServiceDocGen  docsbc=new ARV_AP09_BAAGServiceDocGen ();
            ContentDocumentLink attach = new ContentDocumentLink();
              string finalDescription=string.valueOf(quoteItem.Product2Id) +SEPARATOR +TYPENAME;
            string checkDescription=(checkBCBS==true)?BCBSCOMP:finalDescription;
            if(!test.isRunningTest()){
                attach=docsbc.getBAAGDoc(quoteItem.Product2Id,quoteIds,checkBCBS);
            }
            if(attach!=null){
              list<ContentDocumentLink> cdlList=new list<ContentDocumentLink>();
                cdlList.add(attach);
                set<id> cntDocId=new set<id>();
                List<ContentVersion> versions = new List<ContentVersion>();
                for(ContentDocumentLink cdl:cdlList){
                    cntDocId.add(cdl.ContentDocumentId);
                 } 
                List <contentversion> updtCVLst = new List <contentversion> ();
                for (contentversion cvl: [select id, Description, ContentDocumentId from contentversion where ContentDocumentId in:cntDocId ]) {
                    cvl.Description=checkDescription;
                    updtCVLst.add(cvl);
                }
                if(updtCVLst.size()>0){
                database.update(updtCVLst);
                }
            }else{}
        }
        catch(exception e){ GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME); }
    }
}