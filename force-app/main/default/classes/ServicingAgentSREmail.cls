public without sharing class ServicingAgentSREmail {
    public static boolean sendemail=false;
    public static void sendEmailtoASRSalesreps(list<case> CaseList, map<id, case> caseOldMap){
        id currentUserId = userinfo.getUserId();
        User currentUser = [SELECT profile.name, Delegate_User__c FROM user WHERE Id =: currentUserId];
        list<id> supportRequestIds=new list<id>();
        Map<String ,String> profileMap=new Map<String ,String>();
        String[] profileslist=System.label.Support_Request_Servicing_Agent_Profile_Name.split(';');
        for(String str:profileslist){   
            String[]  Profilrstr=str.split(':');       
            profileMap.put(Profilrstr[1],Profilrstr[0]);
        }
        for (Case  caserec: CaseList) {  
            
            if ((caseoldMap==null && profileMap.get(currentUser.profile.name)!=null && (caserec.Status=='Submitted' || caserec.Status=='Closed' || caserec.Status=='In Progress' ) )||
                (caseoldMap!=null && String.isNotBlank(caseoldMap.get(caserec.id).Status) 
                 && caserec.Status!=caseoldMap.get(caserec.id).Status )
               ){
                   system.debug('****supportRequestIds****'+supportRequestIds);
                   supportRequestIds.add(caserec.id);         
               }
            
        }
        system.debug('****supportRequestIds****'+supportRequestIds);
        if(supportRequestIds.size()>0){
            if(sendemail==false){
                //sendEmailtoASRSalesrepFuture(supportRequestIds);
                sendemail=true;
            }
        }
    }
    
    
    @future(callout=true)
    public static void sendEmailtoASRSalesrepFuture(List<id> caserecordIds){
        try{
            List<String> submittoAddresses = new List<String>();
            List<String> submittoAddressesSR = new List<String>();
            List<String> closetoAddresses = new List<String>();
            List<String> closetoAddressesSR = new List<String>();
            List<String> inprogresstoAddresses = new List<String>();
             List<String> inprogresstoAddressesSR = new List<String>();
            List< Messaging.SingleEmailMessage> msg=new list<Messaging.SingleEmailMessage>();
            string owdAddress =  System.Label.OrgwideEmailAddress;                       
            OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress WHERE Address =:owdAddress];
            List<Contact> conList = [Select id, LastName, AccountId From Contact Limit 1];
            List<Case> caselist= [SELECT id,AccountId,contactID,GA_AgentName__c,createdbyid,status,FSA_Delegated_Agent__c,Account.Servicing_Agent__c,GA_AgentName__r.accountid,Account.Servicing_Agent__r.email, GA_AgentName__r.Recordtypeid,createdby.id,createdby.profile.name,createdby.Email,createdby.contact.vlocity_ins__Type__c FROM Case WHERE Id IN :caserecordIds ];
            for(Case caserec:caselist){
               if(caserec.Account.Servicing_Agent__c!=null && String.isNotBLank((String)caserec.Account.Servicing_Agent__r.email)){
                    if(caserec.Status=='Submitted'){
                       
                        
                        EmailTemplate emailTemplate = [Select Id, Subject, Description, HtmlValue,DeveloperName,Body
                                                       FROM EmailTemplate where DeveloperName = 'Email_to_Agent_When_New_Support_Request_Created_ASR'];
                        if(caserec.Account.Servicing_Agent__r.email != caserec.GA_AgentName__r.Email ||
                           caserec.Account.Servicing_Agent__r.email != caserec.FSA_Delegated_Agent__r.Email){
                               submittoAddresses.add(caserec.Account.Servicing_Agent__r.email);
                               Messaging.SingleEmailMessage submitmail = new Messaging.SingleEmailMessage();
                                submitmail.setToAddresses(submittoAddresses);
                                submitmail.setTargetObjectId(conList[0].Id);
                                submitmail.setTemplateId(emailTemplate.Id);
                                submitmail.setWhatId(caserec.Id);
                                submitmail.setSaveAsActivity(false);
                                submitmail.setOrgWideEmailAddressId(owa.id);                        
                                submitmail.setTreatTargetObjectAsRecipient(false);
                                msg.add(submitmail);  
                           }
                        
                       
                          
                    }else  if(caserec.Status=='Closed'){
                        EmailTemplate emailTemplate = [Select Id, Subject, Description, HtmlValue,DeveloperName,Body
                                                       FROM EmailTemplate where DeveloperName = 'Email_to_Agent_When_SR_status_is_closed_ASR'];
                        
                       
                        if(caserec.Account.Servicing_Agent__r.email != caserec.GA_AgentName__r.Email ||
                           caserec.Account.Servicing_Agent__r.email != caserec.FSA_Delegated_Agent__r.Email){
                               closetoAddresses.add(caserec.Account.Servicing_Agent__r.email);
                                Messaging.SingleEmailMessage closedmail = new Messaging.SingleEmailMessage();
                                closedmail.setToAddresses(closetoAddresses);
                                closedmail.setTargetObjectId(conList[0].Id);
                                closedmail.setTemplateId(emailTemplate.Id);
                                closedmail.setWhatId(caserec.Id);
                                closedmail.setSaveAsActivity(false);
                                closedmail.setOrgWideEmailAddressId(owa.id);
                                closedmail.setTreatTargetObjectAsRecipient(false);      
                                msg.add(closedmail);    
                           }
                        
                          
                    }else if(caserec.Status=='In Progress'){
                            
                           
                            EmailTemplate emailTemplate = [Select Id, Subject, Description, HtmlValue,DeveloperName,Body
                                                           FROM EmailTemplate where DeveloperName = 'Email_to_Agent_when_Support_Request_Status_is_changed_ASR'];                                                          
                             if(caserec.Account.Servicing_Agent__r.email != caserec.GA_AgentName__r.Email ||
                               caserec.Account.Servicing_Agent__r.email != caserec.FSA_Delegated_Agent__r.Email){
                                   inprogresstoAddresses.add(caserec.Account.Servicing_Agent__r.email);
                                   Messaging.SingleEmailMessage inprogressemail = new Messaging.SingleEmailMessage();
                                    inprogressemail.setToAddresses(inprogresstoAddresses);
                                    inprogressemail.setTargetObjectId(conList[0].Id);
                                    inprogressemail.setTemplateId(emailTemplate.Id);
                                    inprogressemail.setWhatId(caserec.Id);
                                    inprogressemail.setSaveAsActivity(false);
                                    inprogressemail.setOrgWideEmailAddressId(owa.id);
                                    inprogressemail.setTreatTargetObjectAsRecipient(false);
                                    msg.add(inprogressemail);    
                               }
                                             
                        }       
                }
            }
            if(msg.size()>0){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(msg);
                System.debug('++++++++++++results:'+results);
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: '+ results[0].errors[0].message);
                }
            }
            
        } catch(Exception e) {
            system.debug(logginglevel.error,+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, 'ServicingAgentSREmail', 'sendEmailtoASRSalesrepFuture');
        }
    }
    
    
}