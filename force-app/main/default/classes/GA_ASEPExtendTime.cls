/**
@Author : Sri Lakshmi
@Name: GA_ASEPExtendTime
@CreatedDate: 26 - Oct 2018 
@Description: GA_ASEPExtendTime class is to extend time on ASEP Record page.
@version : 1.0  
*/
public without sharing class GA_ASEPExtendTime {
    public static final string ClsName  ='GA_ASEPExtendTime';
    public static string methodNme='ExtendTime';
    public static string ErrMsg='Cannot Extend Time';
    public static string inSufPrvlgsfMsg=system.label.GA_PostIsuffErrMsg;	
    public static string TimeAlrdyExtendedrMsg=system.label.GA_ASEP_Rec_Time_Already_Extended_Msg;
    public static string TimelimitOverMsg=system.label.GA_ASEPRec_ExtendTimeLimit_Over_Msg;
    public static string InvalidStatusMsg=system.label.GA_Pending_ASEP_Rec_ExtendTime_Msg;
    public static string LockAccPostedMsg=system.label.GA_Record_Lock_Post_Msg;
    public static string SmrtLbl='SMART';
    public static string StpOwnrLbl='PT1';
    public static string pendingCntl =  'Pending - Controllable' ;
    public static string pendingUnCntl =  'Pending - UnControllable' ;
    public static string rejectedCntl =  'Rejected - Controllable' ;
    public static string rejectedUnCntl =  'Rejected - UnControllable' ;
    public static string succmsg = 'Extened Time Successfully';
    /**
@Description: ExtendTime() method 
@Name : ExtendTime
@Param : N/A
@Return : boolean
@throws Exception : N/A
*/   
    @AuraEnabled
    public static String ExtendTime(string ASEPRecId){  
        
        list<GA_Trigger_Functionality_By_Pass__c> aasepExtnbypss = [select id,GA_ASEP_Extend_Time__c,SetupOwner.Name from GA_Trigger_Functionality_By_Pass__c where SetupOwnerId=:userInfo.getProfileId() limit 1];
        GA_Agent_Sold_Enrollment__c ASEPRec =  [Select Id,GA_Account_Id__r.GA_System_of_Record__c,GA_ASEP_Status__c,
                                                GA_Rejection_Notification_Date__c,GA_Extended_Date__c from GA_Agent_Sold_Enrollment__c
                                                where Id =:  ASEPRecId Limit 1];
        
        try{
            
            if(aasepExtnbypss.size()>0 && aasepExtnbypss[0].GA_ASEP_Extend_Time__c)
            {
                
                if(ASEPRec.GA_Account_Id__r.GA_System_of_Record__c!=SmrtLbl || aasepExtnbypss[0].SetupOwner.Name ==StpOwnrLbl)
                {
                    String asepSts = ASEPRec.GA_ASEP_Status__c;
                    if((asepSts.equalsIgnoreCase(pendingCntl) || asepSts.equalsIgnoreCase(pendingUnCntl)) && String.isNotEmpty(asepSts))
                    {
                        if(DateTime.Now()<ASEPRec.GA_Rejection_Notification_Date__c)
                        {
                            
                            
                            return succmsg;
                            
                        }
                        else
                        {
                            
                            return TimelimitOverMsg;
                        }
                        
                    }
                    
                    else
                    {
                        return InvalidStatusMsg;
                    }
                    
                }
                else
                {
                    return LockAccPostedMsg;
                }
                
                
            }
            
            
            else
            {   
                return inSufPrvlgsfMsg;
            }
            
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            throw new AuraHandledException(ErrMsg); 
        }
        
    }
    
    
    /**
@Description: extendto24hrs() method 
@Name : extendto24hrs
@Param : string ASEPRecId
@Return : boolean
@throws Exception : N/A
*/   
    @AuraEnabled   
    public static boolean extendto24hrs(string ASEPRecId){  
        
        try{
            
            GA_Agent_Sold_Enrollment__c ASEPRec =  [Select Id,GA_Account_Id__r.GA_System_of_Record__c,GA_ASEP_Status__c,
                                                    GA_Rejection_Notification_Date__c,GA_Extended_Date__c from GA_Agent_Sold_Enrollment__c
                                                    where Id =:  ASEPRecId Limit 1];
            
            Datetime dtOpn = ASEPRec.GA_Extended_Date__c;
            Datetime notificationDate = null;
            boolean dtCalc = false;
            BusinessHours bh = [SELECT Id FROM BusinessHours WHERE isdefault  = true];
            notificationDate = BusinessHours.add(bh.Id, dtOpn, 1000 * 60 * 60 * Integer.valueOf(System.label.GA_ASEP_ExtendTime));
            dtCalc = true;
            if(dtCalc)
                ASEPRec.GA_Extended_Date__c = notificationDate;
            update ASEPRec;
            return true;
            
        }
        
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            throw new AuraHandledException(ErrMsg); 
        }
    }
    
}