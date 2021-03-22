/**
@Author : IDC Offshore
@Name: ARV_AP62_ContractCreateWorkflow
@CreatedDate: 26 - Oct 2018 
@Description: ARV_AP62_ContractCreateWorkflow class is to create workflow from Contract.
@version : 1.0  
*/
public without sharing class ARV_AP62_ContractCreateWorkflow {
    public static final string CLSNAME = 'ARV_AP62_ContractCreateWorkflow';
    public static final string UPDTCNTRCTSTATUSMETHDNME = 'updtCntrctStatus';
    public static final string CHECKTEMPLATEMETHDNME = 'checkTemplate';
    public static final string CREATCONTRACTWRKFLOWMETHDNME = 'creatContractNewwrkflow';
    public static final String AGNTSLDENRLMNT='%New Business Blue Cross OneSource Manual%';
    public static final String COMMAOP=',';
    public static final String EMPTYSTRNG='';
    public static final String OPNLBL='Open';
    public static final String BCBSMLBL='BCBSM';
    public static final String BCNLBL='BCN';
    public static final String MNTHYRFRMT = 'MMMM, YYYY';
    public static final String HYPNVAL = ' - ';
    public static final String TRUEVAL = 'True';
    public static final String FALSEVAL = 'False';
    public static final String REDYFORINTGRTN = 'Ready for Integration';
    public static final String MANUL = 'Manual';
    public static final string ENABLESMLGRPUWINTGN = system.label.ARV_CL40_Small_Group_Enable_Integration;
    public static final string BCNHSAAUTOMATE = system.label.ARV_CL54_BCN_HSA_Automate;
    public static final string BCNHRAAUTOMATE = system.label.ARV_CL55_BCN_HRA_Automate;
    public static final String AUTMTEDENRLMNTINTGRNREDY = 'Automated Enrollment Setup - Integration Ready';
    public static final String MNULENRLMNTREDY = 'Manual Enrollment Setup - Processing';
    public static final String UPDAT = 'update';
    public static final String INSRT = 'insert';
    public static final String SMALGRPUWQUENAME = 'GA_Small_Group_Underwriting_Queue';
    public static final string GAUNITLEADERQUENAME = 'GA_Unit_Leader_WFGSQueue';
    public static final String VLOCITYTAG = 'Vlocity';
    public static final String HYPHN = '-';
    public static final String DATEFRMT ='MMMM, YYYY';
    
    /**
@Description: updtCntrctStatus() method 
@Name : updtCntrctStatus
@Param : List<GA_Group_SEgment__C> , Contract ,string 
@Return : void
@throws Exception : N/A
*/      
    public static void updtCntrctStatus(List<GA_Group_Segment__C> grpLst, Contract cntrcRecd,string accId){
        try{
            boolean crtWrkflw = False;
            boolean isBCNHRA = False;
            boolean isBCNHSA = False;
            boolean isManaulWF = False;
            boolean isAutomatedWF = False;
            
            if(grpLst.size()>0){
                for (GA_Group_Segment__C grp :grpLst){
                    if (grp.ARV_BCN_HRA__c)
                    {
                        isBCNHRA=True;
                    }
                    if (grp.ARV_BCN_HSA__c)
                    {
                        isBCNHSA=True;
                    }
                }
            } 
            
            if(ENABLESMLGRPUWINTGN.equalsIgnoreCase(FALSEVAL))
            {
                isManaulWF=True;
            }
            if(ENABLESMLGRPUWINTGN.equalsIgnoreCase(TRUEVAL))
            {
                if (isBCNHRA && !isBCNHSA){
                    if(BCNHRAAUTOMATE.equalsIgnoreCase(TRUEVAL))
                    {
                        isAutomatedWF = True;
                    }
                    if(BCNHRAAUTOMATE.equalsIgnoreCase(FALSEVAL))
                    {
                        isManaulWF=True;
                    }
                }
                if (!isBCNHRA && isBCNHSA){
                    if(BCNHSAAUTOMATE.equalsIgnoreCase(TRUEVAL))
                    {
                        isAutomatedWF = True;
                    }
                    if(BCNHSAAUTOMATE.equalsIgnoreCase(FALSEVAL))
                    {
                        isManaulWF=True;
                    }
                }
                if (isBCNHRA && isBCNHSA){
                    if(BCNHRAAUTOMATE.equalsIgnoreCase(TRUEVAL) && BCNHSAAUTOMATE.equalsIgnoreCase(TRUEVAL))
                    {
                        isAutomatedWF = True;
                    }
                    if(BCNHRAAUTOMATE.equalsIgnoreCase(TRUEVAL) && BCNHSAAUTOMATE.equalsIgnoreCase(FALSEVAL))
                    {
                        isManaulWF=True;
                    }
                    if(BCNHRAAUTOMATE.equalsIgnoreCase(FALSEVAL) && BCNHSAAUTOMATE.equalsIgnoreCase(TRUEVAL))
                    {
                        isManaulWF=True;
                    }
                    if(BCNHRAAUTOMATE.equalsIgnoreCase(FALSEVAL) && BCNHSAAUTOMATE.equalsIgnoreCase(FALSEVAL))
                    {
                        isManaulWF=True;
                    }
                }
                if (!isBCNHRA && !isBCNHSA){
                    isAutomatedWF = True;
                }
            } 
            
            List<Contract> cntrctUpdtLst = new List<Contract> ();
            
            if(isAutomatedWF)
            {
                cntrcRecd.ARV_Integration_Status__c = REDYFORINTGRTN;
                cntrcRecd.Status=AUTMTEDENRLMNTINTGRNREDY;
                cntrcRecd.ARV_Is_Mass_Updating__c=True;
                cntrctUpdtLst.add(cntrcRecd);
            }
            if(isManaulWF)
            {
                cntrcRecd.ARV_Integration_Status__c = MANUL;
                cntrcRecd.Status=MNULENRLMNTREDY;
                cntrcRecd.ARV_Is_Mass_Updating__c=True;
                cntrctUpdtLst.add(cntrcRecd);
                crtWrkflw = True;
            }
            
            if(cntrctUpdtLst.size()>0){
                //List<Database.SaveResult> contrcList = ARV_AP08_DMLHelper.insertSObjects(cntrctUpdtLst,UPDAT,true);
                database.update(cntrctUpdtLst);
            }
            
            if(crtWrkflw)
            {
                checkTemplate(grpLst,cntrcRecd,accId);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, UPDTCNTRCTSTATUSMETHDNME, cntrcRecd.id); 
            ARV_AP59_CreateGroupSegmentRecords.errorOccured = true;
        }
    }
    
    /**
@Description: checkTemplate() method 
@Name : checkTemplate
@Param : List<GA_Group_SEgment__C> , Contract ,account 
@Return : void
@throws Exception : N/A
*/   
    public static void checkTemplate(List<GA_Group_Segment__C> grpLst, Contract cntrcRecd,string accId){
        try{
            List<string> slectedBCBSMGrp = new List<string> ();
            List<string> slectedBCNGrp = new List<string> ();
            List<GA_Group_Segment__c> bcbsmGrpLst = new List<GA_Group_Segment__c> ();
            List<GA_Group_Segment__c> bcnGrpLst = new List<GA_Group_Segment__c> ();

            if(grpLst.size()>0){
                for(GA_Group_Segment__c grp:grpLst)
                {
                    if(grp.GA_Carrier__c == BCBSMLBL){
                        slectedBCBSMGrp.add(grp.Id);
                        bcbsmGrpLst.add(grp);
                    }
                    if(grp.GA_Carrier__c == BCNLBL){
                        slectedBCNGrp.add(grp.Id);
                        bcnGrpLst.add(grp);
                    }
                }
            }
            
            list<GA_WFT_workflow__c> wfTepltBCBSM=[select id,Name,GA_Carrier__c,
                                                   GA_Method__c,GA_Process_Subtype__c,
                                                   GA_Process_Type__c from GA_WFT_workflow__c where GA_Carrier__c=:BCBSMLBL and Name like :AGNTSLDENRLMNT limit 1];
            
            list<GA_WFT_workflow__c> wfTepltBCN=[select id,Name,GA_Carrier__c,
                                                 GA_Method__c,GA_Process_Subtype__c,
                                                 GA_Process_Type__c from GA_WFT_workflow__c where GA_Carrier__c=:BCNLBL and Name like :AGNTSLDENRLMNT limit 1];
            
            List<GA_WF_Workflow__c> wfRecLst = new List<GA_WF_Workflow__c> ();

            if(wfTepltBCBSM.size()>0 && slectedBCBSMGrp.size()>0){
            GA_WF_Workflow__c wfRec=new GA_WF_Workflow__c(Name = wfTepltBCBSM[0].GA_Carrier__c + HYPHN + wfTepltBCBSM[0].GA_Process_Type__c + HYPHN + wfTepltBCBSM[0].GA_Process_Subtype__c + HYPHN + wfTepltBCBSM[0].GA_Method__c + HYPHN +Datetime.now().format( DATEFRMT),
                                                          GA_Account__c = accId,  
                                                          ARV_Enrollment_Contract__c=cntrcRecd.Id,
                                                          Sub_Type__c = wfTepltBCBSM[0].GA_Process_Subtype__c,
                                                          GA_Type__c = wfTepltBCBSM[0].GA_Process_Type__c,
                                                          GA_Carrier__c = wfTepltBCBSM[0].GA_Carrier__c,
                                                          GA_Method__c = wfTepltBCBSM[0].GA_Method__c,
                                                          GA_Workflow_Template__c = wfTepltBCBSM[0].Id,
                                                          GA_Status__c = OPNLBL,
                                                          GA_External_Initiated__c=true,
                                                          GA_Selected_Group_Segments__c=string.join(slectedBCBSMGrp, COMMAOP),
                                                          GA_Benefit_Effective_Date__c=bcbsmGrpLst[0].GA_Benefit_Effective_Date__c,
                                                          GA_Date_Opened__c=system.today());
            wfRecLst.add(wfRec);
            }
            
            if(wfTepltBCN.size()>0 && slectedBCNGrp.size()>0){
            GA_WF_Workflow__c wfRec=new GA_WF_Workflow__c(Name = wfTepltBCN[0].GA_Carrier__c + HYPHN + wfTepltBCN[0].GA_Process_Type__c + HYPHN + wfTepltBCN[0].GA_Process_Subtype__c + HYPHN + wfTepltBCN[0].GA_Method__c + HYPHN +Datetime.now().format( DATEFRMT),
                                                          GA_Account__c = accId,  
                                                          ARV_Enrollment_Contract__c=cntrcRecd.Id,
                                                          Sub_Type__c = wfTepltBCN[0].GA_Process_Subtype__c,
                                                          GA_Type__c = wfTepltBCN[0].GA_Process_Type__c,
                                                          GA_Carrier__c = wfTepltBCN[0].GA_Carrier__c,
                                                          GA_Method__c = wfTepltBCN[0].GA_Method__c,
                                                          GA_Workflow_Template__c = wfTepltBCN[0].Id,
                                                          GA_Status__c = OPNLBL,
                                                          GA_External_Initiated__c=true,
                                                          GA_Selected_Group_Segments__c=string.join(slectedBCNGrp, COMMAOP),
                                                          GA_Benefit_Effective_Date__c=bcnGrpLst[0].GA_Benefit_Effective_Date__c,
                                                          GA_Date_Opened__c=system.today());
            wfRecLst.add(wfRec);
            }
            creatContractNewwrkflow(wfRecLst, cntrcRecd.Id);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CHECKTEMPLATEMETHDNME, cntrcRecd.Id);
        }
    }
    /**
@Description: creatContractNewwrkflow() method 
@Name : creatContractNewwrkflow
@Param : List<GA_WF_Workflow__c> , string   
@Return : void
@throws Exception : N/A
*/  
    public static void creatContractNewwrkflow(List<GA_WF_Workflow__c> wfRecLst,
                                               string cntrcRecdID)
    {
        try{
                if(wfRecLst.size()>0){
                GA_WorkflowServiceCls.isExecuting=true;
                database.insert(wfRecLst);
            }
           
            List<Contract> cntrctRec = [select id,ARV_System_Check_1_Status__c from Contract where id=:cntrcRecdID limit 1];
            list<GA_WF_Group_Segment__c> wfPrcssRecs=[select id,GA_Workflow_ID__c,GA_WF_Step_ID__c,GA_Workflow_ID__r.GA_Carrier__c
                                                      from GA_WF_Group_Segment__c where GA_Workflow_ID__c in:wfRecLst and GA_WF_Step_ID__c !=null LIMIT 2000];
            GA_WF_Group_Segment__c wfprcssTmp = new GA_WF_Group_Segment__c ();
            list<GA_WF_Group_Segment__c> wfPrcssRecsUpdtOwnr=new list<GA_WF_Group_Segment__c>();
            
            List<QueueSobject> smalGrpUWqueueLst = [SELECT Id, Queue.name,QueueId,Queue.developerName
                                                    FROM QueueSobject where Queue.developerName =:SMALGRPUWQUENAME limit 1];
            
            List<QueueSobject> gaUnitLeaderqueueLst = [SELECT Id, Queue.name,QueueId,Queue.developerName
                                                    FROM QueueSobject where Queue.developerName =:GAUNITLEADERQUENAME limit 1];
            
            if(wfPrcssRecs.size()>0){
                for(GA_WF_Group_Segment__c wfprcss:wfPrcssRecs)
                {
                    wfprcssTmp=new GA_WF_Group_Segment__c();
                    wfprcssTmp.Id=wfprcss.Id;
                    if(wfprcss.GA_Workflow_ID__r.GA_Carrier__c == BCNLBL){
                    if(cntrctRec[0].ARV_System_Check_1_Status__c == null || cntrctRec[0].ARV_System_Check_1_Status__c == EMPTYSTRNG){
                        wfprcssTmp.ownerId=smalGrpUWqueueLst[0].QueueId;
                    }
                    else{
                        wfprcssTmp.ownerId=userInfo.getUserId();
                    }
                    }
                    if(wfprcss.GA_Workflow_ID__r.GA_Carrier__c == BCBSMLBL){
                        wfprcssTmp.ownerId=gaUnitLeaderqueueLst[0].QueueId;
                    }
                    wfPrcssRecsUpdtOwnr.add(wfprcssTmp);
                } 
            }
            
            if(wfPrcssRecsUpdtOwnr.size()>0)
            {
                //List<Database.SaveResult> contrcList = ARV_AP08_DMLHelper.insertSObjects(wfPrcssRecsUpdtOwnr,UPDAT,true);
                database.update(wfPrcssRecsUpdtOwnr);
            }
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CREATCONTRACTWRKFLOWMETHDNME, cntrcRecdID);
            ARV_AP59_CreateGroupSegmentRecords.errorOccured = true;
        }
        
    }
}