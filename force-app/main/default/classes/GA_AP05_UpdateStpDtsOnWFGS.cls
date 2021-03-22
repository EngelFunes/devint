/*****************************************************************************************
Class Name   : GA_DisplayStepHistoryCls
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to fetch Workflow history
******************************************************************************************/
public with sharing class GA_AP05_UpdateStpDtsOnWFGS {
    
    public static final string SELECTQUERY='select id ,GA_Notes__c,GA_Tracking_Status__c,GA_Problem_Identified_Values__c,GA_Status__c,GA_Other_please_specify__c,GA_Work_Type__c,GA_Grace_Code__c  FROM GA_WF_Group_Segment__c ';
    public static final string WHERECLAUSE=' where GA_WF_Step_ID__c  in ';
    public static final string WHERECLAUSE2 = ' and  GA_Status__c = ' ;        
    public static final string LIMITCLAUSE=' limit 100';
    public static final string CLSNAME = 'GA_AP05_UpdateStpDtsOnWFGS';
    public static final string UPDATEWFGSDTLS = 'updateWFGSdtls';
    public static final string CHECKGRPSGMTSOPEN = 'checkGrpSgmtsOpen';
    public static final string ERRORMSG = 'There is some problem in updating Workflow group segments';
    public static final string EXCEPSEPARTR = ' : ';
    public static final string OPEN ='Open';
    /**
@Description: updateWFGSdtls() method 
@Name : updateWFGSdtls
@Param :GA_WF_Step__c wrfStepRec
@Return : None
@throws Exception : AuraHandledException;
*/       
    @AuraEnabled
    public static void updateWFGSdtls(GA_WF_Step__c wrfStepRec)
    {
        try
        {
        set<id> wkflwStpIdSet=new set<id>();
        wkflwStpIdSet.add(wrfStepRec.Id);
        string wkflwStepIdString=GA_Util08_FilterProcessHelper.idSet(wkflwStpIdSet); 
        List<GA_WF_Group_Segment__c> wfgsLst = GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SELECTQUERY,WHERECLAUSE+wkflwStepIdString,GA_Util15_WFGSDataAccesHelper.BLANK,LIMITCLAUSE).values();
       
        List<GA_WF_Group_Segment__c> updatewfgsLst = New List<GA_WF_Group_Segment__c> () ;
        
        if(!wfgsLst.isEmpty()){
            for (GA_WF_Group_Segment__c wfgs : wfgsLst){
               // wfgs.GA_Notes__c = wrfStepRec.GA_Notes__c;
                wfgs.GA_Tracking_Status__c = wrfStepRec.GA_Tracking_Status__c;
                wfgs.GA_Problem_Identified_Values__c =  wrfStepRec.GA_Problem_Identified_Values__c;
                wfgs.GA_Work_Type__c=wrfStepRec.GA_Work_Type__c;
                wfgs.GA_Other_please_specify__c = wrfStepRec.GA_Other_please_specify__c;
                wfgs.GA_Grace_Code__c = wrfStepRec.GA_Grace_Code__c;
                updatewfgsLst.add(wfgs);
            }
        }
        if(!updatewfgsLst.isEmpty()){
            GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(updatewfgsLst, GA_Util15_WFGSDataAccesHelper.UPDATE_OPERATION);}
            
              }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, UPDATEWFGSDTLS);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
/**
@Description: checkGrpSgmtsOpen() method 
@Name : checkGrpSgmtsOpen
@Param :Id wrfStepRecid
@Return : Boolean
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static Boolean checkGrpSgmtsOpen(Id wrfStepRecid)
    {
        try
        {
        Boolean grpSgmntsOpen = false;
        set<id> wkflwStpIdSet=new set<id>();
        wkflwStpIdSet.add(wrfStepRecid);
        string wkflwStepIdString=GA_Util08_FilterProcessHelper.idSet(wkflwStpIdSet); 
        string opensts =GA_Util08_FilterProcessHelper.FltrString(OPEN); 
        List<GA_WF_Group_Segment__c> wfgsLst = GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SELECTQUERY,WHERECLAUSE+wkflwStepIdString+WHERECLAUSE2+opensts,GA_Util15_WFGSDataAccesHelper.BLANK,LIMITCLAUSE).values();
        
        
        if(!wfgsLst.isEmpty()){
            grpSgmntsOpen = True;
        }
       
        return grpSgmntsOpen;
              }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, CHECKGRPSGMTSOPEN);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    
    
}