/**
@Author : IDC Offshore
@Name: ASC_AutoGenerateFiles
@CreatedDate:  23-July-2020 
@Description: ASC_AutoGenerateFiles class is for Auto Generation of Contractual Documents
@version : 1.0  
********************************************************************/
public without sharing class ASC_AutoGenerateFiles {
    
    public static final string targtObj = 'ASC_Contractual_Document__c';
    public static final string SALESFORCEGENERATED = 'Salesforce Generated';
    public static Boolean isCongaTriggerBackEndFieldUpdated = false;
    public static Boolean isTemplateUpdated = false;
    private static final String UNDERSCORE = '_';
    public static  string  StopLoss='Stop Loss';
    public static  string  SYS_ADMIN='System Administrator';
    public static  string  GROUPSTATUS='GROUP';
    public static  string  REQUESTED='Requested';
    public static  string  VP= 'VP';
    public static  string  POSTINGTOCM='Posting to CM';
    public static  string  COMPLETE='Complete';
    public static  string  ERRORMSG='The contractual document cant be updated if the contract signature process is in progress or completed.';
    public static void invokeCongaTriggerForFilesCreation(List<ASC_Contractual_Document__c> cdLst,Map<id,ASC_Contractual_Document__c> cdoldMap)
    {
        if(!cdLst.isEmpty()){
            set<string> contractIds = new set<string>();        
            for(ASC_Contractual_Document__c cd :cdLst){
                if(cd.ASC_Contract__c != null){
                    contractIds.add(cd.ASC_Contract__c);
                    
                }               
            }
            System.debug('Before lis cntrcLinItemLst:' );
            List<vlocity_ins__ContractLineItem__c> cntrcLinItemLst = [select id,Name,vlocity_ins__ContractId__c,
                                                                      vlocity_ins__Product2Id__c,vlocity_ins__ParentItemId__c,vlocity_ins__ParentItemId__r.vlocity_ins__Product2Id__c
                                                                      from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c in :contractIds];
            for(ASC_Contractual_Document__c cd :cdLst){
                System.debug('Inside loop: ASC_Contractual_Document__c' );
                if(cdoldMap !=null)
                {
                    ASC_Contractual_Document__c oldCD = cdoldMap.get(cd.Id);
                    if((oldCD.ASC_Document_Language__c != cd.ASC_Document_Language__c 
                        || oldCD.Document_Version__c != cd.Document_Version__c  
                        || oldCD.Doc_Reference_Year__c != cd.Doc_Reference_Year__c 
                        || oldCD.Stop_Loss_Amendment_Reference__c != cd.Stop_Loss_Amendment_Reference__c
                        || (oldCD.Document_Source__c != cd.Document_Source__c && SALESFORCEGENERATED.equals(cd.Document_Source__c)) //TD-1099 - Added By Dinesh :Added document source condition 
                       )
                       && 
                       (cd.ASC_Document_Type__c.equals('Contract Amendment') 
                        || cd.ASC_Document_Type__c.equals('Stop-Loss Amendment') 
                        || cd.ASC_Document_Type__c.equals('Schedule A - Ex 2')
                        || cd.ASC_Document_Type__c.equals('Stop-Loss Policy')
                       )
                      )
                    {
                        // Delete files and recreate files.
                        List<ContentDocumentLink> contentDocLink = [SELECT ContentDocumentId,ContentDocument.Title FROM ContentDocumentLink 
                                                                    where LinkedEntityId = :cd.Id 
                                                                    AND LinkedEntity.Type='ASC_Contractual_Document__c'
                                                                    AND ContentDocument.Title LIKE '%SF_Gen%'
                                                                    limit 1];
                        if(contentDocLink != null && contentDocLink.size()>0)
                        {
                            database.delete(contentDocLink);
                        }
                        System.debug('Before CongaTrigger_BackendField__c:' + cd.CongaTrigger_BackendField__c);
                        if(SALESFORCEGENERATED.equals(cd.Document_Source__c)){ //Added By Dinesh - TD-1033 only if condition
                            cd.CongaTrigger_BackendField__c = True;
                            System.debug('Inside if:' + cd.CongaTrigger_BackendField__c);
                        }
                    }
                    //Added By Dinesh - when user changes Document Source to 'Salesforce Generated' manually on the existing record, Workflow outbound message will be trigged to generate the file.
                    if(!isCongaTriggerBackEndFieldUpdated 
                       && SALESFORCEGENERATED.equals(cd.Document_Source__c) 
                       && cd.Document_Source__c != oldcd.Document_Source__c){   
                           
                           cd.CongaTrigger_BackendField__c = true;
                       }                                        
                }
                else{ 
                    
                    if(cd.ASC_Document_Type__c.equals('Stop-Loss Exhibit') || cd.ASC_Document_Type__c.equals('Schedule A'))                    {
                        
                        Integer instanceNumbr = 58943345;
                        if(cd.ASC_Document_Type__c.equals('Stop-Loss Exhibit'))
                        {
                            instanceNumbr = 692057;
                        }
                        
                        List<ASC_Document_Type_Record__c> todeleteList = [select id,instance__c from ASC_Document_Type_Record__c where instance__c=:instanceNumbr];
                        if(todeleteList != null && todeleteList.size()>0)
                        {
                            Database.delete(todeleteList);
                            
                            
                        }
                        
                        createDocTypeRec(cntrcLinItemLst, instanceNumbr);
                        
                    }
                    
                    if(SALESFORCEGENERATED.equals(cd.Document_Source__c)){ //Added By Dinesh - TD-1033 only if condition
                        System.debug('Inside if 2:' + cd.CongaTrigger_BackendField__c);
                        cd.CongaTrigger_BackendField__c = True; 
                        
                    }                       
                }                    
            }              
        }
    } 
    
    //TD-1596 Added By Dinesh - Modified the method to avoid 101 soql queries.
    public static void createDocTypeRec(List<vlocity_ins__ContractLineItem__c> CntrcLinItemLst, integer instanceNumbr)
    {
        try{
            
            List<ASC_Document_Type_Record__c> docTypRecInsrtLst = new List<ASC_Document_Type_Record__c> ();                      
            Map<String,Product_Document_Mapping__c> prdDocMap = new Map<String,Product_Document_Mapping__c>();
            Set<Id> covSpecIdSet = new Set<Id>();
            
            Map<String,vlocity_ins__ContractLineItem__c> cLIIdMap = new Map<String,vlocity_ins__ContractLineItem__c>();
            if(!CntrcLinItemLst.isEmpty()){
                for(vlocity_ins__ContractLineItem__c cntrctLineItm:CntrcLinItemLst){
                    String covSpec_ParentConcatenation = cntrctLineItm.vlocity_ins__Product2Id__c+UNDERSCORE+cntrctLineItm.vlocity_ins__ParentItemId__r.vlocity_ins__Product2Id__c;
                    cLIIdMap.put(covSpec_ParentConcatenation,cntrctLineItm);
                }
            }
            //looping through Product Document Mapping
            for(Product_Document_Mapping__c pdm:[select id,Name,Coverage_Product__c,Parent_Product__c
                                                 from Product_Document_Mapping__c
                                                 LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                                                     String covSpec_ParentConcatenation = pdm.Coverage_Product__c+UNDERSCORE+pdm.Parent_Product__c;
                                                     if(cLIIdMap.ContainsKey(covSpec_ParentConcatenation)){                  
                                                         //Creating Document Type object record
                                                         ASC_Document_Type_Record__c docTypRec = new ASC_Document_Type_Record__c ();
                                                         docTypRec.Name = cLIIdMap.get(covSpec_ParentConcatenation).Name + ' _ ' + 'PDM';
                                                         docTypRec.Contract_Line_Item__c =  cLIIdMap.get(covSpec_ParentConcatenation).Id; //cntrctLineItm.id;
                                                         docTypRec.Product_Document_Mapping__c = pdm.id;
                                                         docTypRec.Instance__c = instanceNumbr;
                                                         docTypRecInsrtLst.add(docTypRec);
                                                     }                                               
                                                 }                                                       
            
            if(!docTypRecInsrtLst.isEmpty()){
                database.insert(docTypRecInsrtLst);
            }
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, 'clsName', 'createDocTypeRecMthd');}
    }
    
    public static void updateFieldsAtContractualDocument(list<ContentDocumentLink> cntDocNewList)
    {
        system.debug('Content Trigger - updateFieldsAtContractualDocument');
        
        Set<Id> docIds = new Set<Id>();
        for(ContentDocumentLink cdlRec: cntDocNewList){
            docIds.add(cdlRec.ContentDocumentId);     
        }
        
        List<ASC_Contractual_Document__c> cdListToUpdate = new List<ASC_Contractual_Document__c>();
        List<ASC_Contractual_Document__c> cdDocListToUpdate = new List<ASC_Contractual_Document__c>();
        Map<Id,ASC_Contractual_Document__c> cdDocMapToUpdate = new Map<Id,ASC_Contractual_Document__c>();
        Set<Id> condocIds = new Set<Id>();
        for(ContentDocumentLink cdlRec:[select id,ContentDocumentId,LinkedEntityId,LinkedEntity.Name,ContentDocument.Title from ContentDocumentLink where ContentDocumentId in: docIds limit 100])
        {   
            String sObjName = cdlRec.LinkedEntityId.getSObjectType().getDescribe().getName();
            
            if(targtObj.equals(sObjName))
            {                  
                /*Id cdId = cdlRec.ContentDocumentId;   //commented to resolve too many queries issue                     
ContentDocument cdRec = [select id,Title from ContentDocument where Id =:cdId limit 1];
String name = cdRec.Title;
*/
                condocIds.add(cdlRec.LinkedEntityId);
                String name = cdlRec.ContentDocument.Title;
                if(name.containsIgnoreCase('_SF_Gen'))
                {
                    ASC_Contractual_Document__c cdToUpdate = new ASC_Contractual_Document__c();
                    cdToUpdate.Id = cdlRec.LinkedEntityId;
                    cdToUpdate.Document_Source__c = SALESFORCEGENERATED;
                    cdToUpdate.CongaTrigger_BackendField__c = False;
                    isCongaTriggerBackEndFieldUpdated = true;
                    cdDocMapToUpdate.put(cdToUpdate.Id,cdToUpdate);                        
                }
                else
                {
                    ASC_Contractual_Document__c cdToUpdate = new ASC_Contractual_Document__c();
                    cdToUpdate.Id = cdlRec.LinkedEntityId;
                    cdToUpdate.Document_Source__c ='Manual';                                                                
                    cdDocMapToUpdate.put(cdToUpdate.Id,cdToUpdate);
                }                                                
            }
        }
        //added TD-1947
        if(cdDocMapToUpdate != null && cdDocMapToUpdate.Values().Size()>0){        
            database.update(cdDocMapToUpdate.Values(),false);
        }
        // end
        for(ASC_Contractual_Document__c CDDoc:[SELECT Id, ASC_Document_Language__c,Document_Source__c FROM ASC_Contractual_Document__c 
                                               WHERE id IN:cdDocMapToUpdate.Values()
                                               AND ASC_Document_Type__c='Group Signed Package' limit 1]
           ){
               
               CDDoc.Document_Source__c=SALESFORCEGENERATED;
               
               cdDocListToUpdate.add(CDDoc);
           }
        if(cdDocListToUpdate != null && cdDocListToUpdate.size()>0)
        {
            system.debug('cdListToUpdate '+cdDocListToUpdate);
            database.update(cdDocListToUpdate);
        }
        
        
    }
    
    public static void checkForDocLanguageTextUpdation(list<ASC_Document_Language__c> doclList,
                                                       map<id,ASC_Document_Language__c> doclOldMap)
    { 
        for(ASC_Document_Language__c doclId:doclList){
            ASC_Document_Language__c oldDL = doclOldMap.get(doclId.Id);
            if(oldDL.ASC_Document_Language_Text__c != doclId.ASC_Document_Language_Text__c)
            {
                List<ASC_Contractual_Document__c> cdRec = [SELECT Id, ASC_Document_Language__c,Document_Source__c FROM ASC_Contractual_Document__c 
                                                           WHERE ASC_Document_Language__c=:doclId.Id 
                                                           AND Document_Source__c='Salesforce Generated'
                                                          ];
                if(!cdRec.isEmpty())
                {
                    String CDId = cdRec[0].Id;
                    // Delete files and recreate.
                    List<ContentDocumentLink> contentDocLink = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId = :CDId and LinkedEntity.Type='ASC_Contractual_Document__c' limit 1];
                    if(contentDocLink != null && contentDocLink.size()>0)
                    {
                        database.delete(contentDocLink);
                    }
                    ASC_Contractual_Document__c cdToUpdate = new ASC_Contractual_Document__c();
                    cdToUpdate.Id = CDId;
                    cdToUpdate.CongaTrigger_BackendField__c = True;
                    update cdToUpdate;
                }                
            }
        }
    }
    public static void invokeContractualDocumentScheduleA(list<Line_Item_Extension__c> louNew,  
                                                          map<id,Line_Item_Extension__c> oldMapLou){
                                                              set<id> plansIds=new set<id>();
                                                              set<id> contractIds=new set<id>();
                                                              list<ASC_Contractual_Document__c> listContractualDocument=new list<ASC_Contractual_Document__c>();
                                                              List<ContentDocument> contentDocumentIds = new List<ContentDocument>();
                                                              
                                                              for(Line_Item_Extension__c louNewVal:louNew){
                                                                  
                                                                  if(louNewVal.LOU_Signed__c != oldMapLou.get(louNewVal.id).LOU_Signed__c && louNewVal.Parent_Product__c!=StopLoss){
                                                                      plansIds.add(louNewVal.Plan_ID__c);
                                                                      
                                                                  }
                                                              }
                                                              
                                                              if(!plansIds.isEmpty()){
                                                                  for(vlocity_ins__ContractLineItem__c plansIdsVal:[select vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c
                                                                                                                    WHERE id=:plansIds]){
                                                                                                                        contractIds.add(plansIdsVal.vlocity_ins__ContractId__c);
                                                                                                                        
                                                                                                                    }
                                                                  
                                                              }
                                                              if(!contractIds.isEmpty()){
                                                                  for(ContentDocumentLink con:[select id,LinkedEntityId,ContentDocumentId  from ContentDocumentLink  where LinkedEntityId IN: contractIds]){
                                                                      contentDocumentIds.add(new ContentDocument(id=con.ContentDocumentId));
                                                                  }
                                                                  
                                                                  for(ASC_Contractual_Document__c contractualDocumentVal:[select  id,CongaTrigger_BackendField__c,ASC_Contract__c
                                                                                                                          ,ASC_Document_Type__c,ASC_Document_Language__c,Document_Version__c,Doc_Reference_Year__c,Stop_Loss_Amendment_Reference__c,Document_Source__c from ASC_Contractual_Document__c
                                                                                                                          WHERE ASC_Contract__c=:contractIds AND ASC_Document_Type__c ='Schedule A']){
                                                                                                                              
                                                                                                                              listContractualDocument.add(contractualDocumentVal);
                                                                                                                              
                                                                                                                          }
                                                              }
                                                              if(listContractualDocument.size()>0){
                                                                  //invokeCongaTriggerForFilesCreation(listContractualDocument,null);
                                                                  //update listContractualDocument;
                                                                  set<Id> ascContractIds=new set<Id>();
                                                                  for(ASC_Contractual_Document__c cd :listContractualDocument){
                                                                      if(cd.ASC_Contract__c != null){
                                                                          contractIds.add(cd.ASC_Contract__c);
                                                                      }
                                                                      if( cd.ASC_Document_Type__c.equals('Schedule A')){
                                                                          ascContractIds.add(cd.Id);
                                                                      }
                                                                      
                                                                  }
                                                                  List<vlocity_ins__ContractLineItem__c> cntrcLinItemLst = [select id,Name,vlocity_ins__ContractId__c,
                                                                                                                            vlocity_ins__Product2Id__c,vlocity_ins__ParentItemId__c,vlocity_ins__ParentItemId__r.vlocity_ins__Product2Id__c
                                                                                                                            from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c in :contractIds];
                                                                  
                                                                  Integer instanceNumbr = 58943345;
                                                                  List<ASC_Document_Type_Record__c> todeleteList = [select id,instance__c from ASC_Document_Type_Record__c where instance__c=:instanceNumbr];
                                                                  if(todeleteList != null && todeleteList.size()>0)
                                                                  {
                                                                      Database.delete(todeleteList);
                                                                      
                                                                      
                                                                  }
                                                                  
                                                                  
                                                                  List<ContentDocumentLink> contentDocLink = [SELECT ContentDocumentId,ContentDocument.Title FROM ContentDocumentLink 
                                                                                                              where LinkedEntityId IN:ascContractIds 
                                                                                                              AND LinkedEntity.Type='ASC_Contractual_Document__c'
                                                                                                              AND ContentDocument.Title LIKE '%SF_Gen%'] ;
                                                                  if(contentDocLink != null && contentDocLink.size()>0)                                                                                  
                                                                  {
                                                                      database.delete(contentDocLink); 
                                                                      system.debug('delete contractual doc records'+contentDocLink);
                                                                  }
                                                                  createDocTypeRec(cntrcLinItemLst, instanceNumbr); 
                                                                  
                                                              }
                                                              list<ASC_Contractual_Document__c> asContractsDocs=new list<ASC_Contractual_Document__c>();
                                                              for(ASC_Contractual_Document__c cd :listContractualDocument){
                                                                  if(SALESFORCEGENERATED.equals(cd.Document_Source__c)){ 
                                                                      asContractsDocs.add(new ASC_Contractual_Document__c(Id=cd.Id,CongaTrigger_BackendField__c = True));
                                                                  }
                                                                  
                                                              }
                                                              
                                                              
                                                              database.update(asContractsDocs,false);
                                                              if(!contentDocumentIds.isEmpty()){
                                                                  delete contentDocumentIds;
                                                                  system.debug('files record deletion'+contentDocumentIds);
                                                              }
                                                              
                                                              
                                                          }
    
    public static void sendForSignature(list<ContentDocumentLink> cntDocNewList)
    {
        system.debug('sendForSignature - sendForSignature');
        try{  
            Set<Id> docIds = new Set<Id>();
            for(ContentDocumentLink cdlRec: cntDocNewList){
                docIds.add(cdlRec.ContentDocumentId);     
            }
            
            List<ASC_Contractual_Document__c> documentIds= new List<ASC_Contractual_Document__c>();
            List<ContentDocumentLink> contentDocLink= new List<ContentDocumentLink>();
            Decimal countofdocs;
            Id cdId;
            
            /*
for(ContentDocumentLink cdlRec:[select id,ContentDocumentId,LinkedEntityId,LinkedEntity.Name from ContentDocumentLink where ContentDocumentId in: docIds limit 100])
{   
String sObjName = cdlRec.LinkedEntityId.getSObjectType().getDescribe().getName();

if(targtObj.equals(sObjName))
{                  
cdId = cdlRec.LinkedEntityId;                    

contentDocLink = [SELECT ContentDocumentId,ContentDocument.Title FROM ContentDocumentLink 
where LinkedEntityId = :cdId 
AND LinkedEntity.Type='ASC_Contractual_Document__c'
AND (NOT ContentDocument.Title LIKE '%SF_Gen%')
];                                        
}
} */
            
            for(ContentDocumentLink cdlRec:[select id,ContentDocumentId,LinkedEntityId,LinkedEntity.Name,ContentDocument.Title
                                            from ContentDocumentLink 
                                            where ContentDocumentId IN: docIds 
                                            //AND LinkedEntity.Type = 'ASC_Contractual_Document__c'
                                            //AND (NOT ContentDocument.Title LIKE '%SF_Gen%')
                                            LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                                                System.debug('cdl records'+cdlRec);
                                                String sObjName = cdlRec.LinkedEntityId.getSObjectType().getDescribe().getName();  
                                                System.debug('sObjName'+sObjName);
                                                List<String> titleSet = new List<String>();
                                                titleSet.add(cdlRec.ContentDocument.Title);
                                                
                                                system.debug('titleSet'+titleSet);
                                                // 'ASC_Contractual_Document__c'.equals(cdlRec.LinkedEntity.Type) && 
                                                if(targtObj.equals(sObjName) && !titleSet.Contains('SF_Gen')){
                                                    contentDocLink.add(cdlRec);
                                                    cdId = cdlRec.LinkedEntityId;                    
                                                    
                                                    system.debug('contentDocLink'+contentDocLink);
                                                }               
                                            }
                                            if(cdId!=null){
                                              contentDocLink = [SELECT ContentDocumentId,ContentDocument.Title FROM ContentDocumentLink 
                              where LinkedEntityId = :cdId 
                              AND LinkedEntity.Type='ASC_Contractual_Document__c'
                              AND (NOT ContentDocument.Title LIKE '%SF_Gen%')
                             ];                                        
          }
            
            documentIds=[Select id,ASC_Contract__c,ASC_Contract__r.Count_of_contractual_Document__c,ASC_Document_Type__c from ASC_Contractual_Document__c where Id=:cdId and ASC_Document_Type__c=:'Group Signed Package' limit 1];
            system.debug('documentIds'+documentIds);
            if(documentIds!=null && documentIds.size()>0){
                countofdocs=documentIds[0].ASC_Contract__r.Count_of_contractual_Document__c+1;
                System.debug('countofdocs'+countofdocs);
                
            }     
            System.debug('contentDocLink.size()'+contentDocLink.size()+'countofdocs'+countofdocs);
            
            if(contentDocLink != null &&  contentDocLink.size()>0 && contentDocLink.size()==countofdocs)
            {
                System.debug('before countofdocs'+documentIds[0].id);
                
                ASC_SendForSignature.sendEnvelope(documentIds[0].id);                  
            }else{}
            
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, 'clsName', 'sendForSignature');}
        
    }
    /*******************************************************************************************************************************
//@Description: This method is used to throw error when user is trying to add files in contractual document when contract signature is group,vp,posting to cm,requested,completed.
//@Name : updateFiles
//@Param : list<ContentDocumentLink> cntList
//@throws Exception : N/A;
//US-4565
//********************************************************************************************************************************/  
    public static void updateFiles(list<ContentDocumentLink> cntList)
    {
        List<String> ids=new List<String>();
        List<Profile> adminId = [SELECT Id from Profile where Name='integration user' OR Name='System Administrator' OR name='Support Admin'];
        for(Profile profileee: adminId){
            ids.add(profileee.id);
        }
        
        if(!ids.contains(UserInfo.getProfileId())){
            Set<Id> contentDocumentRecIdSet = new Set<Id>();
            for(ContentDocumentLink cdLink: cntList){
                contentDocumentRecIdSet.add(cdLink.LinkedEntityId);
            }
            Map<Id,ASC_Contractual_Document__c> cdMap = new Map<Id,ASC_Contractual_Document__c>();
            if(!contentDocumentRecIdSet.isEmpty()){
                for(ASC_Contractual_Document__c cd: [SELECT Id FROM ASC_Contractual_Document__c 
                                                     WHERE Id=:contentDocumentRecIdSet AND ((ASC_Contract__r.ASC_Signature_Status__c=:REQUESTED) 
                                                                                            OR (ASC_Contract__r.ASC_Signature_Status__c=:GROUPSTATUS) 
                                                                                            OR (ASC_Contract__r.ASC_Signature_Status__c=:VP) 
                                                                                            OR (ASC_Contract__r.ASC_Signature_Status__c=:POSTINGTOCM)
                                                                                            OR(ASC_Contract__r.ASC_Signature_Status__c=:COMPLETE)) limit 1])
                {
                    cdMap.put(cd.Id,cd);
                }
            }
            for(ContentDocumentLink cdLink: cntList){
                if(cdMap.ContainsKey(cdLink.LinkedEntityId)){
                    cdLink.adderror(ERRORMSG);
                }
            }
        }
    }
}