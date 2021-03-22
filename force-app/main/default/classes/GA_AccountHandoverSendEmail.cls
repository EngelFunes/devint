/*****************************************************************************************
Class Name   : GA_AccountHandoverSendEmail
Date Created : 09/22/2020
Created By   : Steven Pascaran 
Description  : This is the class responsible for sending the email to the Account Owner
whenever the Account Handover's Status is changed to "Transition to Retention Account Manager"
******************************************************************************************/
public class GA_AccountHandoverSendEmail {
    public static final string emailTmpltDevName = 'Retention_Account';
    public static final String ClsName  ='GA_AccountHandoverSendEmail';
    public static final String methodNmesendEmail ='sendEmail';
    public static final String informaticaUser = 'Informatica Admin User';
    
    public static void sendEmail(List<GA_AccountHandOver__c> achToMailList){
        // Set used later to get the managers of the users in the set
        Set<String> userIDList = new Set<String>();                    
        Set<String> accIDSet = new  Set<String>();
        //Map<String,String> terrIDMap = new  Map<String,String>();
        Map<String,String> AccUserIDMap = new  Map<String,String>();
        //Map<String,String> TerUserIDMap = new  Map<String,String>();
        //Map<String,String> UserManagerMap = new  Map<String,String>();
        Map<String,String> UserManagerEmailMap = new  Map<String,String>();
        
        List<String> ownerIDList = new  List<String>();
        
        try{
            // Field containing the Account related to the Handover --> GA_CompanyFullLegalName__c
            for(GA_AccountHandOver__c ach : achToMailList){
                accIDSet.add(ach.GA_CompanyFullLegalName__c);
                // To get the owner email
                userIDList.add(ach.CreatedById);
                //ownerIDList.add(ach.CreatedById);
            }
            
            // Query Account and check the Account_Services_Representative__c field if populated
            for(Account acc : [SELECT ID, Name, Account_Services_Representative__c, GA_Territory__c, OwnerId FROM Account WHERE ID =: accIDSet]){
                System.debug('Account Name: '+acc.Name);
                /*if(acc.Account_Services_Representative__c != null){
                    system.debug('acc.Account_Services_Representative__c: '+acc.Account_Services_Representative__c);
                    AccUserIDMap.put(acc.ID,acc.Account_Services_Representative__c);
                    userIDList.add(acc.Account_Services_Representative__c);
                }*/
                system.debug('acc.OwnerId '+acc.OwnerId);
                AccUserIDMap.put(acc.ID,acc.OwnerId);
                userIDList.add(acc.OwnerId);
                // Get the Territory IDs of the Accounts to query later
                // terrIDMap.put(acc.ID,acc.GA_Territory__c);
            }
            
            // Query Territory and check the GA_RetentionSalesRepresentative__c field if populated
            /*for(GA_Territory__c ter : [SELECT ID, Name, GA_RetentionSalesRepresentative__c FROM GA_Territory__c WHERE ID =: terrIDMap.values()]){
                System.debug('Territory Name: '+ter.Name);
                if(ter.GA_RetentionSalesRepresentative__c != null){
                    system.debug('ter.GA_RetentionSalesRepresentative__c: '+ter.GA_RetentionSalesRepresentative__c);
                    TerUserIDMap.put(ter.ID,ter.GA_RetentionSalesRepresentative__c);
                    userIDList.add(ter.GA_RetentionSalesRepresentative__c);
                }
            }*/
            system.debug('userIDList: '+userIDList);
            // Query User and get Manager ID and Owner ID to query and get the email
            for(User usr : [SELECT ID, Name, ManagerId, Email FROM User WHERE ID =: userIDList]){
                if(usr.Name != informaticaUser){
                    system.debug('User: '+usr.Name);
                    //UserManagerMap.put(usr.ID,usr.ManagerId);
                    //if(ownerIDList.contains(usr.ID)){
                        UserManagerEmailMap.put(usr.ID,usr.Email);
                    //}
                }
            }
            
            // Query User's Manager and get the email
            /*for(User usr : [SELECT ID, Name, Email FROM User WHERE ID =: UserManagerMap.values()]){
                System.debug('Manager Name: '+usr.Name+'+++++ Manager Email: '+usr.Email);
                UserManagerEmailMap.put(usr.ID,usr.Email);
            }*/
            
            // Code to send email
            // Manager's will be the To of the email
            List<String> emailList = new List<String>();
            // Person who created the form will be CC'd
            List<String> emailccList = new List<String>();
            
            EmailTemplate emailTmplt= [SELECT Id,HtmlValue,Subject,Markup FROM EmailTemplate WHERE DeveloperName = :emailTmpltDevName Limit 1];
            String emailTmpltId=emailTmplt.Id;
            
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            
            // Map all the data to send the email
            for(GA_AccountHandOver__c ach : achToMailList){
                // Account Service Rep Manager Email
                //emailList.add(UserManagerEmailMap.get(UserManagerMap.get(AccUserIDMap.get(ach.GA_CompanyFullLegalName__c))));
                emailList.add(UserManagerEmailMap.get(AccUserIDMap.get(ach.GA_CompanyFullLegalName__c)));
                system.debug('Account Service Rep Manager Email: '+emailList);
                
                // Retention Sales Rep Manager Email
               // emailList.add(UserManagerEmailMap.get(UserManagerMap.get(TerUserIDMap.get(terrIDMap.get(ach.GA_CompanyFullLegalName__c)))));
                //system.debug('Retention Sales Rep Manager Email: '+emailList);
                
                // Owner Email
                emailccList.add(UserManagerEmailMap.get(ach.CreatedById));
                system.debug('Owner Email: '+emailccList);
                
                // If there are Manager to email, create a mail
                if(emailList.size() > 0){
                    // From user ID
                    String userId = ach.LastModifiedById;
                    // whatID, the record used to be rendered in the email template
                    //String accId = ach.GA_CompanyFullLegalName__c; 
                    // Render the Email Template. Param: Email Temp ID / User Id / What Id
                    Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTmpltId, userId, ach.id);
                    
                    String emailSubject = email.getSubject();
                    String emailTextBody = email.getPlainTextBody();
                    email.setToAddresses(emailList);
                    email.setCcAddresses(emailccList);
                    email.setTargetObjectId(userId);
                    email.setSubject(emailSubject);
                    email.setPlainTextBody(emailTextBody);
                    email.setSaveAsActivity(false);
                    emails.add(email);
                }
                
                emailList.clear();
                emailccList.clear();
            }
            
            Messaging.sendEmail(emails); 
            
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmesendEmail);
        }
        
    }
}