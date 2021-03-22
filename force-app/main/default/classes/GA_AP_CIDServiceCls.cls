/*****************************************************************************************
Class Name   : GA_AP_CIDServiceCls
Date Created : 01/10/2017
Created By   : IDC Offshore
Description  : 1. This is the class for getting CID/SMart ID from external system and updating the same in Account record.
******************************************************************************************/
public with sharing class GA_AP_CIDServiceCls {
    
    public static final string ErrMsg = system.label.GA_CIDErrMsg;
    public static final string accProsRecTyp=system.label.GA_ProspectRecType;
    public static final string Blank='';
    //public static final string CIDEndpoint=system.label.GA_CIDEndpoint;
    public static final string CIDEndpoint=system.label.GA_NewCIDEndpoint;
    public static final string reqType=system.label.GA_Method_ReqType;
    public static final string CustVal='cid';
    public static final string SysUnqVal='SystemUniqueID';
    public static final string CodeVal=system.label.GA_CodeVal;
    public static final string SysUnqKey='SMARTIDVal';
    public static final string AddInfoKey=system.label.GA_Description;
    public static final string CustKey='CIDVal';
    public static final string AddInfoVal=system.label.GA_AdditionalInfo;
    public static final string SuccessCode=system.label.GA_SuccssCode;
    public static final string updateKey='Update';
    public static final string updateValTrue='true';
    public static final string updateValfalse='false';
    public static final string reqfieldErr=system.label.GA_ReqfieldErr;
    public static final string CIDExisMssg=system.label.GA_CIDExisMssg;
    public static final string NoPermMssg=system.label.GA_CIDNoPermMssg;
    public static final string ServiceVersionVal=system.label.GA_Service_Version;
    public static final string SchemaVersionVal=system.label.GA_Schema_Version;
    public static final string CusnmrId=system.label.GA_ConsumerId;
    public static final string MessageIDVal='CID SFDC Request';
    public static final string ForceNewCIDCreationVal='Y';
    public static final string phnKey='phnNumber';
    public static final string phnVal='number';
    public static final string excepSepartr=': ';
    public static final map<string,string> respMap=new map<string,string>();
    public static  Map<string,string> errRespMap=New Map<string,string>();  
    public static  String reqField;
    public static final GA_CID_Service_ByPass__c profBypass = GA_CID_Service_ByPass__c.getInstance();
    public static final string updtSuccss='CID received';
    public static final string ClsName  ='GA_AP_CIDServiceCls';
    public static final string methodNmeGetCIDVl  ='getcidVal';
    public static final string methodNme  ='serializeReq';
    public static final string SmartIdPreFx  ='CO_';
    

/**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
    /**
@Description: getcidVal() method 
@Name : getcidVal
@Param : id currentId
@Return : map<string,string>
@throws Exception : AuraHandledException;
*/
    @AuraEnabled
    public static map<string,string> getcidVal(id currentId)
    {
        try
        {
            
            if(profBypass.GA_By_Pass__c)
            {
                string prspctRecTpId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(accProsRecTyp).getRecordTypeId();
                list<account> accLst=[select id,ShippingStateCode,GA_External_ID__c,CID__c,GA_SMART_ID__c,Name,Federal_Tax_ID__c,GA_Territory__r.GA_TerritoryCode__c,phone,ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,ShippingCountry,GA_Physical_County_Id__r.name from account where id=:currentId and CID__c =:Blank and recordtypeid=:prspctRecTpId limit 1];
                
                if(accLst.size()>0)
                {
                    
                    Account acc=accLst[0];
                    boolean reqfld=false;
                    
                    for(GA_CID_Service_Required_Field__mdt CidReqFld: [select label,DeveloperName,GA_Field_Name__c from GA_CID_Service_Required_Field__mdt limit 50])
                    {
                        if(string.isblank(((String)acc.get(CidReqFld.GA_Field_Name__c))))
                        {
                            reqfld=true;
                            reqField = CidReqFld.label ;
                            break;
                        }
                        
                    }
                    if(!reqfld)
                    {
                        string ReqBody=serializeReq(acc);
                        HttpRequest req = new HttpRequest();
                        req.setEndpoint(CIDEndpoint);
                        req.setHeader('content-type', 'application/json');
                        req.setHeader('client_id', system.label.GA_ClientId);
                        req.setHeader('client_secret', system.label.GA_ClientSecret); 
                        req.setMethod(reqType);
                        req.setTimeout(120000);
                        req.setbody(ReqBody);
                        system.debug('RequestBody-->'+ReqBody);
                        system.debug('Request-->'+req);
                        Http http = new Http();
                        HTTPResponse res = http.send(req);
                        system.debug('Response-->'+res);
                        string CIDVal;
                        string SMARTIDVal;
                        string Descrption;
                        string Code;
                        JSONParser parser = JSON.createParser(res.getBody());
                        while (parser.nextToken() != null) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                                (parser.getText() == CustVal || parser.getText() ==CodeVal || parser.getText() ==AddInfoVal)) {
                                    if(parser.getText() ==CodeVal)
                                    {
                                        parser.nextToken();
                                        Code=parser.getText();
                                        respMap.put(CodeVal, Code);
                                    }
                                    if(parser.getText() ==AddInfoVal)
                                    {
                                        parser.nextToken();
                                        Descrption=parser.getText();
                                        respMap.put(AddInfoKey, Descrption);
                                    }
                                    if(parser.getText() == CustVal)
                                    {
                                        parser.nextToken();
                                        CIDVal = parser.getText();
                                        respMap.put(CustKey, CIDVal);
                                    }                                   
                                    
                                }
                            
                        }
                        
                        if(string.isblank(acc.CID__c) && Code ==SuccessCode)
                        {
                            acc.CID__c=CIDVal;
                            
                           
                            acc.GA_External_ID__c=CIDVal;
                            
                            /*** removed for US-2585 **/
                            //errRespMap.put(String.valueof(acc.id),Code+System.label.Hyphen+updtSuccss);
                            database.update(acc,true);  
                        }
                        else{
                            errRespMap.put(String.valueof(acc.id),Code+System.label.Hyphen+Descrption);
                        }
                        respMap.put(updateKey, updateValTrue);
                        if(errRespMap.size() > 0 ){
                            string Resp=(String.Valueof(res.getBody()).length() > 131072) ? String.Valueof(res.getBody()).substring(0, 131072):(String.Valueof(res.getBody()) );
                                GA_logBCBSMWSException.logWSError(errRespMap,system.Label.GA_CIDService,system.Label.GA_Action,Resp);
                        }
                        
                        return respMap;  
                    }
                    else
                    {
                        respMap.put(updateKey, updateValfalse);
                        respMap.put(AddInfoKey, reqfieldErr+reqField);
                        return respMap; 
                    }
                    
                }
                else
                {
                    respMap.put(updateKey, updateValfalse);
                    respMap.put(AddInfoKey, CIDExisMssg);
                    return respMap;
                }
            }
            else
            {
                respMap.put(updateKey, updateValfalse);
                respMap.put(AddInfoKey, NoPermMssg);
                return respMap;
            }
            
            
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            system.debug('detail-->'+e);
            throw new AuraHandledException(ErrMsg+excepSepartr+e.getMessage()); 
        }
    }
    
    /**
@Description: serializeReq() method 
@Name : serializeReq
@Param : account accRec
@Return : string
@throws Exception : NA
*/
    public static string serializeReq(account accRec)
    {
        try
        {
                       
            GA_AP_CIDParseJSON.cls_ReqHeaderArea Reqhdrarea=new GA_AP_CIDParseJSON.cls_ReqHeaderArea();
            
            Reqhdrarea.messageId=MessageIDVal;
            Reqhdrarea.systemEnvironmentCode=system.label.GA_systemEnvironmentCode;
            			            
            GA_AP_CIDParseJSON.cls_Phone phn=new GA_AP_CIDParseJSON.cls_Phone();            
		   
            String tmpPhone = (String.Valueof(accRec.Phone).length() > 25) ? String.Valueof(accRec.Phone).substring(0, 25):(String.Valueof(accRec.Phone) );
			String phnNbr=  tmpPhone.replaceAll( '\\D', '');             
			if (phnNbr.length() != null)
			{
				phn.areaCode = phnNbr.left(3);
				phn.exchange = phnNbr.mid(3,3);
				phn.phnNumber = phnNbr.right(4);
			}
            SYSTEM.DEBUG('phn:'+phn);	
            			
			List<string> streetLst=new list<string>();
            if(!string.isBlank(accRec.ShippingStreet))
                streetLst.add((String.Valueof(accRec.ShippingStreet).length() > 40) ? String.Valueof(accRec.ShippingStreet).substring(0, 40):(String.Valueof(accRec.ShippingStreet) ));       
            
            
            GA_AP_CIDParseJSON.cls_PhysicalAddress physclAddrss=new GA_AP_CIDParseJSON.cls_PhysicalAddress();
            physclAddrss.street1=((String.Valueof(accRec.ShippingStreet) ));
            physclAddrss.street2='';
            physclAddrss.city=(String.Valueof(accRec.ShippingCity).length() > 40) ? String.Valueof(accRec.ShippingCity).substring(0, 40):(String.Valueof(accRec.ShippingCity) );             
            physclAddrss.zip=(String.Valueof(accRec.ShippingPostalCode).length() > 10) ? String.Valueof(accRec.ShippingPostalCode).substring(0, 10):(String.Valueof(accRec.ShippingPostalCode) ); 
        	if(accRec.GA_Physical_County_Id__r != NULL && accRec.GA_Physical_County_Id__r.name != NULL)
            	physclAddrss.county=(String.Valueof(accRec.GA_Physical_County_Id__r.name).length() > 10) ? String.Valueof(accRec.GA_Physical_County_Id__r.name).substring(0, 10):(String.Valueof(accRec.GA_Physical_County_Id__r.name));    
                        
            SYSTEM.DEBUG('Physical County'+physclAddrss.county);
            GA_AP_CIDParseJSON.cls_PayloadArea payldareararea=new GA_AP_CIDParseJSON.cls_PayloadArea();
			payldareararea.companyName=(String.Valueof(accRec.Name).length() > 100) ? String.Valueof(accRec.Name).substring(0, 100):(String.Valueof(accRec.Name) );
			payldareararea.dunsNumber = '';
            payldareararea.federalTaxId=(String.Valueof(accRec.Federal_Tax_ID__c).length() > 9) ? String.Valueof(accRec.Federal_Tax_ID__c).substring(0, 9):(String.Valueof(accRec.Federal_Tax_ID__c) ); 
			payldareararea.phone=phn;                         
			payldareararea.physicalAddress=physclAddrss;  
            if(accRec.GA_Territory__r != NULL && accRec.GA_Territory__r.GA_TerritoryCode__c != NULL)
	            payldareararea.territoryCode=(String.Valueof(accRec.GA_Territory__r.GA_TerritoryCode__c).length() > 2) ? String.Valueof(accRec.GA_Territory__r.GA_TerritoryCode__c).substring(0, 2):(String.Valueof(accRec.GA_Territory__r.GA_TerritoryCode__c) );
            payldareararea.sourceChannel=system.label.GA_Source_Channel;
            
            GA_AP_CIDParseJSON.cls_CreateGroupCustRequest crteRst=new GA_AP_CIDParseJSON.cls_CreateGroupCustRequest();
            //crteRst.PayloadArea=payldareararea;
            crteRst.headerArea=Reqhdrarea;
            crteRst.payloadArea=payldareararea;
            system.debug('crteRst:'+crteRst);
            
             GA_AP_CIDParseJSON jsonCrt=new GA_AP_CIDParseJSON(Reqhdrarea,payldareararea);
             string JSONStrng=JSON.serialize(jsonCrt);            
            JSONStrng=JSONStrng.replace(phnKey, phnVal);
            system.debug('JSONStrng:'+JSONStrng);
            return JSONStrng;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeGetCIDVl);
            throw new ValidateException(ErrMsg,e); 
        }
        
    }
	
}