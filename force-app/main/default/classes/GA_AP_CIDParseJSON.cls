/*****************************************************************************************
Class Name   : GA_AP_CIDParseJSON
Date Created : 01/10/2017
Created By   : IDC Offshore
Description  : 1. This is the class for parsing CID/SMart ID from external system and updating the same in Account record.
******************************************************************************************/
public with sharing class GA_AP_CIDParseJSON{
    
    /**
@Description: GA_AP_CIDParseJSON() method 
@Name : GA_AP_CIDParseJSON
@Param : cls_CreateGroupCustRequest crteRst
@Return : void
@throws Exception : NA;
*/
      public GA_AP_CIDParseJSON(cls_ReqHeaderArea Reqhdrarea,cls_PayloadArea payldareararea)
    {
         headerArea = Reqhdrarea;
         payloadArea =payldareararea;         
        //CreateGroupCustRequest= crteRst;        
     }
     public cls_ReqHeaderArea headerArea;
     public cls_PayloadArea payloadArea;
     //public cls_CreateGroupCustRequest CreateGroupCustRequest;
    
    /**
@Name : cls_CreateGroupCustRequest
*/   
    public with sharing class cls_CreateGroupCustRequest {
        public cls_ReqHeaderArea headerArea;
        public cls_PayloadArea payloadArea;
        
    }
    
    /**
@Name : cls_ReqHeaderArea
*/
    public with sharing class cls_ReqHeaderArea {
        
        public String systemEnvironmentCode;
		public String messageId;    
        	}
    
    /**
@Name : cls_VersionInfo
*/
    public with sharing class cls_VersionInfo {
        public String serviceVersion;   
        public String schemaVersion;    
    }
    
    /**
@Name : cls_Consumer
*/
    public with sharing class cls_Consumer {
        public String ID;   
    }
    
    /**
@Name : cls_PayloadArea
*/
    public with sharing class cls_PayloadArea {
        public String companyName;
		public String dunsNumber;
		public String federalTaxId;
        public cls_Phone phone; 
		public cls_PhysicalAddress physicalAddress;
        public String territoryCode;  
        public String sourceChannel;
    }
    
    /**
@Name : cls_GroupCustomer
*/
    public with sharing class cls_GroupCustomer {
        public String CompanyName;  
        public String FederalTaxID; 
        //public cls_Phone Phone;
        public cls_PhysicalAddress PhysicalAddress;
        public String TerritoryCode;    
    }
    
    /**
@Name : cls_Phone
*/
    public with sharing class cls_Phone {
        public String areaCode;
		public String exchange;
		public String phnNumber;
         
    }
    
    /**
@Name : cls_PhysicalAddress
*/
    public with sharing class cls_PhysicalAddress {
        public String street1;
		public String street2;
        public String city; 
        public String county;   
        public String zip;   
     }
    
}