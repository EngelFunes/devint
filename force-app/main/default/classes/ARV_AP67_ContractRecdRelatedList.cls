/**
@Author : Surya .
@Name: ARV_AP67_ContractRecdRelatedList....
@CreatedDate: 10-Jan-2020
@Description: ARV_AP67_ContractRecdRelatedList Fetching related records of a contract
@version : 1.0 
*/
public without sharing class ARV_AP67_ContractRecdRelatedList {
    private static final String LIMIT4 = ' LIMIT 4';
    private static final String RELATED = 'related';
    private static final String OPEN_BRACE = ' (';
    private static final String CLOSE_BRACE = ')';
    private static final String SELECT_QRY = 'SELECT Id';
    private static final String FROM_QRY = ' FROM ';
    private static final String WHERE_QRY = ' WHERE ';
    private static final String THREE_PLUS_COUNT = '3+';
    private static final String CONTRACT_RENEWAL_QUERY = 'select Id, ARV_Renewal_Status__c,RecordType.Name,ARV_Is_Generate_Renewal__c from Contract ';
    private static final String CONTRACTQUERY = 'select ContractNumber,Status,Is_Document_Generation__c,ARV_Renewal_Status__c,ARV_Default_Delay_Days__c from Contract';
    private static final String CONTRACTWHERECLAUSE=' where id=:paramId1';
    private static final String CONTENT_DOCUMENT_LINK_QRY = 'SELECT ContentDocumentId FROM ContentDocumentLink';
    private static final String CONTENT_DOCUMENT_LINK_WHERE = ' where LinkedEntityId=:paramId5';
    private static final String PROFILE_QRY = 'SELECT Id, Name FROM Profile';
    private static final String CONTENT_VERSION_QRY = 'select id,title,ContentDocument.createdDate,ContentDocumentId from contentversion';
    private static final String CONTENT_VERSION_WHERE = ' WHERE ContentDocumentId in:products';
    private static final String CONTENT_VERSION_ORDER = '  order by createddate asc';
    private static final String CONTENT_VERSION_LIMIT = ' LIMIT 100';
    private static final String METADATA_QRY = 'SELECT MasterLabel, QualifiedApiName,Field_Labels__c FROM ARV_CM05_Related_List__mdt';
    private static final String METADATA_WHERE = ' WHERE SObject_Name__c = :paramName';
    private static final String LIMIT1=' limit 1';
    private static final String CLASS_NAME = 'ARV_AP67_ContractRecdRelatedList';
    private static final String METHOD_NAME = 'updateFileType';
    private static final String EMPTY_STRING = '';
    private static final List<String> FILES_PROFILES = new List<String>{'Small Group Underwriter','Small Group Underwriting Manager'};
    private static final String COMMA_STRING = ',';
    private static final String EMPTY_SPACE_STRING = ' ';
    
    
   /**
@Description: getRstatus() method
@Name : getRstatus
@Param : String recId, String sObjName, String parentFldNam, String strCriteria, String isView
@Return : String value
@throws Exception : N/A;
 
    */
    @AuraEnabled
      public static String getRstatus(Id conId)
      {     String result;
             Contract con=[select id,ARV_Renewal_Status__c from contract where id=:conId];
       if(con.ARV_Renewal_Status__c!=''&& con.ARV_Renewal_Status__c!=NULL)
           result=con.ARV_Renewal_Status__c;
           return result;
          
      }

        /**
@Description: fetchRecs() method
@Name : fetchRecs
@Param : String recId, String sObjName, String parentFldNam, String strCriteria, String isView
@Return : RelatedListResult
@throws Exception : N/A;
*/ 
    
        @AuraEnabled  
        public static RelatedListResult fetchRecs( String recId, String sObjName, String parentFldNam,
                                                  String strCriteria, String isView ) {  
            try{
                ARV_AP07_QueryDataHelper.paramName=sObjName;
                list<ARV_CM05_Related_List__mdt> contractrec =ARV_AP07_QueryDataHelper.getsObjects(METADATA_QRY,
                                                                                                   METADATA_WHERE,NULL,LIMIT1);
                //ARV_CM05_Related_List__mdt sObjeFields = [SELECT MasterLabel, QualifiedApiName,Field_Labels__c FROM ARV_CM05_Related_List__mdt WHERE SObject_Name__c = :sObjName];
                ARV_CM05_Related_List__mdt sObjeFields = contractrec.get(0);
                String fileds = String.isNotBlank(sObjeFields.Field_Labels__c)?COMMA_STRING+sObjeFields.Field_Labels__c:EMPTY_STRING;
                Map<String,String> fieldLables = getObjFieldLabel(sObjName,sObjeFields.Field_Labels__c);
                String strTitle = OPEN_BRACE;           
                List <sObject> listsObjects = new List < sObject >();  
                RelatedListResult obj = new RelatedListResult();  
                String strSOQL = SELECT_QRY+ fileds + FROM_QRY + sObjName + WHERE_QRY + parentFldNam + ' = \'' + recid + '\'';  
                if(String.isNotBlank( strCriteria )) {
                    strSOQL += EMPTY_SPACE_STRING + strCriteria;
                }   
                if(isView==RELATED) {
                    strSOQL += LIMIT4;
                } 
                listsObjects = Database.query( strSOQL );
                if(isView==RELATED) {
                    Integer intCount = listsObjects.size();  
                    if ( intCount > 3 ) {                 
                        List < sObject > tempListsObjects = new List < sObject >();  
                        for ( Integer i = 0; i <3; i++ )  {
                            tempListsObjects.add( listsObjects.get( i ) );   
                        }                    
                        obj.listsObject = tempListsObjects;  
                        strTitle += THREE_PLUS_COUNT;                      
                    } else {                      
                        obj.listsObject = listsObjects;
                        strTitle += String.valueOf( intCount );                    
                    }  
                    strTitle += CLOSE_BRACE;   
                    obj.strTitle = strTitle;
                }
                obj.contractNumber = getContractNumber(recId);
                obj.listsObject = listsObjects; 
                obj.fieldLables = fieldLables;
                return obj;                                           
            } catch( Exception e ) {
                throw new AuraHandledException(e.getMessage());                 
            }             
        } 
    /**
@Description: getObjFieldLabel() method
@Name : getObjFieldLabel
@Param : String sObjName,String fieldStrAPis
@Return : Map<String,String>
@throws Exception : N/A;
*/ 
    public static Map<String,String> getObjFieldLabel( String sObjName,String fieldStrAPis ) {
        List<String> fieldAPis = fieldStrAPis.toLowerCase().split(COMMA_STRING);
        Map<String,String> flables = new Map<String,String>();        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(sObjName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {
            if(fieldAPis.contains(fieldName.toLowerCase())) {
                flables.put(EMPTY_STRING+fieldMap.get(fieldName),fieldMap.get(fieldName).getDescribe().getLabel());
            }
        }
        return flables;
    }
    /**
@Description: getContractNumber() method
@Name : getContractNumber
@Param : String
@Return : String
@throws Exception : N/A;
*/ 
    public static String getContractNumber(String contractId) {
        String contractNumber = EMPTY_STRING;
        ARV_AP07_QueryDataHelper.paramId1=contractId;
        list<Contract>contractrec=ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,
                                                                       CONTRACTWHERECLAUSE,NULL,LIMIT1);
        Contract con= contractrec.get(0);
        contractNumber = con.ContractNumber;
        return contractNumber;
    }
    /**
@Description: getContractStatus() method
@Name : getContractStatus
@Param : String
@Return : String
@throws Exception : N/A;
*/  
    @AuraEnabled
    public static String getContractStatus(String contractId) {
        ARV_AP07_QueryDataHelper.paramId1=contractId;
        list<Contract> contractrec = ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,
                                                                          CONTRACTWHERECLAUSE,NULL,LIMIT1);
        Contract con= contractrec.get(0);
        return con.Status;
    }
/**
@Description: getContractDocGenStatus() method
@Name : getContractDocGenStatus
@Param : String
@Return : String
@throws Exception : N/A;
*/  
    @AuraEnabled
    public static Boolean getContractDocGenStatus(String contractId) {
        Boolean contractDocGenStatus=false;
        ARV_AP07_QueryDataHelper.paramId1=contractId;
        list<Contract> contractrec = ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,
                                                                          CONTRACTWHERECLAUSE,NULL,LIMIT1);
        Contract con= contractrec.get(0);
        return con.Is_Document_Generation__c;
    }
/**
@Description: getContractDetailsSB() method
@Name : getContractDetailsSB
@Param : String
@Return : sbContractDataResult
@throws Exception : N/A;
*/ 
    @AuraEnabled
    public static sbContractDataResult getContractDetails(String contractId)  {
        ARV_AP07_QueryDataHelper.paramId1=contractId;
        list<Contract> contractrec = ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,
                                                                          CONTRACTWHERECLAUSE,NULL,LIMIT1);
        Contract con= contractrec.get(0);
        sbContractDataResult conDetails  = new sbContractDataResult();
        conDetails.contractStatus = getContractStatus(contractId);
        conDetails.isDocGen = getContractDocGenStatus(contractId);
        return conDetails;
    }  
/**
@Description: fileLstRecs() method
@Name : fileLstRecs
@Param : string suppId
@Return : RelatdFilesResult
@throws Exception : N/A;
*/ 
    @AuraEnabled
    public static RelatdFilesResult fileLstRecs(string suppId)
    {   
        try{
            ARV_AP07_QueryDataHelper.paramId5=suppId;
            list<ContentDocumentLink> cntDocLnkLst = ARV_AP07_QueryDataHelper.getsObjects(CONTENT_DOCUMENT_LINK_QRY,
                                                                                          CONTENT_DOCUMENT_LINK_WHERE,NULL,NULL);
            set<id> cntDocIdSet=new set<id>();
            for(ContentDocumentLink cntDoclnk:cntDocLnkLst)
            {
                cntDocIdSet.add(cntDoclnk.ContentDocumentId);  
            }    
            ARV_AP07_QueryDataHelper.products=cntDocIdSet;
            list<contentversion> cntVrsionLst = ARV_AP07_QueryDataHelper.getsObjects(CONTENT_VERSION_QRY,
                                                                                     CONTENT_VERSION_WHERE,CONTENT_VERSION_ORDER,CONTENT_VERSION_LIMIT);
            Map<Id,contentversion> cntVerDocMap = New Map<Id,contentversion>();        
            for(contentversion cntVrsion : cntVrsionLst){
                cntVerDocMap.put(cntVrsion.ContentDocumentId,cntVrsion); 
            }        
            List<contentversion> newcntVrsionLst = New List<contentversion> ();
            for(contentversion ctntVer : cntVerDocMap.values()){
                newcntVrsionLst.add(ctntVer);
            }
            RelatdFilesResult obj = new RelatdFilesResult();
            obj.listsObject = newcntVrsionLst;
            obj.contractNumber = getContractNumber(suppId);
            String userProfileName = getUserProfileName(); 
            obj.userProfileName = userProfileName;
            obj.isShowFiles = FILES_PROFILES.contains(userProfileName)?true:false;
            obj.contractStatus = getContractStatus(suppId);
            return obj;        
        } catch( Exception e ) {
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    /**
@Description: updateFileType() method
@Name : updateFileType
@Param : string docIdLst
@Return : void
@throws Exception : N/A;
*/ 
    @AuraEnabled
    public static void updateFileType(string docIdLst)
    {
        try{            
            set<id> docIds=new set<id>();
            List<DocWrapCls> DocmntsLst = (List<DocWrapCls>)JSON.deserialize(docIdLst, List<DocWrapCls>.class);
            for(docWrapCls doc:DocmntsLst)
            {
                docIds.add(doc.documentId);
            }
            list<contentversion> cntvLst=[select id from contentversion where ContentDocumentId in:docIds];
            list<contentversion> cntvLstToUpdt=new list<contentversion>();
            for(contentversion cntv:cntvLst)
            {
                cntvLstToUpdt.add(cntv);
            }            
            database.update(cntvLstToUpdt);
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLASS_NAME, METHOD_NAME);
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
@Description: getUserProfileName() method
@Name : getUserProfileName
@Param : N/A
@Return : Boolean
@throws Exception : N/A;
*/ 
    @AuraEnabled
    public static String getUserProfileName(){
        Boolean isShowFiles = false;
        ARV_AP07_QueryDataHelper.paramId1=userinfo.getProfileId();
        list<Profile> profileDetails = ARV_AP07_QueryDataHelper.getsObjects(PROFILE_QRY,
                                                                            CONTRACTWHERECLAUSE,NULL,LIMIT1);
        return profileDetails[0].Name;
    }
    /**
    Method Name : getRenewalStatusVal
    Description : returns the renewal status value of contract.
    */ 
    @AuraEnabled
    public static ContractReadOnlyWrapper getRenewalStatusVal(Id conId) {
        try{
            system.debug('sdlfjasd->'+conId);
            ContractReadOnlyWrapper cntrtWrapper = new ContractReadOnlyWrapper();
            ARV_AP07_QueryDataHelper.paramId1=conId;
            String renewalstatus;
            List<Contract> con=ARV_AP07_QueryDataHelper.getsObjects(CONTRACT_RENEWAL_QUERY,CONTRACTWHERECLAUSE,NULL,LIMIT1);
            system.debug('querresult->'+con);
            //renewalstatus=con.get(0).ARV_Renewal_Status__c;
            cntrtWrapper.contractRenewalStatus = String.isEmpty(con.get(0).ARV_Renewal_Status__c)?'':con.get(0).ARV_Renewal_Status__c;
            cntrtWrapper.profileName = getUserProfileName();
            cntrtWrapper.generateRenewal = con.get(0).ARV_Is_Generate_Renewal__c;
            cntrtWrapper.recType=  String.isEmpty(con.get(0).RecordType.Name)?'':con.get(0).RecordType.Name;

            return cntrtWrapper;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }        
    }
     /**
@Description: getTypeValues() method
@Name : getTypeValues
@Param : N/A
@Return : List<Strin>
@throws Exception : N/A;
*/ 
    /*@AuraEnabled
    public static Map<string,string> getTypeValues()
    {
         Map<string,string> options = new  Map<string,string>();
        Schema.DescribeFieldResult fieldResult =ContentVersion.GA_Type__C.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         for( Schema.PicklistEntry flsVal : ple)
        {
           options.put(flsVal.getValue(), flsVal.getLabel());
        }  
       return options;
    }*/
    /**
@Description: RelatedListResult wrapper class
@Name : RelatedListResult
*/ 
    public class RelatedListResult { 
        @AuraEnabled  
        public String strTitle;  
        @AuraEnabled  
        public List <sObject> listsObject=new List <sObject>();
        @AuraEnabled  
        public Map<String,String> fieldLables = new Map<String,String>();
        @AuraEnabled  
        public String contractNumber; 
    }
    /**
@Description: DocWrapCls wrapper class
@Name : DocWrapCls
*/  
    public class DocWrapCls{
        string name;
        string documentId;
    }
   
    /**
    @Description: RelatdFilesResult wrapper class
    @Name : RelatdFilesResult
    */  
    public class RelatdFilesResult{
        @AuraEnabled  
        public List<ContentVersion> listsObject = new List<ContentVersion>();
        @AuraEnabled  
        public String contractNumber;
        @AuraEnabled  
        public String userProfileName;
        @AuraEnabled  
        public Boolean isShowFiles; 
        @AuraEnabled
        public String contractStatus;
    }
    /**
    @Description: ContractReadOnlyWrapper wrapper class
    @Name : ContractReadOnlyWrapper
    */  
    public class ContractReadOnlyWrapper {
        @AuraEnabled  
        public String contractRenewalStatus;
        @AuraEnabled  
        public String profileName;
        @AuraEnabled
        public Boolean generateRenewal;
        @AuraEnabled
         public String recType;
    }
/************************************************
@Description: sbContractDataResult wrapper class
@Name : sbContractDataResult
*************************************************/ 
    public class sbContractDataResult{
        @AuraEnabled  
        public String contractStatus;
        @AuraEnabled  
        public Boolean isDocGen; 
    }
}