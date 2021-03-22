/*****************************************************************************************
@Author : IDC Offshore
@Name: ASC_ContractBatchToUpdateStatus
@CreatedDate: 02 - Sept - 2020
@Description: ASC_AP_ContractBatchToUpdateStatus batch class to Update ASC contract Status.
******************************************************************************************/
global class ASC_ContractBatchToUpdateStatus implements Database.Batchable<sObject>{
    
    global final string query='select id,StartDate,EndDate,Status,RecordTypeId from Contract';
    private static final string ACCEPTED  ='Accepted';
    private static final string ACTIVATED  ='Activated';
    private static final string EXPIRED  ='Expired';
    private static final string CONTRACT  ='ASC_Contract';
    public static final string CLASSNAME  ='ASC_ContractBatchToUpdateStatus';
    public static final string METHODNME  ='execute';
   
    /*****************************************************************************************
@Description: start() method 
@Name : start
@Param : Database.BatchableContext BC
@Return : Database.QueryLocator
@throws Exception : N/A;
******************************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        return Database.getQueryLocator(query); 
    }
    
    /*****************************************************************************************
Description: execute() method 
@Name : execute
@Param : Database.BatchableContext BC, List<sObject> scope
@Return : Database.QueryLocator
@throws Exception : N/A;
******************************************************************************************/ 
    global void execute(Database.BatchableContext bc, List<Contract> scope)
    {
        try{
            list<Contract> conList=new list<Contract>();
            Date today = Date.Today();
            Id ASC_CONTRACT_RECTYPEID = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get(CONTRACT).getRecordTypeId();
	            System.debug('REc Id '+ASC_CONTRACT_RECTYPEID+' ACCEPTED '+ACCEPTED);
            if(!scope.isEmpty()){
                for(Contract c:scope){
                   System.debug('Scope '+c); 
                    If(ASC_CONTRACT_RECTYPEID.equals(c.RecordTypeId) && ACCEPTED.equals(c.Status) && c.StartDate<=today)
                    {
                        c.Status=ACTIVATED;
                        conList.add(c);
                    }
                    else if(ASC_CONTRACT_RECTYPEID.equals(c.RecordTypeId) && ACTIVATED.equals(c.Status) && c.EndDate<today)
                    {
                        c.Status=EXPIRED;
                        conList.add(c);
                    }
                    
                }
            }
            if(!conList.isEmpty()){
            database.update(conList);
            }
           }
           catch(exception e){
                GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNME);
           } 
        
    }
    /******************************************************************************************
@Description: finish() method 
@Name : finish
@Param : Database.BatchableContext BC
@Return : Void
@throws Exception : N/A;
******************************************************************************************/ 
    global void finish(Database.BatchableContext bc)
    {
        
    }
}