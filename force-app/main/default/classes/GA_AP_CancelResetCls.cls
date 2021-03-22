/*********************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_AP_CancelResetCls
@CreatedDate: 01 - 11
@Description: GA_AP_CancelResetCls class is cancel/reset group segment posting 
@version : 1.0  
**********************************************************************************************************************************************/

public with sharing class GA_AP_CancelResetCls {
    public static string inSuffMsg=system.label.GA_PostIsuffErrMsg; 
    public static string ErrMsg='Cancel/Reset of group posting failed';
    public static string LockAccPostedMsg=system.label.GA_Record_Lock_Post_Msg;
    public static string AlreadyPostedGSMsg=System.label.GA_AlrdyPosted;
    public static string NonASEPGrpSgmt=system.label.GA_ASEP_Process_Records;
    public static string SmrtLbl='SMART';
    public static string StpOwnrLbl='PT1';
    public static final String Pending = 'Pending'  ;
    public static final String modificationRqstd =  'GA_Rqst_to_Modify_Posted_Group_Segment';
    public static string ClsName='GA_AP_CancelDelGrpCls';
    public static string methodNme='resetGrpSgmnts';
    public static string methodNme1='cnclResetSgmnts';
    public static string methodNme2='sendNotificationToUsers';
    
    /**
@Description: resetGrpSgmnts() method 
@Name : resetGrpSgmnts
@Param :string GrpSgmntId
@Return : String
@throws Exception : ;
*/       
    @AuraEnabled
    public static String resetGrpSgmnts(string GrpSgmntId)
    {
        try
        {
            list<GA_Trigger_Functionality_By_Pass__c> delGrpgSgmntbypss = [select id,GA_Reset_Group_Segments__c,SetupOwner.Name from GA_Trigger_Functionality_By_Pass__c where SetupOwnerId=:userInfo.getProfileId() limit 1];
            if(delGrpgSgmntbypss.size()>0 && delGrpgSgmntbypss[0].GA_Reset_Group_Segments__c){
                
                GA_Group_Segment__c grpSgmnt=[select id,GA_Date_Posted__c,Name,Status__c,GA_Account__r.GA_System_of_Record__c,GA_Post_Transaction__c,GA_Transaction_Posted__c,GA_SourceASG__c
                                              from GA_Group_Segment__c where id =:GrpSgmntId Limit 1];
                
                
                if(grpSgmnt.GA_Account__r.GA_System_of_Record__c!=SmrtLbl || delGrpgSgmntbypss[0].SetupOwner.Name ==StpOwnrLbl)
                {
                    if(grpSgmnt.GA_SourceASG__c==True)
                    {
                        if((grpSgmnt.GA_Transaction_Posted__c == True)&&(grpSgmnt.Status__c == Pending))
                        {
                            //archiveGSRecs(grpSgmnt);
                            return 'Group Segment reset completed';
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
@Description: cnclResetSgmnts() method 
@Name : cnclResetSgmnts
@Param :string GrpSgmntId
@Return : boolean
@throws Exception : ;
*/      
    @AuraEnabled
    public static boolean cnclResetSgmnts(string GrpSgmntId)
    {
        try{
            GA_Group_Segment__c grpSgmnt=[select id,GA_Date_Posted__c,GA_Post_Transaction__c,GA_Transaction_Posted__c
                                          from GA_Group_Segment__c where id =:GrpSgmntId Limit 1];
            if( grpSgmnt.GA_Transaction_Posted__c == True){
                grpSgmnt.GA_Transaction_Posted__c = false;
                grpSgmnt.GA_Post_Transaction__c=false;               
                database.update(grpSgmnt);
            }
            return true;  
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
        try{
            GA_Group_Segment__c GrpSg  =[select id,Name,GA_PostGrpNots__c from GA_Group_Segment__c where id =:GrpSgmntId];
            GrpSg.GA_PostGrpNots__c = msgNts;
            update GrpSg;
            
            
            String[] underwritingmailBox = New String[]{System.Label.GA_UWMailbox};
                
                GA_Util22_SendEmail.sendMailtoUsrs(null, GrpSg.Id, modificationRqstd,underwritingmailBox);
            
            return true;
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            throw new AuraHandledException(ErrMsg); 
        }
    }
}