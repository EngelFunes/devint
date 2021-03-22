/*****************************************************************************************
Class Name   : GA_WorkflowGroStpSaveCls
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to assign the GS ownership
******************************************************************************************/
public with sharing  class GA_WorkflowGroStpSaveCls {
    
    public static final string selectQuery='select id,GA_Workflow_ID__r.GA_Account__r.id,GA_Workflow_ID__r.GA_Account__r.Name,'+
        'GA_Workflow_ID__r.GA_Support__r.id,GA_Workflow_ID__r.GA_Support__r.CaseNumber,GA_Workflow_ID__r.GA_Benefit_Effective_Date__c,GA_Workflow_ID__r.GA_Corporate_Received_Date__c,'+
        'GA_WF_Step_ID__c,GA_Group_Segment_ID__c,GA_WF_Step_ID__r.id,GA_WF_Step_ID__r.GA_Notes__c,GA_WF_Step_ID__r.Name,GA_Workflow_ID__r.Name,GA_Status__c,'+
        'GA_WF_Step_ID__r.GA_WF_Template_Step__c,GA_Workflow_ID__c,GA_Workflow_ID__r.GA_Workflow_Owner_Role__c,'+
        'GA_Date_Opened__c,owner.Name,ownerid,GA_Workflow_ID__r.ARV_Enrollment_Contract__c,GA_Workflow_ID__r.ARV_Enrollment_Contract__r.ContractNumber,GA_Workflow_ID__r.GA_Account_Benefit_Review__c,GA_Workflow_ID__r.GA_Account_Benefit_Review__r.Name'+
        ',GA_WF_Step_ID__r.GA_WF_Template_Step__r.GA_Role__c,GA_WF_Step_ID__r.GA_WF_Template_Step__r.GA_Department__c,'+
        'GA_Date_Closed__c,GA_Quote_ID__c,GA_Group_Segment_Name__c, GA_Processed_By__c,GA_Tracking_Status__c,GA_Problem_Identified_Values__c,GA_Work_Type__c,	GA_Other_please_specify__c,'+
        '   GA_Notes__c '+
        'FROM GA_WF_Group_Segment__c where';
    public static final string whereClause=' id in ';
    public static final string limitClause=' limit 10';
    public static final String SelectwfgsQury = 'SELECT Id, GA_Workflow_ID__c, GA_Group_Segment_ID__c,  GA_WF_Step_ID__c ,GA_WF_Process_Owner_Initial__c,'+
        'GA_Workflow_Next_Step__c,GA_Workflow_Next_Step__r.GA_WF_Template_Step__c,GA_Workflow_Next_Step__r.GA_Status__c  FROM GA_WF_Group_Segment__c ';
    public static final String whrWfgsQry = ' WHERE GA_Workflow_ID__c = ';
    public static final String whrWfgsStp = ' WHERE GA_WF_Step_ID__c = ';
    public static final String WFGSWhereGrpSgmntId = ' AND GA_Group_Segment_ID__c IN ';
    public static final String WFGSWhereWFNxtStp = ' AND GA_Workflow_Next_Step__c = ';
    public static final string  whrstpname =' where GA_WF_Step_ID__r.Name =';
    public static final string  whrwfidname =' and GA_Workflow_ID__c= ';
    public static final String wfgslimit = ' limit 2000 ';
    
    public static final string wfgsObject = 'GA_WF_Group_Segment__c';
    public static final string trackStsFld = 'GA_Tracking_Status__c';
    public static final string probIdnFld = 'GA_Problem_Identified_Values__c';
    public static final string noneStr = '-None-';
    public static final string blankStr = '';
    public static final string ftchWfStpname = 'fetchwrkStpGSDetails';
    public static final string updtGrpSgmmthd = 'updateWKGrpSgmnts';
    public static final string chkqueInfoMthd = 'nextStepQueueInfoWFGS';
    public static final String ErrorMsg = 'There is some problem in fetching data';
    public static final string savenext = 'savenext';
    public static final string ClsName = 'GA_WorkflowGroStpSaveCls';
    public static final String excepSepartr=': ';
    public static final String WFStpSelectQuery = 'SELECT Id,Name,GA_WF_Workflow_ID__c,GA_Work_Type__c,GA_WF_Workflow_ID__r.GA_Workflow_Owner_Role__c,GA_WF_Template_Step__c,GA_WF_Template_Step__r.GA_WFT_Inventory_Step_ID__r.Name,'+
        ' GA_WF_Workflow_ID__r.GA_Workflow_Template__c,OwnerId,GA_Status__c,GA_Notes__c FROM GA_WF_Step__c ';
    
    public static final String WFStpWhereQuery = ' WHERE Id = ';
    public static final string whrwfid =  ' where GA_WF_Workflow_ID__c = ';
    public static final string whrstpsts = ' and GA_Status__c = ' ;
    public static final String WFStplimit = ' limit 200';
    public static final String WFTStpSelQuery = 'SELECT Id, Name, GA_WFT_Inventory_Step_ID__r.Name FROM GA_WFT_Step__c';
    public static final String WFTStpwhereQuery = ' WHERE Id = ';  
    public static final String WFTStpLimit = ' limit 1000 '; 
    public static final string cmpStr = 'Completed';
    public static final string clsd = 'Closed';
    public static final string Opn = 'Open';
    public static final string queuePrfix = '00G';
    public static final String nullStr = 'NULL';
    public static final String notifyUseAssignedWFSTpMtd = 'notifyUseAssignedWFSTp';
    public static final String errMsgShowMthd='errMsgShow';
    public static final String stepNameRecMthd='stepNameRec';
    public static final String BLANK = '';
    public static final String abrTmplt = 'BCBSM - N/A - ABR - N/A';
    public static final String wrkTypeVal='GA_Work_Type__c';    
    public static final String otherPIDVal='GA_Other_please_specify__c';   
    public static TimeZone tz = UserInfo.getTimeZone();
    public static Datetime currenttime = system.now();
    private static final Datetime myDT = Datetime.now();
    private static final String myDate = myDT.format('MM/dd/yyyy h:mm:ss a');
    private static final String sPace = ' ';
    private static final String coMma = ',';
    
    /**
@Description: fetchwrkStpGSDetails() method 
@Name : fetchwrkStpGSDetails
@Param : list<id> wfGrpIdLst
@Return : list<wrkflwGrpSgmntWrp>
@throws Exception : AuraHandledException;
*/    
    @AuraEnabled    
    public static list<wrkflwGrpSgmntWrp> fetchwrkStpGSDetails(list<id> wfGrpIdLst)
    {
        try{ 
            
            if(!wfGrpIdLst.isEmpty()){
                set<id> wfGrpIds=new set<id>();
                wfGrpIds.addAll(wfGrpIdLst);
                string wfGrpIdString=GA_Util08_FilterProcessHelper.idSet(wfGrpIds);
                
                List<GA_WF_Group_Segment__c> wfgsLst = GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(selectQuery,whereClause+wfGrpIdString,GA_Util15_WFGSDataAccesHelper.BLANK,limitClause).values();
                User usr=GA_Util08_FilterProcessHelper.fetchUsrDtls(Userinfo.getUserId());
                
                //to fetch the object picklist values
                sObject sObj = Schema.getGlobalDescribe().get(wfgsObject).newSObject() ;        
                List<String> trackingStatus = GA_AP06_fetchPicklistValues.getselectOptions(sObj, trackStsFld);
                List<String> problemIdentified = GA_AP06_fetchPicklistValues.getselectOptions(sObj, probIdnFld);
                List<String> wrkTypeValues = GA_AP06_fetchPicklistValues.getselectOptions(sObj, wrkTypeVal); 
                List<String> otherPIDValues = GA_AP06_fetchPicklistValues.getselectOptions(sObj, otherPIDVal);
                
                list<GA_WFT_Allowed_Next_Step__c> nxtsteps =WorkflowController.retrieveNextSteps(wfgsLst[0].GA_WF_Step_ID__c);// GA_AP_02_WkflwstepDetmntion.wfallwdSteps(wfgsLst[0].GA_WF_Step_ID__r.GA_WF_Template_Step__c);
                list<GA_WF_Group_Segment__c> wfGrps = WorkflowController.retrieveCurrentStepGroupSegments(wfgsLst[0].GA_WF_Step_ID__c);
                
                wrkflwGrpSgmntWrp wfgswrapper = New wrkflwGrpSgmntWrp(wfgsLst[0],usr,trackingStatus,problemIdentified,wfgsLst[0].GA_Tracking_Status__c,
                                                                      wfgsLst[0].GA_Problem_Identified_Values__c,nxtsteps,
                                                                      wfgsLst[0].GA_Work_Type__c,wrkTypeValues,otherPIDValues,
                                                                      wfgsLst[0].GA_Other_please_specify__c,wfGrps );
                list<wrkflwGrpSgmntWrp> wfgswrapperLst=new list<wrkflwGrpSgmntWrp>();
                wfgswrapperLst.add(wfgswrapper);
                
                return wfgswrapperLst;
            }
            else{
                return null; 
            }
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, ftchWfStpname);
            throw new AuraHandledException(System.Label.GA_WFGSDetailError+excepSepartr+e.getMessage()); 
        }
        
    }
    /**
@Description: updateWKGrpSgmnts() method 
@Name : updateWKGrpSgmnts
@Param : list<id> wfGrpIdsTmpLst,GA_WF_Group_Segment__c grpData
@Return : none
@throws Exception : AuraHandledException;
*/   
    @AuraEnabled
    public static void updateWKGrpSgmnts(list<id> wfGrpIdsTmpLst,GA_WF_Group_Segment__c grpData)
    {
        try{
            if(!wfGrpIdsTmpLst.isEmpty()){
                set<id> wfGrpIds=new set<id>();
                wfGrpIds.addAll(wfGrpIdsTmpLst);
                String grpNames = BLANK;
                string wfGrpIdString=GA_Util08_FilterProcessHelper.idSet(wfGrpIds);
                
                List<GA_WF_Group_Segment__c> WKGrpSgmnts = GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(selectQuery,whereClause+wfGrpIdString,GA_Util15_WFGSDataAccesHelper.BLANK,limitClause).values();
                
                list<GA_WF_Group_Segment__c> WKGrpSgmntsToUpdate=new list<GA_WF_Group_Segment__c>();
                for(GA_WF_Group_Segment__c wrkGrpSgmnt:WKGrpSgmnts)
                { 
                    String trkStsVal = grpData.GA_Tracking_Status__c;
                    String problmIdenVal = grpData.GA_Problem_Identified_Values__c;
                    String wrkTypeVal = grpData.GA_Work_Type__c;
                    String otherProbIdentifiedVal = grpData.GA_Other_please_specify__c;
                    if(trkStsVal !=null && !trkStsVal.equalsIgnoreCase(noneStr))
                    {
                        wrkGrpSgmnt.GA_Tracking_Status__c=grpData.GA_Tracking_Status__c;
                    }
                    else
                    {
                        wrkGrpSgmnt.GA_Tracking_Status__c=blankStr;
                    }
                    if(problmIdenVal !=null && !problmIdenVal.equalsIgnoreCase(noneStr))
                    {
                        wrkGrpSgmnt.GA_Problem_Identified_Values__c=grpData.GA_Problem_Identified_Values__c;
                    }
                    else
                    {
                        wrkGrpSgmnt.GA_Problem_Identified_Values__c=blankStr;
                    }
                    if(wrkTypeVal !=null && !wrkTypeVal.equalsIgnoreCase(noneStr))
                    {
                        wrkGrpSgmnt.GA_Work_Type__c=grpData.GA_Work_Type__c;
                    }
                    else
                    {
                        wrkGrpSgmnt.GA_Work_Type__c=blankStr;
                    }
                    if(otherProbIdentifiedVal !=null && !otherProbIdentifiedVal.equalsIgnoreCase(noneStr))
                    {
                        wrkGrpSgmnt.GA_Other_please_specify__c=grpData.GA_Other_please_specify__c;
                    }
                    else
                    {
                        wrkGrpSgmnt.GA_Other_please_specify__c=blankStr;
                    }
                    wrkGrpSgmnt.GA_Notes__c=    myDate +sPace+ userinfo.getName()+sPace+ wrkGrpSgmnt.GA_Group_Segment_Name__c +  sPace + grpData.GA_Notes__c +' \r\n'+ (wrkGrpSgmnt.GA_Notes__c <>null ?'\n' + wrkGrpSgmnt.GA_Notes__c  : BLANK)  ; //grpData.GA_Notes__c;
                    grpNames = grpNames + wrkGrpSgmnt.GA_Group_Segment_Name__c+ coMma;
                    wrkGrpSgmnt.OwnerId=userinfo.getUserId();
                    WKGrpSgmntsToUpdate.add(wrkGrpSgmnt);
                }
                
                
                GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(WKGrpSgmntsToUpdate,GA_Util15_WFGSDataAccesHelper.UPDATE_OPERATION);
                if(WKGrpSgmnts.size()>0)
                {
                    GA_WF_Step__c wfStp=new GA_WF_Step__c();
                    wfStp.id=WKGrpSgmnts[0].GA_WF_Step_ID__c; 
                    String stptrkStsVal = grpData.GA_Tracking_Status__c;
                    String stpproblmIdenVal = grpData.GA_Problem_Identified_Values__c;
                    String stpwrkTypeVal = grpData.GA_Work_Type__c;
                    String stpotherProbIdentifiedVal = grpData.GA_Other_please_specify__c;
                    if(stptrkStsVal !=null && !stptrkStsVal.equalsIgnoreCase(noneStr))
                    {
                        wfStp.GA_Tracking_Status__c=grpData.GA_Tracking_Status__c;
                    }
                    else
                    {
                        wfStp.GA_Tracking_Status__c=blankStr;
                    }
                    if(stpproblmIdenVal !=null && !stpproblmIdenVal.equalsIgnoreCase(noneStr))
                    {
                        wfStp.GA_Problem_Identified_Values__c=grpData.GA_Problem_Identified_Values__c;
                    }
                    else
                    {
                        wfStp.GA_Problem_Identified_Values__c=blankStr;
                    }
                    if(stpwrkTypeVal !=null && !stpwrkTypeVal.equalsIgnoreCase(noneStr))
                    {
                        wfStp.GA_Work_Type__c=grpData.GA_Work_Type__c;
                    }
                    else
                    {
                        wfStp.GA_Work_Type__c=blankStr;
                    }
                    if(stpotherProbIdentifiedVal !=null && !stpotherProbIdentifiedVal.equalsIgnoreCase(noneStr))
                    {
                        wfStp.GA_Other_please_specify__c=grpData.GA_Other_please_specify__c;
                    }
                    else
                    {
                        wfStp.GA_Other_please_specify__c=blankStr;
                    }
                    wfStp.GA_Notes__c=myDate + sPace + userinfo.getName() + sPace + grpNames.removeEnd(coMma)+ sPace+ grpData.GA_Notes__c+' \r\n' + (WKGrpSgmnts[0].GA_WF_Step_ID__r.GA_Notes__c <>null ?'\n' + WKGrpSgmnts[0].GA_WF_Step_ID__r.GA_Notes__c  : BLANK) ;// objCurrentWorkFlowStep.GA_Notes__c ;;
            //grpData.GA_Notes__c;
                    database.update(wfStp);
                }
                
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, updtGrpSgmmthd);
            throw new AuraHandledException(System.Label.GA_WFGSDetailError+excepSepartr+e.getMessage()); 
        }
    }
    /**
@Description: saveNextStep() method 
@Name : saveNextStep
@Param : Id currentWorkflowStepId, Id selectedWorkFlowTemplateStepId, 
string selectedWorkFlowStepName, List<String> lstGroupSegments,
list<String> wfGrpIdsTmpLst,GA_WF_Group_Segment__c grpData
@Return : Id
@throws Exception : AuraHandledException;
*/ 
    @AuraEnabled
    public static Id saveNextStep(Id currentWorkflowStepId, Id selectedWorkFlowTemplateStepId, string selectedWorkFlowStepName, List<String> lstGroupSegments,list<String> wfGrpIdsTmpLst,GA_WF_Group_Segment__c grpData,string assGnOwnr,boolean sendMailVal,String notes){
        try{
            
            GA_WF_Step__c objNextWorkFlowStep =New GA_WF_Step__c();
            String ownId = '';
            String NxtWFStpId = '';  
            Boolean nxtStpsExists = false;        
            list<GA_WF_Group_Segment__c> lstWFStepGroupSegments = new list<GA_WF_Group_Segment__c>();
            String grpNames = BLANK;
            if(lstGroupSegments.isEmpty()){
                
                GA_WF_Group_Segment__c wfGSRecord = [Select id,GA_Group_Segment_ID__c from  GA_WF_Group_Segment__c where id in: wfGrpIdsTmpLst Limit 1];  
                lstGroupSegments.add(wfGSRecord.GA_Group_Segment_ID__c);
            }
            // To-do refactor the code so that we don't need to execute below SOQL to get the Workflow Id based on the step Id
            GA_WF_Step__c objCurrentWorkFlowStep = GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(WFStpSelectQuery,
                                                                                                           WFStpWhereQuery + GA_Util08_FilterProcessHelper.FltrString(currentWorkflowStepId), 
                                                                                                           GA_Util03_WrkflwStpDataAccessHelper.BLANK,
                                                                                                           WFStplimit).values();
            
           //added to capture parent workflow process
            map<id,id> GSParentWFPrcssMap=workflowController.fetchParentWEFPrcess(objCurrentWorkFlowStep.GA_WF_Workflow_ID__c);
           GA_WFT_Step__c objNextWorkFlowTemplateStep = GA_Util14_WFStepTmpltDataAccesHelper.fetchwrkflowStpTmpsMap(WFTStpSelQuery, WFTStpwhereQuery+ GA_Util08_FilterProcessHelper.FltrString(selectedWorkFlowTemplateStepId), GA_Util14_WFStepTmpltDataAccesHelper.BLANK, WFTStpLimit).values();
            
            
            
            //To check if NextStep is already created  on currrently         
            list<GA_WF_Group_Segment__c> lstCurrentWFStepGroupSegments = GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SelectwfgsQury,whrWfgsQry+ GA_Util08_FilterProcessHelper.FltrString(objCurrentWorkFlowStep.GA_WF_Workflow_ID__c),GA_Util15_WFGSDataAccesHelper.BLANK,wfgslimit).values();
            
            String nxtStpTmpName = objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name ;
            //if(!nxtStpTmpName.equalsIgnoreCase(cmpStr) )
            {
                for(id grpid:lstGroupSegments)
                {
                    for(GA_WF_Group_Segment__c wfgst : lstCurrentWFStepGroupSegments){
                        
                        if(wfgst.GA_Workflow_Next_Step__r.GA_WF_Template_Step__c == selectedWorkFlowStepName 
                           && (wfgst.GA_Workflow_Next_Step__r.GA_Status__c =='Open' || nxtStpTmpName.equalsIgnoreCase(cmpStr))
                          ){
                              
                              if(grpid==wfgst.GA_Group_Segment_ID__c)
                              {
                                  nxtStpsExists = false;
                                  break;
                              }
                              NxtWFStpId = wfgst.GA_Workflow_Next_Step__c;  
                              nxtStpsExists = true;   
                          }
                    }
                    if(!nxtStpsExists)
                    {
                        break;
                    }
                }
            }
            
            if(nxtStpsExists){
                if(nxtStpTmpName.equalsIgnoreCase(cmpStr))
                {
                    GA_WF_Step__c wfStpCmp=new GA_WF_Step__c(); 
                    wfStpCmp.Id=NxtWFStpId;
                    wfStpCmp.GA_End_Time__c=currenttime;
                    database.update(wfStpCmp);
                }
                for(string groupSegmentIds : lstGroupSegments){
                    for(GA_WF_Group_Segment__c wfgst : lstCurrentWFStepGroupSegments){
                        if(wfgst.GA_WF_Step_ID__c==currentWorkflowStepId){
                            if(wfgst.GA_Group_Segment_ID__c == groupSegmentIds ){
                                wfgst.GA_Workflow_Next_Step__c = NxtWFStpId;
                                wfgst.GA_Date_Closed__c = currenttime;
                                wfgst.GA_Status__c = clsd;
                                wfgst.OwnerId=userinfo.getUserId();
                                lstWFStepGroupSegments.add(wfgst);  
                            }
                        }
                    }
                    
                }
                
                objNextWorkFlowStep = new GA_WF_Step__c(id  = NxtWFStpId); 
                if( String.isBlank(ownId)) {
                    ownId =  Userinfo.getUserId();}
            }
            else {
                
                
                if(wrkTypeVal !=null && !wrkTypeVal.equalsIgnoreCase(noneStr))
                    // To-do refactor the code so that we don't have to get the template step Name, might be use the work flow to set it.
                    objNextWorkFlowStep = new GA_WF_Step__c(Name = objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name, //selectedWorkFlowStepName,
                                                            GA_WF_Workflow_ID__c = objCurrentWorkFlowStep.GA_WF_Workflow_ID__c,
                                                            GA_WF_Template_Step__c = selectedWorkFlowTemplateStepId,
                                                            GA_Start__c = currenttime,
                                                            
                                                            GA_Status__c = Opn);
                if(grpData.GA_Work_Type__c !=null && !grpData.GA_Work_Type__c.equalsIgnoreCase(noneStr))
                {
                    objNextWorkFlowStep.GA_Work_Type__c = grpData.GA_Work_Type__c;
                }
                else
                {
                    objNextWorkFlowStep.GA_Work_Type__c=blankStr;
                }
                if( String.isBlank(ownId)) {
                    ownId =  Userinfo.getUserId();
                    objNextWorkFlowStep.ownerId = Userinfo.getUserId();
                }
                else{
                    objNextWorkFlowStep.ownerId = Userinfo.getUserId();
                }
                
                if(nxtStpTmpName.equalsIgnoreCase(cmpStr))
                {
                    objNextWorkFlowStep.GA_Status__c=clsd;
                    objNextWorkFlowStep.GA_End_Time__c=currenttime;
                }
                
                List<GA_WF_Step__c> wfStpLst = New List<GA_WF_Step__c>();
                wfStpLst.add(objNextWorkFlowStep); 
                GA_Util03_WrkflwStpDataAccessHelper.dmlOnwrkflwstp(wfStpLst,GA_Util03_WrkflwStpDataAccessHelper.INSERT_OPERATION);
                
                //insert objNextWorkFlowStep;
                
                set<id> wkflwGSStpIdSet=new set<id>();
                
                for(String wfgid : lstGroupSegments){
                    wkflwGSStpIdSet.add(wfgid); 
                }
                
                List<GA_WF_Group_Segment__c> wfgslst =  GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SelectwfgsQury,whrWfgsStp+ GA_Util08_FilterProcessHelper.FltrString(currentWorkflowStepId)+ WFGSWhereGrpSgmntId+GA_Util08_FilterProcessHelper.idSet(wkflwGSStpIdSet) ,GA_Util15_WFGSDataAccesHelper.BLANK,wfgslimit).values();
                
                for(GA_WF_Group_Segment__c objWFGroupSegment : wfgslst ){
                    
                    objWFGroupSegment.GA_Workflow_Next_Step__c = objNextWorkFlowStep.Id;
                    lstWFStepGroupSegments.add(objWFGroupSegment);
                    
                }// end of for-each
                
            }
            //query GA_WF_Group_Segment__c related to lstGroupSegments and workflowid is current workflow
            list<GA_WF_Group_Segment__c> wfGrpSgmntLst=GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SelectwfgsQury,whrstpname+ GA_Util08_FilterProcessHelper.FltrString(nxtStpTmpName) + whrwfidname + GA_Util08_FilterProcessHelper.FltrString(objCurrentWorkFlowStep.GA_WF_Workflow_ID__c) ,GA_Util15_WFGSDataAccesHelper.BLANK,wfgslimit).values();
            
            set<id> grpSgmntId=new set<id>();
            for(GA_WF_Group_Segment__c grpSgmnt:wfGrpSgmntLst)
            {
                grpSgmntId.add(grpSgmnt.GA_Group_Segment_ID__c);
            }
            list<GA_WF_Group_Segment__c> lstWFStepGroupSegmentsNew=new list<GA_WF_Group_Segment__c>();
            list<GA_Group_Segment__c> grpRemoveInprgrssLst=new list<GA_Group_Segment__c>();
            for(string groupSegmentIds : lstGroupSegments){
                GA_WF_Group_Segment__c WFgrpSgmnt=new GA_WF_Group_Segment__c();
                WFgrpSgmnt.GA_Workflow_ID__c=  objCurrentWorkFlowStep.GA_WF_Workflow_ID__c;
                WFgrpSgmnt.GA_Group_Segment_ID__c = groupSegmentIds;
                WFgrpSgmnt.GA_WF_Step_ID__c = objNextWorkFlowStep.Id;
                WFgrpSgmnt.GA_Parent_WF_Process__c=GSParentWFPrcssMap.get(groupSegmentIds);
                WFgrpSgmnt.GA_Date_Opened__c =currenttime;
                if(grpData.GA_Work_Type__c !=null && !grpData.GA_Work_Type__c.equalsIgnoreCase(noneStr))
                {
                    WFgrpSgmnt.GA_Work_Type__c = grpData.GA_Work_Type__c;
                }
                else
                {
                    WFgrpSgmnt.GA_Work_Type__c=blankStr;
                }
                if(assGnOwnr != BLANK)
                {
                    WFgrpSgmnt.OwnerId= assGnOwnr; 
                }
                else
                    WFgrpSgmnt.OwnerId = ownId;
                
                list<GA_WF_Group_Segment__c> extngWFGS = [select Id,Name,GA_Group_Segment_ID__c,GA_Workflow_ID__c,GA_Status__c,GA_Workflow_ID__r.GA_Workflow_Template_Name__c from GA_WF_Group_Segment__c where GA_Workflow_ID__c !=: (objCurrentWorkFlowStep.GA_WF_Workflow_ID__c) and GA_Group_Segment_ID__c IN: lstGroupSegments and GA_Status__c =:Opn and GA_Workflow_ID__r.GA_Workflow_Template_Name__c !=: abrTmplt limit 500];
                
                Map<string,string> wfGSMap = new Map<string,string> (); 
                for(GA_WF_Group_Segment__c wfgs : extngWFGS){
                    wfGSMap.put(wfgs.GA_Group_Segment_ID__c,wfgs.GA_Workflow_ID__c);
                }
                
                if(nxtStpTmpName.equalsIgnoreCase(cmpStr) )
                {
                    WFgrpSgmnt.GA_Date_Closed__c=currenttime;
                    WFgrpSgmnt.GA_Status__c=clsd;
                    
                    
                    GA_Group_Segment__c gtpTmp=new GA_Group_Segment__c();
                    gtpTmp.Id=groupSegmentIds;
                     if(!wfGSMap.keySet().contains(groupSegmentIds))
                    {  
                    gtpTmp.GA_In_Progress__c=false;
                    gtpTmp.GA_In_Progress_Type__c='';
                    gtpTmp.GA_Is_Mass_Updating__c=True;
                    grpRemoveInprgrssLst.add(gtpTmp);
                    }
                    
                }
                if(grpSgmntId.contains(groupSegmentIds))
                {
                    WFgrpSgmnt.GA_Return_to_Step_Chk__c=true; 
                    WFgrpSgmnt.GA_Return_to_Step_Count__c=system.Math.floor((wfGrpSgmntLst.size()/grpSgmntId.size()))+1;
                }
                lstWFStepGroupSegmentsNew.add(WFgrpSgmnt);
                
            }// end of for-each
            list<GA_WF_Group_Segment__c> lstWFStepGroupSegmentstoInsrt = new list<GA_WF_Group_Segment__c>();
            //for(id grpSgmnt:wfGrpIdsTmpLst)
            for(GA_WF_Group_Segment__c objWFGroupSegment : [SELECT Id, GA_Workflow_ID__c, GA_Group_Segment_ID__c, GA_Quote_ID__c,  GA_WF_Step_ID__c, GA_Workflow_Next_Step__c, 
                                                               GA_Group_Segment_Name__c,GA_Notes__c FROM GA_WF_Group_Segment__c 
                                                                WHERE id IN :wfGrpIdsTmpLst Limit 200])
               
          
            {
                    lstWFStepGroupSegmentstoInsrt.add(new GA_WF_Group_Segment__c(
                    id=objWFGroupSegment.id,
                    GA_Date_Closed__c=currenttime,
                    GA_Status__c=clsd,
                    GA_Tracking_Status__c=grpData.GA_Tracking_Status__c,
                    GA_Problem_Identified_Values__c=grpData.GA_Problem_Identified_Values__c==noneStr ?blankStr:grpData.GA_Problem_Identified_Values__c,
                    GA_Work_Type__c=grpData.GA_Work_Type__c==noneStr ?blankStr:grpData.GA_Work_Type__c,
                    GA_Other_please_specify__c = grpData.GA_Other_please_specify__c==noneStr ?blankStr:grpData.GA_Other_please_specify__c,
                
                    GA_Notes__c= myDate +sPace+ userinfo.getName()+sPace+ objWFGroupSegment.GA_Group_Segment_Name__c +  sPace + 
                    grpData.GA_Notes__c +' \r\n'+ (objWFGroupSegment.GA_Notes__c <>null ?'\n' + objWFGroupSegment.GA_Notes__c  : ''), //grpData.GA_Notes__c; 
                    //grpData.GA_Notes__c,
                    OwnerId=userinfo.getUserId()
                ));
                grpNames = grpNames + objWFGroupSegment.GA_Group_Segment_Name__c+ coMma;
            }
            if(wfGrpIdsTmpLst.size()>0)
            {
                GA_WF_Step__c wfStp=new GA_WF_Step__c();
                wfStp.id=objCurrentWorkFlowStep.Id; 
                String stptrkStsVal = grpData.GA_Tracking_Status__c;
                String stpproblmIdenVal = grpData.GA_Problem_Identified_Values__c;
                String stpwrkTypeVal = grpData.GA_Work_Type__c;
                String stpotherProbIdentifiedVal = grpData.GA_Other_please_specify__c;
                if(stptrkStsVal !=null && !stptrkStsVal.equalsIgnoreCase(noneStr))
                {
                    wfStp.GA_Tracking_Status__c=grpData.GA_Tracking_Status__c;
                }
                else
                {
                    wfStp.GA_Tracking_Status__c=blankStr;
                }
                if(stpproblmIdenVal !=null && !stpproblmIdenVal.equalsIgnoreCase(noneStr))
                {
                    wfStp.GA_Problem_Identified_Values__c=grpData.GA_Problem_Identified_Values__c;
                }
                else
                {
                    wfStp.GA_Problem_Identified_Values__c=blankStr;
                }
                if(stpwrkTypeVal !=null && !stpwrkTypeVal.equalsIgnoreCase(noneStr))
                {
                    wfStp.GA_Work_Type__c=grpData.GA_Work_Type__c;
                }
                else
                {
                    wfStp.GA_Work_Type__c=blankStr;
                }
                if(stpotherProbIdentifiedVal !=null && !stpotherProbIdentifiedVal.equalsIgnoreCase(noneStr))
                {
                    wfStp.GA_Other_please_specify__c=grpData.GA_Other_please_specify__c;
                }
                else
                {
                    wfStp.GA_Other_please_specify__c=blankStr;
                }
               // wfStp.GA_Notes__c=grpData.GA_Notes__c;
               wfStp.GA_Notes__c =  myDate + sPace + userinfo.getName() + sPace + grpNames.removeEnd(coMma)+ sPace+ grpData.GA_Notes__c +' \r\n'+ (objCurrentWorkFlowStep.GA_Notes__c <>null ?'\n' + objCurrentWorkFlowStep.GA_Notes__c  : '') ;// objCurrentWorkFlowStep.GA_Notes__c ;;
               database.update(wfStp);
            }
            //call queueassigmnet class here by sending lstWFStepGroupSegments
            list<GA_WF_Group_Segment__c> grpsgmntToUpsrt;
            if(assGnOwnr != BLANK)
            {
                grpsgmntToUpsrt= lstWFStepGroupSegmentsNew;
            }
            else
                grpsgmntToUpsrt=GA_AP_WFQueueAssignment.getWFProcssOwnerInfo(objCurrentWorkFlowStep.GA_WF_Workflow_ID__r.GA_Workflow_Template__c ,objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name,objCurrentWorkFlowStep.GA_WF_Workflow_ID__c, 
                                                                             objCurrentWorkFlowStep.Name, objCurrentWorkFlowStep.OwnerId, lstWFStepGroupSegmentsNew,objCurrentWorkFlowStep.GA_WF_Workflow_ID__r.GA_Workflow_Owner_Role__c);
            
            boolean ownrque=true;
            if(grpsgmntToUpsrt.size()>0)
            {
                
                if(string.valueof(grpsgmntToUpsrt[0].ownerId).startswith(queuePrfix))
                {
                    ownrque=true;
                }
                else
                {
                    ownrque=false;   
                }
            }
            grpsgmntToUpsrt.addall(lstWFStepGroupSegments);
            //upsert lstWFStepGroupSegments;
            //upsert grpsgmntToUpsrt;
            // upsert lstWFStepGroupSegments;
            // update lstWFStepGroupSegmentstoInsrt;
            
            if(!grpsgmntToUpsrt.isEmpty()){
                GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(grpsgmntToUpsrt, GA_Util15_WFGSDataAccesHelper.UPSERT_OPERATION);  
            }
            if(!lstWFStepGroupSegments.isEmpty()){
                GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(lstWFStepGroupSegments, GA_Util15_WFGSDataAccesHelper.UPSERT_OPERATION);  
            }
            if(!lstWFStepGroupSegmentstoInsrt.isEmpty()){
                GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(lstWFStepGroupSegmentstoInsrt, GA_Util15_WFGSDataAccesHelper.UPDATE_OPERATION);  
            }
            if(grpRemoveInprgrssLst.size()>0)
            {
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                GA_GroupSegAccUpdateCls.isExecuting = true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                
                database.update(grpRemoveInprgrssLst);
            }
            
            
            
            
            List <GA_WF_Group_Segment__c> unassignedGrps = GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SelectwfgsQury,whrWfgsStp +GA_Util08_FilterProcessHelper.FltrString(currentWorkflowStepId)+ WFGSWhereWFNxtStp + nullStr ,GA_Util15_WFGSDataAccesHelper.BLANK,WFGSlimit).values();
            
            
            GA_WF_Step__c wfstRec =New GA_WF_Step__c(id = currentWorkflowStepId);
            
            String currenttemplName = objCurrentWorkFlowStep.GA_WF_Template_Step__r.GA_WFT_Inventory_Step_ID__r.Name;
            
            if (unassignedGrps.isEmpty() ){
                
                wfstRec.GA_Status__c = clsd;
                wfstRec.GA_End_Time__c = currenttime;
            }
            
            
            if(wfstRec <> null){
                GA_Util03_WrkflwStpDataAccessHelper.dmlOnwrkflwstp(New List<GA_WF_Step__c>{wfstRec},GA_Util03_WrkflwStpDataAccessHelper.UPDATE_OPERATION);
                
            }
            if(nxtStpTmpName.equalsIgnoreCase(cmpStr) )
            {
                List<GA_WF_Step__c> wfstReclst = GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(WFStpSelectQuery, whrwfid + GA_Util08_FilterProcessHelper.FltrString(objCurrentWorkFlowStep.GA_WF_Workflow_ID__c ) + whrstpsts +  GA_Util08_FilterProcessHelper.FltrString(Opn) , GA_Util03_WrkflwStpDataAccessHelper.BLANK, WFStplimit).values();
                
                if(wfstReclst.size()==0)  
                {
                    GA_WF_Workflow__c currStpWFObj = New  GA_WF_Workflow__c(id = objCurrentWorkFlowStep.GA_WF_Workflow_ID__c);
                    currStpWFObj.GA_Status__c = clsd;
                    currStpWFObj.GA_Date_Closed__c=system.today();
                    database.update(currStpWFObj);
                }
            }
            if(assGnOwnr != BLANK && sendMailVal)
            {
                notifyUseAssignedWFSTp(assGnOwnr,objCurrentWorkFlowStep.GA_WF_Workflow_ID__c);
            }
            return objCurrentWorkFlowStep.GA_WF_Workflow_ID__c;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, savenext);
            throw new AuraHandledException(System.Label.GA_WFGSDetailError+excepSepartr+e.getMessage()); 
        }
        
    }// end of saveNextStep
    /**
@Description: errMsgShow() method 
@Name : errMsgShow
@Param : id wflwStpId,List<id> lstGroupSegments
@Return : list<GA_AP_ShowValidationMessages.errormessage>
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static list<GA_AP_ShowValidationMessages.errormessage> errMsgShow(id wflwStpId,List<id> lstGroupSegments)
    {
        try
        {
            list<GA_AP_ShowValidationMessages.errormessage> grpSgmntErrLst=GA_AP_ShowValidationMessages.errMsgShow(wflwStpId,lstGroupSegments); 
            return grpSgmntErrLst;   
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, errMsgShowMthd);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    /**
@Description: stepNameRec() method 
@Name : stepNameRec
@Param : String wflwStpId
@Return : string
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static string stepNameRec(String wflwStpId)
    {
        try
        {
        string wfstRecName= GA_AP_ShowValidationMessages.stepNameRec(wflwStpId);
        return wfstRecName;    
        }
          catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, stepNameRecMthd);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    
    @AuraEnabled
    public static boolean nextStepQueueInfoWFGS(Id currentWorkflowStepId, Id selectedWorkFlowTemplateStepId, string selectedWorkFlowStepName, List<String> lstGroupSegments){
        try{
            boolean nxtqueInfo=WorkflowController.nextStepQueueInfo(currentWorkflowStepId, selectedWorkFlowTemplateStepId, selectedWorkFlowStepName, lstGroupSegments);
            return nxtqueInfo;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, chkqueInfoMthd);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    
    /**
@Description: notifyUseAssigned() method 
@Name : notifyUseAssigned
@Param :string assignOwnr       
@Return :None
@throws Exception : AuraHandledException;
*/     
    public static void notifyUseAssignedWFSTp(string assignOwnr,Id wfId)
    {
        
        try{
            WorkflowController.notifyUseAssigned(assignOwnr,wfId);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, notifyUseAssignedWFSTpMtd);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
        
    }
    
    @AuraEnabled
    public static string chkLoggedInUsrprfle()
    {
        list<user> usrLst=[select profile.Name from user where id=:userInfo.getUserId()];
        return usrLst[0].profile.Name;
    }
    
    @AuraEnabled
    public static GA_Workflow_Field_Visibility__mdt fieldVisibilty()
    {
        list<user> usr=[select id,GA_RoleName__c,profile.Name from user where id=:userInfo.getUserId()];
        if(usr.size()>0)
        {
            string RoleNm=usr[0].GA_RoleName__c;
            if(RoleNm!='')
            {
                list<GA_Workflow_Field_Visibility__mdt> wflfildVsbllst=[select id,label,GA_Problem_Identified_Editable__c,
                                                                        GA_Problem_Identified_Visible__c,GA_Tracking_Status_Code__c,
                                                                        GA_Work_Type__c 
                                                                        from GA_Workflow_Field_Visibility__mdt where label=:RoleNm];  
                if(wflfildVsbllst.size()>0)
                {
                    return wflfildVsbllst[0];
                }
            }
            
        }
        return null;
    }  
    /**
@Description: wrkflwGrpSgmntWrp class
@Name : wrkflwGrpSgmntWrp

*/
    public class wrkflwGrpSgmntWrp
    {
        @AuraEnabled
        public GA_WF_Group_Segment__c wfgsRec;
        @AuraEnabled
        public User loginUser;
        @AuraEnabled
        public List<String> trackSts; 
        @AuraEnabled
        public List<String> problemIdentified;
        @AuraEnabled
        public List<String> workType;
        @AuraEnabled
        public List<String> otherPID;
        @AuraEnabled
        public String selectedTrackingstatus; 
        @AuraEnabled
        public String selectedProbIdentified;
        @AuraEnabled
        public String selectedOtherPID;
        @AuraEnabled
        public String selectedwrkType;
        @AuraEnabled
        public list<GA_WFT_Allowed_Next_Step__c> nxtStps;
        @AuraEnabled
        public list<GA_WF_Group_Segment__c> nxtWFGrps;
        
        public wrkflwGrpSgmntWrp(GA_WF_Group_Segment__c wfgsRecTmp,User loginUserTmp,List<String> trackStsTmp,
                                 List<String> problemIdentifiedTmp,String selectedTrackingstatusTmp,
                                 String selectedProbIdentifiedTmp,list<GA_WFT_Allowed_Next_Step__c> nxtStpsTmp,
                                 string selectedwrkTypeTmp,list<string> workTypeTmp,List<String> otherPIDTmp,String selectedOtherPIDTmp,
                                 List<GA_WF_Group_Segment__c> nxtWFGrpsTmp)
        {
            wfgsRec=wfgsRecTmp;
            loginUser=loginUserTmp;
            trackSts = trackStsTmp;
            problemIdentified = problemIdentifiedTmp;
           
            selectedTrackingstatus=  selectedTrackingstatusTmp;
            selectedProbIdentified = selectedProbIdentifiedTmp;
            workType=workTypeTmp;
            selectedwrkType=selectedwrkTypeTmp;
            nxtStps = nxtStpsTmp;
            otherPID = otherPIDTmp;
            selectedOtherPID = selectedOtherPIDTmp;
            nxtWFGrps= nxtWFGrpsTmp;
        }
    }
   
    
}