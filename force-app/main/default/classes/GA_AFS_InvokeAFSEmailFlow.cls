/**
@Author : Padmahaarika Jayana
@Name: GA_AFS_InvokeAFSEmailFlow 
@CreatedDate: 24- Jul 2017 
@Description: GA_AFS_InvokeAFSEmailFlow class is to send Fact sheet 
@version : 1.0  Code Coverage: None
API Version:

40

Go To

public Id afsId {get;set;}

*/
public with sharing class  GA_AFS_InvokeAFSEmailFlow {
    
    
    /**
@Description: ValidateException
@Name : ValidateException
@Param : none
@Return : void
@throws Exception : N/A;
*/ 
    public with sharing class ValidateException extends Exception {}
    public static final string ErrorMsg = 'Unable to Generate Factsheet.';
    public static final string ClsName  ='GA_AFS_InvokeAFSEmailFlow';
    public static final string methodNme  ='generateFactsheetDoc';
    public pagereference p;
    /**
@Description: GA_AFS_InvokeAFSEmailFlow() constructor method 
@Name : GA_AFS_InvokeAFSEmailFlow
@Param : ApexPages.StandardController stdController
@Return : void
@throws Exception : N/A;
*/ 
    public GA_AFS_InvokeAFSEmailFlow(ApexPages.StandardController stdController) {
        p = Page.GA_VF_01_GenerateFactSheet;
    }
    
    
    /**
@Description: GenerateFactsheetDoc() method is to generate factsheet
@Name : GenerateFactsheetDoc
@Param : none
@Return : void
@throws Exception : N/A;
*/   
    public pagereference  generateFactsheetDoc() {
        try{
            p.setRedirect(false);
            return   p; 
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorMsg)); 
            return null;
        }
        
        
    }
    
}