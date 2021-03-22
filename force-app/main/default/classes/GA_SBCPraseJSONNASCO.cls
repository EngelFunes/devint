/*****************************************************************************************
Class Name   : GA_SBCPraseJSONNASCO
Date Created : 6/21/2018
Created By   : IDC Offshore
Description  : 1. This is the class for getting SBC document from external system.
******************************************************************************************/
public with sharing class GA_SBCPraseJSONNASCO{
    public cls_CreateDocRequest CreateDocRequest;
    /*Constructor*/
    public GA_SBCPraseJSONNASCO(cls_CreateDocRequest crteDocRqst)
    {
        CreateDocRequest= crteDocRqst;
    }
    /*@Name:cls_CreateDocRequest*/
    public without sharing class cls_CreateDocRequest {
        public cls_ReqHeaderArea ReqHeaderArea;
        public cls_PayloadArea PayloadArea;
    }
    /*@Name:cls_ReqHeaderArea*/
    public without sharing class cls_ReqHeaderArea {
        public string systemEnvironmentCode;
        public cls_VersionInfo VersionInfo;
        public String CreationDateTime;	//2017-10-27T09:39:10.416
        public String MessageID;	//10/27/2017 9:39:10:AM
        public cls_Consumer Consumer;
    }
    /*@Name:cls_VersionInfo*/
    public without sharing class cls_VersionInfo {
        public String ServiceVersion;	//1.0
        public String SchemaVersion;	//1.0.0
    }
     /*@Name:cls_Consumer*/
    public without sharing class cls_Consumer {
        public String ID;	//cssbcgen
        public String Name;	//Benefit Factory
    }
    /*@Name:cls_PayloadArea*/
    public without sharing class cls_PayloadArea {
        public String BusinessChannel;	//BCBSM
        public String PreGenInd;	//Y
        public cls_GroupInfo GroupInfo;
        public cls_CoverageInfo CoverageInfo;
        public cls_TemplateInfo TemplateInfo;
        public cls_TrackingInfo TrackingInfo;
    }
    /*@Name:cls_GroupInfo*/
    public without sharing class cls_GroupInfo {
        public String mosInd;
        public String GrpNumber;	//007002427
        public String Suffix;
        public String PackageCode;
    }
    /*@Name:cls_CoverageInfo*/
    public without sharing class cls_CoverageInfo {
        public cls_GroupInfoForOverlay GroupInfoForOverlay;
        public String CoverageFor;	//Individual/Family
    }
    /*@Name:cls_GroupInfoForOverlay*/
    public without sharing class cls_GroupInfoForOverlay {
        public String GrpNumber;	//007002427
        public String Suffix;	//0001
        public String PackageCode;	//0684N
    }
    /*@Name:cls_TemplateInfo*/
    public without sharing class cls_TemplateInfo {
        public String DocType;	//PDF
    }
     /*@Name:cls_TrackingInfo*/
    public without sharing class cls_TrackingInfo {
        public String ID;	//007009359-0004
        public String UserType;	//Employee
        public String UserID;	//e131541
        public String BusinessArea;	//Benefit Factory
        public String AppTriggerEvent;	//Upon Request
        public cls_RequestorInfo RequestorInfo;
    }
    /*@Name:cls_RequestorInfo*/
    public without sharing class cls_RequestorInfo {
        public cls_Name Name;
        public String Email;	//RSchram@bcbsm.com
    }
    /*@Name:cls_Name*/
    public without sharing class cls_Name {
        public String First;	//Robert
        public String Last;	//Schram
    }
}