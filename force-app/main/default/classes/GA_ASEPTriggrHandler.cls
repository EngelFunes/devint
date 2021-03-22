public class GA_ASEPTriggrHandler {
    
    public static final String ClsName  ='GA_ASEPTriggrHandler';
    public static final String methodNmebeforeinsert = 'beforeinsert';
    public static final String methodNmebeforeupdate = 'beforeupdate';
    public static final String methodNmeafterupdate = 'afterupdate';
    public static final string AsepQue='ASEP Queue';
	public static final string AsepObj='GA_Agent_Sold_Enrollment__c';   
    public static final string AsepStatus='New';
    
    /***********************************************************************************************************************************************
@Description: beforeinsert() method 
@Name : afterinsert
@Param :list<GA_WF_Group_Segment__c> wkflProcssList,
map<id,GA_WF_Group_Segment__c> wkflProcssMap, map<id,Account>  wkflProcssMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void beforeinsert(list<GA_Agent_Sold_Enrollment__c> asepList,map<id,GA_Agent_Sold_Enrollment__c> asepNewMap)
    {
        try
        {
            QueueSobject asepQueue = [SELECT Id, Queue.name,QueueId FROM QueueSobject where Queue.name=:AsepQue and SobjectType = :AsepObj  limit 1];
            for(GA_Agent_Sold_Enrollment__c asep: asepList){
                asep.ownerid = asepQueue.QueueId; 
                asep.GA_ASEP_Status__c = AsepStatus;
            }
            
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmebeforeinsert);
        }
    }    
    /***********************************************************************************************************************************************
@Description: beforeupdate() method 
@Name : beforeupdate
@Param :list<GA_Agent_Sold_Enrollment__c> asepList,map<id,GA_Agent_Sold_Enrollment__c> asepNewMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void beforeupdate(list<GA_Agent_Sold_Enrollment__c> asepList,map<id,GA_Agent_Sold_Enrollment__c> asepNewMap)
    {
        try
        {
           GA_ASEP_SendRejectionNotifications.UpdateRejectionNotfctDate(asepList, asepNewMap);
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmebeforeupdate);
        }
    }
 /***********************************************************************************************************************************************
@Description: afterupdate() method 
@Name : afterupdate
@Param :list<GA_Agent_Sold_Enrollment__c> asepList, map<id,GA_Agent_Sold_Enrollment__c> asepNewMap,map<id,GA_Agent_Sold_Enrollment__c> asepOldMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/    
    public static void afterupdate(list<GA_Agent_Sold_Enrollment__c> asepList, map<id,GA_Agent_Sold_Enrollment__c> asepNewMap,map<id,GA_Agent_Sold_Enrollment__c> asepOldMap)
    {
        try
        {
            
            GA_ASEP_SendRejectionNotifications.sendASEPRejectionNotfctToUsers(asepList, asepNewMap,asepOldMap);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterupdate);
        }
    }      
     
}