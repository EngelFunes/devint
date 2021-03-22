/*************************************************************
Class Name   : ARV_AP29_AgentLogoUtil 
Date Created : 26-July-2019
Created By   : IDC Offshore
Description  : As part of RateGrip PDG generation, this class will be called to get the Agent logo details on pdf.**/
public with sharing class ARV_AP29_AgentLogoUtil {   
    private static final string QUOTEQUERY=system.label.ARV_CL26_QUOTEQUERY;
    private static final string QUOTEWHERE=' where Id = :paramId1';
    private static final string USERQUERY=system.label.ARV_CL27_USERQUERY; 
    private static final string USERWHERE=' where Id = :paramId1';
    private static final string ATTACHMENTQUERY='select id from contentdocumentlink '; 
    private static final string ATTACHMENTWHERE=' where linkedentityid  =:paramId1';
    private static final string ORDERBY=' order By LastModifiedDate DESC';
    private static final string LIMITCLAUSE=' LIMIT 1';
    private static final String CLSNAME='ARV_AP29_AgentLogoUtil';
    private static final String METHODNAME='getAgentLogo';
    private static final String ERRORMSG=  'There was an issue while fetching attachmentId of Agent';     
    public static  List<Quote> quoteRec{get;set;}
    public static List<User> loggedInUser{get;set;}
    public static List<ContentDocumentLink> ContactAgentLogo{get;set;}
    public static String attachmentId{get;set;}
    /*************************************************************
Class Name   : getAgentLogo 
Date Created : 26-July-2019
Created By   : IDC Offshore
Description  : As part of RateGrip PDG generation, this Method will be called to get the Agent logo details on pdf**/    
    public static String getAgentLogo (Id quoteId){
        try{
            quoteRec = new List<Quote>();
            loggedInUser = new List<User>();
            ContactAgentLogo = new List<ContentDocumentLink>(); 
            //calling the ARV_AP07_QueryDataHelper to fetch the Quote Details
            ARV_AP07_QueryDataHelper.paramId1 = quoteId;
            quoteRec =  ARV_AP07_QueryDataHelper.getsObjects(QUOTEQUERY,QUOTEWHERE,NULL,NULL);         
            Id userId = userInfo.getUserId();
            Id contactId = NULL;
            //calling the ARV_AP07_QueryDataHelper to fetch the loggedInUser
            ARV_AP07_QueryDataHelper.paramId1 = userId;
            loggedInUser =  ARV_AP07_QueryDataHelper.getsObjects(USERQUERY,USERWHERE,NULL,NULL) ;
            //Checking External user or Internal user
            if(loggedInUser[0].contactId != null){
                contactId = loggedInUser[0].contactId ;}
            else{                   
                ARV_AP07_QueryDataHelper.paramId1 = quoteRec[0].Agent_Name__c ; 
                //calling the ARV_AP07_QueryDataHelper to fetch the loggedInUser
                loggedInUser =  ARV_AP07_QueryDataHelper.getsObjects(USERQUERY,USERWHERE,NULL,NULL) ;   
                if( loggedInUser.size()>0 ){
                    contactId = loggedInUser[0].contactId ;}     }  
            if(contactId != null)  {  
                //calling the ARV_AP07_QueryDataHelper to fetch the attachment 
                ARV_AP07_QueryDataHelper.paramId1 = contactId;
                ContactAgentLogo =  ARV_AP07_QueryDataHelper.getsObjects(ATTACHMENTQUERY,ATTACHMENTWHERE,null,LIMITCLAUSE) ;
                if(ContactAgentLogo.size() >0){
                    attachmentId = ContactAgentLogo[0].id; } } }
        catch(Exception e){ GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME  );       
                           throw new AuraHandledException(ERRORMSG+e.getMessage());}
        return attachmentId; }       }