/**
@Author : IDC Offshore
@Name: GA_AP_InvokeCIServOnBatch 
@CreatedDate: 15-Jan-2018 
@Description: GA_AP_InvokeCIServOnBatch class to update CID in account for failed accounts 
@version : 1.0  
*/
public with sharing class GA_AP_InvokeCIServOnBatch {
    
    public static  Map<string,string> respMap=New Map<string,string>();  
    public static List<Account> updtCIDonAccList = New List<Account>();
    public static final String ClsName  ='GA_AP_InvokeCIServOnBatch';
    public static final String methodNmefetchCID ='fetchCIDServiceResponses';
    public static final String methodNmecallCIDServ ='callBCBSMCIDServ';
    public static final string CIDEndpoint='callout:Smart_Service/Sales/GrpCustMgmt/1.0';
    public static final string reqType='POST';
    public static final string CustVal='CustomerID';
    public static final string SysUnqVal='SystemUniqueID';
    public static final string CodeVal='Code';
    public static final string SysUnqKey='SMARTIDVal';
    public static final string AddInfoKey='Descrption';
    public static final string CustKey='CIDVal';
    public static final string AddInfoVal='AdditionalInfo';
    public static final string SuccessCode='S0000';
    public static final string updtSuccss='CID received';
    public static final string hyphenVal='-';
    public static final string SFDCInternalError='Internal Error-SFDC Internal Error';
    public static string RespVal;
    public static final string SmartIdPreFx  ='CO_';
/**
@Description: fetchCIDServiceResponses() method 
@Name : fetchCIDServiceResponses
@Param : Map<Id,Account> accList
@Return : void
@throws Exception : N/A;
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
            Map<String,String> reqFieldLabelName = New Map<String,String> ();
            
            //list<GA_CID_Service_Required_Field__mdt> CidReqFldLst=[select label,DeveloperName,GA_Field_Name__c from GA_CID_Service_Required_Field__mdt limit 50];
            for(GA_CID_Service_Required_Field__mdt CidReqFld:[select label,DeveloperName,GA_Field_Name__c from GA_CID_Service_Required_Field__mdt limit 50])
            {
                reqFieldLabelName.put(CidReqFld.GA_Field_Name__c,CidReqFld.label);
                
            }
            
            integer accSize = accLst.size();
            List<Id> removeAccListId = New List<Id>();
            if(accLst.size() > 0){
                for(Account acc : accLst){
                    callBCBSMCIDServ(acc);
                }
            }
            if(updtCIDonAccList.size()>0)
            {
                Database.SaveResult[] srList = Database.update(updtCIDonAccList,false);
                set<string> successAccIds=new set<string>();
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        successAccIds.add(sr.getId());
                    }
                }
                for(string respKey:respMap.keyset())
                {
                    if(!successAccIds.contains(respKey))
                    {
                        respMap.put(respKey,SFDCInternalError);
                    }
                }
            }
            
            if(respMap.size() > 0) {
                string Resp=(String.Valueof(RespVal).length() > 131072) ? String.Valueof(RespVal).substring(0, 131072):(String.Valueof(RespVal) );
                GA_logBCBSMWSException.logWSError(respMap,system.Label.GA_CIDService,system.Label.GA_Trigger,Resp);
            }
            return  respMap;
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmefetchCID);
            return null;
            
        }
    } 
/**
@Description: callBCBSMCIDServ() method 
@Name : callBCBSMCIDServ
@Param : account  acc
@Return : void
@throws Exception : N/A;
*/    
    public static void callBCBSMCIDServ(account  acc){
        
        try{
                            
            string CIDVal;
            string SMARTIDVal;
            string Descrption;
            string Code; 
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
            RespVal=res.getBody();
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == CustVal || parser.getText() ==SysUnqVal || parser.getText() ==CodeVal || parser.getText() ==AddInfoVal)) {
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
                        }                                                                  
                    }
            }
            if(Code!=SuccessCode){
                
                respMap.put(String.valueof(acc.id),Code+hyphenVal+Descrption);
            }
            else{
                respMap.put(String.valueof(acc.id),Code+hyphenVal+updtSuccss);
                acc.CID__c=CIDVal;
                
                if(string.isblank(acc.GA_SMART_ID__c))
                {
                    acc.GA_SMART_ID__c=SmartIdPreFx+SMARTIDVal;
                }
                acc.GA_External_ID__c=CIDVal;
                updtCIDonAccList.add(acc);
                
            }

        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmecallCIDServ);
        }
        
    }
}