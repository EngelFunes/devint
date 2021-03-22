/**
@Author : IDC Offshore
@Name: ASC_AP_SendQuoteNotificationCls
@CreatedDate:  03-24-2020 
@Description: ASC_AP_SendQuoteNotificationCls class is able to send a notification to the Sales team once the quote is available for their review
@version : 1.0  
@US Number: US-2534
*/
public class ASC_AP_SendQuoteNotificationCls {
    public static string ERRMSG='The email notification failed,please contact to System Admin';
    public static final String emailTemplate ='ASC_Quote_Notification_VF';
    public static final string CLSNAME = 'ASC_AP_SendQuoteNotificationCls';
    public static final string METHODNME1 = 'sendQuoteNotification';
    public static final string METHODNME3 = 'sendQuoteMails';
    public static final string METHODNME4 = 'trackSentQuoteMail';
    
    @AuraEnabled
    public static boolean reviewBttn(){
        
       return GA_Trigger_Functionality_By_Pass__c.getInstance().ASC_Quote_Review__c;
        
    }
    
    @AuraEnabled
    public static List<String> sendQuoteNotification(string QuoteId,String emailTitle,String emailMsg,List<String> selectedchk)
    {
        try
        {
            Quote quoteRec  =[select id,Name,ASC_Email_Title__c,ASC_Email_Message__c,AccountId,
                              ASC_CID__c,ASC_Carrier__c
                              from Quote where id =:QuoteId Limit 1];
            
            String accountId=quoteRec.AccountId;
            Account acc =[Select Id, Name,Owner.Email,GA_Underwriting__r.Email,ASC_SPOC_Mail_Id__c,
                          ASC_Contract_Renewal_Month__c from Account where Id=:accountId];
            String accountName = acc.Name;
            String renewalMonth = acc.ASC_Contract_Renewal_Month__c;
            String subject =accountName+'-'+quoteRec.ASC_CID__c+'-'+emailTitle; 
            quoteRec.ASC_Email_Title__c = subject;
            quoteRec.ASC_Email_Message__c = emailMsg;
            List<String> strList = new List<String>();
            String[] usrMailIds= New String[]{};
                if(QuoteId !=null && accountId !=null){
                    for(String key:selectedchk){
                        if('Sales'.equals(key)
                           && Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', acc.Owner.Email) 
                          ){
                            usrMailIds.add(acc.Owner.Email);
                        }        
                        else if('Sales'.equals(key)){
                            strList = new List<String>{'Sales'};
                        }
                        if('UW'.equals(key)
                            && acc.GA_Underwriting__c !=null
                            && Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', acc.GA_Underwriting__r.Email)
                          ){ 
                            usrMailIds.add(acc.GA_Underwriting__r.Email);                            
                        }
                        else if('UW'.equals(key)){  
                            if(strList.Contains('Sales')){ 
                               strList = new List<String>{'Sales/UW'};                         
                            }
                            else{
                               strList = new List<String>{'UW'};                         
                            }
                        }
                        if('SPOC'.equals(key)  
                           && acc.ASC_SPOC_Mail_Id__c !=null
                           && Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', acc.ASC_SPOC_Mail_Id__c)
                         ){ 
                            usrMailIds.add(acc.ASC_SPOC_Mail_Id__c);
                        }
                        else if('SPOC'.equals(key)){
                            if(strList.Contains('Sales/UW')){                          
                               strList = new List<String>{'Sales/UW/SPOC'};
                            }
                            else if(strList.Contains('UW')){                          
                               strList = new List<String>{'UW/SPOC'};
                            }
                            else{
                               strList = new List<String>{'SPOC'};
                            }
                        }
                    }            
                    if(strList.isEmpty()){
                        sendQuoteMails(accountName, renewalMonth, quoteRec, 'Quote', emailTemplate, usrMailIds, true);
                    }
                    return strList;
                }
            else{
                return strList;
            }       
        }        
        catch(exception e){ GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1); throw new AuraHandledException(ERRMSG); } 
    }
                   
    public static void sendQuoteMails(String accountName,String renewalMonth,sObject obj, String ObjNme, String emailTmpltDevName,
                                      List<String> emailString,boolean cretEmailMsg)
    {
        try{
            
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate emailTmplt= [SELECT Id,HtmlValue,Subject,Markup FROM EmailTemplate 
                                       WHERE DeveloperName = :emailTmpltDevName Limit 1];
            string orgURL=system.label.GA_Org_Base_URL;
            string emailTmpltId=emailTmplt.Id;
            string recordId=(string)obj.get('Id');
            
            String recLink =orgURL+'/lightning/r/Quote/'+recordId+'/view';
            String quoteNme='Name';
            String CIDNm =  'ASC_CID__c' ;
            String carrier = 'ASC_Carrier__c';
            String emailMsg='ASC_Email_Message__c';
            String emailTitle='ASC_Email_Title__c';
            
            String quoteTmplt = 'NAME';
            String accNmeTmplt = 'ACCOUNT' ;
            String CIDNmTmplt =  'ASC_CID' ;
            String recLinkTmplt ='ASC_QUOTE_REC';
            String renewlMnthTmplt ='ASC_RNWL_MNTH';
            String carrierTmplt ='ASC_CARRIER';
            String emailMsgTmplt='ASC_MSG';
            String emailTitleTmplt='ASC_TITLE';
            
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
                mail.setWhatId(recordId);
                mail.setToAddresses(emailsAsArray);
                mail.setSubject((String)obj.get('ASC_Email_Title__c'));
                
                String htmlBody = emailTmplt.HtmlValue;
                htmlBody = htmlBody.replace(quoteTmplt,( obj.get(quoteNme) <> null ?(String)obj.get(quoteNme) : ''));
                htmlBody = htmlBody.replace(accNmeTmplt,( accountName <> null ? accountName : ''));
                htmlBody = htmlBody.replace(CIDNmTmplt,( obj.get(CIDNm) <> null ?(String)obj.get(CIDNm) : ''));
                htmlBody = htmlBody.replace(renewlMnthTmplt,( renewalMonth <> null ? renewalMonth : ''));
                htmlBody = htmlBody.replace(carrierTmplt,( obj.get(carrier) <> null ?(String)obj.get(carrier) : ''));
                htmlBody = htmlBody.replace(emailMsgTmplt,( obj.get(emailMsg) <> null ?(String)obj.get(emailMsg) : ''));
                htmlBody = htmlBody.replace(recLinkTmplt, ( recLink <> null ? recLink : ''));
                mail.setHtmlBody(htmlBody);
                
                emails.add(mail);
                string asepRecordId = (string)obj.get('Id');
                if(cretEmailMsg)
                    trackSentQuoteMail(emailsAsArray,obj,asepRecordId,emailTmplt,toemailmsg,htmlBody);
                
            }
            Messaging.sendEmail(emails);//Uncomment it before deploying to higher orgs
        }
        catch(exception e){ GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME3); }
    }

    private static void trackSentQuoteMail(String[] emailsAsArray,sobject obj,string recordId,emailTemplate emailTmplt,string toemails,string htmlBody)
    {
        try{   
            // if EnhancedEmail Perm is enabled, create an EmailMessage object
            EmailMessage emailMessage = new EmailMessage();
            emailMessage.status = '3'; // email was sent
            emailMessage.relatedToId = recordId; // related to record e.g. an opportunity
            emailMessage.fromAddress = userinfo.getUserEmail(); // from address       
            emailMessage.fromName =userinfo.getFirstName(); emailMessage.subject = (String)obj.get('ASC_Email_Title__c'); // email subject
            emailMessage.htmlBody = htmlBody;  emailMessage.toAddress = toemails;  emailMessage.ASC_Quote__c = recordId; 
            database.insert(emailMessage);
        }
        catch(exception e){  GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME4);  }
    }    
}