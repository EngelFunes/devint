/******************************************************************************************************************************************
@Author : Offshore
@Name: ARV_AP65_ContrctApprvExceptionHandling
@CreatedDate: 8 - Jan 2020  
@Description: ARV_AP65_ContrctApprvExceptionHandling to handle exceptions for the Approve Enrollment/Contract process. 
@version : 1.0  
*****************************************************************************************************************************************/
public with sharing class ARV_AP65_ContrctApprvExceptionHandling {
    public static final integer OCCURENCE = 0;
    public static final String  EXCPSVRTY='ERROR';
    public static final String EXCPCODE = 'Small Group Enrollment Submission Logs';
    public static final String ERRORSTATUS = 'Enrollment Submission – Error';
    public static final String REJSTATUS = 'Rejected';
    public static final string CLSNAME  ='ARV_AP65_ContrctApprvExceptionHandling';
    public static final string METHODUPDTCNTRCTSTUS  ='updtCntrctStats';
    public static final string METHODINSERTXCPTNRECDS  ='insertExceptionRecs';
    public static final string METHODREJSTATUS  ='updtCntrct';
    
    /*******************************************************************************************************************************
@Description    :  insertExceptionRecs 
@Name         :   insertExceptionRecs
@Param         :   List<Database.SaveResult> srList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static boolean insertExceptionRecs(List<Database.SaveResult> srList){
        try{
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            boolean isError = False;
            ExceptionLog__c objLog= new ExceptionLog__c();
            if(!srList.isEmpty()){
                for(Database.SaveResult obj : srList){
                    for(Database.Error objErr : obj.getErrors()){
                        if(!obj.isSuccess()){
                            objLog = new ExceptionLog__c(
                                Object_ID__c =obj.getId(),
                                ExceptionDescription__c = objErr.getMessage(),
                                ExceptionCode__c =  EXCPCODE,
                                NumberOfTimesOccured__c = OCCURENCE + 1,
                                ExceptionDetails__c = objErr.getMessage(),
                                Severity__c = EXCPSVRTY);
                            excpLst.add(objLog);
                        } 
                    }
                }
            }
            if(!excpLst.isEmpty()){
                Database.upsert(excpLst,false);
                isError = true;
            }
            return isError;
        }
        Catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME,METHODINSERTXCPTNRECDS);
           return false;
        } 
    }
    /*******************************************************************************************************************************
@Description    :  updtCntrctStats 
@Name         :   updtCntrctStats
@Param         :   String recordId
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updtCntrctStats(String recordId){
        try{
            List<Contract> cntrcLst = new  List<Contract> ();
            Contract cntrctRec =[Select id,Status,ARV_Is_Mass_Updating__c From Contract WHERE id=:recordId limit 1];
            cntrctRec.Status=ERRORSTATUS;
            cntrctRec.ARV_Is_Mass_Updating__c=True;       
            cntrcLst.add(cntrctRec);
            database.update(cntrcLst);
        }
        Catch(Exception e)
        {
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME,METHODUPDTCNTRCTSTUS,recordId);
        }        
    }
        /*******************************************************************************************************************************
@Description    :  updtCntrct 
@Name         :   updtCntrct
@Param         :   String recordId
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updtCntrct(String recordId){
        try{
            List<Contract> cntrcLst = new  List<Contract> ();
            Contract cntrctRec =[Select id,Status,EndDate,ARV_TECH_Account_Merge__c,
                                 ARV_Is_Mass_Updating__c From Contract WHERE id=:recordId limit 1];
            cntrctRec.Status=REJSTATUS;
            cntrctRec.ARV_TECH_Account_Merge__c=null;
            cntrctRec.Description=null;
            cntrctRec.ARV_Is_Mass_Updating__c=True;       
            cntrcLst.add(cntrctRec);
            database.update(cntrcLst);
        }
        Catch(Exception e)
        {
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME,METHODREJSTATUS,recordId);
        }        
    }
   
}