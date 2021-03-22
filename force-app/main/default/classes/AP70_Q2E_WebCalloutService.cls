/**
 * @File Name          : AP70_Q2E_WebCalloutService.cls
 * @Description        : Generalized Webservice Callout.
 * @Author             : amitchell
 * @Group              : Salesforce Professional Services
 * @Last Modified By    : amitchell
 * @Last Modified On    : 2/20/2020
 * @Modification Log    : 
 * Ver       Date            Author                 Modification
 * 1.0      2/20/2020       amitchell              Initial Version
**/ 


public abstract class AP70_Q2E_WebCalloutService {

    public static final integer DEFAULT_TIMEOUT = 120000;

    public static HttpResponse sendRequest(string endPoint, string methodName, Map<string, string> msgHeader, string msgBody, string inboundClassName) {

        Http h = new Http();
        HttpRequest req = new Httprequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint(endPoint);
        req.setMethod(methodName);
        req.setTimeout(DEFAULT_TIMEOUT);

        if (!string.isBlank(msgBody)) {
            req.setBody(msgBody);
        }
        else {
            req.setHeader('Content-length', '0');
        }

        // message header key value pair
        if(msgHeader != null){
            for (string headerKey : msgHeader.keySet()) {
                string headerValue = msgHeader.get(headerKey);
                req.setHeader(headerKey, headerValue);
            }
        }
        try {
            System.debug(req);
            System.debug(req.getBody());
            res = h.send(req);
            
            if (res.getStatusCode() != 200 || res.getStatusCode() != 201) {
                System.debug(res.getStatusCode());
                System.debug(res.getBody());
               /*
                UTIL_LoggingService.logHandledException(null,  //Exception
                                                    UserInfo.getOrganizationId(), //Org Id
                                                    UtilConstants.BCSBIBU, // Application Name
                                                    inboundClassName, // Class
                                                    'sendRequest', // Method
                                                    UtilConstants.BlankString, // Trigger
                                                    Logginglevel.ERROR // Error Level
                                                    );   
                */
            }
        
        } catch (Exception ex) {
            System.debug(ex);
            /*
            UTIL_LoggingService.logHandledException(ex,  //Exception
                                                    UserInfo.getOrganizationId(), //Org Id
                                                    UtilConstants.BCSBIBU, // Application Name
                                                    'AP70_Q2E_WebCalloutService', // Class
                                                    'sendRequest', // Method
                                                    UtilConstants.BlankString, // Trigger
                                                    Logginglevel.ERROR // Error Level
                                                    );   
            */

        }
     
        return res;

    }
}