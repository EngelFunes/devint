/*****************************************************************************************
Class Name   : ARV_AP47_DocusignContractScreen. 
Date Created : 30-DEC-2019
Created By   : IDC Offshore
Description  :This is the class for Docusign Contract screen.
******************************************************************************************/
global with Sharing class ARV_AP47_DocusignContractScreen  implements vlocity_ins.VlocityOpenInterface{
    private static final String GETCONTACTDETAILS='getContactDetails';
    private static final String GETGWCCONTACTDETAILS='getGWCEsignContactDetails';
    private static final String FINALCONTACTNAMES='finalContactName';
    private static final String CONTACTNAMES='ContactNames';
    private static final String CONTACTEMAIL='ContactEmails';
    private static  final String CONTACTQUERY=system.label.ARV_CL45_ContactQuery;
    private static final string CONTACTWHERE= ' Where ARV_Tech_ContractId__c = :paramName ';
    private static final string CONTACTWHEREGWC	= ' Where AccountId=:paramName ';
    private static final string FINALCONTACTID='FinalContactId';
     private static final string CONTEXTID='ContextId';
    private static final string ACCOUNTID='AccountId';
/************************************************************************************
    Method Name : invokeMethod
    Description : This method is used to fetch contact name.
    ************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, 
                          Map<String,Object> outMap, Map<String,Object> options){
        boolean result = true;
        try{
            if(methodName.equalsIgnoreCase(GETCONTACTDETAILS)){
                getContactDetails(inputMap,outMap);                
            }
            if(methodName.equalsIgnoreCase(GETGWCCONTACTDETAILS)){
                getGWCEsignContactDetails(inputMap,outMap);
            }
        }
        catch(Exception e){
            result = false;
        }
        return result;
    }
    
   /************************************************************************************
    Method Name : getContractDetaisl
    Description : This method is  to display  contactDetaisl
    ************************************************************************************/
    public void getContactDetails(Map<String,Object> inputMap,Map<String,Object> outMap){
    string contactId=string.valueof(inputMap.get(CONTEXTID));
    List<string> allContactNames=new list<string>();
     ARV_AP07_QueryDataHelper.paramName= contactId;
     List<Map<String, String>> returnList = new List<Map<String,String>>();
    list<contact> contactList=ARV_AP07_QueryDataHelper.getsObjects(CONTACTQUERY,CONTACTWHERE,NULL,NULL);
     Map<String,String> tempMap = new Map<String,String>();
          for(contact cont:contactList){
            tempMap = new Map<String,String>();
            cont.Title=cont.Title==null?ARV_AP41_StringLiteralUtils.MYBLANKVAL:cont.Title;
            String name=cont.Title ==ARV_AP41_StringLiteralUtils.MYBLANKVAL?cont.Name : cont.Name+ARV_AP41_StringLiteralUtils.HYPHENVAL+cont.Title;            
            tempMap.put(CONTACTNAMES, name);
            tempMap.put(CONTACTEMAIL,cont.Email);
            tempMap.put(FINALCONTACTID,string.valueof(cont.Id));
            returnList.add(tempMap);
            }
        outMap.put(FINALCONTACTNAMES,returnList);   
        
    }
    /************************************************************************************
    Method Name : getContractDetaisl
    Description : This method is  to display  contactDetaisl
    ************************************************************************************/
    global void getGWCEsignContactDetails(Map<String,Object> inputMap,Map<String,Object> outMap){
    string contactId=string.valueof(inputMap.get(ACCOUNTID));
    List<string> allContactNames=new list<string>();
     ARV_AP07_QueryDataHelper.paramName= contactId;
     ARV_AP07_QueryDataHelper.paramName1=null;
     List<Map<String, String>> returnList = new List<Map<String,String>>();
    list<contact> contactList=ARV_AP07_QueryDataHelper.getsObjects(CONTACTQUERY,CONTACTWHEREGWC,NULL,NULL);
     Map<String,String> tempMap = new Map<String,String>();
          for(contact cont:contactList){
            tempMap = new Map<String,String>();
            cont.Title=cont.Title==null?ARV_AP41_StringLiteralUtils.MYBLANKVAL:cont.Title;
            String name=cont.Title ==ARV_AP41_StringLiteralUtils.MYBLANKVAL?cont.Name : cont.Name+ARV_AP41_StringLiteralUtils.HYPHENVAL+cont.Title;            
            tempMap.put(CONTACTNAMES, name);
            tempMap.put(CONTACTEMAIL,cont.Email);
            tempMap.put(FINALCONTACTID,string.valueof(cont.Id));
            returnList.add(tempMap);
            }
        outMap.put(FINALCONTACTNAMES,returnList);   
        
    }
}