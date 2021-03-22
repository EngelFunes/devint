/*****************************************************************************************
Class Name   : GA_AP_CalloutMockResp
Date Created : 2/7/2018
Created By   : IDC Offshore
Description  : This is the test class mock class for DocStar Service.
******************************************************************************************/
@isTest
global class GA_AP_CalloutMockResp implements HttpCalloutMock{
    private static string ReqBody;
    
    /**
@Description: GA_AP_CalloutMockResp() method 
@Name : GA_AP_CalloutMockResp
@Param : string reqstBody
@Return : NA
@throws Exception : NA;
*/  
    public GA_AP_CalloutMockResp(string reqstBody)
    {
       
            ReqBody=reqstBody;
       
    }
    
    /**
@Description: respond() method 
@Name : respond
@Param : HTTPRequest req
@Return : HTTPResponse
@throws Exception : NA;
*/
    global HTTPResponse respond(HTTPRequest req) {
       
            HTTPResponse resp=new HTTPResponse();
            resp.setHeader('Content-Type', 'application/json');
            resp.setBody(ReqBody);
            resp.setStatusCode(200);
            return resp;
      
    }
}