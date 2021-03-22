/*****************************************************************************************
Class Name   : GA_Util22_SendEmail
Created By   : IDC Offshore
Description  : 1. This is the util data access class to send email
Change History : 
******************************************************************************************/
public without sharing class GA_Util22_SendEmail {
    public static final string ClsName = 'GA_Util22_SendEmail';
    public static final string methodNme = 'sendMailtoUsrs';
    public static final string errorMsg = 'Email notification failed, Please contact System administrator';
    public static final String sysAdmin = 'System Administrator';
    public static final String dumyEmlID = 'dummyemail@xyz.com';
    public static final String lessSymb = '<';
    public static final String greatrSymb = '>';
    public static final String nme ='Name';
    
    
    /**
@Description: sendMailtoUsrs() method 
@Name : sendMailtoUsrs
@Param :set<id> userIds,string recordId,String emailTmpltDevName,String[] emailString
@Return : None
@throws Exception : AuraHandledException;
*/   
    public static void sendMailtoUsrs(set<id> userIds,string recordId,String emailTmpltDevName,String[] emailString)
    {
        try{
            
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate emailTmplt= [SELECT Id,HtmlValue,Subject,Markup FROM EmailTemplate WHERE DeveloperName = :emailTmpltDevName Limit 1];
            string emailTmpltId=emailTmplt.Id;
            Messaging.SingleEmailMessage mail;
            emailString.add(DumyEmlID);
            // if userid are available      
            if(userIds !=null && userIds.size() > 0){
                for(id user:userIds)
                {
                    mail = new Messaging.SingleEmailMessage();                    
                    mail.setSaveAsActivity(false);
                    mail.setTemplateId(emailTmpltId);
                    mail.setTargetObjectId(user);
                    mail.setWhatId(recordId);
                    //mail.setToAddresses(new String[] {'prasantsatpathy0174@gmail.com'}); 
                    emails.add(mail);
                }
            }
            
            // if emailId's are available  
            if(emailString.size() > 0) {
                
                Id userid = [Select Id from user where  GA_RoleName__c =: sysAdmin and EmployeeNumber = null  Limit 1].Id;
                mail = new Messaging.SingleEmailMessage();
                
                mail.setSaveAsActivity(false);
                mail.setTemplateId(emailTmpltId);
                mail.setTargetObjectId(userid);
                mail.setWhatId(recordId);
                mail.setToAddresses(emailString);
                emails.add(mail);
                
            }
            Messaging.sendEmail(emails);  
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme); 
        }
    }
    public static void sendMailtoUsrsUpdts(set<id> userIds,sObject obj,String emailTmpltDevName,
                                           String[] emailString,boolean cretEmailMsg)
    {
        try{
            
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate emailTmplt= [SELECT Id,HtmlValue,Subject,Markup FROM EmailTemplate WHERE DeveloperName = :emailTmpltDevName Limit 1];
            
            string emailTmpltId=emailTmplt.Id;
            string recordId=(string)obj.get('Id');
            String GSName = '{!GA_Group_Segment__c.Name}';
            String WFCncltnUrl ='{!$Label.GA_WF_Cancellation_URL}';
            String GSAccName = '{!GA_Group_Segment__c.GA_Account__r.Name}';
            String GSDtPstd ='{!GA_Group_Segment__c.GA_Date_Posted__c}';
            String RecLnkUrl = '{RecordLinkURL}';
            String GSPstGrpNts ='{!GA_Group_Segment__c.GA_PostGrpNots__c}';
            String GSMTVGrp = '{!GA_Group_Segment__c.GA_MTV_Group__c}';
            String AccLkUpNm ='GA_Account__r';
            String DtPstd = 'GA_Date_Posted__c';
            String PstGrpNt = 'GA_PostGrpNots__c';
            String MTVGrp = 'GA_MTV_Group__c';
            Messaging.SingleEmailMessage  mail;
            // if userid are available      
            if(userIds !=null && userIds.size() > 0){
                for(id user:userIds)
                {
                    mail = new Messaging.SingleEmailMessage();
                    
                    mail.setSaveAsActivity(false);
                    mail.setTemplateId(emailTmpltId);
                    mail.setTargetObjectId(user);
                    mail.setWhatId(recordId);
                    //mail.setToAddresses(new String[] {'prasantsatpathy0174@gmail.com'}); 
                    emails.add(mail);
                }
            }
            
            // if emailId's are available  
            if(emailString.size() > 0) {
                list<string> emailLst=new list<string>();
                
                if(emailString[0].contains(lessSymb))
                    emailLst.add(emailString[0].substringBetween(lessSymb, greatrSymb));
                else
                    emailLst.add(emailString[0]);   
                Id userid = [Select Id from user where  GA_RoleName__c =: sysAdmin and EmployeeNumber = null  Limit 1].Id;
                mail = new Messaging.SingleEmailMessage();
                
                mail.setSaveAsActivity(false);
                //mail.setTemplateId('00Xc0000000Neju');
                // mail.setTargetObjectId(userid);
                mail.setWhatId(recordId);
                mail.setToAddresses(emailLst);
                mail.setSubject(emailTmplt.Subject);
                String htmlBody = emailTmplt.HtmlValue;
                
                htmlBody = htmlBody.replace(GSName,(string)obj.get(nme));
                htmlBody = htmlBody.replace(WFCncltnUrl,system.label.GA_WF_Cancellation_URL);
                htmlBody = htmlBody.replace(GSAccName,(string)obj.getSobject(AccLkUpNm).get(nme));
                htmlBody = htmlBody.replace(GSDtPstd, obj.get(DtPstd)==null?'':string.valueof((date)obj.get(DtPstd)));
                htmlBody = htmlBody.replace(RecLnkUrl, System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+(string)obj.get('Id')); 
                htmlBody = htmlBody.replace(GSPstGrpNts, (string)obj.get(PstGrpNt)); 
                htmlBody = htmlBody.replace(GSMTVGrp, obj.get(MTVGrp)==null?'':(string)obj.get(MTVGrp)); 
                
                mail.setHtmlBody(htmlBody);
                if(emailString.size()>=3)
                    mail.setCcAddresses(new string[]{emailString[2]});
                emails.add(mail);
                if(cretEmailMsg)
                    trackSentmail(emailString,obj,recordId,emailTmplt,userid,htmlBody);
                
                
            }
            Messaging.sendEmail(emails);  
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme); 
        }
    }
    
    public static void sendASEPMails(set<id> userIds,sObject obj, String ObjNme, String emailTmpltDevName,
                                     List<String> emailString,boolean cretEmailMsg)
    {
        try{
            
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate emailTmplt= [SELECT Id,HtmlValue,Subject,Markup FROM EmailTemplate WHERE DeveloperName = :emailTmpltDevName Limit 1];
            
            string emailTmpltId=emailTmplt.Id;
            string recordId=(string)obj.get('Id');
            
            string WFStepObj = 'GA_WF_Step__c';
            string ASEPObj = 'GA_Agent_Sold_Enrollment__c';
            
            if(ObjNme==WFStepObj){
                
                string AccNameTmplt = 'AccountName';
                string DcsnMkrTmplt = 'DecisionMaker';
                string ASEPWFCrtdDtTmplt = 'ASEPWFCreatedDate';  
                String AccNm ='GA_Account__c';
                string AccDcsnMkrNm = 'GA_Account_Decision_Maker_Name__c';
                
                Datetime dt = (Datetime)obj.get('GA_ASEP_WF_Created_Date__c'); 
                String asepWfcreatedDt = dt.format('MM-dd-yyyy');
                
                String [] emailsAsArray = new String[]{};
                    String toemailmsg = '';
                
                
                // if emailId's are available  
                if(emailString.size() > 0) {
                    
                    for(String eml : emailString){
                        if(eml <> null){
                            emailsAsArray.add(eml);
                            toemailmsg = toemailmsg + eml+',';
                        }
                    }
                    
                    toemailmsg = toemailmsg.removeEnd(',');
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    mail.setSaveAsActivity(false);
                    //mail.setTemplateId('00Xc0000000Neju');
                    // mail.setTargetObjectId(userid);
                    mail.setWhatId(recordId);
                    mail.setToAddresses(emailsAsArray);
                    mail.setSubject(emailTmplt.Subject);
                    String htmlBody = emailTmplt.HtmlValue;
                    
                    htmlBody = htmlBody.replace(AccNameTmplt,(string)obj.get(AccNm));
                    htmlBody = htmlBody.replace(DcsnMkrTmplt,( obj.get(AccDcsnMkrNm) <> null ?(String)obj.get(AccDcsnMkrNm) : ''));
                    htmlBody = htmlBody.replace(ASEPWFCrtdDtTmplt,asepWfcreatedDt);
                    
                    mail.setHtmlBody(htmlBody);
                    
                    //mail.setCcAddresses(new string[]{emailString[0]});
                    emails.add(mail);
                    string asepRecordId = (string)obj.getSobject('GA_WF_Workflow_ID__r').get('GA_ASEP__c');
                    if(cretEmailMsg)
                        trackSentAsepMail(emailsAsArray,obj,asepRecordId,emailTmplt,toemailmsg,htmlBody);
                    
                }
                Messaging.sendEmail(emails);
            }
            
            if(ObjNme==ASEPObj){
                String accNme = 'GA_Account_Name_Frml__c'  ;
                String dcsnMkrNm =  'GA_Account_Decision_Maker_Name_Frml__c' ;
                String asepStatus ='GA_ASEP_Status__c';
                String rejctnRsn = 'GA_Rejection_Reason__c';
                String accNmeTmplt = 'AccountName' ;
                String dcsnMkrNmTmplt =  'DecisionMaker' ;
                String asepNmTmplt ='ASEPName';
                String asepStatusTmplt ='ASEPStatus';
                String rejctnRsnTmplt = 'ASEPRejectionReason';
                
                String [] emailsAsArray = new String[]{};
                    String toemailmsg = '';
                
                
                // if emailId's are available  
                if(emailString.size() > 0) {
                    
                    for(String eml : emailString){
                        if(eml <> null){
                            emailsAsArray.add(eml);
                            toemailmsg = toemailmsg + eml+',';
                        }
                        
                    }
                    
                    toemailmsg = toemailmsg.removeEnd(',');
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    mail.setSaveAsActivity(false);
                    //mail.setTemplateId('00Xc0000000Neju');
                    // mail.setTargetObjectId(userid);
                    mail.setWhatId(recordId);
                    mail.setToAddresses(emailsAsArray);
                    mail.setSubject(emailTmplt.Subject);
                    String htmlBody = emailTmplt.HtmlValue;
                    
                    htmlBody = htmlBody.replace(accNmeTmplt,( obj.get(accNme) <> null ?(String)obj.get(accNme) : ''));
                    htmlBody = htmlBody.replace(dcsnMkrNmTmplt,( obj.get(dcsnMkrNm) <> null ?(String)obj.get(dcsnMkrNm) : ''));
                    htmlBody = htmlBody.replace(asepNmTmplt,( obj.get(nme) <> null ?(String)obj.get(nme) : '') );
                    htmlBody = htmlBody.replace(asepStatusTmplt,( obj.get(asepStatus) <> null ?(String)obj.get(asepStatus) : ''));
                    htmlBody = htmlBody.replace(rejctnRsnTmplt, ( obj.get(rejctnRsn) <> null ?(String)obj.get(rejctnRsn) : '') );
                    mail.setHtmlBody(htmlBody);
                    
                   // mail.setCcAddresses(new string[]{emailString[0]});
                    emails.add(mail);
                    string asepRecordId = (string)obj.get('Id');
                    if(cretEmailMsg)
                        trackSentAsepMail(emailsAsArray,obj,asepRecordId,emailTmplt,toemailmsg,htmlBody);
                    
                }
                Messaging.sendEmail(emails);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme); 
        }
    }
    
    private static void trackSentAsepMail(String[] emailsAsArray,sobject obj,
                                          string recordId,emailTemplate emailTmplt,string toemails,string htmlBody)
    {
        
        // if EnhancedEmail Perm is enabled, create an EmailMessage object
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.status = '3'; // email was sent
        emailMessage.relatedToId = recordId; // related to record e.g. an opportunity
        emailMessage.fromAddress = userinfo.getUserEmail(); // from address       
        emailMessage.fromName =userinfo.getFirstName(); // from name
        emailMessage.subject = emailTmplt.subject; // email subject
        emailMessage.htmlBody = htmlBody; // email body
        emailMessage.toAddress = toemails;
        emailMessage.CcAddress=emailsAsArray[0];
        emailMessage.GA_Agent_Sold_Enrollment__c = recordId; 
        database.insert(emailMessage); 
    }
    
    private static void trackSentmail(list<string> emailString,sobject obj,
                                      string recordId,emailTemplate emailTmplt,id userid,string htmlBody)
    {
        // if EnhancedEmail Perm is enabled, create an EmailMessage object
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.status = '3'; // email was sent
        emailMessage.relatedToId = recordId; // related to record e.g. an opportunity
        emailMessage.fromAddress = emailString[1].substringBetween(lessSymb, greatrSymb); // from address       
        emailMessage.fromName = emailString[1].substringBefore(lessSymb); // from name
        
        emailMessage.subject = emailTmplt.subject; // email subject
        emailMessage.htmlBody = htmlBody; // email body
        
        // Contact, Lead or User Ids of recipients
        String[] toIds = new String[]{userid}; 
            //emailMessage.toIds = toIds;
            // additional recipients who don’t have a corresponding contact, lead or user id in the Salesforce org (optional)
            emailMessage.toAddress = emailString[0].substringBetween(lessSymb, greatrSymb);
        emailMessage.CcAddress=emailString[2];
        emailMessage.GA_Group_Segment__c = recordId; 
        database.insert(emailMessage); // insert
        
        // Add Email Message Relation for id of the sender
        /* EmailMessageRelation emr = new EmailMessageRelation();
emr.emailMessageId = emailMessage.id;
emr.relationId = userid; // user id of the sender
emr.relationType = 'FromAddress';
insert emr;*/
    }
}