/*****************************************************************************************
Class Name   : GA_SBCParseJSON
Date Created : 1/31/2018
Created By   : IDC Offshore
Description  : 1. This is the class for getting SBC document from external system and show in Plan Package.
******************************************************************************************/
public without sharing class GA_SBCParseJSON{
    public cls_CreateDocRequest CreateDocRequest;
    /***constructor***/
    public GA_SBCParseJSON(cls_CreateDocRequest crteDocRqst)
    {
        CreateDocRequest= crteDocRqst;
    }
    /***Inner Class***/
    public without sharing class cls_CreateDocRequest {
        public cls_ReqHeaderArea ReqHeaderArea;
        public cls_PayloadArea PayloadArea;
    }
    /***Inner Class***/
    public without sharing class cls_ReqHeaderArea {
        public string systemEnvironmentCode;
        public cls_VersionInfo VersionInfo;
        public String CreationDateTime;	//2017-10-27T09:39:10.416
        public String MessageID;	//10/27/2017 9:39:10:AM
        public cls_Consumer Consumer;
    }
    /***Inner Class***/
    public without sharing class cls_VersionInfo {
        public String ServiceVersion;	//1.0
        public String SchemaVersion;	//1.0.0
    }
    /***Inner Class***/
    public without sharing class cls_Consumer {
        public String ID;	//cssbcgen
        public String Name;	//Benefit Factory
    }
    /***Inner Class***/
    public without sharing class cls_PayloadArea {
        public String BusinessChannel;	//OBI
        public String BPID;	//0684N
        public String IncludeAttachmentInd;	//Y
        public String PreGenInd;	//Y
        public String PublishDocInd;	//N
        public cls_GroupInfo GroupInfo;
        public cls_CoverageInfo CoverageInfo;
        public cls_TemplateInfo TemplateInfo;
        public cls_TrackingInfo TrackingInfo;
    }
    /***Inner Class***/
    public without sharing class cls_GroupInfo {
        public String GrpNumber;	//007002427
        public String Suffix;
    }
    /***Inner Class***/
    public without sharing class cls_CoverageInfo {
        public String CoveragePeriod;
        public cls_GroupInfoForOverlay GroupInfoForOverlay;
        public String CoverageFor;	//Individual/Family
        public String URL;	//www.bcbsm.com
    }
    /***Inner Class***/
    public without sharing class cls_GroupInfoForOverlay {
        public String mosInd;	//Y
        public String GrpNumber;	//007002427
        public String Suffix;	//0001
        public String PackageCode;	//0684N
    }
    /***Inner Class***/
    public without sharing class cls_TemplateInfo {
        public String DocType;	//PDF
    }
    /***Inner Class***/
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
    /***Inner Class***/
    public without sharing class cls_Contract {
    }
    /***Inner Class***/
    public without sharing class cls_RequestorInfo {
        public cls_Name Name;
        public String Email;	//RSchram@bcbsm.com
    }
    /***Inner Class***/
    public without sharing class cls_Name {
        public String First;	//Robert
        public String Last;	//Schram
    }
}