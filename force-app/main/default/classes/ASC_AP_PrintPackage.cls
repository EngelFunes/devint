/**
@Author : Mida
@Name: ASC_AP_PrintPackage
@CreatedDate:  23-July-2020 
@Description: ASC_AP_PrintPackage class is used to generate package using combination of files.
@version : 1.0  
*/
public without sharing class ASC_AP_PrintPackage {
    
    private static final String SALESFORCE_GENERATED = 'Salesforce Generated';
    private static final List<String> PERMISSIONSETNAMES = new List<String>{'ASC_Sales_Specialist'};
        @AuraEnabled
        public static Map<String,String> processControlsForPackageGen(String contractId){
            
            Map<String,String> processControlMap = new Map<String,String>();
            Boolean hasAccess = false;
            String userId =  UserInfo.getUserId();
            String packageName = '';
            User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
            String userRoleName =userDetails.UserRole.Name; 
            system.debug('userRoleName '+userRoleName);
            
            /*TD-1844 Added By Dinesh - ASC Sales specialist permission set should be able to access Print Package button. */
            List<PermissionSetAssignment> userpermissionSet = [select PermissionSet.Name from PermissionSetAssignment 
                                                               where AssigneeId =:UserInfo.getUserId() 
                                                               AND PermissionSet.Name IN:PERMISSIONSETNAMES
                                                               Limit :UTIL_SLB.retrieveQueryLimitValue()];
            
            /*TD-1844 - End */
            if(userDetails.Profile.Name.equals('System Administrator') || (userRoleName != null && userRoleName.contains('GOR')) || !userpermissionSet.isEmpty())
            {
                hasAccess = true;           
            }
            else
            {
                hasAccess = false;
                processControlMap.put('HasAccess','This feature is only available to GOR users.');
            }
            
            if(hasAccess == true)
            {
                List<ASC_Contractual_Document__c> cntrctlDcmtRecList = [select id,Name,ASC_Document_Type__c,Document_Version__c,
                                                                        ASC_Contract__r.CID__c,ASC_Contract__r.ASC_Carrier__c,
                                                                        ASC_Contract__r.Status,ASC_Contract__r.ASC_Contract_Year__c,
                                                                        ASC_Contract__r.Account.Name,ASC_Document_Language__c,
                                                                        Document_Language_Required__c,ASC_Document_Language__r.ASC_Document_Language_State__c,
                                                                        Doc_Reference_Year__c,Stop_Loss_Amendment_Reference__c 
                                                                        from ASC_Contractual_Document__c where ASC_Contract__c =: contractId 
                                                                        and ASC_Do_Not_Include__c = False 
                                                                        AND Document_Source__c =:SALESFORCE_GENERATED 
                                                                        AND (ASC_Document_Type__c = 'Contract Amendment'
                                                                             OR ASC_Document_Type__c = 'Schedule A - Ex 2'
                                                                             OR ASC_Document_Type__c = 'Stop-Loss Amendment')
                                                                        ORDER BY ASC_Document_Type__c                                                                                                                                                    
                                                                        Limit 100];
                
                /*TD-1165 - Added By Dinesh - Start */
                List<Contract> contrRec = [Select id,CID__c,ASC_Carrier__c,ASC_Contract_Year__c,Account.Name,Status from Contract where Id =:contractId LIMIT 1];
                if(!contrRec.isEmpty()){
                    packageName = contrRec[0].CID__c+'_'+contrRec[0].ASC_Carrier__c+'_'+contrRec[0].ASC_Contract_Year__c+'_ASC_PKG_'+contrRec[0].Account.Name;               
                    processControlMap.put('PackageName',packageName);
                    processControlMap.put('ContractStatus',contrRec[0].Status);
                }
                /*TD-1165 - Added By Dinesh - End */                                                      
                List<ContentDocumentLink> cdl = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: contractId limit 1];
                if(cdl != null && cdl.size()>0)
                {
                    delete cdl;
                }            
                if(cntrctlDcmtRecList != null && cntrctlDcmtRecList.size()>0)
                {
                    String docLangRequiredValidation ='';
                    String incompleteData = '';
                    String docLangStatus = '';
                    for(integer i=0;i<cntrctlDcmtRecList.size();i++)
                    {
                        ASC_Contractual_Document__c eachCDRec = cntrctlDcmtRecList[i];
                        if(eachCDRec.ASC_Document_Type__c.equals('Contract Amendment'))
                        {
                            if(eachCDRec.Document_Language_Required__c == True && eachCDRec.ASC_Document_Language__c == null)
                            {
                                docLangRequiredValidation = 'Contract Amendment';                            
                            }
                            if(eachCDRec.Doc_Reference_Year__c == null || eachCDRec.Doc_Reference_Year__c.equals('9999'))
                            {
                                incompleteData = 'Contract Amendment';
                            }
                            if(eachCDRec.ASC_Document_Language__c != null && eachCDRec.ASC_Document_Language__r.ASC_Document_Language_State__c.equals('Deleted'))
                            {
                                docLangStatus = 'Contract Amendment';
                            }
                        }
                        else if(eachCDRec.ASC_Document_Type__c.equals('Schedule A - Ex 2'))
                        {
                            if(eachCDRec.Document_Language_Required__c == True && eachCDRec.ASC_Document_Language__c == null)
                            {
                                docLangRequiredValidation = docLangRequiredValidation +', Schedule A - Ex 2';                            
                            }
                            if(eachCDRec.Doc_Reference_Year__c == null || eachCDRec.Doc_Reference_Year__c.equals('9999'))
                            {
                                incompleteData = incompleteData +', Schedule A - Ex 2';
                            }
                            if(eachCDRec.ASC_Document_Language__c != null && eachCDRec.ASC_Document_Language__r.ASC_Document_Language_State__c.equals('Deleted'))
                            {
                                docLangStatus = docLangStatus +', Schedule A - Ex 2';
                            }
                        }
                        else if(eachCDRec.ASC_Document_Type__c.equals('Stop-Loss Amendment'))
                        {
                            if(eachCDRec.Document_Language_Required__c == True && eachCDRec.ASC_Document_Language__c == null)
                            {
                                docLangRequiredValidation = docLangRequiredValidation +', Stop-Loss Amendment';
                            }
                            if(eachCDRec.Stop_Loss_Amendment_Reference__c == null || eachCDRec.Stop_Loss_Amendment_Reference__c == '')
                            {
                                incompleteData = incompleteData +', Stop-Loss Amendment'; 
                            }
                            if(eachCDRec.ASC_Document_Language__c != null && eachCDRec.ASC_Document_Language__r.ASC_Document_Language_State__c.equals('Deleted'))
                            {
                                docLangStatus = docLangStatus +', Stop-Loss Amendment';
                            }
                        }  
                        /* 
if(eachCDRec.ASC_Document_Language__c != null && eachCDRec.ASC_Document_Language__r.ASC_Document_Language_State__c.equals('Deleted'))
{
docLangStatus = docLangStatus +', Stop-Loss Amendment';
}*/          
                    }
                    
                    if(!docLangRequiredValidation.equals(''))
                    {
                        docLangRequiredValidation = docLangRequiredValidation.removeEnd(',');
                        docLangRequiredValidation = docLangRequiredValidation.removeStart(',');
                        processControlMap.put('DocLangRequired','The package cannot be generated. The document language is missing for '+docLangRequiredValidation+ ' contractual documents');
                    }
                    else if(!incompleteData.equals(''))
                    {
                        incompleteData = incompleteData.removeEnd(',');
                        incompleteData = incompleteData.removeStart(',');
                        processControlMap.put('incompleteData','The data required for contractual documents '+ incompleteData +' is incomplete or invalid. Please check all the related contractual documents and associated document languages.');
                    }
                    else if(!docLangStatus.equals(''))
                    {
                        docLangStatus = docLangStatus.removeEnd(',');
                        docLangStatus = docLangStatus.removeStart(',');
                        processControlMap.put('docLangStatus','The document language attached to the contractual documents '+ docLangStatus +' is not in a Draft or Active Status.');
                    }                
                    
                }    
            }
            system.debug('processControlMap '+processControlMap);
            return processControlMap;        
        }
    
    @AuraEnabled
    public static Map<String,String> fetchContractualDocuments(String contractId){
        try
        {   
            Map<String,String> cdFileIdMap = new Map<String,String>();
            Map<String,ASC_Contractual_Document__c> cdDetailsMap = new Map<String,ASC_Contractual_Document__c>();
            // Getting the list of Contractual Documents associated with the Contract.
            List<ASC_Contractual_Document__c> cntrctlDcmtRecList = [select id,Name,ASC_Document_Type__c,Document_Version__c,
                                                                    ASC_Contract__r.CID__c,ASC_Contract__r.ASC_Carrier__c,
                                                                    ASC_Sequence__c,Document_Source__c from ASC_Contractual_Document__c
                                                                    where ASC_Contract__c =: contractId and ASC_Do_Not_Include__c = False
                                                                    //AND Document_Source__c =:SALESFORCE_GENERATED
                                                                    ORDER BY ASC_Sequence__c limit 100]; 
            
            if(cntrctlDcmtRecList !=null && cntrctlDcmtRecList.size()>0)
            {
                for(ASC_Contractual_Document__c eachCD : cntrctlDcmtRecList)
                {
                    cdDetailsMap.put(eachCD.ASC_Document_Type__c,eachCD);                                   
                }
                
                system.debug('cdDetailsMap '+cdDetailsMap);
                
                //Get the File Ids associated with each Contractual Documents.
                cdFileIdMap = fetchContractualDocumentsFileIds(cdDetailsMap);
            }      
            return cdFileIdMap;
        }
        catch(exception e)
        { GA_LogExceptionCls.LogExcp(e, 'ASC_AP_PrintPackage', 'fetchContractualDocuments');
         throw new AuraHandledException(e.getMessage()); 
        }
    }
    
    @AuraEnabled
    public static Map<String,String> fetchContractualDocumentsFileIds(Map<String,ASC_Contractual_Document__c> cdDetailsMap){
        
        Map<String,String> cdFileIdMap = new Map<String,String>();
        
        for (String key : cdDetailsMap.keySet()) {
            // The "key" variable is also available inside the loop
            ASC_Contractual_Document__c eachCD = cdDetailsMap.get(key);
            // ... logic to get the File Ids
            List<ContentDocumentLink> contentDocLink = [SELECT ContentDocumentId,SystemModstamp FROM ContentDocumentLink 
                                                        where LinkedEntityId = :eachCD.Id 
                                                        and LinkedEntity.Type='ASC_Contractual_Document__c' 
                                                        ORDER BY SystemModstamp DESC  limit 100];
            system.debug('contentDocLink'+contentDocLink);
            if(contentDocLink != null && contentDocLink.size()>0)
            {
                system.debug('Document_Source__c'+eachCD.Document_Source__c);
                if(eachCD.Document_Source__c != null && eachCD.Document_Source__c.equals('Manual'))
                {
                    for(ContentDocumentLink cdlRec:contentDocLink)
                    {
                        ContentDocument cdRec = [select id,Title from ContentDocument where Id =:cdlRec.ContentDocumentId limit 1];
                        String name = cdRec.Title;
                        system.debug('name'+name);
                        if(!name.contains('_SF_Gen'))
                        {
                            cdFileIdMap.put(eachCD.ASC_Document_Type__c,cdlRec.ContentDocumentId);
                            break;
                        }                   
                    }
                }
                else
                {
                    cdFileIdMap.put(eachCD.ASC_Document_Type__c,contentDocLink[0].ContentDocumentId);
                }                
            }            
        }
        if(cdDetailsMap.size() != cdFileIdMap.size())
        {
            cdFileIdMap.put('DocMissing','Required Documents are missing.Please check all Contractual Document Records.');
        }
        system.debug('cdFileIdMap '+cdFileIdMap);
        return cdFileIdMap;
    }
}