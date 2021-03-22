public without sharing class ARV_AP_GWC_WorkFlowsCreation {
    public static final string CLSNAME = 'ARV_AP_GWC_WorkFlowsCreation';
    public static final string MNLWFMETHDNME = 'manualWorkFlow';
    public static final string CHTEMPRETROMETHDNME = 'checkTemplateRetro';
    public static final string CHECKTEMPLATEMETHDNME = 'checkTemplate';
    public static final string CHTEMPBCBSMETHDNME = 'checkTemplatebcbs';
    public static final string CREATCONTRACTWRKFLOWMETHDNME = 'creatContractNewwrkflow';
    public static final String BENEFITCHANGE='Benefit Change - OneSource';
    public static final String BLUCRSOS='Blue Cross OneSource';
    public static final String GWC='GWC';
    public static final String NA='N/A';
    public static final String NEWGROUPSEGMENT='New Group Segment - OneSource';
    public static final String COMMAOP=ARV_AP41_StringLiteralUtils.COMMAVAL;
    public static final String EMPTYSTRNG=ARV_AP41_StringLiteralUtils.EMPTYSTRNG;
    public static final String OPNLBL=ARV_AP41_StringLiteralUtils.OPNLBL;
    public static final String BCBSMLBL=ARV_AP41_StringLiteralUtils.BCBSMVAL;
    public static final String BCNLBL=ARV_AP41_StringLiteralUtils.BCNTYPE;
    public static final String MNTHYRFRMT = 'MMMM, YYYY';
    public static final String HYPNVAL = ARV_AP41_StringLiteralUtils.SPACEVAL+ARV_AP41_StringLiteralUtils.HYPHENVAL+ARV_AP41_StringLiteralUtils.SPACEVAL;
    public static final String TRUEVAL = 'True';
    public static final String FALSEVAL = 'False';
    public static final String REDYFORINTGRTN = ARV_AP41_StringLiteralUtils.REDYFORINTGRTN;
    public static final String MANUL = ARV_AP41_StringLiteralUtils.MANUL;
    public static final string ENABLESMLGRPUWINTGN = system.label.ARV_CL40_Small_Group_Enable_Integration;
    public static final string BCNHSAAUTOMATE = system.label.ARV_CL54_BCN_HSA_Automate;
    public static final string BCNHRAAUTOMATE = system.label.ARV_CL55_BCN_HRA_Automate;
    //public static final String AUTMTEDENRLMNTINTGRNREDY = 'Automated Enrollment Setup - Integration Ready';
    //public static final String MNULENRLMNTREDY = 'Manual Enrollment Setup - Processing';
    public static final String UPDAT = ARV_AP41_StringLiteralUtils.TYPEUPDATE;
    public static final String INSRT = ARV_AP41_StringLiteralUtils.TYPEINSERT;
    public static final String SMALGRPUWQUENAME = 'GA_Small_Group_Underwriting_Queue';
    public static final string GAUNITLEADERQUENAME = 'GA_Unit_Leader_WFGSQueue';
    public static final String VLOCITYTAG = 'Vlocity';
    public static final String HYPHN = ARV_AP41_StringLiteralUtils.HYPHENVAL;
    public static final String DATEFRMT ='MMMM, YYYY';
    public static final string CONSTATUS=ARV_AP41_StringLiteralUtils.GSGWCCMP;
    
    
/*****************************************************************************************
Method Name   : cloneGroupSegmentRecord
Created By   : IDC Offshore
Description  : This is the method for group segment creation
******************************************************************************************/
    public static void manualWorkFlow(List<GA_Group_Segment__c> gslist,contract con,string accId, boolean BCNHSA, boolean BCNHRA,boolean BCNHBL,boolean BCNMASSPLAN,boolean RETROGWC){
      try{
          system.debug('GsListsize:'+gslist.size());
          system.debug('Gslist:'+gslist);
         system.debug('con.ARV_Tech_SystemCheck2__c::'+con.ARV_Tech_SystemCheck2__c);
             system.debug('con.status::'+con.status);
          system.debug('con'+con);
            boolean crtWrkflw = ARV_AP41_StringLiteralUtils.FALSE_VALUE;
           
            boolean isManaulWF = ARV_AP41_StringLiteralUtils.FALSE_VALUE;
          boolean isNoChng = ARV_AP41_StringLiteralUtils.FALSE_VALUE;
            //boolean isAutomatedWF = False;
               List<GA_Group_Segment__c> bcnlist= new List<GA_Group_Segment__c>();
               List<GA_Group_Segment__c> bcbslist= new List<GA_Group_Segment__c>();
          for(GA_Group_Segment__c gs:gslist){
              if(gs.GA_Carrier__c==ARV_AP41_StringLiteralUtils.BCNTYPE)
              {
             
                  bcnlist.add(gs);
              }
              else
              {
                  bcbslist.add(gs);
              }
              }
          
          system.debug('bcnlist:'+bcnlist);
          system.debug('bcbslist:'+bcbslist);
          //system.debug('con.ARV_Tech_SystemCheck2__c::'+con.ARV_Tech_SystemCheck2__c);
         // system.debug('con.status::'+con.status);
         // system.debug('check::'+if(con.ARV_Tech_SystemCheck2__c !='' && con.status==CONSTATUS));
          if((con.ARV_Tech_SystemCheck2__c !=ARV_AP41_StringLiteralUtils.NULLSTRING) && con.status==CONSTATUS){
             isManaulWF=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
              }
          
            List<Contract> cntrctUpdtLst = new List<Contract>();
            
            if(isManaulWF)
            {
                con.ARV_Integration_Status__c = MANUL;
               con.Status=ARV_AP41_StringLiteralUtils.MNLGWCRDY;
                con.ARV_Is_Mass_Updating__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                crtWrkflw = ARV_AP41_StringLiteralUtils.TRUE_VALUE;
            }
          else if((con.ARV_Tech_SystemCheck2__c ==ARV_AP41_StringLiteralUtils.NULLSTRING) && con.status==CONSTATUS){
              con.ARV_Integration_Status__c = REDYFORINTGRTN;
              con.Status=ARV_AP41_StringLiteralUtils.AUTGWCRDY;
          }
            cntrctUpdtLst.add(con);
            if(cntrctUpdtLst.size()>0){
                //List<Database.SaveResult> contrcList = ARV_AP08_DMLHelper.insertSObjects(cntrctUpdtLst,UPDAT,true);
                database.update(cntrctUpdtLst);
            }
            system.debug('cont status:'+con.Status);
          if(crtWrkflw)
            {system.debug('retro carrier');
                if(con.ARV_Tech_SystemCheck2__c=='Retro GWCs,' && con.GWC_Request_Type__c=='Existing Benefit Package No Change'){
              checkTemplateRetro(bcnlist,bcbslist,con,accId);
          }
            else if((bcnlist.size()>0 && bcbslist.isempty())||(bcbslist.size()>0 && bcnlist.isempty()))
              {
                  system.debug('single carrier');
               if(bcnlist.size()>0 && bcbslist.isempty()) 
                  {system.debug('bcn carrier');
                  checkTemplate(bcnlist,con,accId);
                  }
                  else if((bcbslist.size()>0 && bcnlist.isempty()))
                  {system.debug('bcbsm carrier');
                  checkTemplatebcbs(bcbslist,con,accId);
                  } 
              }
            else if(bcnlist.size()>0 && bcbslist.size()>0)   
              { system.debug('dual carrier');
                  if(BCNHBL==ARV_AP41_StringLiteralUtils.TRUE_VALUE|| 
                     BCNHRA==ARV_AP41_StringLiteralUtils.TRUE_VALUE|| BCNHSA==ARV_AP41_StringLiteralUtils.TRUE_VALUE
                     ||BCNMASSPLAN==ARV_AP41_StringLiteralUtils.TRUE_VALUE|| RETROGWC==ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                      
                     checkTemplate(bcnlist,con,accId);
                   checkTemplatebcbs(bcbslist,con,accId);
              }
            }
        }
        
          
      }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, MNLWFMETHDNME, con.id); 
            ARV_AP59_CreateGroupSegmentRecords.errorOccured = ARV_AP41_StringLiteralUtils.TRUE_VALUE;
            system.debug('Linenumber'+e.getLineNumber()+','+e.getMessage());
        }
    }
    
    //retro metod
    public static void checkTemplateRetro(List<GA_Group_Segment__C> bcnlist, List<GA_Group_Segment__C> bcbslist,
  Contract cntrcRecd,string accId){
        try{
           
            List<string> slectedGSBcn = new List<string> ();
            
            List<GA_Group_Segment__c> bcnGSLst = new List<GA_Group_Segment__c> ();
			
			List<string> slectedGSBcbs = new List<string> ();
            
            List<GA_Group_Segment__c> bcbsGSLst = new List<GA_Group_Segment__c> ();
            List<GA_WF_Workflow__c> wfRecLst = new List<GA_WF_Workflow__c> ();
            if(bcnlist.size()>0){
                for(GA_Group_Segment__c grp:bcnlist)
                {
                    if(grp.ARV_GWC_Type__c  == 'No Change'){
                       slectedGSBcn.add(grp.Id);
                        bcnGSLst.add(grp);
                 }
                }
               list<GA_WFT_workflow__c> wfTepltBcn=[select id,Name,GA_Carrier__c,
                                                   GA_Method__c,GA_Process_Subtype__c,
                                                   GA_Process_Type__c from GA_WFT_workflow__c where 
                                                   GA_Process_Subtype__c =:BENEFITCHANGE and 
                                                   GA_Carrier__c=:ARV_AP41_StringLiteralUtils.BCNTYPE and 
                                                   GA_process_Type__c=:GWC and GA_Method__c=:NA limit 1];
            system.debug('wfTepltBcn:'+wfTepltBcn);
            
            

            if(wfTepltBcn.size()>0 && slectedGSBcn.size()>0){
             
            GA_WF_Workflow__c wfRecbcn=new GA_WF_Workflow__c(Name =  wfTepltBcn[0].GA_Process_Type__c + HYPHN + wfTepltBcn[0].GA_Process_Subtype__c + HYPHN + wfTepltBcn[0].GA_Method__c + HYPHN +Datetime.now().format( DATEFRMT),
                                                          GA_Account__c = accId,  
                                                          ARV_Enrollment_Contract__c=cntrcRecd.Id,
                                                          Sub_Type__c = wfTepltBcn[0].GA_Process_Subtype__c,
                                                          GA_Type__c = wfTepltBcn[0].GA_Process_Type__c,
                                                          GA_Carrier__c = wfTepltBcn[0].GA_Carrier__c,
                                                          GA_Method__c = wfTepltBcn[0].GA_Method__c,
                                                          //GA_Method__c='Manual',
                                                          GA_Workflow_Template__c = wfTepltBcn[0].Id,
                                                          GA_Status__c = OPNLBL,
                                                          GA_External_Initiated__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE,
                                                          GA_Selected_Group_Segments__c=string.join(slectedGSBcn, COMMAOP),
                                                          GA_Benefit_Effective_Date__c=bcnGSLst[0].GA_Benefit_Effective_Date__c,
                                                          GA_Date_Opened__c=system.today());
                system.debug('wfRecbcn::'+wfRecbcn);
            wfRecLst.add(wfRecbcn);
            } 
            }
			if(bcbslist.size()>0){
                for(GA_Group_Segment__c grp:bcbslist)
                {
                    if(grp.ARV_GWC_Type__c  == 'No Change'){
                       slectedGSBcbs.add(grp.Id);
                        bcbsGSLst.add(grp);
                    }
                               }
                list<GA_WFT_workflow__c> wfTepltBcbs=[select id,Name,GA_Carrier__c, GA_Method__c,GA_Process_Subtype__c,GA_Process_Type__c from 
                                                           GA_WFT_workflow__c where GA_Process_Subtype__c =:BLUCRSOS and GA_process_Type__c=:GWC and
                                                           GA_Method__c=:ARV_AP41_StringLiteralUtils.MANUL and 
                                                           GA_Carrier__c=:ARV_AP41_StringLiteralUtils.BCBSMVAL limit 1];
            system.debug('wfTepltBcbs:'+wfTepltBcbs); 
            
            
            
            if(wfTepltBcbs.size()>0 && slectedGSBcbs.size()>0){
             //cntrcRecd.status=ARV_AP41_StringLiteralUtils.MNLGWCPRC;
            GA_WF_Workflow__c wfRecbcbs=new GA_WF_Workflow__c(Name =  wfTepltBcbs[0].GA_Process_Type__c + HYPHN + wfTepltBcbs[0].GA_Process_Subtype__c + HYPHN + wfTepltBcbs[0].GA_Method__c + HYPHN +Datetime.now().format( DATEFRMT),
                                                          GA_Account__c = accId,  
                                                          ARV_Enrollment_Contract__c=cntrcRecd.Id,
                                                          Sub_Type__c = wfTepltBcbs[0].GA_Process_Subtype__c,
                                                          GA_Type__c = wfTepltBcbs[0].GA_Process_Type__c,
                                                          GA_Carrier__c = wfTepltBcbs[0].GA_Carrier__c,
                                                          GA_Method__c = wfTepltBcbs[0].GA_Method__c,
                                                          //GA_Method__c='Manual',
                                                          GA_Workflow_Template__c = wfTepltBcbs[0].Id,
                                                          GA_Status__c = OPNLBL,
                                                          GA_External_Initiated__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE,
                                                          GA_Selected_Group_Segments__c=string.join(slectedGSBcbs, COMMAOP),
                                                          GA_Benefit_Effective_Date__c=bcbsGSLst[0].GA_Benefit_Effective_Date__c,
                                                          GA_Date_Opened__c=system.today());
                system.debug('wfRecbcbs:;'+wfRecbcbs);
            wfRecLst.add(wfRecbcbs);
            }
            }
          
            
           
            creatContractNewwrkflow(wfRecLst, cntrcRecd);
            
            system.debug('retro con manl prcs');
            
        }
        catch(exception e)
        {
            system.debug('retro error::'+e.getLineNumber()+','+e.getMessage());
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CHTEMPRETROMETHDNME, cntrcRecd.Id);
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
            system.debug('grpLst:'+grpLst);
            List<string> slectedNewGS = new List<string> ();
            List<string> slectedBenefitChange = new List<string> ();
            List<GA_Group_Segment__c> newGSLst = new List<GA_Group_Segment__c> ();
            List<GA_Group_Segment__c> benefitChangeGsLst = new List<GA_Group_Segment__c> ();
            List<String> conTransNames = cntrcRecd.ARV_Tech_SystemCheck2__c.split(ARV_AP41_StringLiteralUtils.COMMAVAL);

            if(grpLst.size()>0){
                for(GA_Group_Segment__c grp:grpLst)
                {
                    //if(grp.GA_Carrier__c!='BCBSM'){
                    if(grp.ARV_GWC_Type__c  == ARV_AP41_StringLiteralUtils.PACKUPD){
                        system.debug('Benefit GS:'+grp.Id);
                        slectedBenefitChange.add(grp.Id);
                        benefitChangeGsLst.add(grp);
                    }
                    if(grp.ARV_GWC_Type__c == ARV_AP41_StringLiteralUtils.PACKADD){
                        system.debug('New GS:'+grp.Id);
                        slectedNewGS.add(grp.Id);
                        newGSLst.add(grp);
                    }
                 //}
                }
            }
            system.debug('newGSLst::'+newGSLst);
            system.debug('benefitChangeGsLst::'+benefitChangeGsLst);
            
            list<GA_WFT_workflow__c> wfTepltBenefitChange=[select id,Name,GA_Carrier__c,
                                                   GA_Method__c,GA_Process_Subtype__c,
                                                   GA_Process_Type__c from GA_WFT_workflow__c where 
                                                   GA_Process_Subtype__c =:BENEFITCHANGE and 
                                                   GA_Carrier__c=:ARV_AP41_StringLiteralUtils.BCNTYPE and 
                                                   GA_process_Type__c=:GWC and GA_Method__c=:NA limit 1];
            system.debug('wfTepltBenefitChange:'+wfTepltBenefitChange);
            list<GA_WFT_workflow__c> wfTepltNewGroupSegment=[select id,Name,GA_Carrier__c,
                                                 GA_Method__c,GA_Process_Subtype__c,
                                                 GA_Process_Type__c from GA_WFT_workflow__c where 
                                                 GA_Process_Subtype__c =:NEWGROUPSEGMENT
                                             and GA_Carrier__c=:ARV_AP41_StringLiteralUtils.BCNTYPE and GA_process_Type__c=:GWC and GA_Method__c=:NA limit 1];
            system.debug('wfTepltNewGroupSegment:'+wfTepltNewGroupSegment);
            List<GA_WF_Workflow__c> wfRecLst = new List<GA_WF_Workflow__c> ();

            if(wfTepltBenefitChange.size()>0 && slectedBenefitChange.size()>0){
            // cntrcRecd.status=ARV_AP41_StringLiteralUtils.MNLGWCPRC;
            GA_WF_Workflow__c wfRec=new GA_WF_Workflow__c(Name =  wfTepltBenefitChange[0].GA_Process_Type__c + HYPHN + wfTepltBenefitChange[0].GA_Process_Subtype__c + HYPHN + wfTepltBenefitChange[0].GA_Method__c + HYPHN +Datetime.now().format( DATEFRMT),
                                                          GA_Account__c = accId,  
                                                          ARV_Enrollment_Contract__c=cntrcRecd.Id,
                                                          Sub_Type__c = wfTepltBenefitChange[0].GA_Process_Subtype__c,
                                                          GA_Type__c = wfTepltBenefitChange[0].GA_Process_Type__c,
                                                          GA_Carrier__c = wfTepltBenefitChange[0].GA_Carrier__c,
                                                          GA_Method__c = wfTepltBenefitChange[0].GA_Method__c,
                                                          //GA_Method__c='Manual',
                                                          GA_Workflow_Template__c = wfTepltBenefitChange[0].Id,
                                                          GA_Status__c = OPNLBL,
                                                          GA_External_Initiated__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE,
                                                          GA_Selected_Group_Segments__c=string.join(slectedBenefitChange, COMMAOP),
                                                          GA_Benefit_Effective_Date__c=benefitChangeGsLst[0].GA_Benefit_Effective_Date__c,
                                                          GA_Date_Opened__c=system.today());
                system.debug('wfRec:;'+wfRec);
            wfRecLst.add(wfRec);
            }
            
            if(wfTepltNewGroupSegment.size()>0 && slectedNewGS.size()>0){
            GA_WF_Workflow__c wfRec=new GA_WF_Workflow__c(Name = wfTepltNewGroupSegment[0].GA_Process_Type__c +  HYPHN + wfTepltNewGroupSegment[0].GA_Process_Subtype__c + HYPHN + wfTepltNewGroupSegment[0].GA_Method__c + HYPHN +Datetime.now().format( DATEFRMT),
                                                          GA_Account__c = accId,  
                                                          ARV_Enrollment_Contract__c=cntrcRecd.Id,
                                                          Sub_Type__c = wfTepltNewGroupSegment[0].GA_Process_Subtype__c,
                                                          GA_Type__c = wfTepltNewGroupSegment[0].GA_Process_Type__c,
                                                          GA_Carrier__c = wfTepltNewGroupSegment[0].GA_Carrier__c,
                                                          GA_Method__c = wfTepltNewGroupSegment[0].GA_Method__c,
                                                          //GA_Method__c='Manual',
                                                          GA_Workflow_Template__c = wfTepltNewGroupSegment[0].Id,
                                                          GA_Status__c = OPNLBL,
                                                          GA_External_Initiated__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE,
                                                          GA_Selected_Group_Segments__c=string.join(slectedNewGS, COMMAOP),
                                                          GA_Benefit_Effective_Date__c=newGSLst[0].GA_Benefit_Effective_Date__c,
                                                          GA_Date_Opened__c=system.today());
            wfRecLst.add(wfRec);
            }
            system.debug('wfRecLst::'+wfRecLst);
            creatContractNewwrkflow(wfRecLst, cntrcRecd);
            
            system.debug('bcn con manl prcs');
        }
        catch(exception e)
        {system.debug('bcn error::'+e.getLineNumber()+','+e.getMessage());
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
                                               Contract cntrcRecd)
    {
        try{
                if(wfRecLst.size()>0){
                GA_WorkflowServiceCls.isExecuting=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                database.insert(wfRecLst);
               //cntrcRecd.status='Manual GWC Setup – Complete';
               system.debug('Workflow inserted');
               cntrcRecd.status=ARV_AP41_StringLiteralUtils.MNLGWCPRC;
            update cntrcRecd;
            }
        }
           
            /*List<Contract> cntrctRec = [select id,ARV_System_Check_1_Status__c from Contract where id=:cntrcRecdID limit 1];
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
        }*/
        catch(exception e){
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CREATCONTRACTWRKFLOWMETHDNME, cntrcRecd.Id);
            ARV_AP59_CreateGroupSegmentRecords.errorOccured = ARV_AP41_StringLiteralUtils.TRUE_VALUE;
            system.debug('Linenumber1'+e.getLineNumber());
            system.debug('Errormes1'+e.getMessage());
        }
        
    }
    
        /**
@Description: checkTemplatebcbs() method 
@Name : checkTemplate
@Param : List<GA_Group_SEgment__C> , Contract ,account 
@Return : void
@throws Exception : N/A
*/   
    public static void checkTemplatebcbs(List<GA_Group_Segment__C> grpLst, Contract cntrcRecd,string accId){
        try{
            system.debug('grpLst:'+grpLst);
            List<string> slectedNewGS = new List<string> ();
            List<string> slectedBenefitChange = new List<string> ();
            List<GA_Group_Segment__c> newGSLst = new List<GA_Group_Segment__c> ();
            List<GA_Group_Segment__c> benefitChangeGsLst = new List<GA_Group_Segment__c> ();

            if(grpLst.size()>0){
                for(GA_Group_Segment__c grp:grpLst)
                {
                    //if(grp.GA_Carrier__c!='BCBSM'){
                    if(grp.ARV_GWC_Type__c  ==ARV_AP41_StringLiteralUtils.PACKUPD){
                        system.debug('Benefit GS:'+grp.Id);
                        slectedBenefitChange.add(grp.Id);
                        benefitChangeGsLst.add(grp);
                    }
                    if(grp.ARV_GWC_Type__c == ARV_AP41_StringLiteralUtils.PACKADD){
                        system.debug('New GS:'+grp.Id);
                        slectedNewGS.add(grp.Id);
                        newGSLst.add(grp);
                    }
                 //}
                }
            }
            system.debug('newGSLstbcbsm::'+newGSLst);
            system.debug('benefitChangeGsLstbcbsm::'+benefitChangeGsLst);
            
            list<GA_WFT_workflow__c> wfTepltBenefitChange=[select id,Name,GA_Carrier__c, GA_Method__c,GA_Process_Subtype__c,GA_Process_Type__c from 
                                                           GA_WFT_workflow__c where GA_Process_Subtype__c =:BLUCRSOS and GA_process_Type__c=:GWC and
                                                           GA_Method__c=:ARV_AP41_StringLiteralUtils.MANUL and 
                                                           GA_Carrier__c=:ARV_AP41_StringLiteralUtils.BCBSMVAL limit 1];
            system.debug('wfTepltBenefitChangebcbsm:'+wfTepltBenefitChange);
            list<GA_WFT_workflow__c> wfTepltNewGroupSegment=[select id,Name,GA_Carrier__c,
                                                 GA_Method__c,GA_Process_Subtype__c,
                                                 GA_Process_Type__c from GA_WFT_workflow__c where 
                                                  GA_Process_Subtype__c=:NEWGROUPSEGMENT and GA_process_Type__c=:GWC and GA_Method__c=:ARV_AP41_StringLiteralUtils.MANUL
                                                  and GA_Carrier__c=:ARV_AP41_StringLiteralUtils.BCBSMVAL limit 1];
            system.debug('wfTepltNewGroupSegmentbcbsm:'+wfTepltNewGroupSegment);
            List<GA_WF_Workflow__c> wfRecLst = new List<GA_WF_Workflow__c> ();

            if(wfTepltBenefitChange.size()>0 && slectedBenefitChange.size()>0){
            //cntrcRecd.status=ARV_AP41_StringLiteralUtils.MNLGWCPRC;  
            GA_WF_Workflow__c wfRec=new GA_WF_Workflow__c(Name =  wfTepltBenefitChange[0].GA_Process_Type__c + HYPHN + wfTepltBenefitChange[0].GA_Process_Subtype__c + HYPHN + wfTepltBenefitChange[0].GA_Method__c + HYPHN +Datetime.now().format( DATEFRMT),
                                                          GA_Account__c = accId,  
                                                          ARV_Enrollment_Contract__c=cntrcRecd.Id,
                                                          Sub_Type__c = wfTepltBenefitChange[0].GA_Process_Subtype__c,
                                                          GA_Type__c = wfTepltBenefitChange[0].GA_Process_Type__c,
                                                          GA_Carrier__c = wfTepltBenefitChange[0].GA_Carrier__c,
                                                          GA_Method__c = wfTepltBenefitChange[0].GA_Method__c,
                                                          //GA_Method__c='Manual',
                                                          GA_Workflow_Template__c = wfTepltBenefitChange[0].Id,
                                                          GA_Status__c = OPNLBL,
                                                          GA_External_Initiated__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE,
                                                          GA_Selected_Group_Segments__c=string.join(slectedBenefitChange, COMMAOP),
                                                          GA_Benefit_Effective_Date__c=benefitChangeGsLst[0].GA_Benefit_Effective_Date__c,
                                                          GA_Date_Opened__c=system.today());
                system.debug('wfRec:;'+wfRec);
            wfRecLst.add(wfRec);
            }
            
            if(wfTepltNewGroupSegment.size()>0 && slectedNewGS.size()>0){
            GA_WF_Workflow__c wfRec=new GA_WF_Workflow__c(Name = wfTepltNewGroupSegment[0].GA_Process_Type__c +  HYPHN + wfTepltNewGroupSegment[0].GA_Process_Subtype__c + HYPHN + wfTepltNewGroupSegment[0].GA_Method__c + HYPHN +Datetime.now().format( DATEFRMT),
                                                          GA_Account__c = accId,  
                                                          ARV_Enrollment_Contract__c=cntrcRecd.Id,
                                                          Sub_Type__c = wfTepltNewGroupSegment[0].GA_Process_Subtype__c,
                                                          GA_Type__c = wfTepltNewGroupSegment[0].GA_Process_Type__c,
                                                          GA_Carrier__c = wfTepltNewGroupSegment[0].GA_Carrier__c,
                                                          GA_Method__c = wfTepltNewGroupSegment[0].GA_Method__c,
                                                          //GA_Method__c='Manual',
                                                          GA_Workflow_Template__c = wfTepltNewGroupSegment[0].Id,
                                                          GA_Status__c = OPNLBL,
                                                          GA_External_Initiated__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE,
                                                          GA_Selected_Group_Segments__c=string.join(slectedNewGS, COMMAOP),
                                                          GA_Benefit_Effective_Date__c=newGSLst[0].GA_Benefit_Effective_Date__c,
                                                          GA_Date_Opened__c=system.today());
            wfRecLst.add(wfRec);
            }
            system.debug('wfRecLst::'+wfRecLst);
            creatContractNewwrkflow(wfRecLst, cntrcRecd);
            
            system.debug('bcbs con manl prcs');
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CHTEMPBCBSMETHDNME, cntrcRecd.Id);
            system.debug('linenumber3'+e.getLineNumber());
            system.debug('MSg3'+e.getMessage());
        }
    }
}