/**
@Author : Offshore
@Name: ASC_ContractualDocument_Duplicate
@CreatedDate: 28 - July 2020 
@Description: ASC_ContractualDocument_Duplicate class is to check the duplicate values info based upon Document Type.
@version : 1.0  
*/
public with sharing class ASC_ContractualDocument_Duplicate 
{
    public static void duplicateCheckInsert(list<ASC_Contractual_Document__c> cdList){
    system.debug('Inside&&&&');
        Set<String> ContractId = new Set<String>();
        for(ASC_Contractual_Document__c ASCContractual : cdList)
        {
            ContractId.add(ASCContractual.ASC_Contract__c);
        }
        
        if(ContractId.size() > 0 )
        {
            List<ASC_Contractual_Document__c> ContractualDocQuery = [select id,Name,ASC_Contract__c,ASC_Document_Type__c from ASC_Contractual_Document__c where ASC_Contract__c in :ContractId ];
            system.debug('ListQuery&&&&&'+ContractualDocQuery);
            Map<String ,ASC_Contractual_Document__c> DoctypeMap = new Map<String,ASC_Contractual_Document__c>();
            for(ASC_Contractual_Document__c ASCCon: ContractualDocQuery)
            {
                DoctypeMap.put(ASCCon.ASC_Document_Type__c ,ASCCon);
            }
            
            for(ASC_Contractual_Document__c ASCCon : cdList)
            {
                if(DoctypeMap.containsKey(ASCCon.ASC_Document_Type__c))
                {
                    ASCCon.addError('The contractual document of this document type already exists. ');
                  
                }
            }
            
        }
    }
    /*******************************************************************************************************************************
@Description        :   duplicateCheckUpdate() method 
@Name               :   duplicateCheckUpdate
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/         
    public static void duplicateCheckUpdate(list<ASC_Contractual_Document__c> cdList,map<id,ASC_Contractual_Document__c> cdOldMap){
       system.debug('Inside+++++');
        Set<String> ContractId = new Set<String>();
        for(ASC_Contractual_Document__c ASCContractual : cdList)
        {
            ContractId.add(ASCContractual.ASC_Contract__c);
        }
        
        if(ContractId.size() > 0 )
        {
            List<ASC_Contractual_Document__c> ContractualDocQuery = [select id,Name,ASC_Contract__c,ASC_Document_Type__c from ASC_Contractual_Document__c where ASC_Contract__c in :ContractId ];
            system.debug('ListQuery++++'+ContractualDocQuery);
            Map<String ,ASC_Contractual_Document__c> DoctypeMap = new Map<String,ASC_Contractual_Document__c>();
            for(ASC_Contractual_Document__c ASCCon: ContractualDocQuery)
            {
                DoctypeMap.put(ASCCon.ASC_Document_Type__c ,ASCCon);
            }
            for(ASC_Contractual_Document__c ASCCon:cdList){
                if(DoctypeMap.containsKey(ASCCon.ASC_Document_Type__c)){
                    if((ASCCon.ASC_Document_Type__c != cdOldMap.get(ASCCon.id).ASC_Document_Type__c)){
                        ASCCon.addError('The contractual document of this document type already exists. ');
                    }
                }
            }
        }
    }
}