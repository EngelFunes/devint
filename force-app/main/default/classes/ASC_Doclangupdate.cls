/******************************************************************************************************************************************
@Author : Sandeep
@Name: ASC_Doclangupdate
@CreatedDate: 18 - Aug - 2020 
@Description: 
@version : 1.0  
*****************************************************************************************************************************************/
public class ASC_Doclangupdate {
    
    public static boolean isExecuting = false;
    private static final string CLSNAME  ='ASC_Doclangupdate';
    private static final string DOCLANGTEXTUPDATION  ='docLanguageTextUpdation';
    private static final string CREATEDOCLANGRECORDS  ='createDocLangRecords';
    
    public static void docLanguageTextUpdation(list<ASC_Document_Language__c> doclList,map<id,ASC_Document_Language__c> doclOldMap)
    { 
        try{
            
            Integer Year = Date.Today().Year();
            
            List<ASC_Document_Language__c> dlStatusUpdate = new List<ASC_Document_Language__c>();
            map<id,ASC_Document_Language__c> DlStatus = doclOldMap;
            
            Set<Id> docLangTemplateId = new Set<Id>();
            Map<Id,String> dLstatusMap = new Map<Id,String>();
            
                for(ASC_Document_Language__c doc:doclList){
                    if(doc.Update_Quote_Specific_Language__c&&doc.Template__c){
                        docLangTemplateId.add(doc.Id);
                    }
                }
                
                List<ASC_Document_Language__c> updtDocLan = new List<ASC_Document_Language__c>();
                if(!docLangTemplateId.isEmpty()){
                    
                    for(ASC_Document_Language__c doclRec :[SELECT Id,IsDeleted, Name, 
                                                           Template_Used__r.ASC_Product__c,
                                                           Template_Used__r.ASC_Effective_Date__c, 
                                                           Template_Used__r.ASC_End_Date__c, 
                                                           ASC_Description__c, 
                                                           Template_Used__r.ASC_Document_Type__c,
                                                           Template_Used__r.ASC_Description__c,
                                                           Template_Used__r.ASC_When_Used__c, 
                                                           Template_Used__r.ASC_Document_Language_Text__c, 
                                                           Template_Used__r.ASC_Base_Contract__c,
                                                           Template_Used__r.ASC_Confidential__c,
                                                           Template_Used__r.ASC_Estimated_Outstanding_Liability_EOL__c,
                                                           Template_Used__r.ASC_Is_Subrogated__c, 
                                                           Template_Used__r.ASC_Compliance_Start_Date__c,
                                                           Template_Used__r.ASC_Term_Clause_Duration__c, 
                                                           Template_Used__r.ASC_Date_Signed__c,
                                                           Template_Used__r.ASC_Need_To_be_Signed_By__c, 
                                                           Template_Used__r.ASC_Approved_for_Contracting__c,
                                                           Template_Used__r.ASC_Legal_Approval_Date__c,
                                                           Template_Used__r.ASC_Document_Language_State__c,
                                                           Template_Used__r.Account_Name__c, 
                                                           Template_Used__r.Carrier__c,ASC_Document_Language_State__c,
                                                           Template_Used__r.Renewal_Year__c,
                                                           Template_Used__c,
                                                           Renewal_Year__c,
                                                           Update_Quote_Specific_Language__c,                                                       
                                                           ASC_Document_Type__c,
                                                           ASC_Document_Language_Text__c,
                                                           ASC_Quote__c                                                       
                                                           FROM ASC_Document_Language__c 
                                                           where ASC_Document_Language_State__c!='Deleted' and
                                                           ASC_Quote__r.Status!='Rejected' and Template_Used__c IN:docLangTemplateId]){
                                                           dLstatusMap.put(doclRec.Id,doclRec.ASC_Document_Language_State__c);
                                                       if(doclRec.Renewal_Year__c==String.valueOf(Year) ||doclRec.Renewal_Year__c==String.valueOf(Year+1)){
                                                           doclRec.ASC_Document_Language_State__c='Deleted';                                                                    
                                                           updtDocLan.add(doclRec);                          
                                                       }
                     }
                }
                if(!updtDocLan.isEmpty()){
                    update updtDocLan;
                    createDocLangRecords(updtDocLan,doclOldMap,dLstatusMap);            
                }
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, DOCLANGTEXTUPDATION);
        }        
    }
    
    public static void createDocLangRecords(List<ASC_Document_Language__c> updatedDoclangList,
                                            Map<id,ASC_Document_Language__c> doclOldMap,Map<Id,String> dLstatusMap)
    { 
        List<ASC_Document_Language__c>  doclListToInsert = new List<ASC_Document_Language__c>();
        
        try{
            
            for(ASC_Document_Language__c docl:updatedDoclangList){
                
                ASC_Document_Language__c newdocl = new ASC_Document_Language__c();
                
                newdocl.Name = docl.Name;
                newdocl.ASC_Document_Language_State__c = docl.Template_Used__r.ASC_Document_Language_State__c;
                newdocl.ASC_Document_Type__c = docl.Template_Used__r.ASC_Document_Type__c;
                newdocl.ASC_Document_Language_Text__c = docl.Template_Used__r.ASC_Document_Language_Text__c;
                newdocl.ASC_Quote__c = docl.ASC_Quote__c;
                newdocl.ASC_Product__c = docl.Template_Used__r.ASC_Product__c;
                newdocl.ASC_Effective_Date__c = docl.Template_Used__r.ASC_Effective_Date__c;
                newdocl.ASC_End_Date__c = docl.Template_Used__r.ASC_End_Date__c;
                newdocl.ASC_Description__c = docl.Template_Used__r.ASC_Description__c;
                newdocl.ASC_When_Used__c = docl.Template_Used__r.ASC_When_Used__c;
                newdocl.ASC_Base_Contract__c = docl.Template_Used__r.ASC_Base_Contract__c;
                newdocl.ASC_Confidential__c = docl.Template_Used__r.ASC_Confidential__c;
                newdocl.ASC_Estimated_Outstanding_Liability_EOL__c = docl.Template_Used__r.ASC_Estimated_Outstanding_Liability_EOL__c;
                newdocl.ASC_Is_Subrogated__c = docl.Template_Used__r.ASC_Is_Subrogated__c;
                newdocl.ASC_Compliance_Start_Date__c = docl.Template_Used__r.ASC_Compliance_Start_Date__c;
                newdocl.ASC_Term_Clause_Duration__c = docl.Template_Used__r.ASC_Term_Clause_Duration__c;
                newdocl.ASC_Date_Signed__c = docl.Template_Used__r.ASC_Date_Signed__c;    
                newdocl.ASC_Approved_for_Contracting__c = docl.Template_Used__r.ASC_Approved_for_Contracting__c;
                newdocl.ASC_Legal_Approval_Date__c = docl.Template_Used__r.ASC_Legal_Approval_Date__c;
                newdocl.Template_Used__c = docl.Template_Used__c;
                newdocl.Update_Quote_Specific_Language__c = docl.Update_Quote_Specific_Language__c;
                doclListToInsert.add(newdocl);                            
            }
            
            if(!doclListToInsert.isEmpty()){
                insert doclListToInsert;
            }
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, CREATEDOCLANGRECORDS);
        }        
    }
}