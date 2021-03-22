/*****************************************************************************************
Class Name   : GA_AP_SBCServiceCls
Date Created : 2/6/2018
Created By   : IDC Offshore
Description  : 1. This is the class for getting SBC document from external system and show in Plan Package.
******************************************************************************************/
public with sharing class GA_AP_SBCServiceCls {
    /**Class to throw exception*/
    public with sharing class ValidateException extends exception{}
    public static final map<string,string> respMap=new map<string,string>();
    public static final String CodeVal=system.label.GA_CodeVal_SBCBAAG;
    public static final String AddInfoKey=system.label.GA_AddInfoKey;
    public static final String DescpVal=system.label.GA_Description;
    public static final String AddInfoVal=system.label.GA_AdditionalInfo;
    public static final String SuccessCode=system.label.GA_SuccssCode;
    public static final String NoDataFoundCode=system.label.GA_NoDataFoundCode;
    public static final String ErrMsg=system.label.GA_SBCErrMsg;
    public static final String excepSepartr=': ';
    public static final String SBCEndpoint=system.label.GA_SBCEndpoint;
    public static final String ReqTyp=system.label.GA_Method_ReqType;
    public static final String DocId=system.label.GA_DocId;
    public static final String SrvcVersn=system.label.GA_Service_Version;
    public static final String SchmVersn=system.label.GA_Schema_Version;
    public static final String CnsmrId=system.label.GA_SBCCnsmrId;
    public static final String CnsmrMOSId=system.label.GA_ConsmrMOSId;
    public static final String CnsmrName=system.label.GA_SBCConsmrMOSNm;
    public static final String MessgID=system.label.GA_MessgID;
    public static  String DocCntType=system.label.GA_DocCntType;
    public static  String DocExt=system.label.GA_DocExt;
    public static final String UsrType='Employee';
    public static final String AppTriggerEvent='Upon Request';
    public static final String QuoteID='MMddyyyyHHmmss';
    public static final String QuoteIDPreFx='GA-';
    public static final String BusinessArea='Group-Sales CRM';
    public static final String MOSInd='Y';
    public static String DocTyp=system.label.GA_DocTyp;
    public static final String IncludeAttchhmentInd='Y';
    public static final String GrpNoKey='GrpNumber';
    public static final String GrpNoVal='Number';
    public static final String blobRespFrmt1='3e';
    public static final String blobRespFrmt2='2d2d';
    public static final String NoDocRecdMsg=system.label.GA_NoDocRecdMsg;
    public static final String HyphenVal=system.label.Hyphen;
    public static final String JsonRespFrmt1='--';
    public static final String JsonRespFrmt2='>';
    public static final String NoJsonRecvMsg=system.label.GA_NoJsonRecvMsg;
    public static final String foldrName=system.label.GA_BCBSM_FldrNme;
    public static final String SbcmosService='SBC MOS Service';
    public static final String PreGenInd='Y';
    public static final String PublishDocInd='N';
    public static final String BusinessChannel='OBI';
    public static final String CoverageFor='Individual/Family';
    public static final String URL=system.label.GA_URL;
    public static final String CnsmerName =system.label.GA_SBCConsmrBCNNm;
    public static final String PlnTyp = 'HMO';
    public static final String TollFreeNumbr =system.label.GA_Toll_Number;
    public static final String BusinsChanl ='BCN';
    public static final String BusinsChanlBCBSM ='BCBSM';
    public static final String ServcNme ='SBC';
    public static final String Blank ='';
    public static final String CveragVal='Beginning on or after ';
    public static final string UpdateKey='Update';
    public static final string UpdateValTrue='true';
    public static final string UpdateValfalse='false';
    public static final string ReqfieldErr=system.label.GA_ReqfieldErr;
    public static final boolean BCNFunctionality=boolean.valueof(system.label.GA_BCNFuntionality);
    public static final boolean BCBSMFunctionality=boolean.valueof(system.label.GA_BCBSMFuntionality);
    public static final string FormNumberReqMssg=system.label.GA_FormNumberReqMssg;
    public static final string SBCBCNNotAvailable=system.label.GA_SBCBCNNotAvailable;
    public static final string SBCBSCNSoldPrd=system.label.GA_SBCBSCNSoldPrd;
    public static final string IntErrKey=system.label.GA_IntErrKey;
    public static final string MOSSrvcTyp=system.label.GA_MOSVal;
    public static final string BCNSrvcTyp=system.label.GA_BCNVal;
    public static final string UnbleToPrcssRq=system.label.GA_SBCUnbleToPrcssRq;
    public static final string ClsName  ='GA_AP_SBCServiceCls';
    public static final string methodNmeSBCDoc  ='getSBCDoc';
    public static final string SrvcNmBCN  ='BCN';
    public static final string SrvcNmNSC  ='NASCO';
    public static final string SrvcNmMOS  ='MOS';
    public static final string DocExtASC='doc';
    public static final string DocTypASC='WORD';
    public static final string DocCntTypeASC='application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    //public static final string DocCntTypeASC='application/json';
    public static final string ASCSelfFund='Self-Funded (ASC)';
    public static final string ASC2549='ASC 25-49';
    public static final string ASCNtlITS='ASC National ITS';
    public static final String NtwrkBlank='Invalid Network';
    public static final string SBCNotAvailable=system.label.GA_SBCServiceNotAvailable;
    public static final list<string> invalidPlnType=system.label.GA_SBC_BCN_Plan_Type_Validations.split('~');
    /**
@Description: getSBCDoc() method 
@Name : getSBCDoc
@Param : id currentId
@Return : map<string,string>
@throws Exception : AuraHandledException;
*/        
    @AuraEnabled
    public static map<string,string> getSBCDoc(id currentId)
    {
        try
        {
            user usr=[select id,email,EmployeeNumber from user where id=:userinfo.getUserId() limit 1];
            GA_Plan_Package__c pnPkg=[select id,Name,GA_Group_Segment__r.GA_Group_Suffix_Frmla__c,GA_Group_Segment__r.GA_Group_Name__c,
                                      GA_Group_Segment__r.GA_MTV_Group__c,GA_Group_Segment__c,GA_Group_Segment__r.GA_MTV_Group_Division__c,GA_Group_Segment__r.name,
                                      GA_Plan_Package__c,GA_Coverage_Begin_Date__c,GA_Coverage_End_Date__c,GA_Class__c,
                                      GA_Group_Segment__r.GA_Account_Type__c,GA_Group_Segment__r.Network__c
                                      ,   GA_Group_Segment__r.GA_Rating_Type__c,GA_Group_Segment__r.GA_Region_Name__c
                                      from GA_Plan_Package__c where id=:currentId limit 1]; 
            
            string ReqBody;
            boolean reqfld=false;
            boolean soldprdMssg=false;
            string reqField;
            sObject sObj=pnPkg;
            string SrvcType=Blank;
            if(pnPkg.GA_Group_Segment__r.Network__c==SrvcNmNSC)
            {
                SrvcType=SrvcNmNSC;  
                if(pnPkg.GA_Group_Segment__r.GA_Rating_Type__c==ASCSelfFund 
                   || pnPkg.GA_Group_Segment__r.GA_Rating_Type__c==ASC2549 
                   || pnPkg.GA_Group_Segment__r.GA_Rating_Type__c==ASCNtlITS)
                {
                    DocExt=DocExtASC;
                    DocTyp=DocTypASC;
                    DocCntType=DocCntTypeASC;
                }
            }
            if(pnPkg.GA_Group_Segment__r.Network__c==SrvcNmMOS)
            {
                SrvcType=MOSSrvcTyp;
                if(pnPkg.GA_Group_Segment__r.GA_Rating_Type__c==ASCSelfFund 
                   || pnPkg.GA_Group_Segment__r.GA_Rating_Type__c==ASC2549 
                   || pnPkg.GA_Group_Segment__r.GA_Rating_Type__c==ASCNtlITS)
                {
                    DocExt=DocExtASC;
                    DocTyp=DocTypASC;
                    DocCntType=DocCntTypeASC;
                }
            }
             list<asset> sldprdLst=new list<asset> ();   
            if(pnPkg.GA_Group_Segment__r.Network__c==SrvcNmBCN)
            {
                SrvcType=BCNSrvcTyp; 
                sldprdLst=[select id,GA_Form_Numbers__c,GA_Product_Family__c,GA_Plan_Type__c from asset where 
                           GA_Plan_Package_Id__r.GA_Group_Segment__c=:pnPkg.GA_Group_Segment__c
                           and GA_Plan_Package_Id__r.GA_ACTIVE_IND__c='Active' and GA_Plan_Package_Id__r.GA_Coverage_Begin_Date__c<=:system.today()];
                
            }
                
            
            if(SrvcType !=Blank)
            {
                for(GA_Integration_Required_Fields__mdt SBCReqFld: [select label,DeveloperName,GA_MOS_BCN__c,GA_Child_Object_API_Name__c,
                                                                    Field_API_Name__c,GA_Object_API_Name__c,GA_Service_Name__c,
                                                                    GA_Other_Validation__c,GA_Other_Validation_Value__c,GA_Error_Message__c
                                                                    from GA_Integration_Required_Fields__mdt 
                                                                    where GA_Service_Name__c=:ServcNme and GA_MOS_BCN__c=:SrvcType limit 50])
                {
                    if(SBCReqFld.GA_Object_API_Name__c !=null && !SBCReqFld.GA_Other_Validation__c)
                    {
                        
                        if(string.isblank((String)sObj.getSObject(SBCReqFld.GA_Object_API_Name__c).get(SBCReqFld.Field_API_Name__c)))
                        {
                            reqfld=true;
                            reqField = SBCReqFld.label ;
                            break;
                        } 
                      
                                           
                    }
                    System.debug('BCNFunctionality '+BCNFunctionality);
                    if(BCNFunctionality)
                    {
                        if(pnPkg.GA_Group_Segment__r.Network__c==SrvcNmBCN)
                        {
                            if(SBCReqFld.GA_Object_API_Name__c !=null && SBCReqFld.GA_Other_Validation__c)
                            {
                                
                                if((String)sObj.getSObject(SBCReqFld.GA_Object_API_Name__c).get(SBCReqFld.Field_API_Name__c)==SBCReqFld.GA_Other_Validation_Value__c)
                                {
                                    reqfld=true;
                                    soldprdMssg=true;
                                    reqField = SBCReqFld.GA_Error_Message__c ;
                                    break; 
                                } 
                                
                            }
                            if(SBCReqFld.GA_Child_Object_API_Name__c!=null && SBCReqFld.GA_Object_API_Name__c ==null)
                            {
                                //if(sObj.getSObjects(SBCReqFld.GA_Child_Object_API_Name__c) !=null)
                                if(sldprdLst.size()>0)
                                {
                                    if(sldprdLst.size()>=1)
                                    {  
                                        boolean validfrmsting=false;
                                        boolean suprtedGrp=false;
                                        

                                        for(sObject childRecs:sldprdLst)
                                        {
                                            if(childRecs.get(SBCReqFld.Field_API_Name__c) !=null)
                                            {
                                                if(!invalidPlnType.contains((string)childRecs.get('GA_Plan_Type__c') ))
                                                {      
                                                    validfrmsting=true;
                                                    suprtedGrp=true;
                                                    break;
                                                }
                                                
                                                validfrmsting=true;
                                                
                                            }
                                            
                                        }
                                        if(!validfrmsting)
                                        {
                                            reqfld=true;
                                            reqField = SBCReqFld.label ;
                                            break; 
                                        }
                                        else
                                        {
                                          if(!suprtedGrp)
                                          {
                                              reqfld=true;
                                              soldprdMssg=true;
                                              reqField = system.label.GA_SBCNotSupprtGrps;
                                              break;  
                                          }
                                        }
                                    }
                                    else 
                                    {
                                        reqfld=true;
                                        soldprdMssg=true;
                                        reqField = SBCBSCNSoldPrd ;
                                        break; 
                                    }
                                    
                                }
                                
                                else
                                {
                                    reqfld=true;
                                    soldprdMssg=true;
                                    reqField = FormNumberReqMssg ;
                                    break;
                                }
                                
                            }
                           
                        }  
                    }
                    
                    if(SBCReqFld.GA_Child_Object_API_Name__c==null && SBCReqFld.GA_Object_API_Name__c ==null)
                    {
                        if(string.valueOf(sObj.get(SBCReqFld.Field_API_Name__c))==null)
                        {
                            reqfld=true;
                            reqField = SBCReqFld.label ;
                            break;
                        }  
                    }
                }
                if(!reqfld)
                {
                    
                    if(pnPkg.GA_Group_Segment__r.Network__c!=SrvcNmBCN){
                        if(BCBSMFunctionality)
                        {
                            if(SrvcType==SrvcNmNSC)
                            {
                                ReqBody=serializeReqNasco(pnPkg,usr); 
                            }
                            else
                                ReqBody=serializeReq(pnPkg,usr);
                            
                        }
                        else
                        {
                            respMap.put(CodeVal,IntErrKey);
                            respMap.put(DescpVal, SBCNotAvailable);
                            return respMap;
                        }

                    }
                    else{
                        if(BCNFunctionality)
                            ReqBody=serializeBCNReq(pnPkg,usr,sldprdLst);
                        else
                        {
                            respMap.put(CodeVal,IntErrKey);
                            respMap.put(DescpVal, SBCBCNNotAvailable);
                            return respMap; 
                        }
                    }
                    
                    system.debug('ReqBody->'+ReqBody);
                    HttpRequest req = new HttpRequest();
                    
                    req.setEndpoint(SBCEndpoint);
                    req.setMethod(ReqTyp);
                    req.setTimeout(120000);
                    req.setbody(ReqBody);
                    
                    Http http = new Http();
                    HTTPResponse res = http.send(req);
                     system.debug('ResBody->'+res.getBody());
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
                                    if(Code ==null)
                                        Code=parser.getText();
                                    respMap.put(CodeVal, Code);
                                }
                                if(parser.getText() ==AddInfoVal)
                                {
                                    parser.nextToken();
                                    if(AddInfo ==null)
                                        AddInfo=parser.getText();
                                }
                                if(parser.getText() ==DescpVal)
                                {
                                    parser.nextToken();
                                    if(Description ==null)
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
                        d.Body = EncodingUtil.convertFromHex(fetchBinaryData(EncodingUtil.convertToHex(res.getBodyasBlob())));//res.getBodyAsBlob(); 
                         
                        if(SrvcType==SrvcNmNSC)
                        {
                           d.ContentType = DocTypASC;
                           d.Type = DocExtASC;
                        }
                        else{
                              d.ContentType = DocCntType;                         
                              d.Type = DocExt;
                        }                            
                        system.debug('DocCntType : '+d.ContentType);
                        system.debug('Body : '+d.Body);
                        
                        insert d; 
                        system.debug('docid : '+d.id);
                        respMap.put(DocId, d.id);
                    }
                    else
                    {
                        string Resp=(String.Valueof(res.getBody()).length() > 131072) ? String.Valueof(res.getBody()).substring(0, 131072):(String.Valueof(res.getBody()) );
                            if(AddInfo !=null)
                            GA_logBCBSMWSException.logWSError(new Map<String,String>{pnPkg.id => Code+HyphenVal+Description+excepSepartr+AddInfo},SbcmosService,system.Label.GA_Action,Resp);                      
                        else
                            GA_logBCBSMWSException.logWSError(new Map<String,String>{pnPkg.id => Code+HyphenVal+Description},SbcmosService,system.Label.GA_Action,Resp);                          
                        
                        respMap.put(DescpVal, UnbleToPrcssRq);   
                        respMap.put(AddInfoKey,AddInfo);
                    }
                    
                    return respMap;
                }
                else
                {
                    respMap.put(CodeVal,IntErrKey);
                    if(!soldprdMssg)
                        respMap.put(DescpVal, reqfieldErr+HyphenVal+reqField);
                    else
                        respMap.put(DescpVal, reqField);    
                    return respMap; 
                }
                
            }
            else
            {
                respMap.put(DescpVal, NtwrkBlank);
                return respMap; 
            }
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeSBCDoc);
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
        
        GA_SBCParseJSON.cls_VersionInfo vrsnInfo=new GA_SBCParseJSON.cls_VersionInfo();
        vrsnInfo.ServiceVersion=SrvcVersn;
        vrsnInfo.SchemaVersion=SchmVersn;
        
        GA_SBCParseJSON.cls_Consumer consumr=new GA_SBCParseJSON.cls_Consumer();
        consumr.ID=CnsmrMOSId;
        consumr.Name=CnsmrName;
        
        GA_SBCParseJSON.cls_ReqHeaderArea Reqhdrarea=new GA_SBCParseJSON.cls_ReqHeaderArea();
        Reqhdrarea.VersionInfo=vrsnInfo;
        Reqhdrarea.CreationDateTime=string.valueof(system.now());
        Reqhdrarea.MessageID=MessgID;
        Reqhdrarea.Consumer=consumr;
        Reqhdrarea.systemEnvironmentCode=system.label.GA_systemEnvironmentCode;
        
        GA_SBCParseJSON.cls_Name qName = New GA_SBCParseJSON.cls_Name();
        qName.First =  userinfo.getFirstName();
        qName.Last=  userinfo.getLastName();
        
        GA_SBCParseJSON.cls_RequestorInfo reqinfo = New GA_SBCParseJSON.cls_RequestorInfo();
        reqinfo.Email = usr.email;
        reqinfo.Name = qName;
        
        GA_SBCParseJSON.cls_TrackingInfo trackingInfo = New GA_SBCParseJSON.cls_TrackingInfo();
        DateTime dt = DateTime.now();
        trackingInfo.ID=pnPkg.GA_Group_Segment__r.GA_MTV_Group__c + HyphenVal + pnPkg.GA_Group_Segment__r.GA_Group_Suffix_Frmla__c;//'007009359-0004';
        trackingInfo.UserType = UsrType;
        trackingInfo.UserID=usr.EmployeeNumber;
        trackingInfo.BusinessArea=BusinessArea;
        trackingInfo.QuoteID = QuoteIDPreFx+dt.format(QuoteID);
        trackingInfo.AppTriggerEvent=AppTriggerEvent;
        trackingInfo.RequestorInfo = reqinfo;
        
        GA_SBCParseJSON.cls_GroupInfoForOverlay grpInfoOvrLy=new GA_SBCParseJSON.cls_GroupInfoForOverlay();
        grpInfoOvrLy.mosInd=MOSInd;
        grpInfoOvrLy.GrpNumber=pnPkg.GA_Group_Segment__r.GA_MTV_Group__c;
        grpInfoOvrLy.Suffix=pnPkg.GA_Group_Segment__r.GA_Group_Suffix_Frmla__c;
        
        
        GA_SBCParseJSON.cls_GroupInfo grpInfo=new  GA_SBCParseJSON.cls_GroupInfo();
        grpInfo.GrpNumber=pnPkg.GA_Group_Segment__r.GA_MTV_Group__c;
        grpInfo.Suffix=pnPkg.GA_Group_Segment__r.GA_Group_Suffix_Frmla__c;
        
        GA_SBCParseJSON.cls_CoverageInfo cvrgInfo=new  GA_SBCParseJSON.cls_CoverageInfo();
        
        cvrgInfo.CoverageFor=CoverageFor;
        cvrgInfo.URL=URL;
        cvrgInfo.GroupInfoForOverlay=grpInfoOvrLy;
        
        //GA_SBCParseJSON.cls_TemplateInfo tmpltInfo=new  GA_SBCParseJSON.cls_TemplateInfo();
        //tmpltInfo.DocType=DocTyp;
        
        GA_SBCParseJSON.cls_PayloadArea payloadarea=new GA_SBCParseJSON.cls_PayloadArea();
        payloadarea.BusinessChannel=BusinessChannel;
        payloadarea.BPID= pnPkg.GA_Plan_Package__c;
        payloadarea.IncludeAttachmentInd = IncludeAttchhmentInd; 
        payloadarea.PreGenInd=PreGenInd;
        payloadarea.TrackingInfo = trackingInfo;
        payloadarea.CoverageInfo=cvrgInfo;
        //payloadarea.TemplateInfo=tmpltInfo;
        
        GA_SBCParseJSON.cls_CreateDocRequest crtDoc = New GA_SBCParseJSON.cls_CreateDocRequest();
        crtDoc.ReqHeaderArea=Reqhdrarea;
        crtDoc.PayloadArea=payloadarea;   
        
        GA_SBCParseJSON jsonReq=new GA_SBCParseJSON(crtDoc);
        string SBCJsonReq=JSON.serialize(jsonReq);  
        SBCJsonReq=SBCJsonReq.replace(GrpNoKey, GrpNoVal);
        
        return SBCJsonReq;
        
    }
    /**
@Description: serializeBCNReq method 
@Name : serializeBCNReq
@Param : GA_Plan_Package__c pnPkg,user usr
@Return : string
*/    
    private static string serializeBCNReq( GA_Plan_Package__c pnPkg,user usr,list<asset> sldprdLst){
        
        GA_SBCBCNParseJSON.cls_VersionInfo vrsnInfo=new GA_SBCBCNParseJSON.cls_VersionInfo();
        vrsnInfo.ServiceVersion=SrvcVersn;
        vrsnInfo.SchemaVersion=SchmVersn;
        
        GA_SBCBCNParseJSON.cls_Consumer consumr=new GA_SBCBCNParseJSON.cls_Consumer();
        consumr.ID=CnsmrId;
        consumr.Name= cnsmerName;
        
        GA_SBCBCNParseJSON.cls_ReqHeaderArea Reqhdrarea=new GA_SBCBCNParseJSON.cls_ReqHeaderArea();
        Reqhdrarea.VersionInfo=vrsnInfo;
        Reqhdrarea.CreationDateTime=string.valueof(system.now());
        Reqhdrarea.MessageID=MessgID;
        Reqhdrarea.Consumer=consumr;
        
        
        GA_SBCBCNParseJSON.cls_Name qName = New GA_SBCBCNParseJSON.cls_Name();
        qName.First =  userinfo.getFirstName();
        qName.Last=  userinfo.getLastName();
        
        GA_SBCBCNParseJSON.cls_RequestorInfo reqinfo = New GA_SBCBCNParseJSON.cls_RequestorInfo();
        reqinfo.Email = usr.email;
        reqinfo.Name = qName;
        
        GA_SBCBCNParseJSON.cls_TrackingInfo trackingInfo = New GA_SBCBCNParseJSON.cls_TrackingInfo();          
        trackingInfo.UserType = UsrType;
        trackingInfo.UserID=usr.EmployeeNumber;
        trackingInfo.BusinessArea=BusinessArea;
        
        trackingInfo.AppTriggerEvent=AppTriggerEvent;
        trackingInfo.RequestorInfo = reqinfo;
        
        GA_SBCBCNParseJSON.cls_CoverageInfo cvrgInfo=new  GA_SBCBCNParseJSON.cls_CoverageInfo();
        if(!string.isblank(string.valueof(pnPkg.GA_Coverage_End_Date__c)))
        {
            cvrgInfo.CoveragePeriod=string.valueof(pnPkg.GA_Coverage_Begin_Date__c)+HyphenVal+string.valueof(pnPkg.GA_Coverage_End_Date__c);
        }
        else
            cvrgInfo.CoveragePeriod=CveragVal+string.valueof(pnPkg.GA_Coverage_Begin_Date__c);
        
        cvrgInfo.CoverageFor=CoverageFor;
        cvrgInfo.GroupName=pnPkg.GA_Group_Segment__r.GA_Group_Name__c;
        cvrgInfo.PlanName=pnPkg.Name;
        cvrgInfo.PlanType= plnTyp;
        cvrgInfo.URL=URL;
        cvrgInfo.TollFreeNumber=tollFreeNumbr;
        
        
        GA_SBCBCNParseJSON.cls_TemplateInfo tmpltInfo=new  GA_SBCBCNParseJSON.cls_TemplateInfo();
        tmpltInfo.DocType=DocTyp;
        
        GA_SBCBCNParseJSON.cls_PayloadArea payloadarea=new GA_SBCBCNParseJSON.cls_PayloadArea();
        payloadarea.BusinessChannel=businsChanl;
        string frmString='';
        integer i=0;
        set<string> frmstringLst=new set<string>();
        for(Asset sldPrd:sldprdLst)
        {
            
            if(sldPrd.GA_Form_Numbers__c!=null 
               && (!invalidPlnType.contains((string)sldPrd.GA_Plan_Type__c )))
            {
                
                for(string frmNumbr:sldPrd.GA_Form_Numbers__c.split(','))
                {
                    
                    frmstringLst.add(frmNumbr.trim());
                }
            } 
        }
        for(string frmStrngTmp:frmstringLst)
        {
            if(i==0)
            {
                frmString= frmStrngTmp;             
            }
            else
            {
                frmString=frmString+','+frmStrngTmp;
            }
            i++;
        }
        
        payloadarea.RiderString=frmString;
        
        payloadarea.IncludeAttachmentInd = IncludeAttchhmentInd; 
        
        payloadarea.TrackingInfo = trackingInfo;
        payloadarea.CoverageInfo=cvrgInfo;
        payloadarea.TemplateInfo=tmpltInfo;
        
        GA_SBCBCNParseJSON.cls_CreateDocRequest crtDoc = New GA_SBCBCNParseJSON.cls_CreateDocRequest();
        crtDoc.ReqHeaderArea=Reqhdrarea;
        crtDoc.PayloadArea=payloadarea;   
        
        GA_SBCBCNParseJSON jsonReq=new GA_SBCBCNParseJSON(crtDoc);
        string SBCBCNJsonReq=JSON.serialize(jsonReq);  
        SBCBCNJsonReq=SBCBCNJsonReq.replace(GrpNoKey, GrpNoVal);
        
        return SBCBCNJsonReq;
        
    }
    
    /**
@Description: serializeReq() method 
@Name : serializeReq
@Param : GA_Plan_Package__c pnPkg,user usr
@Return : string
*/    
    private static string serializeReqNasco( GA_Plan_Package__c pnPkg,user usr){
        
        GA_SBCPraseJSONNASCO.cls_VersionInfo vrsnInfo=new GA_SBCPraseJSONNASCO.cls_VersionInfo();
        vrsnInfo.ServiceVersion=SrvcVersn;
        vrsnInfo.SchemaVersion=SchmVersn;
        
        GA_SBCPraseJSONNASCO.cls_Consumer consumr=new GA_SBCPraseJSONNASCO.cls_Consumer();
        consumr.ID=CnsmrMOSId;
        consumr.Name=CnsmrName;
        
        GA_SBCPraseJSONNASCO.cls_ReqHeaderArea Reqhdrarea=new GA_SBCPraseJSONNASCO.cls_ReqHeaderArea();
        Reqhdrarea.VersionInfo=vrsnInfo;
        Reqhdrarea.CreationDateTime=string.valueof(system.now());
        Reqhdrarea.MessageID=MessgID;
        Reqhdrarea.Consumer=consumr;
        Reqhdrarea.systemEnvironmentCode=system.label.GA_systemEnvironmentCode;
        
        GA_SBCPraseJSONNASCO.cls_Name qName = New GA_SBCPraseJSONNASCO.cls_Name();
        qName.First =  userinfo.getFirstName();
        qName.Last=  userinfo.getLastName();
        
        GA_SBCPraseJSONNASCO.cls_RequestorInfo reqinfo = New GA_SBCPraseJSONNASCO.cls_RequestorInfo();
        reqinfo.Email = usr.email;
        reqinfo.Name = qName;
        
        GA_SBCPraseJSONNASCO.cls_TrackingInfo trackingInfo = New GA_SBCPraseJSONNASCO.cls_TrackingInfo();
        DateTime dt = DateTime.now();
        trackingInfo.ID=pnPkg.GA_Group_Segment__r.Name;
        trackingInfo.UserType = UsrType;
        trackingInfo.UserID=usr.EmployeeNumber;
        trackingInfo.BusinessArea=BusinessArea;
        trackingInfo.AppTriggerEvent=AppTriggerEvent;
        trackingInfo.RequestorInfo = reqinfo; 
        
        GA_SBCPraseJSONNASCO.cls_GroupInfoForOverlay grpInfoOvrLy=new GA_SBCPraseJSONNASCO.cls_GroupInfoForOverlay();
        grpInfoOvrLy.GrpNumber=pnPkg.GA_Group_Segment__r.GA_MTV_Group__c.substring(4);
        grpInfoOvrLy.Suffix=pnPkg.GA_Group_Segment__r.GA_Group_Suffix_Frmla__c; 
        grpInfoOvrLy.PackageCode=pnPkg.Name;
        
        GA_SBCPraseJSONNASCO.cls_GroupInfo grpInfo=new  GA_SBCPraseJSONNASCO.cls_GroupInfo();
        grpInfo.GrpNumber=pnPkg.GA_Group_Segment__r.GA_MTV_Group__c.substring(4);
        grpInfo.Suffix=pnPkg.GA_Group_Segment__r.GA_Group_Suffix_Frmla__c;
        grpInfo.mosInd=PublishDocInd;
        grpInfo.PackageCode=pnPkg.Name;
        GA_SBCPraseJSONNASCO.cls_CoverageInfo cvrgInfo=new  GA_SBCPraseJSONNASCO.cls_CoverageInfo();
        
        cvrgInfo.CoverageFor=CoverageFor;
        cvrgInfo.GroupInfoForOverlay=grpInfoOvrLy;
        
        GA_SBCPraseJSONNASCO.cls_TemplateInfo tmpltInfo=new  GA_SBCPraseJSONNASCO.cls_TemplateInfo();
        
        GA_SBCPraseJSONNASCO.cls_PayloadArea payloadarea=new GA_SBCPraseJSONNASCO.cls_PayloadArea();
        payloadarea.BusinessChannel=BusinsChanlBCBSM;
        payloadarea.PreGenInd=PreGenInd;
        payloadarea.TrackingInfo = trackingInfo;
        payloadarea.CoverageInfo=cvrgInfo;
        payloadarea.TemplateInfo=tmpltInfo;
        payloadarea.GroupInfo=grpInfo; 
        
        GA_SBCPraseJSONNASCO.cls_CreateDocRequest crtDoc = New GA_SBCPraseJSONNASCO.cls_CreateDocRequest();
        crtDoc.ReqHeaderArea=Reqhdrarea;
        crtDoc.PayloadArea=payloadarea;   
        
        GA_SBCPraseJSONNASCO jsonReq=new GA_SBCPraseJSONNASCO(crtDoc);
        string SBCJsonReq=JSON.serialize(jsonReq);  
        SBCJsonReq=SBCJsonReq.replace(GrpNoKey, GrpNoVal);
        
        return SBCJsonReq;
        
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