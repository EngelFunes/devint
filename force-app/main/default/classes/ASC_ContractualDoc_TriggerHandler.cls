/**
@Author : Raj Jena
@Name: ASC_ContractualDoc_TriggerHandler
@CreatedDate: 12 - Feb 2020 
@Description: ASC_ContractualDoc_TriggerHandler class is for Contractual Document object.
@version : 1.0  
*/
public with sharing class ASC_ContractualDoc_TriggerHandler {
    public static final string CLSNAME  ='ASC_ContractualDoc_TriggerHandler';
    public static final string METHODNME  ='beforeInsert';
    public static final string METHODNME1  ='beforeUpdate';
    /*******************************************************************************************************************************
@Description        :   beforeInsert() method 
@Name               :   beforeInsert
@Param              :   list<ASC_Contractual_Document__c> cdList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void beforeInsert(list<ASC_Contractual_Document__c> cdList)
    {
        try
        {   if(cdList.size()>0){
            ASC_ContractualDocument_Duplicate.duplicateCheckInsert(cdList);
            ASC_CD_DocumentType.updtSignatrReq(cdList,null);
            ASC_CD_NamingConvention.updtContractDocName(cdList,null);
            ASC_CreateCDRecords.cloneCDRecords(cdList, null);
            ASC_AutoGenerateFiles.invokeCongaTriggerForFilesCreation(cdList, null);
            
        }
         
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    }

    /*******************************************************************************************************************************
@Description        :   beforeUpdate() method 
@Name               :   beforeUpdate
@Param              :   list<ASC_Contractual_Document__c> cdList,map<id,ASC_Contractual_Document__c> cdOldMap
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/         
    public static void beforeUpdate(list<ASC_Contractual_Document__c> cdList, map<id,ASC_Contractual_Document__c> cdOldMap)
    {
        try
        {    
            if(cdList.size()>0){
                ASC_ContractualDocument_Duplicate.duplicateCheckUpdate(cdList,cdOldMap);
                ASC_CD_DocumentType.updtSignatrReq(cdList,cdOldMap);  
                ASC_CD_NamingConvention.updtContractDocName(cdList,cdOldMap);
                ASC_CreateCDRecords.cloneCDRecords(cdList, cdoldMap);
                ASC_AutoGenerateFiles.invokeCongaTriggerForFilesCreation(cdList, cdoldMap);
//ASC_DocuSignAutoGenerateFiles.invokeCongaTriggerForFilesCreation(cdList, cdoldMap);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1);
        }
    }
/*
    public static void ContractualDocumentComplianceStatus(Contract contractRelated){
        //add logic to update only success documents 
        List<ASC_Contractual_Document__c> listContractualDocument = new List<ASC_Contractual_Document__c>([SELECT Id, ASC_Signature_Required__c,ASC_Do_Not_Include__c,  
                                                                                                        ASC_Document_Compliance_Status__c , ASC_Date_Signed__c,ASC_Contract__c  
                                                                                                        FROM ASC_Contractual_Document__c 
                                                                                                        WHERE ASC_Contract__c =: contractRelated.id ]) ;
        listContractualDocument = UpdateDocumentComplianceStatus(listContractualDocument);
        Update listContractualDocument;
    }

    public static void ContractualDocumentComplianceStatus(List<ASC_Contractual_Document__c> listContractualDocument){
        listContractualDocument = UpdateDocumentComplianceStatus( listContractualDocument );
    }
*/
/*    public static List<ASC_Contractual_Document__c> UpdateDocumentComplianceStatus(List<ASC_Contractual_Document__c> listContractualDocument){
        for(ASC_Contractual_Document__c contractualDocument: listContractualDocument){
            if(contractualDocument.ASC_Signature_Required__c == FALSE || contractualDocument.ASC_Do_Not_Include__c == TRUE){
                contractualDocument.ASC_Document_Compliance_Status__c = 'N/A';
            }else if(contractualDocument.ASC_Date_Signed__c != null){
                contractualDocument.ASC_Document_Compliance_Status__c = 'Compliant';
            }else{
                contractualDocument.ASC_Document_Compliance_Status__c = 'Noncompliant';
            }
        }

        return listContractualDocument;
    }
*/
    
}