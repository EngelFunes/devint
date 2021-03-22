/*****************************************************************************************
Class Name   : ARV_AP04_SBCParserJSON 
Date Created : 3-MAY-2019
Created By   : IDC Offshore
Description  : This class is used to parse JSON String for SBC
******************************************************************************************/
public without sharing class ARV_AP04_SBCParserJSON {
        public Cls_CreateDocRequest CreateDocRequest;
        /*Constructor*/
        public ARV_AP04_SBCParserJSON(Cls_CreateDocRequest crteDocRqst)
        {
            CreateDocRequest= crteDocRqst;
        }
        /*@Name:cls_CreateDocRequest*/
        public without sharing class Cls_CreateDocRequest {
            public Cls_ReqHeaderArea ReqHeaderArea;
            public Cls_PayloadArea PayloadArea;
        }
        /*@Name:cls_ReqHeaderArea*/
        public without sharing class Cls_ReqHeaderArea {
            public Cls_VersionInfo VersionInfo;
            public String CreationDateTime;  
            public String MessageID;  
            public Cls_Consumer Consumer;
        }
        /*@Name:cls_VersionInfo*/
        public without sharing class Cls_VersionInfo {
            public String ServiceVersion; 
            public String SchemaVersion;  
        }
        /*@Name:cls_Consumer*/
        public without sharing class Cls_Consumer {
            public String ID;  
            public String Name;  
        }
         /*@Name:cls_corporatestring*/
         public without sharing class Cls_corporatestring
          {
                  public string Code;
          }
        /*@Name:cls_PayloadArea*/
        public without sharing class Cls_PayloadArea {
            public String BusinessChannel;  
            public String IncludeAttachmentInd; 
            public string EffectiveDate;
            public list<Cls_corporatestring> CorporateForm=null;
            public Cls_CoverageInfo CoverageInfo;
            public Cls_TemplateInfo TemplateInfo;
            public Cls_TrackingInfo TrackingInfo;
        }
      
          /*@Name:cls_CoverageInfo*/
        public without sharing class Cls_CoverageInfo {
            public string URL;
            public string TollFreeNumber;
            public String CoverageFor;  
            public string PlanType;
            public string PlanName;
            public string GroupName;
            public string CoveragePeriod;
        }  
        /*@Name:cls_TrackingInfo*/
        public without sharing class Cls_TrackingInfo {
            public String ID;  
            public String UserType;  
            public String UserID; 
            public String BusinessArea; 
            public String AppTriggerEvent;  
            public Cls_RequestorInfo RequestorInfo;
            public string QuoteID;
            public string Contract;
        }
        /*@Name:cls_RequestorInfo*/
        public without sharing class Cls_RequestorInfo {
            public Cls_Name Name;
            public String Email;  
        }
        /*@Name:cls_Name*/
        public without sharing class Cls_Name {
            public String First; 
            public String Last;  
        }
          /*@Name:cls_TemplateInfo*/
        public without sharing class Cls_TemplateInfo {
            public String DocType;  
        }
}