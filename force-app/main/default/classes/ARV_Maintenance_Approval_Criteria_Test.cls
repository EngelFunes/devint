@isTest(seealldata=false)
public class ARV_Maintenance_Approval_Criteria_Test {
    private static final string PROFILENAME1='Retention Sales';
    private static final string NAME2='AP33RateGrid';
    public static final Id gwcTTRcrdTypId1 = Schema.SObjectType.ARV_GWC_Transaction_Table__c.getRecordTypeInfosByName().get('Maintenance Change').getRecordTypeId();
    public static final String EMPTYSTRING='';
    private static final string AccountName='TestAcc';
    Private static final String CID='23';
    private static final string RecordTypeId='redcordid';
    private static final String ACCOUNTID='accountid'; 
    private static final String TEST_VAL='Test'; 
    public static Boolean isEmailSent= true;
    
   
@TestSetup static void testDataSetup()
    {
        Account acct = new Account(name='TestAcc');
        acct.Name=AccountName;
        acct.CID__c=CID;
        database.insert(acct);
        ARV_GWC_Transaction_Table__c gwcTrans= new ARV_GWC_Transaction_Table__c(ARV_Maintenance_Change_Approval_Criteria__c='Rating Area Change');
        database.insert(gwcTrans);
        gwcTrans.Status__c = 'In Progress';
                
        Id recordID = Schema.SObjectType.ARV_GWC_Transaction_Table__c.getRecordTypeInfosByName().get('Maintenance Change').getRecordTypeId();
        gwcTrans.RecordtypeId= recordID;
        database.update(gwcTrans);
        
        gwcTrans.Status__c = 'Under Review';
        database.update(gwcTrans);
        
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME2;
        if(user.SObjectType.getDescribe().isAccessible()){database.insert(usr,true);}       
    }
    
 //Get Criteria record and update status on approval 
@isTest
    static void  testmethod1(){
                Account acc = ARV_AP05_TestDataCreation.accRec();
                Database.insert(acc);
                system.debug('acc::'+acc);
         List <ARV_GWC_Transaction_Table__c> gwctra =[select Account_ID__c,Status__c,ARV_Maintenance_Change_Approval_Criteria__c from 
                                               ARV_GWC_Transaction_Table__c where Status__c='Under Review'];
                system.debug('gwctra::'+gwctra);
        
        
                if(gwctra.size()>0)
                {user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
                system.runAs(usr2){    
        try{        
                system.test.startTest();
                ARV_Maintenance_Approval_Criteria.getCriteriaRecords(string.valueof(gwctra[0].id));
                ARV_Maintenance_Approval_Criteria.approveRecord(string.valueof(gwctra[0].id));
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
                
         }  }  
    }

//SendEmail
@isTest
       static void  testmethod2(){
                Account acc = ARV_AP05_TestDataCreation.accRec();
                Database.insert(acc);
      
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String emailBody = EMPTYSTRING;
                String toAddresses = '';
                mail.setToAddresses(new String[]{'randomtest@sample.com'});   
      
                mail.setSubject('Test sub');
                emailBody += '<html> Test Message</html>';

                mail.setHTMLBody(emailBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     
      try{
               system.test.startTest();
               ARV_Maintenance_Approval_Criteria.sendEmailMC(acc.Name,string.valueof(acc.Id));
                
               system.test.stoptest();
               }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
   }
 }
}