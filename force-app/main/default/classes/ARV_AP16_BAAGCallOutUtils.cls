/*****************************************************************************************
Class Name   : ARV_AP16_BAAGCallOutUtils 
Date Created : 21-MAY-2019
Created By   : IDC Offshore
Description  : This  class is called from ARV_AP09_BAAGServiceDocGen to call BAAG services.
******************************************************************************************/
public without sharing class ARV_AP16_BAAGCallOutUtils {
    private static final String GRPNOKEY='GrpNumber';
    private static final String GRPNOVAL='Number';
    private static final String JSONRESPFRMT1='--';
    private static final String JSONRESPFRMT2='>';
    private static final String CODEVAL=system.label.ARV_CL03_CodeVal;
    private static final String ADDINFOVAL=system.label.ARV_CL01_AdditionalInfo;
    private static final String DESCPVAL=system.label.ARV_CL08_Description;
    private static final String SUCCESSCODE=system.label.ARV_CL18_SuccssCode;
    private static final String FOLDRNAME=system.label.ARV_CL02_BCBSM_FldrNme;
    private static  String DOCCNTTYPE=system.label.ARV_CL09_DocCntType;
    private static  String DOCEXT=system.label.ARV_CL10_DocExt;
    private static final String BLOBRESPFRMT1='3e';
    private static final String BLOBRESPFRMT2='2d2d';
    private static final string REQRDDATE = 'yyyy-MM-dd';
    private static final String INCLUDEATTCHHMENTIND='Y';
    private static final String MOSIND='Y';
    private static final string OVRLAYIND='Y';
    private static final String RETRIEVEBENEFITIND='Y';
    private static final String REQTYP=system.label.ARV_CL15_Method_ReqType;
    private static final String BAAGENDPOINT=system.label.ARV_CL13_End_point_BAAG;
    private static final String SRVCVERSN=system.label.ARV_CL17_Service_Version;
    private static final String SCHMVERSN=system.label.ARV_CL16_Schema_Version;
    private static final String CONSUMERID=system.label.ARV_CL04_ConsumerId;
    private static final String CONSUMERNAME=system.label.ARV_CL05_ConsumerName;
    private static final String MESSGID=system.label.ARV_CL14_MessgID;
    private static final String APPTRIGGEREVENT='Quoting';
    private static final String BUSINESSAREA=system.label.ARV_CL54_BusinessArea;
    private static final String USRTYPE='Agent';
    private static final String REQUESTTYPE ='BAAG';
    private static final string QUOTEDATE = 'MMddyyHHMMss';
    private static final string BAAGNAME ='BAAG - formIDs';
    private static final string DOCNAME ='BAAG Doc';
    private static final string COMMAVAL =',';
    private static final string QUOTESTRING ='QUO';
    public boolean disblBtn {get;set;}
    public transient String fileName {get; set;}
    public transient String base64Value { get; set; }
    private static final string USERQUERY=system.label.ARV_CL27_USERQUERY;
    private static final string USERWHERE=' where Id =:paramId1';
    private static final string PRODUCTQUERY=system.label.ARV_CL24_ProductQuery;
    private static final string PRODUCTWHERE=' where id=:paramId1';
    private static final String BLANKVAL='';
    private static final string ClsName  ='ARV_AP09_BAAGServicecls';
    private static final string methodNmeSBCDoc  ='getBAAGDoc';
    private static final String EXCEPSEPRATR=': ';
    private static final String ERRORMSG='Unable to retrieve SBC Document';
    private static final string MYPRODUCTID='pId';
    private static final string BAAGTYPE='_BAAG.pdf';
    public Id productId;
    private static string mycrop;
    private static final String limitClause=' LIMIT 100'; 
    Public  static string type='card';
    private static final  string FINALVAL1='D1';
    private static final string FINALVAL2='D2';
    private static final  string FINALVAL3='D3';
    private static final string QUOTEQUERY=SYSTEM.LABEL.ARV_CL26_QUOTEQUERY;
    private static final string QUOTEQUERYWHERE=' where Id =:paramId1';
        private static final string USERID=system.label.ARV_CL55_AgentCode;   

        /**************  
    Method name : serializeReq
    Params     : Product,Account,user
    Return Type : String
    Description :This serializeReq() method  is Used to serilise data to send request.
    *************/
    public static string serializeReq( List<Product2> productlist, list<user> usr,List<Quote> quoteList,boolean checkBCBS,string quoteId)
    { 
        string benefitJsonReq;
        try{
            ARV_AP10_BAAGParserJSON.Cls_BenefitInfo Benefit1 =new  ARV_AP10_BAAGParserJSON.Cls_BenefitInfo();
            ARV_AP10_BAAGParserJSON.Cls_PayloadArea payloadarea=new ARV_AP10_BAAGParserJSON.Cls_PayloadArea();
            Payloadarea.CorporateForm=getCorpList(productlist,checkBCBS,quoteList,quoteId);
            for(quote quo:quoteList){
                payloadarea.EffectiveDate =quo.Requested_Effective_Date__c;
                Benefit1.GroupName=quo.Account.Name;
            }
            payloadarea.BenefitInfo=Benefit1;
            payloadarea.IncludeAttachmentInd =INCLUDEATTCHHMENTIND;
            payloadarea.MOSInd = MOSIND ;
            payloadarea.OverlayInd=OVRLAYIND;
            payloadarea.RequestType =REQUESTTYPE;
            payloadarea.RetrieveBenefitInd =RETRIEVEBENEFITIND;
            payloadarea.TrackingInfo =getTrackingInfo(usr,quoteList);
            ARV_AP10_BAAGParserJSON.Cls_CreateBenefitDocRequest crtDoc = New ARV_AP10_BAAGParserJSON.Cls_CreateBenefitDocRequest();
            crtDoc.ReqHeaderArea=getReqhdrarea();
            crtDoc.PayloadArea=payloadarea;   
            ARV_AP10_BAAGParserJSON jsonReq=new ARV_AP10_BAAGParserJSON(crtDoc);
            benefitJsonReq=JSON.serialize(jsonReq);  
            benefitJsonReq=benefitJsonReq.replace(GRPNOKEY, GRPNOVAL);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, methodNmeSBCDoc);
            throw new AuraHandledException(e.getMessage()); 
        }
        return benefitJsonReq;
    }

        /**************  
    Method name : getCorpList
    Params     : ProductList,checkBCBS flag
    Return Type : ARV_AP10_BAAGParserJSON.Cls_corporatestring
    Description :This getCorpList method is callsed from serializeReq method.
    *************/
    private static List<ARV_AP10_BAAGParserJSON.Cls_corporatestring> getCorpList(List<Product2> prdList,boolean checkBCBS,List<Quote> quoteList,string quoteId)
    {
        List<ARV_AP10_BAAGParserJSON.Cls_corporatestring> corpList = new list<ARV_AP10_BAAGParserJSON.Cls_corporatestring>();
        try{
            ARV_AP10_BAAGParserJSON.Cls_corporatestring cropin=new ARV_AP10_BAAGParserJSON.Cls_corporatestring();
            for(Product2 prd:prdList){
                if(prd.vlocity_ins__Type__c==ARV_AP41_StringLiteralUtils.DENTALTYPE || prd.vlocity_ins__Type__c==ARV_AP41_StringLiteralUtils.VISIONTYPE)
                {
                    if(checkBCBS==false){
                        mycrop=prd.Corporate_Form_String__c;
                    }else{
                        mycrop=prd.ARV_CF_Tech_CompCoporateString__c;
                    }
                    
                } else if(prd.vlocity_ins__Type__c==ARV_AP41_StringLiteralUtils.MEDICALTYPE){
                    if(checkBCBS==false){
                        if(!quoteList.isEmpty()){
                            if(quoteList[0].ARV_Tech_Is_Pediatric__c==null){
                                string finalDental=ARV_AP15_CallOutUtils.fetchDentalCorporate(quoteId);
                                mycrop=prd.Corporate_Form_String__c+COMMAVAL+finalDental;
                            }else if(quoteList[0].ARV_Tech_Is_Pediatric__c==ARV_AP15_CallOutUtils.YES ){
                                mycrop=prd.Corporate_Form_String__c+COMMAVAL+ARV_AP15_CallOutUtils.OTHERSTRING;
                            } else if(quoteList[0].ARV_Tech_Is_Pediatric__c==ARV_AP15_CallOutUtils.NO ){
                                string finalVal=ARV_AP15_CallOutUtils.fetchCorporateFormStrng();
                                mycrop=prd.Corporate_Form_String__c+COMMAVAL+finalVal;
                            }
                            string myVisionComp=ARV_AP15_CallOutUtils.fetchVisionCorporate(quoteId);
                            if(myVisionComp!=null){
                                mycrop=mycrop+COMMAVAL+myVisionComp;
                            }
                        }
                    }
                    else{
                        mycrop=prd.ARV_CF_Tech_CompCoporateString__c;
                    }
                }else{}
            }
            String[] arrTest = mycrop!=null?mycrop.split(COMMAVAL):new List<string>();
            for(string str:arrTest)
            {
                cropin=new ARV_AP10_BAAGParserJSON.Cls_corporatestring();
                cropin.Name = str;
                corpList.add(cropin);       
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, methodNmeSBCDoc);
            throw new AuraHandledException(e.getMessage()); 
        }
        return corpList;        
    }
        /**************  
    Method name : getReqhdrarea
    Params     : null
    Return Type : ARV_AP10_BAAGParserJSON.Cls_ReqHeaderArea
    Description :This getReqhdrarea method is callsed from serializeReq method.
    *************/
    private static ARV_AP10_BAAGParserJSON.Cls_ReqHeaderArea getReqhdrarea()
    {
        ARV_AP10_BAAGParserJSON.Cls_ReqHeaderArea Reqhdrarea=new ARV_AP10_BAAGParserJSON.Cls_ReqHeaderArea();
        try{
            ARV_AP10_BAAGParserJSON.Cls_VersionInfo vrsnInfo=new ARV_AP10_BAAGParserJSON.Cls_VersionInfo();
            vrsnInfo.ServiceVersion=SRVCVERSN;
            vrsnInfo.SchemaVersion=SCHMVERSN;
            ARV_AP10_BAAGParserJSON.Cls_Consumer consumr=new ARV_AP10_BAAGParserJSON.Cls_Consumer();
            consumr.ID=CONSUMERID;
            consumr.Name=CONSUMERNAME;
            Reqhdrarea.VersionInfo=vrsnInfo;
            Reqhdrarea.CreationDateTime=string.valueof(system.now());
            Reqhdrarea.MessageID=MESSGID;
            Reqhdrarea.Consumer=consumr;
            Reqhdrarea.systemEnvironmentCode=system.label.ARV_CL19_systemEnvironmentCode;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, methodNmeSBCDoc);
            throw new AuraHandledException(e.getMessage()); 
         }
        return Reqhdrarea;
    }
    
        /**************  
    Method name : getTrackingInfo
    Params     : user
    Return Type : Cls_TrackingInfo
    Description :This getTrackingInfo method is called from serializeReq method.
    *************/
    private static ARV_AP10_BAAGParserJSON.Cls_TrackingInfo getTrackingInfo(list<user> userList,List<Quote> quoteList){
        ARV_AP10_BAAGParserJSON.Cls_TrackingInfo trackingInfo = New ARV_AP10_BAAGParserJSON.Cls_TrackingInfo();
        try{
            ARV_AP10_BAAGParserJSON.cls_Name qName = New ARV_AP10_BAAGParserJSON.cls_Name();
            qName.First =  userinfo.getFirstName();
            qName.Last=  userinfo.getLastName();
            ARV_AP10_BAAGParserJSON.cls_RequestorInfo reqinfo = New ARV_AP10_BAAGParserJSON.cls_RequestorInfo();
            for(user usr:userList){
                reqinfo.Email = usr.email;
            }
            reqinfo.Name = qName;
            for(Quote quo:quoteList){
               trackingInfo.QuoteID = quo.opportunity.ARV_Tech_QuoteID__c ;
            }
            trackingInfo.AppTriggerEvent=APPTRIGGEREVENT;
            trackingInfo.BusinessArea=BUSINESSAREA;       
            //trackingInfo.ID=USERID;
            trackingInfo.RequiredDate=system.now().format(reqrdDate);
            for(user usr:userList){
                trackingInfo.ID=usr.FederationIdentifier;
                trackingInfo.UserID=usr.EmployeeNumber;
            }
            trackingInfo.UserType = USRTYPE;
            trackingInfo.RequestorInfo = reqinfo;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, methodNmeSBCDoc);
            throw new AuraHandledException(e.getMessage()); 
         }
        return trackingInfo;
    }
    
        /**************  
    Method name : callBAAGService
    Params     : AccountId,ProductId,InvokeType
    Return Type : ResponseWrapper
    Description :callBAAGService()  method is used to send request and get response from server.
    *************/
    public static ResponseWrapper callBAAGService(Id prdId, string invokeType,STRING quoteId,boolean checkBCBS){
        ResponseWrapper rwpList = new ResponseWrapper();
        try{
            ARV_AP07_QueryDataHelper.paramId1 = userinfo.getUserId();
            List<user> usr= ARV_AP07_QueryDataHelper.getsObjects(userQuery,userWhere,null,limitClause); 
            ARV_AP07_QueryDataHelper.paramId1 = quoteId;
            List<Quote> quoteList=ARV_AP07_QueryDataHelper.getsObjects(QUOTEQUERY,QUOTEQUERYWHERE,null,null);           
            ARV_AP07_QueryDataHelper.paramId1 = prdId;
            list<product2> productlist= ARV_AP07_QueryDataHelper.getsObjects(productQuery,productwhere,BLANKVAL,limitClause);
            string vlocityType=productlist[0].vlocity_ins__Type__c;
            string reqBody=ARV_AP16_BAAGCallOutUtils.serializeReq(productlist,usr,quoteList,checkBCBS,quoteId);
           system.debug('RequestBAAG'+reqBody);
            HTTPResponse res = ARV_AP15_CallOutUtils.makeHTTPCallOut(BAAGENDPOINT,reqBody);
            system.debug('response'+res.getBody());
           string code = ARV_AP15_CallOutUtils.getScucessCode(JSON.createParser(ARV_AP15_CallOutUtils.fetchJSONData(res.getBody())));
            if(code ==SUCCESSCODE ){ 
             if(invokeType == type){                                                                                                 
                rwpList.fileName = productlist[0].Name;
                rwpList.base64val = EncodingUtil.base64Encode(res.getBodyasBlob());
            }else{
               STRING finalVal=((vlocityType==ARV_AP41_StringLiteralUtils.MEDICALTYPE)?FINALVAL1:((vlocityType==ARV_AP41_StringLiteralUtils.DENTALTYPE)?FINALVAL2:((vlocityType==ARV_AP41_StringLiteralUtils.VISIONTYPE)?FINALVAL3:NULL)));
                string BaagName=finalVal+BAAGTYPE;
                ContentDocumentLink attach = ARV_AP15_CallOutUtils.fileCreation(res,quoteid,BaagName);
                database.insert(attach,true);
                rwpList.attachRecord=attach;
                rwpList.fileName = productlist[0].Name;
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, methodNmeSBCDoc);
            throw new AuraHandledException(e.getMessage()); 
        }
        return rwpList;
    }
    
        /**************  
    Class  name : ResponseWrapper
    Description :This calss is used for wrapper list variables.
    *************/ 
    public class ResponseWrapper{
        @AuraEnabled
        public document docRecord;
        @AuraEnabled
        public ContentDocumentLink attachRecord;
        @AuraEnabled
        public string base64val;
        @AuraEnabled
        public string fileName;
    }
    
}