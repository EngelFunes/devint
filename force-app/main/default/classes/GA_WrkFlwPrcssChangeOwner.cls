/*****************************************************************************************
Class Name   : GA_WrkFlwPrcssChangeOwner
Date Created : 29-05-2018
Created By   : IDC Offshore
Description  : 1. This is class to restrict change owner on unmanaged queue
******************************************************************************************/
public class GA_WrkFlwPrcssChangeOwner {
    
    public static final string SelectQueueQry = 'SELECT Id, Queue.name,QueueId,Queue.developerName FROM QueueSobject where ';
    public static final string whereSobj = ' SobjectType = ';
    public static final string WFGSObjectApi='GA_WF_Group_Segment__c';
    public static final String WFQueueSelQuery = 'SELECT GA_QueueName__c, GA_QueueType__c FROM GA_WF_Queue_Mapping__mdt';
    public static final String WFQueueLimit = ' limit 100 ';
    public static final String queType = 'Unmanaged';
    public static final String ownrFld ='ownerid';
    public static final string queueCheck = '00G';
    public static final string ClsName  ='GA_WrkFlwPrcssChangeOwner';
    public static final string methodNme  ='RestrictChangeOwnerOManagedQueue';
    public static final string errMsg  ='Unable to perform validations';
    
    /**
@Description: wfallwdSteps() method 
@Name : wfallwdSteps
@Param :id wfTmpId, id wfId,Id wfstpId
@Return : List<String>
@throws Exception : AuraHandledException;
*/    
    public static void RestrictChangeOwnerOManagedQueue(map<id,GA_WF_Group_Segment__c> wkflProcssNewMap, map<id,GA_WF_Group_Segment__c>  wkflProcssOldMap){
        try{
            set<id> wfgsSetId = New Set<Id>();
            Map<id,id> wfgsOwnerMap = New Map<id,id>();
            for(GA_WF_Group_Segment__c wfgs : wkflProcssNewMap.values()){
                if( (wfgs.get(ownrFld) != wkflProcssOldMap.get(wfgs.Id).get(ownrFld))   ){
                    String ownrId = String.ValueOf(wkflProcssOldMap.get(wfgs.Id).get(ownrFld));
                    if(ownrId.contains(queueCheck)){
                        wfgsOwnerMap.put(wfgs.id,ownrId);
                    }
                }  
            }
            
            Map<Id,String> wfgsOwnerName = New Map<Id,String>();
            
            Map<Id,QueueSobject> queueMap= GA_Util18_QueueDataAccesHelper.fetchQueuesMap(SelectQueueQry,
                                                                                         whereSobj + GA_Util08_FilterProcessHelper.FltrString(WFGSObjectApi) ,
                                                                                         GA_Util18_QueueDataAccesHelper.BLANK, 
                                                                                         GA_Util18_QueueDataAccesHelper.BLANK);
            
            List<GA_WF_Queue_Mapping__mdt> queueMetaDataMap = GA_Util16_MetaDataAccessLayer.fetchWFqueueMap(WFQueueSelQuery,
                                                                                                            GA_Util16_MetaDataAccessLayer.BLANK,
                                                                                                            GA_Util16_MetaDataAccessLayer.BLANK,
                                                                                                            WFQueueLimit).values();
            
            for(Id wfgsId : wfgsOwnerMap.keySet()){
                for(QueueSobject que : queueMap.values()){
                    for(GA_WF_Queue_Mapping__mdt queueDls : queueMetaDataMap){
                        if( wfgsOwnerMap.get(wfgsId) == que.QueueId  &&  que.Queue.name == queueDls.GA_QueueName__c  && queueDls.GA_QueueType__c == queType){
                            wfgsSetId.add(wfgsId);
                            
                        }
                    }
                }
            }
            
            for(GA_WF_Group_Segment__c wrkProc : wkflProcssNewMap.values())
            {
                if(wfgsSetId.contains(wrkProc.Id) && wrkProc.OwnerId !=userInfo.getUserId())
                {
                    wrkProc.addError(System.Label.GA_InsuffPrvlg);
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
        }
    }
}