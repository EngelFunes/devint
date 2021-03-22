/*****************************************************************************************
Class Name   : ARV_AP12_QueueableServices 
Date Created : 16-MAY-2019
Created By   : IDC Offshore
Description  : This  class is called from ARV_AP24_QuoteProposalServiceCall to call SBC services.
******************************************************************************************/
public without sharing class ARV_AP12_QueueableServices implements Queueable, Database.AllowsCallouts {
    private QuoteLineItem quoteItem;
    private Id accId;
    private id quoteIds;
    private string carrierType;
    private static final string CLASSNAME ='ARV_AP12_QueueableServices';
    private static final string METHODNAME  ='execute';
    private static final String TYPENAME='SBC';
    private static final String SEPERATOR='-';
    
    /*Get products related to quote*/
    public ARV_AP12_QueueableServices(Id acId,QuoteLineItem qlt,Id quoteId,string carrierType){
        this.quoteItem = qlt;
        this.accId= acId;
        this.quoteIds = quoteId;
        this.carrierType=carrierType;
    }
    
        /**************  
    Method name : execute method
    Params     : NA
    Return Type : NA
    Description :This method is used to call webservices.
    *************/ 
    public void execute(QueueableContext context) {                 
        try{
            ARV_AP13_SBCServiceDocGen  docsbc=new ARV_AP13_SBCServiceDocGen ();
            ContentDocumentLink attach=new ContentDocumentLink();
            String finalDescription= string.valueOf(quoteItem.Product2Id)+SEPERATOR+TYPENAME;
            if(!test.isRunningTest()){
             attach = docsbc.getSBCDoc(quoteItem.Product2Id,accId,quoteIds,carrierType);
            }else {
               //attach.title = quoteItem.Description;
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
                    cvl.Description=finalDescription;
                    updtCVLst.add(cvl);
                }
                database.update(updtCVLst);
            }else{}
        }
        catch(exception e){ GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME);  }
    }
}