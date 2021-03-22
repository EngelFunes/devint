/**
@Author : IDC Offshore
@Name: GA_AORSendingEmail_Batch
@CreatedDate: 03 - June - 2019 
@Description: GA_AORSendingEmail_Batch batch class to send AOR email 
*/
global class GA_AORSendingEmail_Batch implements Database.Batchable<sObject>{
    private string aorQuery; 
    public static final String TILTOPRTR='~';
    public static final String SPRTROPRTR='^';
    public static final String FROMEMAILADDRESS='noreplysalesforce@bcbsm.com';
    public static final String AORREQUESTEMAILADDRESS='agentadminaorrequests@bcbsm.com';
    public static final String EMLTMPTDEVNM = 'GA_AOR_Letter_Express_2ndExAgtLtr';
    public static final String BLNK = '';
    public static final String AORNAME = 'AORName';
    public static final String AORSRVCDATE = 'AORServiceStartDate';
    public static final String AORCOMMSSDATE = 'AORCommissionStartDate';
    public static final String ACCNAME = '{!relatedTo.GA_Account_Id__r.Name}';
    public static final String ACCBILLCTY = '{!relatedTo.GA_Account_Id__r.BillingCity}';
    public static final String ACCBILLSTREET = '{!relatedTo.GA_Account_Id__r.BillingStreet}';
    public static final String ACCBILLINGCITY = '{!relatedTo.GA_Account_Id__r.BillingState}';
    public static final String ACCBILNGPSTCD ='{!relatedTo.GA_Account_Id__r.BillingPostalcode}';
    public static final String AORPRCSSDDT ='{!month(relatedTo.GA_Process_Date__c)}/{!day(relatedTo.GA_Process_Date__c)}/{!year(relatedTo.GA_Process_Date__c)}';
    public static final String AORAGNTNAME ='{!relatedTo.GA_Contact_Id__r.Name}';
    public static final String AORAGNTCODE = '{!relatedTo.GA_Contact_Id__r.Agent_Code__c}';
     public static final String AORCMMMDT ='{!month(relatedTo.GA_Commission_Start_Date__c)}-{!day(relatedTo.GA_Commission_Start_Date__c)}-{!year(relatedTo.GA_Commission_Start_Date__c)}';
     public static final String AORCMMENDDT = '{!month(relatedTo.GA_Commission_End_Date__c)}-{!day(relatedTo.GA_Commission_End_Date__c)}-{!year(relatedTo.GA_Commission_End_Date__c)}';
    public static final String AORAGNCY ='{!relatedTo.GA_Agency__c}';
    public static final String CNTCMAILSTRT = '{!relatedTo.GA_Contact_Id__r.Mailingstreet}';
    public static final String CNTCMAILCTY = '{!relatedTo.GA_Contact_Id__r.Mailingcity}';
    public static final String CNTCMAILSTATE =  '{!relatedTo.GA_Contact_Id__r.Mailingstate}';
    public static final String CNTCMAILPOSTALCD =  '{!relatedTo.GA_Contact_Id__r.MailingPostalcode}'; 
    public static final String ACCCID = '{!relatedTo.GA_Account_Id__r.CID__c}';
     public static final String AORNAMESTR ='{!relatedTo.Name}';
    public static final String FRMTAORPRSCSTR ='{!relatedTo.GA_Format_Process_Date__c}';
    public static final String FRMTAORCMNCSTR ='{!relatedTo.GA_Format_Commission_Start_Date__c}';
    public static final String FRMTAORCMNCEND ='{!relatedTo.GA_Format_Commission_End_Date__c}';
     
    /**
@Description: GA_AORSendingEmail_Batch() Constructer method 
@Name : GA_AORSendingEmail_Batch
@Param : string aorgsQry
@Return : void
@throws Exception : N/A;
*/  
    global GA_AORSendingEmail_Batch(string aorQry)
    {
        aorQuery=aorQry;
    }
    /**
@Description: start() method 
@Name : start
@Param : Database.BatchableContext BC
@Return : Database.QueryLocator
@throws Exception : N/A;
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(aorQuery); 
    }
    /**
@Description: execute() method 
@Name : execute
@Param : Database.BatchableContext BC, List<sObject> scope
@Return : Database.QueryLocator
@throws Exception : N/A;
*/ 
    global void execute(Database.BatchableContext batchCtxt, List<GA_AOR__c> recScope)
    {
        Map<String,Id> aorCnctMap = new Map<String,Id>();
        Map<String,String> letterTmpMap = New Map<String,String>();
        Map<String,String> LttrTmpltIdMap = New Map<String,String>();
        Map<String,String> aorcntcLttrTmpltMap = New Map<String,String>();
        Set<Id> aorIds =  New Set<Id> ();
        Set<Id> letterTypeSet = new Set<Id>();
        
        List<Messaging.SingleEmailMessage> emailsLst = new List<Messaging.SingleEmailMessage>();
        Map<Id,GA_AOR__c> aorMap = New Map<Id,GA_AOR__c>();
        OrgWideEmailAddress emailOfAgentAor = [select Id, Address, DisplayName from OrgWideEmailAddress where Address = :AORREQUESTEMAILADDRESS];
        System.debug('---recScope---'+recScope.size());
        for(GA_AOR__c aorRec : recScope ){
            String agntLttrtype = aorRec.GA_Letter_Type__c;
            String custLttrtype =  aorRec.GA_Customer_Letter_Type__c;
            if(!String.isEmpty(aorRec.GA_Letter_Type__c) && !String.isEmpty(aorRec.GA_To__c)){
                aorCnctMap.put(aorRec.id+TILTOPRTR+aorRec.GA_Contact_Id__c+SPRTROPRTR+aorRec.GA_Letter_Type__c,aorRec.GA_Contact_Id__c); 
            }
            if(!String.isEmpty(aorRec.GA_Customer_Letter_Type__c) &&  !String.isEmpty(aorRec.GA_CC__c)){
                aorCnctMap.put(aorRec.id+TILTOPRTR+aorRec.GA_Account_Id__r.GA_Decision_Maker__c+SPRTROPRTR+aorRec.GA_Customer_Letter_Type__c,aorRec.GA_Account_Id__r.GA_Decision_Maker__c); 
            }
            aorMap.put(aorRec.Id,aorRec);
        }
        System.debug('---aorCnctMap---'+aorCnctMap.size());
        Map<Id,Contact> cntLst = New Map<Id,Contact>([Select Id,Email from Contact where id in: aorCnctMap.values() Limit 1000]);
        system.debug(aorCnctMap); 
        list<GA_AORLetterTemplatesConfig__mdt> letterTmplLst=[select id,GA_AOR_Letter_type__c,GA_VF_Template__c from 
                                                              GA_AORLetterTemplatesConfig__mdt   Limit 20];
        List<String> vfTmpLst =  New List<String>();
        for(GA_AORLetterTemplatesConfig__mdt letterTmp : letterTmplLst){
            letterTmpMap.put(letterTmp.GA_VF_Template__c+SPRTROPRTR+letterTmp.GA_AOR_Letter_type__c,letterTmp.GA_AOR_Letter_type__c);
            vfTmpLst.add(letterTmp.GA_VF_Template__c);
        }
        system.debug(letterTmpMap); 
        Map <Id,EmailTemplate> emailTmpltLst= New Map<Id,EmailTemplate>([SELECT Id,DeveloperName,HtmlValue,Subject,Markup FROM EmailTemplate 
                                                                         WHERE DeveloperName in: vfTmpLst Limit 100]);
        
        
        for(EmailTemplate emTmp :  emailTmpltLst.values()){
            for(String lettrkey :  letterTmpMap.keySet()){   
                String vfTmpDevNm = lettrkey.substringBefore(SPRTROPRTR);
                if(vfTmpDevNm.equalsIgnoreCase(emTmp.DeveloperName)){
                    LttrTmpltIdMap.put(letterTmpMap.get(lettrkey),emTmp.id);
                }
            }
        }
        List<EmailMessage> emaiMsgLst = New List<EmailMessage>();
        if(!aorCnctMap.isEmpty()){
            for(String aorInfo : aorCnctMap.keySet()){
                if(LttrTmpltIdMap.containsKey(aorInfo.substringAfter(SPRTROPRTR))){
                    // Logic to set cc address only for agent letter type
                    System.debug('---aorInfo.substringAfter(SPRTROPRTR)--'+aorInfo.substringAfter(SPRTROPRTR));
                    if(aorInfo.substringAfter(SPRTROPRTR) == 'AOR Normal (New)'){
                        letterTypeSet.add(aorInfo.substringBefore(SPRTROPRTR).substringAfter(TILTOPRTR));
                    }
                    // End
                    aorcntcLttrTmpltMap.put(aorInfo.substringBefore(SPRTROPRTR),LttrTmpltIdMap.get(aorInfo.substringAfter(SPRTROPRTR))); 
                }
            }
            List<EmailMessage> emailMsgLst = New List<EmailMessage>();
            EmailTemplate emailTmplt= [SELECT Id,HtmlValue,Subject,Markup FROM EmailTemplate WHERE DeveloperName = :EMLTMPTDEVNM Limit 1];
            
           // String htmlBody = emailTmplt.HtmlValue ;
            List<String> ccIdsList = new List<String>();
            for(  String aorCntinfo : aorcntcLttrTmpltMap.keySet() ){
                
             String htmlBody = emailTmpltLst.get(aorcntcLttrTmpltMap.get(aorCntinfo)).HtmlValue;          
                
                String nme = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).Name;
                String accNme = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.Name;
                String srvDt = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Service_Start_Date__c <> null ? String.ValueOf((Date)aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Service_Start_Date__c) : BLNK;
                String cmmDt = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Commission_Start_Date__c <> null ? String.ValueOf((Date)aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Commission_Start_Date__c) : BLNK;
                String cmmEndDt = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Commission_End_Date__c <> null ? String.ValueOf((Date)aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Commission_End_Date__c) : BLNK;
                String billCty = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.BillingCity <> null ? aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.BillingCity : BLNK;
                String billState = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.BillingState <> null ? aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.BillingState : BLNK;
                String billStreet = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.BillingStreet <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.BillingStreet  : BLNK;
                String billPstalcd = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.BillingPostalcode <> null ? aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.BillingPostalcode : BLNK;
                String aorPrcsdDt = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Process_Date__c <> null ?  String.ValueOf((Date)aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Process_Date__c) : BLNK;
                String agntName = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.Name  <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.Name  : BLNK;
                String agntCode = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.Agent_Code__c  <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.Agent_Code__c  : BLNK;
                String aorAgcy = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Agency__c <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Agency__c  : BLNK;
                String cntcMailStrtstr = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.Mailingstreet <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.Mailingstreet  : BLNK;
                String cntcMailCtystr = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.Mailingcity <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.Mailingcity  : BLNK;
                String cntcMailStatestr = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.Mailingstate <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.Mailingstate  : BLNK;
                String cntcMailPstCdstr= aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.MailingPostalcode <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Contact_Id__r.MailingPostalcode  : BLNK;
                String accntCid = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.CID__c <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.CID__c  : BLNK;
                String strFRMTAORPRSCSTR = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Format_Process_Date__c <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Format_Process_Date__c  : BLNK;
                String strFRMTAORCMNCSTR = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Format_Commission_Start_Date__c <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Format_Commission_Start_Date__c  : BLNK;
                String strFRMTAORCMNCEND = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Format_Commission_End_Date__c <> null ?  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Format_Commission_End_Date__c  : BLNK;
                String agntLttrtype = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Letter_Type__c;
                String custLttrtype =  aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Customer_Letter_Type__c;
                string ownerEmail = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.Owner.Email;
                string accountOwnerName = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.Account_Owner__c;
                String ownerIdVal = aorMap.get(aorCntinfo.substringBefore(TILTOPRTR)).GA_Account_Id__r.OwnerId;
                system.debug('recScope. after---'+agntLttrtype);
                system.debug('recScope. after---'+custLttrtype);
                ccIdsList.add(ownerIdVal);
                system.debug('ccIdsList. after---'+ccIdsList);
                if(htmlBody <> null )
                {
                    htmlBody = htmlBody.replace(AORNAME,nme);
                    htmlBody = htmlBody.replace(ACCNAME,accNme);
                    htmlBody = htmlBody.replace(AORSRVCDATE,srvDt);
                    htmlBody = htmlBody.replace(AORCOMMSSDATE,cmmDt);    
                    htmlBody = htmlBody.replace(ACCBILLCTY,billCty); 
                    htmlBody = htmlBody.replace(ACCBILLINGCITY,billState); 
                    htmlBody = htmlBody.replace(ACCBILNGPSTCD,billPstalcd); 
                    htmlBody = htmlBody.replace(ACCBILLSTREET,billStreet);
                    htmlBody = htmlBody.replace(AORPRCSSDDT,aorPrcsdDt); 
                    htmlBody = htmlBody.replace(AORAGNTNAME,agntName);
                    htmlBody = htmlBody.replace(AORAGNTCODE,agntCode);
                    htmlBody = htmlBody.replace(AORCMMMDT,cmmDt);
                    htmlBody = htmlBody.replace(AORAGNCY,aorAgcy);
                    htmlBody = htmlBody.replace(CNTCMAILSTRT,cntcMailStrtstr);
                    htmlBody = htmlBody.replace(CNTCMAILCTY,cntcMailCtystr);
                    htmlBody = htmlBody.replace(CNTCMAILSTATE,cntcMailStatestr);
                    htmlBody = htmlBody.replace(CNTCMAILPOSTALCD,cntcMailPstCdstr);
                    htmlBody = htmlBody.replace(ACCCID,accntCid);
                    htmlBody = htmlBody.replace(AORCMMENDDT,cmmEndDt);
                    htmlBody = htmlBody.replace(AORNAMESTR,nme);
                    htmlBody = htmlBody.replace(FRMTAORPRSCSTR,strFRMTAORPRSCSTR);
                    htmlBody = htmlBody.replace(FRMTAORCMNCSTR,strFRMTAORCMNCSTR);
                    htmlBody = htmlBody.replace(FRMTAORCMNCEND,strFRMTAORCMNCEND);
                                         
                    Messaging.SingleEmailMessage aorMail = new Messaging.SingleEmailMessage(); 
                    // aorMail.setTargetObjectId(aorCntinfo.substringAfter(TILTOPRTR)); 
                    //Change with Template ID
                    aorMail.setTemplateId(aorcntcLttrTmpltMap.get(aorCntinfo)); 
                    //Record ID for which letter will be generated
                    aorMail.setWhatId(aorCntinfo.substringBefore(TILTOPRTR)); 
                    aorIds.add(aorCntinfo.substringBefore(TILTOPRTR));
                    aorMail.setToAddresses(New List<String> {cntLst.get(aorCntinfo.substringAfter(TILTOPRTR)).Email});
                    
                    // Logic to set cc address only for agent letter type
                    if(letterTypeSet.contains(aorCntinfo.substringAfter(TILTOPRTR)) && accountOwnerName != 'Informatica Admin User'){
                        aorMail.setCcAddresses(New List<String> {ownerIdVal});
                    }
                    // End 
                    //if(agntLttrtype == 'AOR Normal (New)' && accountOwnerName != 'Informatica Admin User'){
                                //aorMail.setCcAddresses(New List<String> {ownerIdVal});
                    //}
                    aorMail.setBccSender(false); 
                    aorMail.setHtmlBody(htmlBody);
                    aorMail.setUseSignature(false); 
                    aorMail.setOrgWideEmailAddressId(emailOfAgentAor.Id); 
                    aorMail.setSaveAsActivity(false);
                           
                    emailsLst.add(aorMail);
                    String recordId = aorCntinfo.substringAfter(TILTOPRTR);
                    EmailMessage emailMessage = new EmailMessage();
                    emailMessage.status = '3'; // email was sent
                    emailMessage.relatedToId = aorCntinfo.substringBefore(TILTOPRTR);//aorCntinfo.substringBefore(TILTOPRTR); // related to record e.g. an opportunity
                    emailMessage.fromAddress = System.Label.GA_AORSenderEmail; // from address       
                    emailMessage.fromName = System.Label.GA_AORSenderEmail; // from name
                    
                    /*if(agntLttrtype == 'AOR Normal (New)' && custLttrtype == 'AOR Normal (Group)' && accountOwnerName != 'Informatica Admin User'){
                        system.debug('inside recScope. after---'+agntLttrtype);
                        system.debug('inside recScope. after---'+custLttrtype);
                        emailMessage.CcIds = ccIdsList;
                    }*/
                    
                    if(letterTypeSet.contains(aorCntinfo.substringAfter(TILTOPRTR)) && accountOwnerName != 'Informatica Admin User'){
                        //emailMessage.CcIds = ccIdsList;
                        emailMessage.ccAddress = ownerIdVal ;
                    }
                    
                    
                    emailMessage.subject = emailTmplt.subject; // email subject
                    emailMessage.htmlBody = htmlBody; // email body
                    emailMessage.toAddress =cntLst.get(aorCntinfo.substringAfter(TILTOPRTR)).Email ;
                    //emailMessage.ccAddress = ownerIdVal ; 
                    emailMessage.GA_AOR__c = aorCntinfo.substringBefore(TILTOPRTR); 
                    system.debug('emailMessage. after---'+emailMessage);
                    emailMsgLst.add(emailMessage);
                }
            }
            System.debug('--emailsLst---'+emailsLst.size());
            for(Messaging.SingleEmailMessage aorMail : emailsLst){
                system.debug('---aorMail..toaddresses--'+aorMail.toaddresses);
                system.debug('---aorMail..ccaddresses--'+aorMail.ccaddresses);
            }
            Messaging.sendEmail(emailsLst);
            database.insert(emailMsgLst);
            
            List<GA_AOR__c> updtAorLst= New List<GA_AOR__c>();
            GA_AOR__c updtAor = New GA_AOR__c();
            for(Id aorRecid : aorIds){
                updtAor =  New GA_AOR__c(id = aorRecid,
                                         GA_Process_Date__c = null,
                                         GA_Letter_Type__c = null,
                                         GA_Customer_Letter_Type__c = null,
                                         //  GA_To__c = null,
                                         // GA_CC__c = null,
                                         GA_Is_Mass_Updating__c = true);
                updtAorLst.add(updtAor);
            }
            Database.update(updtAorLst);
            
            
        } 
        
    }
    /**
@Description: finish() method 
@Name : finish
@Param : Database.BatchableContext BC
@Return : Void
@throws Exception : N/A;
*/ 
    global void finish(Database.BatchableContext bc)
    {
        
    }
}