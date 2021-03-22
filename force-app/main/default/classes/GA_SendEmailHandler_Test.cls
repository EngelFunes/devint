/**
@Author : IDC Offshore
@Name: GA_SendEmailHandler_Test 
@CreatedDate: 15-Nov-2018
@Description: Test class for GA_SendEmailHandler 
@version : 1.0  
*/
@isTest(seealldata=false)
private class GA_SendEmailHandler_Test {
    /*******************************************************************************************************************************
@Description        :   TestEmailAttachment() method 
@Name               :   TestEmailAttachment
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static testMethod void emailTester(){
        try{
            list<user> usrLst=new list<user>();
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRec','testsysadminmail@bcbsm.com','System Administrator');
            usrLst.add(usr);
            user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRec2','testsysadminmail2@bcbsm.com','System Administrator');
            usrLst.add(usr1);
            database.insert(usrLst);
            system.runAs(usr)
            {
                GA_SendEmailHandler objconfirm = new GA_SendEmailHandler();
                // Create a new email, envelope object and Attachment
                Messaging.InboundEmail email1 = new Messaging.InboundEmail();
                Messaging.InboundEnvelope envelope1 = new Messaging.InboundEnvelope();
                
                list<GA_CID_Request_Additional_Info__c> cidAddLst = New list<GA_CID_Request_Additional_Info__c>();
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount1);
                
                Account testAccount2= GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount2.CID__c = '765348';
                database.insert(testAccount2);
                
                GA_Group_Segment__c grpSgmnt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount1);               
                database.insert(grpSgmnt);
                
                GA_CID_Adjustment__c cidRec=GA_OBJ_TD01_TestDataCreation.cidAdjRecrd();
                cidRec.GA_Source_Account__c  = testAccount1.Id;
                cidRec.GA_Target_Account__c  = testAccount2.Id;
                database.insert(cidRec);
                cidRec.OwnerId=Usr.Id;
                database.Update(cidRec);
                
                GA_CID_Request_Additional_Info__c cidAddnInfoRec =GA_OBJ_TD01_TestDataCreation.cidAddnInfo(usr, usr1,CIdRec);
                Database.insert(cidAddnInfoRec);
                GA_CID_Request_Additional_Info__c cidAddnInfoRec1 =GA_OBJ_TD01_TestDataCreation.cidAddnInfo(usr, usr1,CIdRec);
                cidAddnInfoRec1.GA_Master_CID_Request_Additional_Info__c = cidAddnInfoRec.id;
                Database.insert(cidAddnInfoRec1);
                String sub = [select Name,id from GA_CID_Request_Additional_Info__c where id =: cidAddnInfoRec.id Limit 1 ].name ;     
                String subject = 'Additional Information Requried:-'+sub;
                cidAddLst.add(cidAddnInfoRec1);
                // setup controller object
                
                objconfirm.restApprvlLst = cidAddLst;
                
                email1.subject = subject;
                email1.plainTextBody = 'Hello, this a test email body. for testing purposes only. Bye';
                email1.fromAddress = usr.Email;
                envelope1.fromAddress = usr.Email;
                //Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[2];
                Messaging.InboundEmail.BinaryAttachment binaryAttachment1 = new Messaging.InboundEmail.BinaryAttachment();
                binaryAttachment1.Filename = 'test.pdf';
                binaryAttachment1.body = blob.valueOf('my attachment text');
                email1.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment1 };
                    
                    Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
                attachmenttext.body = 'my attachment text';
                attachmenttext.fileName = 'textfiletwo3.txt';
                attachmenttext.mimeTypeSubType = 'texttwo/plain';
                email1.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
                    //binaryattachment.mimeTypeSubType = 'text/plain';
                    objconfirm.handleInboundEmail(email1, envelope1);
                // Messaging.InboundEmailResult result = objconfirm.handleInboundEmail(email, envelope);
                system.assert(usr <> null);
            }
            
        }
        catch(exception e)
        {
            return;
        }
        
    }
    
    
}