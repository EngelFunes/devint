/*****************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_AP_addGrpSegments
@CreatedDate: 28 - Sep 2018 
@Description: GA_AP_addGrpSegments class is used to append group segments to existing workflow 
@version : 1.0  
*****************************************************************************************************************************************/
public class GA_AP_addGrpSegments {
    public static final String ClsName  ='GA_AP_addGrpSegments';
    public static final String methodNme  ='appendGrpSegmentToWF';
    public static Datetime currenttime = system.now();
    public static string stepName = 'Small Group Underwriting - to Review';
    public static string openSts = 'Open' ;
    public static String clsdSts = 'Closed';
    public static String err = 'ERROR';
    public static String progressType = 'Workflow';
    

    /**
@Description: AutoCrteWrkFlw() method 
@Name : AutoCrteWrkFlw
@Param : list<GA_WF_Workflow__c> wrkFLwLst 
@Return : void
@throws Exception : N/A;
*/
    public static void appendGrpSegmentToWF(String wfId,String gsId)
    {
        try
        {
            List<GA_WF_Group_Segment__c> wfgsLst = New List<GA_WF_Group_Segment__c>();
            GA_WF_Workflow__c currentWF = [select id,Name,	GA_Workflow_Template__r.GA_Carrier__c from GA_WF_Workflow__c where id =: wfId limit 1];
            GA_Group_Segment__c gsOpen = [Select Id,GA_In_Progress__c,	GA_In_Progress_Type__c,Name,GA_Carrier__c from 
                                                      GA_Group_Segment__c where  id  =: gsId
                                                        limit 1];
            
            if((currentWF <> null) && (gsOpen <> null)){
                
                if(currentWF.GA_Workflow_Template__r.GA_Carrier__c == gsOpen.GA_Carrier__c){
                if(!gsOpen.GA_In_Progress__c){
                    List<GA_WF_Step__c> currentWorkflowStep = [Select Id,ownerid  from GA_WF_Step__c where Name =: stepName  and GA_Status__c = : openSts and 	GA_WF_Workflow_ID__c =:wfId Limit 1 ];
                    if(currentWorkflowStep.size() > 0 ){
                        GA_WF_Group_Segment__c wfGrpsgmnt=new GA_WF_Group_Segment__c();
                        wfGrpsgmnt.GA_Workflow_ID__c=wfId;
                        wfGrpsgmnt.GA_Group_Segment_ID__c=gsId;
                        wfGrpsgmnt.GA_Date_Opened__c=currenttime;
                        wfGrpsgmnt.GA_Date_Closed__c = currenttime;
                        wfGrpsgmnt.GA_Status__c=clsdSts;  
                        wfGrpsgmnt.OwnerId = currentWorkflowStep[0].ownerid;
                        wfgsLst.add(wfGrpsgmnt);
                        
                        GA_WF_Group_Segment__c suwwfGrpsgmnt=new GA_WF_Group_Segment__c();
                        suwwfGrpsgmnt.GA_Workflow_ID__c=wfId;
                        suwwfGrpsgmnt.GA_Group_Segment_ID__c=gsId;
                        suwwfGrpsgmnt.GA_Date_Opened__c=currenttime;
                        suwwfGrpsgmnt.GA_Status__c=openSts;
                        suwwfGrpsgmnt.GA_WF_Step_ID__c = currentWorkflowStep[0].id;
                        suwwfGrpsgmnt.OwnerId = currentWorkflowStep[0].ownerid;
                         wfgsLst.add(suwwfGrpsgmnt);
                        
                        Database.insert(wfgsLst);
                        
                        
                        gsOpen.GA_In_Progress__c = true;
                        gsOpen.GA_In_Progress_Type__c = progressType;
                        gsOpen.GA_Is_Mass_Updating__c=True;
                          GA_GS_AP02_Update_Address.isExecuting=true;
                       // GA_ExternlaAppleSrvcCls.isExecuting = true;
                        GA_GS_UpdateRatingType.isExecuting = true;
                        GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                        GA_GroupSegmentTriggerHandler.isExecuting = true;
                        GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                        GA_GS_AP04_UpdtStatus.isExecuting = true;
                        GA_GS_AP04_UpdtStatus.isInvoked = true;
                        GA_GS_UpdatWrappingFileTPA.isExecuting = true;   
                        database.update(gsOpen,false);
                        
                    }
                    else{
                    ExceptionLog__c objLog = new ExceptionLog__c();
                    objLog.Object_ID__c =wfId ;
                    objLog.ExceptionDescription__c = System.Label.GA_SGUWStepClosedErr;
                    objLog.ExceptionCode__c =  System.Label.GA_StepClosedExcpCode;
                    objLog.NumberOfTimesOccured__c =  1;
                    objLog.ExceptionDetails__c = System.Label.GA_SGUWStepClosedErr+' '+wfId;
                    objLog.ClassName__c = ClsName;
                    objLog.MethodName__c = methodNme;
                    objLog.Severity__c = err;
                    Database.insert(objLog);
                    }
                    }
                else{
                    ExceptionLog__c objLog = new ExceptionLog__c();
                    objLog.Object_ID__c =gsId ;
                    objLog.ExceptionDescription__c = System.Label.GA_OpenGSErrMsg;
                    objLog.ExceptionCode__c =  System.Label.GA_OPENGRP;
                    objLog.NumberOfTimesOccured__c =  1;
                    objLog.ExceptionDetails__c = System.Label.GA_OpenGSErrMsg+' '+gsOpen.Name;
                    objLog.ClassName__c = ClsName;
                    objLog.MethodName__c = methodNme;
                    objLog.Severity__c = err;
                    Database.insert(objLog); 
                }
                }else{
                    
                    ExceptionLog__c objLog = new ExceptionLog__c();
                    objLog.Object_ID__c =gsId ;
                    objLog.ExceptionDescription__c = 'Select Group Segment carrier is not similar to Workflow carrier';
                    objLog.ExceptionCode__c =  System.Label.GA_OPENGRP;
                    objLog.NumberOfTimesOccured__c =  1;
                    objLog.ExceptionDetails__c = 'Select Group Segment carrier is not similar to Workflow carrier'+' '+gsOpen.Name;
                    objLog.ClassName__c = ClsName;
                    objLog.MethodName__c = methodNme;
                    objLog.Severity__c = err;
                    Database.insert(objLog); 
                    
                }
                
            }
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
        }
    }
    
}