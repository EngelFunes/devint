/*********************************************************************************************************
Class Name   : ARV_AP91_UpdateGATypeOnContVersion
Date Created : 26-MAr-2020
Created By   : IDC Offshore
Description  : 1.This is used for mapping File category on ContentVersion GA_TYPE Picklist
               2.It is used PDF/Upload Omniscript,whenever user uploads file based on its code on filename 
                 It uses ARV_CM07_MappFileCodesforContractDocs__mdt to map respective value on GA_Type field
                 on ContentVersion Object
************************************************************************************************************/
global without sharing class ARV_AP91_UpdateGATypeOnContVersion implements vlocity_ins.VlocityOpenInterface2 {
    private static final string CLSNAME='ARV_AP91_UpdateGATypeOnContVersion';
    private static final string UPDATEGATYPE_MTHD='updateGATypeonfile';
    private static final string CONTEXTID='ContextId';
    private static final string HYPHEN='-';
    private static final string DOT='.';
    private static Map <String,String>codeFileTypeMap;
/*********************************************************************************************************
Method Name   : invokeMethod
Parameters    : String methodName, Map <String,Object>input,Map <String,Object>outMap, Map <String,Object>options
Description   : This is VlocityHelper Method from which calls Main Method
************************************************************************************************************/   
 global Boolean invokeMethod(String methodName, Map <String,Object>input,Map <String,Object>outMap, Map <String,Object>options) {
    Boolean result = true;
    try {
        if (UPDATEGATYPE_MTHD.equals(methodName)){
            updateGATypeonfile(input, outMap, options);
        }
    }
    catch (Exception ex){GA_LogExceptionCls.LogExcp(ex, CLSNAME, UPDATEGATYPE_MTHD);}
    return result;
 }
/*********************************************************************************************************
Method Name   : updateGATypeonfile
Parameters    : Map <String,Object>input,Map <String,Object>outMap, Map <String,Object>options
Return Type   : Void
Description   : This is Main Method which calls helper method to update ContentVersion
************************************************************************************************************/ 
    private static void updateGATypeonfile(Map <String,Object> input, Map <String,Object> outMap, Map <String,Object> options) {
        String contractId = string.valueOf(options.get(CONTEXTID));
        set<Id> ContdocIds = New Set <Id> ();
            for (ContentDocumentLink cdl: [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: contractId]) {
            ContdocIds.add(cdl.ContentDocumentId);
            }
        updatecontVersionfieldType(ContdocIds);

    }
/*********************************************************************************************************
Method Name   : updatecontVersionfieldType
Parameters    : Set<Id> Ids
Return Type   : Void
Description   : This IS helper method to update ContentVersion SOBJECT
************************************************************************************************************/ 
    private static void updatecontVersionfieldType(Set<Id>Ids) {
        codeFileTypeMap= New Map <String,String> ();
         ARV_CM07_MappFileCodesforContractDocs__mdt[]  cmdvals = [Select DeveloperName, File_Name__c, Type__c from ARV_CM07_MappFileCodesforContractDocs__mdt];
			for (ARV_CM07_MappFileCodesforContractDocs__mdt cmdata: cmdvals) {
                   codeFileTypeMap.put(cmdata.DeveloperName,cmdata.Type__c);
            }
        List <contentversion> updtCVLst = new List <contentversion> ();
            for (contentversion cvl: [select id, title, GA_Type__c, ContentDocumentId from contentversion where ContentDocumentId in:Ids limit 100]) {
                string fileCodeVal = null;
                If(cvl.title.contains(HYPHEN)){
                    cvl.Title=cvl.Title.substringBeforeLast(DOT);
                    fileCodeVal= cvl.Title.split(HYPHEN)[0];
                    cvl.GA_Type__c = preparegaTypeVal(fileCodeVal);
                    updtCVLst.add(cvl);
                }
            }
        Database.update(updtCVLst);
    }
/*********************************************************************************************************
Method Name   : prepareGaTypeVal
Parameters    : string gaTypeCode
Return Type   : Void
Description   : This Method prepares GA type Value based on file codes from ARV_CM07_MappFileCodesforContractDocs__mdt Metadata Type
************************************************************************************************************/ 
    private static string prepareGaTypeVal(string gaTypeCode) {
        String gatypeVal = null;
        if (codeFileTypeMap.containskey(gaTypeCode)){
                gatypeVal = codeFileTypeMap.get(gaTypeCode);
        }
        return gatypeVal;
    }
}