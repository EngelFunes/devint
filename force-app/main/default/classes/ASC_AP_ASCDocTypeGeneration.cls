public without sharing class ASC_AP_ASCDocTypeGeneration
{
    public static final string clsName  ='ASC_AP_ASCDocTypeGeneration';
    public static final string fetchDocGenAccessMthd  ='fetchDocGenAccess';
    public static final string createDocTypeRecMthd  = 'createDocTypeRec';
    public static final String excepSepartr=': ';
   
    @AuraEnabled
    public static ASC_Contractual_Document__c fetchDocGenAccess(string cntrctlDcmtId, integer instanceNumbr){
   
            ASC_Contractual_Document__c cntrctlDcmtRec = [select id,Name,ASC_Document_Type__c,Document_Version__c,Document_Source__c,ASC_Contract__r.CID__c,ASC_Contract__r.ASC_Carrier__c,ASC_Contract__r.ContractNumber from ASC_Contractual_Document__c where id =: cntrctlDcmtId limit 1];
           
        if(cntrctlDcmtRec.ASC_Document_Type__c != null && 
               (cntrctlDcmtRec.Document_Version__c != null && cntrctlDcmtRec.Document_Version__c != 'N/A' ))
            {
                createDocTypeRec(cntrctlDcmtId,instanceNumbr);
            }
           return cntrctlDcmtRec;
      
    }
    
    
    
    Public static void createDocTypeRec(string cntrctlDcmtId, integer instanceNumbr)
    {
        try{
            ASC_Contractual_Document__c cntrctlDcmtRec = [select id,ASC_Document_Type__c,Document_Source__c,Document_Version__c,ASC_Contract__c,
                                                          ASC_Contract__r.Id from ASC_Contractual_Document__c where id =: cntrctlDcmtId limit 1];
            string contractId = cntrctlDcmtRec.ASC_Contract__r.Id ;
            system.debug('contractId '+contractId);
            List<vlocity_ins__ContractLineItem__c> CntrcLinItemLst = [select id,Name,vlocity_ins__ContractId__c,vlocity_ins__ContractId__r.id,
                                                                      vlocity_ins__Product2Id__c,vlocity_ins__ParentItemId__c,vlocity_ins__ParentItemId__r.vlocity_ins__Product2Id__c
                                                                      from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__r.id=:contractId];
            List<ASC_Document_Type_Record__c> docTypRecInsrtLst = new List<ASC_Document_Type_Record__c> (); 
               system.debug('CntrcLinItemLst '+CntrcLinItemLst);
            if(CntrcLinItemLst.Size() > 0)
            {
                for(vlocity_ins__ContractLineItem__c cntrctLineItm:CntrcLinItemLst )
                {
                    List<Product_Document_Mapping__c> prdctDocMapingLst = [select id,Name,Coverage_Product__c,Parent_Product__c
                                                                           from Product_Document_Mapping__c where Coverage_Product__c =: cntrctLineItm.vlocity_ins__Product2Id__c and
                                                                          Parent_Product__c=: cntrctLineItm.vlocity_ins__ParentItemId__r.vlocity_ins__Product2Id__c];
                    if(prdctDocMapingLst.Size() > 0)
                    {
                        system.debug('prdctDocMapingLst '+prdctDocMapingLst);
                        for(Product_Document_Mapping__c prdctDocMaping : prdctDocMapingLst )
                        {
                            ASC_Document_Type_Record__c docTypRec = new ASC_Document_Type_Record__c ();
                            docTypRec.Name=cntrctLineItm.Name + ' _ ' + 'PDM';
                            docTypRec.Contract_Line_Item__c = cntrctLineItm.id;
                            docTypRec.Product_Document_Mapping__c = prdctDocMaping.id;
                            docTypRec.Instance__c = instanceNumbr;
                            docTypRecInsrtLst.add(docTypRec);
                        }
                    }
                }
            }
            if(docTypRecInsrtLst.size()>0)
            {
                database.insert(docTypRecInsrtLst);
            }
       }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, clsName, createDocTypeRecMthd);}
    }
    
    
}