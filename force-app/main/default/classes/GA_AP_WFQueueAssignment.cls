/*****************************************************************************************
Class Name   : GA_AP_WFQueueAssignment
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to fetch Workflow Group segment ownership assignment
******************************************************************************************/
public with sharing class GA_AP_WFQueueAssignment {
    
    public static final string selectQuery='select id,name,ownerId from GA_WF_Step__c where ';
    public static final string whereClause=' GA_WF_Workflow_ID__c in ';
    public static final string whereClause1=' and GA_Status__c = ';
    public static final string whereClause2=' and Name = ';
    public static final string limitClause=' limit 1';
    public static final string statusVal='Completed';
    public static final string wfStpTmpselectQuery='select id,name,GA_Queue__c,GA_Role__c,GA_Conditional_Assignment__c from GA_WFT_Step__c where ';
    public static final string wfStpTmpwhereClause=' GA_WFT_Inventory_Step_ID__r.name = ';
    public static final string wfStpTmpwhereClause1=' and GA_WFT_Workflow_ID__c in ';
    public static final string ClsName = 'GA_AP_WFQueueAssignment';
    public static final string getWFOwnerInfo = 'getWFOwnerInfo';
    public static final string ErrorMsg = 'There is some problem in assigning record ownership';
    public static final string excepSepartr = ' : ';
    public static final string  userStr = 'User';
    public static final string  SelectWFStpQuery = 'select id,Name,OwnerId,(select id,Name,GA_Group_Segment_ID__c,ownerId from GA_WF_Group_Segments__r) from GA_WF_Step__c where';
    public static final string  whereWFId = ' GA_WF_Workflow_ID__c= ';
    public static final string  orderbyCrtDt = ' order by createddate desc';
    public static final string PCS = 'PCS Queue';
    public static final string PCSQ = '%PCS Queue%';
    public static final string PCSSupport = 'PCS - Support' ;
    public static final string PCSSupportQueue ='GA_Sales_Support_PCS_WFGSQueue';
    public static final string PCSWMSupport='PCS - West Michigan Support';
    public static final string WMSupport='West Michigan Support Representative';
    public static final string WMSupportMgr='West Michigan Support Manager';       
    public static final string PCSWMSupportQueue='West_Michigan_Support_PCS_Queue';
    public static final string WFGSObjectApi='GA_WF_Group_Segment__c';
    public static final string NA='N/A';
    public static final string Preprocessing='Pre-Processing';
    public static final string ASRtoModify='ASR To Modify';
    public static final string queueNA = 'Queue N/A';
    public static final string SelectQueueQry = 'SELECT Id, Queue.name,QueueId,Queue.developerName FROM QueueSobject where ';
    public static final string whereQueName = 'Queue.name= ';
    public static final string whereQueuNmLike = 'Queue.name Like ';
    public static final string whereSobj = ' and SobjectType = ';
    public static final string limitStr2 = ' limit 2';
    public static final string SelectUsrStpRoleQry = 'select id,GA_User_Role__c,GA_Step_Role__c from User_Step_Role_Mapping__mdt where ';
    public static final string whereusrRole = 'GA_User_Role__c= ';
    
    /**
@Description: getWFOwnerInfo() method 
@Name : getWFOwnerInfo
@Param : string wrfTmpId,string wrfStpNme, string wrfId
@Return : string
@throws Exception : AuraHandledException;
*/     
    public static string getWFOwnerInfo(string wrfTmpId,string wrfStpNme, string wrfId)
    {
        try{
            String StpTempRole = GA_Util03_WrkflwStpDataAccessHelper.BLANK;
            set<id> curridSet=new set<id>();
            curridSet.add(wrfId);
            string wfsIdString=GA_Util08_FilterProcessHelper.idSet(curridSet);
            
            set<id> wrfTmpidSet=new set<id>();
            wrfTmpidSet.add(wrfTmpId);
            string wrfTmpidString=GA_Util08_FilterProcessHelper.idSet(wrfTmpidSet);
            
            string stsStrng=GA_Util08_FilterProcessHelper.FltrString(statusVal);
            string nmStrng=GA_Util08_FilterProcessHelper.FltrString(wrfStpNme);
            //Query exisitng workflow step records to verify if Current step already exist 
            list<GA_WF_Step__c> wfstpRecLstInsrt=GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(selectQuery, 
                                                                                                         whereClause+wfsIdString+
                                                                                                         whereClause1+stsStrng+
                                                                                                         whereClause2+nmStrng, 
                                                                                                         GA_Util03_WrkflwStpDataAccessHelper.BLANK, 
                                                                                                         limitClause).values();
            
            user usr=[select id,name,GA_RoleName__c from user where id=:Userinfo.getUserId() limit 1];
            
            
            //check if no step record exist query quename from related workflow step template record
            if(wfstpRecLstInsrt.size()==0)
            {
                list<GA_WFT_Step__c> wkstepTmpLst=GA_Util14_WFStepTmpltDataAccesHelper.fetchwrkflowStpTmpsMap(wfStpTmpselectQuery, 
                                                                                                              wfStpTmpwhereClause+nmStrng+
                                                                                                              wfStpTmpwhereClause1+wrfTmpidString, 
                                                                                                              GA_Util14_WFStepTmpltDataAccesHelper.BLANK, 
                                                                                                              limitClause).values();
                StpTempRole = wkstepTmpLst[0].GA_Role__c;
                
                
                if(wkstepTmpLst.size()>0)
                { 
                    if(string.isNotBlank(StpTempRole) && wkstepTmpLst[0].GA_Queue__c != queueNA){
                        if( string.isNotBlank(usr.GA_RoleName__c) && StpTempRole.contains(usr.GA_RoleName__c) )
                        {
                            
                            
                            return usr.id;
                            
                        }
                        else{
                            list<QueueSobject> queueLst=[SELECT Id, Queue.name,QueueId FROM QueueSobject where Queue.name=:wkstepTmpLst[0].GA_Queue__c and SobjectType = 'GA_WF_Group_Segment__c'  limit 1];
                            if(queueLst.size()>0)
                                
                                return queueLst[0].QueueId;
                        } 
                    } 
                } 
            }
            else
            {
                
                return (wfstpRecLstInsrt[0].OwnerId);
            }
            
            
            return null;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, getWFOwnerInfo);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    /**
@Description: chkQueueVal() method 
@Name : chkQueueVal
@Param : string wrfTmpId,string wrfStpNme, string wrfId
@Return : boolean
@throws Exception : AuraHandledException;
*/     
    public static boolean chkQueueVal(string wrfTmpId,string wrfStpNme, string wrfId,List<String> lstGroupSegments)
    {
        try{
            set<id> wrfTmpidSet=new set<id>();
            wrfTmpidSet.add(wrfTmpId);
            string wrfTmpidString=GA_Util08_FilterProcessHelper.idSet(wrfTmpidSet);
            string nmStrng=GA_Util08_FilterProcessHelper.FltrString(wrfStpNme);
            
            list<GA_WF_Step__c> wfstpRecLstInsrt=GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(SelectWFStpQuery,
                                                                                                         whereWFId + GA_Util08_FilterProcessHelper.FltrString(wrfId), 
                                                                                                         orderbyCrtDt, 
                                                                                                         GA_Util14_WFStepTmpltDataAccesHelper.BLANK).values();
            map<string,list<GA_WF_Group_Segment__c>> priorStps=new map<string,list<GA_WF_Group_Segment__c>>();
            for(GA_WF_Step__c wfStp:wfstpRecLstInsrt)
            {
                //map step with related workflow process records
                if(wfStp.GA_WF_Group_Segments__r.size()>0)
                    priorStps.put(wfStp.Name,wfStp.GA_WF_Group_Segments__r);
            }
            
            list<GA_WFT_Step__c> wkstepTmpLst=GA_Util14_WFStepTmpltDataAccesHelper.fetchwrkflowStpTmpsMap(wfStpTmpselectQuery, 
                                                                                                          wfStpTmpwhereClause+nmStrng+
                                                                                                          wfStpTmpwhereClause1+wrfTmpidString, 
                                                                                                          GA_Util14_WFStepTmpltDataAccesHelper.BLANK, 
                                                                                                          limitClause).values();
            if(wkstepTmpLst.size()>0)
            {
                if(wkstepTmpLst[0].GA_Queue__c== userStr)
                {
                    if(string.isBlank(wkstepTmpLst[0].GA_Conditional_Assignment__c) || wkstepTmpLst[0].GA_Conditional_Assignment__c ==NA)
                        return true;
                    else
                    {
                        for(string priorStp:priorStps.keySet())
                        {
                            
                            if(wkstepTmpLst[0].GA_Conditional_Assignment__c==priorStp)
                            {
                                list<GA_WF_Group_Segment__c> WFGrpSGmntsLst;
                                list<string> grpSGmnts=new list<string>();
                                WFGrpSGmntsLst=priorStps.get(priorStp);
                                for(GA_WF_Group_Segment__c wfGrp:WFGrpSGmntsLst)
                                {
                                    if(lstGroupSegments.contains(wfGrp.GA_Group_Segment_ID__c))
                                    {
                                        return false;
                                    }
                                    
                                }
                                
                                
                            }
                        }
                        return true;
                    }
                }
            }
            return false;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, getWFOwnerInfo);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    /**
@Description: getWFProcssOwnerInfo() method 
@Name : getWFProcssOwnerInfo
@Param : string wrfTmpId,string wrfStpNme, string wrfId,
string currwrfStpNme,string cuttwrfStpOwnr,
list<GA_WF_Group_Segment__c> currntGrpSgmnetsLs
@Return : list<GA_WF_Group_Segment__c> 
@throws Exception : AuraHandledException;
*/      
    public static list<GA_WF_Group_Segment__c> getWFProcssOwnerInfo(string wrfTmpId,string wrfStpNme, string wrfId,
                                                                    string currwrfStpNme,string cuttwrfStpOwnr,
                                                                    list<GA_WF_Group_Segment__c> currntGrpSgmnetsLst,string wrflwOnerRole)
    {
        try{
            //add one more paramter to send workflow process records for next step
            list<GA_WF_Group_Segment__c> currntGrpSgmnetsLstWithOwnr=new list<GA_WF_Group_Segment__c>();
            String StpTempRole = GA_Util03_WrkflwStpDataAccessHelper.BLANK;
            String StpTempQueue = GA_Util03_WrkflwStpDataAccessHelper.BLANK;
            set<id> curridSet=new set<id>();
            curridSet.add(wrfId);
            string wfsIdString=GA_Util08_FilterProcessHelper.idSet(curridSet);
            
            set<id> wrfTmpidSet=new set<id>();
            wrfTmpidSet.add(wrfTmpId);
            string wrfTmpidString=GA_Util08_FilterProcessHelper.idSet(wrfTmpidSet);
            string nmStrng=GA_Util08_FilterProcessHelper.FltrString(wrfStpNme);
            string stsStrng=GA_Util08_FilterProcessHelper.FltrString(statusVal);
            //Query exisitng workflow step records to verify if Current step already exist
            //use subquery to query related workflow process records
            
            list<GA_WF_Step__c> wfstpRecLstInsrt=GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(SelectWFStpQuery,
                                                                                                         whereWFId + GA_Util08_FilterProcessHelper.FltrString(wrfId), 
                                                                                                         orderbyCrtDt, 
                                                                                                         GA_Util14_WFStepTmpltDataAccesHelper.BLANK).values();
            
            
            //[select id,Name,OwnerId,(select id,Name,GA_Group_Segment_ID__c,ownerId from GA_WF_Group_Segments__r) from GA_WF_Step__c where GA_WF_Workflow_ID__c=:wrfId order by createddate desc];
            map<string,list<GA_WF_Group_Segment__c>> priorStps=new map<string,list<GA_WF_Group_Segment__c>>();
            for(GA_WF_Step__c wfStp:wfstpRecLstInsrt)
            {
                //map step with related workflow process records
                if(wfStp.GA_WF_Group_Segments__r.size()>0)
                    priorStps.put(wfStp.Name,wfStp.GA_WF_Group_Segments__r);
            }
            
            list<GA_WFT_Step__c> wkstepTmpLst=GA_Util14_WFStepTmpltDataAccesHelper.fetchwrkflowStpTmpsMap(wfStpTmpselectQuery, 
                                                                                                          wfStpTmpwhereClause+nmStrng+
                                                                                                          wfStpTmpwhereClause1+wrfTmpidString, 
                                                                                                          GA_Util14_WFStepTmpltDataAccesHelper.BLANK, 
                                                                                                          limitClause).values();
            
            id OwnerIdVal;
            boolean condAssn=false;
            boolean ownrExst=false;
            if(wkstepTmpLst.size()>0)
            {
                //need to change it to single select piclist ,hence split is not required inplace of contains we can use equal
                string condAssgn=wkstepTmpLst[0].GA_Conditional_Assignment__c;
                StpTempRole = wkstepTmpLst[0].GA_Role__c;                
                StpTempQueue = wkstepTmpLst[0].GA_Queue__c;
                list<QueueSobject> queueLst;
                user usr=  GA_Util08_FilterProcessHelper.fetchUsrDtls(userInfo.getUserId()); 
                //[select id,name,GA_RoleName__c from user where id=:cuttwrfStpOwnr limit 1];
                
                if(StpTempQueue.contains(PCS)){
                    queueLst=GA_Util18_QueueDataAccesHelper.fetchQueuesMap(SelectQueueQry,
                                                                           whereQueuNmLike + GA_Util08_FilterProcessHelper.FltrString(PCSQ) +                                                                                                                                
                                                                           whereSobj + GA_Util08_FilterProcessHelper.FltrString(WFGSObjectApi) ,
                                                                           GA_Util18_QueueDataAccesHelper.BLANK, 
                                                                           limitStr2).values();
                    
                    //[SELECT Id, Queue.name,Queue.developerName,QueueId FROM QueueSobject where Queue.name Like :wkstepTmpLst[0].GA_Queue__c and SobjectType = 'GA_WF_Group_Segment__c'  limit 2];
                    if(queueLst.size()>0)
                        
                    {
                        
                        
                        for(QueueSobject queu : queueLst){
                            
                            if((usr.GA_RoleName__c==PCSSupport) && (queu.queue.developerName == PCSSupportQueue)){
                                OwnerIdVal=queu.queueId;}
                            else if((usr.GA_RoleName__c== PCSWMSupport) && (queu.queue.developerName == PCSWMSupportQueue)){
                                OwnerIdVal=queu.queueId;
                            }
                            else if((usr.GA_RoleName__c== WMSupport || usr.GA_RoleName__c== WMSupportMgr) && (queu.queue.developerName == PCSWMSupportQueue)){
                                OwnerIdVal=queu.queueId;
                            }
                            else if ((wrflwOnerRole==WMSupport || wrflwOnerRole==PCSWMSupport || wrflwOnerRole== WMSupportMgr) && (queu.queue.developerName == PCSWMSupportQueue))
                            {
                               OwnerIdVal=queu.queueId; 
                            }
                            else
                            {
                                if(queu.queue.developerName == PCSSupportQueue)
                                    OwnerIdVal=queu.queueId;
                            }
                        }
                    }
                    else
                    {
                        OwnerIdVal=userinfo.getUserId();
                    }
                }
                else{
                    queueLst=GA_Util18_QueueDataAccesHelper.fetchQueuesMap(SelectQueueQry,
                                                                           whereQueName + GA_Util08_FilterProcessHelper.FltrString(wkstepTmpLst[0].GA_Queue__c) +                                                                                                                                
                                                                           whereSobj + GA_Util08_FilterProcessHelper.FltrString(WFGSObjectApi) ,
                                                                           GA_Util18_QueueDataAccesHelper.BLANK, 
                                                                           limitClause).values();
                    
                    //[SELECT Id, Queue.name,QueueId FROM QueueSobject where Queue.name=:wkstepTmpLst[0].GA_Queue__c and SobjectType = 'GA_WF_Group_Segment__c'  limit 1];
                    if(queueLst.size()>0)
                    {
                        OwnerIdVal=queueLst[0].QueueId;
                    } 
                    else
                    {
                        OwnerIdVal=userinfo.getUserId();
                    }
                    
                }
                //next step is underwritting current step front end check cond asing-gwc assigmet
                //
                if((!string.isBlank(condAssgn) && condAssgn !=NA) && currwrfStpNme!= Preprocessing && wrfStpNme != ASRtoModify)
                {
                    condAssn=true;
                    
                    //queueLst=[SELECT Id, Queue.name,QueueId FROM QueueSobject where Queue.name=:wkstepTmpLst[0].GA_Queue__c and SobjectType = 'GA_WF_Group_Segment__c'  limit 1];
                    
                    for(string priorStp:priorStps.keySet())
                    {
                        
                        if(condAssgn==priorStp)
                        {
                            //loop through prior step related workflow process records and nect step related workflow process records
                            list<GA_WF_Group_Segment__c> WFGrpSGmntsLst;
                            WFGrpSGmntsLst=priorStps.get(priorStp);
                            map<id,id> grpNoOwnrId=new map<id,id>();
                            if(WFGrpSGmntsLst.size()>0)
                            {
                                for(GA_WF_Group_Segment__c grpSGmnts:WFGrpSGmntsLst)
                                {
                                    grpNoOwnrId.put(grpSGmnts.GA_Group_Segment_ID__c,grpSGmnts.OwnerId);
                                }
                                for(GA_WF_Group_Segment__c grpSGmnts:currntGrpSgmnetsLst)
                                {
                                    if(grpNoOwnrId.get(grpSGmnts.GA_Group_Segment_ID__c) !=null)
                                    {
                                        grpSGmnts.OwnerId=grpNoOwnrId.get(grpSGmnts.GA_Group_Segment_ID__c);   
                                    }
                                    else
                                    {
                                        grpSGmnts.OwnerId=OwnerIdVal; 
                                    }
                                    currntGrpSgmnetsLstWithOwnr.add(grpSGmnts);
                                }
                                ownrExst=true;
                                break;   
                            }
                            
                        }
                    } 
                    
                    
                }
                if((string.isBlank(condAssgn) || ownrExst==false || condAssgn ==NA) && currwrfStpNme!=Preprocessing && wrfStpNme !=ASRtoModify)
                {
                    condAssn=false;
                    
                }
                if(wrfStpNme !=ASRtoModify)      
                {
                    
                    
                    list<User_Step_Role_Mapping__mdt> usrstpRlsMap= [select id,GA_User_Role__c,GA_Step_Role__c from User_Step_Role_Mapping__mdt where GA_User_Role__c=:usr.GA_RoleName__c limit 1];
                    if(usrstpRlsMap.size()>0 && StpTempRole == usrstpRlsMap[0].GA_Step_Role__c)
                    {
                        condAssn=false;
                        OwnerIdVal=userInfo.getUserId();
                    }
                    
                    
                    
                    
                }
                if(wrfStpNme==ASRtoModify)
                {
                    condAssn=false;
                    OwnerIdVal=priorStps.get(Preprocessing)[0].OwnerId;
                }
            }
            if(OwnerIdVal==null)
                OwnerIdVal=userinfo.getUserId();
            if(!condAssn)
            {
                currntGrpSgmnetsLstWithOwnr=new list<GA_WF_Group_Segment__c>();
                for(GA_WF_Group_Segment__c grpSGmnts:currntGrpSgmnetsLst)
                {
                    grpSGmnts.OwnerId=OwnerIdVal;
                    currntGrpSgmnetsLstWithOwnr.add(grpSGmnts);
                } 
            }
            return currntGrpSgmnetsLstWithOwnr;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, getWFOwnerInfo);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    
}