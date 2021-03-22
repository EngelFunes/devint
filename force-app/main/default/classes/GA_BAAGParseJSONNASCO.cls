/**
@Author : Prasant Kumar Satpathy
@Name: GA_BAAGParseJSONNASCO
@CreatedDate: 6/26/2018 
@Description: GA_ACTPLN01_RecList class is viewing and creating action plan related list in Account record page.
@version : 1.0  
*/
public without sharing class GA_BAAGParseJSONNASCO {
    
    public cls_CreateBenefitDocRequest CreateBenefitDocRequest;
    /*constructor*/
    public GA_BAAGParseJSONNASCO(cls_CreateBenefitDocRequest crteBenfRqst)
    {
        CreateBenefitDocRequest= crteBenfRqst;
    }
    /***cls_CreateBenefitDocRequest***/
    public without sharing class cls_CreateBenefitDocRequest {
        public cls_ReqHeaderArea ReqHeaderArea;
        public cls_PayloadArea PayloadArea;
    }
    /***cls_ReqHeaderArea***/
    public without sharing class cls_ReqHeaderArea {
        public String systemEnvironmentCode;	
        public cls_VersionInfo VersionInfo;
        public String CreationDateTime;
        public String MessageID;	
        public cls_Consumer Consumer;
    }
    /***cls_VersionInfo***/
    public without sharing class cls_VersionInfo {
        public String ServiceVersion;	
        public String SchemaVersion;	
    }
    /***cls_Consumer***/
    public without sharing class cls_Consumer {
        public String ID;	
        public String Name;	
    }
    /***cls_PayloadArea***/
    public without sharing class cls_PayloadArea {
        public String BusinessChannel;
        public cls_GroupInfo GroupInfo;
        public String DocType;
        public String IncludeAttachmentInd;
        public String mosInd;
        public String OverlayInd;
        public String RequestType;
        public String RetrieveBenefitInd;
        public cls_TrackingInfo TrackingInfo;
        public String PackageCode;
        public String PublishDocInd;
    }
    /***cls_GroupInfo***/
    public without sharing class cls_GroupInfo {
        public String mosInd;
        public String groupNo;	
        public String Section; 
    }
    /***cls_TrackingInfo***/
    public without sharing class cls_TrackingInfo {
        public String AppTriggerEvent;	
        public String BusinessArea;	
        public String QuoteID;	
        public String RequiredDate;
        public cls_RequestorInfo RequestorInfo;
        public String UserID;	
        public String UserType;	
        public string ID;
    }
    /***cls_RequestorInfo***/
    public without sharing class cls_RequestorInfo {
        public cls_Name Name;
        public String Email;
        public String Phone;
    }
    /***cls_Name***/
    public without sharing class cls_Name {
        public String First;	
        public String Last;	
    }
}