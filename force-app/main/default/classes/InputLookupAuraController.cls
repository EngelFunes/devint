/*
* Author: Enrico Murru (http://enree.co, @enreeco)
*/
public with sharing class InputLookupAuraController {
    
    public static final String caseObj = 'Case';
    public static final String searchString1 = '\'*';
    public static final String searchString2 = '*\'';
    public static final String qryFind = 'FIND :searchString IN NAME FIELDS RETURNING ';
    public static final String qryId = '(Id, ';
    public static final String qryOrdrBy = '  ORDER BY ';
    public static final String qryOrdrByAcc = ' where accountid =: accId AND (RecordTypeId =: sprtRequestId OR RecordTypeId =: wstMichiganId)  ORDER BY ';
    public static final String qryLimit = ') LIMIT 20';
    public static final String idVal = 'Id';
    public static final String nameVal = 'Name';
    public static final String qrySelect = 'Select Id, ';
    public static final String qryFrom = ' From ';
    public static final String whereClause = ' Where Id = \'';
    public static final String qrySelectString = '\'';
    public Static final String supportReqRecType = 'Support - Request';
    public Static final String wstMichignRecType = 'Support - Support / West Michigan';
    public Static final Id sprtRequestId = Schema.SObjectType.Case.RecordTypeInfosByName.get(supportReqRecType).RecordTypeId;
    public Static final Id wstMichiganId = Schema.SObjectType.Case.RecordTypeInfosByName.get(wstMichignRecType).RecordTypeId;
    public static final String blank = '';
    public static final String accObj = 'Account';
    public static final String soslFnd ='FIND ';
    public static final String soslNameFld =' IN NAME FIELDS RETURNING ';
    public static final String soslAllFlds = ' IN ALL FIELDS RETURNING ';
    public static final String whrId ='(Id, ';
    public static final String whrIdCID ='(Id,CID__c  ORDER BY ';
    public static final String lmit =') LIMIT 20';
    public static final String userObj = 'User';
    public static final String bcnQualityStp = 'BCN Quality';
    public static final String rcBuddyCheckStp = 'RC Buddy Check';
    public static final String seBuddyCheckStp = 'SE Buddy Check';
    public static final String whrUsrRole = ' where GA_RoleName__c IN ';
    public static final String clsngBrcs = ')';
    public static final String whraccId = ' where accountid =\'';
    public static final String whrrcrdId = '\' AND (RecordTypeId =\'';
    public static final String orRcrdId = '\' OR RecordTypeId =\'';
    public static final String ordrByCaseNo = '\')  ORDER BY CaseNumber) LIMIT 20';
    
    /*
* Loads the initial value of the given SObject type with ID "value"
*/
    @AuraEnabled
    public static String getCurrentValue(String type, String value,string srchntName){
        if(String.isBlank(type)){
            return null;
        }
        
        ID lookupId = null;
        try{   
            lookupId = (ID)value;
        }catch(Exception e){
            return null;
        }
        
        if(String.isBlank(lookupId)){
            return null;
        }
        
        SObjectType objType = Schema.getGlobalDescribe().get(type);
        if(objType == null){
            return null;
        }
        
        String nameField = getSobjectNameField(objType,srchntName);
        String query = qrySelect +nameField+ qryFrom +type+ whereClause +lookupId+ qrySelectString;
        
        List<SObject> oList = Database.query(query);
        if(oList.size()==0) {
            return null;
        }
        return (String) oList[0].get(nameField);
    }
    
    /*
* Utility class for search results
*/
    public class SearchResult{
        public String value{get;Set;}
        public String id{get;set;}
    }
    
    /*
* Returns the "Name" field for a given SObject (e.g. Case has CaseNumber, Account has Name)
*/
    private static String getSobjectNameField(SobjectType sobjType, string srchntName){
        
        //describes lookup obj and gets its name field
        String nameField = nameVal;
        Schema.DescribeSObjectResult dfrLkp = sobjType.getDescribe();
        for(schema.SObjectField sotype : dfrLkp.fields.getMap().values()){
            Schema.DescribeFieldResult fieldDescObj = sotype.getDescribe();
            if(srchntName ==blank)
            {
                if(fieldDescObj.isNameField() ){
                    nameField = fieldDescObj.getName();
                    break;
                }
            }
            else
            {
                nameField = srchntName;
                break;
                
            }
            
        }
        
        return nameField;
    }
    
    /*
* Searchs (using SOSL) for a given Sobject type
*/
    @AuraEnabled
    public static String searchSObject(String type,String stepName, String searchString,String accId,String srchntName){
        try
        {
            if(String.isBlank(type) || String.isBlank(searchString)){
                return null;
            }
            
            SObjectType objType = Schema.getGlobalDescribe().get(type);
            if(objType == null){
                return null;
            }
            
            String nameField = getSobjectNameField(objType,srchntName);
            searchString = searchString1 +searchString+ searchString2;
            
            
            String soslQuery ;
            
            
            if(type <> caseObj){
                
                
                if(type != accObj){
                    if(type == userObj){
                        
                            Set<string> rolenms = New Set<String>();
                            List<String> rolenmsLst = New List<String>();
                            for(GA_Workflow_Step_Role__mdt wfStpMDT : [SELECT GA_Workflow_Step__c, GA_Applicable_Role__c 
                                                                       FROM GA_Workflow_Step_Role__mdt
                                                                       Limit 200])
                            {
                                if(stepName == wfStpMDT.GA_Workflow_Step__c && !string.isBlank(wfStpMDT.GA_Applicable_Role__c))
                                {
                                    rolenmsLst=wfStpMDT.GA_Applicable_Role__c.split(';');    
                                }
                            }
                            if(rolenmsLst.size()>0){
                                for(String rl : rolenmsLst)
                                {
                                    rolenms.add(rl);
                                }
                                string roleLst = GA_Util08_FilterProcessHelper.strSet(rolenms);
                            
                                soslQuery=soslFnd+searchString+soslNameFld
                                    + type +whrId+nameField+whrUsrRole+roleLst+')';
                            }
                            else{
                            soslQuery=soslFnd+searchString+soslNameFld
                                + type +whrId+nameField+qryOrdrBy+nameField+lmit;
                        }
                        
                        
                    }
                    else{
                        soslQuery=soslFnd+searchString+soslNameFld
                            + type +whrId+nameField+qryOrdrBy+nameField+lmit;
                    }
                }
                else 
                {
                    soslQuery=soslFnd+searchString+soslAllFlds
                        + type +whrIdCID+nameField+lmit; 
                }
                
            }
            else {
                
                soslQuery=soslFnd+searchString+soslNameFld+type+whrId+nameField+whraccId+ accId+whrrcrdId+ sprtRequestId+orRcrdId+ wstMichiganId+ordrByCaseNo;
                
            }
            
            
            List<List<SObject>> results =  Search.query(soslQuery);
            
            List<SearchResult> output = new List<SearchResult>();
            if(results.size()>0){
                for(SObject sobj : results[0]){
                    SearchResult sr = new SearchResult();
                    sr.id = (String)sobj.get(idVal);
                    sr.value = (String)sobj.get(nameField);
                    output.add(sr)   ;
                }
            }
            return JSON.serialize(output);    
        }
        catch(exception e)
        {
            throw new AuraHandledException(e.getMessage()); 
        }
        
    }
}