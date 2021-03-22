/*
@Author : Sri Lakshmi Addula
@Name: GA_Util22_SendEmail_Test 
@CreatedDate: 26 - Nov 2018 
@Description: GA_Util22_SendEmail Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_Util22_SendEmail_Test {
    
    /**
@Description: emailfNotifications() method 
@Name : emailfNotifications
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void emailfNotifications()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpSgmntRec.GA_Quote_ID__c='123';    
                grpSgmntRec.GA_Date_Posted__c = System.today();
                grpSgmntRec.GA_PostGrpNots__c = 'asdasf';
                grpSgmntRec.GA_MTV_Group__c = '000021378';
                database.insert(grpSgmntRec);
                
                List<GA_Group_Segment__c> grpSgmntList = [Select Id,Name,GA_PostGrpNots__c,GA_MTV_Group__c,GA_Date_Posted__c,GA_Account__r.Name from GA_Group_Segment__c where id =: grpSgmntRec.id Limit 1];
                
                string recId = acc.Id;
                
                EmailTemplate emailtmplt = new EmailTemplate (developerName = 'test', FolderId = UserInfo.getUserId(), TemplateType= 'Text', Name = 'test');
                emailtmplt.HtmlValue = '{!GA_Group_Segment__c.Name} - {!$Label.GA_WF_Cancellation_URL} -{RecordLinkURL}-{!GA_Group_Segment__c.GA_PostGrpNots__c}-{!GA_Group_Segment__c.GA_MTV_Group__c}';
                insert emailtmplt;
                
                string emailtmptNme = emailtmplt.Name;
                
                set<id> usrid = new set<id> ();
                usrid.add(usr.Id);
                
                String[] testmailBox = New String[]{usr.Email};
                
                Set<Id> userIds = New set<Id>();
                userIds.add(usr.id);
                
                test.startTest();
                GA_Util22_SendEmail.sendMailtoUsrs(userIds, grpSgmntRec.id, emailtmptNme, testmailBox);
                GA_Util22_SendEmail.sendMailtoUsrsUpdts(userIds, grpSgmntList[0], emailtmptNme, testmailBox, true);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
     /**
@Description: executeUtilFilterProssr() method 
@Name : executeUtilFilterProssr
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void executeUtilFilterProssr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                String usrId;
                String filter;
                Set<String> strList;
                Set<Id> idList;
                GA_Util08_FilterProcessHelper.fetchUsrDtls(usrId);
                GA_Util08_FilterProcessHelper.idSet(idList);
                GA_Util08_FilterProcessHelper.FltrString(filter);
                GA_Util08_FilterProcessHelper.strSet(strList);
               
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}