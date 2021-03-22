/*****************************************************************************************
Class Name   : ARV_AP86_CheckDocuSignStatus. 
Date Created : 04-Apr-2020
Created By   : IDC Offshore
Description  : This is the class for validating Docusign Completion Status.
******************************************************************************************/
global class ARV_AP86_CheckDocuSignStatus implements vlocity_ins.VlocityOpenInterface2 {
    private static final string FETCHDOCSIGNSTATUS='fetchdocsignstatus';
    private static final string CONTEXTID='ContextId';
    private static final string ERROR='error';
    private static final string ESIGNERRMSG=system.label.ARV_CL57_Esign_ErrorMessage;
    private static final string SLCTQRY='Select id,dsfs__Envelope_Status__c from dsfs__DocuSign_Status__c';
    private static final string WHERECLAUSE=' Where dsfs__Contract__c=:paramName1';
    private static final string ORDERBY=' order by createddate desc';
    private static final string LIMITCLAUSE=' Limit 1';
    private static final string SENT_VAL='Sent';
    
    /*************************************************************************************************  
Method name : invokeMethod
Params     : map
Return Type : null
Description :this method is used to invoke the fetchdocsignstatus method
******************************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options){           
        Boolean success =true;
        
        try{            
            if (methodName == FETCHDOCSIGNSTATUS) 
            {
                fetchdocsignstatus(input,output,options);
            }        
            
        }catch(Exception e){
            success = false;        
        }
        return true;
    }
    /*****************************************************************************************
Method Name  : fetchdocsignstatus
Created By   : IDC Offshore
Description  : This is the method for Cfetching docusign Staus and Display Error Message if not completed esign request.
******************************************************************************************/
    private static void fetchdocsignstatus(Map<String, Object> input, Map<String, Object> output, Map<String,Object> options){
        ARV_AP07_QueryDataHelper.paramName1= string.valueof(options.get(CONTEXTID));
        List<dsfs__DocuSign_Status__c> ds = ARV_AP07_QueryDataHelper.getsObjects(SLCTQRY,WHERECLAUSE,ORDERBY,LIMITCLAUSE);
            if(ds.size()>0 && string.isNotBlank(ds[0].dsfs__Envelope_Status__c)){
                if(SENT_VAL.equalsIgnoreCase(ds[0].dsfs__Envelope_Status__c)){
                    output.put(ERROR,ESIGNERRMSG);
                }
            }
    }
}