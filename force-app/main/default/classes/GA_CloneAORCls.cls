/**
@Author : IDC Offshore
@Name: GA_CloneAORCls
@CreatedDate: 19 - April 2019
@version : 1.0  
*/
public without sharing class GA_CloneAORCls {
    
    public static final String CLONESTR ='_Clone';
    public static final String SRVENDDT = 'GA_Service_End_Date__c';
    public static final String CMMSENDDT ='GA_Commission_End_Date__c';
    public static final String CLNOBJMTHD = 'cloneAnySobjet';
    public static final String CLSNAME = 'GA_CloneAORCls';
    public static final String CLNCHLDRECS = 'cloneChildRecords';
    public static final String FTCHAORCLN =    'fetchAORClone';
    public static final String SPRTR =': ';
    public static final String CMMA =  ',';
    public static final String SLCT = 'SELECT ' ;
    public static final String FRM = ' FROM ';
    public static final String WHRCNCL = ' WHERE GA_Cancel_Flag__c = FALSE AND ';
    public static final String BFRFWDSLSH = ' = \'';
    public static final String AFTFWDSLSH = '\'';
    public static final String WWHRBFRFWDSLSH = ' WHERE ID = \'';
    public static final String BLNK = '';
    public static final String AORGSOBJNM = 'GA_AOR_Group_Segment__c';
    public static final String AORFLD =   'GA_AOR_Id__c';
    public static final Date FUTUREENDDTPLUSONE =   Date.newInstance(2200, 1, 2);
    public static final Date FUTUREENDDT =   Date.newInstance(2200, 1, 1);
    public static string CLONEAORENDDTERROR=system.label.GA_CloneAOREndDtErr;
    public static string ACTIVEAROREXISTSERROR=system.label.GA_AORSrvDateChkError;
    
    /*
@Description: cloneAnySobjet() method 
@Name : gSgmtLst
@Param : string currentId
@Return : List<GA_Group_Segment__c>
@throws Exception : ValidateException;
*/ 
    @AuraEnabled
    public static String cloneAnySobjet(String recordId){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, String> fetchAORCloneExclusionMap = fetchAORCloneExclusionMap();
        String objectAPIName = Id.ValueOf(recordId).getsobjecttype().getDescribe().getName();
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();
        String soqlQuery = SLCT ;
        
        for (String s :fieldMap ){
            if(!fetchAORCloneExclusionMap.containsKey(s))
            {
                soqlQuery +=  + s+CMMA;
            }            
            
        }
        soqlQuery =  soqlQuery.removeEnd(CMMA);
        soqlQuery += FRM +objectAPIName +WWHRBFRFWDSLSH + recordId +AFTFWDSLSH ;
        
        // Quering all the fields from SObject to clone
        SObject record = Database.query(soqlQuery); 
        
        
        record.put(Schema.GA_AOR__c.GA_Prevs_RecordID__c, recordId+CLONESTR);
        if(record.get(SRVENDDT) <> null )
        {
            if(Date.valueOf(record.get(SRVENDDT)) >= FUTUREENDDTPLUSONE ){
            //if(Date.valueOf(record.get(SRVENDDT)) >= FUTUREENDDT ){
               throw new AuraHandledException(CLONEAORENDDTERROR);
                //record.put(Schema.GA_AOR__c.GA_Service_Start_Date__c, FUTUREENDDTPLUSONE);
                //record.put(Schema.GA_AOR__c.GA_Service_End_Date__c	, FUTUREENDDTPLUSONE);
            }
            else
            {
                record.put(Schema.GA_AOR__c.GA_Service_Start_Date__c, Date.valueOf(record.get(SRVENDDT)).adddays(1));
                record.put(Schema.GA_AOR__c.GA_Service_End_Date__c	, FUTUREENDDT);
            }
        }
        else
        {
            record.put(Schema.GA_AOR__c.GA_Service_Start_Date__c, null);
            record.put(Schema.GA_AOR__c.GA_Service_End_Date__c, null);
        }
        
        if(record.get(CMMSENDDT) <> null )
        {
           // if(Date.valueOf(record.get(CMMSENDDT)) >= FUTUREENDDT )  {
           if(Date.valueOf(record.get(CMMSENDDT)) >= FUTUREENDDTPLUSONE )  {
                record.put(Schema.GA_AOR__c.GA_Commission_Start_Date__c, FUTUREENDDT);
                record.put(Schema.GA_AOR__c.GA_Commission_End_Date__c, FUTUREENDDT);
            }   
            else{
               record.put(Schema.GA_AOR__c.GA_Commission_Start_Date__c, Date.valueOf( record.get(CMMSENDDT)).adddays(1));
               record.put(Schema.GA_AOR__c.GA_Commission_End_Date__c, FUTUREENDDT);
            }
        }
        else
        {
            record.put(Schema.GA_AOR__c.GA_Commission_Start_Date__c, null);
            record.put(Schema.GA_AOR__c.GA_Commission_End_Date__c, null);            
        }      
        
        SObject clondedParentRecordID= record.clone(false, true);
        
        try{
            Database.insert(clondedParentRecordID) ;
            return clondedParentRecordID.id ;
            
        }catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, CLNOBJMTHD);
            if(e.getMessage().contains(ACTIVEAROREXISTSERROR))
            {
                throw new AuraHandledException(ACTIVEAROREXISTSERROR);
            }
            else
            {
                throw new AuraHandledException(e.getMessage());
            }
            
            // return BLNK ;             
        }        
    }    
    /*
@Description: Fetching the lsit of values to be excluded while cloning from custom metadata
@Name : fetchAORCloneExclusionMap
@Param : NA
@Return : Map<String, String>
@throws Exception : ValidateException;
*/     
    public static Map<String, String> fetchAORCloneExclusionMap()
    {
        try{
            list<GA_AOR_Clone_Exclusion_List__mdt> clnExclusionList=[select id,Field_API_Name__c from 	GA_AOR_Clone_Exclusion_List__mdt Limit 1000];
            Map<String, String> clnExlusionMap =  new Map <String, String>();
            if(clnExclusionList.size()>0)
            {
                for(integer i=0;i<clnExclusionList.size();i++)
                {
                    String fieldValue=clnExclusionList[i].Field_API_Name__c;
                    clnExlusionMap.put(fieldValue.toLowerCase(),fieldValue.toLowerCase());
                }            
            }
            
            return clnExlusionMap;
        }
        catch(Exception excpDtls){
            return null;
        }
    }
    
    /**
@Description: fetchGroupSegmentClone() method 
@Name : fetchGroupSegmentClone
@Param :null
@Return : GA_Trigger_Functionality_By_Pass__c
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static boolean fetchAORClone(){
        try
        {
            return GA_Trigger_Functionality_By_Pass__c.getInstance().GA_AOR_Custom_Clone__c;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, FTCHAORCLN);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+SPRTR+e.getMessage()); 
        }
    }
    
    /**
@Description: Cloning Group Segment Child records method 
@Name : cloneChildRecords
@Param :null
@Return : void
@throws Exception : AuraHandledException;
*/      
    public static void cloneChildRecords(String objectAPIName, string recordId, string clonedRecordId, string fldname)
    {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();
        String soqlQuery = SLCT ; 
        for (String s :fieldMap ){  
            
            soqlQuery +=  + s+CMMA;  
            
        }
        soqlQuery =  soqlQuery.removeEnd(CMMA);
        soqlQuery += FRM +objectAPIName + WHRCNCL +fldname+BFRFWDSLSH  + recordId +AFTFWDSLSH ;      
        List<sObject> record = Database.query(soqlQuery);     
        List<SObject> lstOfSObjectToBeInserted = new List<SObject>();
        for (sObject eachRec : record) {
            eachRec.put(fldname, clonedRecordId);            
            SObject clondedChildRecordID= eachRec.clone(false, true);
            lstOfSObjectToBeInserted.add(clondedChildRecordID);           
        }
        try{
            Database.insert(lstOfSObjectToBeInserted) ;           
        }catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, CLNCHLDRECS);
        } 
    }  
}