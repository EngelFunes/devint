/**
@Author : IDC Offshore
@Name: GA_SendEmailHandler
@CreatedDate: 15-Nov-2018
@Description: GA_SendEmailHandler class to send/receive email for CID Additional Info between Requestor,Approver/Data Admin
@version : 1.0  
*/
global class GA_SendEmailHandler implements Messaging.InboundEmailHandler {
    public static final string AddInfoSub='Additional Information Requried:-';
    public static final string AddInfoSendAs='CID Adjustment Info';
    public static final string blnk = '';
    public static final String  newLine = '\n';
    public static final String  sfmailStrt = 'On';
    public static final String   viewAccess = 'V';
    public static final string allUsrs = 'AllUsers';
    public static final string fwdSlash = '/' ;
    public static final string hyphen = '-' ;
    public  list<GA_CID_Request_Additional_Info__c> restApprvlLst ;
    
     /**
        @Description: handleInboundEmail() method 
        @Name : Email service handler
        @Param : Messaging.InboundEmail email, Messaging.InboundEnvelope envelope
        @Return :  Messaging.InboundEmailResult
        @throws Exception : N/A;
        */     
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        Id sentToUsr;
        String sendtoEmail;
        Id cidAdjId;
        Id mstrCIDAdId;
         restApprvlLst = New list<GA_CID_Request_Additional_Info__c>();
        // Try and extract the object name from the subject
        String subject = email.subject.trim();
        
        subject = subject.substringAfter(hyphen).trim();
        
         restApprvlLst=[select id,GA_Comments__c,GA_CID_Adjustment__c,GA_Sent_From__r.Email 
                                                               ,GA_Sent_To__c,GA_Sent_To__r.email from GA_CID_Request_Additional_Info__c 
                                                               where GA_Master_CID_Request_Additional_Info__r.Name=:subject 
                                                               order by createddate desc limit 1 ];
      
        if(restApprvlLst.size()>0)
        {
            if(restApprvlLst[0].GA_Sent_From__r.Email==email.fromAddress)
            {
                sentToUsr=restApprvlLst[0].GA_Sent_To__c;
                sendtoEmail=restApprvlLst[0].GA_Sent_To__r.Email;
            }
            else
            {
                sentToUsr=restApprvlLst[0].GA_Sent_From__c;
                sendtoEmail=restApprvlLst[0].GA_Sent_From__r.Email;   
            }
            
            cidAdjId=restApprvlLst[0].GA_CID_Adjustment__c;
            mstrCIDAdId=restApprvlLst[0].Id;
        }
        else
        {
            list<GA_CID_Request_Additional_Info__c> toUsrLst=[select id,GA_Sent_From__c,GA_Sent_From__r.Email,GA_CID_Adjustment__c 
                                                              from GA_CID_Request_Additional_Info__c 
                                                              where Name=:subject limit 1];
            
            sentToUsr=toUsrLst[0].GA_Sent_From__c;
            sendtoEmail=toUsrLst[0].GA_Sent_From__r.Email;
            cidAdjId=toUsrLst[0].GA_CID_Adjustment__c;
            mstrCIDAdId=toUsrLst[0].id;
        }
        
        String comments =  email.plainTextBody;
        
        GA_CID_Request_Additional_Info__c restApprvl=new GA_CID_Request_Additional_Info__c();
        restApprvl.GA_CID_Adjustment__c=cidAdjId;
        restApprvl.GA_Master_CID_Request_Additional_Info__c=mstrCIDAdId;
        restApprvl.GA_Comments__c= (!String.isBlank(comments) ? comments.substringBefore(newLine+sfmailStrt) : blnk);
        restApprvl.GA_Email__c  =  email.plainTextBody ;
        restApprvl.GA_Sent_From__c=[select id from user where Email=:email.fromAddress and isActive=true limit 1].Id;
        restApprvl.GA_Sent_To__c=sentToUsr;
        database.insert(restApprvl);
        
        list<Messaging.EmailFileAttachment> filattmntLst=new list<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment filattmnt=new Messaging.EmailFileAttachment();
        List<ContentVersion>cvList = new List<ContentVersion>();
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        
        if(email.binaryAttachments !=null)
        {
            for (Messaging.InboundEmail.BinaryAttachment binAttach : email.binaryAttachments) {
                ContentVersion testContentInsert = new ContentVersion();
                testContentInsert.Title = binAttach.fileName;
                testContentInsert.VersionData = binAttach.body;
                testContentInsert.PathOnClient = fwdSlash + binAttach.fileName ;
                cvList.add(testContentInsert);              
                filattmnt=new Messaging.EmailFileAttachment();
                filattmnt.setBody(binAttach.body);
                filattmnt.setFileName(binAttach.fileName);
                filattmnt.setInline(false);
                filattmntLst.add(filattmnt);
            } 
            
            
            insert cvList;
            cvList = [select id, ContentDocumentId from ContentVersion WHERE Id in :cvList];
            for (ContentVersion cv : cvList) {
                ContentDocumentLink cl = new ContentDocumentLink();
                cl.ContentDocumentId = cv.ContentDocumentId;
                cl.LinkedEntityId = restApprvl.Id; //Shared with record ID
                cl.ShareType = viewAccess;
                cl.Visibility = allUsrs;
                cdlList.add(cl);
                
                
                
            }
            insert cdlList;
        }
        if(email.textAttachments !=null)
        {
            for (Messaging.InboundEmail.textAttachment txtAttach : email.textAttachments) {
                ContentVersion testContentInsert = new ContentVersion();
                testContentInsert.Title = txtAttach.fileName;
                testContentInsert.VersionData = blob.valueOf(txtAttach.body);
                testContentInsert.PathOnClient = fwdSlash + txtAttach.fileName ;
                cvList.add(testContentInsert);
                
                filattmnt=new Messaging.EmailFileAttachment();
                filattmnt.setBody(blob.valueOf(txtAttach.body));
                filattmnt.setFileName(txtAttach.fileName);
                filattmnt.setInline(false);
                filattmntLst.add(filattmnt);
            } 
            
            
            database.upsert(cvList,false) ; //insert cvList;Modified for test class
            cvList = [select id, ContentDocumentId from ContentVersion WHERE Id in :cvList];
            for (ContentVersion cv : cvList) {
                ContentDocumentLink cl = new ContentDocumentLink();
                cl.ContentDocumentId = cv.ContentDocumentId;
                cl.LinkedEntityId = restApprvl.Id; //Shared with record ID
                cl.ShareType = viewAccess;
                cl.Visibility = allUsrs;
                cdlList.add(cl);
                
                
                
            }
                      database.upsert(cdlList,false) ;  //insert cdlList;Modified for test class
        }
        
        
        list<Messaging.SingleEmailMessage> EmailList=new list<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        
        msg.setReplyTo(system.label.GA_CID_EmailServiceId);
        msg.setSenderDisplayName(AddInfoSendAs);
        
        msg.setToAddresses(new String[] {sendtoEmail});
        
        msg.setSubject(AddInfoSub+subject);
        msg.setPlainTextBody(restApprvl.GA_Comments__c);
        
        
        msg.setFileAttachments(filattmntLst);
        EmailList.add(msg);
        Messaging.sendEmail(EmailList);
        return result;
    }
}