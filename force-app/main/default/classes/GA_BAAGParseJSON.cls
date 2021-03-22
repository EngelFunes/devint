/**
@Author : padmahaarika jayana
@Name: GA_BAAGParseJSON
@CreatedDate: 1/17/2018  
@Description: GA_BAAGParseJSON class is for hitting Baag Services
@version : 1.0  
*/ 
public without sharing class GA_BAAGParseJSON {

    public cls_CreateBenefitDocRequest CreateBenefitDocRequest;
    /**constructor**/
    public GA_BAAGParseJSON(cls_CreateBenefitDocRequest crteBenfRqst)
    {
        CreateBenefitDocRequest= crteBenfRqst;
    }
    /**Inner Class-cls_CreateBenefitDocRequest**/
    public without sharing class cls_CreateBenefitDocRequest {
        public cls_ReqHeaderArea ReqHeaderArea;
        public cls_PayloadArea PayloadArea;
    }
    /**Inner Class-cls_ReqHeaderArea**/
    public without sharing class cls_ReqHeaderArea {
        public String systemEnvironmentCode;	
        public cls_VersionInfo VersionInfo;
        public String CreationDateTime;
        public String MessageID;	
        public cls_Consumer Consumer;
    }
    /**Inner Class-cls_VersionInfo**/
    public without sharing class cls_VersionInfo {
        public String ServiceVersion;	
        public String SchemaVersion;	
    }
    /**Inner Class-cls_Consumer**/
    public without sharing class cls_Consumer {
        public String ID;	
        public String Name;	
    }
    /**Inner Class-cls_PayloadArea**/
    public without sharing class cls_PayloadArea {
        public cls_GroupInfo GroupInfo;
        public cls_BenefitInfo BenefitInfo;
        public cls_BenefitKey BenefitKey;
        public String DocType;	
        public String IncludeAttachmentInd;	
        public String MOSInd;	
        public String RequestType;	
        public String RetrieveBenefitInd;	
        public cls_TrackingInfo TrackingInfo;
        public string EffectiveDate;
    }
    /**Inner Class-cls_GroupInfo**/
    public without sharing class cls_GroupInfo {
        public String groupNo;	
        public String Section; 
    }
    /**Inner Class-cls_BenefitInfo**/
    public without sharing class cls_BenefitInfo {
        public String GroupName;	
        public String GroupNumber;	
    }
    /**Inner Class-cls_BenefitKey**/
    public without sharing class cls_BenefitKey {
        public String BPID;	
    }
    /**Inner Class-cls_TrackingInfo**/
    public without sharing class cls_TrackingInfo {
        public String AppTriggerEvent;	
        public String BusinessArea;	
        public String QuoteID;	
        public cls_RequestorInfo RequestorInfo;
        public String UserID;	
        public String UserType;	
        public string ID;
    }
    /**Inner Class-cls_RequestorInfo**/
    public without sharing class cls_RequestorInfo {
        public cls_Name Name;
        public String Email;	
    }
    /**Inner Class-cls_Name**/
    public without sharing class cls_Name {
        public String First;	
        public String Last;	
    }
}