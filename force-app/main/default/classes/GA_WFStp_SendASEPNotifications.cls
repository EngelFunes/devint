/*****************************************************************************************
Class Name   : GA_Util22_SendEmail
Created By   : IDC Offshore
Description  : 1. This is the util data access class to send email
Change History : 
******************************************************************************************/
public with sharing class  GA_WFStp_SendASEPNotifications {
    public Static Final string clsName = 'GA_WFStp_SendASEPNotifications';
    public Static Final string methodNme = 'sendASEPNotificationToUsers';
    public Static Final string errorMsg = 'Email notification failed, Please contact System administrator';
    public Static Final String sysAdmin = 'System Administrator';
    public Static Final String bcbsmAsepTmplt = system.label.GA_ASEP_BCBSM_WfTemplate;
    public Static Final String bcnAsepTmplt = system.label.GA_ASEP_BCN_WfTemplate;
    public Static Final String semiColon = ';';
    public Static Final String smallGrpUnderWritingStep = 'Small Group Underwriting - to Review';
    public Static Final String nbforAssgmntStep = 'NB - for Assignment';
    public Static Final String secondBCNLetterStep = 'Send 2nd BCN Letter';
    public Static Final String cmpltStep = 'Completed';
    public Static Final String firstBCBSMLetter =  'GA_1_BCBSM_Letter_VF';
    public Static Final String secondBCBSMLetter =  'GA_2_BCBSM_Letter_VF';
    public Static Final String thirdBCBSMLetter =  'GA_3_BCBSM_Letter_VF';
    public Static Final String firstBCNLetter =  'GA_1_BCN_Letter_VF';
    public Static Final String secondBCNLetter =  'GA_2_BCN_Letter_VF';
    public Static Final String objName =  'GA_WF_Step__c';
    /**
@Description: sendASEPNotificationToUsers() method 
@Name : sendASEPNotificationToUsers
@Param :list<GA_WF_Step__c> wkflStpList,map<id,GA_WF_Step__c> wkflStpNewMap
@Return : None
@throws Exception : AuraHandledException;
*/       
    public static void sendASEPNotificationToUsers(list<GA_WF_Step__c> wkflStpList,map<id,GA_WF_Step__c> wkflStpNewMap){
        try{
            // Fetch the step information
            List<String> maEmails; 
            
            
            for(GA_WF_Step__c wfstp : [select id,Name,GA_Account__c,GA_Account_Decision_Maker_Name__c,GA_ASEP_WF_Created_Date__c,GA_WF_Workflow_ID__r.GA_ASEP__c,GA_WF_Workflow_ID__r.GA_ASEP__r.GA_Email__c,
                                           GA_WF_Workflow_ID__r.GA_ASEP__r.GA_Decision_Maker__r.GA_Email__c,
                                           GA_WF_Workflow_ID__r.GA_Workflow_Template_Name__c
                                           from GA_WF_Step__c where 
                                           id in :wkflStpNewMap.keyset() 
                                           order by createddate asc limit 1000]){
                if((wfstp.GA_WF_Workflow_ID__r.GA_Workflow_Template_Name__c == bcbsmAsepTmplt
                    || wfstp.GA_WF_Workflow_ID__r.GA_Workflow_Template_Name__c == bcnAsepTmplt) 
                  ){
                      
                      String managingAgentEmail = wfstp.GA_WF_Workflow_ID__r.GA_ASEP__r.GA_Email__c;
                      maEmails = New List<String>();
                      if(managingAgentEmail != null){
                          maEmails = managingAgentEmail.split(semiColon);
                          //maEmails.add(wfstp.GA_WF_Workflow_ID__r.GA_ASEP__r.GA_Decision_Maker__r.GA_Email__c);
                          if(wfstp.Name  == smallGrpUnderWritingStep && wfstp.GA_WF_Workflow_ID__r.GA_Workflow_Template_Name__c == bcbsmAsepTmplt){
                             // GA_Util22_SendEmail.sendMailtoUsrs(null, wfstp.Id, firstBCBSMLetter,maEmails);   
                              GA_Util22_SendEmail.sendASEPMails(null,wfstp,objName,firstBCBSMLetter,maEmails,true); 
                          }
                          
                          if(wfstp.Name  == smallGrpUnderWritingStep && wfstp.GA_WF_Workflow_ID__r.GA_Workflow_Template_Name__c == bcnAsepTmplt){
                             // GA_Util22_SendEmail.sendMailtoUsrs(null, wfstp.Id, firstBCNLetter,maEmails);   
                             GA_Util22_SendEmail.sendASEPMails(null,wfstp,objName,firstBCNLetter,maEmails,true);  
                          }
                          if(wfstp.Name  == nbforAssgmntStep && wfstp.GA_WF_Workflow_ID__r.GA_Workflow_Template_Name__c == bcbsmAsepTmplt){
                             // GA_Util22_SendEmail.sendMailtoUsrs(null, wfstp.Id, secondBCBSMLetter,maEmails);   
                               GA_Util22_SendEmail.sendASEPMails(null,wfstp,objName,secondBCBSMLetter,maEmails,true); 
                          }
                          
                          if(wfstp.Name  == secondBCNLetterStep && wfstp.GA_WF_Workflow_ID__r.GA_Workflow_Template_Name__c == bcnAsepTmplt){
                             // GA_Util22_SendEmail.sendMailtoUsrs(null, wfstp.Id, secondBCNLetter,maEmails); 
                               GA_Util22_SendEmail.sendASEPMails(null,wfstp,objName,secondBCNLetter,maEmails,true);   
                          }
                          
                          if(wfstp.Name  == cmpltStep && wfstp.GA_WF_Workflow_ID__r.GA_Workflow_Template_Name__c == bcbsmAsepTmplt){
                             // GA_Util22_SendEmail.sendMailtoUsrs(null, wfstp.Id, thirdBCBSMLetter,maEmails);  
                              GA_Util22_SendEmail.sendASEPMails(null,wfstp,objName,thirdBCBSMLetter,maEmails,true);  
                          }
                          
                          
                      }
                      
                  }
                
                
                
            } 
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, methodNme); 
        }
    }
    
}