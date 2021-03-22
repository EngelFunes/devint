/**
@Author : Prasant ksatpathy 
@Name: GA_SBCBCNParseJSON
@CreatedDate: 2/9/2018  
@Description: GA_SBCBCNParseJSON class is for hitting SBCBCN Services
@version : 1.0  
*/ 
public without sharing class GA_SBCBCNParseJSON{
    public cls_CreateDocRequest CreateDocRequest;
    
    /****constructor****/
    public GA_SBCBCNParseJSON(cls_CreateDocRequest crteDocRqst)
    {
        CreateDocRequest= crteDocRqst;
    }
    /****Inner Class -cls_CreateDocRequest****/
    public without sharing class cls_CreateDocRequest {
        public cls_ReqHeaderArea ReqHeaderArea;
        public cls_PayloadArea PayloadArea;
    }
    /****Inner Class -cls_ReqHeaderArea****/
    public without sharing class cls_ReqHeaderArea {
        
        public cls_VersionInfo VersionInfo;
        public String CreationDateTime;	//2018-01-25T09:39:10.416
        public String MessageID;	//10/27/2017 9:39:10:AM
        public cls_Consumer Consumer;
    }
    /****Inner Class-cls_VersionInfo****/
    public without sharing class cls_VersionInfo {
        public String ServiceVersion;	//1.0
        public String SchemaVersion;	//1.0.0
    }
    /****Inner Class-cls_Consumer****/
    public without sharing class cls_Consumer {
        public String ID;	//cssalesforce
        public String Name;	//Blue eSolutions
    }
    /****Inner Class-cls_PayloadArea****/
    public without sharing class cls_PayloadArea {
        public String BusinessChannel;	//BCN
        public String RiderString;	//98185MI0160001
        public String IncludeAttachmentInd;	//Y
        public cls_CoverageInfo CoverageInfo;
        public cls_TemplateInfo TemplateInfo;
        public cls_TrackingInfo TrackingInfo;
    }
    /****Inner Class-cls_CoverageInfo****/
    public without sharing class cls_CoverageInfo {
        public String CoveragePeriod;	//Beginning on or after 02/01/2017
        public String CoverageFor;	//Individual/Family
        public String GroupName;	//TEST0916
        public String PlanName;	//BCN Classic HMO $1000-20% VA
        public String PlanType;	//HMO
        public String URL;	//www.bcbsm.com
        public String TollFreeNumber;	//1-800-465-5199
    }
    /****Inner Class_cls_TemplateInfo****/
    public without sharing class cls_TemplateInfo {
        public String DocType;	//PDF
    }
    /****Inner Class_cls_TrackingInfo****/
    public without sharing class cls_TrackingInfo {
        public String ID;	//007009359-0004
        public String UserType;	//Employee
        public String UserID;	//e131541
        public String BusinessArea;	//Benefit Factory
        public cls_Contract Contract;
        public String QuoteID;	//SF66887174
        public String AppTriggerEvent;	//Upon Request
        public cls_RequestorInfo RequestorInfo;
    }
    /****Inner Class_cls_Contract****/
    public without sharing class cls_Contract {
    }
    /****Inner Class_cls_RequestorInfo****/
    public without sharing class cls_RequestorInfo {
        public cls_Name Name;
        public String Email;	//RSchram@bcbsm.com
    }
    /****Inner Class_cls_Name****/
    public without sharing class cls_Name {
        public String First;	//Robert
        public String Last;	//Schram
    }
}