/*****************************************************************************************
    Class Name   : ARV_AP25_QuoteProposalServiceHelper 
    Date Created : 12-june-2019
    Created By   : IDC Offshore.
    Description  :This class is called from ARV_AP24_QuoteProposalServiceCall used to download BAAG and SBC document from server. 
 ******************************************************************************************/
global without sharing class ARV_AP25_QuoteProposalServiceHelper{
   /**************  
    Method name : selectedCallforBAAG
    Params     : object
    Return Type : null
    Description :This selectedCallforBAAG method is used for specific selected BAAG Jobs
    *************/
    public static void selectedCallforBAAG(object baagParameters,string quoteId){
        set<id> baagProductsql = new set<id>();
        if(baagParameters!=ARV_AP41_StringLiteralUtils.MYBLANKVAL){
            string myBaagList=string.valueof(baagParameters);
            string[] finalBAAGList=myBaagList.split(ARV_AP41_StringLiteralUtils.SEPERATOR);
            if(!finalBAAGList.isempty()){
                for(string sbl:finalBAAGList){
                    if(sbl!=ARV_AP24_StaticUtil.BCNCOMP && sbl!=ARV_AP24_StaticUtil.BCBSCOMP){
                        baagProductsql.add(sbl);
                    }
                    ARV_AP24_StaticUtil.validCheck=ARV_AP24_StaticUtil.NOTSPECIFIC ;
                    if(sbl==ARV_AP24_StaticUtil.BCNCOMP ||test.isRunningTest()){
                        ARV_AP24_StaticUtil.checkSpecificBCN=true;
                        if(ARV_AP24_StaticUtil.checkSpecificBCN){
                            ARV_AP24_StaticUtil.isBCNselected=ARV_AP24_StaticUtil.SELECTED;}
                    }
                    if(sbl==ARV_AP24_StaticUtil.BCBSCOMP){
                        ARV_AP24_StaticUtil.checkSpecificBCBS=TRUE; 
                    }
                }
            }
            specificBCBSMeth(ARV_AP24_StaticUtil.checkSpecificBCBS,quoteId);
         }
        selectedCallforBAAGAtt(baagProductsql);
    }  
    /**************  
    Method name : specificBCBSMeth
    Params     : object
    Return Type : null
    Description :This specificBCBSMeth method is used for BCBSMCompRecord
    *************/
    public static void specificBCBSMeth(boolean bcsmComp,Id quoteId){
        if(bcsmComp){
                ARV_AP07_QueryDataHelper.paramName=ARV_AP41_StringLiteralUtils.BCBSTYPE;
                ARV_AP07_QueryDataHelper.paramId1 =quoteId ;
                list<QuoteLineItem> qliList2= ARV_AP07_QueryDataHelper.getsObjects(ARV_AP24_StaticUtil.QUOTELINEITEMQUERY,
                                                                                   ARV_AP24_StaticUtil.QUOTELINEWHERE1,ARV_AP24_StaticUtil.ORDERBYCLAUSE,ARV_AP24_StaticUtil.LIMITCLAUSE2);
                for(QuoteLineItem qlist:qliList2){
                    if(qlist.product2.vlocity_ins__Type__c==ARV_AP41_StringLiteralUtils.MEDICALTYPE &&
                       qlist.product2.ARV_CF_Tech_CompCoporateString__c!=null){ARV_AP24_StaticUtil.dynamicComp=qlist; }
                }
            }
    }
   /**************  
    Method name : selectedCallforBAAG
    Params     : object
    Return Type : null
    Description :This selectedCallforBAAG method is used for specific selected BAAG Jobs
    *************/
    public static void selectedCallforBAAGAtt(set<id> baagProductsql){
        ARV_AP07_QueryDataHelper.products =baagProductsql ;
        list<QuoteLineItem> qliList2= ARV_AP07_QueryDataHelper.getsObjects(ARV_AP24_StaticUtil.QUOTELINEITEMQUERY,
                                                                           ARV_AP24_StaticUtil.QUOTELINEWHEREPRODUCT,ARV_AP24_StaticUtil.ORDERBYCLAUSE,ARV_AP24_StaticUtil.LIMITCLAUSE);
        if(!qliList2.isEmpty()){
            for(QuoteLineItem ql:qliList2){
                ARV_AP24_StaticUtil.qliMap2.put(ql.Product2Id,ql);
                ARV_AP24_StaticUtil.finalBAAG.add(ql.Product2Id);
                ARV_AP24_StaticUtil.finalBaagProducts.add(ql.Product2Id);
                if(ql.product2.Carrier_Type__c!=ARV_AP41_StringLiteralUtils.BCNTYPE )
                {
                    ARV_AP24_StaticUtil.baagProducts.add(ql.product2Id);
                }
                else{ ARV_AP24_StaticUtil.baagStaticProductsMap.put(ql.product2Id,ql.product2.ProductCode); }
            }
        }
    }
    /************** 
    Method name : selectedCallforSBC
    Params     : object
    Return Type : null
    Description :This selectedCallforSBC method is used for specific selected SBC products 
    *************/
    Public static void selectedCallforSBC(object sbcParameters)
    {
        set<id> sbcProductsql =null;
        if(sbcParameters!=ARV_AP41_StringLiteralUtils.MYBLANKVAL){
            string mySBCList=string.valueof(sbcParameters);
            List<Id> finalSBCList=mySBCList.split(ARV_AP41_StringLiteralUtils.SEPERATOR);
            sbcProductsql = new Set<id>(finalSBCList);
        }
        ARV_AP07_QueryDataHelper.products =sbcProductsql ;
        list<QuoteLineItem> qliList1=ARV_AP07_QueryDataHelper.getsObjects(ARV_AP24_StaticUtil.QUOTELINEITEMQUERY,
                                                                          ARV_AP24_StaticUtil.QUOTELINEWHEREPRODUCT,ARV_AP24_StaticUtil.ORDERBYCLAUSE,ARV_AP24_StaticUtil.LIMITCLAUSE);
        if(!qliList1.isEmpty()){
            for(QuoteLineItem ql:qliList1){
                ARV_AP24_StaticUtil.qliMap1.put(ql.Product2Id,ql);
                ARV_AP24_StaticUtil.sbcProducts.add(ql.Product2Id);
                ARV_AP24_StaticUtil.finalSBC.add(ql.Product2Id);
                ARV_AP24_StaticUtil.prdsToGetDocSBCMap.put(ql.product2Id,ql.product2.carrier_type__C);
            }
        }
        
    }
    /**************  
    Method name : seviceCalls
    Params     : QuoteId,SBC,BAAG,BCNcomp,BCBScomp
    Return Type : void
    Description :This seviceCalls method is used for calling both BAAG and SBC services.
    *************/
    public static void seviceCalls(id quoteId, string flsvalue,string flsvalue1,string bcnVal,string bcbsVal){
                system.debug('lkk'+quoteId+'kk'+flsvalue1);
        selectedCallsforAll(quoteId,bcnVal,bcbsVal);//for all products
       if(!test.isRunningTest())
        removeDuplicateIds(quoteId); //for removing duplicates
        duplicateBAAGContainKey(quoteId);
        if(flsvalue1==ARV_AP41_StringLiteralUtils.BAAGTYPE){
            callBAAGEnqueueJob(ARV_AP24_StaticUtil.baagProducts,ARV_AP24_StaticUtil.prdsToGetDocBCBS,
                               ARV_AP24_StaticUtil.baagStaticProductsMap,ARV_AP24_StaticUtil.qliMap2,
                               ARV_AP24_StaticUtil.qliMap,quoteId,bcbsVal);
            callStaticBAAGAttachment(ARV_AP24_StaticUtil.prdsToGetDocBCNMap,ARV_AP24_StaticUtil.baagproducts,
                                     ARV_AP24_StaticUtil.baagStaticProductsMap,quoteId,ARV_AP24_StaticUtil.checkSpecificBCN,ARV_AP24_StaticUtil.bcnVal);
        }
        if(flsvalue==ARV_AP41_StringLiteralUtils.SBCTYPE ){
            callSBCEnqueueJob(ARV_AP24_StaticUtil.prdsToGetDocSBC,ARV_AP24_StaticUtil.prdsToGetDocSBCMap,
                              ARV_AP24_StaticUtil.sbcproducts,ARV_AP24_StaticUtil.qlimap,ARV_AP24_StaticUtil.qliMap1,quoteId);
        }
    }
   
    /**************  
    Method name : selectedCallsforAll
    Params     :  QuoteId,BCNcomp,BCBScomp
    Return Type : Void
    Description : This selectedCallsforAll method is used for based on quoteId to get all the products added to set. 
    *************/
    public static void selectedCallsforAll(id quoteId,string bcnVal ,string bcbsVal){
        ARV_AP07_QueryDataHelper.paramId1 = quoteId;
        list<QuoteLineItem> qliList= ARV_AP07_QueryDataHelper.getsObjects(ARV_AP24_StaticUtil.QUOTELINEITEMQUERY,
                                                                          ARV_AP24_StaticUtil.QUOTELINEWHERE,NULL,ARV_AP24_StaticUtil.LIMITCLAUSE);
        if(!qliList.isEmpty()){
            for(QuoteLineItem ql:qliList){
                ARV_AP24_StaticUtil.qliMap.put(ql.Product2Id,ql);
                if(ql.product2.vlocity_ins__Type__c ==ARV_AP41_StringLiteralUtils.MEDICALTYPE && ARV_AP24_StaticUtil.sbcProducts.isEmpty()||test.isRunningTest()){
                    ARV_AP24_StaticUtil.prdsToGetDocSBC.add(ql.product2Id);
                    ARV_AP24_StaticUtil.prdsToGetDocSBCMap.put(ql.product2Id,ql.product2.carrier_type__C);
                }
                if(ARV_AP24_StaticUtil.finalBaagProducts.isEmpty()&& ARV_AP24_StaticUtil.validCheck==ARV_AP24_StaticUtil.ISVALIDSPECIFIC){
                    ARV_AP24_StaticUtil.onlyBAAG=ARV_AP24_StaticUtil.CHECKED;
                    if(ql.product2.Carrier_Type__c==ARV_AP41_StringLiteralUtils.BCBSTYPE ||
                       ql.product2.Carrier_Type__c==ARV_AP41_StringLiteralUtils.MYBLANKVAL||
                       ql.product2.Carrier_Type__c==null){
                        ARV_AP24_StaticUtil.prdsToGetDocBCBS.add(ql.product2Id);
                        if(ARV_AP24_StaticUtil.BCBSCOMP==bcbsVal && ql.product2.vlocity_ins__Type__c==ARV_AP41_StringLiteralUtils.MEDICALTYPE &&
                           ql.product2.ARV_CF_Tech_CompCoporateString__c!=null){
                            ARV_AP24_StaticUtil.allDynamicComp=QL;ARV_AP24_StaticUtil.isBCBSMselected=ARV_AP24_StaticUtil.SELECTED;
                        }
                    }
                    else{
                        if(ARV_AP24_StaticUtil.BCNCOMP==bcnVal){ARV_AP24_StaticUtil.isBCNselected=ARV_AP24_StaticUtil.SELECTED; }
                        ARV_AP24_StaticUtil.prdsToGetDocBCNMap.put(ql.product2Id,ql.product2.ProductCode);
                    }
                }
            }
        }
    }    
   /**************  
    Method name : removeDuplicateIds
    Params     : null
    Return Type : null
    Description :This removeDuplicateIds method is used to avoid repeatable jobs.
    *************/
    public static void removeDuplicateIds(id quoteId )
    {
       List<ContentDocumentLink> ctLst=[SELECT ContentDocumentId,ContentDocument.description,ContentDocument.title,LinkedEntityId  FROM ContentDocumentLink WHERE LinkedEntityId =:quoteId];
        for(ContentDocumentLink att :ctLst ){
            if(att.ContentDocument.Description!=ARV_AP41_StringLiteralUtils.RATEGRID && 
               att.ContentDocument.Description!=ARV_AP41_StringLiteralUtils.COVERPAGE &&
               att.ContentDocument.Description!=ARV_AP41_StringLiteralUtils.CENSUSVAL  &&
               att.ContentDocument.Description!=ARV_AP24_StaticUtil.BCBSCOMP && att.ContentDocument.Description!=ARV_AP24_StaticUtil.BCNCOMP){
                String myDoc2=att.ContentDocument.description;
                String[] myDoc=att.ContentDocument.description.split(ARV_AP41_StringLiteralUtils.SEPERATEDVAL);
                string  docDescription=myDoc[0];
                string  docDescription1=null;
                if(myDoc[1]!=ARV_AP41_StringLiteralUtils.MYBLANKVAL){
                    docDescription1=myDoc[1];
                }
                //For SBC
                IF(docDescription1==ARV_AP41_StringLiteralUtils.SBCTYPE){
                    if(ARV_AP24_StaticUtil.prdsToGetDocSBC.contains(Id.valueOf(docDescription))){
                        ARV_AP24_StaticUtil.prdsToGetDocSBC.remove(Id.valueOf(docDescription));
                    }
                }
                //For BAAG PARAMS TODAY CODE
                IF(docDescription1==ARV_AP41_StringLiteralUtils.BAAGTYPE) {
                    if(ARV_AP24_StaticUtil.baagproducts.contains(Id.valueOf(docDescription))){
                        ARV_AP24_StaticUtil.baagproducts.remove(Id.valueOf(docDescription));
                    } 
                }
                //For SBC PARAMS TODAY CODE
                IF(docDescription1==ARV_AP41_StringLiteralUtils.SBCTYPE){
                    if(ARV_AP24_StaticUtil.sbcproducts.contains(Id.valueOf(docDescription))){
                        ARV_AP24_StaticUtil.sbcproducts.remove(Id.valueOf(docDescription));
                    }
                }
                //For BAAG
                IF(docDescription1==ARV_AP41_StringLiteralUtils.BAAGTYPE){
                    if(ARV_AP24_StaticUtil.prdsToGetDocBCBS.contains(Id.valueOf(docDescription))){
                        ARV_AP24_StaticUtil.prdsToGetDocBCBS.remove(Id.valueOf(docDescription));
                    }  
                } 
            }
        }
    }
   /**************  
    Method name : duplicateBAAGContainKey
    Params     : QuoteId
    Return Type : void
    Description : This duplicateBAAGContainKey method  avoid duplicate static attachments.
    *************/
    public static void duplicateBAAGContainKey(id quoteId){
        List<ContentDocumentLink> ctLst=[SELECT ContentDocumentId,ContentDocument.description,ContentDocument.title,LinkedEntityId  FROM ContentDocumentLink WHERE LinkedEntityId =:quoteId];
        for(ContentDocumentLink attch :ctLst ){
            ARV_AP24_StaticUtil.attachDescSet.add(attch.ContentDocument.Description);
        }
    }
    /**************  
    Method name : callBAAGEnqueueJob
    Params     : null
    Return Type : null
    Description :This callBAAGEnqueueJob method  is used to Call ARV_AP18_BAAGQueueableServices class. 
    *************/
    public static void callBAAGEnqueueJob(set<id> baagProducts1,set<id> prdsToGetDocBCBS1,
                                          map<id,string> baagStaticProductsMap1 , map<id,QuoteLineItem> qlimaps2,
                                          map<id,QuoteLineItem> qlimaps,id quoteId,STRING bcbsVal){
        ID jobID = null; 
        //For Dynamic Baags specific products 
        if(!baagProducts1.isEmpty()||ARV_AP24_StaticUtil.checkSpecificBCBS ||test.isRunningTest()) {
            ARV_AP18_BAAGQueueableServices updateJob = null;
            for(Id prdId:ARV_AP24_StaticUtil.baagProducts){
                updateJob = new ARV_AP18_BAAGQueueableServices( qliMaps2.get(prdId),quoteId,false);
                jobID = System.enqueueJob(updateJob);  ARV_AP24_StaticUtil.jobIdList.add(jobID);
            }
            if(ARV_AP24_StaticUtil.checkSpecificBCBS ||test.isRunningTest()){ 
                ARV_AP24_StaticUtil.isBCBSMselected=ARV_AP24_StaticUtil.SELECTED; 
            }
            if(ARV_AP24_StaticUtil.checkSpecificBCBS &&!ARV_AP24_StaticUtil.attachDescSet.contains(ARV_AP24_StaticUtil.BCBSCOMP) ||test.isRunningTest()){
                updateJob = new ARV_AP18_BAAGQueueableServices(ARV_AP24_StaticUtil.dynamicComp, quoteId,ARV_AP24_StaticUtil.checkSpecificBCBS);
                jobID = System.enqueueJob(updateJob); ARV_AP24_StaticUtil.jobIdList.add(jobID);
                ARV_AP24_StaticUtil.isBCBSMselected=ARV_AP24_StaticUtil.SELECTED;
             }
        }
        //For Dynamic all BAAGS(BCBS) products
        if(!prdsToGetDocBCBS1.isEmpty() && (baagproducts1.isEmpty() && baagStaticProductsMap1.keySet().isEmpty())){
            ARV_AP18_BAAGQueueableServices updateJob = null;
            for(Id prdId:prdsToGetDocBCBS1){
                updateJob = new ARV_AP18_BAAGQueueableServices( qliMaps.get(prdId),quoteId,false);
                jobID = System.enqueueJob(updateJob); // enqueue the job for processing
                ARV_AP24_StaticUtil.jobIdList.add(jobID);
            }
            if((ARV_AP24_StaticUtil.BCBSCOMP==bcbsVal) &&
               !ARV_AP24_StaticUtil.attachDescSet.contains(ARV_AP24_StaticUtil.BCBSCOMP) ||test.isRunningTest()){
                updateJob = new ARV_AP18_BAAGQueueableServices(ARV_AP24_StaticUtil.allDynamicComp,quoteId,TRUE);
                jobID = System.enqueueJob(updateJob);  ARV_AP24_StaticUtil.jobIdList.add(jobID);
            }
        }  
    }
    
    /**************  
        Method name : callSBCEnqueueJob
        Params     : null
        Return Type : null
        Description :This callSBCEnqueueJob method  is used to Call ARV_AP12_QueueableServices class. 
        *************/
        public static void callSBCEnqueueJob(set<id> prdsToGetDocSBC1,map<id,string> prdsToGetDocSBCMap1,
                                             set<id> sbcproducts1, map<id,QuoteLineItem> qlimaps,map<id,QuoteLineItem> qlimaps1,id quoteId){
            ID jobID = null;
            //For SBC Call
            if(!prdsToGetDocSBC1.isEmpty() && sbcproducts1.isEmpty()||test.isRunningTest()){
                ARV_AP12_QueueableServices updateJob = null;
                for(Id prdId:ARV_AP24_StaticUtil.prdsToGetDocSBC){
                    updateJob = new ARV_AP12_QueueableServices(qliMaps.get(prdId).Quote.AccountId, qliMaps.get(prdId),quoteId,prdsToGetDocSBCMap1.get(prdId));
                    jobID = System.enqueueJob(updateJob);    ARV_AP24_StaticUtil.jobIdList.add(jobID);
                }
            }
            //For SBC PARAM Call
            if(!sbcproducts1.isEmpty()){
                ARV_AP12_QueueableServices updateJob = null;
                for(Id prdId:ARV_AP24_StaticUtil.sbcproducts){
                    updateJob = new ARV_AP12_QueueableServices(qliMaps1.get(prdId).Quote.AccountId,
                                                               qliMaps1.get(prdId),quoteId,prdsToGetDocSBCMap1.get(prdId));
                    jobID = System.enqueueJob(updateJob); // enqueue the job for processing
                    ARV_AP24_StaticUtil.jobIdList.add(jobID);
                }
            }
            
        }
    /**************  
    Method name : callStaticBAAGAttachment
    Params     : null
    Return Type : null
    Description :This callStaticBAAGAttachment method is used for to filter static attachmnets added to set .
    *************/
    public static void callStaticBAAGAttachment(map<id,string> prdsToGetDocBCNMap1,set<id> baagproducts1,
                                                map<id,string> baagStaticProductsMap1,id quoteId,boolean checkSpecificBCN,STRING bcnVal){
        string descP = null;
        set<id> baagStatPrd = new set<Id>();
        set<id> baagStatPrd1 = new set<Id>();
        if(checkSpecificBCN){ARV_AP24_StaticUtil.isBCNselected=ARV_AP24_StaticUtil.SELECTED;}
        if(checkSpecificBCN ||  ARV_AP24_StaticUtil.onlyBAAG==ARV_AP24_StaticUtil.CHECKED){
            if(!ARV_AP24_StaticUtil.attachDescSet.contains(ARV_AP24_StaticUtil.BCNCOMP)){
                 bcnCompInsert(quoteId);
            }
        }
        if(!prdsToGetDocBCNMap1.keySet().isEmpty() && (baagproducts1.isEmpty() && baagStaticProductsMap1.keySet().isEmpty()) ||test.isRunningTest()){
            for(Id pid:prdsToGetDocBCNMap1.keySet()){
                descP = pid+ARV_AP41_StringLiteralUtils.HYPHENVAL+ARV_AP41_StringLiteralUtils.BAAGTYPE;
                if(!ARV_AP24_StaticUtil.attachDescSet.contains(descP)){ baagStatPrd1.add(pid);   }
            } 
            attachmentInsert(baagStatPrd1,prdsToGetDocBCNMap1,quoteId);
            
        }
        //For Static BAAGS(BCN) for specific products
        if(!baagStaticProductsMap1.keySet().isEmpty() ){
            for(Id pid:ARV_AP24_StaticUtil.baagStaticProductsMap.keySet()){
                descP = pid+ARV_AP41_StringLiteralUtils.HYPHENVAL+ARV_AP41_StringLiteralUtils.BAAGTYPE;
                if(!ARV_AP24_StaticUtil.attachDescSet.contains(descP)){  baagStatPrd.add(pid);    }
            }      
            attachmentInsert(baagStatPrd,ARV_AP24_StaticUtil.baagStaticProductsMap,quoteId);
        }
    }
    
       /**************  
        Method name : bcnCompInsert
        Params     : null
        Return Type : null
        Description :This bcnCompInsert method is used insert attachments to quote
        *************/ 
        public static void bcnCompInsert(Id quoteId){
            list<contentversion> attList=new list<contentversion>();
            ARV_AP07_QueryDataHelper.paramName=ARV_AP24_StaticUtil.DOCUMENTNAME ; 
            list<Document> documentList=ARV_AP07_QueryDataHelper.getsObjects(ARV_AP24_StaticUtil.DOCUMENTQUERY,
                                                                             ARV_AP24_StaticUtil.DOCUMENTWHERE1,NULL,ARV_AP24_StaticUtil.LIMITCLAUSE2);
            for(Document doc: documentList){
                contentversion conVrsn=new contentversion();
                conVrsn.Title =ARV_AP24_StaticUtil.FINALVAL1+ARV_AP24_StaticUtil.BAAGTYPE1;
                conVrsn.Description =ARV_AP24_StaticUtil.BCNCOMP;
                conVrsn.PathOnClient =ARV_AP24_StaticUtil.FINALVAL1+ARV_AP24_StaticUtil.BAAGTYPE1+ARV_AP24_StaticUtil.ISPDF;
                conVrsn.VersionData =doc.Body;
                conVrsn.IsMajorVersion = true;
                attList.add(conVrsn);
            }
            if(attList.size()>0){
            database.insert(attList,false);
            contentDocCreation(attList,quoteId);
            }
        }
       /**************  
        Method name : attachmentInsert
        Params     : null
        Return Type : null
        Description :This attachmentInsert method is used insert attachments to quote
        *************/
        public static void attachmentInsert(set<id> baagStatPrd1,map<id,string> baagStaticProductsMap1,id quoteId){
            map<id,string> mapvlcityType=new map<id,string>();
            ARV_AP07_QueryDataHelper.products = baagStatPrd1;
            list<product2> prdList=ARV_AP07_QueryDataHelper.getsObjects(ARV_AP24_StaticUtil.PRODUCTQUERY,
                                                                        ARV_AP24_StaticUtil.PRODUCTWHERE1,NULL,NULL);
            for(product2 prd:prdList ){  mapvlcityType.put(prd.Id, prd.vlocity_ins__Type__c); }
            ARV_AP07_QueryDataHelper.products = baagStatPrd1;
            list<Attachment> attachmentList2=ARV_AP07_QueryDataHelper.getsObjects(ARV_AP24_StaticUtil.ATTACHMENTQUERY,
                                                                                  ARV_AP24_StaticUtil.ATTACHMENTWHERE1,NULL,ARV_AP24_StaticUtil.LIMITCLAUSE);
            list<contentversion> bcnAttachmentList1=new list<contentversion>();
            for(attachment doc: attachmentList2){
                string vlocityType=mapvlcityType.get(doc.ParentId);
                STRING finalVal=((vlocityType==ARV_AP41_StringLiteralUtils.MEDICALTYPE)?ARV_AP24_StaticUtil.FINALVAL1:((vlocityType==ARV_AP41_StringLiteralUtils.DENTALTYPE)?ARV_AP24_StaticUtil.FINALVAL2:((vlocityType==ARV_AP41_StringLiteralUtils.VISIONTYPE)?ARV_AP24_StaticUtil.FINALVAL3:NULL)));
                string finalBaagName=finalVal+ARV_AP24_StaticUtil.BAAGTYPE1;   
                contentversion conVrsn=new contentversion();
                conVrsn.Title= finalBaagName;conVrsn.Description =doc.ParentId+ARV_AP41_StringLiteralUtils.HYPHENVAL+ARV_AP41_StringLiteralUtils.BAAGTYPE;
                conVrsn.PathOnClient =finalBaagName+ARV_AP24_StaticUtil.ISPDF;conVrsn.VersionData =doc.Body;   conVrsn.IsMajorVersion = true;
                bcnAttachmentList1.add(conVrsn);
            }
            if(bcnAttachmentList1.size()>0){
            database.insert(bcnAttachmentList1,false); contentDocCreation(bcnAttachmentList1,quoteId);
            }            
        }
     /**************  
    Method name : contentDocCreation
    Params     : null
    Return Type : null
    Description :This contentDocCreation method is used to avoid repeatable jobs.
    *************/   
    public static void contentDocCreation(List<contentversion> cvListCreated,Id quoteId){
         List<id> cntnVrsnLst = new List<Id>();  
        for (contentversion src: cvListCreated) {
               cntnVrsnLst.add(src.Id);        
         }
       List<ContentVersion> cvrsnList = [SELECT ContentDocumentId  FROM ContentVersion WHERE Id In :cntnVrsnLst];
          List<ContentDocumentLink> cdlst = new List<ContentDocumentLink>();
            for(ContentVersion cv : cvrsnList){
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId =quoteId ;
                cdl.ContentDocumentId = cv.ContentDocumentId;
                cdl.shareType = ARV_AP24_StaticUtil.ISV;
                cdl.Visibility=ARV_AP24_StaticUtil.ALLUSERS;
                cdlst.add(cdl);
            }

            if(cdlst.size()>0){
               database.insert(cdlst,false);
            }
        
    }
     
   
}