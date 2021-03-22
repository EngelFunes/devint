/*****************************************************************************************
Class Name   : GA_AP_SearchDocSTAR
Date Created : 01/10/2017
Created By   : IDC Offshore
Description  : 1. This is the class for getting Docstar document from external system and show in Account record.
******************************************************************************************/
public with sharing class GA_AP_SearchDocSTAR {
    public static final string ErrMsg = system.label.GA_DocErrMsg;
    public static final string excepSepartr=': ';
    public static final string Blank='';
    public static final string DocStrEndpoint=system.label.GA_DocStrEndpoint;
    public static final string ReqType=system.label.GA_Method_ReqType;
    public static final string Name='Name';
    //public static string FlNme='FileName';
    public static final string CodeVal=system.label.GA_CodeVal;
    public static final string Val='Value';
    public static final string Descption=system.label.GA_Description;
    public static final string addInfo=system.label.GA_AdditionalInfo;
    public static final string SuccssCode=system.label.GA_SuccssCode;
    public static final string HundRecordCode=system.label.GA_100RecordCode;
    public static final String NoDataFoundCode=system.label.GA_NoDataFoundCode;
    public static final string FrwdSlsh='/';
    public static final string Itmid='ITEMID';
    public static final string Succs='Success';
    public static final string Err='Error';
    public static final string NoDocMsg=system.label.GA_NoDocMsg;
    public static final string CIDReq=system.label.GA_CIDReq;
    public static final string Hyphen='-';
    public static final string CustId=system.label.GA_CustomerID;
    public static final string Eqlto='EQUAL_TO';
    public static final string Dtmapnm=system.label.GA_DataMapping;
    public static final string PlodaraId=system.label.GA_PlodaraId;
    public static final string PlodaraPwd=system.label.GA_PlodaraPwd;
    public static final string ReTrvDocEndpoint=system.label.GA_ReTrvDocEndpoint;
    public static final string mimetypeVal='mimeType:';
    public static final string fileExtVal='fileExtn:';
    public static final string DocExt='docx';
    public static final string SrvcVrsn=system.label.GA_Service_Version;
    public static final string SchmVrsn=system.label.GA_Schema_Version;
    public static final string CosmrId=system.label.GA_ConsumerId;
    public static final string MsgIdSrchBnft=system.label.GA_MsgIdSrchBnft;
    public static final string MsgIdRetrv=system.label.GA_MsgIdRetrv;
    public static final string RetrivDocMimtypFetch1='{ "RetrieveDocumentResponse":';
    public static final string RetrivDocMimtypFetch2='"Value":"GroupCRM" } ] } } }';
    public static final string RetrivDocMimtypFetch3='"Value":"DocuSignDocs" } ] } } }';
    public static final string RetrivDocMimtypFetch4='] } } }';
    public static final string Mimty='MimeType';
    public static final string RetriveBlob1='3e';
    public static final string RetriveBlob2='2d2d';
    public static final string FoldrName=system.label.GA_BCBSM_FldrNme;
    public static  String objectName = '';
    public static final string UnbleToPrcssRq=system.label.GA_DOCStrUnbleToPrcssRq;
    public static final string ClsName  ='GA_AP_SearchDocSTAR';
    public static final string methodNmeSrchDoc  ='searchAccountDocument';
    public static final string methodNmeRtrvDoc  ='fetchAccountDocument';
    public static final string FiltrCntAttbts ='Y';
    public static final String WFHISOBJNM = 'GA_HIST_WF_STEP__c';
    public static final string ASAPdataMapNm = 'SFGRPCRM_CM_ASAP_ALL';
    public static final String FILTYPS = 'file_type';
    /**
@Description: searchAccountDocument() method 
@Name : searchAccountDocument
@Param : id currentId
@Return : list<docstarDispWrap>
@throws Exception : AuraHandledException;
*/
    @AuraEnabled
    public static list<docstarDispWrap> searchAccountDocument(id currentId,string objName, datetime strtDate, datetime endDate)
    {
        try
        {
            
            list<docstarDispWrap> docstrwrpLst=new list<docstarDispWrap>();
            //Account currentAccount = [Select CID__c from Account where id=:currentId limit 1];
            GA_AP_FetchDocstarAttbt.retrnIdMsgWrap retnWrp=GA_AP_FetchDocstarAttbt.fetchattbt(currentId, objName);
            objectName = objName;
            String accCID =  retnWrp.retnId;
            
            List<string> fileList=New List<string>();
            List<string> itemList=New List<string>();   
            List<string> itmTypeList=New List<string>();
            List<string> ImgRefList=New List<string>(); 
            List<string> fileSizeList=New List<string>();
            
            map<string,string> ImgRefmap=new map<string,string>();
            List<string> scandateList=New List<string>();
            List<string> FilTypeList=New List<string>();
            List<string> CidList=New List<string>();
            List<Datetime> crdteList=new list<Datetime>();
           
            map<string,Datetime> submittedDateMap=new map<string,Datetime>();
            map<string,string> documentTypemap=new map<string,string>();            
            String serviceResponse ;
            String SerResDescription;
            string SerResAddInfo;
            list<string> attbtInpLst=new list<string>();
            if(accCID !=null)
                attbtInpLst=accCID.split('~');
            else
            {
                attbtInpLst.add('null');  
            }
            list<string> errMsgLst=retnWrp.errMsg.split('~');
            list<string> inpNmLst=retnWrp.inpNm.split('~');
            list<string> datmapNmLst=retnWrp.DtaMpNm.split('~');
            
            if(attbtInpLst.size()>0){ 
                integer y=0;
                for(string attbtInp:attbtInpLst)
                {
                    itemList=New List<string>(); 
                    fileList=New List<string>();
                    itmTypeList=New List<string>();
                    ImgRefList=New List<string>();
                    ImgRefmap=new map<string,string>();
                    FilTypeList=New List<string>();
                    crdteList=new list<Datetime>();
                    submittedDateMap = new map<string,Datetime>();
                    documentTypemap=new map<string,string>();
                    CidList=New List<string>();
                    fileSizeList=New List<string>();
                    
                    if(attbtInp !='null')
                    {
                        string ReqBody=serializeReq(attbtInp,inpNmLst[y],datmapNmLst[y],retnWrp.cntFltrAttbt,
                                                    strtDate,endDate);
                        HttpRequest req = new HttpRequest();
                        req.setEndpoint(DocStrEndpoint);
                        req.setMethod(reqType);
                        req.setTimeout(120000);
                        req.setbody(ReqBody);
                        system.debug('req->'+ReqBody);
                        Http http = new Http();
                        HTTPResponse res = http.send(req);
                        system.debug('res->'+res.getBody());
                        JSONParser  parser = JSON.createParser(res.getBody());
                        string filnmeValTmp='';
                        while (parser.nextToken() != null) { 
                            
                            integer Counter = 0;
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) ){   
                                Counter++;
                                String fieldName = parser.getText();
                                parser.nextToken();
                                String fieldValue=parser.getText();
                                String docValue;
                                String docName;
                                String scanDate;
                                
                                if(fieldName == 'Attribute') {                        
                                    filnmeValTmp='';
                                }
                                
                                if(fieldName == Name && fieldValue=='item_id') {                        
                                    parser.nextToken();
                                    if(parser.getText()==val){
                                        parser.nextToken();
                                        docValue= parser.getText();
                                        
                                        filnmeValTmp=docValue;
                                        system.debug('filnmeValTmp->'+filnmeValTmp);
                                    }
                                }
                                if(fieldName == Name && fieldValue==itmid) {                        
                                    parser.nextToken();
                                    if(parser.getText()==val){
                                        parser.nextToken();
                                        docValue= parser.getText();
                                        itemList.add(docValue);
                                        filnmeValTmp=docValue;
                                        
                                    }
                                }
                                
                                //if(fieldName == Name && fieldValue==retnWrp.filenme) { 
                                if(fieldName == Name && fieldValue=='OriginalFileName') {                                    
                                    parser.nextToken();
                                    if(parser.getText()==val){
                                        parser.nextToken();
                                        docName= parser.getText(); 
                                        system.debug('OriginalFileName'+docName);
                                        fileList.add(docName);
                                    }
                                }
                                if(fieldName == Name && fieldValue=='FILE_TYPE') {                        
                                    parser.nextToken();
                                    if(parser.getText()==val){
                                        parser.nextToken();
                                        docValue= parser.getText();
                                        FilTypeList.add(docValue);
                                    }
                                }
                                if(fieldName == Name && fieldValue=='cid') {                        
                                    parser.nextToken();
                                    if(parser.getText()==val){
                                        parser.nextToken();
                                        docValue= parser.getText();
                                        CidList.add(docValue);
                                    }
                                }
                                
                                if(fieldName == Name && fieldValue=='ItemType') {                        
                                    parser.nextToken();
                                    if(parser.getText()==val){
                                        parser.nextToken();
                                        docValue= parser.getText();
                                        itmTypeList.add(docValue);
                                        
                                    }
                                }
                                if(fieldName == Name && fieldValue=='OriginalFileSize') {                        
                                    parser.nextToken();
                                    if(parser.getText()==val){
                                        parser.nextToken();
                                        docValue= parser.getText();
                                        fileSizeList.add(docValue);
                                        
                                    }
                                }
                                if(fieldName == Name && fieldValue=='Image_Ref') {                        
                                    parser.nextToken();
                                    if(parser.getText()==val){
                                        parser.nextToken();
                                        docValue= parser.getText();
                                        ImgRefList.add(docValue);
                                        system.debug('filnmeValTmp inside img->'+filnmeValTmp);
                                        ImgRefmap.put(filnmeValTmp,docValue); 
                                    }
                                }
                                if(fieldName == Name && fieldValue=='CREATETS') {                        
                                    parser.nextToken();
                                    if(parser.getText()==val){
                                        parser.nextToken();
                                        docValue= parser.getText();
                                        system.debug('docValue->'+docValue);
                                        crdteList.add(datetime.newinstance(long.valueOf(docValue)));
                                        // crdteList.sort();
                                    }
                                }
                                if(fieldName == Name && fieldValue=='Submission_Date') {                        
                                    parser.nextToken();
                                    if(parser.getText()==val){
                                        parser.nextToken();
                                        docValue= parser.getText();                                     
                                        system.debug('filnmeValTmp inside SubmissionDate->'+filnmeValTmp);
                                        if(docValue != null)
                                        submittedDateMap.put(filnmeValTmp,datetime.newinstance(long.valueOf(docValue))); 
                                    }
                                }
                                if(fieldName == Name && fieldValue=='Document_Type') {                        
                                    parser.nextToken();
                                    if(parser.getText()==val){
                                        parser.nextToken();
                                        docValue= parser.getText();                                   
                                        system.debug('filnmeValTmp inside docType->'+filnmeValTmp);
                                        documentTypemap.put(filnmeValTmp,docValue); 
                                    }
                                }
                                if(fieldName == CodeVal) {                        
                                    
                                    serviceResponse = parser.getText();
                                }
                                if(fieldName == Descption) {                        
                                    
                                    SerResDescription = parser.getText();
                                }
                                if(fieldName == addInfo) {                        
                                    
                                    SerResAddInfo = parser.getText();
                                }
                                
                            }
                        } 
                        
                        if(serviceResponse == SuccssCode ||serviceResponse == HundRecordCode){
                           
                            
                            if(itemList.size() > 0){
                                for (Integer i = 0; i < itemList.size(); i++) {
                                     String hundredRecCodeMsg = Blank;
                                     if(serviceResponse == HundRecordCode)
                                     {
                                         hundredRecCodeMsg= 'Hundred';   
                                     }
                                    docstarDispWrap docStrDisp=new docstarDispWrap(fileList[i], itemList[i],succs,Blank,Blank,datmapNmLst[y],hundredRecCodeMsg);
                                    if(FilTypeList.size()>0)
                                        docStrDisp.FilType=FilTypeList[i];
                                    if(CidList.size()>0 && CidList.size() == itemList.size()){
                                        docStrDisp.CidVal=CidList[i]; 
                                    } else{
										docStrDisp.CidVal='';                                        
                                    }
                                                                          
                                    if(itmTypeList.size()>0)
                                        docStrDisp.itemType=itmTypeList[i];
                                    system.debug('ImgRefmapVals'+ImgRefmap);
                                    if(ImgRefmap.keyset().size()>0)
                                    {
                                        if(ImgRefmap.get(itemList[i]) !=null)
                                            docStrDisp.imgRef=ImgRefmap.get(itemList[i]);  
                                        else
                                            docStrDisp.imgRef='';   
                                    }
                                    if(submittedDateMap.keyset().size()>0)
                                    {
                                        if(submittedDateMap.get(itemList[i]) !=null)
                                            docStrDisp.submittedDteVal =submittedDateMap.get(itemList[i]);  
                                        else
                                            docStrDisp.submittedDteVal=null;   
                                    }
                                    if(documentTypemap.keyset().size()>0)
                                    {
                                        if(documentTypemap.get(itemList[i]) !=null)
                                            docStrDisp.documentType=documentTypemap.get(itemList[i]);  
                                        else
                                            docStrDisp.documentType='';   
                                    }
                                    if(crdteList.size()>0)
                                        docStrDisp.createdDteVal=crdteList[i];
                                    
                                    if(fileSizeList.size()>0)
                                        docStrDisp.fileSize=fileSizeList[i];
                                    
                                    docstrwrpLst.add(docStrDisp);
                                }
                                docstrwrpLst.sort();
                            }
                            else{
                                if(docstrwrpLst.size()>0)
                                {
                                    docstrwrpLst.remove(0); 
                                }
                                docstrwrpLst.add(new docstarDispWrap(Blank, Blank,err,NoDocMsg,Blank,datmapNmLst[y],Blank));
                            }
                            
                        }
                        
                        else{
                            
                            
                            if(serviceResponse !=NoDataFoundCode)
                            {
                                if(docstrwrpLst.size()>0)
                                {
                                    docstrwrpLst.remove(0); 
                                }
                                string Resp=(String.Valueof(res.getBody()).length() > 131072) ? String.Valueof(res.getBody()).substring(0, 131072):(String.Valueof(res.getBody()) );
                                    //docstrwrpLst.add(new docstarDispWrap(Blank, Blank,err,serviceResponse+Hyphen+SerResDescription,SerResAddInfo));
                                                                    
                                docstrwrpLst.add(new docstarDispWrap(Blank, Blank,err,UnbleToPrcssRq,Blank,datmapNmLst[y],Blank));
                                   
                                GA_logBCBSMWSException.logWSError(new Map<String,String>{currentId => serviceResponse+Hyphen+SerResDescription},system.Label.GA_DocSTARService,system.Label.GA_Action,Resp);                      
                            }
                            else
                            {
                                if(docstrwrpLst.size()>0)
                                {
                                    docstrwrpLst.remove(0); 
                                }
                                docstrwrpLst.add(new docstarDispWrap(Blank, Blank,err,NoDocMsg,Blank,datmapNmLst[y],Blank));
                            }
                            
                        }
                        
                        
                    }
                    else
                    {
                        if(datmapNmLst[y] !='SFGRPCRM_CM_DocuSignDocs')
                            docstrwrpLst.add(new docstarDispWrap(Blank, Blank,Err,errMsgLst[ y],Blank,datmapNmLst[y],Blank)); 
                    }
                    y++;
                }
                
                
            }
            list<docstarDispWrap> docstrwrpLstTotl=new list<docstarDispWrap>();
            
            for(docstarDispWrap docWrp:docstrwrpLst)
            {
                if(docWrp.status !=err)
                {
                    docstrwrpLstTotl.add(docWrp);
                }
            }
            
            if(docstrwrpLstTotl.size()>0)
            {
                return docstrwrpLstTotl; 
            }
            
            return docstrwrpLst;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeSrchDoc);
            throw new AuraHandledException(ErrMsg+excepSepartr+e.getMessage()); 
        }
        
    } 
    
    /**
@Description: wrapper class for displaying document records fetched from docstar 
@Name : docstarDispWrap
*/
    public class docstarDispWrap implements Comparable
    {
        @AuraEnabled
        public string filenme;
        @AuraEnabled
        public string itemid;
        @AuraEnabled
        public string status;
        @AuraEnabled
        public string errResp;
        @AuraEnabled
        public string errAddInfoResp;
        @AuraEnabled
        public string dataMapNme;
        @AuraEnabled
        public string itemType;
        @AuraEnabled
        public dateTime createdDteVal;
        @AuraEnabled
        public string imgRef;
        @AuraEnabled
        public string FilType;
        @AuraEnabled
        public string CidVal;
        @AuraEnabled
        public dateTime submittedDteVal;
        @AuraEnabled
        public string documentType;
         @AuraEnabled
        public string fileSize;
         @AuraEnabled
        public string hundredRecordMsg;
        
        
        /*Constructor*/
        public docstarDispWrap(string filenmeTmp,string itemidTmp,string statusTmp,string errRespTmp,string errAddInfoRespTmp,string dataMapNmeTmp,string hundredRecordMsgtmp)
        {
            filenme=filenmeTmp;
            itemid=itemidTmp;
            status=statusTmp;
            errResp=errRespTmp;
            errAddInfoResp=errAddInfoRespTmp;
            dataMapNme=dataMapNmeTmp;
            hundredRecordMsg = hundredRecordMsgtmp;
        }
        
        public Integer compareTo(Object objToCompare) {
            docstarDispWrap that = (docstarDispWrap)objToCompare;
            Integer returnValue = 0;
            
            if (this.createdDteVal < that.createdDteVal) { returnValue = 1;}
            if (this.createdDteVal > that.createdDteVal) {   returnValue = -1;}
            return returnValue;    
        }
        
    }
    
    /**
@Description: serializeReq() method 
@Name : serializeReq
@Param : String accCID
@Return : string
@throws Exception : NA;
*/
    private static string serializeReq(String accCID,string inpNm,string DataMpNm,string CntAttbt,
                                       datetime strtDate, datetime endDate){
                                           GA_SearchDocSTARParseJSON.cls_VersionInfo vrsnInfo=new GA_SearchDocSTARParseJSON.cls_VersionInfo();
                                           vrsnInfo.ServiceVersion=SrvcVrsn;
                                           vrsnInfo.SchemaVersion=SchmVrsn;
                                           
                                           GA_SearchDocSTARParseJSON.cls_Consumer consumr=new GA_SearchDocSTARParseJSON.cls_Consumer();
                                           consumr.ID=CosmrId;
                                           
                                           GA_SearchDocSTARParseJSON.cls_ReqHeaderArea Reqhdrarea=new GA_SearchDocSTARParseJSON.cls_ReqHeaderArea();
                                           Reqhdrarea.VersionInfo=vrsnInfo;
                                           Reqhdrarea.CreationDateTime=string.valueof(system.now());
                                           Reqhdrarea.MessageID=MsgIdSrchBnft;
                                           Reqhdrarea.Consumer=consumr;
                                           Reqhdrarea.systemEnvironmentCode=system.label.GA_systemEnvironmentCode;
                                           
                                           List<string> cidtLst=new list<string>();
                                           if (objectName == 'GA_HIST_WF_STEP__c'){
                                                   accCID = accCID.toUpperCase();
                                           }
                                           if(!string.isBlank(accCID))
                                               cidtLst.add(accCID);
                                           List<string> wfLst=new list<string>{'WORKFLOW'};
                                         
                                          // List< GA_SearchDocSTARParseJSON.cls_attributeValue> attrValLst = new List< GA_SearchDocSTARParseJSON.cls_attributeValue>();
                                           GA_SearchDocSTARParseJSON.cls_attributeValue attrVal = new GA_SearchDocSTARParseJSON.cls_attributeValue();
                                           attrVal.Name = inpNm;
                                           attrVal.Operator = Eqlto;  
                                           attrVal.Value = cidtLst; 
                                         //  attrValLst.add(attrVal);
                                           
                                         GA_SearchDocSTARParseJSON.cls_attributeValue attrVal1 = new GA_SearchDocSTARParseJSON.cls_attributeValue();
                                         if (objectName == WFHISOBJNM){
                                          attrVal1.Name = FILTYPS;
                                           attrVal1.Operator = Eqlto;  
                                           attrVal1.Value = wfLst; 
                                           //   attrValLst.add(attrVal1);
                                           }
                                           
                                           list<string> attrLgclValLst=new  list<string>();
                                           
                                           attrLgclValLst.add(string.valueof(strtDate.getTime()));
                                           attrLgclValLst.add(string.valueof(endDate.getTime()));
                                           GA_SearchDocSTARParseJSON.cls_AttributeValueWithLogical attrValLgcl = new GA_SearchDocSTARParseJSON.cls_AttributeValueWithLogical();
                                           if(DataMpNm == ASAPdataMapNm)
                                           {
                                               attrValLgcl.Name = 'submission_date';
                                           }
                                           else
                                           {
                                               attrValLgcl.Name = 'eff_date';
                                           }
                                           attrValLgcl.Operator = 'BETWEEN';  
                                           attrValLgcl.Value = attrLgclValLst; 
                                           attrValLgcl.LogicalOperator='AND';
                                           
                                           
                                           list<string> wfStpattrLgclValLst=new  list<string>();
                                           wfStpattrLgclValLst.add('WORKFLOW');
                                           
                                           GA_SearchDocSTARParseJSON.cls_AttributeValueWithLogical wfStpAttrValLgcl = new GA_SearchDocSTARParseJSON.cls_AttributeValueWithLogical();
                                           wfStpAttrValLgcl.Name = 'file_type';
                                           wfStpAttrValLgcl.Operator = 'EQUAL_TO';  
                                           wfStpAttrValLgcl.Value =wfStpattrLgclValLst ; 
                                           wfStpAttrValLgcl.LogicalOperator='AND';
                                           
                                           list<GA_SearchDocSTARParseJSON.cls_AttributeValueWithLogical> wfStpattrValLgclLst=new list<GA_SearchDocSTARParseJSON.cls_AttributeValueWithLogical>();
                                           wfStpattrValLgclLst.add(wfStpAttrValLgcl);
                                           
                                           list<GA_SearchDocSTARParseJSON.cls_AttributeValueWithLogical> attrValLgclLst=new list<GA_SearchDocSTARParseJSON.cls_AttributeValueWithLogical>();
                                           attrValLgclLst.add(attrValLgcl);
                                           
                                           GA_SearchDocSTARParseJSON.cls_SortOrder srchSortOrder = new GA_SearchDocSTARParseJSON.cls_SortOrder();
                                           system.debug('datamap:'+DataMpNm);
                                           if(DataMpNm == ASAPdataMapNm){
			                                 system.debug('asap');           
                                             srchSortOrder.AttributeName = 'submission_date'; 
                                           }
                                           else{
                                               system.debug('acct');  
                                              srchSortOrder.AttributeName = 'eff_date';
                                           }  
                                           srchSortOrder.SortOrder = 'DESCENDING';
                                           
                                           GA_SearchDocSTARParseJSON.cls_PayloadArea payloadarea=new GA_SearchDocSTARParseJSON.cls_PayloadArea();
                                           payloadarea.DataMapName=DataMpNm;     
                                           payloadarea.Id = PlodaraId; 
                                           payloadarea.Password = PlodaraPwd;
                                           payloadarea.AttributeValue = attrVal;//attrValLst;//
                                           payloadarea.SortBy= srchSortOrder;
                                           /**if (objectName == 'GA_HIST_WF_STEP__c'){
                                                   payloadarea.AttributeValue = attrVal1;
                                           }**/
                                           if(CntAttbt=='Y')
                                           {
                                               payloadarea.FilterContentAttributes=CntAttbt; // ASAP Files retrieval
                                               if(DataMpNm != ASAPdataMapNm){ 
                                                   payloadarea.AttributeValueWithLogical=attrValLgclLst;
                                               }
                                           }
                                           
                                           if (objectName == WFHISOBJNM){
                                               payloadarea.FilterContentAttributes=CntAttbt;  
                                               payloadarea.AttributeValueWithLogical=wfStpattrValLgclLst;
                                           }
                                           
                                           GA_SearchDocSTARParseJSON.cls_SearchDocSTAR searchDocSTAR = New GA_SearchDocSTARParseJSON.cls_SearchDocSTAR();
                                           searchDocSTAR.ReqHeaderArea=Reqhdrarea;
                                           searchDocSTAR.PayloadArea=payloadarea;   
                                           
                                           GA_SearchDocSTARParseJSON jsonReq=new GA_SearchDocSTARParseJSON(searchDocSTAR);
                                           string searchJsonReq=JSON.serialize(jsonReq);
                                           
                                           return searchJsonReq;
                                       }
    
    /**
@Description: fetchAccountDocument() method 
@Name : fetchAccountDocument
@Param : String documentName
@Return : String
@throws Exception : AuraHandledException;
*/
    @AuraEnabled
    public static String fetchAccountDocument(String docId, String documentName,string currentId,string DataMapNme) // added docId
    {
        try
        {
            
            HttpRequest req = new HttpRequest();      
            req.setEndpoint(ReTrvDocEndpoint);
            req.setMethod(ReqType);
            req.setTimeout(120000);
            
            String jsonRequest =  rtrvDocSerializeReq(docId,DataMapNme); // old val docId = documentName
            
            system.debug(jsonRequest);
            req.setbody(jsonRequest);         
            
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            Map<String,String> mimeFile = New Map<String,String> ();
            
            
            list<GA_Mimetype_FileExtension__mdt> mimFileLst=[select Id,GA_FileExtension__c,GA_MimeType__c from GA_Mimetype_FileExtension__mdt limit 50];
            for(GA_Mimetype_FileExtension__mdt File :mimFileLst)
            {
                mimeFile.put(File.GA_MimeType__c,File.GA_FileExtension__c);
                
            }
            
            system.debug(res.getBodyasBlob());
            
            String mimeType =  fetchMimeType(String.valueOf(res.getBody()),currentId,DataMapNme);
            system.debug('mimeType->'+mimeType);
            if(!string.isblank(mimeType))
            {
                String fileExtn = mimeFile.get(mimeType);
                // Start Adding Content Document 
                ContentVersion v = new ContentVersion();
                v.ContentLocation = 'S';
                v.PathOnClient = documentName+'.'+fileExtn;
                v.Title = documentName;
                v.VersionData = EncodingUtil.convertFromHex(fetchBinaryData(EncodingUtil.convertToHex(res.getBodyasBlob())));
                v.Description = 'TO BE DELETED BY BATCH';
                insert v;
				
                Id docId2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:v.Id].ContentDocumentId;
                //ContentWorkspace ws = [SELECT Id, RootContentFolderId FROM ContentWorkspace WHERE Name =: FoldrName  LIMIT 1];

				ContentDocumentLink cDocLink = new ContentDocumentLink();
                cDocLink.ContentDocumentId = docId2;
                cDocLink.LinkedEntityId = currentId;
                cDocLink.ShareType = 'I';
                cDocLink.Visibility = 'AllUsers';
                Insert cDocLink;

                String docLink = URL.getSalesforceBaseUrl().toExternalForm() +'/sfc/servlet.shepherd/document/download/' + cDocLink.ContentDocumentId + '?operationContext=S1';
                //String docLink = cDocLink.ContentDocumentId;
                return docLink;
                // End of Content Document
                
                /*id fldrid=[SELECT Id, Name FROM Folder where name=:foldrName limit 1].id;
                Document d = new Document(); 
                d.Name = documentName; 
                d.folderid=fldrid; //Shared folder document folder
                d.Body = EncodingUtil.convertFromHex(fetchBinaryData(EncodingUtil.convertToHex(res.getBodyasBlob())));
                d.ContentType = mimeType;// Fetching the Mime Type from repsonse but what could be the Type   
                d.Type = (fileExtn == null ? DocExt : fileExtn);
                
                insert d;  
                String docId = d.Id;
                return docId;*/
            }
            else
            {
                return Blank;
            }
            
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeRtrvDoc);
            throw new AuraHandledException(ErrMsg+excepSepartr+e.getMessage());             
        }
        
    }
    
    /**
@Description: rtrvDocSerializeReq() method 
@Name : rtrvDocSerializeReq
@Param : String docName
@Return : string
@throws Exception : NA;
*/
    private  static string rtrvDocSerializeReq(String docName,string DataMapNme){
        GA_RtrvDocSTARJSONParser.cls_VersionInfo vrsnInfo=new GA_RtrvDocSTARJSONParser.cls_VersionInfo();
        vrsnInfo.ServiceVersion=SrvcVrsn;
        vrsnInfo.SchemaVersion=SchmVrsn;
        
        GA_RtrvDocSTARJSONParser.cls_Consumer consumr=new GA_RtrvDocSTARJSONParser.cls_Consumer();
        consumr.ID=CosmrId;
        
        
        GA_RtrvDocSTARJSONParser.cls_ReqHeaderArea Reqhdrarea=new GA_RtrvDocSTARJSONParser.cls_ReqHeaderArea();
        Reqhdrarea.VersionInfo=vrsnInfo;
        Reqhdrarea.CreationDateTime=string.valueof(system.now());//'2017-04-28T11:44:25.145';
        Reqhdrarea.MessageID=MsgIdRetrv;
        Reqhdrarea.Consumer=consumr;
        Reqhdrarea.systemEnvironmentCode=system.label.GA_systemEnvironmentCode;
        
        
        GA_RtrvDocSTARJSONParser.cls_attributeValue attrVal = new GA_RtrvDocSTARJSONParser.cls_attributeValue();
        attrVal.Name = Itmid;
        attrVal.Value = docName; 
        
        List<GA_RtrvDocSTARJSONParser.cls_attributeValue > attrList = New List<GA_RtrvDocSTARJSONParser.cls_attributeValue >();
        attrList.add(attrVal);
        
        GA_RtrvDocSTARJSONParser.cls_PayloadArea payloadarea=new GA_RtrvDocSTARJSONParser.cls_PayloadArea();
        payloadarea.DataMapName=DataMapNme;//Dtmapnm;     
        payloadarea.Id = PlodaraId; 
        payloadarea.Password = PlodaraPwd;
        payloadarea.Attribute = attrList;
        
        GA_RtrvDocSTARJSONParser.cls_RtrvDocSTAR rtrvDocSTAR = New GA_RtrvDocSTARJSONParser.cls_RtrvDocSTAR();
        rtrvDocSTAR.ReqHeaderArea=Reqhdrarea;
        rtrvDocSTAR.PayloadArea=payloadarea;   
        
        GA_RtrvDocSTARJSONParser jsonReq=new GA_RtrvDocSTARJSONParser(rtrvDocSTAR);
        string rtrvJsonReq=JSON.serialize(jsonReq);
        
        return rtrvJsonReq;
    }
    
    /**
@Description: fetchMimeType() method 
@Name : fetchMimeType
@Param : String resp
@Return : string
@throws Exception : NA;
*/
    private static String fetchMimeType(String resp,string accountIdVal,string DataMapNme){
        GA_DocStar_DataMap_Info__mdt docStrInfo=[select GA_JSON_End_String__c,GA_JSON_End_Length__c from GA_DocStar_DataMap_Info__mdt where Label=:DataMapNme limit 1];
        String mimType;
        String serviceResponse ;
        String SerResDescription;
        string SerResAddInfo;
        
        //system.debug(resp);
        integer StartJson = resp.indexOf(RetrivDocMimtypFetch1);
        integer endJson;
        
        /* if(DataMapNme==Dtmapnm)
endJson = resp.indexOf(RetrivDocMimtypFetch2) + 28;
if(DataMapNme=='SFGRPCRM_CM_DocuSignDocs')
endJson = resp.indexOf(RetrivDocMimtypFetch3) + 32;
if(DataMapNme=='SFGRPCRM_CM_ASAP_ALL')
endJson = resp.indexOf(RetrivDocMimtypFetch4)+8;*/
        endJson= resp.indexOf(docStrInfo.GA_JSON_End_String__c)+integer.valueof(docStrInfo.GA_JSON_End_Length__c);
        integer endfile = resp.length();
        
        String jsonString = resp.substring(StartJson, endJson); 
        system.debug('resp->'+resp);
        system.debug('jsonString->'+jsonString);
        JSONParser  parser = JSON.createParser(jsonString);
        while (parser.nextToken() != null) { 
            integer Counter = 0;
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){   
                Counter++;
                String fieldName = parser.getText();
                parser.nextToken();
                String fieldValue=parser.getText();
                if(fieldName == Name && fieldValue==Mimty) {                        
                    parser.nextToken();
                    if(parser.getText()==Val){
                        parser.nextToken();
                        mimType= parser.getText();
                    }
                }
                if(fieldName == CodeVal) {                        
                    
                    serviceResponse = parser.getText();
                }
                if(fieldName == Descption) {                        
                    
                    SerResDescription = parser.getText();
                }
                if(fieldName == addInfo) {                        
                    
                    SerResAddInfo = parser.getText();
                }
                
            }
            
        }
        
        system.debug(serviceResponse);
        
        if(serviceResponse != SuccssCode)
        {
            string RespVal=(String.Valueof(resp).length() > 131072) ? String.Valueof(resp).substring(0, 131072):(String.Valueof(resp) );
                GA_logBCBSMWSException.logWSError(new Map<String,String>{accountIdVal => serviceResponse+Hyphen+SerResDescription},system.Label.GA_DocSTARService,system.Label.GA_Action,RespVal);                      
            return Blank;
        }
        else
        {
            return mimType;  
        }
        
    }
    
    /**
@Description: fetchBinaryData() method 
@Name : fetchBinaryData
@Param : String resp
@Return : string
@throws Exception : NA;
*/
    private static String fetchBinaryData(String resp){
        
        String binaryData ;
        
        integer strtBinData = resp.indexOf(RetriveBlob1,resp.indexOf(RetriveBlob1) + 1)+10;
        integer endBinData = resp.lastindexOf(RetriveBlob2,resp.lastindexOf(RetriveBlob2) - 1)-4;
        
        binaryData = resp.substring(strtBinData, endBinData);
        return binaryData;
        
    }
}