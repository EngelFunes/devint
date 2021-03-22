/*****************************************************************************************
Class Name   : GA_AP_BAAGServiceCls
Date Created : 01/10/2017
Created By   : IDC Offshore
Description  : 1. This is the class for getting BAAG document from external system and show in Plan Package.
******************************************************************************************/
public with sharing class GA_AP_BAAGServiceCls {
    /**Class to throw exception*/
    public with sharing class ValidateException extends exception{}
    public static final map<string,string> respMap=new map<string,string>();
    public static final String CodeVal=system.label.GA_CodeVal_SBCBAAG;
    public static final String AddInfoKey=system.label.GA_AddInfoKey;
    public static final String DescpVal=system.label.GA_Description;
    public static final String AddInfoVal=system.label.GA_AdditionalInfo;
    public static final String SuccessCode=system.label.GA_SuccssCode;
    public static final String NoDataFoundCode=system.label.GA_NoDataFoundCode;
    public static final String ErrMsg=system.label.GA_BaagErrMsg;
    public static final String excepSepartr=': ';
    public static final String BaagEndpoint=system.label.GA_BaagEndpoint;
    public static final String ReqTyp=system.label.GA_Method_ReqType;
    public static final String DocId=system.label.GA_DocId;
    public static final String SrvcVersn=system.label.GA_Service_Version;
    public static final String SchmVersn=system.label.GA_Schema_Version;
    public static final String SFGrpCRM=system.label.GA_ConsumerId;
    public static final String SFGrpCRMNm=system.label.GA_ConsumerName; 
    public static final String MessgID=system.label.GA_MessgID;
    public static final String UsrType='Employee';
    public static String DocTyp=system.label.GA_DocTyp;
    public static final String IncludeAttchhmentInd='Y';
    public static final String MOSInd='Y';
    public static final String RequestType=system.label.GA_BAAGReqType;
    public static final String RetrieveBenefitInd='Y';
    public static final String GrpNoKey='groupNo';
    public static final String GrpNoVal='Number';
    public static final String blobRespFrmt1='3e';
    public static final String blobRespFrmt2='2d2d';
    public static final String NoDocRecdMsg=system.label.GA_NoDocRecdMsg;
    public static final String QuoteID='MMddyyyyHHmmss';
    public static final String QuoteIDPreFx='GA-';
    public static final String AppTriggerEvent='Upon Request';
    public static final String BusinessArea='Group-Sales CRM';
    public static final String HyphenVal=system.label.Hyphen;
    public static final String JsonRespFrmt1='--';
    public static final String JsonRespFrmt2='>';
    public static final String NoJsonRecvMsg=system.label.GA_NoJsonRecvMsg;
    public static String DocCntType=system.label.GA_DocCntType;
    public static String DocExt=system.label.GA_DocExt;
    public static final String foldrName=system.label.GA_BCBSM_FldrNme;
    public static final String BaagService='BAAG Service';
    public static final String BaagNotForBCN=system.label.GA_BaagNotSupported;
    public static final string updateKey='Update';
    public static final string updateValTrue='true';
    public static final string updateValfalse='false';
    public static final string reqfieldErr=system.label.GA_ReqfieldErr;
    public static final boolean BCNFunctionality=boolean.valueof(system.label.GA_BCNFuntionality);
    public static final boolean BCBSMFunctionality=boolean.valueof(system.label.GA_BCBSMFuntionalityBAAG);
    public static final string BAAGNotAvailable=system.label.GA_BAAGServiceNotAvailable;
    public static final string IntErrKey=system.label.GA_IntErrKey;
    public static final string UnbleToPrcssRq=system.label.GA_BAAGUnbleToPrcssRq;
    public static final string ClsName  ='GA_AP_BAAGServiceCls';
    public static final string methodNmeBAAGDoc  ='getBenefitDoc';
    public static final string SrvcNm  ='BAAG';
    public static final string SrvcNm1  ='NASCO';
    public static final string SrvcNm2  ='MOS';
    public static final string SrvcNmBCN  ='BCN';
    public static final string mosIndN ='N';
    public static final string reqrdDate = 'yyyy-MM-dd';
    public static final string ovrlayInd='Y';
    public static final string docType = 'PDF_CHKOPTOUT';
    public static final String Blank ='';
    public static final string DocExtASC='doc';
    public static final string DocTypASC='WORD';
    public static final string DocCntTypeASC='application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    public static final string ASCSelfFund='Self-Funded (ASC)';
    public static final string ASC2549='ASC 25-49';
    public static final string ASCNtlITS='ASC National ITS';
    public static final String NtwrkBlank='Invalid Network';
    /**
@Description: getBenefitDoc() method 
@Name : getBenefitDoc
@Param : id currentId
@Return : map<string,string>
@throws Exception : AuraHandledException;
*/    
    @AuraEnabled
    public static map<string,string> getBenefitDoc(id currentId)
    {
        try
        {
            user usr=[select id,email,EmployeeNumber,Phone from user where id=:userinfo.getUserId() limit 1];
            GA_Plan_Package__c pnPkg=[select id,Name,GA_Class__c,GA_Group_Segment__r.GA_Account_Type__c,GA_Group_Segment__r.GA_Group_Suffix_Frmla__c,GA_Group_Segment__r.GA_Group_Name__c,
                                      GA_Group_Segment__r.GA_MTV_Group__c,GA_Group_Segment__r.GA_MTV_Group_Division__c,GA_Plan_Package__c,GA_Coverage_Begin_Date__c,GA_Group_Segment__r.Name,
                                      GA_Group_Segment__r.Network__c  ,GA_Group_Segment__r.GA_Rating_Type__c
                                      from GA_Plan_Package__c where id=:currentId limit 1];
            boolean reqfld=false;
            string reqField;
            sObject sObj=pnPkg;
            string SrvcType='';
            if(pnPkg.GA_Group_Segment__r.Network__c==SrvcNm1)
            {
                SrvcType=SrvcNm1;  
               /* if(pnPkg.GA_Group_Segment__r.GA_Rating_Type__c==ASCSelfFund 
                   || pnPkg.GA_Group_Segment__r.GA_Rating_Type__c==ASC2549 
                   || pnPkg.GA_Group_Segment__r.GA_Rating_Type__c==ASCNtlITS)
                {
                    DocExt=DocExtASC;
                    DocTyp=DocTypASC;
                    DocCntType=DocCntTypeASC;
                }*/
            }
            if(pnPkg.GA_Group_Segment__r.Network__c==SrvcNm2)
            {
                SrvcType=SrvcNm2;  
            }

            if(SrvcType !=Blank || pnPkg.GA_Group_Segment__r.Network__c==SrvcNmBCN)
            {
                for(GA_Integration_Required_Fields__mdt BaagReqFld: [select label,DeveloperName,Field_API_Name__c,GA_Object_API_Name__c,GA_Service_Name__c from GA_Integration_Required_Fields__mdt where GA_Service_Name__c=:SrvcNm and GA_MOS_BCN__c=:SrvcType  limit 50])
                {
                    
                    if(BaagReqFld.GA_Object_API_Name__c !=null)
                    {
                        if(string.isblank((String)sObj.getSObject(BaagReqFld.GA_Object_API_Name__c).get(BaagReqFld.Field_API_Name__c)))
                        {
                            reqfld=true;
                            reqField = BaagReqFld.label ;
                            break;   
                        }
                        
                    }
                    else
                    {
                        if((String)sObj.get(BaagReqFld.Field_API_Name__c)==null)
                        {
                            reqfld=true;
                            reqField = BaagReqFld.label ;
                            break;  
                        }
                        
                    }
                }
                if(!reqfld)
                {
                    
                    if(pnPkg.GA_Group_Segment__r.Network__c==SrvcNmBCN)
                    {
                        respMap.put(CodeVal,IntErrKey);
                        respMap.put(DescpVal,BaagNotForBCN);
                        return respMap; 
                    }  
                    
                    
                    else
                    { 
                        if(BCBSMFunctionality)
                        {
                        string ReqBody;
                        if(SrvcType==SrvcNm1)                     
                            ReqBody=serializeReqNasco(pnPkg,usr);
                        else
                            ReqBody=serializeReq(pnPkg,usr);    
                        
                        HttpRequest req = new HttpRequest();
                        
                        req.setEndpoint(BaagEndpoint);
                        req.setMethod(ReqTyp);
                        req.setTimeout(120000);
                        req.setbody(ReqBody);
                        
                        Http http = new Http();
                        HTTPResponse res = http.send(req);
                        
                        string AddInfo;
                        string Description;
                        string Code;
                        JSONParser parser = JSON.createParser(fetchJSONData(res.getBody()));
                        while (parser.nextToken() != null) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                                (parser.getText() ==CodeVal || parser.getText() ==AddInfoVal || parser.getText() ==DescpVal)) {
                                    if(parser.getText() ==CodeVal)
                                    {
                                        parser.nextToken();
                                        Code=parser.getText();
                                        respMap.put(CodeVal, Code);
                                    }
                                    if(parser.getText() ==AddInfoVal)
                                    {
                                        parser.nextToken();
                                        if(AddInfo==null)
                                            AddInfo=parser.getText();
                                    }
                                    if(parser.getText() ==DescpVal)
                                    {
                                        parser.nextToken();
                                        if(Description==null)
                                            Description=parser.getText();
                                    }
                                }
                        }
                        
                        if(Code ==SuccessCode)
                        {
                            id fldrid=[SELECT Id, Name FROM Folder where name=:foldrName limit 1].id;
                            Document d = new Document(); 
                            d.Name = pnPkg.Name; 
                            d.folderid=fldrid;
                            d.Body = EncodingUtil.convertFromHex(fetchBinaryData(EncodingUtil.convertToHex(res.getBodyasBlob())));
                            d.ContentType = DocCntType;
                            d.Type = DocExt;
                            insert d; 
                            respMap.put(DocId, d.id);
                        }
                        else
                        {
                            string Resp=(String.Valueof(res.getBody()).length() > 131072) ? String.Valueof(res.getBody()).substring(0, 131072):(String.Valueof(res.getBody()) );
                                if(AddInfo !=null)
                                GA_logBCBSMWSException.logWSError(new Map<String,String>{pnPkg.id => Code+HyphenVal+Description+excepSepartr+AddInfo},BaagService,system.Label.GA_Action,Resp);                      
                            else
                                GA_logBCBSMWSException.logWSError(new Map<String,String>{pnPkg.id => Code+HyphenVal+Description},BaagService,system.Label.GA_Action,Resp);                      
                            
                            respMap.put(DescpVal, UnbleToPrcssRq); 
                            respMap.put(AddInfoKey,AddInfo);
                        }
                        
                        return respMap;
                        }
                        else
                        {
                            respMap.put(CodeVal,IntErrKey);
                            respMap.put(DescpVal,BAAGNotAvailable);
                            return respMap; 
                        }
                    }
                    
                }
                else
                {
                    respMap.put(CodeVal,IntErrKey);
                    respMap.put(DescpVal, reqfieldErr+HyphenVal+reqField);
                    return respMap; 
                }
            }
            else
            {
                respMap.put(CodeVal,IntErrKey);
                respMap.put(DescpVal, NtwrkBlank);
                return respMap; 
            }
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeBAAGDoc);
            throw new AuraHandledException(ErrMsg+excepSepartr+e.getMessage()); 
        }
    }

    /**
@Description: serializeReq() method 
@Name : serializeReq
@Param : GA_Plan_Package__c pnPkg,user usr
@Return : string
*/
    private static string serializeReq( GA_Plan_Package__c pnPkg,user usr){

            GA_BAAGParseJSON.cls_VersionInfo vrsnInfo=new GA_BAAGParseJSON.cls_VersionInfo();
            vrsnInfo.ServiceVersion=SrvcVersn;
            vrsnInfo.SchemaVersion=SchmVersn;
            
            GA_BAAGParseJSON.cls_Consumer consumr=new GA_BAAGParseJSON.cls_Consumer();
            consumr.ID=SFGrpCRM;
            consumr.Name=SFGrpCRMNm;
        
            GA_BAAGParseJSON.cls_ReqHeaderArea Reqhdrarea=new GA_BAAGParseJSON.cls_ReqHeaderArea();
            Reqhdrarea.VersionInfo=vrsnInfo;
            Reqhdrarea.CreationDateTime=string.valueof(system.now());
            Reqhdrarea.MessageID=MessgID;
            Reqhdrarea.Consumer=consumr;
            Reqhdrarea.systemEnvironmentCode=system.label.GA_systemEnvironmentCode;
            
            GA_BAAGParseJSON.cls_GroupInfo groupInfo =  New GA_BAAGParseJSON.cls_GroupInfo();
            groupInfo.groupNo =  pnPkg.GA_Group_Segment__r.GA_MTV_Group__c;
            //groupInfo.Suffix = pnPkg.GA_Group_Segment__r.GA_Group_Suffix_Frmla__c; --MKN
            groupInfo.Section = pnPkg.GA_Group_Segment__r.GA_Group_Suffix_Frmla__c; 
            
            GA_BAAGParseJSON.cls_Benefitinfo benefitInfo = New GA_BAAGParseJSON.cls_Benefitinfo();
            benefitInfo.GroupName = pnPkg.GA_Group_Segment__r.GA_Group_Name__c;
            benefitInfo.GroupNumber =  pnPkg.GA_Group_Segment__r.GA_MTV_Group__c;
            
            GA_BAAGParseJSON.cls_BenefitKey setbenefitKey = New GA_BAAGParseJSON.cls_BenefitKey();
            setbenefitKey.BPID = pnPkg.GA_Plan_Package__c;
            
            GA_BAAGParseJSON.cls_Name qName = New GA_BAAGParseJSON.cls_Name();
            qName.First =  userinfo.getFirstName();
            qName.Last=  userinfo.getLastName();
            
            GA_BAAGParseJSON.cls_RequestorInfo reqinfo = New GA_BAAGParseJSON.cls_RequestorInfo();
            reqinfo.Email = usr.email;
            reqinfo.Name = qName;
            
            GA_BAAGParseJSON.cls_TrackingInfo trackingInfo = New GA_BAAGParseJSON.cls_TrackingInfo();
            DateTime dt = DateTime.now();
            trackingInfo.QuoteID = QuoteIDPreFx+dt.format(QuoteID);
            trackingInfo.AppTriggerEvent=AppTriggerEvent;
            trackingInfo.BusinessArea=BusinessArea;
            
            trackingInfo.UserID=usr.EmployeeNumber;
            trackingInfo.UserType = UsrType;
            trackingInfo.RequestorInfo = reqinfo;
            trackingInfo.ID=pnPkg.GA_Group_Segment__r.Name;
            
            GA_BAAGParseJSON.cls_PayloadArea payloadarea=new GA_BAAGParseJSON.cls_PayloadArea();
            payloadarea.GroupInfo=groupInfo;     
            payloadarea.BenefitInfo = benefitInfo; 
            payloadarea.BenefitKey = setbenefitKey;
            payloadarea.DocType = DocTyp;
            payloadarea.EffectiveDate = string.valueof(pnPkg.GA_Coverage_Begin_Date__c);
            payloadarea.IncludeAttachmentInd = IncludeAttchhmentInd;         
            payloadarea.MOSInd = MOSInd ;
            
            payloadarea.RequestType = RequestType;
            payloadarea.RetrieveBenefitInd = RetrieveBenefitInd;
            payloadarea.TrackingInfo = trackingInfo;
            
            GA_BAAGParseJSON.cls_CreateBenefitDocRequest crtBenefitDoc = New GA_BAAGParseJSON.cls_CreateBenefitDocRequest();
            crtBenefitDoc.ReqHeaderArea=Reqhdrarea;
            crtBenefitDoc.PayloadArea=payloadarea;   
            
            GA_BAAGParseJSON jsonReq=new GA_BAAGParseJSON(crtBenefitDoc);
            string benefitJsonReq=JSON.serialize(jsonReq);
            benefitJsonReq=benefitJsonReq.replace(GrpNoKey, GrpNoVal);     
            return benefitJsonReq;

    }
    /**
@Description: serializeReqNasco() method 
@Name : serializeReqNasco
@Param : GA_Plan_Package__c pnPkg,user usr
@Return : string
*/    
    private static string serializeReqNasco( GA_Plan_Package__c pnPkg,user usr){

            GA_BAAGParseJSONNASCO.cls_VersionInfo vrsnInfo=new GA_BAAGParseJSONNASCO.cls_VersionInfo();
            vrsnInfo.ServiceVersion=SrvcVersn;
            vrsnInfo.SchemaVersion=SchmVersn;
            
            GA_BAAGParseJSONNASCO.cls_Consumer consumr=new GA_BAAGParseJSONNASCO.cls_Consumer();
            consumr.ID=SFGrpCRM;
            consumr.Name=SFGrpCRMNm;
        
            GA_BAAGParseJSONNASCO.cls_ReqHeaderArea Reqhdrarea=new GA_BAAGParseJSONNASCO.cls_ReqHeaderArea();
            Reqhdrarea.VersionInfo=vrsnInfo;
            Reqhdrarea.CreationDateTime=string.valueof(system.now());
            Reqhdrarea.MessageID=MessgID;
            Reqhdrarea.Consumer=consumr;
            Reqhdrarea.systemEnvironmentCode=system.label.GA_systemEnvironmentCode;
            
            GA_BAAGParseJSONNASCO.cls_GroupInfo groupInfo =  New GA_BAAGParseJSONNASCO.cls_GroupInfo();
            groupInfo.mosInd= mosIndN;
            groupInfo.groupNo =  pnPkg.GA_Group_Segment__r.GA_MTV_Group__c.substring(4);
            //groupInfo.Section = pnPkg.GA_Group_Segment__r.GA_MTV_Group_Division__c; 
            groupInfo.Section = pnPkg.GA_Group_Segment__r.GA_Group_Suffix_Frmla__c;
            /*GA_BAAGParseJSON.cls_Benefitinfo benefitInfo = New GA_BAAGParseJSON.cls_Benefitinfo();
            benefitInfo.GroupName = pnPkg.GA_Group_Segment__r.GA_Group_Name__c;
            benefitInfo.GroupNumber =  pnPkg.GA_Group_Segment__r.GA_MTV_Group__c;
            
            GA_BAAGParseJSON.cls_BenefitKey setbenefitKey = New GA_BAAGParseJSON.cls_BenefitKey();
            setbenefitKey.BPID = pnPkg.GA_Plan_Package__c;*/
            
            GA_BAAGParseJSONNASCO.cls_Name qName = New GA_BAAGParseJSONNASCO.cls_Name();
            qName.First =  userinfo.getFirstName();
            qName.Last=  userinfo.getLastName();
            
            GA_BAAGParseJSONNASCO.cls_RequestorInfo reqinfo = New GA_BAAGParseJSONNASCO.cls_RequestorInfo();
            reqinfo.Email = usr.email;
            reqinfo.Name = qName;
            reqinfo.Phone=usr.Phone;
            
            GA_BAAGParseJSONNASCO.cls_TrackingInfo trackingInfo = New GA_BAAGParseJSONNASCO.cls_TrackingInfo();
            DateTime dt = DateTime.now();
            trackingInfo.QuoteID = QuoteIDPreFx+dt.format(QuoteID);
            trackingInfo.AppTriggerEvent=AppTriggerEvent;
            trackingInfo.BusinessArea=BusinessArea;
            trackingInfo.RequiredDate=system.now().format(reqrdDate);
            trackingInfo.UserID=usr.EmployeeNumber;
            trackingInfo.UserType = UsrType;
            trackingInfo.RequestorInfo = reqinfo;
            trackingInfo.ID=pnPkg.GA_Group_Segment__r.Name;
            
            GA_BAAGParseJSONNASCO.cls_PayloadArea payloadarea=new GA_BAAGParseJSONNASCO.cls_PayloadArea();
            payloadarea.BusinessChannel=SrvcNm1;
            payloadarea.GroupInfo=groupInfo;     
            payloadarea.DocType = docType;
            payloadarea.IncludeAttachmentInd = IncludeAttchhmentInd;         
            payloadarea.MOSInd = MOSInd ;  
            payloadarea.OverlayInd=ovrlayInd;
            payloadarea.RequestType = SrvcNm;
            payloadarea.RetrieveBenefitInd = RetrieveBenefitInd;
            payloadarea.TrackingInfo = trackingInfo;
            payloadarea.PackageCode=pnPkg.Name;

            GA_BAAGParseJSONNASCO.cls_CreateBenefitDocRequest crtBenefitDoc = New GA_BAAGParseJSONNASCO.cls_CreateBenefitDocRequest();
            crtBenefitDoc.ReqHeaderArea=Reqhdrarea;
            crtBenefitDoc.PayloadArea=payloadarea;   
            
            GA_BAAGParseJSONNASCO jsonReq=new GA_BAAGParseJSONNASCO(crtBenefitDoc);
            string benefitJsonReq=JSON.serialize(jsonReq);
            benefitJsonReq=benefitJsonReq.replace(GrpNoKey, GrpNoVal);     
            return benefitJsonReq;

    }
    /**
@Description: fetchBinaryData() method 
@Name : fetchBinaryData
@Param : String resp
@Return : String
*/    
    private static String fetchBinaryData(String resp){

            String binaryData ;
            
            integer strtBinData = resp.indexOf(blobRespFrmt1,resp.indexOf(blobRespFrmt1) + 1)+10;
            integer endBinData = resp.lastindexOf(blobRespFrmt2,resp.lastindexOf(blobRespFrmt2) - 1)-4;
            
            binaryData = resp.substring(strtBinData, endBinData);
            return binaryData; 

    }
    /**
@Description: fetchJSONData() method 
@Name : fetchJSONData
@Param : String resp
@Return : String
*/   
    private static String fetchJSONData(String resp){

            if(resp.indexOf(JsonRespFrmt1)!=-1)
            {
                String JSONData ;
                
                integer strtBinData = resp.indexOf(JsonRespFrmt2)+1;
                integer endBinData = resp.indexOf(JsonRespFrmt1,resp.indexOf(JsonRespFrmt1) + 1)-1;
                JSONData = resp.substring(strtBinData, endBinData);
                return JSONData;  
            }
            else
            {
                return resp;  
            }

    }
}