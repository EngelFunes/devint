global without sharing class ARV_AP_ApproveContractFromIP implements vlocity_ins.VlocityOpenInterface{
    public static final string CLSNAME='ARV_AP_ApproveContractFromIP';
    public static final string METHODNME='aprvUnmatchContrct';
    public static final String ERRMSG=system.label.ARV_CL43_Contract_Update_Error;
    public static final String SCSSMSGAPPRV=system.label.ARV_CL42_Contract_Approved_Sucess;
    public static final String CNTRCTSTATUSAPPRVD=system.label.ARV_CL41_ContractStatus_Approved;
    public static final String SELCTSTRNG ='select id,AccountId,Status,ARV_TECH_Account_Merge__c,ARV_Is_Mass_Updating__c,vlocity_ins__EnrollmentCensusId__c ';
    public static final String WHRSTRNG = 'from Contract where Id in ';
    public static final String LMTSTRNG = ' LIMIT 1';
    public static final String UPDAT ='update';
    String contractId;
    public static final String AUTMTEDENRLMNTINTGRNREDY = 'Automated Enrollment Setup - Integration Ready';
    public static final String MNULENRLMNTREDY = 'Manual Enrollment Setup - Processing';
   
    
        global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options){           
        Boolean success = true;
        try{
            if (methodName == METHODNAME){ 
                aprvUnmatchContrct(input,output,options);
            }
        }catch(Exception e){
            system.debug('line number@@ '+e.getLineNumber());
            system.debug('getMessage @@ '+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, 'ARV_AP61_UpdateContractDetails11', 'METHODNAME');
           // throw new AuraHandledException(e.getMessage()+e.getlinenumber());
        }
        return success;
    }
    
    /**
@Description: aprvUnmatchContrct() method 
@Name : aprvUnmatchContrct
@Param : contractId
@Return : string
@throws Exception : N/A;
*/  
    //@AuraEnabled
    public void aprvUnmatchContrct(Map<String,Object> input, Map<String,Object> output,
                                     Map<String,Object> options)
    {
    
        try
        {
            List<Contract> conRecLst = new List<Contract>();
            contractId = String.valueof(options.get('conID'));
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
               //return ERRMSG;
            }     
            
            Contract contRecQry =[select id,name,AccountId,Status,ARV_TECH_Account_Merge__c,ARV_Is_Mass_Updating__c from contract 
                                  where id =:contractId LIMIT 1];
            if(contRecQry.Status!=AUTMTEDENRLMNTINTGRNREDY && contRecQry.Status!=MNULENRLMNTREDY){
                contRecQry.ARV_Is_Mass_Updating__c=True;
                contRecQry.Status=CNTRCTSTATUSAPPRVD;
                database.update(contRecQry);
            }
           
            //return SCSSMSGAPPRV;
        }        
        catch(exception e)
        {
            system.debug('Error at Line Number^^^^'+e.getLineNumber());
            ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(contractId);    
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, METHODNME, contractId);
            //return ERRMSG;
        } 
  }
}