/*************************************************************
Class Name   : ARV_AP39_AttachePDFsToQuote 
Date Created : 19-June-2019
Created By   : IDC Offshore
Description  : This class used to create attachment in Quote object for CoverPage and RateGrid Page.
**************************************************************/
public with sharing class ARV_AP39_AttachePDFsToQuote
{    
    private static final string DOCNAME1='C_RateGrid.pdf';
    private static final string CONTENTTYPE='application/pdf';
    private static final string DOCNAME2='A_QuoteCoverPage.pdf';
    private static final string DOCNAME3='B_CensusRateGrid.pdf';
    private static final string BOBVAL='Unit.Test';
    private static final string QTID='id';
    private static final string COUNTQUERY=' select id from contentdocumentlink ';
    private static final string COUNTWHERE=' where linkedentityid =:paramName and contentdocument.Title = :paramName1';
    private static final String CLSNAME='ARV_AP39_AttachePDFsToQuote';
    private static final String METHODNAME='attachToQuote';
    private static final String METHODNAME1='attachmentCreate';
    private static final String ERRORMSG= 'There was an issue Creating CoverPage and RateGrid attachment and CensusRateGrid';
    
    /*************************************************************
    Method Name  : attachToQuote
    Date Created : 19-June-2019
    Created By   : IDC Offshore
    Description  : This Method will create attachment in Quote object. 
    **************************************************************/     
    public static void attachToQuote(string quoteId,string docType1,string docType2,string docType3) {
        try{
            if(docType1 == ARV_AP41_StringLiteralUtils.RATEGRID){
                //calling the ARV_AP07_QueryDataHelper to fetch the count of Attachment   
                rateGridAtt(quoteId);
            }
            if(docType2 == ARV_AP41_StringLiteralUtils.COVERPAGE){
                //calling the ARV_AP07_QueryDataHelper to fetch the count of Attachment  
               coverPageAtt(quoteId); 
            } 
            if(docType3 == ARV_AP41_StringLiteralUtils.CENSUSVAL){
                //calling the ARV_AP07_QueryDataHelper to fetch the count of Attachment  
               censusRateGridPage(quoteId);
            }
        }
        catch(Exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME  );
            throw new AuraHandledException(ERRORMSG+e.getMessage());}
    } 
    /*************************************************************
    Method Name  : fileCreation
    Date Created : 19-June-2019
    Created By   : IDC Offshore
    Description  : This Method will create Files in Quote object. 
    **************************************************************/    
    private static void fileCreation(String descprtn,String title,Blob pdf,String qoutId ){
        contentversion conVrsn=new contentversion();
        conVrsn.Title =title;
        conVrsn.Description =descprtn;
        conVrsn.PathOnClient =title+'.pdf';
        conVrsn.VersionData =pdf ;
        conVrsn.IsMajorVersion = true;
        insert conVrsn;
        List<ContentVersion> cvrsn = [SELECT ContentDocumentId  FROM ContentVersion WHERE Id=:conVrsn.id ];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = qoutId;
        cdl.ContentDocumentId = cvrsn[0].ContentDocumentId;
        cdl.shareType = 'V';
        cdl.Visibility='AllUsers';
        insert cdl;
    } 
    /*************************************************************
    Method Name  : rateGridAtt
    Date Created : 19-June-2019
    Created By   : IDC Offshore
    Description  : This Method will create RateGrid attachment in Quote object. 
    **************************************************************/    
    public static void rateGridAtt(string quoteId)
    {   
        try{
            ARV_AP07_QueryDataHelper.paramName = quoteId;
            ARV_AP07_QueryDataHelper.paramName1 = DOCNAME1;
            list<ContentDocumentLink> attList =ARV_AP07_QueryDataHelper.getsObjects(COUNTQUERY,COUNTWHERE,NULL,NULL) ;
            if( attList.size() < 1 ){
                PageReference pageRef = Page.ARV_VF06_RateGridPage;
                pageRef.getParameters().put(QTID,quoteId);
                Blob pdf1=NULL ;
                if(Test.isRunningTest()){
                    pdf1 = blob.valueOf(BOBVAL);
                }else{
                    pdf1 = pageRef.getcontentAsPdf();
                }
                //Creating PDF RateGrid Attachment
               
                fileCreation(ARV_AP41_StringLiteralUtils.RATEGRID,DOCNAME1,pdf1,quoteId);
            }    
        }catch(Exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME1);
            throw new AuraHandledException(ERRORMSG+e.getMessage());}
    }
    
    /*************************************************************
    Method Name  : coverPageAtt
    Date Created : 19-June-2019
    Created By   : IDC Offshore
    Description  : This Method will create coverPageAtt attachment in Quote object. 
    **************************************************************/    
    public static void coverPageAtt(string quoteId)
    {   
        try{
            ARV_AP07_QueryDataHelper.paramName = quoteId;
            ARV_AP07_QueryDataHelper.paramName1 = DOCNAME2;
            list<ContentDocumentLink> attList =ARV_AP07_QueryDataHelper.getsObjects(COUNTQUERY,COUNTWHERE,NULL,NULL) ;
            //List<ContentDocumentLink>  attList =[select id from contentdocumentlink where linkedentityid=:quoteId and contentdocument.Title=:DOCNAME2];
            if( attList.size() < 1 ){
                PageReference pageRef = Page.ARV_VF09_CoverPage;
                pageRef.getParameters().put(QTID,quoteId);
                Blob pdf1=NULL ;
                if(Test.isRunningTest()){
                    pdf1 = blob.valueOf(BOBVAL);
                }else{
                    pdf1 = pageRef.getcontentAsPdf();
                }
                //Creating PDF RateGrid Attachment
                fileCreation(ARV_AP41_StringLiteralUtils.COVERPAGE,DOCNAME2,pdf1,quoteId);
            }
        }catch(Exception e){ GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME1);
            throw new AuraHandledException(ERRORMSG+e.getMessage());}
    }
    
    /*************************************************************
    Method Name  : censusRateGridPage
    Date Created : 19-June-2019
    Created By   : IDC Offshore
    Description  : This Method will create censusRateGridPage attachment in Quote object. 
    **************************************************************/    
    public static void censusRateGridPage(string quoteId)
    {   
        try{
            ARV_AP07_QueryDataHelper.paramName = quoteId;
            ARV_AP07_QueryDataHelper.paramName1 = DOCNAME3;
            list<ContentDocumentLink> attList =ARV_AP07_QueryDataHelper.getsObjects(COUNTQUERY,COUNTWHERE,NULL,NULL) ;
            if( attList.size() < 1 ){
                PageReference pageRef = Page.ARV_VF10_CensusRateGridPage;
                pageRef.getParameters().put(QTID,quoteId);
                Blob pdf1=NULL ;
                if(Test.isRunningTest()){
                    pdf1 = blob.valueOf(BOBVAL);
                }else{
                    pdf1 = pageRef.getcontentAsPdf();
                }
                //Creating PDF RateGrid Attachment
                fileCreation(ARV_AP41_StringLiteralUtils.CENSUSVAL,DOCNAME3,pdf1,quoteId);
            }
        }
        catch(Exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME1);
            throw new AuraHandledException(ERRORMSG+e.getMessage());}
    }
}