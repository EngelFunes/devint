/*********************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_ASEP_SendRejectionNotifications
@CreatedDate: 03 - 11
@Description: GA_ASEP_SendRejectionNotifications class is send notifcations on asep rejection
@version : 1.0  
**********************************************************************************************************************************************/

public class GA_ASEP_SendRejectionNotifications {
    public static string clsName='GA_ASEP_SendRejectionNotifications';
    public static string methodNme='sendASEPRejectionNotfctToUsers';
    public static string methodNme1='sendNotificationToUsers';
    public static string errMsg='Email notification failed';
    public static string pendingCntl =  'Pending - Controllable' ;
    public static string pendingUnCntl =  'Pending - UnControllable' ;
    public static string softrejectVFtmplt = 'GA_ASEP_record_Soft_rejected_VF';
    public static string rejectedCntl =  'Rejected - Controllable' ;
    public static string rejectedUnCntl =  'Rejected - UnControllable' ;
    public static string hardrejectVFtmplt = 'GA_ASEP_record_Hard_rejected_VF';
    public static string asepSts  = 'GA_ASEP_Status__c';
    public static string semicoln = ';';
    public Static Final String objName =  'GA_Agent_Sold_Enrollment__c';
    /**
@Description: sendASEPRejectionNotfctToUsers() method 
@Name : sendASEPRejectionNotfctToUsers
@Param :list<GA_Agent_Sold_Enrollment__c> ASEPList,map<id,GA_Agent_Sold_Enrollment__c> ASEPNewMap
@Return : 
@throws Exception : ;
*/       
    public static void sendASEPRejectionNotfctToUsers(list<GA_Agent_Sold_Enrollment__c> ASEPList,map<id,GA_Agent_Sold_Enrollment__c> ASEPNewMap,map<id,GA_Agent_Sold_Enrollment__c> asepOldMap){
        
        try{
            List<String> maEmails;
            
            for(GA_Agent_Sold_Enrollment__c ASEPRec : ASEPList)
            {
                maEmails = New List<String>();
                String managingAgentEmail = ASEPRec.GA_Email__c;
                 
               if((ASEPRec.GA_ASEP_Status__c == pendingCntl || ASEPRec.GA_ASEP_Status__c == pendingUnCntl) 
                  && (ASEPRec.get(asepSts) != asepOldMap.get(ASEPRec.Id).get(asepSts)))
                {
                    if(!String.isEmpty(managingAgentEmail))
                    {
                        maEmails = managingAgentEmail.split(semicoln);
                      //  GA_Util22_SendEmail.sendMailtoUsrs(null, ASEPRec.Id, softrejectVFtmplt,maEmails); 
                        GA_Util22_SendEmail.sendASEPMails(null,ASEPRec,objName,softrejectVFtmplt,maEmails,true);  
                    }
                    
                }
                
                if(ASEPRec.GA_ASEP_Status__c == rejectedCntl || 
                   ASEPRec.GA_ASEP_Status__c == rejectedUnCntl
                  && (ASEPRec.get(asepSts) != asepOldMap.get(ASEPRec.Id).get(asepSts)))
                {
                    if(managingAgentEmail != null)
                    {
                        maEmails = managingAgentEmail.split(semicoln);
                       // GA_Util22_SendEmail.sendMailtoUsrs(null, ASEPRec.Id, hardrejectVFtmplt,maEmails);   
                        GA_Util22_SendEmail.sendASEPMails(null,ASEPRec,objName,hardrejectVFtmplt,maEmails,true); 
                        
                    }
                }
                
            }
            
        }  
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, methodNme);
            throw new AuraHandledException(errMsg); 
        } 
    }
    /**
@Description: UpdateRejectionNotfctDate() method 
@Name : UpdateRejectionNotfctDate
@Param :list<GA_Agent_Sold_Enrollment__c> ASEPList,map<id,GA_Agent_Sold_Enrollment__c> ASEPNewMap
@Return : 
@throws Exception : ;
*/       
    public static void UpdateRejectionNotfctDate(list<GA_Agent_Sold_Enrollment__c> ASEPList,map<id,GA_Agent_Sold_Enrollment__c> ASEPNewMap){
        
        try{
            Datetime dtOpn = DateTime.Now();
            Datetime notificationDate = null;
            BusinessHours bh = [SELECT Id FROM BusinessHours WHERE isdefault  = true Limit 1];
			notificationDate = BusinessHours.add(bh.Id, dtOpn, 1000 * 60 * 60 * Integer.valueOf(System.label.GA_ASEP_Default_ExtendedDate));
            for(GA_Agent_Sold_Enrollment__c ASEPRec : ASEPList)
            {
                
               if((ASEPRec.GA_ASEP_Status__c == pendingCntl || ASEPRec.GA_ASEP_Status__c == pendingUnCntl) 
                   && !(ASEPRec.GA_Rejection_Notification_Date__c != null))
              
                {
                    ASEPRec.GA_Rejection_Notification_Date__c = notificationDate;
                    ASEPRec.GA_Extended_Date__c = notificationDate;
                    
                }
                 
            }
            
        }  
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, methodNme);
            throw new AuraHandledException(errMsg); 
        } 
    }
}