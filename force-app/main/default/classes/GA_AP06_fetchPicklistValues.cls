/*****************************************************************************************
Class Name   : GA_AP06_fetchPicklistValues
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to fetch picklist of provided object and field 
******************************************************************************************/
public with sharing class GA_AP06_fetchPicklistValues {
    public static final string ClsName = 'GA_AP06_fetchPicklistValues';
    public static final string getselectOptions = 'getselectOptions';
    public static final string ErrorMsg = 'There is some problem in fetching workflow history';
    public static final string excepSepartr = ' : ';
/**
@Description: getselectOptions() method 
@Name : getselectOptions
@Param :sObject objObject, string fld
@Return : List < String > 
@throws Exception : AuraHandledException;
*/   
     public static List < String > getselectOptions(sObject objObject, string fld) {
         try{
        
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        
        allOpts.sort();
        return allOpts;
         }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, getselectOptions);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }

    
}