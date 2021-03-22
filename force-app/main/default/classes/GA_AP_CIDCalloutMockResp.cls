/*****************************************************************************************
Class Name   : GA_AP_CIDCalloutMockResp
Date Created : 01/21/2018
Created By   : IDC Offshore
Description  : This is the test class mock class for CID service callout.
******************************************************************************************/
@isTest(seealldata=false)
global without sharing class GA_AP_CIDCalloutMockResp implements HttpCalloutMock {
    private static string ReqBody;     
    private static string respCode;
    private static final String CNTTYP = 'content-type';
    private static final String reqType = 'POST';    
    private static final String APPJSON ='application/json';
    private static final String CLIENT ='client_id';
    private static final String CLNTKY =system.label.GA_ClientId;
    private static final String SCRTID ='client_secret';
    private static final String SCRTKY =system.label.GA_ClientSecret;
    private static final String RESPS = '{"headerArea": { "systemEnvironmentCode": "QA", "messageId": "0d99ded0-687d-11ea-af01-0e34c8da2609", "systemMessage": [ { "code": "S0000", "source": "Group Salesforce", "additionalInfo": "SuccessFully inserted record into Salesforce" } ] }, "payloadArea": { "cid": "600396" } }';
    /**
@Description: GA_AP_CIDCalloutMockResp() method 
@Name : GA_AP_CIDCalloutMockResp
@Param : string codeVal
@Return : NA
@throws Exception : NA;
*/  
    public GA_AP_CIDCalloutMockResp(string cidResp)
    { 
        ReqBody=cidResp;
         
        //respCode=codeVal;
        //system.assert(userinfo.getUserId() <> null,true);
        
    }
    
    /**
@Description: respond() method 
@Name : respond
@Param : HTTPRequest req
@Return : HTTPResponse
@throws Exception : NA;
*/
    global HTTPResponse respond(HTTPRequest req) {       
        req.setEndpoint('https://webservicesqa.bcbsm.com/REST/SalesForce/PushAPI/Sales/GrpCustMgmt/generateCID/1.0');
        req.setMethod('POST');
        req.setHeader(CNTTYP, APPJSON);
        req.setHeader(CLIENT, CLNTKY);
        req.setHeader(SCRTID, SCRTKY);
        system.debug('mock call');
        //resp.setBody(RESPS.replace('respCode', respCode));
        HTTPResponse resp=new HTTPResponse(); 
        resp.setBody(RESPS);
        resp.setStatusCode(200);        
        system.assert(resp <> null , true);
        return resp;
    }
}