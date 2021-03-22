/*****************************************************************************************
Class Name   : ARV_AP15_CallOutUtils 
Date Created : 16-MAY-2019
Created By   : IDC Offshore
Description  : This  class is called from ARV_AP12_QueueableServices and ARV_AP03_SBCServiceCls to call SBC services.
******************************************************************************************/
public without sharing class ARV_AP15_CallOutUtils{
    private static final string CODEVAL=system.label.ARV_CL03_CodeVal;
    private static final String ADDINFOVAL=system.label.ARV_CL01_AdditionalInfo;
    private static final String DESCPVAL=system.label.ARV_CL08_Description;
    private static final String FOLDRNAME=system.label.ARV_CL02_BCBSM_FldrNme;
    private static final string DOCNAME='E_SBC.pdf';
    private static  String DOCCNTTYPE=system.label.ARV_CL09_DocCntType;
    private static  String DOCEXT=system.label.ARV_CL10_DocExt;
    private static final String BLOBRESPFRMT1='3e';
    private static final String BLOBRESPFRMT2='2d2d';
    private static final String REQTYP=system.label.ARV_CL15_Method_ReqType;
    private static final String JSONRESPFRMT2='>';
    private static final String JSONRESPFRMT1='--';
    private static final String SRVCVERSN=system.label.ARV_CL17_Service_Version;
    private static final String SCHMVERSN=system.label.ARV_CL16_Schema_Version;
    private static final String GRPNOKEY='GrpNumber';
    private static final String GRPNOVAL='Number';
    private static final string ENDPOINT=system.label.ARV_CL12_EndPointSBC;
    private static final String SFGRPCRM=system.label.ARV_CL04_ConsumerId;
    private static final String SFGRPCRMNM=system.label.ARV_CL05_ConsumerName;
    private static final String MESSGID=system.label.ARV_CL14_MessgID; 
    //private static final String BUSINESSAREA='Group-Sales CRM';
    private static final String BUSINESSAREA=system.label.ARV_CL54_BusinessArea;
    private static final String APPTRIGGEREVENT='Quoting';
    private static final String DOCTYP=system.label.ARV_CL11_DocTyp;
    private static final String INCLUDEATTCHHMENTIND='Y';
    private static final String BUSINSCHANL ='OBI';
    private static final String BUSINSCHANLBCN ='BCN';
    private static final String COVERAGEFOR='Individual/Family';
    private static final string SBCNAME ='SBC - formIDs';
    private static final String URL=system.label.ARV_CL20_URL;
    private static final String COVERAGEPERIOD='Beginning on or after ';
    private static final String RIDERSTRING='MGAPN';
    private static final string SUCCESSCODE1='S0006';
    private static final String SUCCESSCODE=system.label.ARV_CL18_SuccssCode;
    private static final STRING TOLLFREE='1234567891';
    private static final STRING COMMAVAL=',';
    private static final String BLANKVAL='';
    private static final string FOLDERQUERY='SELECT Id, Name FROM Folder';
    private static final string FOLDERWHERE=' where Name=:paramName'; 
    private static final string ACCOUNTQUERY='select id,Name,Phone from Account';
    private static final string ACCOUNTWHERE=' where id=:paramId1'; 
    private static final string USERQUERY=system.label.ARV_CL27_USERQUERY;
    private static final string USERWHERE=' where Id =:paramId1';
    private static final string PRODUCTQUERY=system.label.ARV_CL24_ProductQuery;
    private static final string PRODUCTWHERE=' where id=:paramId1';
    private static final string PRODUCTWHERE1=' where Name like :paramName and vlocity_ins__Type__c =:paramName1';
    private static final String limitClause=' LIMIT 100';
    private static final String folderlimitClause=' LIMIT 1';
    private static string mycrop;
    Public  static string type='card';
    private static string MESSAGEIDBCN='SBCMGMTJSON1.0-56eee1d8-9d1e-494b-b7f7-74c548851fd3';
    private static string TESTVAR='var';
    private static string AGENT='Agent';
    Private static final string SMMARKER='℠'; 
    Private static final string SMMARKERVAL=system.label.ARV_CL33_SMMAKER;
    private static final string DATEFORMAT='yyyy-MM-dd';
    Private static final string DATEFORMAT1='MM/dd/yyyy';
    private static final string OPPORTUNITYQUERY=System.label.ARV_CL48_Opportunity_Query;
    private static final string OPPORTUNITYWHERE=' Where id =: paramId1';
    private static final string QUOTEQUERY=System.label.ARV_CL26_QUOTEQUERY;
    private static final string QUOTEQUERYWHERE=' where Id =:paramId1';
    private static final string PEDIATRIC='%Pediatric%';
    public static final string YES='Yes';
    public static final string NO='No';
    public static final string  OTHERSTRING='616G';
    private static final string QUOTELINEWHERE=' where QuoteId=:paramId1  and product2.vlocity_ins__Type__c=:paramName '+
               ' and (not Product2.Name like :paramName1)';
     private static final string PRODUCTWHERE2=' where vlocity_ins__Type__c =:paramName1 and Corporate_Form_String__c!=null '
        +'and (not Name like :paramName) ';   
    private static final string USERID=system.label.ARV_CL55_AgentCode;   
    private static final string MANAGINGAGENT='Managing Agent';
    private static final string BCBSMQUOTE='BcbsmQuote';
    private static final string MAPROFILE='Managing Agent Community User';
    private static final string  BCBSMPROFILE='BCBSM Agent';
    private static final string  BCBSMPROFILEBOTH='BCBSM Both';
    public static integer countAcc=0;
    /**************  
    Method name : getScucessCode
    Params     : JSON Parser 
    Return Type : String
    Description :This method is used to get success code for request we send to server.
    *************/ 
    public static string getScucessCode(JSONParser parser)
    {
        string code = null;
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() ==CODEVAL || parser.getText() ==ADDINFOVAL || parser.getText() ==DESCPVAL)) {
                if(parser.getText() ==CODEVAL) {
                    parser.nextToken();                       
                    if(code ==null){code=parser.getText();  }
                }
            }
        }
        return code;
    }
    
     /**************  
    Method name : getAttachmentRecord
    Params     : Response
    Return Type : Attachment
    Description :This method is used to create record.
    *************/ 
     Public static ContentDocumentLink fileCreation(HTTPResponse res,Id quoteId,string fileName ){
        Id profileId=[Select id,profileId from user where id=:UserInfo.getUserId()].profileId;
         string profileName=[select id,name from profile where id=:profileId].Name;
         List<Network>  netList=[Select id,Name from  Network];
         Id mangingAgentId=Null; Id bcbsmQuoteId=NUll;
         for(Network nts:netList){
             if(nts.Name==MANAGINGAGENT){ mangingAgentId=nts.Id; }
             if(nts.Name==BCBSMQUOTE){bcbsmQuoteId=nts.Id; }
         }
        contentversion conVrsn=new contentversion();
        conVrsn.Title =fileName; conVrsn.PathOnClient =fileName+ARV_AP24_StaticUtil.ISPDF;
        conVrsn.VersionData = EncodingUtil.convertFromHex(fetchBinaryData(EncodingUtil.convertToHex(res.getBodyasBlob())));
        conVrsn.IsMajorVersion = true;
         if(MAPROFILE==profileName){ conVrsn.NetworkId =mangingAgentId; }
         if(BCBSMPROFILE==profileName || BCBSMPROFILEBOTH == profileName){ conVrsn.NetworkId=bcbsmQuoteId; }
        insert conVrsn;
        List<ContentVersion> cvrsn = [SELECT ContentDocumentId  FROM ContentVersion WHERE Id=:conVrsn.id limit 1];
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = quoteId;cdl.ContentDocumentId = cvrsn[0].ContentDocumentId;
        cdl.shareType = ARV_AP24_StaticUtil.ISV;cdl.Visibility=ARV_AP24_StaticUtil.ALLUSERS;
       return cdl;
    }
    /**************  
    Method name : fetchBinaryData
    Params      : Resp
    Return Type : String
    Description : fetchBinaryData() Method
    *************/
    private static String fetchBinaryData(String resp){
        String binaryData ;
        integer strtBinData = resp.indexOf(BLOBRESPFRMT1,resp.indexOf(BLOBRESPFRMT1) + 1)+10;
        integer endBinData = resp.lastindexOf(BLOBRESPFRMT2,resp.lastindexOf(BLOBRESPFRMT2) - 1)-4;
        binaryData = resp.substring(strtBinData, endBinData);
        return binaryData; 
    }
     
    /**************  
    Method name : makeHTTPCallOut
    Params      : endPnt,ReqBody
    Return Type : HTTPResponse
    Description : This method is used to send request to https callout and get response.
    *************/ 
    public static HTTPResponse makeHTTPCallOut(string endPnt,string ReqBody)
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPnt);
        req.setMethod(REQTYP);
        req.setTimeout(120000);
        req.setbody(ReqBody);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }
     /**************  
    Method name : fetchCorporateFormStrng
    Params      : null
    Return Type : Map
    Description : fetchCorporateFormStrng() Method added for 2689
    *************/
    Public static string fetchCorporateFormStrng(){
         ARV_AP07_QueryDataHelper.paramName = PEDIATRIC;
        ARV_AP07_QueryDataHelper.paramName1 = ARV_AP41_StringLiteralUtils.DENTALTYPE;
        list<product2> productlist= ARV_AP07_QueryDataHelper.getsObjects(PRODUCTQUERY,productwhere1,NULL,folderlimitClause);
        return productlist[0].Corporate_Form_String__c;
    }
     /**************  
    Method name : anyDentalCorporateFormStrng
    Params      : null
    Return Type : Map
    Description : fetchCorporateFormStrng() Method added for 2689 for compare modal
    *************/
    Public static string anyDentalCorporateFormStrng(){
         ARV_AP07_QueryDataHelper.paramName = PEDIATRIC;
        ARV_AP07_QueryDataHelper.paramName1 = ARV_AP41_StringLiteralUtils.DENTALTYPE;
        list<product2> productlist= ARV_AP07_QueryDataHelper.getsObjects(PRODUCTQUERY,PRODUCTWHERE2,NULL,folderlimitClause);
        return productlist[0].Corporate_Form_String__c;
    }
      
    /**************  
    Method name : fetchDentalCorporate
    Params      : Id
    Return Type : String
    Description : fetchDentalCorporate() Method
    *************/
    public static string fetchDentalCorporate(Id quoteId){
        string  myDentalCorporateStr;
            ARV_AP07_QueryDataHelper.paramName=ARV_AP41_StringLiteralUtils.DENTALTYPE;
            ARV_AP07_QueryDataHelper.paramId1 =quoteId ;
            ARV_AP07_QueryDataHelper.paramName1=PEDIATRIC;
            list<QuoteLineItem> qliList2= ARV_AP07_QueryDataHelper.getsObjects(ARV_AP24_StaticUtil.QUOTELINEITEMQUERY,
                                                                              QUOTELINEWHERE,null,folderlimitClause);
            for(QuoteLineItem qlist:qliList2){
                if(qlist.product2.Corporate_Form_String__c!=null){ myDentalCorporateStr=qlist.product2.Corporate_Form_String__c;  }
            }
        return myDentalCorporateStr;
    }
    
     /**************  
    Method name : fetchVisionCorporate
    Params      : Id
    Return Type : String
    Description : fetchVisionCorporate() Method
    *************/
    public static string fetchVisionCorporate(Id quoteId){
        string  myVisionCorporateStr;
            ARV_AP07_QueryDataHelper.paramName=ARV_AP41_StringLiteralUtils.VISIONTYPE;
            ARV_AP07_QueryDataHelper.paramId1 =quoteId ;
            ARV_AP07_QueryDataHelper.paramName1=PEDIATRIC;
            list<QuoteLineItem> qliList2= ARV_AP07_QueryDataHelper.getsObjects(ARV_AP24_StaticUtil.QUOTELINEITEMQUERY,
                                                                              QUOTELINEWHERE,null,folderlimitClause);
            for(QuoteLineItem qlist:qliList2){
                if(qlist.product2.Corporate_Form_String__c!=null){  myVisionCorporateStr=qlist.product2.Corporate_Form_String__c;}
            }
        return myVisionCorporateStr;
    }
    /**************  
    Method name : fetchJSONData
    Params      : Resp
    Return Type : String
    Description : fetchJSONData() Method
    *************/
    public static string fetchJSONData(String resp){
        
        if(resp.indexOf(JSONRESPFRMT1)!=-1)
        {
            String JSONData ;     
            integer strtBinData = resp.indexOf(JSONRESPFRMT2)+1;
            integer endBinData = resp.indexOf(JSONRESPFRMT1,resp.indexOf(JSONRESPFRMT1) + 1)-1;
            JSONData = resp.substring(strtBinData, endBinData);
            return JSONData;  
        }
        else { return resp;   }
        
    }
    
    /**************  
    Method name : serializeReq
    Params      : Product,Account,user
    Return Type : String
    Description : This serializeReq() method  is Used to serilise data to send request.
    *************/
    public static string serializeReq( List<Product2> productlist,List<Account> accList, list<user> usr,Id oppId,list<quote> quoteList,datetime effDate,string pediatricVal,Id quoteId)
    { 
        ARV_AP04_SBCParserJSON.Cls_CoverageInfo cvrgInfo1 = getCvrgInfo(productlist,accList,quoteList,effDate,pediatricVal,quoteId);
        ARV_AP04_SBCParserJSON.Cls_TemplateInfo tmpltInfo=new  ARV_AP04_SBCParserJSON.Cls_TemplateInfo();
        tmpltInfo.DocType=DOCTYP;        
        ARV_AP04_SBCParserJSON.Cls_PayloadArea payloadarea=new ARV_AP04_SBCParserJSON.Cls_PayloadArea();
        DateTime effectiveDate=system.today();
        if(!quoteList.isEmpty()){  effectiveDate =quoteList[0].Requested_Effective_Date__c;
        }else{
            effectiveDate= effDate;
        }
        string dateOutput = effectiveDate.formatGMT(DATEFORMAT);
        payloadarea.EffectiveDate=dateOutput;
        Payloadarea.CorporateForm=getCorpList();
        payloadarea.BusinessChannel=BUSINSCHANL;
        payloadarea.IncludeAttachmentInd=INCLUDEATTCHHMENTIND;
        payloadarea.TrackingInfo = getTrackingInfo(usr,oppId);
        payloadarea.CoverageInfo=cvrgInfo1;
        Payloadarea.TemplateInfo=tmpltInfo;        
        ARV_AP04_SBCParserJSON.Cls_CreateDocRequest crtDoc = New ARV_AP04_SBCParserJSON.Cls_CreateDocRequest();
        crtDoc.ReqHeaderArea=getReqhdrarea();
        crtDoc.PayloadArea=payloadarea;   
        ARV_AP04_SBCParserJSON jsonReq=new ARV_AP04_SBCParserJSON(crtDoc);
        string SBCJsonReq=JSON.serialize(jsonReq);  
        SBCJsonReq=SBCJsonReq.replace(GRPNOKEY, GRPNOVAL);
        return SBCJsonReq;
    }
    
    /**************  
    Method name : getCvrgInfo
    Params      : Product,Account
    Return Type : Cls_CoverageInfo
    Description : This getCvrgInfo method is called from serializeReq method.
    *************/
    private static ARV_AP04_SBCParserJSON.Cls_CoverageInfo getCvrgInfo(List<Product2> prdList,List<Account> acList,list<quote> quoteList,datetime effDate,string pediatricVal,Id quoteId)
    {
        ARV_AP04_SBCParserJSON.Cls_CoverageInfo cvrgInfo=new  ARV_AP04_SBCParserJSON.Cls_CoverageInfo();
        cvrgInfo.URL=URL;
        cvrgInfo.TollFreeNumber=TOLLFREE;
        for(Account acc:acList){
            cvrgInfo.GroupName=acc.Name;
        }
        Datetime effectiveDate=system.today();
        mycrop=BLANKVAL;
        cvrgInfo.CoverageFor=COVERAGEFOR;
        for(Product2 prd:prdList){
            cvrgInfo.PlanType=prd.vlocity_ins__Type__c;
            if(prd.Name.contains(SMMARKER)){
                string finalName=prd.Name.replace(SMMARKER,SMMARKERVAL);   cvrgInfo.PlanName =finalName;            
            }
            else{
                cvrgInfo.PlanName=prd.Name;
             }
            if(prd.vlocity_ins__Type__c==ARV_AP41_StringLiteralUtils.DENTALTYPE || prd.vlocity_ins__Type__c==ARV_AP41_StringLiteralUtils.VISIONTYPE)
            {
                mycrop=prd.Corporate_Form_String__c;
            }
            else if(prd.vlocity_ins__Type__c==ARV_AP41_StringLiteralUtils.MEDICALTYPE){
                 //added for us2689
                if(quoteList.isEmpty()){
                    if(pediatricVal==BLANKVAL){
                       string anyDental= anyDentalCorporateFormStrng(); mycrop=prd.Corporate_Form_String__c+COMMAVAL+anyDental;
                    }else if(pediatricVal==YES){
                        mycrop=prd.Corporate_Form_String__c+COMMAVAL+OTHERSTRING;
                    }else if( pediatricVal==NO){
                        string finalVal=fetchCorporateFormStrng(); mycrop=prd.Corporate_Form_String__c+COMMAVAL+finalVal;
                    }
                   
                }
                if(!quoteList.isEmpty()){
                    if(quoteList[0].ARV_Tech_Is_Pediatric__c==null){
                        string finalDental=fetchDentalCorporate(quoteId);  mycrop=prd.Corporate_Form_String__c+COMMAVAL+finalDental;
                    }else if(quoteList[0].ARV_Tech_Is_Pediatric__c==YES ){
                        mycrop=prd.Corporate_Form_String__c+COMMAVAL+OTHERSTRING;
                    } else if(quoteList[0].ARV_Tech_Is_Pediatric__c==NO ){
                        string finalVal=fetchCorporateFormStrng(); mycrop=prd.Corporate_Form_String__c+COMMAVAL+finalVal;
                    }
                    string myVisionComp=fetchVisionCorporate(quoteId);
                    if(myVisionComp!=null){  mycrop=mycrop+COMMAVAL+myVisionComp;  }
                }
            }
        } 
        if(!quoteList.isEmpty()){ effectiveDate =quoteList[0].Requested_Effective_Date__c;
        }else{
            effectiveDate= effDate;
        }
        String dateOutput = effectiveDate.formatGMT(DATEFORMAT1);
        cvrgInfo.CoveragePeriod=COVERAGEPERIOD+dateOutput;
        return cvrgInfo;
    }
    
    /**************  
    Method name : getTrackingInfo
    Params      : user
    Return Type : Cls_TrackingInfo
    Description : This getTrackingInfo method is callsed from serializeReq method.
    *************/
    private static ARV_AP04_SBCParserJSON.Cls_TrackingInfo getTrackingInfo(list<user> userList,Id oppId){
        ARV_AP04_SBCParserJSON.Cls_Name qName = New ARV_AP04_SBCParserJSON.Cls_Name();
        qName.First =  userinfo.getFirstName();
        qName.Last=  userinfo.getLastName();
        ARV_AP04_SBCParserJSON.Cls_RequestorInfo reqinfo = New ARV_AP04_SBCParserJSON.Cls_RequestorInfo();
        for(user usr:userList){
            reqinfo.Email = usr.email;
        }
        reqinfo.Name = qName;
        ARV_AP04_SBCParserJSON.Cls_TrackingInfo trackingInfo = New ARV_AP04_SBCParserJSON.cls_TrackingInfo();
       // trackingInfo.ID=USERID;
        for(user usr:userList){
            trackingInfo.UserID=usr.EmployeeNumber;
             trackingInfo.ID=usr.FederationIdentifier;
        }
        ARV_AP07_QueryDataHelper.paramId1 = oppId;
        list<opportunity> oppList= ARV_AP07_QueryDataHelper.getsObjects(OPPORTUNITYQUERY,OPPORTUNITYWHERE,NULL,null);
        trackingInfo.BusinessArea=BUSINESSAREA;
        trackingInfo.AppTriggerEvent=APPTRIGGEREVENT;
        trackingInfo.RequestorInfo = reqinfo; 
        trackingInfo.QuoteID=oppList[0].ARV_Tech_QuoteID__c;
        trackingInfo.Contract=null;
        trackingInfo.UserType=AGENT;
        return trackingInfo;
    }
    
    /**************  
    Method name : getCorpList
    Params      : null
    Return Type : Cls_corporatestring
    Description : This getCorpList method is callsed from serializeReq method.
    *************/
    private static List<ARV_AP04_SBCParserJSON.Cls_corporatestring> getCorpList()
    {
        ARV_AP04_SBCParserJSON.Cls_corporatestring cropin=new ARV_AP04_SBCParserJSON.Cls_corporatestring();
        List<ARV_AP04_SBCParserJSON.Cls_corporatestring> corpList = new list<ARV_AP04_SBCParserJSON.Cls_corporatestring>();
        String[] arrTest = mycrop!=null?mycrop.split(COMMAVAL):new List<string>();
        string mycon=BLANKVAL;
        for(string str:arrTest) {
            cropin=new ARV_AP04_SBCParserJSON.Cls_corporatestring();
            cropin.Code = str;
            corpList.add(cropin);       
        }
        return corpList;        
    }
    
    
    /**************  
    Method name : getReqhdrarea
    Params      : null
    Return Type : Cls_ReqHeaderArea
    Description : This getReqhdrarea method is called from serializeReq method.
    *************/
    private static ARV_AP04_SBCParserJSON.Cls_ReqHeaderArea getReqhdrarea()
    {
        ARV_AP04_SBCParserJSON.Cls_VersionInfo vrsnInfo = new ARV_AP04_SBCParserJSON.Cls_VersionInfo();
        vrsnInfo.ServiceVersion=SRVCVERSN;
        vrsnInfo.SchemaVersion=SCHMVERSN;
        ARV_AP04_SBCParserJSON.Cls_Consumer consumr=new ARV_AP04_SBCParserJSON.Cls_Consumer();
        consumr.ID=SFGRPCRM;
        consumr.Name=SFGRPCRMNM;
        ARV_AP04_SBCParserJSON.Cls_ReqHeaderArea reqHdrarea=new ARV_AP04_SBCParserJSON.Cls_ReqHeaderArea();
        reqHdrarea.VersionInfo=vrsnInfo;
        reqHdrarea.CreationDateTime=string.valueof(system.now());
        reqHdrarea.MessageID=MESSGID;
        reqHdrarea.Consumer=consumr;    
        return reqHdrarea;
    }
    
    /**************  
    Method name : callSBCService
    Params      : AccountId,ProductId,InvokeType
    Return Type : ResponseWrapper
    Description : callSBCService()  method is used to invoke in product card layout and from queable.
    *************/
    public static ResponseWrapper callSBCService(Id accId,Id prdId, string invokeType,string quoteId,Id oppId,string carrierType,Datetime effectiveDate,string pediatricVal){
        ARV_AP07_QueryDataHelper.paramId1 = userinfo.getUserId();
        List<user> usr= ARV_AP07_QueryDataHelper.getsObjects(userQuery,userWhere,NULL,limitClause);  
        ARV_AP07_QueryDataHelper.paramId1 = prdId;
        list<product2> productlist= ARV_AP07_QueryDataHelper.getsObjects(PRODUCTQUERY,productwhere,NULL,limitClause);
        ARV_AP07_QueryDataHelper.paramId1 =accId;
        list<Account> acclist= ARV_AP07_QueryDataHelper.getsObjects(accountQuery,accountwhere,NULL,limitClause);
        List<Quote> quoteList=new list<quote>();
        if(quoteId!=ARV_AP41_StringLiteralUtils.MYBLANKVAL){
            ARV_AP07_QueryDataHelper.paramId1 = quoteId;
            quoteList=ARV_AP07_QueryDataHelper.getsObjects(QUOTEQUERY,QUOTEQUERYWHERE,null,null);  
        }
        else{
            quoteId=null;
        }
        if(oppId==null){ oppId=quoteList[0].OpportunityId; }
        string ReqBody;
        if(carrierType!=BUSINSCHANLBCN){
           ReqBody=ARV_AP15_CallOutUtils.serializeReq(productlist,acclist,usr,oppId,quoteList,effectiveDate,pediatricVal,quoteId);
        }
        else{
         ReqBody=ARV_AP15_CallOutUtils.serializeReq_BCN(productlist,acclist,usr,oppId,quoteList,effectiveDate);
        }
        System.debug('ReqBody12'+ReqBody);
        HTTPResponse res = ARV_AP15_CallOutUtils.makeHTTPCallOut(ENDPOINT,ReqBody); 
        string code = ARV_AP15_CallOutUtils.getScucessCode(JSON.createParser(ARV_AP15_CallOutUtils.fetchJSONData(res.getBody())));
        System.debug('resposne'+res.getBody());
        ResponseWrapper rwp = new ResponseWrapper();
        if(code ==SUCCESSCODE || code==SUCCESSCODE1){
            if(invokeType == type){  
                rwp.fileName = productlist[0].Name;
                rwp.base64val = EncodingUtil.base64Encode(res.getBodyasBlob());
            }
            else{
                ContentDocumentLink attach=ARV_AP15_CallOutUtils.fileCreation(res,quoteId,DOCNAME);
                database.insert(attach,true);
                rwp.attachRecord = attach;rwp.fileName = productlist[0].Name;
            }
        }
        return rwp;
    }
    
    /**************  
    Method name : serializeReq
    Params      : Product,Account,user
    Return Type : String
    Description : This serializeReq_BCN() method  is Used to serilise data to send request.
    *************/
    public static string serializeReq_BCN( List<Product2> productlist,List<Account> accList, list<user> usr,Id oppId,list<quote> quoteList,datetime effDate)
    { 
                
        ARV_AP40_SBCParserJSON_BCN.Cls_PayloadArea_BCN payloadarea=new ARV_AP40_SBCParserJSON_BCN.Cls_PayloadArea_BCN();
        payloadarea.BusinessChannel=BUSINSCHANLBCN;
        DateTime effectiveDate=system.today();
        for(product2 prd:productlist){
           payloadarea.RiderString=prd.Certificate_Rider_Unique_String__c;
        }
        if(!quoteList.isEmpty()){ effectiveDate =quoteList[0].Requested_Effective_Date__c; }
        else{
            effectiveDate=effDate;
        }
        string dateOutput=effectiveDate.formatGMT(DATEFORMAT);
        payloadarea.EffectiveDate=dateOutput;
        payloadarea.IncludeAttachmentInd=INCLUDEATTCHHMENTIND;
        ARV_AP40_SBCParserJSON_BCN.Cls_CoverageInfo_BCN cvrgInfo1 = getCvrgInfo_BCN(productlist,accList,quoteList,effDate);
        payloadarea.CoverageInfo=cvrgInfo1;
        ARV_AP40_SBCParserJSON_BCN.Cls_TemplateInfo_BCN tmpltInfo=new  ARV_AP40_SBCParserJSON_BCN.Cls_TemplateInfo_BCN();
        tmpltInfo.DocType=DOCTYP;
        Payloadarea.TemplateInfo=tmpltInfo;        
        payloadarea.TrackingInfo = getTrackingInfo_BCN(usr,oppId);
        ARV_AP40_SBCParserJSON_BCN.Cls_CreateDocRequest_BCN crtDoc = New ARV_AP40_SBCParserJSON_BCN.Cls_CreateDocRequest_BCN();
        crtDoc.ReqHeaderArea=getReqhdrarea_BCN();
        crtDoc.PayloadArea=payloadarea;   
        ARV_AP40_SBCParserJSON_BCN jsonReq=new ARV_AP40_SBCParserJSON_BCN(crtDoc);
        string SBCJsonReq=JSON.serialize(jsonReq);  
        SBCJsonReq=SBCJsonReq.replace(GRPNOKEY, GRPNOVAL);
        return SBCJsonReq;
    }
    /**************  
    Method name : getReqhdrarea
    Params      : null
    Return Type : Cls_ReqHeaderArea
    Description : This getReqhdrarea_BCN method is callsed from serializeReq_BCN() method.
    *************/
    private static ARV_AP40_SBCParserJSON_BCN.Cls_ReqHeaderArea_BCN getReqhdrarea_BCN()
    {
        ARV_AP40_SBCParserJSON_BCN.Cls_VersionInfo_BCN vrsnInfo = new ARV_AP40_SBCParserJSON_BCN.Cls_VersionInfo_BCN();
        vrsnInfo.ServiceVersion=SRVCVERSN;
        vrsnInfo.SchemaVersion=SCHMVERSN;
        ARV_AP40_SBCParserJSON_BCN.Cls_Consumer_BCN consumr=new ARV_AP40_SBCParserJSON_BCN.Cls_Consumer_BCN();
        consumr.ID=SFGRPCRM;
        consumr.Name=SFGRPCRMNM;
        ARV_AP40_SBCParserJSON_BCN.Cls_ReqHeaderArea_BCN reqHdrarea=new ARV_AP40_SBCParserJSON_BCN.Cls_ReqHeaderArea_BCN();
        reqHdrarea.VersionInfo=vrsnInfo;
        reqHdrarea.CreationDateTime=string.valueof(system.now());
        reqHdrarea.MessageID=MESSAGEIDBCN;
        reqHdrarea.Consumer=consumr;    
        return reqHdrarea;
    }
    /**************  
    Method name : getCvrgInfo_BCN
    Params      : Product,Account
    Return Type : Cls_CoverageInfo_BCN
    Description : This getCvrgInfo_BCN method is callsed from serializeReq_BCN() method.
    *************/
    private static ARV_AP40_SBCParserJSON_BCN.Cls_CoverageInfo_BCN getCvrgInfo_BCN(List<Product2> prdList,List<Account> acList,list<quote> quoteList,Datetime effDate)
    {
        ARV_AP40_SBCParserJSON_BCN.Cls_CoverageInfo_BCN cvrgInfo=new  ARV_AP40_SBCParserJSON_BCN.Cls_CoverageInfo_BCN();
        cvrgInfo.URL=URL;
        cvrgInfo.TollFreeNumber=TOLLFREE;
        for(Account acc:acList){
            cvrgInfo.GroupName=acc.Name;
        }
        DateTime effectiveDate=system.today();
        cvrgInfo.CoverageFor=COVERAGEFOR;
        for(Product2 prd:prdList){
            cvrgInfo.PlanType=prd.vlocity_ins__Type__c;
            cvrgInfo.PlanName=prd.Name;
        }      
        if(!quoteList.isEmpty()){ effectiveDate =quoteList[0].Requested_Effective_Date__c; }
        else{
           effectiveDate= effDate;
        }
        String dateOutput = effectiveDate.formatGMT(DATEFORMAT1);
        cvrgInfo.CoveragePeriod=COVERAGEPERIOD+dateOutput;
        return cvrgInfo;
    }
    
    
    /**************  
    Method name : getTrackingInfo_BCN
    Params      : user
    Return Type : Cls_TrackingInfo
    Description : This getTrackingInfo_BCN method is callsed from serializeReq_BCN() method.
    *************/
    private static ARV_AP40_SBCParserJSON_BCN.Cls_TrackingInfo_BCN getTrackingInfo_BCN(list<user> userList,Id oppId){
        ARV_AP40_SBCParserJSON_BCN.Cls_Name_BCN qName = New ARV_AP40_SBCParserJSON_BCN.Cls_Name_BCN();
        qName.First =  userinfo.getFirstName();
        qName.Last=  userinfo.getLastName();
        ARV_AP40_SBCParserJSON_BCN.Cls_RequestorInfo_BCN reqinfo = New ARV_AP40_SBCParserJSON_BCN.Cls_RequestorInfo_BCN();
        for(user usr:userList){
            reqinfo.Email = usr.email;
        }
        reqinfo.Name = qName;
        ARV_AP40_SBCParserJSON_BCN.Cls_TrackingInfo_BCN trackingInfo = New ARV_AP40_SBCParserJSON_BCN.Cls_TrackingInfo_BCN();
        trackingInfo.BusinessArea=BUSINESSAREA;
        trackingInfo.AppTriggerEvent=APPTRIGGEREVENT;
        trackingInfo.RequestorInfo=reqinfo;
        trackingInfo.UserType=AGENT;
        return trackingInfo;
    }
    /**************  
    Class  name : ResponseWrapper
    Description : This calss is used for wrapper list variables.
    *************/ 
    public class ResponseWrapper{
        @AuraEnabled
        public document docRecord;
        @Auraenabled
        public ContentDocumentLink attachRecord;
         @Auraenabled
        public string base64val;
         @Auraenabled
        public string fileName;
    }
}