global class auditTrailLog implements Schedulable {
    
    public string auditLogs;
    public string emailRecipient;
    public string emailMessage;
    
    global void execute(SchedulableContext ctx) {
        
        notifyUs();   
    } 
    
    public void notifyUs() {

    integer rowCount = 0;
    string htmlBody = '<table border="1" style="border-collapse: collapse"><caption><strong>THE LIST</strong></caption><tr><th>Row Number</th><th>The Offender</th><th>The Date and Time</th><th>The Offense</th><th>Section</th><th>Delegate User</th></tr>';

        
        for(Sandbox_Refresh_Settings__mdt srs : [select query__c, Send_to_email__c from Sandbox_Refresh_Settings__mdt where Use_this_record__c = true AND Audit_Log_Email__c = TRUE LIMIT 1]){
            
            auditLogs = srs.query__c;
            emailRecipient =srs.Send_To_email__c;
        }

        List<SetupAuditTrail> theseLogs = Database.query(auditLogs);

        for( SetupAuditTrail log : theseLogs ){
        

            integer thisRowCount = rowCount;
            string thisOffender = log.Createdby.name;
            string thisCreatedDate = string.valueof(log.CreatedDate);
            string thisAction = log.Action;
            string thisDisplay = log.Display;
            string thisDelegateUser = log.DelegateUser; //if(log.DelegateUser == null){myPhone = '[Not Provided]';}
            rowCount++;     

            htmlBody += '<tr><td>' + thisRowCount + '</td><td>' + thisOffender + '</td><td>' + thisCreatedDate + '</td><td>' + thisDisplay + '</td><td>' + thisAction + '</td><td>' + thisDelegateUser + '</td></tr>';

        }

        htmlBody += '</table>';
        emailMessage = htmlBody;


        //build email and send
       if(emailMessage.contains('0')) {
                                    
        system.debug('email message' + emailMessage);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<string> toAddress = new List <String>();
            
            Organization thisOrg = [SELECT InstanceName,IsSandbox,Name,OrganizationType FROM Organization];
            
            list <user> thisUserName = [select username from user where username like '%.com.grp%' and usertype = 'standard' limit 1];
            
            string sandboxName = string.valueof(thisUserName).substringAfterLast('.').substringBefore(',');
            
            for(User u : [select id, email from user where id in (SELECT MemberId FROM CollaborationGroupMember where collaborationgroup.name = 'audit log recipients')])
            {           
                toAddress.add(u.email);
            }  
            if(!toAddress.isEmpty()){
                
                mail.setToAddresses(toAddress); 

            } else {
                        
                String[] toAddresses = new String[] {emailRecipient};
                    
                mail.setToAddresses( toAddresses);
            }
                
            mail.setSubject('Yesterday\'s Audit Trail logs from: ' + sandboxName + ' - ' + thisOrg.InstanceName);

            mail.sethtmlbody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}