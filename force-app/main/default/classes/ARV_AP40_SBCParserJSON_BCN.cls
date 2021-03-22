/*****************************************************************************************
Class Name   : ARV_AP40_SBCParserJSONBCN 
Date Created : 23-july-2019
Created By   : IDC Offshore
Description  : This class is used to parse JSON Strings..
******************************************************************************************/
public without sharing class ARV_AP40_SBCParserJSON_BCN {
public Cls_CreateDocRequest_BCN CreateDocRequest;
        /*Constructor*/
        public ARV_AP40_SBCParserJSON_BCN(Cls_CreateDocRequest_BCN crteDocRqst)
        {
            CreateDocRequest= crteDocRqst;
        }
        /*@Name:cls_CreateDocRequest*/
        public without sharing class Cls_CreateDocRequest_BCN {
            public Cls_ReqHeaderArea_BCN ReqHeaderArea;
            public Cls_PayloadArea_BCN PayloadArea;
        }
        /*@Name:cls_ReqHeaderArea*/
        public without sharing class Cls_ReqHeaderArea_BCN {
            public Cls_VersionInfo_BCN VersionInfo;
            public String CreationDateTime;  
            public String MessageID;  
            public Cls_Consumer_BCN Consumer;
        }
        /*@Name:cls_VersionInfo*/
        public without sharing class Cls_VersionInfo_BCN {
            public String ServiceVersion; 
            public String SchemaVersion;  
        }
        /*@Name:cls_Consumer*/
        public without sharing class Cls_Consumer_BCN {
            public String ID;  
            public String Name;  
        }
         
        /*@Name:cls_PayloadArea*/
        public without sharing class Cls_PayloadArea_BCN {
            public String BusinessChannel;  
            public String RiderString;
            public string EffectiveDate;
            public String IncludeAttachmentInd; 
            public Cls_CoverageInfo_BCN CoverageInfo;
            public Cls_TemplateInfo_BCN TemplateInfo;
            public Cls_TrackingInfo_BCN TrackingInfo;
        }
      
          /*@Name:cls_CoverageInfo*/
        public without sharing class Cls_CoverageInfo_BCN {
            public string CoveragePeriod;
            public String CoverageFor; 
            public string GroupName;
            public string PlanName;
            public string PlanType;
            public string URL;
            public string TollFreeNumber;
             
        }  
        /*@Name:cls_TrackingInfo*/
        public without sharing class Cls_TrackingInfo_BCN {
            public String BusinessArea;
            public String AppTriggerEvent;
            public String UserType;
            public Cls_RequestorInfo_BCN RequestorInfo;
            
        }
        /*@Name:cls_RequestorInfo*/
        public without sharing class Cls_RequestorInfo_BCN {
            public Cls_Name_BCN Name;
            public String Email;  
        }
        /*@Name:cls_Name*/
        public without sharing class Cls_Name_BCN {
            public String First; 
            public String Last;  
        }
          /*@Name:cls_TemplateInfo*/
        public without sharing class Cls_TemplateInfo_BCN {
            public String DocType;  
        }
}