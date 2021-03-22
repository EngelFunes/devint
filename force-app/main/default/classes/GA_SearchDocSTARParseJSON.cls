/*****************************************************************************************
Class Name   : GA_SearchDocSTARParseJSON
Date Created : 01/10/2017
Created By   : IDC Offshore
Description  : 1. This is the class for getting Docstar document from external system and show in Account record.
******************************************************************************************/
public with sharing class GA_SearchDocSTARParseJSON {
    /*Constructor*/
    public GA_SearchDocSTARParseJSON(cls_SearchDocSTAR searcDoc)
    {
        SearchDocumentRequest= searcDoc;
    }
    public cls_SearchDocSTAR SearchDocumentRequest;
    /*@Name:cls_SearchDocSTAR*/
    public without sharing class cls_SearchDocSTAR {
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
        public cls_attributeValue AttributeValue;
        public cls_AttributeValueWithLogical[] AttributeValueWithLogical;
        public cls_SortOrder SortBy;
        public string FilterContentAttributes;
    }
    /*@Name:cls_attributeValue*/
    public without sharing class cls_attributeValue{
        public string Name;
        public String Operator;
        public List<String> Value;
    }
    public without sharing class cls_AttributeValueWithLogical {
        public String Name; //eff_date
        public String Operator; //BETWEEN
        public List<String> Value;
        public String LogicalOperator;  //AND
    }
    public without sharing class cls_SortOrder {
        public String AttributeName; // eff_date prev was Name
        public String SortOrder;  //descending
    }
}