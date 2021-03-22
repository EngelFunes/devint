/*****************************************************************************************
Class Name   : GA_AP_GrpSegntAssnmtCls
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to assign the GS ownership
******************************************************************************************/
public with sharing class GA_AP_GrpSegntAssnmtCls {
    
    public static final String QUEUE = 'Queue';
    public static final String QUEUTYPE = 'Unmanaged';
    public static final String USER = 'User';
    //public static final String autoValdtn = 'Automated Validation';
    //public static final String Closed = 'Closed';
    public static final String OPENSGBR = '[' ;
    public static final String CLOSEDSGBR = ']' ;
    public static final String COMMASYB = ',' ;
    public static final String SPLITSTR = '\\s+' ;
    public static final String BLANKSTR = '' ;
    public static final String WFGSSELECTQUERY = 'select id,GA_Workflow_ID__c,GA_Workflow_Next_Step__c,GA_Tracking_Status__c,GA_WF_Step_ID__c,GA_Group_Segment_ID__c,GA_WF_Step_ID__r.Name,owner.type,owner.name,ownerid,GA_Group_Segment_ID__r.Name,GA_ManagerId__c from GA_WF_Group_Segment__c';
    public static final String WFGSWHERE =  ' where id in ';
    //public static final String WFGSWHERESTEPID =  ' WHERE GA_WF_Step_ID__c = ';
   //public static final String WFGSWhereGrpSgmntId = ' AND GA_Group_Segment_ID__c IN ';
    //public static final String WFGSWhereWFNxtStp = ' AND GA_Workflow_Next_Step__c = ';
    public static final String WFGSLIMIT = 'limit 4000';
    //public static final String WFStpSelectQuery = 'SELECT GA_WF_Workflow_ID__c, GA_WF_Template_Step__c,GA_WF_Template_Step__r.GA_WFT_Inventory_Step_ID__r.Name, GA_WF_Workflow_ID__r.GA_Workflow_Template__c FROM GA_WF_Step__c ';
    //public static final String WFStpWhereQuery = 'WHERE Id = ';
    //public static final String WFStplimit = ' limit 200';
    //public static final String WFTStpSelQuery = 'SELECT Id, Name, GA_WFT_Inventory_Step_ID__r.Name FROM GA_WFT_Step__c';
    //public static final String WFTStpwhereQuery = ' WHERE Id = ';  
    //public static final String WFTStpLimit = ' limit 1000 '; 
    public static final String WFQUEUESELQUERY = 'SELECT GA_QueueName__c, GA_QueueType__c,GA_ApplyFilter__c FROM GA_WF_Queue_Mapping__mdt';
    public static final String WFQUEUELIMIT = ' limit 100 '; 
    public static final string FETCHWKGPSMSTEPS  ='FectWKGrpSgmntSteps';
    public static final string CLSNAME  ='GA_AP_GrpSegntAssnmtCls';
    public static final String EXCEPTIONSEPARATOR=': ';
    public static final string UPDATEWKGRPSGMNTSMETHOD  = 'updateWKGrpSgmnts';
    public static final string CHECKQUEUEINFOMTHD  = 'checkQueueInfo';
    public static final String ASSIGNERR = ': : Assignment failed. Return to Queue to refresh and reselect.';
    public static final String SUCCESSMSG = ': Successfully assigned';
    public static final String QUEUEPREFIXID = '00G';
    public static final String ASSIGNOWNMTHD = 'assignOwnerWFGS';
    public static final String MANAGDTYP = 'Managed';
    //public static final String openSts = 'Open';
    //public static final String nullStr = 'NULL';
    public static final String TILDESTR = '~';
    public static final String USRLBL = 'User';
    //public static final String QueLbl = 'Queue';
    public static final String FLSELBL = 'false';
    /**
@Description: FectWKGrpSgmntSteps() method 
@Name : FectWKGrpSgmntSteps
@Param : string wfGrpIds,GA_WF_Group_Segment__c grpSgmntRecTmp
@Return : list<GA_WF_Group_Segment__c>
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static list<GA_WF_Group_Segment__c> FectWKGrpSgmntSteps(string wfGrpIds,GA_WF_Group_Segment__c grpSgmntRecTmp)
    {
        try{           
            
            list<GA_WF_Group_Segment__c> wkGrpSgmntsToUpdate=new list<GA_WF_Group_Segment__c>();
            list<GA_WF_Group_Segment__c> wkGrpSgmnts=new list<GA_WF_Group_Segment__c>();
            list<id> stepsIds=new list<id>();
            Id wfStpId =  null;
            if(String.isNotBlank(wfGrpIds) ){
            string wfGrpIdsTmp=wfGrpIds.remove(OPENSGBR).remove(CLOSEDSGBR);
            wfGrpIdsTmp= wfGrpIdsTmp.replaceAll( SPLITSTR, BLANKSTR);
            list<id> wfGrpIdsTmpLst=wfGrpIdsTmp.split(COMMASYB);
            set<id> wkflwGSStpIdSet=new set<id>();
            
            
                wkflwGSStpIdSet.addall(wfGrpIdsTmpLst);
                wkGrpSgmnts= GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(WFGSSELECTQUERY,WFGSWHERE+GA_Util08_FilterProcessHelper.idSet(wkflwGSStpIdSet),GA_Util15_WFGSDataAccesHelper.BLANK,WFGSLIMIT).values();
                for(GA_WF_Group_Segment__c wrkGrpSgmnt:wkGrpSgmnts)
                {
                    wfStpId = wrkGrpSgmnt.GA_WF_Step_ID__c;
                    stepsIds.add(wfStpId);
                }
            }
            return wkGrpSgmnts;
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, FETCHWKGPSMSTEPS);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+EXCEPTIONSEPARATOR+e.getMessage()); 
        }
    }
    /**
@Description: updateWKGrpSgmnts() method 
@Name : updateWKGrpSgmnts
@Param : string wfGrpIds,GA_WF_Group_Segment__c grpSgmntRecTmp
@Return : None
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static void updateWKGrpSgmnts(string wfGrpIds,GA_WF_Group_Segment__c grpSgmntRecTmp)
    {
        try{  
            list<GA_WF_Group_Segment__c> wkGrpSgmntsToUpdate=new list<GA_WF_Group_Segment__c>();
            list<id> stepsIds=new list<id>();
            if(String.isNotBlank(wfGrpIds) ){
            string wfGrpIdsTmp=wfGrpIds.remove(OPENSGBR).remove(CLOSEDSGBR);
            wfGrpIdsTmp= wfGrpIdsTmp.replaceAll( SPLITSTR, BLANKSTR);
            list<id> wfGrpIdsTmpLst=wfGrpIdsTmp.split(COMMASYB);
            set<id> wkflwGSStpIdSet=new set<id>();
            wkflwGSStpIdSet.addall(wfGrpIdsTmpLst);
            
                list<GA_WF_Group_Segment__c> wkGrpSgmnts= GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(WFGSSELECTQUERY,WFGSWHERE+GA_Util08_FilterProcessHelper.idSet(wkflwGSStpIdSet),GA_Util15_WFGSDataAccesHelper.BLANK,WFGSLIMIT).values();
                
                for(GA_WF_Group_Segment__c wrkGrpSgmnt:wkGrpSgmnts)
                {
                    wrkGrpSgmnt.GA_Tracking_Status__c=grpSgmntRecTmp.GA_Tracking_Status__c;
                    wkGrpSgmntsToUpdate.add(wrkGrpSgmnt);
                }
                
                GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(wkGrpSgmntsToUpdate, GA_Util15_WFGSDataAccesHelper.UPDATE_OPERATION);
            }
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, UPDATEWKGRPSGMNTSMETHOD);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+EXCEPTIONSEPARATOR+e.getMessage()); 
        }
    }
    /**
@Description: checkQueueInfo() method 
@Name : checkQueueInfo
@Param : string wfGrpIds,GA_WF_Group_Segment__c grpSgmntRecTmp
@Return : boolean
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static boolean checkQueueInfo(string wfGrpIds,GA_WF_Group_Segment__c grpSgmntRecTmp)
    {
        try{ 
           
            if(String.isNotEmpty(wfGrpIds)){
                String recQueueName = '';
                list<id> stepsIds=new list<id>();
                string wfGrpIdsTmp=wfGrpIds.remove(OPENSGBR).remove(CLOSEDSGBR);
                wfGrpIdsTmp= wfGrpIdsTmp.replaceAll( SPLITSTR, BLANKSTR);
                list<id> wfGrpIdsTmpLst=wfGrpIdsTmp.split(COMMASYB);
                set<id> wkflwGSStpIdSet=new set<id>();
                wkflwGSStpIdSet.addall(wfGrpIdsTmpLst);
                list<GA_WF_Group_Segment__c> wkGrpSgmnts=GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(WFGSSELECTQUERY,WFGSWHERE+GA_Util08_FilterProcessHelper.idSet(wkflwGSStpIdSet),GA_Util15_WFGSDataAccesHelper.BLANK,WFGSLIMIT).values();
                
                if(wkGrpSgmnts[0].owner.type == QUEUE){
                    recQueueName =  wkGrpSgmnts[0].owner.name;
                 //   List<GA_WF_Queue_Mapping__mdt> queueMap =  [SELECT GA_QueueName__c, GA_QueueType__c FROM GA_WF_Queue_Mapping__mdt  limit 100];
                    for(GA_WF_Queue_Mapping__mdt queueDls : [SELECT GA_QueueName__c, GA_QueueType__c FROM GA_WF_Queue_Mapping__mdt  limit 100]){
                        if(queueDls.GA_QueueName__c == recQueueName && queueDls.GA_QueueType__c == QUEUTYPE){
                            return true;
                        }
                    }
                }
            }
            return false;
            
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, CHECKQUEUEINFOMTHD);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+EXCEPTIONSEPARATOR+e.getMessage()); 
        }
    }
    /**
@Description: checkQueueType() method 
@Name : checkQueueType
@Param : string wfGrpIds,GA_WF_Group_Segment__c grpSgmntRecTmp
@Return : List<String>
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static List<String> checkQueueType(string wfGrpIds,GA_WF_Group_Segment__c grpSgmntRecTmp,boolean prjSupprt)
    {
        try{
            List<String> assignmentMessages = New List<String>();
            String recQueueName = '';
            string wfGrpIdsTmp=wfGrpIds.remove(OPENSGBR).remove(CLOSEDSGBR);
            wfGrpIdsTmp= wfGrpIdsTmp.replaceAll( SPLITSTR, BLANKSTR);
            list<id> wfGrpIdsTmpLst=wfGrpIdsTmp.split(COMMASYB);
            set<id> wkflwGSStpIdSet=new set<id>();
            wkflwGSStpIdSet.addall(wfGrpIdsTmpLst);
            
            if(String.isNotEmpty(wfGrpIds)){
                list<GA_WF_Group_Segment__c> wkGrpSgmnts=GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(WFGSSELECTQUERY,WFGSWHERE+GA_Util08_FilterProcessHelper.idSet(wkflwGSStpIdSet),GA_Util15_WFGSDataAccesHelper.BLANK,WFGSLIMIT).values();
                Map<Id,String> grpSegOwnerMap = New  Map<Id,String>();
                grpSegOwnerMap.clear();
                for(GA_WF_Group_Segment__c wfgs : wkGrpSgmnts ){
                   grpSegOwnerMap.put(wfgs.Id,wfgs.owner.type+TILDESTR+wfgs.owner.name+TILDESTR+Wfgs.GA_Group_Segment_ID__r.Name+TILDESTR+Wfgs.GA_ManagerId__c);
                }
                
                
                List<GA_WF_Queue_Mapping__mdt> queueCMLst = GA_Util16_MetaDataAccessLayer.fetchWFqueueMap(WFQUEUESELQUERY,GA_Util16_MetaDataAccessLayer.BLANK,GA_Util16_MetaDataAccessLayer.BLANK,WFQUEUELIMIT).values();
                List<GA_WF_Group_Segment__c> updtWfgsLst = New List<GA_WF_Group_Segment__c>();
               GA_WF_Group_Segment__c   upWfgs = new GA_WF_Group_Segment__c(); 
                for(Id wfgsid : grpSegOwnerMap.keyset()){
                    List<String> wfgsQueDtls = grpSegOwnerMap.get(wfgsid).split(TILDESTR);
                    for(GA_WF_Queue_Mapping__mdt queueDls : queueCMLst){
                        if( wfgsQueDtls[0]==QUEUE   ){
                        if((queueDls.GA_QueueName__c == wfgsQueDtls[1]  && queueDls.GA_QueueType__c == QUEUTYPE) ){
                               upWfgs = New GA_WF_Group_Segment__c(id=wfgsid,ownerid = Userinfo.getUserId());
                            updtWfgsLst.add(upWfgs);    
                            assignmentMessages.add(wfgsQueDtls[2]+SUCCESSMSG);
                        }
                            if((queueDls.GA_QueueName__c == wfgsQueDtls[1]  && queueDls.GA_QueueType__c == MANAGDTYP)
                              && queueDls.GA_ApplyFilter__c ){
                                assignmentMessages.add(queueDls.GA_QueueName__c);
                            }
                            
                       }
                     }
                    
                    if(wfgsQueDtls[0]==USRLBL && prjSupprt){
                           upWfgs = New GA_WF_Group_Segment__c(id=wfgsid,ownerid = Userinfo.getUserId());
                        updtWfgsLst.add(upWfgs);    
                        assignmentMessages.add(wfgsQueDtls[2]+SUCCESSMSG);
                    }
                    
                    if( wfgsQueDtls[0]==USRLBL && wfgsQueDtls[3] == FLSELBL && !prjSupprt){
                        
                        assignmentMessages.add(wfgsQueDtls[2]+ASSIGNERR);  
                    }
                }
              
                if(!updtWfgsLst.isEmpty()){
                   GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(updtWfgsLst, GA_Util15_WFGSDataAccesHelper.UPDATE_OPERATION);
                }
                    
                  
                
            }
            else{
                return New List<String>{System.Label.GA_SelectRecord};
                    }
            
            
          
            return assignmentMessages;
            
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, checkQueueInfoMthd);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+EXCEPTIONSEPARATOR+e.getMessage()); 
        }
    }
    
    /**
@Description: assignOwnerWFGS() method 
@Name : assignOwnerWFGS
@Param : string wfGrpIds,GA_WF_Group_Segment__c grpSgmntRecTmp,String ownrId
@Return : List<String>
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static List<String> assignOwnerWFGS(string wfGrpIds,GA_WF_Group_Segment__c grpSgmntRecTmp,String ownrId)
    {
        try{
            List<String> assignedmsg = New List<String>();
            list<GA_WF_Group_Segment__c> wkGrpSgmntsToUpdate=new list<GA_WF_Group_Segment__c>();
            string wfGrpIdsTmp=wfGrpIds.remove(OPENSGBR).remove(CLOSEDSGBR);
            wfGrpIdsTmp= wfGrpIdsTmp.replaceAll( SPLITSTR, BLANKSTR);
            list<id> wfGrpIdsTmpLst=wfGrpIdsTmp.split(COMMASYB);
            set<id> wkflwGSStpIdSet=new set<id>();
            wkflwGSStpIdSet.addall(wfGrpIdsTmpLst);
            if(String.isNotBlank(wfGrpIdsTmp) ){
                list<GA_WF_Group_Segment__c> wkGrpSgmnts= GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(WFGSSELECTQUERY,WFGSwhere+GA_Util08_FilterProcessHelper.idSet(wkflwGSStpIdSet),GA_Util15_WFGSDataAccesHelper.BLANK,WFGSlimit).values();
                User usr = [Select id,username,name from User where id =: ownrId Limit 1 ];
                for(GA_WF_Group_Segment__c wrkGrpSgmnt:wkGrpSgmnts)
                {
                    
                    if(wrkGrpSgmnt.owner.type == USER ){
                        
                        if( wrkGrpSgmnt.ownerid == userinfo.getUserId() && userinfo.getUserId()  == ownrId){
                            String msg = wrkGrpSgmnt.GA_Group_Segment_ID__r.Name+ ASSIGNERR;
                            assignedmsg.add(msg);  
                        }
                        if( wrkGrpSgmnt.ownerid == userinfo.getUserId() && userinfo.getUserId()  <> ownrId){
                            wrkGrpSgmnt.ownerId=ownrId;
                            String msg = wrkGrpSgmnt.GA_Group_Segment_ID__r.Name+SUCCESSMSG;
                            assignedmsg.add(msg);
                        } 
                        if( wrkGrpSgmnt.GA_ManagerId__c){
                            wrkGrpSgmnt.ownerId=ownrId;
                            String msg = wrkGrpSgmnt.GA_Group_Segment_ID__r.Name+SUCCESSMSG;
                            assignedmsg.add(msg);
                        } 
                        
                    }
                    if(wrkGrpSgmnt.owner.type == QUEUE ){
                        Boolean isOwnerQueue = String.valueof(wrkGrpSgmnt.ownerId).startsWith(QUEUEPREFIXID);
                       
                        if(isOwnerQueue){
                            wrkGrpSgmnt.ownerId=ownrId;
                            String msg =  wrkGrpSgmnt.GA_Group_Segment_ID__r.Name+SUCCESSMSG;
                            assignedmsg.add(msg);
                        }
                        else{
                            String msg = wrkGrpSgmnt.GA_Group_Segment_ID__r.Name+ ASSIGNERR;
                            assignedmsg.add(msg);   
                        }
                    }
                    //wrkGrpSgmnt.Name=grpSgmntRec.Name;
                    wkGrpSgmntsToUpdate.add(wrkGrpSgmnt);
                }
                database.update(wkGrpSgmntsToUpdate);
            }
            return  assignedmsg;
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, ASSIGNOWNMTHD);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+EXCEPTIONSEPARATOR+e.getMessage()); 
        }
    }

   
}