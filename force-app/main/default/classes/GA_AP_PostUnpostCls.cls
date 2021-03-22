/**
@Author : IDC offshore
@Name: GA_AP_PostUnpostCls
@CreatedDate: 18 - Sep 2018 
@Description: GA_AP_PostUnpostCls class is to post/unpost group segments created through ASEp processing
@version : 1.0  
*/
public class GA_AP_PostUnpostCls {
    
    public static string ClsName='GA_AP_PostUnpostCls';
    public static string methodNme='postUnpostSgmnts';
    public static string inSuffMsg=system.label.GA_PostIsuffErrMsg; 
    public static string ErrMsg=system.label.GA_Group_Post_UnPost_Error;
    public static string ScssMsg=system.label.GA_Group_Post_Sucess;
    public static string ScssMsgunPost=system.label.GA_Group_UnPost_Sucess;
    public static string AlrdyPostedMsg=system.label.GA_Group_Post_UnPost_Info;
    public static string NonASEPGrpSgmt=system.label.GA_ASEP_Process_Records;
    public static string ActvGrpPostedMsg=system.label.GA_Active_Grp_Sgmnt_Post_Msg;
    public static string LockAccPostedMsg=system.label.GA_Record_Lock_Post_Msg;
    public static string PndgLbl='Pending';
    public static string SmrtLbl='SMART';
    public static string StpOwnrLbl='PT1';
    /**
@Description: postUnpostSgmnts() method 
@Name : postUnpostSgmnts
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    @AuraEnabled
    public static string postUnpostSgmnts(string GrpSgmntId)
    {
        try
        {
            list<GA_Trigger_Functionality_By_Pass__c> pstUnpstbypss = [select id,GA_Post_Unpost_Validation__c,SetupOwner.Name from GA_Trigger_Functionality_By_Pass__c where SetupOwnerId=:userInfo.getProfileId() limit 1];
            if(pstUnpstbypss.size()>0 && pstUnpstbypss[0].GA_Post_Unpost_Validation__c){
                
                GA_Group_Segment__c grpSgmnt=[select id,GA_Date_Posted__c,Status__c,GA_Account__r.GA_System_of_Record__c,GA_Post_Transaction__c,GA_Transaction_Posted__c
                                              from GA_Group_Segment__c where id =:GrpSgmntId];
                
                    
                if(grpSgmnt.GA_Account__r.GA_System_of_Record__c!=SmrtLbl || pstUnpstbypss[0].SetupOwner.Name ==StpOwnrLbl)
                {
                    if(grpSgmnt.Status__c==PndgLbl)
                    {
                      if(!grpSgmnt.GA_Transaction_Posted__c)
                    {
                        if(grpSgmnt.GA_Date_Posted__c ==null || !grpSgmnt.GA_Post_Transaction__c)
                        {
                            grpSgmnt.GA_Date_Posted__c=system.today();
                            grpSgmnt.GA_Post_Transaction__c=true;                
                            database.update(grpSgmnt);
                            return ScssMsg;
                        }
                        else
                        {
                           // grpSgmnt.GA_Post_Transaction__c=false;                
                           // database.update(grpSgmnt);
                            return ScssMsgunPost;
                        }
                        
                    }
                    else
                        return AlrdyPostedMsg;   
                    }
                    else
                    {
                        return ActvGrpPostedMsg;
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
@Description: unpostGrpSgmnts() method 
@Name : unpostGrpSgmnts
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    @AuraEnabled
    public static string unpostGrpSgmnts(string GrpSgmntId)
    {
        try
        {
            GA_Group_Segment__c grpSgmnt=[select id,GA_Date_Posted__c,Status__c,GA_Account__r.GA_System_of_Record__c,GA_Post_Transaction__c,GA_Transaction_Posted__c
                                          from GA_Group_Segment__c where id =:GrpSgmntId];
            
            grpSgmnt.GA_Post_Transaction__c=false;                
            database.update(grpSgmnt);
            return ScssMsgunPost;
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            throw new AuraHandledException(ErrMsg); 
        } 
    }
}