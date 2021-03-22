/*****************************************************************************************
Class Name   : ARV_AP08_DMLHelper
Date Created : 28-July-2019
Created By   : IDC Offshore
Description  :This is used for DML operations.
*******************************************************************************/
public without sharing class ARV_AP08_DMLHelper {
        private static final String EXCEPSEPRATR=': ';
     private static final string CLSNAME  ='ARV_AP08_DMLHelper';
    private static final string METHODNAME  ='insertSObjects';
    private static final String ERRORMSG='Unable to retrieve SBC Document';
     /****************************************************************************************************
    Method Name : insertAttachmentOnQuote
    Parameters  : List sObjects
    Return type : void
    Description : This method is used to perform the DML operations on sObjects.
    *****************************************************************************************************/
    public static list<Database.SaveResult> insertSObjects(List<sObject> objList,string operationType,Boolean saveType){  
        Database.SaveResult[] srList=null;
        try{
            if(!objList.isEmpty()){
                if(operationType==ARV_AP41_StringLiteralUtils.TYPEINSERT){
                    srList = Database.insert(objList, saveType);
                }else if(operationType==ARV_AP41_StringLiteralUtils.TYPEUPDATE){
                    srList = Database.update(objList, saveType);
                }
                else if(operationType==ARV_AP41_StringLiteralUtils.TYPEUPSERT){
                    Database.upsert(objList, saveType);
                }
                else if(operationType==ARV_AP41_StringLiteralUtils.TYPEDELETE){
                    Database.delete(objList, saveType);
                }
                else{
                    
                }
            }
        }  
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPRATR+e.getMessage());
        }
        return srList;
    }
}