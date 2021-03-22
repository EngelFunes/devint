/*****************************************************
    @Author : Mida Komal
    @Name: ASC_CreateContractFromQuote
    @CreatedDate: 21 - May 2020
    @version : 1.0  
    *********************************************************/
    public without sharing class ASC_CreateContractFromQuote {
          
        public static final Id ASC_QUOTE_RECTYPEID = 
        Schema.SObjectType.Quote.getRecordTypeInfosByName().get('ASC Quote').getRecordTypeId();
        
        public static final Id ASC_CONTRACT_RECTYPEID = 
        Schema.SObjectType.Contract.getRecordTypeInfosByName().get('ASC Contract').getRecordTypeId();
        
        private static final String CONTRACT ='Contract';
        private static final String CONTRACT_LINEITEM ='vlocity_ins__ContractLineItem__c';
        private static final String ACCEPTED = 'Accepted';
        public static final String VLOCITY_INS_PARENTITEMID2 ='vlocity_ins__ParentItemId2__c';
        public static final String VLOCITY_INS_PARENTITEMID = 'vlocity_ins__ParentItemId__c';
        public static final String SELECT_STRING ='SELECT ';
        private static final String REC_ID = 'Id';
        private static final String CLASSNAME = 'ASC_CreateContractFromQuote';
        private static final String BCBSM_CARRIER = 'BCBSM';
        private static final String BCN_CARRIER = 'BCN';
        private static final String CREATECONTRACTFRMQUOTE_METHOD = 'createContractFrmQuote';
        private static final String BUILDINSERTCONTRACTLINEPROPS_METHOD = 'buildInsertContractLineProps';
        private static final String BUILDCONTRACTPROPS_METHOD = 'buildContractProps';
        private static final String ASC_CONTRACT ='ASC_Contract__c';
        private static final String ASC_DOCUMENT_TYPE = 'ASC_Document_Type__c';
        public static final String ASC_DOCUMENT_LANGUAGE = 'ASC_Document_Language__c';
        public static final String ASC_SIGNATURE_REQUIRED='ASC_Signature_Required__c';
        private static final String NAME= 'Name';
        private static final String SCHEDULEA ='Schedule A';
        private static final String STOPLOSS_EXHIBIT ='Stop-Loss Exhibit';
        private static final String STOPLOSS_POLICY = 'Stop-Loss Policy';
        private static final String SCHEDULEA_EXHIBIT_1 ='Schedule A - Ex 1';
        private static final String SCHEDULEA_EXHIBIT_2 ='Schedule A - Ex 2';
        private static final String CONTRACT_AMENDMENT ='Contract Amendment';
        private static final String STOPLOSS_AMENDMENT ='Stop-Loss Amendment';
        private static final String CREATECONTRACTDOCUMENTS = 'createContractualDocuments';
        private static final String STATUS = 'Status';
        private static final String DRAFT ='Draft';
        private static final String RECORDTYPEID='RecordTypeId';
        private static final String ACCOUNTID='AccountId';
        public static final String SALESREPNAME = 'Sales_Rep_Name__c';
        public static final String SALESREPEMAIL = 'Sales_Rep_Email__c';
        public static final String VLOCITYOPPID = 'vlocity_ins__OpportunityId__c';
        public static final String VLOCITYQUOTEID = 'vlocity_ins__QuoteId__c';
        private static final String DOC_VERSION = 'Document_Version__c';
        private static final String SCHEDULA_DEFAULT = '2021 Schedule A Default';
        private static final String DOC_REF_YEAR = 'Doc_Reference_Year__c';
        private static final String STOPLOSS_POLICY_DEFAULT ='2021.2 Stop-Loss Policy Default';
        private static final String STOPLOSS_EXHIBIT_DEFAULT ='2021 Stop Loss Exhibit Default';
        private static final String CONTRACT_AMENDMENT_DEF ='2021 Contract Amendment Default';
        private static final String STOPLOSS_AMENDMENT_DEF ='2021 Stop-Loss Amendment Default';
        private static final String SCHA_EXHIBIT2_DEF ='2021 Schedule A Exhibit 2 Default';
        private static final String SCHEDULEA_EXHIBIT2 ='Schedule A - Exhibit 2';
        private static final String SCHEDULEB_BCN ='2021 Schedule B - BCN';
        private static final String SCHEDULEB_BCBSM ='2021 Schedule B - BCBSM';
        private static final String SCHEDULEB ='Schedule B';
        private static final String SCHA_EXHIBIT1_DEF ='2021 Schedule A Exhibit 1 Default';
        private static final String DATA_FEED_PDTCODE = 'ASC_0000160';
        private static final String ACTIVE = 'Active';
        private static final String STRING_EMPTY = '';      
        private static final string STR_COMMA = ',';
        private static final string PARENTITEMPRODUCTCODEFIELD = 'vlocity_ins__ParentItemId2__r.ASC_Product_Code__c';
        public static boolean isExecuting = false;
    
        /*****************************************************************
        @Description: createContractFrmQuote() method 
        @Name : createContractFrmQuote method
        @Param : list<Quote> quoteList,map<id,Quote> quoteOldMap
        @Return :void
        ******************************************************************/
        public static void createContractFrmQuote(list<Quote> quoteList,map<id,Quote> quoteOldMap){
           
          try{
            list<ASC_Quote_Contract_Mapping__mdt> quoteContractMappingMdt = [SELECT Label,Child_API_Name__c,
                                                                             Parent_API_Name__c,Child_Object__c,
                                                                             Parent_Object__c FROM ASC_Quote_Contract_Mapping__mdt
                                                                             where Child_Object__c=:CONTRACT limit 100];
            list<ASC_Quote_Contract_Mapping__mdt> quoteLineContractLineMappingMdt = [SELECT Label,Child_API_Name__c,
                                                                                     Parent_API_Name__c,Child_Object__c,
                                                                                     Parent_Object__c
                                                                                     FROM ASC_Quote_Contract_Mapping__mdt 
                                                                                     where Child_Object__c=:CONTRACT_LINEITEM limit 100];        
                Contract newContract = new Contract();
                if(!quoteList.isEmpty()){
                    for(Quote quoteRec :quoteList){
                        if(quoteRec.RecordTypeId.equals(ASC_QUOTE_RECTYPEID) && quoteOldMap!=null){
                        
                             Quote oldQuote=quoteOldMap.get(quoteRec.Id);
                             if(String.isNotBlank(quoteRec.Status) && oldQuote.Status != quoteRec.Status && ACCEPTED.equals(quoteRec.Status)){
                                
                                  //Contract record Creation Starts if Quote Status is Accepted.                                                    
                                  newContract = buildContractProps(quoteContractMappingMdt, quoteRec);                     
                                    
                                    //contractlineitem records Creation Starts
                                  buildInsertContractLineProps(quoteLineContractLineMappingMdt, quoteRec,newContract.Id); 
                                                                         
                                  //Contractual Document records creation starts here.
                                  createContractualDocuments(newContract.Id,quoteRec.Id,quoteRec.ASC_Renewal_Year__c,quoteRec.ASC_Carrier__c);
                                
                                                                                                                                     
                             }                    
                        }  
                    }  
                }
            }
            Catch(Exception e){GA_LogExceptionCls.LogExcp(e, CLASSNAME, CREATECONTRACTFRMQUOTE_METHOD);}
        }
        
        /*
        @Description: cloneFilesFromContractualDocument() method 
        @Name : cloneFilesFromContractualDocument
        @Param : Id oldContractId and newContractId
        @Return :void
        */
       public static void cloneFilesFromContractualDocument(Id oldContract,Id newContract)
        {
            System.debug('Method in '+oldContract+' OUT '+ newContract);
            List<ASC_Contractual_Document__c> oldCD = new List<ASC_Contractual_Document__c>();
            Map<String, ASC_Contractual_Document__c> CDList = new Map<String, ASC_Contractual_Document__c>();
            
            List<ASC_Contractual_Document__c> lstcdoc = [select id ,ASC_Contract__c, name from ASC_Contractual_Document__c where
                                                     (ASC_Contract__c = :newContract OR ASC_Contract__c = :oldContract) 
                                                         AND ASC_Document_Type__c !='Group Signed Package'  ];
    
            system.debug('lstcdocsize####'+lstcdoc.size());
    
                for(ASC_Contractual_Document__c cd:lstcdoc)
                {
                    if(cd.ASC_Contract__c == newContract ){
                    CDList.put(cd.name, cd);//adding  new cddocs
                    }
                    else if(cd.ASC_Contract__c == oldContract){ 
                    oldCD.add(cd);
                    }                                    
                } 
            System.debug('CDList '+CDList); 
            Map<id, id> oldNewCD = new Map<id,id>();
            for(ASC_Contractual_Document__c eachDoc : oldCD){
                //System.debug('Doc Name '+eachDoc.name);
                 
                for(String key : CDList.keyset()){ 
                  List<String> res = key.split('_', 2);//split and name compare new value with old values
                  System.debug(res);
                 if(eachDoc.Name.contains(res[1]))
                     oldNewCD.put(eachDoc.Id, CDList.get(key).Id);// 
                }
            }
            List<ContentDocumentLink> toBeClonedContentDocumentLinks = [SELECT ContentDocumentId, ContentDocument.title ,Id,
                                                                        IsDeleted,LinkedEntityId,ShareType,SystemModstamp,
                                                                        Visibility FROM ContentDocumentLink where 
                                                                        (NOT ContentDocument.title like '%_SF_Gen%')
                                                                        AND LinkedEntity.Type='ASC_Contractual_Document__c'
                                                                        and LinkedEntityId=:oldNewCD.keySet()];
            
            
            for(ContentDocumentLink cdl : toBeClonedContentDocumentLinks){
                System.debug('cdl '+cdl);
                cdl.Id=null;
                cdl.LinkedEntityId = oldNewCD.get(cdl.LinkedEntityId);
                System.debug('new cdl '+cdl.LinkedEntityId);
            }
            System.debug('manualDoc insert Size '+toBeClonedContentDocumentLinks.size());
            try{
                database.insert(toBeClonedContentDocumentLinks,false);
                system.debug('toBeClonedContentDocumentLinks are=====>'+toBeClonedContentDocumentLinks);
            } Catch(Exception e){
                System.debug('contentfiles == '+e);
                GA_LogExceptionCls.LogExcp(e, CLASSNAME, CREATECONTRACTDOCUMENTS);}         
        } 
        
        /*
        @Description: createContractualDocuments() method   
        @Name : createContractualDocuments
        @Param : Id ContractId
        @Return :void
        */
        public static void createContractualDocuments(Id ContractId,Id QuoteId, String RenewalYear,String carrier)
        {
            List<ASC_Contractual_Document__c> newCDList = new List<ASC_Contractual_Document__c>();
         
            ASC_Contractual_Document__c contractDoc = new ASC_Contractual_Document__c();
            contractDoc.put(ASC_CONTRACT,ContractId);
            contractDoc.put(ASC_DOCUMENT_TYPE,SCHEDULEA);
            contractDoc.put(ASC_SIGNATURE_REQUIRED,true);
            contractDoc.put(DOC_VERSION,SCHEDULA_DEFAULT);
            contractDoc.put(DOC_REF_YEAR,RenewalYear);
           
            contractDoc.put(NAME,ContractId); 
            newCDList.add(contractDoc); 
         
            
            contractDoc = new ASC_Contractual_Document__c();
            contractDoc.put(ASC_CONTRACT,ContractId);
            contractDoc.put(ASC_DOCUMENT_TYPE,SCHEDULEA_EXHIBIT_1);
            contractDoc.put(ASC_SIGNATURE_REQUIRED,true);
            contractDoc.put(DOC_VERSION,SCHA_EXHIBIT1_DEF);
            contractDoc.put(DOC_REF_YEAR,RenewalYear);
            contractDoc.put(NAME,ContractId);
            newCDList.add(contractDoc);
            
            contractDoc = new ASC_Contractual_Document__c();
            contractDoc.put(ASC_CONTRACT,ContractId);
            contractDoc.put(ASC_DOCUMENT_TYPE,SCHEDULEB);
            contractDoc.put(ASC_SIGNATURE_REQUIRED,true);
            if(BCBSM_CARRIER.equals(carrier)){
                contractDoc.put(DOC_VERSION,SCHEDULEB_BCBSM);
            }
            else{
                contractDoc.put(DOC_VERSION,SCHEDULEB_BCN);
            }
              contractDoc.put(DOC_REF_YEAR,RenewalYear);
            contractDoc.put(NAME,ContractId);
            newCDList.add(contractDoc);
            
            //Get the Active Document Language Records associated with Quote.        
            List<ASC_Document_Language__c> docLang = new List<ASC_Document_Language__c>([Select id,ASC_Document_Type__c
                                                                                         from ASC_Document_Language__c 
                                                                                         where ASC_Quote__c=:QuoteId 
                                                                                         and (ASC_Document_Language_State__c=:ACTIVE 
                                                                                         OR ASC_Document_Language_State__c=:DRAFT) 
                                                                                         limit 100]);        
            List<ASC_Contractual_Document__c> newSchExh2CDList = new List<ASC_Contractual_Document__c>();
            List<ASC_Contractual_Document__c> contAmendCDList = new List<ASC_Contractual_Document__c>();
            List<ASC_Contractual_Document__c> stopLossAmendCDList = new List<ASC_Contractual_Document__c>();        
                if(docLang !=null && docLang.size()>0)
                {
                    for(integer i=0;i<docLang.size();i++)
                    {
                        ASC_Document_Language__c eachDoclang = docLang[i];
                        if(SCHEDULEA_EXHIBIT2.equals(eachDoclang.ASC_Document_Type__c))
                        {
                            contractDoc = new ASC_Contractual_Document__c();
                            contractDoc.put(ASC_CONTRACT,ContractId);
                            contractDoc.put(ASC_DOCUMENT_TYPE,SCHEDULEA_EXHIBIT_2);
                            contractDoc.put(ASC_DOCUMENT_LANGUAGE,eachDoclang.Id);
                            contractDoc.put(ASC_SIGNATURE_REQUIRED,true);
                            contractDoc.put(DOC_VERSION,SCHA_EXHIBIT2_DEF);
                            contractDoc.put(DOC_REF_YEAR,RenewalYear);
                            contractDoc.put(NAME,ContractId);
                            newSchExh2CDList.add(contractDoc);
                        }
                        else if(STOPLOSS_AMENDMENT.equals(eachDoclang.ASC_Document_Type__c))
                        {
                            contractDoc = new ASC_Contractual_Document__c();
                            contractDoc.put(ASC_CONTRACT,ContractId);
                            contractDoc.put(ASC_DOCUMENT_TYPE,eachDoclang.ASC_Document_Type__c);
                            contractDoc.put(ASC_DOCUMENT_LANGUAGE,eachDoclang.Id);
                            contractDoc.put(ASC_SIGNATURE_REQUIRED,true);
                            contractDoc.put(DOC_VERSION,STOPLOSS_AMENDMENT_DEF);
                            contractDoc.put(DOC_REF_YEAR,RenewalYear);
                            contractDoc.put(NAME,ContractId);
                            stopLossAmendCDList.add(contractDoc);
                        }
                        else if(CONTRACT_AMENDMENT.equals(eachDoclang.ASC_Document_Type__c)){
                            contractDoc = new ASC_Contractual_Document__c();
                            contractDoc.put(ASC_CONTRACT,ContractId);
                            contractDoc.put(ASC_DOCUMENT_TYPE,eachDoclang.ASC_Document_Type__c);
                            contractDoc.put(ASC_DOCUMENT_LANGUAGE,eachDoclang.Id);
                            contractDoc.put(ASC_SIGNATURE_REQUIRED,true);
                            contractDoc.put(DOC_VERSION,CONTRACT_AMENDMENT_DEF);
                            contractDoc.put(DOC_REF_YEAR,RenewalYear);
                            contractDoc.put(NAME,ContractId);
                            contAmendCDList.add(contractDoc);
                        }
                        else{}
                    }
                }
            
                if(!newSchExh2CDList.isEmpty() && newSchExh2CDList.size()==1){
                    newCDList.add(newSchExh2CDList.get(0));
                }
                else{
                    for(integer i=0;i<newSchExh2CDList.size();i++){
                       ASC_Contractual_Document__c eachCD = newSchExh2CDList.get(i);
                       eachCD.put(ASC_DOCUMENT_LANGUAGE,STRING_EMPTY);
                       newCDList.add(eachCD);
                    }
                }
                
                if(!stopLossAmendCDList.isEmpty() && stopLossAmendCDList.size()==1){
                    newCDList.add(stopLossAmendCDList.get(0));
                }
                else{
                    for(integer i=0;i<stopLossAmendCDList.size();i++){
                       ASC_Contractual_Document__c eachCD = stopLossAmendCDList.get(i);
                       eachCD.put(ASC_DOCUMENT_LANGUAGE,STRING_EMPTY);
                       newCDList.add(eachCD);
                    }
                }
                
                if(!contAmendCDList.isEmpty() && contAmendCDList.size()==1){
                    newCDList.add(contAmendCDList.get(0));
                }
                else{
                    for(integer i=0;i<contAmendCDList.size();i++){
                       ASC_Contractual_Document__c eachCD = contAmendCDList.get(i);
                       eachCD.put(ASC_DOCUMENT_LANGUAGE,STRING_EMPTY);
                       newCDList.add(eachCD);
                    }
                }        
            
            List<QuoteLineItem> qliStopLoss = new List<QuoteLineItem>([Select id from QuoteLineItem where QuoteId=:QuoteId 
                                                                       AND ASC_Product_Code__c=:DATA_FEED_PDTCODE limit 1]);
            if(qliStopLoss != null && qliStopLoss.size()>0)
            {
            contractDoc = new ASC_Contractual_Document__c();
            contractDoc.put(ASC_CONTRACT,ContractId);
            contractDoc.put(ASC_DOCUMENT_TYPE,STOPLOSS_EXHIBIT);
            contractDoc.put(ASC_SIGNATURE_REQUIRED,true);
            contractDoc.put(DOC_VERSION,STOPLOSS_EXHIBIT_DEFAULT);
            contractDoc.put(DOC_REF_YEAR,RenewalYear);
            contractDoc.put(NAME,ContractId);
            newCDList.add(contractDoc);
                
            contractDoc = new ASC_Contractual_Document__c();
            contractDoc.put(ASC_CONTRACT,ContractId);
            contractDoc.put(ASC_DOCUMENT_TYPE,STOPLOSS_POLICY);
            contractDoc.put(ASC_SIGNATURE_REQUIRED,true);
            contractDoc.put(DOC_VERSION,STOPLOSS_POLICY_DEFAULT);
            contractDoc.put(DOC_REF_YEAR,RenewalYear);    
            contractDoc.put(NAME,ContractId);
            newCDList.add(contractDoc); 
            }
            try{
                 database.insert(newCDList);
                system.debug('newCDList=====>'+newCDList);
                //To insert manual files under new contractual document
               list<String> docType = new list<String>();
                for(ASC_Contractual_Document__c cdoc:[select id,ASC_Document_Type__c from ASC_Contractual_Document__c where id in:newCDList ]){
                    docType.add(cdoc.ASC_Document_Type__c);
                 } 
              // System.debug('Doc Type '+docType);
                //List<ASC_Contractual_Document__c> newc = [select id, name from ASC_Contractual_Document__c where  id in :newCDList ];
                ID oldContractID = [select id,ParentContractId__c from Quote where id = :QuoteId limit 1].ParentContractId__c;
                List<ASC_Contractual_Document__c> oldCDclone = [Select id, name,ASC_Document_Type__c,Document_Version__c,Stop_Loss_Amendment_Reference__c,  ASC_Do_Not_Include__c,ASC_Signature_Required__c,
                                                                 Document_Language_Required__c,ASC_Contract__c,ASC_Document_Language__c,Doc_Reference_Year__c,Document_Source__c,ASC_Date_Signed__c,ASC_Compliance_Notes__c from ASC_Contractual_Document__c 
                                                                where  ASC_Document_Type__c NOT IN :docType 
                                                                AND ASC_Document_Type__c !='Group Signed Package' 
                                                                AND ASC_Contract__c = :oldContractID ];
                //System.debug('cloneSize '+oldCDclone.size());
                
                List<ASC_Contractual_Document__c> contrDList=new List<ASC_Contractual_Document__c>();
                
                if(oldCDclone.size()>0){
                    for(ASC_Contractual_Document__c cdocument : oldCDclone){

                      ASC_Contractual_Document__c ascCdl=new ASC_Contractual_Document__c();
                        //cdocument.name = ContractId;
                        ascCdl.name=ContractId;
                       //cdocument.ASC_Contract__c = ContractId;
                        ascCdl.ASC_Contract__c = ContractId;
                        ascCdl.ASC_Document_Type__c=cdocument.ASC_Document_Type__c;
                        ascCdl.Document_Version__c=cdocument.Document_Version__c;
                        contrDList.add(ascCdl);
                    }              
                    
                    try{
                       
                       database.insert(contrDList);
                    }
                    catch(Exception e){
                        System.debug('Insertion failed line 325 '+e);
                    }
                }  
                 
                if(oldContractID != NULL){
                cloneFilesFromContractualDocument(oldContractID,ContractId ); 
                } 
            }    
            
                Catch(Exception e) {
                    GA_LogExceptionCls.LogExcp(e, CLASSNAME, CREATECONTRACTDOCUMENTS);
                system.debug('e vlaues are==>'+e);
                }
                   
        }
        
        /*
        @Description: buildContractProps() method 
        @Name : buildContractProps
        @Param : list<ASC_Quote_Contract_Mapping__mdt> quoteContractMappingMdt,Quote quoteRec
        @Return :Contract
        */
        public static Contract buildContractProps(list<ASC_Quote_Contract_Mapping__mdt> quoteContractMappingMdt,Quote quoteRec){
            try{        
                Contract newContract = new Contract();
                newContract.put(STATUS,DRAFT);
                newContract.put(RECORDTYPEID, ASC_CONTRACT_RECTYPEID);
                String quoteId = quoteRec.Id;
                Quote accQuote = [Select Id, AccountId,OpportunityId from Quote where Id=:quoteId limit 100];  
                Account acc=[Select Id, GA_Territory__r.GA_RetentionSalesRepresentative__r.Name,GA_Territory__r.GA_RetentionSalesRepresentative__r.Email from Account where id=:accQuote.AccountId limit 100];
                newContract.put(accountId,accQuote.AccountId);
                newContract.put(VLOCITYQUOTEID,quoteId);
                newContract.put(VLOCITYOPPID,accQuote.OpportunityId);        
                newContract.put(SALESREPNAME,acc.GA_Territory__r.GA_RetentionSalesRepresentative__r.Name);
                newContract.put(SALESREPEMAIL,acc.GA_Territory__r.GA_RetentionSalesRepresentative__r.Email);
                for(ASC_Quote_Contract_Mapping__mdt quoteContractMap:quoteContractMappingMdt){   
                    if(quoteRec.get(quoteContractMap.Parent_API_Name__c) !=null){   
                        newContract.put(quoteContractMap.Child_API_Name__c,quoteRec.get(quoteContractMap.Parent_API_Name__c));
                    }
                }
                newContract = populateBankInfo(accQuote.AccountId, quoteRec.ASC_Carrier__c, newContract);
                insert newContract;
                return newContract;
            }
            catch(Exception e){GA_LogExceptionCls.LogExcp(e, CLASSNAME, BUILDCONTRACTPROPS_METHOD);return null;}          
        }
              
        /*
        @Description: buildInsertContractLineProps() method 
        @Name : buildInsertContractLineProps
        @Param : list<ASC_Quote_Contract_Mapping__mdt> quoteLineContractLineMappingMdt,Quote quoteRec,Id contractId
        @Return :void
        @US Number : US-3656 updated the method as part of quoting performance.
        */
        public static void buildInsertContractLineProps(list<ASC_Quote_Contract_Mapping__mdt> 
                                                        quoteLineContractLineMappingMdt,Quote quoteRec,Id contractId){
                                                              
          try{        
            Set<String> fieldMap = new Set<String>();
            String soqlQuery = SELECT_STRING ;       
            for(ASC_Quote_Contract_Mapping__mdt quoteContractMap:quoteLineContractLineMappingMdt)
            { 
                fieldMap.add(quoteContractMap.Parent_API_Name__c);
            }
            fieldMap.add(REC_ID);
            fieldMap.add(PARENTITEMPRODUCTCODEFIELD);
            for (String s :fieldMap ){            
                soqlQuery +=  + s+STR_COMMA;          
            }        
            soqlQuery =  soqlQuery.removeEnd(STR_COMMA);
            String quoteRecId= quoteRec.Id; 
            soqlQuery += ' FROM QuoteLineItem WHERE QuoteId =: quoteRecId' ; 
            List<QuoteLineItem> record = Database.query(soqlQuery); 
                               
            List<vlocity_ins__ContractLineItem__c> parentPlansToInsert = new List<vlocity_ins__ContractLineItem__c>();    
            List<QuoteLineItem> childQLIList = new List<QuoteLineItem>();              
            if(!record.isEmpty()){
                for(QuoteLineItem eachRec : record){
                  if(eachRec.vlocity_ins__ParentItemId2__c == null){
                    vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
                    for(ASC_Quote_Contract_Mapping__mdt quoteContractMap: quoteLineContractLineMappingMdt){                     
                            plan.vlocity_ins__ContractId__c = contractId;                        
                            plan.put(quoteContractMap.Child_API_Name__c,eachRec.get(quoteContractMap.Parent_API_Name__c));                                  
                    }
                    parentPlansToInsert.add(plan);              
                  }
                  else{
                    childQLIList.add(eachRec); //Adding coveragespec products QLIList where vlocity_ins__ParentItemId2__c !=null             
                  }
                }
            }
            if(!parentPlansToInsert.isEmpty()){
               Insert parentPlansToInsert; //parent plan Insertion
            }
            Map<String,String> planParentIdMap = new Map<String,String>();
            if(!parentPlansToInsert.isEmpty()){
                for(vlocity_ins__ContractLineItem__c planParent:[Select Id,Name,ASC_Account__c,vlocity_ins__ProductCode__c
                                                                from vlocity_ins__ContractLineItem__c where Id IN:parentPlansToInsert
                                                                LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                    planParentIdMap.put(planParent.vlocity_ins__ProductCode__c,planParent.Id);
                }      
            }
            
            List<vlocity_ins__ContractLineItem__c> childPlansToInsert = new List<vlocity_ins__ContractLineItem__c>();
            if(!childQLIList.isEmpty()){
                for(QuoteLineItem eachRec : childQLIList){   //Iterating through coveragespec QLIList to insert coveragespec products plan records                  
                  if(eachRec.vlocity_ins__ParentItemId2__c != null){            
                    vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
                    for(ASC_Quote_Contract_Mapping__mdt quoteContractMap: quoteLineContractLineMappingMdt){    
                        if(!VLOCITY_INS_PARENTITEMID2.equals(quoteContractMap.Parent_API_Name__c)){                 
                            plan.vlocity_ins__ContractId__c = contractId;
                            plan.put(quoteContractMap.Child_API_Name__c,eachRec.get(quoteContractMap.Parent_API_Name__c));                                  
                            plan.put(VLOCITY_INS_PARENTITEMID,planParentIdMap.ContainsKey(eachRec.vlocity_ins__ParentItemId2__r.ASC_Product_Code__c)?
                            planParentIdMap.get(eachRec.vlocity_ins__ParentItemId2__r.ASC_Product_Code__c):null); // updating the parent product plan id         
                        }
                    }
                    childPlansToInsert.add(plan);                                
                  }
                }   
            }
            if(!childPlansToInsert.isEmpty()){
              Insert childPlansToInsert;//child plan Insertion
            }
            //updating the plan Id's
            //Map<Id,Id> lieIDMap = new Map<Id,Id>();
            Map<Id,vlocity_ins__ContractLineItem__c> lieIDMap = new Map<Id,vlocity_ins__ContractLineItem__c>();
            for(vlocity_ins__ContractLineItem__c cLI:[Select Id,ASC_Line_Item_Extension__c,LastModifiedDate from vlocity_ins__ContractLineItem__c where Id IN:childPlansToInsert
                                                      LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
              lieIDMap.put(cLI.ASC_Line_Item_Extension__c,cLI);
            } 
            
            List<Line_Item_Extension__c> lieToUpdate = new List<Line_Item_Extension__c>();
            for(Line_Item_Extension__c lie:[Select id,Plan_ID__c from Line_Item_Extension__c where ID IN:lieIDMap.KeySet()
                                           LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
              if(lieIDMap.ContainsKey(lie.Id)){
                lie.Plan_ID__c = lieIDMap.get(lie.Id).Id;
                  //D-1964 for updating ASC_Last_Updated_Date__c field on Line item Extension.
                lie.ASC_Last_Updated_Date__c = lieIDMap.get(lie.Id).LastModifiedDate;
                lieToUpdate.add(lie);
              }
            }
            if(!lieToUpdate.isEmpty()){
              update lieToUpdate;
            }
              //end plan id's update
            
          }  
          catch(Exception e){GA_LogExceptionCls.LogExcp(e, CLASSNAME, BUILDINSERTCONTRACTLINEPROPS_METHOD);}                                                                            
        }
        
    
                
        /*
        @Description: populateBankInfo() method 
        @Name : populateBankInfo
        @Param : String accountId,String carrier,Contract newContract
        @Return :Contract
        */
        public static Contract populateBankInfo(String accountId,String carrier,Contract newContract)
        {
            try
            {
                Account acc = [Select id,ASC_BCBSM_Bank__c,ASC_BCN_Bank__c from Account where id=:accountId limit 10];
                String bcbsmBank = acc.ASC_BCBSM_Bank__c;
                String bcnBank = acc.ASC_BCN_Bank__c;
                if(carrier !=null && BCBSM_CARRIER.equals(carrier) && bcbsmBank != null){
                               
                    Bank_Info__c bankInfo = [Select id,Name,American_Bank_Association__c,Wire_Number__c 
                                             from Bank_Info__c where id=:bcbsmBank limit 10];
                    if(bankInfo !=null){
                        newContract.ASC_American_Bank_Association__c =bankInfo.American_Bank_Association__c;
                        newContract.ASC_Bank_Name__c=bankInfo.Name;
                        newContract.ASC_Wire_Number__c=bankInfo.Wire_Number__c;                   
                    }                               
                }
                else if(carrier !=null && BCN_CARRIER.equals(carrier)){               
                
                    Bank_Info__c bankInfo = [Select id,Name,American_Bank_Association__c,Wire_Number__c 
                                             from Bank_Info__c where id=:bcnBank limit 10];
                    if(bankInfo !=null){
                        newContract.ASC_American_Bank_Association__c =bankInfo.American_Bank_Association__c;
                        newContract.ASC_Bank_Name__c=bankInfo.Name;
                        newContract.ASC_Wire_Number__c=bankInfo.Wire_Number__c;                   
                    }                
                }
                else{}
            }
            catch(Exception e){GA_LogExceptionCls.LogExcp(e, CLASSNAME, BUILDINSERTCONTRACTLINEPROPS_METHOD);}         
            return newContract;
        }
    }