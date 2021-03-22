/**
@Author : IDC offshore
@Name: ARV_AP66_ApproveContractcreateRecrds
@CreatedDate: 20 - Dec 2019 
@Description: ARV_AP66_ApproveContractcreateRecrds class is to approve contracts and to create common control records
@version : 1.0  
*/
public without sharing class ARV_AP66_ApproveContractcreateRecrds {
    public static final string CLSNAME='ARV_AP66_ApproveContractcreateRecrds';
    public static final string METHODNME='aprvUnmatchContrct';
    private static final String PROCEDURE_NAME = 'ContractIP_Approval';
    public static final String ERRMSG=system.label.ARV_CL43_Contract_Update_Error;
    public static final String SCSSMSGAPPRV=system.label.ARV_CL42_Contract_Approved_Sucess;
    public static final String CNTRCTSTATUSAPPRVD=system.label.ARV_CL41_ContractStatus_Approved;
    public static final String SELCTSTRNG ='select id,AccountId,Status,ARV_TECH_Account_Merge__c,ARV_Is_Mass_Updating__c,vlocity_ins__EnrollmentCensusId__c ';
    public static final String WHRSTRNG = 'from Contract where Id in ';
    public static final String LMTSTRNG = ' LIMIT 1';
    public static final String UPDAT ='update';
    public static final String AUTMTEDENRLMNTINTGRNREDY = 'Automated Enrollment Setup - Integration Ready';
    public static final String MNULENRLMNTREDY = 'Manual Enrollment Setup - Processing';
   
    /**
@Description: aprvUnmatchContrct() method 
@Name : aprvUnmatchContrct
@Param : contractId
@Return : string
@throws Exception : N/A;
*/  
    @AuraEnabled
    public static string aprvUnmatchContrct(string contractId)
    {
        try
        {
            List<Contract> conRecLst = new List<Contract>();
            List<Account>  acntIdsToAprv = new List<Account>();
            set<id> accIdtoAprv=new set<id>();
            Set<id> contractIds = new Set<id>();
            contractIds.add(contractId);           
            String whrid = WHRSTRNG + GA_Util08_FilterProcessHelper.idSet(contractIds);
            List<Contract> conlst = ARV_AP07_QueryDataHelper.getsObjects(SELCTSTRNG,whrid,'',LMTSTRNG);
            Contract contRec = conlst[0];

            if(contRec.Status == 'Underwriting - Under Review' ){
                ARV_AP58_ApproveContract.sendEmailCDH(contractId);
            }   
            
            ARV_AP58_ApproveContract.createOrMergeAccount(contRec.AccountId,contRec.ARV_TECH_Account_Merge__c,contractId,contRec.vlocity_ins__EnrollmentCensusId__c);
            //Moving this method to create gs method.
            //ARV_AP58_ApproveContract.commonControlCreate(contractId);
            ARV_AP59_CreateGroupSegmentRecords.createGroupSegmentRecords(contractId);
            
            if(ARV_AP59_CreateGroupSegmentRecords.errorOccured){
                ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(contractId);
               // throw new AuraHandledException(ERRMSG); 
               return ERRMSG;
            }     
            
            Contract contRecQry =[select id,name,AccountId,Status,ARV_TECH_Account_Merge__c,ARV_Is_Mass_Updating__c from contract 
                                  where id =:contractId LIMIT 1];
            if(contRecQry.Status!=AUTMTEDENRLMNTINTGRNREDY && contRecQry.Status!=MNULENRLMNTREDY){
                contRecQry.ARV_Is_Mass_Updating__c=True;
                contRecQry.Status=CNTRCTSTATUSAPPRVD;
                database.update(contRecQry);
            }
           
            return SCSSMSGAPPRV;
        }        
        catch(exception e)
        {
            system.debug('Error at Line Number^^^^'+e.getLineNumber());
            ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(contractId);    
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, METHODNME, contractId);
            return ERRMSG;
        } 
    }
    /**
@Description: aprvUnmatchContrct() method 
@Name : aprvUnmatchContrct
@Param : contractId
@Return : string
@throws Exception : N/A;
*/  
    @AuraEnabled
    public static string aprvUnmatchContrct1(string contractId)
    {
       String jobids=null;
        String successMessage = null;
        try
        {
             
            contract contRecord = new contract(Id=id.valueOf(contractId));
            contRecord.ARV_Submitting_User__c=UserInfo.getUserId();
            contRecord.ARV_Date_Submitted__c=System.Today();
                Map <String, Object> ipInput = new Map <String, Object>();
                Map <String, Object> ipOutput = new Map <String, Object>();
                Map <String, Object> ipOptions = new Map <String, Object>();
                ipInput.put('contractID',contRecord.Id);
                 jobids=vlocity_ins.IntegrationProcedureService.runIntegrationProcedureQueueable(PROCEDURE_NAME,ipInput,ipOptions);
            successMessage = 'Contract will be updated soon as it is sent for approval process';
               system.debug('++++++@@@JobId'+jobids);
               contRecord.ARV_TECH_Hide_Approve_Button__c=true;
               database.update(contRecord);
        }
             
        catch(exception e)
        {
            system.debug('Error at Line Number^^^^'+e.getLineNumber());
            ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(contractId);
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        } 
        return successMessage;
    }
}