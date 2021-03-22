/*****************************************************************************************
Class Name   : ARV_AP10_BAAGParserJSON 
Date Created : 03-MAY-2019
Created By   : IDC Offshore
Description  : This class is used for JSONParser
******************************************************************************************/
public without sharing class ARV_AP10_BAAGParserJSON {
    
    public Cls_CreateBenefitDocRequest CreateBenefitDocRequest;
    /*constructor*/
    public ARV_AP10_BAAGParserJSON(Cls_CreateBenefitDocRequest crteBenfRqst)
    {
        CreateBenefitDocRequest= crteBenfRqst;
    }
    /***cls_CreateBenefitDocRequest***/
    public without sharing class Cls_CreateBenefitDocRequest {
        public cls_ReqHeaderArea ReqHeaderArea;
        public cls_PayloadArea PayloadArea;
    }
    /***cls_ReqHeaderArea***/
    public without sharing class Cls_ReqHeaderArea {
        public String systemEnvironmentCode;    
        public cls_VersionInfo VersionInfo;
        public String CreationDateTime;
        public String MessageID;    
        public cls_Consumer Consumer;
    }
    /***cls_VersionInfo***/
    public without sharing class Cls_VersionInfo {
        public String ServiceVersion;   
        public String SchemaVersion;    
    }
    /***cls_Consumer***/
    public without sharing class Cls_Consumer {
        public String Name; 
        public String ID;   
    }
    
    /***cls_PayloadArea***/
    public without sharing class Cls_PayloadArea {
        public Date EffectiveDate;
        public list<cls_corporatestring> CorporateForm;
        public Cls_BenefitInfo BenefitInfo;
        public String IncludeAttachmentInd;
        public String mosInd;
        public String OverlayInd;
        public String RequestType;
        public String RetrieveBenefitInd;
        public cls_TrackingInfo TrackingInfo;
        
        
    }
     /**Cls_BenefitInfo**/
    public without sharing class Cls_BenefitInfo
    {
        public string GroupName;
    }
    /**cls_corporatestring**/
    public without sharing class Cls_corporatestring
    {
        public string Name;
    }
    /***cls_TrackingInfo***/
    public without sharing class Cls_TrackingInfo {
        public String AppTriggerEvent;  
        public String BusinessArea;
        public string ID;
        public String QuoteID;  
        public cls_RequestorInfo RequestorInfo;
        public String RequiredDate;
        public String UserID;   
        public String UserType; 
        
    }
    /***cls_RequestorInfo***/
    public without sharing class Cls_RequestorInfo {
        public cls_Name Name;
        public String Email;
    }
    /***cls_Name***/
    public without sharing class Cls_Name {
        public String First;    
        public String Last; 
    }
    
}