/**
@Author : Raj Jena
@Name: ASC_CD_DocumentType
@CreatedDate: 12 - Feb 2020 
@Description: ASC_CD_DocumentType class is to update the Signature Required info based upon Document Type.
@version : 1.0  
*/
public with sharing class ASC_CD_DocumentType {
    public static final string CLSNAME  ='ASC_CD_DocumentType';
    public static final string METHODNME  ='updtSignatrReq';
    /*********************************************************************************************************************************
@Description        :   updtSignatrReq() method 
@Name               :   updtSignatrReq
@Param              :   list<ASC_Contractual_Document__c> cdLst,map<id,ASC_Contractual_Document__c> cdoldMap
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/         
    public static void updtSignatrReq(list<ASC_Contractual_Document__c> cdLst,map<id,ASC_Contractual_Document__c> cdoldMap){
        try{ 
            Map<String,ASC_Document_Type_List__mdt> docTypeMap = new Map<String,ASC_Document_Type_List__mdt>();
            Map<String,ASC_ContractualDoc_Sequence_Update__mdt> cdSeqMap = new Map<String,ASC_ContractualDoc_Sequence_Update__mdt>();
            Map<String,ASC_ContractualDoc_Sequence_Update__mdt> cdLabelMap = new Map<String,ASC_ContractualDoc_Sequence_Update__mdt>();
            ASC_Contractual_Document__c oldMap = new ASC_Contractual_Document__c();
            
            if(!cdLst.isEmpty()){
                        
                for(ASC_Document_Type_List__mdt docType :[select ASC_Document_Type_Value__c,
                                                 ASC_Signature_Required__c,
                                                 Document_Language_Required__c  
                                                 from ASC_Document_Type_List__mdt
                                                 Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                   docTypeMap.put(docType.ASC_Document_Type_Value__c,docType);
                }
                
                for(ASC_ContractualDoc_Sequence_Update__mdt cdseq :[select ASC_Contract_Document_Type__c,
                                                 ASC_Sequence__c 
                                                 from ASC_ContractualDoc_Sequence_Update__mdt
                                                 Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                   cdSeqMap.put(cdseq.ASC_Contract_Document_Type__c,cdseq);
                }
                for(ASC_ContractualDoc_Sequence_Update__mdt cdlabel :[select ASC_Contract_Document_Type__c,
                                                 ASC_Contractual_Document_Label__c
                                                 from ASC_ContractualDoc_Sequence_Update__mdt
                                                 Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                   cdLabelMap.put(cdlabel.ASC_Contract_Document_Type__c,cdlabel);
                }
 
                for(ASC_Contractual_Document__c cd : cdLst){ 
                   oldMap = cdoldMap!=null?cdoldMap.get(cd.Id):null;
                   if(docTypeMap.ContainsKey(cd.ASC_Document_Type__c) && (oldMap == null || (oldMap!=null && cd.ASC_Document_Type__c != oldMap.ASC_Document_Type__c))){
                        cd.ASC_Signature_Required__c = docTypeMap.get(cd.ASC_Document_Type__c).ASC_Signature_Required__c;
                        cd.Document_Language_Required__c = docTypeMap.get(cd.ASC_Document_Type__c).Document_Language_Required__c;
                   }
                   if(cdSeqMap.ContainsKey(cd.ASC_Document_Type__c) && (oldMap == null || (oldMap!=null && cd.ASC_Document_Type__c != oldMap.ASC_Document_Type__c))){
                        cd.ASC_Sequence__c = cdSeqMap.get(cd.ASC_Document_Type__c).ASC_Sequence__c;
                   }
                   if(cdSeqMap.ContainsKey(cd.ASC_Document_Type__c) && (oldMap == null || (oldMap!=null && cd.ASC_Document_Type__c != oldMap.ASC_Document_Type__c))){
                        cd.ASC_Contractual_Document_Label__c= cdLabelMap.get(cd.ASC_Document_Type__c).ASC_Contractual_Document_Label__c;
                   }
                }                
            }                            
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    }
}