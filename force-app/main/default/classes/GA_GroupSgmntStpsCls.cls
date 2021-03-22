/*****************************************************************************************
Class Name   : GA_GroupSgmntStpsCls
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to fetch Group segment history list 
******************************************************************************************/
public class GA_GroupSgmntStpsCls {
    public static final string hyphenVal='-';
    
    public static final string SelectWFGSQuery = 'select Id, GA_WF_Step_ID__c, GA_WF_Step_ID__r.Name, GA_Status__c,'+
        ' GA_date_opened__c, GA_date_closed__c, GA_Quote_ID__c, GA_Duration__c,GA_WF_Step_ID__r.id,GA_WF_Step_ID__r.ga_status__c,'+
        'GA_Result__c,GA_Notes__c,owner.name from GA_WF_Group_Segment__c where ';
    public static final string wheregrpSgmntId = ' GA_Group_Segment_ID__c = ';
    public static final string wherewrkflId =' and GA_Workflow_ID__c =';   
    public static final string whereaccId =' and GA_Account__c ='; 
    public static final string wherewfStpId =' and GA_WF_Step_ID__c != null';
    public static final string whereGrppSgmtNo = ' GA_Group_Segment_ID__r.Name =';
    public static final string wherewrkStpSts =' and GA_WF_Step_ID__r.ga_status__c = ';
    public static final string orddateClose = ' order by GA_date_closed__c desc, GA_Date_Opened__c desc';
    public static final string orderdatStrt = ' order by GA_WF_Step_ID__r.GA_Start__c asc' ;
    public static final string orderCrtDate = ' order by createddate desc';
    public static final string whereStpName = ' and GA_WF_Step_ID__r.Name=';
    public static final string orStpName = ' and GA_WF_Step_ID__r.Name in ';
    public static final string wheregrpSgmntName = ' GA_Group_Segment_ID__r.Name = ';
    public static final string limitClause = ' Limit 1000';
    public static final string limitStr = ' Limit 1';
    public static final string open = 'Open'  ;  
    public static final string closed = 'Closed' ;
    public static final string automatedValdition= 'Automated Validation';
    public static final string SelGrpSgmntQury = 'Select Id from GA_Group_Segment__c where ';
    public static final string whereGrpNo = ' Name =';
    public static final string ClsName = 'GA_GroupSgmntStpsCls';
    public static final string fetchWorkflowSteps = 'fetchWorkflowSteps';
    public static final string ErrorMsg = 'There is some problem in fetching the Group segment history';
    public static final string excepSepartr = ' : ';
    public static final String OPENSGBR = '[' ;
    public static final String CLOSEDSGBR = ']' ;
    public static final String COMMASYB = ',' ;
    public static final String SPLITSTR = '\\s+' ;
    public static final String BLANKSTR = '' ;
    /**
@Description: fetchWorkflowSteps() method 
@Name : fetchWorkflowSteps
@Param : string grpSegmentNo,String wrkFlId
@Return : list<wrkflwGrpSgmntWrp>
@throws Exception : AuraHandledException;
*/     
    
    @AuraEnabled
    public static List<wrkflwStpHstryWrp> fetchWorkflowSteps(string grpSegmentNo,String wrkFlId, String accId)
    {
        try{
            list<wrkflwStpHstryWrp> wrkflwStpHstryWrpLst=new list<wrkflwStpHstryWrp>();
            
            List<GA_Group_Segment__c> grpSgmntLst = GA_Util17_GrpSgmntDataAccesHelper.fetchGrpSgmMap(SelGrpSgmntQury,
                                                                                                     whereGrpNo + GA_Util08_FilterProcessHelper.FltrString(grpSegmentNo) +
                                                                                                     whereaccId + GA_Util08_FilterProcessHelper.FltrString(accId),
                                                                                                     GA_Util17_GrpSgmntDataAccesHelper.BLANK,
                                                                                                     limitStr).values();
            
            String GrpSgmntId =grpSgmntLst[0].id;
            
            List<GA_WF_Group_Segment__c> wfstpLst = GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SelectWFGSQuery,
                                                                                                       wheregrpSgmntId + GA_Util08_FilterProcessHelper.FltrString(GrpSgmntId) +
                                                                                                       wherewrkflId +  GA_Util08_FilterProcessHelper.FltrString(wrkFlId) +
                                                                                                       wherewfStpId , 
                                                                                                       orddateClose,limitClause).values(); 
            
            
            
            String QuoteId;
            for(GA_WF_Group_Segment__c wfstp:wfstpLst)
            {
                
                string durtion ;
                if(wfstp.GA_date_closed__c <> null && wfstp.GA_date_opened__c <> null ){
                    durtion =   DurationOnWfStep(wfstp.GA_date_opened__c, wfstp.GA_date_closed__c);
                }
                
                if(wfstp.GA_Quote_ID__c <> null ){
                    QuoteId =   wfstp.GA_Quote_ID__c;
                }
                
                wrkflwStpHstryWrp wrkflwHstry=new wrkflwStpHstryWrp(wfstp.Id,wfstp.GA_WF_Step_ID__r.Name,
                                                                    wfstp.GA_Status__c,
                                                                    wfstp.GA_date_opened__c,
                                                                    wfstp.GA_date_closed__c,
                                                                    ((durtion <> null) ? (durtion) : '') ,
                                                                    wfstp.owner.name,
                                                                    wfstp.GA_Notes__c,
                                                                    '/'+wfstp.GA_WF_Step_ID__c, QuoteId);
                
                wrkflwStpHstryWrpLst.add(wrkflwHstry);
                
            }
            
            return wrkflwStpHstryWrpLst;
        }
        
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchWorkflowSteps);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
        
    }
    /**
@Description: fetchGrpSgmntSts() method 
@Name : fetchWorkflowSteps
@Param : string grpSegmentNo,String wrkFlId
@Return : list<wrkflwGrpSgmntWrp>
@throws Exception : AuraHandledException;
*/     
    
    @AuraEnabled
    public static string fetchGrpSgmntSts(string grpSegmentNo,String wrkFlId)
    {
        try{
            
            String grpSgmntSts; 
            Set<String> stpName = New  Set<String> {'Canceled','Completed'};
                List<GA_WF_Group_Segment__c> cmplGrpSgmt = GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SelectWFGSQuery,
                                                                                                              wheregrpSgmntName + GA_Util08_FilterProcessHelper.FltrString(grpSegmentNo) +
                                                                                                              wherewrkflId +  GA_Util08_FilterProcessHelper.FltrString(wrkFlId) +
                                                                                                              orStpName + GA_Util08_FilterProcessHelper.strSet(stpName)                                                    , 
                                                                                                              orddateClose,limitClause).values(); 
            if(!cmplGrpSgmt.isempty())   {
                if(cmplGrpSgmt[0].GA_Status__c == 'Closed' || cmplGrpSgmt[0].GA_Status__c == 'Canceled'  )
                {
                    grpSgmntSts =  cmplGrpSgmt[0].GA_Status__c;
                }
            }
            else{
                grpSgmntSts = 'Open';  
            }
            
            return grpSgmntSts;
            
        }
        
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchWorkflowSteps);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
        
    }
    
    /**
@Description: calculateDuation() method 
@Name : calculateDuation
@Param : Datetime strTime,Datetime endTime
@Return :GA_WF_Group_Segment__c
@throws Exception : AuraHandledException;
*/  
    public static string DurationOnWfStep(Datetime strTime,Datetime endTime){  
        BusinessHours b = new BusinessHours();
        Long millSecs = BusinessHours.diff(System.Label.GA_BusinessHours, strTime, endTime);
        Long hoursTime = millSecs/(60 * 60 * 1000);
        long mins=math.mod(millSecs/(60 * 1000),60);
        string durtn=hoursTime + ' h'+' : '+mins+ ' mins';
        return durtn;
    } 
    /**
@Description: fetchCurrentStep() method 
@Name : fetchCurrentStep
@Param : string grpSegmentNo,String wrkFlId
@Return :GA_WF_Group_Segment__c
@throws Exception : AuraHandledException;
*/     
    
    @AuraEnabled
    public static GA_WF_Group_Segment__c  fetchCurrentStep (string grpSegmentNo,String wrkFlId)
    {
        try{
            List<GA_WF_Group_Segment__c > wfstpOpenLst = New  List<GA_WF_Group_Segment__c > ();
            List<GA_WF_Group_Segment__c > wfstpClosedLst = New  List<GA_WF_Group_Segment__c > ();
            GA_WF_Group_Segment__c  currentStep = New  GA_WF_Group_Segment__c ();
            
            wfstpOpenLst =  GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SelectWFGSQuery,
                                                                               whereGrppSgmtNo + GA_Util08_FilterProcessHelper.FltrString(grpSegmentNo) +
                                                                               wherewrkflId +  GA_Util08_FilterProcessHelper.FltrString(wrkFlId) +
                                                                               wherewrkStpSts + GA_Util08_FilterProcessHelper.FltrString(open) , 
                                                                               orderdatStrt,limitStr).values(); 
            
            
            
            if(wfstpOpenLst.size() > 0){
                
                currentStep = wfstpOpenLst[0];
            }
            else{
                
                wfstpClosedLst    =  GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SelectWFGSQuery,
                                                                                        whereGrppSgmtNo + GA_Util08_FilterProcessHelper.FltrString(grpSegmentNo) +
                                                                                        wherewrkflId +  GA_Util08_FilterProcessHelper.FltrString(wrkFlId) +
                                                                                        wherewrkStpSts + GA_Util08_FilterProcessHelper.FltrString(closed) , 
                                                                                        orderdatStrt,limitStr).values(); 
                
                if(wfstpClosedLst.size() > 0){
                    currentStep = wfstpClosedLst[0];
                }
            }  
            
            
            return currentStep;
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchWorkflowSteps);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    /**
@Description: fetchCurrentStep() method 
@Name : fetchCurrentStep
@Param : string grpSegmentNo,String wrkFlId
@Return :GA_WF_Group_Segment__c
@throws Exception : AuraHandledException;
*/ 
    @AuraEnabled
    public static list<GA_WF_Group_Segment__c>  fetchClosingDtls (string grpSegmentNo,String wrkFlId)
    {
        try{
            list<GA_WF_Group_Segment__c> clsDtsLst =  GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SelectWFGSQuery,
                                                                                                         whereGrppSgmtNo + GA_Util08_FilterProcessHelper.FltrString(grpSegmentNo) +
                                                                                                         wherewrkflId +  GA_Util08_FilterProcessHelper.FltrString(wrkFlId) +
                                                                                                         whereStpName + GA_Util08_FilterProcessHelper.FltrString(automatedValdition) , 
                                                                                                         GA_Util15_WFGSDataAccesHelper.BLANK,limitClause).values(); 
            
            
            
            return clsDtsLst;
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchWorkflowSteps);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    
    /**
@Description: fetchWFprss() method 
@Name : fetchWFprss
@Param : string grpSegmentNo,String wrkFlId
@Return :GA_WF_Group_Segment__c
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static GA_WF_Group_Segment__c fetchWFprss(String wrkProcessId)
    {
        try{
            List<GA_WF_Group_Segment__c > wfstpOpenLst = New  List<GA_WF_Group_Segment__c > ();
            GA_WF_Group_Segment__c  currentStep = New  GA_WF_Group_Segment__c ();
            
            string wfGrpIdsTmp=wrkProcessId.remove(OPENSGBR).remove(CLOSEDSGBR);
            wfGrpIdsTmp= wfGrpIdsTmp.replaceAll( SPLITSTR, BLANKSTR);
            list<id> wfGrpIdsTmpLst=wfGrpIdsTmp.split(COMMASYB);
            set<id> wkflwGSStpIdSet=new set<id>();
            wkflwGSStpIdSet.addall(wfGrpIdsTmpLst);
            
            wfstpOpenLst = [Select Id,GA_Group_Segment_Name__c,GA_Workflow_ID__c,GA_Workflow_ID__r.id,GA_Workflow_ID__r.Name,GA_Workflow_ID__r.GA_Account__r.id,GA_Workflow_ID__r.GA_Account__r.Name,GA_Workflow_ID__r.GA_Account__c from GA_WF_Group_Segment__c where id in: wkflwGSStpIdSet Limit 1];
            currentStep = wfstpOpenLst[0];
            
            return currentStep;
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchWorkflowSteps);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    
    public class wrkflwStpHstryWrp
    {
        @AuraEnabled
        public string WrkPrcssId;
        @AuraEnabled
        public string WrkFlwStep;
        @AuraEnabled
        public string   wrkFlwStatus;
        @AuraEnabled
        public datetime wrkStpStart;
        @AuraEnabled
        public datetime wrkStpEnd;
        @AuraEnabled
        public String duration; 
        @AuraEnabled
        public string assigneduser;
        @AuraEnabled
        public string wrkflwNotes; 
        @AuraEnabled
        public string wrkflwStpId;
        @AuraEnabled
        public string QuoteId;
        
        public wrkflwStpHstryWrp(String WrkPrcssIdTmp,string WrkFlwStepTmp,string wrkFlwStatusTmp, datetime wrkStpStartTmp,
                                 datetime wrkStpEndTmp, String durationTmp, string assigneduserTmp,
                                 string wrkflwNotesTmp,String wrkflwStpIdTmp, String QId)
        {
            WrkPrcssId = WrkPrcssIdTmp;
            WrkFlwStep=WrkFlwStepTmp;
            wrkFlwStatus=wrkFlwStatusTmp;
            wrkStpStart=wrkStpStartTmp;
            wrkStpEnd=wrkStpEndTmp;
            duration=durationTmp;
            assigneduser=assigneduserTmp;
            wrkflwNotes=wrkflwNotesTmp;
            wrkflwStpId=wrkflwStpIdTmp;
            QuoteId=QId;
        }
    }
    
    
    
}