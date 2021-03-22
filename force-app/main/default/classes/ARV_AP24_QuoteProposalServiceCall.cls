/*****************************************************************************************
    Class Name   : ARV_AP24_QuoteProposalServiceCall 
    Date Created : 12-june-2019
    Created By   : IDC Offshore.
    Description  :This class is called from ins-os-plan-docgen-template used to download BAAG and SBC document from server. 
    ******************************************************************************************/
    global without sharing virtual class ARV_AP24_QuoteProposalServiceCall implements vlocity_ins.VlocityOpenInterface2 
    {
        private static final string CLSNAME  ='ARV_AP24_QuoteProposalServiceCall';
        private static final string METHODNAME  ='invokeMethod';        
        private static final String ERRORMSG='Unable to retrieve SBC Document';  
        private static set<Id> jobIdSet1=new set<id>();
        private static set<string> jobStatus1 =new set<string>();
        private static final string JOBQUERY1='select count() from AsyncApexJob where Id in (null) '+
                                             ' and Status not in :jobStatus1';
        private static final string JOBQUERY2='select count() from AsyncApexJob where Id in :jobIdSet1 '+
                                              ' and Status not in :jobStatus1';
    private static boolean stopTimer = false;
        private static string refRateGridCheck;
        private static string refcoverPageCheck;
        private static string refcensusPageCheck;
        /**************  
        Method name : invokeMethod
        Params     : map
        Return Type : null
        Description :This invokeMethod is called from  ins-os-plan-docgen-template template for SBC and BAAG services.
        *************/
        global Object invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output,
                                   Map<String,Object> options) 
        {     
            try{
                if (methodName == ARV_AP24_StaticUtil.METHODNAME1) {           
                    generateDocument(input,output,options);
                }
                else if(methodName == ARV_AP24_StaticUtil.METHODNAME2)
                {
                    refreshDocument(input, output,options);
                }
                else if(methodName == ARV_AP24_StaticUtil.METHODNAME3)
                {
                    sendingEmails(input, output,options);
                }
                else{
                    
                }
            }  
            catch(exception e){ 
                GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME);
                throw new AuraHandledException(ERRORMSG+ARV_AP41_StringLiteralUtils.COLONVAL+e.getMessage());
            }
            return true;
        }
        /**************  
        Method name : generateDocument
        Params     : map
        Return Type : null
        Description :This generateDocument method is called from invoke method to call BAAG and SBC services.
        *************/
        global static void generateDocument(Map<String, Object> input, Map<String, Object> output,Map<String,Object> options) {
            initialiseVariables();
            string flsvalue1 =(String)input.get(ARV_AP24_StaticUtil.PARAMBAAG);
            string bcnVal =(String)input.get(ARV_AP24_StaticUtil.BCNCOMP);
            string bcbsVal =(String)input.get(ARV_AP24_StaticUtil.BCBSCOMP);
            string flsvalue=(String)input.get(ARV_AP24_StaticUtil.PARAMSBC);
            String quoteId = (String)input.get(ARV_AP41_StringLiteralUtils.QUOID);
            string rateGridCheck = input.get(ARV_AP24_StaticUtil.RATEGRIDTYPE)!=null?
                                 (String)input.get(ARV_AP24_StaticUtil.RATEGRIDTYPE):null;
            string coverPageCheck = input.get(ARV_AP24_StaticUtil.COVERPAGETYPE)!=null?
                                  (String)input.get(ARV_AP24_StaticUtil.COVERPAGETYPE):null;
            string censusPageCheck = input.get(ARV_AP24_StaticUtil.CENSUSGRID)!=null?
                                  (String)input.get(ARV_AP24_StaticUtil.CENSUSGRID):null;        
           if(rateGridCheck == ARV_AP41_StringLiteralUtils.RATEGRID || coverPageCheck == ARV_AP41_StringLiteralUtils.COVERPAGE ||
               censusPageCheck==ARV_AP41_StringLiteralUtils.CENSUSVAL){
                   ARV_AP39_AttachePDFsToQuote.attachToQuote(quoteId,rateGridCheck,coverPageCheck,censusPageCheck);
           }   
            if(flsvalue == ARV_AP41_StringLiteralUtils.SBCTYPE || flsvalue1 == ARV_AP41_StringLiteralUtils.BAAGTYPE){
                callingServices(input,quoteId);
                ARV_AP25_QuoteProposalServiceHelper.seviceCalls(quoteId,flsvalue,flsvalue1,bcnVal,bcbsVal);
            } //Call SBC and BAAG calls .
            output.put(ARV_AP24_StaticUtil.JOBLIST,ARV_AP24_StaticUtil.jobIdList);
            output.put(ARV_AP24_StaticUtil.SELECTEDSBC,ARV_AP24_StaticUtil.finalSBC);
            output.put(ARV_AP24_StaticUtil.SELECTEDBAAG,ARV_AP24_StaticUtil.finalBAAG);
            output.put(ARV_AP24_StaticUtil.SELECTEDBCBSM,ARV_AP24_StaticUtil.isBCBSMselected);
            output.put(ARV_AP24_StaticUtil.SELECTEDBCN,ARV_AP24_StaticUtil.isBCNselected);
            output.put(ARV_AP24_StaticUtil.SELECTEDBCBSMALL,ARV_AP24_StaticUtil.isBCBSMselected);
            output.put(ARV_AP24_StaticUtil.SELECTEDBCNALL,ARV_AP24_StaticUtil.isBCNselected);
            output.put(ARV_AP24_StaticUtil.ISBAAG,ARV_AP24_StaticUtil.onlyBAAG);
        }
          /**************  
        Method name : callingServices
        Params     : MAP,id
        Return Type : null
        Description :This initialiseVariables method is used for initialise variables for generateDocument Methods.
        *************/
        public static void callingServices(Map<String, Object> input,Id quoteId){
            object baagParameters=(Object)input.get(ARV_AP24_StaticUtil.MYFINALBAAGPRODUCTS);//BAAG Selected Products.
            if( baagParameters!=ARV_AP41_StringLiteralUtils.MYBLANKVAL){
                ARV_AP25_QuoteProposalServiceHelper.selectedCallforBAAG(baagParameters,quoteId);
            }
            else{
                ARV_AP24_StaticUtil.validCheck=ARV_AP24_StaticUtil.ISVALIDSPECIFIC;
            }
                Object sbcParameters = (Object)input.get(ARV_AP24_StaticUtil.MYFINALSBCPRODUCTS);//sbc Selected Products.
                if(sbcParameters!=ARV_AP41_StringLiteralUtils.MYBLANKVAL){
                    ARV_AP25_QuoteProposalServiceHelper.selectedCallforSBC(sbcParameters);
               }
        }
               
        /**************  
        Method name : initialiseVariables
        Params     : null
        Return Type : null
        Description :This initialiseVariables method is used for initialise variables for generateDocument Methods.
        *************/
        public static void initialiseVariables(){
      
            ARV_AP24_StaticUtil.prdsToGetDocSBCMap=new map<id,string>();
            ARV_AP24_StaticUtil.jobIdList = new List<string>();
            ARV_AP24_StaticUtil.attachDescSet = new List<string>();
            ARV_AP24_StaticUtil.baagProducts=new set<id>();
            ARV_AP24_StaticUtil.sbcProducts=new set<id>();
            ARV_AP24_StaticUtil.baagStaticProductsMap =new Map<Id,String>();
            ARV_AP24_StaticUtil.finalBaagProducts=new set<id>();
            ARV_AP24_StaticUtil.prdsToGetDocBCNMap=new map<id,string>();
            ARV_AP24_StaticUtil.prdsToGetDocSBC = new set<Id>();
            ARV_AP24_StaticUtil.prdsToGetDocBCBS = new set<Id>();
            ARV_AP24_StaticUtil.qlimap1  = new map<Id,QuoteLineItem>();
            ARV_AP24_StaticUtil.qlimap2  = new map<Id,QuoteLineItem>();
            ARV_AP24_StaticUtil.qliMap = new map<Id,QuoteLineItem>();
            ARV_AP24_StaticUtil.finalSBC=new set<id>();
            ARV_AP24_StaticUtil.finalBAAG=new set<Id>();
            ARV_AP24_StaticUtil.jobIdSet = new set<Id>(); 
            
        }           
        /**************  
        Method name : refreshDocument
        Params     : map
        Return Type : null
        Description :This refreshDocument method is called from invoke method
        *************/
        global static void refreshDocument(Map<String, Object> input, Map<String, Object> output,Map<String,Object> options) {
       ARV_AP24_StaticUtil.myAttachmentList=new list<string>();
             String quoteId = (String)input.get(ARV_AP41_StringLiteralUtils.QUOID);
             string flsvalue = (String)input.get(ARV_AP24_StaticUtil.PARAMSBC);
             string flsvalue1 = (String)input.get(ARV_AP24_StaticUtil.PARAMBAAG);  
             refRateGridCheck = input.get(ARV_AP24_StaticUtil.RATEGRIDTYPE)!=null?
                                    (String)input.get(ARV_AP24_StaticUtil.RATEGRIDTYPE):null;
             refcoverPageCheck = input.get(ARV_AP24_StaticUtil.COVERPAGETYPE)!=null?
                                    (String)input.get(ARV_AP24_StaticUtil.COVERPAGETYPE):null;
             refcensusPageCheck = input.get(ARV_AP24_StaticUtil.CENSUSGRID)!=null?
                                     (String)input.get(ARV_AP24_StaticUtil.CENSUSGRID):null;
             string bcbsmSelected=(String)input.get(ARV_AP24_StaticUtil.ISSELECTEDBCBS);
             string bcnSelected=(String)input.get(ARV_AP24_StaticUtil.ISSELECTEDBCN); 
             string bcbsmSelectedAll=(String)input.get(ARV_AP24_StaticUtil.ISSELECTEDBCBS1);
             string bcnSelectedAll=(String)input.get(ARV_AP24_StaticUtil.ISSELECTEDBCN1); 
             string allSecBaag=(String)input.get(ARV_AP24_StaticUtil.ISBAAG1);
             refreshJobIds(input);
             Object isSBCProductIds = (Object)input.get(ARV_AP24_StaticUtil.SCLSBCPLANS);
             Object isBAAGProductIds = (Object)input.get(ARV_AP24_StaticUtil.SCLBAAGPLANS);
             selectedProducts(isSBCProductIds,isBAAGProductIds);
             selectedAttachments(ARV_AP24_StaticUtil.productsforSBC,ARV_AP24_StaticUtil.productsforBAAG,
                                quoteId,flsvalue,flsvalue1,
                                bcbsmSelected,bcnSelected,allSecBaag,bcbsmSelectedAll,bcnSelectedAll);
             output.put(ARV_AP24_StaticUtil.VSTOPTIMER,stopTimer);
             output.put(ARV_AP24_StaticUtil.ATTACHMENTIDS,ARV_AP24_StaticUtil.myAttachmentList);
        }
         /**************  
        Method name : docJobList
        Params     : map
        Return Type : null
        Description :docJobList() method 
        *************/           
        public static void refreshJobIds(Map<String, Object> input){
            ARV_AP24_StaticUtil.jobStatus = new set<string>{ARV_AP24_StaticUtil.COMPLETED,
                                             ARV_AP24_StaticUtil.FAILED,ARV_AP24_StaticUtil.ABORTED};
             Object jobIds = (Object)input.get(ARV_AP24_StaticUtil.MYJOBSID);
             if(jobIds!=ARV_AP41_StringLiteralUtils.MYBLANKVAL){ 
                 if(!test.isRunningTest()) { 
                     docJobList(jobIds);
                 }
               }
             jobIdSet1=ARV_AP24_StaticUtil.jobIdSet;
             jobStatus1=ARV_AP24_StaticUtil.jobStatus;
       string jobQuery=(jobIdSet1==null)?JOBQUERY1:JOBQUERY2;
       integer jobCount = database.countQuery(jobQuery);
             if(jobCount==0 ){
                 stopTimer = true;
             }
        }
        /**************  
        Method name : docJobList
        Params     : map
        Return Type : null
        Description :docJobList() method 
        *************/    
        public static void docJobList(object jobIds){
       if(jobIds!=ARV_AP41_StringLiteralUtils.MYBLANKVAL){
        string myJob=string.valueof(jobIds);
                string[] myJobList=myJob.split(ARV_AP41_StringLiteralUtils.SEPERATOR);
                if(myJobList.size()>=1){          
                    for(string jobs:myJobList){
             if(ARV_AP24_StaticUtil.jobIdSet == null){
                ARV_AP24_StaticUtil.jobIdSet =  new set<Id>();
                        }
                         ARV_AP24_StaticUtil.jobIdSet.add(Id.valueof(jobs));
                    }
                }
            }
        } 
        
        /**************  
        Method name : selectedProducts
        Params     : object
        Return Type : null
        Description :This selectedProducts method to wait until job complete
        *************/
        public static void selectedProducts(object SBCProductIds,object BAAGProductIds ){
            ARV_AP24_StaticUtil.productsforBAAG=new set<id>();
            ARV_AP24_StaticUtil.productsforSBC=new set<id>();
            if(SBCProductIds!=ARV_AP41_StringLiteralUtils.MYBLANKVAL){
                string myJob=string.valueof(SBCProductIds);
                string[] myJobList=myJob.split(ARV_AP41_StringLiteralUtils.SEPERATOR);
                if(myJobList.size()>=1){
                    for(string jblst:myJobList){
                        ARV_AP24_StaticUtil.productsforSBC.add(Id.valueof(jblst));
                    }
                }
            }
            if(BAAGProductIds!=ARV_AP41_StringLiteralUtils.MYBLANKVAL){
                string myJob=string.valueof(BAAGProductIds);
                string[] myJobList=myJob.split(ARV_AP41_StringLiteralUtils.SEPERATOR);
                if(myJobList.size()>=1){
                    for(string jbs:myJobList){
                        ARV_AP24_StaticUtil.productsforBAAG.add(Id.valueof(jbs));
                    }
                }
            }
          }
        
        /**************  
        Method name : selectedAttachments
        Params     : map
        Return Type : null
        Description :This selectedAttachments method to wait until job completesss
        *************/
        public static void selectedAttachments(set<id> productsforSBC1,set<id> productsforBAAG1,Id quoteId ,string flsvalue,
                                               string flsvalue1,string bcbsmSelected,string bcnSelected,
                                               string allSecBaag,string bcbsmSelectedAll,string bcnSelectedAll){
            set<id> finalAttachmentId=new set<Id>();
            Id attachId=null;
   List<ContentDocumentLink> ctLst=[SELECT Id,LinkedEntityId, ContentDocumentId,ContentDocument.description,ContentDocument.title  FROM ContentDocumentLink WHERE LinkedEntityId =:quoteId ];
            for(ContentDocumentLink att :ctLst ){                                                   
                if(att.ContentDocument.Description!=ARV_AP41_StringLiteralUtils.RATEGRID && att.ContentDocument.Description!=ARV_AP41_StringLiteralUtils.COVERPAGE &&
                   att.ContentDocument.Description!=ARV_AP41_StringLiteralUtils.CENSUSVAL  && att.ContentDocument.Description!=ARV_AP24_StaticUtil.BCNCOMP && 
                   att.ContentDocument.Description!=ARV_AP24_StaticUtil.BCBSCOMP &&  att.ContentDocument.Description!=null){
                       String myDoc2=att.ContentDocument.description;
                       String[] myDoc=att.ContentDocument.description.split(ARV_AP41_StringLiteralUtils.SEPERATEDVAL);
                       string  productId=myDoc[0];
                       string  productType=myDoc[1];
                       attachId = ((productType==ARV_AP41_StringLiteralUtils.SBCTYPE && flsvalue ==ARV_AP41_StringLiteralUtils.SBCTYPE ) &&
                                   (productsforSBC1.contains(productId) || (flsvalue ==ARV_AP41_StringLiteralUtils.SBCTYPE &&
                                   productsforSBC1.isEmpty())))?att.ContentDocumentId:(((productType==ARV_AP41_StringLiteralUtils.BAAGTYPE)&&
                                   flsvalue1 ==ARV_AP41_StringLiteralUtils.BAAGTYPE ) && (productsforBAAG1.contains(productId) ||
                                   (productsforBAAG1.isEmpty() && allSecBaag==ARV_AP24_StaticUtil.CHECKED &&
                                    flsvalue1 ==ARV_AP41_StringLiteralUtils.BAAGTYPE))?att.ContentDocumentId:null);
                                           if(attachId !=null){
                                               finalAttachmentId.add(att.ContentDocumentId);
                                             }
                   }
                else{
                     sortingOrderAttach(att,bcbsmSelected,bcnSelected,allSecBaag,bcbsmSelectedAll,
                                        bcnSelectedAll,productsforSBC1,productsforBAAG1,finalAttachmentId,flsvalue1);
                }
            }
            //sortingOrderattachments(finalAttachmentId);
            sortingOrderFiles(finalAttachmentId,quoteId);
            
        }
        
         /**************  
        Method name : selectedAttachments
        Params     : map
        Return Type : null
        Description :This selectedAttachments method to wait until job completesss
        *************/
        public static void sortingOrderAttach(ContentDocumentLink att,string bcbsmSelected,string bcnSelected,
                                               string allSecBaag,string bcbsmSelectedAll,string bcnSelectedAll,
                                              set<id> productsforSBC1,set<id> productsforBAAG1,set<id> finalAttachmentId,string flsvalue1){
                  
                       id attachId1=null;
        attachId1=(refRateGridCheck == ARV_AP41_StringLiteralUtils.RATEGRID && att.ContentDocument.description==ARV_AP41_StringLiteralUtils.RATEGRID)
                    ?att.ContentDocumentId:((refcoverPageCheck == ARV_AP41_StringLiteralUtils.COVERPAGE && 
                     att.ContentDocument.Description==ARV_AP41_StringLiteralUtils.COVERPAGE)?att.ContentDocumentId:
                     ((refcensusPageCheck == ARV_AP41_StringLiteralUtils.CENSUSVAL && 
                     att.ContentDocument.Description==ARV_AP41_StringLiteralUtils.CENSUSVAL)?
                      att.ContentDocumentId:(((att.ContentDocument.Description==ARV_AP24_StaticUtil.BCBSCOMP)&&(productsforBAAG1.isEmpty()&&
                      flsvalue1 == ARV_AP41_StringLiteralUtils.BAAGTYPE && allSecBaag==ARV_AP24_StaticUtil.CHECKED &&
                      bcbsmSelectedAll== ARV_AP24_StaticUtil.SELECTED))?att.ContentDocumentId:(((
                      att.ContentDocument.Description==ARV_AP24_StaticUtil.BCNCOMP )&&
                       (productsforBAAG1.isEmpty()&& flsvalue1 == ARV_AP41_StringLiteralUtils.BAAGTYPE && allSecBaag==ARV_AP24_StaticUtil.CHECKED &&
                        bcnSelectedAll==ARV_AP24_StaticUtil.SELECTED ))?att.ContentDocumentId: (((att.ContentDocument.Description==ARV_AP24_StaticUtil.BCNCOMP)&&
                         (productsforBAAG1.isEmpty() && ( bcnSelected==ARV_AP24_StaticUtil.SELECTED))&& 
                          flsvalue1 == ARV_AP41_StringLiteralUtils.BAAGTYPE)?att.ContentDocumentId:(((att.ContentDocument.Description==ARV_AP24_StaticUtil.BCBSCOMP)&&
                          (productsforBAAG1.isEmpty()  && bcbsmSelected==ARV_AP24_StaticUtil.SELECTED) && 
                          flsvalue1 == ARV_AP41_StringLiteralUtils.BAAGTYPE)?att.ContentDocumentId:
                          ((!productsforBAAG1.isEmpty() && (bcbsmSelected !=null && bcbsmSelected ==ARV_AP24_StaticUtil.SELECTED) 
                           &&att.ContentDocument.Description==ARV_AP24_StaticUtil.BCBSCOMP )?att.ContentDocumentId: ((!productsforBAAG1.isEmpty() &&
                            bcnSelected==ARV_AP24_StaticUtil.SELECTED && att.ContentDocument.Description==ARV_AP24_StaticUtil.BCNCOMP )?att.ContentDocumentId:null))))))));
                             if(attachId1 !=null){
                              finalAttachmentId.add(att.ContentDocumentId);
                             }                                                  
            
        }
        /**************  
        Method name : sortingOrderattachments
        Params     : set<id>
        Return Type : null
        Description :This sortingOrderattachments() method 
        *************/
      /*  public static void sortingOrderattachments(set<id> finalAttachmentId1){
            ARV_AP07_QueryDataHelper.products = finalAttachmentId1;
            list<Attachment> attachmentList=  ARV_AP07_QueryDataHelper.getsObjects(ARV_AP24_StaticUtil.ATTACHMENTQUERY,
                                                                                   ARV_AP24_StaticUtil.ATTACHMENTWHERE3,ARV_AP24_StaticUtil.ORDERBYCLAUSE1,ARV_AP24_StaticUtil.LIMITCLAUSE);
            string  myList =ARV_AP41_StringLiteralUtils.SPACEVAL;
            for(Attachment att:attachmentList)
            {
                myList = myList + att.Id + ARV_AP41_StringLiteralUtils.COMMAVAL;
            }
            string strJsonMy=  myList;
            strJsonMy = strJsonMy.removeEnd( ARV_AP41_StringLiteralUtils.COMMAVAL );
            ARV_AP24_StaticUtil.myAttachmentList.add(strJsonMy);
        }*/
        public static void sortingOrderFiles(set<id> finalAttachmentId1,Id quoteId){
            if(finalAttachmentId1.size()>0){
            list<ContentDocumentLink> attachmentList=[SELECT ContentDocumentId,ContentDocument.description,ContentDocument.title,LinkedEntityId  FROM ContentDocumentLink WHERE ContentDocumentId in:finalAttachmentId1 and LinkedEntityId=:quoteId order by ContentDocument.title ASC ];
             string  myList =ARV_AP41_StringLiteralUtils.SPACEVAL;
            for(ContentDocumentLink att:attachmentList)
            {
                myList = myList + att.ContentDocumentId + ARV_AP41_StringLiteralUtils.COMMAVAL;
            }
            string strJsonMy=  myList;
            strJsonMy = strJsonMy.removeEnd( ARV_AP41_StringLiteralUtils.COMMAVAL );
            ARV_AP24_StaticUtil.myAttachmentList.add(strJsonMy);
            }     
        }
        /**************  
        Method name : sendingEmails
        Params     : map
        Return Type : null
        Description :This sendingEmails() method is invoked from ivnvoke method 
        *************/
        global static void sendingEmails(Map<String, Object> input, Map<String, Object> output,Map<String,Object> options)            
        {  
            list<string> myEmail=new list<string>();
            String quoteId = (String)input.get(ARV_AP41_StringLiteralUtils.QUOID);
            string emailList= (string)input.get(ARV_AP24_StaticUtil.SELECTEDEMAILS);
            Quote qute = new quote();
            qute.Id = quoteId;
            qute.ARV_CF_AdditionalEmailList__c=emailList;
            database.update(qute);
            myEmail.add(emailList);
            output.put(ARV_AP24_StaticUtil.MYEMAILIST,myEmail);
        }
    }