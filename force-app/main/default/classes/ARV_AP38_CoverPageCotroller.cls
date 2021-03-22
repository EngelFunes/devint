/*************************************************************
Class Name   : ARV_AP38_CoverPageCotroller 
Date Created : 19-June-2019
Created By   : IDC Offshore
Description  : As part of CoverPage PDF generation, this class will be invoked in VF page to get Quote Details display in CoverPage..
**************************************************************/
public with sharing class ARV_AP38_CoverPageCotroller
{ 
    private Id quoteId;
    private static final string IDSTRING = 'id';
    private static final string QUOTEQUERY = system.label.ARV_CL26_QUOTEQUERY;
    private static final string QUOTEWHERE = ' where Id = :paramId1';    
    private static final String CLSNAME = 'ARV_AP38_CoverPageCotroller';
    private static final String METHODNAME = 'getQuoteData';
    private static final String ERRORMSG = 'There was an issue processing CoverPage';
    public List<Quote> quoteRec{get;set;}   
    public string effectiveDate{get;set;}
    public String attachmentId{get;set;}
    
/*************************************************************
Method Name  : ARV_AP38_CoverPageCotroller
Date Created : 19-June-2019
Created By   : IDC Offshore
Description  : This is constructor to fetech QuoteId from VF page. 
**************************************************************/     
    public ARV_AP38_CoverPageCotroller(){   
        quoteId = ApexPages.currentPage().getParameters().get(IDSTRING);
    }
    
/*************************************************************
Method Name  : getQuoteData
Date Created : 19-June-2019
Created By   : IDC Offshore
Description  : This Method will fetch data from Quote object and also fetech agent logo from contact attachment section. 
**************************************************************/     
    public void getQuoteData(){
        try{
            quoteRec = new List<Quote>();            
            effectiveDate = null;
            // Calling ARV_AP29_AgentLogoUtil to get the Agent attachmentId.
            attachmentId = ARV_AP29_AgentLogoUtil.getAgentLogo(quoteId);
            //calling the ARV_AP07_QueryDataHelper to fetch the Quote Details.
            ARV_AP07_QueryDataHelper.paramId1 = quoteId;
            quoteRec =  ARV_AP07_QueryDataHelper.getsObjects(QUOTEQUERY,QUOTEWHERE,NULL,NULL) ;
            effectiveDate = quoteRec[0].Requested_Effective_Date__c.month()
                +ARV_AP41_StringLiteralUtils.SLASH+quoteRec[0].Requested_Effective_Date__c.day()
                +ARV_AP41_StringLiteralUtils.SLASH+quoteRec[0].Requested_Effective_Date__c.year();             
        } 
        catch(Exception e){             
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME  );
            throw new AuraHandledException(ERRORMSG+e.getMessage());
        }       
    }    
}