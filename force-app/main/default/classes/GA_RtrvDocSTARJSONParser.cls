/*****************************************************************************************
Class Name   : GA_RtrvDocSTARJSONParser
Date Created : 01/10/2017
Created By   : IDC Offshore
Description  : 1. This is the class for getting Docstar document from external system and show in Account record.
******************************************************************************************/
public with sharing class GA_RtrvDocSTARJSONParser {
    /*Constructor*/
     public GA_RtrvDocSTARJSONParser(cls_RtrvDocSTAR rtrvDoc)
    {
        RetrieveDocumentRequest = rtrvDoc;
    }
    
    public cls_RtrvDocSTAR RetrieveDocumentRequest;
    /*@Name:cls_RtrvDocSTAR*/
    public without sharing class cls_RtrvDocSTAR {
        public cls_ReqHeaderArea ReqHeaderArea;
        public cls_PayloadArea PayloadArea;
        
    }
    /*@Name:cls_ReqHeaderArea*/
    public without sharing class cls_ReqHeaderArea {
        public cls_VersionInfo VersionInfo;
        public String CreationDateTime;	
        public String MessageID;	
        public cls_Consumer Consumer;
        public String systemEnvironmentCode;	
    }
    /*@Name:cls_VersionInfo*/
    public without sharing class cls_VersionInfo {
        public String ServiceVersion;	
        public String SchemaVersion;	
    }
    /*@Name:cls_Consumer*/
    public without sharing class cls_Consumer {
        public String ID;	
    }
    /*@Name:cls_PayloadArea*/
     public without sharing class cls_PayloadArea {
        public string  DataMapName;
        public string Id;
        public string Password;        
        public List<cls_attributeValue> Attribute;
    }
    /*@Name:cls_attributeValue*/
    public without sharing class cls_attributeValue{
        public string Name;
        public String Value;
    }
}