/*********************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_GS_UpdateRatingType
@CreatedDate: 01 - 11
@Description: GA_GS_UpdateRatingType class to assess Group Segment clustor code and update rating type
@version : 1.0  
**********************************************************************************************************************************************/

public with sharing class GA_AP_SendGSNotificationCls {
    public static string ClsName='GA_AP_SendGSNotificationCls';
    public static string methodNme='sendNotification';
    public static string methodNme1='sendNotificationToUsers';
    public static string inSuffMsg=system.label.GA_PostIsuffErrMsg; 
    public static string ErrMsg=system.label.GA_Group_Post_UnPost_Error;
    public static string LockAccPostedMsg=system.label.GA_Record_Lock_Post_Msg;
    public static string AlreadyPostedGSMsg=System.label.GA_AlrdyPosted;
    public static string NonASEPGrpSgmt=system.label.GA_ASEP_Process_Records;
    public static string SmrtLbl='SMART';
    public static string StpOwnrLbl='PT1';
    public static final String modificationComplt =  'GA_Group_Segment_Modification_Completed_Custom';
    public static final String Pending = 'Pending'  ;
    /**
@Description: sendNotification() method 
@Name : sendNotification
@Param :string GrpSgmntId
@Return : String
@throws Exception : ;
*/   
    
    @AuraEnabled
    public static String sendNotification(string GrpSgmntId)
    {
        try
        {
            list<GA_Trigger_Functionality_By_Pass__c> delGrpgSgmntbypss = [select id,   GA_Send_GS_Notfication__c,SetupOwner.Name from GA_Trigger_Functionality_By_Pass__c where SetupOwnerId=:userInfo.getProfileId() limit 1];
            if(delGrpgSgmntbypss.size()>0 && delGrpgSgmntbypss[0].GA_Send_GS_Notfication__c){
                
                GA_Group_Segment__c grpSgmnt=[select id,GA_Date_Posted__c,Name,Status__c,GA_Account__r.GA_System_of_Record__c,GA_Post_Transaction__c,GA_Transaction_Posted__c,GA_SourceASG__c
                                              from GA_Group_Segment__c where id =:GrpSgmntId Limit 1];
                
                
                if(grpSgmnt.GA_Account__r.GA_System_of_Record__c!=SmrtLbl || delGrpgSgmntbypss[0].SetupOwner.Name ==StpOwnrLbl)
                {
                    if(grpSgmnt.GA_SourceASG__c==True)
                    {
                        if((grpSgmnt.GA_Transaction_Posted__c == True)&&(grpSgmnt.Status__c == Pending))
                        {
                            //archiveGSRecs(grpSgmnt);
                            return 'Group Segment reseted Successfully';
                        }
                        else
                        {
                            return AlreadyPostedGSMsg;
                        }
                    }
                    else
                    {
                        return NonASEPGrpSgmt;
                    }   
                }
                else
                {
                    return LockAccPostedMsg;
                }
                
            }
            else{
                return inSuffMsg;
            }
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            throw new AuraHandledException(ErrMsg); 
        }  
    }
    
    /**
@Description: sendNotificationToUsers() method 
@Name : sendNotificationToUsers
@Param :string GrpSgmntId,String msgNts
@Return : boolean
@throws Exception : ;
*/   
    
    @AuraEnabled
    public static boolean sendNotificationToUsers(string GrpSgmntId,String msgNts)
    {
        
        try
        {
            GA_Group_Segment__c GrpSg  =[select id,Name,GA_PostGrpNots__c,GA_Account__c,GA_Account__r.Name,GA_Date_Posted__c,
                                         GA_MTV_Group__c,GA_Post_Transaction__c,GA_Transaction_Posted__c
                                         from GA_Group_Segment__c where id =:GrpSgmntId Limit 1];
            GrpSg.GA_PostGrpNots__c = msgNts;
            update GrpSg;
            list<GA_Trigger_Functionality_By_Pass__c> gsMailboxLst = [select id,GA_Send_GS_Notfication__c,GA_GS_CC_Notification_Email__c,GA_GS_To_Notification_Mailbox__c,GA_GS_From_Notification_Mailbox__c from GA_Trigger_Functionality_By_Pass__c where SetupOwnerId=:userInfo.getProfileId() limit 1];
            
            if(gsMailboxLst.size()>0)
            {
                String[] SharedMailbox = New String[]{gsMailboxLst[0].GA_GS_To_Notification_Mailbox__c,gsMailboxLst[0].GA_GS_From_Notification_Mailbox__c,gsMailboxLst[0].GA_GS_CC_Notification_Email__c};
                    GA_Util22_SendEmail.sendMailtoUsrsUpdts(null, GrpSg, modificationComplt,SharedMailbox,true); 
                return true;
            }
            else
            {
                return false;
            }
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme1);
            throw new AuraHandledException(ErrMsg); 
        } 
    }
}