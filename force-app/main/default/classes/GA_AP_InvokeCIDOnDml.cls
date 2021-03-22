/*****************************************************************************************
Class Name   : GA_AP_InvokeCIDOnDml
Date Created : 01/10/2017
Created By   : IDC Offshore
Description  : 1. This is the helper class for getting CID/SMart ID from external system and updating the same in Account record.
******************************************************************************************/
public with sharing class GA_AP_InvokeCIDOnDml {
    public static boolean recrCheck = true;
    public static  Map<string,string> respMap=New Map<string,string>();
    public static final String ClsName  ='GA_AP_InvokeCIDOnDml';
    public static final String methodNmefetchCID ='fetchCIDServiceResponses';
    public static final String methodNmecallCIDServ ='callBCBSMCIDServ';
    //public static final String CIDEndpoint='callout:Smart_Service/Sales/GrpCustMgmt/1.0';
    public static final string CIDEndpoint=system.label.GA_NewCIDEndpoint;
    public static final String reqType='POST';
    public static final String CustVal='cid';
    public static final String SysUnqVal='SystemUniqueID';
    public static final String CodeVal='code';
    public static final String SysUnqKey='SMARTIDVal';
    public static final String AddInfoKey='Descrption';
    public static final String CustKey='CIDVal';
    public static final String AddInfoVal='AdditionalInfo';
    public static final String SuccessCode='S0000';
    public static final String updtFail='Failure';
    public static final String updtSuccss='Success - CID received';
    public static final String SuccssVal='Success';
    public static final String hyphenVal='-';
    public static final string SmartIdPreFx  ='CO_';
        /**
@Description: fetchCIDServiceResponses() method 
@Name : fetchCIDServiceResponses
@Param : Map<Id,Account> accList
@Return : map<string,string>
@throws Exception : NA;
*/
    Public static map<string,string> fetchCIDServiceResponses(Map<Id,Account> accList)
    {
        try{
            
            integer i=0;
            string prspctRecTpId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.GA_ProspectRecType).getRecordTypeId();
            
            list<account> accLst= New List<Account>(); 
            for(Account acc :  accList.values()){
                if(  String.isBlank(acc.CID__c) && acc.RecordTypeId == prspctRecTpId ){
                    accLst.add(acc);
                }
            }

            integer accSize = accLst.size();
            List<Id> removeAccListId = New List<Id>();
                        
            if(accLst.size() > 0){
                callBCBSMCIDServ(accLst[0].Id);
            }
            return  respMap;
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmefetchCID);
            return null;
        }
    } 
    
          /**
@Description: callBCBSMCIDServ() method 
@Name : callBCBSMCIDServ
@Param : Id  accCID
@Return : void
@throws Exception : NA;
*/  
    @future(callout=true)
    public static void callBCBSMCIDServ(Id  accCID){
        
        try{
            string CIDVal;
            string SMARTIDVal;
            string Descrption;
            string Code;
            Account acc = [select id,ShippingStateCode, CID__c,GA_SMART_ID__c,Name,Federal_Tax_ID__c,GA_Territory__r.GA_TerritoryCode__c,phone,ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,ShippingCountry,GA_Physical_County_Id__r.name from account where id=:accCID limit 1];
            
            string ReqBody=GA_AP_CIDServiceCls.serializeReq(acc);
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(CIDEndpoint);
            req.setHeader('content-type', 'application/json');
            req.setHeader('client_id', system.label.GA_ClientId);
            req.setHeader('client_secret', system.label.GA_ClientSecret); 
            req.setMethod(reqType);
            req.setTimeout(120000);
            req.setbody(ReqBody);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == CustVal || parser.getText() ==CodeVal || parser.getText() ==AddInfoVal)) {
                        if(parser.getText() ==CodeVal)
                        {
                            parser.nextToken();
                            Code=parser.getText();
                            
                        }
                        if(parser.getText() ==AddInfoVal)
                        {
                            parser.nextToken();
                            Descrption=parser.getText();
                            
                        }
                        if(parser.getText() == CustVal)
                        {
                            parser.nextToken();
                            CIDVal = parser.getText();
                            respMap.put(CustKey, CIDVal);
                        }
                        
                        //if(parser.getText() == SysUnqVal)
                        //{
                        //    parser.nextToken();
                        //    SMARTIDVal= parser.getText();
                        //    respMap.put(SysUnqKey, SMARTIDVal);
                        //}
                        
                    }
            }
            
            if(Code!=SuccessCode){
                string Resp=(String.Valueof(res.getBody()).length() > 131072) ? String.Valueof(res.getBody()).substring(0, 131072):(String.Valueof(res.getBody()));
                GA_logBCBSMWSException.updatelogWSError(String.valueof(acc.id),updtFail,Code,Descrption,system.Label.GA_CIDService,system.Label.GA_Trigger,Resp);
              
            }
            else{
                respMap.put(String.valueof(acc.id),updtSuccss);
                acc.CID__c=CIDVal;
                //if(string.isblank(acc.GA_SMART_ID__c))
                //{
                //   acc.GA_SMART_ID__c=SmartIdPreFx+SMARTIDVal;
                //}
                acc.GA_External_ID__c=CIDVal;                
                database.update(acc,true);  
                /*** removed for US-2585 **/
                //string Resp=(String.Valueof(res.getBody()).length() > 131072) ? String.Valueof(res.getBody()).substring(0, 131072):(String.Valueof(res.getBody()));
                //GA_logBCBSMWSException.updatelogWSError(String.valueof(acc.id),SuccssVal,Code,Descrption,system.Label.GA_CIDService,system.Label.GA_Trigger,Resp);
            }
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmecallCIDServ+hyphenVal+accCID);
        }
    }
}