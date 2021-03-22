/*****************************************************************************************
Class Name   : ARV_AP56_ValidateContractSubmit. 
Date Created : 18-Dec-2019
Created By   : IDC Offshore
Description  : This is the class for validateContract in enrollment process...
******************************************************************************************/
global without sharing class ARV_AP56_ValidateContractSubmit implements vlocity_ins.VlocityOpenInterface {
    private static final String METHODNAME='validateContract';
    private static final String VALIDATIONSTATUS = 'validationStatus';
    private static final String ERRORMSG = 'error';
    private static final String WARNINGMSG = 'warning';
    private static final String PROCEED = 'proceed';
    private static final string CONTRACTID= 'contractId';
    private static final string CONTRACTQUERY=System.label.ARV_CL46_CONTRACTQUERY;
    private static final string CONTRACTWHERE=' where id=:paramId1';
    private static final string LIMITCONTR=' limit 1';
    /**************  
    Method name : invokeMethod
    Params     : map
    Return Type : null
    Description :invokeMethod() method.
    *************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options) 
    {           
        Boolean success = true;
        try{
            if (methodName == METHODNAME) 
            {
                validateContract(input,output,options);
            }
        }catch(Exception e){
            success = false;
        }
        return success;
    }
    
    /*****************************************************************************************
    Method Name   : validateContract. 
    Date Created : 30-DEC-2019
    Created By   : IDC Offshore
    Description  : This is the method for Contract Submission Date validation.
    ******************************************************************************************/       
    public void validateContract(Map<String,Object> input, Map<String,Object> output, Map<String,Object> options)   
    {       
        
            string contId=string.valueOf(input.get(CONTRACTID)); 
            Id cId=Id.VALUEOF(contId);
            ARV_AP07_QueryDataHelper.paramId1= cId;
            List<Contract> contrlist =ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,CONTRACTWHERE,NULL,LIMITCONTR);
            Contract con=contrlist[0];
            string submissiondate=string.valueOf(con.ARV_TECH_SubmissionDate__c);
            
            string strToday = submissiondate!=null?submissiondate:String.ValueOf(system.today()); 
            system.debug(':::Today::'+ strToday );     
            //string strToday = String.ValueOf(date.parse('2/17/2019')); // for testing
            string strEffDate = String.ValueOf(con.ARV_Requested_Effective_Date__c);
            
            
            if(validateEffectiveDate(strToday,strEffDate) == WARNINGMSG){
                output.put(VALIDATIONSTATUS,WARNINGMSG);
            }
            else if(disableSubmission(strToday,strEffDate) == ERRORMSG){
                output.put(VALIDATIONSTATUS,ERRORMSG);
            }
            else{
                output.put(VALIDATIONSTATUS,PROCEED);
            }
        
         
    }
    
    
    /*********************************************************************************************************
    Method Name   : validateEffectiveDate. 
    Date Created : 30-DEC-2019
    Created By   : IDC Offshore
    Description  : This is the method for Submission Date validation if submission date is in between 16 & 20.
    **********************************************************************************************************/ 
    public string validateEffectiveDate(string submitDate,string effectDate){
        
            
            Integer intdate= Integer.valueOf(submitDate.substring(8,10));
            Integer submon= Integer.valueOf(submitDate.substring(5,7));
            system.debug('::submont::'+submon);
            Integer reqmon= Integer.valueOf(effectDate.substring(5,7));
            system.debug('::reqmon::'+reqmon);
            Integer subyear=   Integer.valueOf(submitDate.substring(0,4));
            Integer reqyear= Integer.valueOf(effectDate.substring(0,4));
            //String warning = 'warning';
            string returnOut = '';
            integer lastmon = 12;
            integer dt1= integer.valueOf(System.Label.ARV_CL50_Submission_Start_Date);
            integer dt2 = integer.valueOf(System.Label.ARV_CL51_Submission_End_Date);
            system.debug('Start Date::' +dt1);
            system.debug('End Date:: '+dt2);
            if(reqmon==submon+1){
                if((submon==lastmon)&&(reqyear>subyear)&&(submon>reqmon)&&((intdate==dt1)||(intdate>dt1))&&((intdate<dt2)||(intdate==dt2))){
                returnOut=WARNINGMSG;
                }   
                else if((reqmon>submon)&&(reqyear==subyear)&&((intdate==dt1)||(intdate>dt1))&&((intdate<dt2)||(intdate==dt2))){
                returnOut=WARNINGMSG;
                    system.debug('Error:'+returnOut);
                }
                else{}
            }
                  
            return returnOut;
        
    }
    /*****************************************************************************************
    Method Name  : disableSubmission. 
    Date Created : 30-DEC-2019
    Created By   : IDC Offshore
    Description  : This is the method for Submission Date validation if submission date > 20.
    ******************************************************************************************/ 
    public string disableSubmission(string submitDate,string effectDate){
        
            //Date dateNextMonth = System.today().addMonths(1).toStartOfMonth();
            //Date dateNextMonth = date.parse('12/17/2019').addMonths(1).toStartOfMonth();
            //string datetoday =  string.valueOf(dateNextMonth);
            //Integer nextMon = Integer.valueOf(datetoday.substring(5,7));
            Integer intdate= Integer.valueOf(submitDate.substring(8,10));
            Integer submon= Integer.valueOf(submitDate.substring(5,7));
            Integer reqmon= Integer.valueOf(effectDate.substring(5,7));
            Integer subyear=   Integer.valueOf(submitDate.substring(0,4));
            Integer reqyear= Integer.valueOf(effectDate.substring(0,4));
            integer lastmon = 12;
            integer dt1= integer.valueOf(System.Label.ARV_CL51_Submission_End_Date);
            string cannotSubmit ='';
            boolean req=false;
            if(reqmon==submon+1){
            req=true;
            system.debug('Reqmon:: '+req);
                if((submon==lastmon)&&(reqyear>subyear)&&(submon>reqmon)&&((intdate>dt1))){
                cannotSubmit = ERRORMSG;
                }   
                else if((reqmon>submon)&&(reqyear==subyear)&&((intdate>dt1))){
                cannotSubmit = ERRORMSG;
                }
                else{}
           }
            return cannotSubmit;
    }    
}