global with sharing class GA_ScheduleAndEmailReports implements schedulable {
global void execute(SchedulableContext SC){
// Get the report ID
scheduleJob();
}

@future(callout=true) 
    private static void scheduleJob(){
        List <Report> reportList = [SELECT Id,DeveloperName FROM Report where 
                                    DeveloperName IN ('ST_Open_Groups_Processor_to_Review' ,
                                                      'ST_Open_Groups_QA_to_Review',
                                                      'ST_Open_Groups_GA_Unit_Leader',
                                                      'ST_Open_Groups_Project_Support',
                                                      'ST_Open_Groups_Dept_Age_XIb')];
        String content = '';
        
        List<Messaging.SingleEmailMessage> lstEmail = new List<Messaging.SingleEmailMessage>();
       
        List< Messaging.EmailFileAttachment> lstAttachment = new List< Messaging.EmailFileAttachment>();
        String[] reportId = new String[reportList.size()];
        String[] reportname = new String[reportList.size()];
        
       
        
        for(Integer i=0;i < reportList.size();i++)
        {
            //Getting record on the basis of Report Id and puttinf it into Excel as attachment.
            reportId[i] = (String)reportList.get(i).get('Id');
            reportname[i] = (String)reportList.get(i).get('DeveloperName');
            
            // Run the report
            Reports.ReportResults res = Reports.ReportManager.runReport(reportId[i], true);
            
            
            
            ApexPages.PageReference report = new ApexPages.PageReference( '/' + reportId[i] + '?excel=1'); // or csv=1
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName(reportname[i] + '.xls');
            Blob  reportcontent =!Test.isRunningTest() ? report.getContent() : Blob.valueOf('Test');
            attachment.setBody(reportcontent);
            attachment.setContentType('application/vnd.ms-excel'); //  or text/csv
            lstAttachment.add(attachment);
            
            content = content +   '\n' + reportcontent.toString() ;
            
           }  
        
       
        
         String reporttTmplt = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'GA_Report_History_Template'].Id;
       
         Set<User> targetUserLst = getEmailAddresses();
        for(User usr:targetUserLst)
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSaveAsActivity(false);
            message.setTargetObjectId(usr.id);
            message.setTemplateId(reporttTmplt);
            message.setFileAttachments(lstAttachment);
            lstEmail.add(message);  
        }
        
        //lstEmail.add(message);
        
        Messaging.sendEmail(lstEmail ); 
        
    }
    
    private static Set<User> getEmailAddresses() {
        
        List<String> idList = new List<String>();        
        Set<User> mailToAddresses = new Set<User>();        
        Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name = 'Group Admin'];        
        for (GroupMember gm : g.groupMembers) {            
            idList.add(gm.userOrGroupId);            
        }
        User[] usr = [SELECT email FROM user WHERE id IN :idList];
        for(User u : usr) {
            mailToAddresses.add(u);
        }
        return mailToAddresses;
    }
    
}