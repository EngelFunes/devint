/*****************************************************************************************************************************************************
@Author : Sreenu Ravilla
@Name: TaskSendEmailApproversClass
@CreatedDate:  25-Feb-2021 
@Description: TaskSendEmailApproversClass is used to send  Email notifications for task owners.

@US Number: US-3921

*/
public class ASC_TaskSendEmailApproversClass {
    private static final String EAMILNAME = 'noreply@bcbsm.com';
    private static final string EMAILTEMP='Product_and_Pricing_Approval_Task_Notification';
    //Query the orgwide addtrees based in email and this method can be reused in different classes
    private static EmailTemplate getEmailTemplate(){
        return [select Id, Body,Subject, HtmlValue from EmailTemplate where DeveloperName =:EMAILTEMP];
    }
    //Query the orgwide addtrees based in email and this method can be reused in different classes
    private static String getOrgWideAddress(){
        return [SELECT DisplayName,Id FROM OrgWideEmailAddress WHERE DisplayName =:EAMILNAME LIMIT 1].Id;
    }
    
    public static void emailNotificationOnTask(list<task> taskLisk){
        
        List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>(); 
        
        String OrgWideEmailAddress;
        try{
            OrgWideEmailAddress = getOrgWideAddress();
        }catch (QueryException e){
            System.debug('Exception '+e.getMessage());
        }        
        /**Creating email template*/
        EmailTemplate emailTemplate = getEmailTemplate();
        String subject = emailTemplate.Subject;
       // String htmlBody = emailTemplate.Body; 
        String plainBody = emailTemplate.Body;
         Contact contRec= [select id, Email from Contact where email !=null limit 1];
        for(task t:taskLisk){
            String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() +'/lightning/o/Task/home?0.source=alohaHeader';                             
           //This is dummy email that willl render the letter head
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setWhatId(t.whatid);
            mail.setOrgWideEmailAddressId(OrgWideEmailAddress);                                    
            mail.setTemplateId(emailTemplate.id);
            Savepoint sp = Database.setSavepoint();
            mail.setTargetObjectId(contRec.id);  
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {   mail }); 
            Database.rollback(sp); 
             
            
            String htmlBody = mail.getHTMLBody(); 
            htmlBody = htmlBody.replace('Greetings','Greetings '+t.owner.Name);
            htmlBody = htmlBody.replace('Click Here',fullFileURL);
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();                
            emailToSend.setToAddresses(new String[]{t.Owner.email});                       
            emailToSend.setPlainTextBody(mail.getPlainTextBody());
            emailToSend.setHTMLBody(htmlBody);
            emailToSend.setSubject(mail.getSubject());
            emailToSend.setOrgWideEmailAddressId(OrgWideEmailAddress);
            listmail.add(emailToSend);            
            
            
        }
        if(!listmail.isEmpty() && listmail != null){
            try{     
                Messaging.sendEmail(listmail);                   
            } catch (Exception e){
                System.debug('Exception@@@@ '+e.getMessage());
            }
        }     
        
        
    }
}