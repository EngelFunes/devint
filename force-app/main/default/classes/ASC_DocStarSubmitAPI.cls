/**
 * @File Name          : ASC_DocStarSubmitAPI.cls
 * @Description        : Docstar API Callout
 * @Author             : amitchell
 * @Group              : Salesforce Professional Services
 * @Last Modified By    : amitchell
 * @Last Modified On    : 3/10/2020
 * @Modification Log    : 
 * Ver       Date            Author                 Modification
 * 1.0      3/10/2020       amitchell              Initial Version
**/ 

global without sharing class ASC_DocStarSubmitAPI implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    public static final string CLASSNAME  ='ASC_DocStarSubmitAPI';
    public static final string METHODNAME  ='sentDocuments';
    public static final string SVRC_VERS = '1.0';
    public static final string SCHM_VERS = '1.0.0';
    /*public static final string COSMR_ID = 'csSalesForceIBUCRM';
    public static final string COSMR_NAME = 'IBU Salesforce';  // speak with TA - shouldnt be hardcoded but seem unnecessary for custom setting values.
    public static final string MSG_ID = 'sfdcqte';    */
    public static final string COSMR_ID = 'csSalesForceGrpCRM ';
    public static final string COSMR_NAME = 'ASC Salesforce';  // speak with TA - shouldnt be hardcoded but seem unnecessary for custom setting values.
    public static final string MSG_ID = 'sfdasc';    
    public static final string DOCSTAR_ENDPOINT = 'callout:Smart_Service/Utility/DocSTAR/1.0/storeDoc';

    public String fileId;
    public Map <String, String> inboundPayloadAreaAttributes;
    /*public List<QTE_Shopping_Quote_Applicant__c>  shoppingQuotesApp = new List<QTE_Shopping_Quote_Applicant__c>();
    public List<QTE_Shopping_Quote_Product__c> shoppingQuotesProd = new List<QTE_Shopping_Quote_Product__c>();*/
    public List<ContentVersion> versionUpdatesList = new List<ContentVersion>();
    public Set <Id> approvedSubmitFiles;
    Contract contractRelated;
    Integer totalDocs;
    global final string contentQuery;
    global final string npnValue;
    public decimal maxRecount;
    public Integer recordsSent;
    
    private static final String CALLOUT_POST = 'POST';
    private static final string DEVELOPERNAME_DOCSTAR_API = 'DocStar_API';

    global ASC_DocStarSubmitAPI(Set<Id> incApprovedFiles, Contract contractRelatedNew ) {
        totalDocs = incApprovedFiles.size();
        contractRelated = contractRelatedNew;
        approvedSubmitFiles = incApprovedFiles;
        recordsSent = 0 ;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        //return Database.getQueryLocator(contentQuery);
        //return Database.getQueryLocator('Select id,VersionData,FirstPublishLocationId, Title, FileType, ContentSize from contentversion where id=\'068e0000001hFEtAAM\'');
        return Database.getQueryLocator('Select id,VersionData,FirstPublishLocationId, Title, FileType, ContentSize, vlocity_ins__Status__c from contentversion where id in: approvedSubmitFiles AND IsLatest = TRUE ');
        
    }
    

    global void execute(Database.BatchableContext bc, List<sObject> scope) {

        System.debug('Started Execute method');

        if (scope.size() > 1) {
            System.debug('At this time docstar only supports batch size of 1');
            return;
        }
        inboundPayloadAreaAttributes = new Map<String, String>();
        List <ContentVersion> fileInformation = new List<ContentVersion>();
        String quoteLocId;
        fileInformation.add((ContentVersion) scope[0]);

        for(ContentVersion ff : fileInformation){
            if( ff.Title.Contains('.PDF') || ff.Title.Contains('.pdf') ){
                ff.Title = ff.Title.substringBefore('.');
            }else if( ff.Title.Contains('.DOCX') || ff.Title.Contains('.docx') ){
                ff.Title = ff.Title.substringBefore('.');
            }
        }
        System.debug('>>>>>> fileInformation: ' + fileInformation);

		if (fileInformation == null || fileInformation.isEmpty() || fileInformation[0].VersionData == null) {
            System.debug('Cannot find appropriate file information to complete call');
            return;
        }        
        
        versionUpdatesList.add(new ContentVersion(Id = fileInformation[0].Id));
                                                      
        
        

        String fileName = (fileInformation[0].Title + '.' + fileInformation[0].FileType).toUpperCase();
        String fileType = fileInformation[0].FileType.capitalize();
        Datetime current = DateTime.now();
        String local = current.format('yyyy-MM-dd HH:mm:ss', 'EST');
        String convertedLocal = String.valueOf(DateTime.valueOf(local).getTime());
        DateTime dt = System.Now();
        Long utcTime = current.getTime();
        String customerID = contractRelated.CID__c;
        String plan = contractRelated.ASC_Carrier__c;
        String documentYear = contractRelated.ASC_Contract_Year__c;
        String documentType;
        String ContractualDocumentType ='';
        
        if(fileInformation[0].Title.contains('Base ASC')){
            ContractualDocumentType = 'Base ASC Contract';
            documentType = 'ASCCONTRACT';
        }else if(fileInformation[0].Title.contains('Contract Amendment')){
            ContractualDocumentType = 'Contract Amendment';
            documentType = 'ASCAMENDMENT';
        }else if(fileInformation[0].Title.contains('Schedule A')){
            ContractualDocumentType =   'Schedule A';
            documentType = 'SCHEDULEA';
        }else if(fileInformation[0].Title.contains('Stop-Loss Exhibit')){
            ContractualDocumentType = 'Stop-Loss Exhibit';
            documentType = 'SLEXHIBIT';
        }else{
            documentType = fileInformation[0].Title;
        }

        inboundPayloadAreaAttributes.put('FileName', fileName);
        inboundPayloadAreaAttributes.put('Scan_Date_Time', String.valueOf(utcTime));
        inboundPayloadAreaAttributes.put('Customer_ID', customerID);
        inboundPayloadAreaAttributes.put('Group_Type', 'ASC');
        inboundPayloadAreaAttributes.put('Document_Year', documentYear);
        inboundPayloadAreaAttributes.put('Plan', plan);
        inboundPayloadAreaAttributes.put('Document_Type', documentType);

        if (!inboundPayloadAreaAttributes.containsKey('MimeType')) {
            if (fileType == 'PDF') {
                inboundPayloadAreaAttributes.put('MimeType', 'APPLICATION/PDF');
            }
            if (fileType == 'PNG' || fileType == 'BMP' || fileType == 'SVG' || fileType == 'TIFF' || fileType == 'GIF' || fileType == 'JPG' || fileType == 'JPEG') {
                inboundPayloadAreaAttributes.put('MimeType', 'IMAGE/' + fileType.toUpperCase());
            }
        }

        HttpResponse res = AP70_Q2E_WebCalloutService.sendRequest(DOCSTAR_ENDPOINT, 
                                                                    CALLOUT_POST, 
                                                                    null,                                                                     
                                                                    populateDocStarSubmitFile(inboundPayloadAreaAttributes, 
                                                                                              '',
                                                                                              fileInformation[0].VersionData),                                                                    
                                                                    'ASC_DocStarSubmitAPI');
            
        
        
        try {system.debug('>>>>> Result: '+res.getStatusCode() );
            if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                try {

                     //ASC_ContractualDoc_TriggerHandler.ContractualDocumentComplianceStatus(contractRelated);
                    /*List<ContentVersion> lstContentVersion = new List<ContentVersion>();
                    for(ContentVersion cv : fileInformation){
                        lstContentVersion.add( new ContentVersion(id = fileInformation[0].id, vlocity_ins__Status__c = 'Accepted') );
                    }
                    
                    Update fileInformation;*/
                                      
                    ContentVersion cv = new ContentVersion(id = fileInformation[0].id, vlocity_ins__Status__c = 'Accepted');
            		Update cv;
                    recordsSent++; 

                    List<ASC_Contractual_Document__c> lstContractualDocument = new List<ASC_Contractual_Document__c>([SELECT ID 
                                                                                                                    FROM ASC_Contractual_Document__c 
                                                                                                                    WHERE ASC_Document_Type__c =: ContractualDocumentType 
                                                                                                                    AND ASC_Contract__C =: contractRelated.ID ]);
                    System.debug('Outside Date Signed block');
                    for(ASC_Contractual_Document__c contractualDocument : lstContractualDocument){
                        System.debug('Inside Date Signed block');
                        contractualDocument.ASC_Date_Signed__c = system.today();
                    }                                                    
                    update lstContractualDocument;
                    SYSTEM.debug('>>>>>>>lstContractualDocument: :' + lstContractualDocument);
                    System.debug('Integration_Status__c Success');

                } catch (Exception ex) {system.debug('>>>>> Error?: '+ex );
                    ContentVersion cv = new ContentVersion(id = fileInformation[0].id, vlocity_ins__Status__c = 'Rejected');
                    Update cv;
                    GA_LogExceptionCls.LogExcp(ex, CLASSNAME, METHODNAME);
                }
            
            } else {
                //throw new IntegrationException(res.getStatusCode() + ' Error with API');
                System.debug(res.getStatusCode() + ' Error with API:' + res.getBody());
                
            }
        } catch (IntegrationException ex) {
            ContentVersion cv = new ContentVersion(id = fileInformation[0].id, vlocity_ins__Status__c = 'Rejected');
            Update cv;
            //fileInformation[0].vlocity_ins__Status__c = 'Rejected';
            //Update fileInformation[0];
             system.debug('****** ERROR'+ex);
             GA_LogExceptionCls.LogExcp(ex, CLASSNAME, METHODNAME);
        }
        
                   
    }

    /**
    * @method Name: populateDocStarSubmitFile
    * @params - Map<String, String> inboundParams - a value pair map of optional outbound paramters to health sherpa. 
    * @return : String - Your serialized JSON String ready to submit to DocStar
    */

    private static string populateDocStarSubmitFile(Map<String, String> inboundParams, String apiKey, Blob fileContent) {
        AP90_Q2E_STRUCT_DocStar_Submit.cls_VersionInfo vrsnInfo = new AP90_Q2E_STRUCT_DocStar_Submit.cls_VersionInfo();
        vrsnInfo.ServiceVersion = SVRC_VERS;
        vrsnInfo.SchemaVersion = SCHM_VERS;
        
        AP90_Q2E_STRUCT_DocStar_Submit.cls_Consumer consumr = new AP90_Q2E_STRUCT_DocStar_Submit.cls_Consumer();
        consumr.ID = COSMR_ID;
        consumr.Name = COSMR_NAME;
        
        AP90_Q2E_STRUCT_DocStar_Submit.cls_ReqHeaderArea reqhdarea = new AP90_Q2E_STRUCT_DocStar_Submit.cls_ReqHeaderArea();
        reqhdarea.VersionInfo = vrsnInfo;
        reqhdarea.CreationDateTime = String.valueof(system.now());
        reqhdarea.MessageID = MSG_ID;
        reqhdarea.Consumer = consumr;
        
        //For loop here
        List<AP90_Q2E_STRUCT_DocStar_Submit.cls_attributeValue > fullAttributeList = New List<AP90_Q2E_STRUCT_DocStar_Submit.cls_attributeValue>();

        for (String inboundParam : inboundParams.keySet()) {
            AP90_Q2E_STRUCT_DocStar_Submit.cls_attributeValue attrVal = new AP90_Q2E_STRUCT_DocStar_Submit.cls_attributeValue();            
            attrVal.Name = inboundParam;
            attrVal.Value = inboundParams.get(inboundParam);             
            fullAttributeList.add(attrVal);
        }
        
        AP90_Q2E_STRUCT_DocStar_Submit.cls_PayloadArea payloadarea=new AP90_Q2E_STRUCT_DocStar_Submit.cls_PayloadArea();
        //payloadarea.Id = 'cmcsSalesForceIBUCRM';  
        payloadarea.Id = 'cmcsSalesForceGrpCRM';  
        payloadarea.Attribute = fullAttributeList;
        payloadarea.Password = 'cR3gXB%4tZ&p'; //apiKey;
        payloadarea.fileContent = EncodingUtil.base64Encode(fileContent);
        payloadarea.RepositoryName = 'CM';
        payloadarea.FolderName = 'PHI_Cntr';

        AP90_Q2E_STRUCT_DocStar_Submit.cls_RtrvDocSTAR storDocSTAR = New AP90_Q2E_STRUCT_DocStar_Submit.cls_RtrvDocSTAR();
        storDocSTAR.ReqHeaderArea = reqhdarea;
        storDocSTAR.PayloadArea = payloadarea;   
        System.debug(JSON.serialize(new AP90_Q2E_STRUCT_DocStar_Submit(storDocSTAR)));
        return JSON.serialize(new AP90_Q2E_STRUCT_DocStar_Submit(storDocSTAR));

    }
/*
    public static string bytesToHumanReadableFileSize(long incomingSize) {
        if (incomingSize == null) {
            return null;
        }
        if (incomingSize < 1024)
            return string.valueOf(incomingSize) + ' B';
        else if (incomingSize >= 1024 && incomingSize < (1024 * 1024)) {
            return String.valueOf(Decimal.valueOf(incomingSize).divide(1024,2).setScale(0, RoundingMode.HALF_UP)) + ' KB';
        }
        else if (incomingSize >= (1024*1024) && incomingSize < (1024*1024*1024)) {
            return String.valueOf(Decimal.valueOf(incomingSize).divide((1024*1024),2).setScale(1, RoundingMode.HALF_UP)) + ' MB';
        }
        //Size wont be larger then GB 
        return String.valueOf(Decimal.valueOf(incomingSize).divide((1024*1024*1024),2).setScale(1, RoundingMode.HALF_UP)) + ' GB';
    }
*/

    global void finish(Database.BatchableContext bc){
        if (!versionUpdatesList.isEmpty()) {            
            upsert versionUpdatesList;
        }
        if( recordsSent == approvedSubmitFiles.size() ){
            contractRelated.ASC_Signature_Status__c = 'Complete';
            Update contractRelated;
        }

    }
    
    public class IntegrationException extends Exception {}

    public static void sentDocuments(Map<Id,Contract> mapContractNew) { 
        Set<Id> contractIdsSet = mapContractNew.keySet();
        Set<Id> contentVersionIdsSet = new Set<Id>();
        set<Id> cdIDs = new Set<id>();
        Set<Id> contractualDocumentIdSet = new Set<Id>();
        List<ContentVersion> lstContentVersion;
        List<ContentDocumentLink> lstContentDocumentLink;
        List<ASC_Contractual_Document__c> lstContractualDocument;
        List<String> documentList = new List<String>();






        lstContractualDocument = new List<ASC_Contractual_Document__c>( [SELECT ID 
                                                                        FROM ASC_Contractual_Document__c 
                                                                        WHERE ASC_Document_Type__c = 'Group Signed Package' 
                                                                        AND ASC_Contract__C IN : contractIdsSet ] );
        if( lstContractualDocument.size() > 0 ){
            contractualDocumentIdSet = (new Map<Id,ASC_Contractual_Document__c>( lstContractualDocument )).keySet();

            lstContentDocumentLink = new List<ContentDocumentLink>([SELECT ContentDocumentid,ContentDocument.title 
                                                                    FROM ContentDocumentLink 
                                                                    WHERE LinkedEntityId IN : contractualDocumentIdSet
                                                                    AND (NOT ContentDocument.title like '%CoverSheet%')]);

            for (ContentDocumentLink cdLink : lstContentDocumentLink ) {
                documentList.add(cdLink.ContentDocument.title);
            }

            for (ContentDocumentLink cdLink :  [SELECT ContentDocumentId,ContentDocument.title 
                                                FROM ContentDocumentLink 
                                                WHERE LinkedEntityId IN :contractIdsSet
                                                AND ContentDocument.title IN:documentList ]) {

                cdIDs.add(cdLink.ContentDocumentId);

            }

            lstcontentversion = new List<Contentversion>([SELECT id, vlocity_ins__Status__c, title
                                                        FROM contentversion 
                                                        WHERE contentdocumentid IN: cdIDs]);
                                                        
            for ( ContentVersion cVersion : lstcontentversion ) {
                System.debug(cVersion.id + ':' + cVersion.title);
                contentVersionIdsSet.add( cVersion.Id );
            
            }

            if(contentVersionIdsSet.size() > 0){
                List<Contract> lstContractNew = mapContractNew.values();
                Id conId = lstContractNew[0].id;
                Contract con = [SELECT Id, ASC_Contract_Year__c, CustomerSignedId, CID__c, ASC_Carrier__c FROM Contract WHERE Id =: conId LIMIT 1];
                Id batchprocessid = Database.executeBatch( New ASC_DocStarSubmitAPI( contentVersionIdsSet, con ), 1);
            }  
        } 
    }

}