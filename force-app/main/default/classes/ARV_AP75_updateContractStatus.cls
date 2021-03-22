/******************************************************************************************************************************************
@Author : Offshore
@Name: ARV_AP75_updateContractStatus
@CreatedDate: 21 - Jan 2020  
@Description: ARV_AP75_updateContractStatus to upadte the contract staus when worklfows are closed. 
@version : 1.0  
*****************************************************************************************************************************************/
public without sharing class ARV_AP75_updateContractStatus {
    public static boolean isExecuting=false;
    public static final string CLSNAME='ARV_AP75_updateContractStatus';
    public static final string METHODNME='updtCntrctStatus';
    public static final string CLOSED='Closed';
    public static final string OPEN='Open';
    public static final string CNTRCTSTATUS='Manual Enrollment Setup - Complete';
	public static final string MANUALPREVCNTRCTSTATUS='Manual Enrollment Setup - Processing';
	public static final string AUTOPREVCNTRCTSTATUS='Automated Enrollment';
    public static final string AUTOCNTRCTSTATUS='Automated Enrollment Setup - Complete';
    /**
@Description: updtCntrctStatus() method 
@Name : updtCntrctStatus
@Param : N/A
@Return : List<GA_WF_Workflow__c> wfList
@throws Exception : N/A
*/ 
    public static void updtCntrctStatus(List<GA_WF_Workflow__c> wfList)
    {
        try{
            set<id> cntrctIds=new set<id>();
            List<Id> clseList = new List<Id>();
            if(wfList.size()>0){
                for(GA_WF_Workflow__c objWF : wfList){
                    if(objWF.GA_Status__c==CLOSED && objWF.ARV_Enrollment_Contract__c!=NULL)
                    {
                        cntrctIds.add(objWF.ARV_Enrollment_Contract__c);
                        clseList.add(objWF.Id);
                    }
                }
            }
            if(cntrctIds.size() > 0){
                List<Contract>  cntrctLst =[Select id,Status,
                                            (select GA_Status__c from Workflows__r where ARV_Enrollment_Contract__c!=null limit 1000)
                                            from Contract WHERE ID IN :cntrctIds Limit 100];
                
                
                Set<Id> cntIds = New Set<Id> ();
                Set<Id> processContrctIds = New Set<Id>();
                boolean flag = false;
                List<Contract>  cntrctIdsToPrcs = new List<Contract>();
                List<Contract>  finalcntrctIdsToPrcs = new List<Contract>();
                
                if(cntrctLst.size()>0){
                    for(Contract cntrctObj : cntrctLst){
                        if(!cntrctObj.Workflows__r.isEmpty()){
                            for(GA_WF_Workflow__c objWF : cntrctObj.Workflows__r){
                                if(objWF.GA_Status__c==OPEN){
                                    flag=true;
                                    cntIds.add(cntrctObj.Id);
                                    break;
                                }
                                //added for US2723
                                else{
									if(cntrctObj.Status.contains(AUTOPREVCNTRCTSTATUS)){
										if(clseList.contains(objWF.Id) && !processContrctIds.contains(cntrctObj.id)){
											cntrctObj.Status=AUTOCNTRCTSTATUS;
											cntrctIdsToPrcs.add(cntrctObj);
											processContrctIds.add(cntrctObj.Id);
										}
									}
									else{
									if(clseList.contains(objWF.Id) && !processContrctIds.contains(cntrctObj.id)){
											cntrctObj.Status=CNTRCTSTATUS;
											cntrctIdsToPrcs.add(cntrctObj);
											processContrctIds.add(cntrctObj.Id);
										}
									}
                                }
                            }
                        }
                    }
                }
                if(cntIds.size() > 0){
                    processContrctIds.removeAll(cntIds);
                }
                if(cntrctIdsToPrcs.size()>0){ 
                    for(Contract cntrctRec : cntrctIdsToPrcs){
                        if(processContrctIds.contains(cntrctRec.id)){
                            finalcntrctIdsToPrcs.add(cntrctRec);
                        }
                    }
                }
                
                if(!finalcntrctIdsToPrcs.isEmpty()){
                    Database.update(cntrctIdsToPrcs);
                }
            }
            isExecuting=true;
        }	
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
            
        } 
    }
}