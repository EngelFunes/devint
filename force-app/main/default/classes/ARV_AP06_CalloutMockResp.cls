/*****************************************************************************************
Class Name   : ARV_AP06_CalloutMockResp 
Date Created : 3-MAY-2019
Created By   : IDC Offshore
Description  : This class is used for HttpCalloutMock
******************************************************************************************/
global without sharing class ARV_AP06_CalloutMockResp implements HttpCalloutMock{
        private  string reqBody;
        private static final  string CONTENTTYPE='Content-Type';
        private static final  string APPLICATIONTYPE='application/json';
    
        /**************  
        Method name : ARV_AP05_CalloutMockResp
        Params     :reqstBody
        Return Type :NA
        Description :ARV_AP06_CalloutMockResp class
        *************/    
        public ARV_AP06_CalloutMockResp(string reqstBody)
        {
            reqBody=reqstBody;
        } 
       /**************  
        Method name : respond
        Params     :req
        Return Type :HTTPResponse
        Description :respond() Method
        *************/  
        global HTTPResponse respond(HTTPRequest req) {
              HTTPResponse resp=new HTTPResponse();
                resp.setHeader(CONTENTTYPE, APPLICATIONTYPE);
                resp.setBody(ReqBody);
                resp.setStatusCode(200);
                return resp;
       }
}