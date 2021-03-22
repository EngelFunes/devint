public with sharing class AP90_Q2E_STRUCT_DocStar_Submit {
   public cls_RtrvDocSTAR StoreDocumentRequest;
    
    public AP90_Q2E_STRUCT_DocStar_Submit(cls_RtrvDocSTAR subDoc) {
        StoreDocumentRequest = subDoc;
    }
    public class cls_RtrvDocSTAR {
        public cls_ReqHeaderArea ReqHeaderArea;
        public cls_PayloadArea PayloadArea;
        
    }
    public class cls_ReqHeaderArea {
        public cls_VersionInfo VersionInfo;
        public cls_Consumer Consumer;

        public String CreationDateTime;  
        public String MessageID;  
    }
    public class cls_VersionInfo {
        public String ServiceVersion;  
        public String SchemaVersion;  
    }
    public class cls_Consumer {
        public String ID;
        public String Name;
    }
     public class cls_PayloadArea {
        public List<cls_attributeValue> Attribute;

        public String RepositoryName;
        public String FolderName;
        public String Id;
        public String Password;  
        public String fileContent;     
    }
    /*@Name:cls_attributeValue*/
    public class cls_attributeValue{
        public String Name;
        public String Value;
    }
}