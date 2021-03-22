/**
@Author : Harsha
@Name: ASC_DocusignParticipentValidations
@CreatedDate:  11-12-2020 
@Description: ASC_DocusignParticipentValidations class is able to get the input from OS and send Validation messages back to OS .
@version : 1.0  
@US# :US-4060

*/
global without sharing class ASC_DocusignParticipentValidations implements vlocity_ins.VlocityOpenInterface2 {
    
    private static final string CLASSNAME  ='ASC_DocusignParticipentValidations';
    private static final string THROWVALIDATIONS  ='throwValidations';
    private static final string APPROVER  ='Approver';
    private static final string VOIDED  ='Voided';
    private static final string DECLINED  ='Declined';
    private static final string SIGNER  ='Signer';
    private static final string SLA  ='Stop-Loss Amendment';
    private static final string DRAFT  ='Draft';
    private static final string SCHA2  ='Schedule A - Ex 2';
    private static final string CONTRACTAMMENDMENT  ='Contract Amendment';
    private static final string ASCBASECONTRACT  ='Base ASC Contract';
    private static final string ASCCONTRACTUALDOC  ='ASC_Contractual_Document__c';
    private static final string NA  ='N/A';
    private static final string SFGENERATED  ='Salesforce Generated';
    private static final string GRPSIGNEDPKG  ='Group Signed Package';
	private static final string REFYEAR  ='9999';
    private static final string ACTIVE  ='Active';
    private static final string GROUPPRIMARY  ='Group Primary';
    private static final string STR_EMPTY  = '';
    private static final string ERROR  = 'error';
    private static final string CONTXID = 'ContextId';
    private static final String ERROR_MSG_DecisionMakerList =  ' There should be at least 1 recipient with Group Primary Action. ';
    private static final String ERROR_MSG_AgentApproverList =   'There can not be more than 1 recipient with Agent Approver Action.'    ;   
    private static final String ERROR_MSG_SignerList ='There should be only 1 Segment Owner signer.';           
    private static final String ERROR_MSG_RoutingorderNullList ='The routing order should be filled in for all the recipients that are included as Active recipients.';         
    private static final String ERROR_MSG_DecisionMakerList1 = ' There can not be more than 1 Group Primary.';
    private static final String ERROR_MSG_SendEnvelope = ' The data required for contractual documents';
    private static final String ERROR_MSG_EmailNull = ' The following recipient(s) are missing the valid email: ';
    private static final String ERROR_MSG_SalesEmailNull= ' Please add the Sales Reps name and email address on the Contract detail page before moving forward. ';
    private static final String ERROR_MSG_VpadminOrderList ='Please correct the routing order. The routing orders listed for VP admin and Segment Owner are not at the same level.';
    public static final Id AGENT_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Agent').getRecordTypeId();
    public static final Id SEGOWNER_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Segment Owner').getRecordTypeId();
     public static final Id VPADMIN_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('VP Admin').getRecordTypeId();
  
    /********************************************************************************************************************
@Description        :                            
@Name               :   invokeMethod
@Param              :   String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options
@Return             :   Object
@throws Exception   :   N/A;    
********************************************************************************************************************************/
    global Object invokeMethod(String methodName, Map<String,Object> input, 
                               Map<String,Object> output, Map<String,Object> options) 
    {           
        try{
            if(THROWVALIDATIONS.equals(methodName)){
                return throwValidations(input,output);
            }
            
        }
        catch(exception e){   
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, THROWVALIDATIONS);
            system.debug('line number@@ '+e.getLineNumber());
            system.debug('getMessage @@ '+e.getMessage());
        }        
        try{
            
            if('showEmailContent'.equals(methodName)){
                return showEmailContent(input,output);
            }
        }
        catch(exception e){   
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, THROWVALIDATIONS);
            system.debug('line number@@ '+e.getLineNumber());
            system.debug('getMessage @@ '+e.getMessage());
        }
        try{
            
            if('sendEnvelopeValidations'.equals(methodName)){
                return sendEnvelopeValidations(input,output);
            }
        }
        catch(exception e){   
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, THROWVALIDATIONS);
            system.debug('line number@@ '+e.getLineNumber());
            system.debug('getMessage @@ '+e.getMessage());
        }
        try{
            
            if('createDeleteConDocs'.equals(methodName)){
                return createDeleteConDocs(input,output);
            }
        }
        catch(exception e){   
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, THROWVALIDATIONS);
            system.debug('line number@@ '+e.getLineNumber());
            system.debug('getMessage @@ '+e.getMessage());
        }
        return true;        
    }
    /********************************************************************************************************************
@Description        :   This method is used to throw validation on Omniscript page based on docusign action validations.
@Name               :   throwValidations
@Param              :   Map<String, Object> input, Map<String, Object> output
@Return             :   Boolean
@throws Exception   :   N/A;    
********************************************************************************************************************************/        
    global static Boolean throwValidations(Map<String, Object> input,
                                           Map<String, Object> output)
        
    { 
        
        //List<string> EmailNullNames=new List<string>(); 
        string EmailNullNames=''; 
        string Finalmsg='';
        List<DocuSign_Participant__c> EmailNullList = new List<DocuSign_Participant__c>();
        List<DocuSign_Participant__c> DecisionMakerList = new List<DocuSign_Participant__c>();
        List<DocuSign_Participant__c> AgentApproverList = new List<DocuSign_Participant__c>();
        List<DocuSign_Participant__c> SignerList = new List<DocuSign_Participant__c>();
        List<DocuSign_Participant__c> RoutingorderNullList = new List<DocuSign_Participant__c>();
        List<DocuSign_Participant__c> VpadminRoutingOrderList = new List<DocuSign_Participant__c>();
        String qtID = STR_EMPTY;
        Decimal SegmentOrder;
        if(input.get(CONTXID) !=null){
            qtID = (string)input.get(CONTXID);
            for(DocuSign_Participant__c dsp:[SELECT id,name,contract__c,docusign_action__c,Active__c,recipient_email__c,recordtype.name,routing_order__c FROM DocuSign_Participant__c where contract__c =: qtID and Active__c=True ])  
            {
                
                if(GROUPPRIMARY.equals(dsp.DocuSign_Action__c) && dsp.Active__c){
                    
                    DecisionMakerList.add(dsp);
                    system.debug('DecisionMakerList'+DecisionMakerList);
                }
                 if(String.isBlank(dsp.Recipient_Email__c) && dsp.Active__c){
                    
                    EmailNullList.add(dsp);
                     EmailNullNames+=''+dsp.Name+',';
                     Finalmsg=EmailNullNames.removeEnd(',');
                    system.debug('EmailNullList'+EmailNullList);
                }
                if(APPROVER.equals(dsp.DocuSign_Action__c) && dsp.RecordTypeId==AGENT_RECTYPEID && dsp.Active__c){
                    
                    AgentApproverList.add(dsp);
                    system.debug('AgentApproverList'+AgentApproverList);
                }
                
                if(SIGNER.equals(dsp.DocuSign_Action__c) && dsp.RecordTypeId==SEGOWNER_RECTYPEID && dsp.Active__c){
                    
                    SegmentOrder=dsp.Routing_Order__c;
                    SignerList.add(dsp);
                    system.debug('SignerList'+SignerList);
                }
                if((dsp.Routing_Order__c== NULL) && dsp.Active__c){
                    
                    RoutingorderNullList.add(dsp);
                    system.debug('RoutingorderNullList'+RoutingorderNullList);
                }
                  if(dsp.RecordTypeId==VPADMIN_RECTYPEID && (dsp.Routing_Order__c!= SegmentOrder) && dsp.Active__c){
                    
                    VpadminRoutingOrderList.add(dsp);
                    system.debug('RoutingorderNullList'+VpadminRoutingOrderList);
                }

            }
        }  
        if( DecisionMakerList.isEmpty() )  {   
            output.put(ERROR,ERROR_MSG_DecisionMakerList);   
        }
        if( DecisionMakerList.size()>1 )  {   
            output.put(ERROR,ERROR_MSG_DecisionMakerList1);   
        }
        if(AgentApproverList.size()>1 )  {   
            output.put(ERROR,ERROR_MSG_AgentApproverList);   
        }
        if(SignerList.size()>1 || SignerList.isEmpty())  {   
            output.put(ERROR,ERROR_MSG_SignerList);   
        } 
        if(RoutingorderNullList.size()>0 )  {   
            output.put(ERROR,ERROR_MSG_RoutingorderNullList);   
        } 
         if(VpadminRoutingOrderList.size()>0 )  {   
            output.put(ERROR,ERROR_MSG_VpadminOrderList);   
        } 
         if(!EmailNullList.isEmpty())  {   
            output.put(ERROR,ERROR_MSG_EmailNull+Finalmsg);   
        }
        return true; 
        
        
    }
    global static Boolean showEmailContent(Map<String, Object> input,
                                           Map<String, Object> output)
        
    {
        Map<String,ASC_DocuSign_Email_Content__mdt> lineExtMap = new Map<String,ASC_DocuSign_Email_Content__mdt>();
        for(ASC_DocuSign_Email_Content__mdt qLI:[Select Id,ASC_Message__c,ASC_Recipient_Type__c,
                                                 ASC_Subject__c from ASC_DocuSign_Email_Content__mdt
                                                 Limit :UTIL_SLB.retrieveQueryLimitValue()]){ 
                                                     
                                                     lineExtMap.put(qLI.ASC_Message__c,qLI);
                                                 } 
        system.debug('lineExtMap'+lineExtMap.values());
        output.put('emailList',lineExtMap.values()); 
        return true; 
    }
    
    global static Boolean sendEnvelopeValidations(Map<String, Object> input,
                                                  Map<String, Object> output)
        
    {
        String qtID = STR_EMPTY;
        if(input.get(CONTXID) !=null){
            qtID = (string)input.get(CONTXID);
        }
        String prdStr = '';  
        String prdStrSet = '';  
        String prdErr = '';  
       Boolean flagCheck=false;
        contract con=[select id,Sales_Rep_Name__c,Sales_Rep_Email__c from contract where id=:qtID];
        if(String.isBlank(con.Sales_Rep_Name__c) || String.isBlank(con.Sales_Rep_Email__c)){
                                    output.put('Errors' ,ERROR_MSG_SalesEmailNull);  
        }
        
        List<ContentDocumentLink> contentDocLink= new List<ContentDocumentLink>();
        list<ASC_Contractual_Document__c> cdList=new list<ASC_Contractual_Document__c>();
        for(ASC_Contractual_Document__c acd:[Select Id,Name,Document_Language_Required__c,ASC_Document_Language__c,Doc_Reference_Year__c,Stop_Loss_Amendment_Reference__c,ASC_Document_Type__c,ASC_Contractual_Document__c.ASC_Document_Language__r.Name,ASC_Document_Language__r.ASC_Document_Language_State__c from ASC_Contractual_Document__c where ASC_Contract__c =: qtID AND ASC_Do_Not_Include__c=false AND Document_Source__c!='Manual']){
            if((acd.Document_Language_Required__c==true && string.isBlank(acd.ASC_Document_Language__c)) 
               || ((string.isBlank(acd.Doc_Reference_Year__c)|| acd.Doc_Reference_Year__c==REFYEAR) && (acd.ASC_Document_Type__c==CONTRACTAMMENDMENT || acd.ASC_Document_Type__c==SCHA2))
               || (acd.ASC_Document_Language__C!=NULL && (acd.ASC_Document_Language__r.ASC_Document_Language_State__c!=DRAFT && acd.ASC_Document_Language__r.ASC_Document_Language_State__c!=ACTIVE ))
               || (acd.ASC_Document_Type__c.equals('Stop-Loss Amendment') && string.isBlank(acd.Stop_Loss_Amendment_Reference__c))
              ){
                  system.debug('acd=====>'+acd);
                  prdStr += ''+ acd.Name + '</br>' +' ';
                  system.debug('prdStrSet'+prdStr);
                  if(!string.isBlank(prdStr)){
                      flagCheck=true;
                  }
                                    output.put('Errors' ,prdStr);

              }   
            
        }
cdList=[Select Id,Name,ASC_Document_Type__c,CongaTrigger_DocuSign_BackendField__c from ASC_Contractual_Document__c where ASC_Contract__c =: qtID AND ASC_Document_Type__c=:ASCBASECONTRACT limit 1];
        
         if(cdList.size()>0) 
        {   
                  prdStr += ''+ cdList[0].Name + '</br>' +' ';

            for(ContentDocumentLink cdl:[SELECT ContentDocumentId,ContentDocument.Title FROM ContentDocumentLink 
                                         where LinkedEntityId = :cdList[0].Id
                                         AND LinkedEntity.Type=:ASCCONTRACTUALDOC limit 100
                                        ]){
                                            
                                            contentDocLink.add(cdl);
                                        }  
            if(contentDocLink.isEmpty() && !flagCheck){
                
                                 output.put('Errors' ,prdStr);
            }           
        }          
        
        return true; 
    }
    global static Boolean createDeleteConDocs(Map<String, Object> input,
                                              Map<String, Object> output)
        
    {
        String qtID = STR_EMPTY;
         
      String conYear=(string)input.get('conyr');
        System.debug('@@@@@conYear'+conYear);
        if(input.get(CONTXID) !=null){
            qtID = (string)input.get(CONTXID);
        }
        List<ContentDocumentLink> contentDocLink= new List<ContentDocumentLink>();
        list<ASC_Contractual_Document__c> cdList=new list<ASC_Contractual_Document__c>();
        list<ASC_Contractual_Document__c> cdListNew=new list<ASC_Contractual_Document__c>();
        
        cdList=[Select Id,ASC_Document_Type__c,CongaTrigger_DocuSign_BackendField__c from ASC_Contractual_Document__c where ASC_Contract__c =: qtID AND ASC_Document_Type__c=:GRPSIGNEDPKG AND (ASC_contract__r.ASC_Signature_Status__c=:VOIDED or ASC_contract__r.ASC_Signature_Status__c=:DECLINED) limit 1];
        System.debug('@@@@@cdList'+cdList); 
        if(cdList.size()>0) 
        {   
            cdList[0].CongaTrigger_DocuSign_BackendField__c=false;
            update cdList;
            for(ContentDocumentLink cdl:[SELECT ContentDocumentId,ContentDocument.Title FROM ContentDocumentLink 
                                         where LinkedEntityId = :cdList[0].Id
                                         AND LinkedEntity.Type=:ASCCONTRACTUALDOC limit 100
                                        ]){
                                            
                                            contentDocLink.add(cdl);
                                        }  
            if(contentDocLink.size()>0){
                
                delete contentDocLink;
                 cdList[0].CongaTrigger_DocuSign_BackendField__c=true;
                update cdList;

            }          
        }else{
            
            ASC_Contractual_Document__c cdcreate=new ASC_Contractual_Document__c();
            cdcreate.ASC_Contract__c=qtID;
            cdcreate.ASC_Signature_Required__c=false;
            cdcreate.Document_Version__c=NA;
            cdcreate.CongaTrigger_DocuSign_BackendField__c=true;
            cdcreate.Document_Source__c=SFGENERATED;
            cdcreate.ASC_Do_Not_Include__c=true;
            cdcreate.ASC_Document_Type__c=GRPSIGNEDPKG;
            cdcreate.Doc_Reference_Year__c=conYear;
            cdListNew.add(cdcreate);
            
            System.debug('@@@@@cdListNew'+cdListNew);
            insert cdListNew;
        }
        
        return true;
    }
}