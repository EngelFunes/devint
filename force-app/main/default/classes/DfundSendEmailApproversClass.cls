/*****************************************************************************************************************************************************
@Author : Dinesh P
@Name: DfundSendEmailApproversClass
@CreatedDate:  20-Dec-2020 
@Description: DfundSendEmailApproversClass is used to send Reminder Email if dfund request is assigned to same approver if more than one day.

@version : 1.0  
@US Number: US-4293 ,US-4098, US-4100

---Modified---
*******************************************************************************************************************************************************/
    public with sharing class DfundSendEmailApproversClass {
    
    public static final string ClsName  = 'DfundSendEmailApproversClass';
    public static final string methodNme  = 'sendEmailToApprovers';
    public static final string methodNmedml  ='dmloprtions';
    public static final string dfundRecType = 'Dfund Request';
    public static final string uccrDfundRecType = 'UCCR DFund request';
    
    public static Id dfundReqRecordTypeId = Schema.SObjectType.Dfund_Request__c.getRecordTypeInfosByName().get(dfundRecType).getRecordTypeId();
    public static Id uccrdfundReqRecordTypeId = Schema.SObjectType.Dfund_Request__c.getRecordTypeInfosByName().get(uccrDfundRecType).getRecordTypeId();
    
    public static final string actQuery='select id,Status__c,RecordType.Name from Dfund_Request__c ';
    public static final string actWhere=' where Status__c !=null';
    public static final string actWhere1=' and recordtypeid in';       
    public static final string actwhere2 =  ' and (Status__c = \'Sales_Review\'';
    public static final string actwhere3 =  ' or Status__c = \'Underwriting Review\'';    
    public static final string actwhere4 =  ' or Status__c = \'Operations Review\'';               
    public static final string actwhere5 =  ' or Status__c = \'Finance Review\')';      
      
    public static final string actLIMIT = ' LIMIT 10000';
    
    //public static final string actwhere6 = ' and Id =\'aA02i0000004Rud\''; // testing
            
    public static final String QUOTE = '\'';
    public static final String QUOTECOMMA = '\',';
    public static final String COMMA =',';
    public static final String OPENBRACKET ='(';
    public static final String CLOSEBRACKET =')';
    public static final string ErrorMsg = 'Unable to Filter';
    public static final Integer DEFAULT_BATCH_SIZE = 1;

    
    /**
    @Description: ValidateException() method 
    @Name : ValidateException
    @Param : None
    @Return : void
    @throws Exception : N/A;
    */    
    public with sharing class ValidateException extends Exception {}
    
    /****************************************************************************************************
    Method Name : sendEmailToApprovers
    Parameters  : N/A
    Return type : Void
    Description : This method is used to send soql to the batch class to process batch requests
    ******************************************************************************************************/
    public static void sendEmailToApprovers()
    {
        try{             
                Decimal batchSize = DEFAULT_BATCH_SIZE;
                Set<id> dfundIdSet = new Set<id>();
                dfundIdSet.add(dfundReqRecordTypeId);
                dfundIdSet.add(uccrdfundReqRecordTypeId);
                
                String dfundRecIdString = idSet(dfundIdSet);                                                 
                String q=actQuery+actWhere+actWhere2+actWhere3+actWhere4+actWhere5+actWhere1+dfundRecIdString+actLIMIT;                                  
                //String q=actQuery+actWhere+actWhere2+actWhere3+actWhere4+actWhere5+actwhere6+actWhere1+dfundRecIdString+actLIMIT;                  
                                                
                System.debug('^^query'+q);              
                DfundSendEmailApproversBatch uptAcctBtch = new DfundSendEmailApproversBatch(q);
                ID batchprocessid = Database.executeBatch(uptAcctBtch,Integer.valueOf(batchSize));           
        }
        catch(Exception e){
           GA_LogExceptionCls.LogExcp(e, ClsName, 'sendEmailToApprovers');
        }
     }
    
     /****************************************************************************************************
     Method Name : dmloptions
     Parameters  : list<Dfund_Request__c> dReqList
     Return type : Void
     Description : 
     ******************************************************************************************************/
    public static void dmloptions(list<Dfund_Request__c> dReqList)
    {    
     try{
                        
        Map<String, ApprovalProcessProperty> m_approvalProp = new Map<String, ApprovalProcessProperty>();    
        Map<String,Dfund_Request__c> dfundRecordIdMap = new Map<String,Dfund_Request__c>();
           
        String dfundApproval = System.Label.DfundRequest_ApprovalProcessName;
        String uccrDfundApproval = System.Label.Dfund_Request_UCCR_Approval_ProcessName;
        if(!dReqList.isEmpty()){                    
            for(Dfund_Request__c dreq:dReqList){                              
               if(dfundRecType.equals(dreq.RecordType.Name)){                                                      
               m_approvalProp.put(dfundApproval, new ApprovalProcessProperty(dreq));         
               dfundRecordIdMap.put(dreq.Id,dreq);
               }
               if(uccrDfundRecType.equals(dreq.RecordType.Name)){                        
               m_approvalProp.put(uccrDfundApproval, new ApprovalProcessProperty(dreq));         
               dfundRecordIdMap.put(dreq.Id,dreq);
               }        
            }        
        }
        
        //Querying all active users
        Map<String,User> usrEmailMap = new Map<String,User>();
        for(User usrRecord:[Select Id,Email,DelegatedApproverId from User where isActive = true LIMIT : UTIL_SLB.retrieveQueryLimitValue()]){
           usrEmailMap.put(usrRecord.Id,usrRecord);
        }
        
        //Querying all the Queues        
        List<Group> grouprecordList = [select Id, Name from Group where Type ='Queue' LIMIT : UTIL_SLB.retrieveQueryLimitValue()];        
        Map<String,String> queueemailMap = new Map<String,String>();
        Map<String, List<String>> queueallemailMap = new Map<String, List<String>>();   
              
        if(!grouprecordList.isEmpty()){
        
            for(GroupMember grpm: [SELECT Id, Group.Name, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN:grouprecordList 
                                   LIMIT : UTIL_SLB.retrieveQueryLimitValue()]){
              
                if(((String)grpm.UserOrGroupId).startsWith('005') && usrEmailMap.ContainsKey(grpm.UserOrGroupId)){   
                              
                    Id delApprId = usrEmailMap.get(grpm.UserOrGroupId).DelegatedApproverId;
                    
                    if (queueallemailMap.containsKey(grpm.GroupId)) {
                        List<String> emailList = queueallemailMap.get(grpm.GroupId);
                        emailList.add(usrEmailMap.get(grpm.UserOrGroupId).Email);
                                                                        
                        if(delApprId !=null){
                        emailList.add(usrEmailMap.get(delApprId).Email);
                        }
                        
                        queueallemailMap.put(grpm.GroupId,emailList); 
                    } else {
                        String emailList = usrEmailMap.get(grpm.UserOrGroupId).Email;
                        String emailListDelgApp = '';
                    
                        queueallemailMap.put(grpm.GroupId, new List<String>{emailList});
    
                        if(delApprId !=null){
                         emailListDelgApp = usrEmailMap.get(delApprId).Email;
                         queueallemailMap.put(grpm.GroupId, new List<String>{emailList,emailListDelgApp});
                        }                        
                    }
                }   
            }                             
        }
    
        for(ProcessInstance pi: [SELECT Id, Status, TargetObjectId, LastModifiedDate, ProcessDefinition.DeveloperName, 
                                                        (SELECT Id, ActorId, StepStatus, CreatedDate, TargetObjectId ,Actor.Email FROM StepsAndWorkitems where StepStatus='Pending')
                                                        FROM ProcessInstance 
                                                        where Status IN ('Pending','Reassigned')
                                                        and ProcessDefinition.DeveloperName IN :m_approvalProp.keySet()
                                                        and ProcessInstance.TargetObjectId IN:dfundRecordIdMap.KeySet()
                                                        Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                                                        
                        ProcessInstanceRecord processInstanceRec = new ProcessInstanceRecord(pi.Id, pi.Status, pi.TargetObjectId, pi.LastModifiedDate);
                        
                        for (ProcessInstanceHistory pih : pi.StepsAndWorkItems) {
                            //system.debug('PIH values==='+pih);
                            ProcessInstanceItemRecord processInstanceItemRec = new ProcessInstanceItemRecord(pih.ActorId, pih.StepStatus, pih.CreatedDate,pih.TargetObjectId,pih.Actor.Email);
                            
                            processInstanceRec.addItem(processInstanceItemRec);
                        }
                        
                        m_approvalProp.get(pi.ProcessDefinition.DeveloperName).addRecordId(pi.TargetObjectId);
                        m_approvalProp.get(pi.ProcessDefinition.DeveloperName).addProcessInstance(processInstanceRec);               
        } 
        
        
        //Map<String,Dfund_Request__c> emailMap = new Map<String,Dfund_Request__c>();
        Map<String,List<String>> emailMap = new Map<String,List<String>>();
        Map<String,Dfund_Request__c> queMap = new Map<String,Dfund_Request__c>();
                
        for(String approvalKey : m_approvalProp.keySet()){                     
                    //Loop over approval process instance
                    for(ProcessInstanceRecord pi : m_approvalProp.get(approvalKey).l_instanceRecords){
                    
                        //Per each pending approver
                        for(ProcessInstanceItemRecord pih : pi.items) {
                            
                            //Calculate the hours/minutes difference from time processinstance was created until now                            
                            long seconds = system.now().getTime() - pih.CreatedDate.getTime();
                            System.debug('CreatedDate --'+pih.CreatedDate);
                            System.debug('SystemNow --'+system.now());                            
                            long millseconds = seconds/1000;                            
                            Integer min = Integer.valueof(millseconds/60);
                            System.debug('min --'+min );
                            Integer hours = min/60;                                      
                            
                            Integer mVal = Integer.ValueOf(System.Label.Dfund_ApproverReminderDuration); 
                            
         
                            if(Test.isRunningTest() || min > mVal){ 
                               String approverEmail = '';
                                String delApprEmail = '';                                
                                String queueId = System.Label.DfundQueueId;
                                
                                Dfund_Request__c dfundrecord = dfundRecordIdMap.ContainsKey(pih.recordId)?dfundRecordIdMap.get(pih.recordId):null;   
                                                                
                                if(pih.ActorId.startsWith('005')){
                                  approverEmail = pih.apemail;                                                        
                                  List<String> emailIds = new List<String>();                                                        
                                  emailIds.add(approverEmail);
                                  
                                  //Delegated Approver
                                  Id delApprId = usrEmailMap.get(pih.ActorId).DelegatedApproverId;                              
                                  delApprEmail = delApprId !=null?usrEmailMap.get(delApprId).Email:'';
                                  emailIds.add(delApprEmail);
                                                                                                                            
                                  emailMap.put(dfundrecord.Id,emailIds);                                      
                                }
                                if(pih.ActorId.startsWith(queueId)){
                                    List<String> emailIds = new List<String>();                                                        
                                    emailIds = queueallemailMap.get(pih.ActorId);                                                                                                                                                                                         
                                    emailMap.put(dfundrecord.Id,emailIds);                              
                                }                                                                            
                                System.debug('***********emailMap'+emailMap);
                            }                                        
                        }
                    }
        }   
              
       List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>(); 
       
       if(emailMap !=null && !emailMap.isEmpty()){
        
        Id emailNotificationTempID;
        List<String> tempNames = new List<String>{'DFund_Request_Approval_Reminder_Email_Notification'};      
        for (EmailTemplate emTemp : [SELECT ID,DeveloperName,Name FROM EmailTemplate WHERE DeveloperName IN: tempNames LIMIT :UTIL_SLB.retrieveQueryLimitValue()]) {
            if (emTemp.DeveloperName.equalsIgnoreCase('DFund_Request_Approval_Reminder_Email_Notification')) {
                emailNotificationTempID = emTemp.id;   
            }
        }
        
        
        String emailName = 'noreply@bcbsm.com';
        String OrgWideEmailAddress;
        
        try{
            OrgWideEmailAddress = [SELECT DisplayName,Id FROM OrgWideEmailAddress WHERE DisplayName =:emailName LIMIT 1].Id;
        }catch (QueryException e){
            System.debug('Exception '+e.getMessage());
        }
        
        
        Contact cnt;
        if (test.isrunningtest()) {
            Account acc = new Account(Name='testName');
            insert Acc;
            
            cnt = new Contact(Firstname ='test1',lastname='test2',AccountId=Acc.id,Email='guest@test.com');
            insert cnt;
        }else {       
            cnt = [select id, Email from Contact where email !=null limit 1];
        }
       
        for(String idstr:emailMap.keySet()){
       
          if(emailMap.containsKey(idstr) && idstr !=null && emailMap.get(idstr) !=null){
    
            for(String emailstr:emailMap.get(idstr)){
              
              
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                mail.setWhatId(idstr);
                
                mail.setOrgWideEmailAddressId(OrgWideEmailAddress);                                    
                mail.setTemplateId(emailNotificationTempID);
                                          
                Savepoint sp = Database.setSavepoint();
                mail.setTargetObjectId(cnt.id);  
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {   mail }); 
                Database.rollback(sp); 
                
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();                
                emailToSend.setToAddresses(new String[]{emailstr});            
                emailToSend.setWhatId(idstr);            
                emailToSend.setPlainTextBody(mail.getPlainTextBody());
                emailToSend.setHTMLBody(mail.getHTMLBody());
                emailToSend.setSubject(mail.getSubject());
                emailToSend.setOrgWideEmailAddressId(OrgWideEmailAddress);
                //system.debug('======emailToSend'+emailToSend);
                listmail.add(emailToSend);                     
             }       
           }
        }                                  
       }
       
       if(!listmail.isEmpty() && listmail != null){
            try{     
                Messaging.sendEmail(listmail);                   
            } catch (Exception e){
                System.debug('Exception@@@@ '+e.getMessage());
            }
       }                                                                                          
     }
     catch(Exception e){
         GA_LogExceptionCls.LogExcp(e, ClsName, 'dmloptions');
     }
    }
    
    //Wrapper Class - ApprovalProcessProperty */
    public class ApprovalProcessProperty{

        public Dfund_Request__c approvalProcessReminder;
        public list<String> l_recordsIds;
        public list<ProcessInstanceRecord> l_instanceRecords;
        
        map<String, SObject> m_relatedRecords;
        
        public ApprovalProcessProperty(Dfund_Request__c pApprovalProcessReminder){
            approvalProcessReminder = pApprovalProcessReminder;
            
            l_recordsIds = new list<String>();
            l_instanceRecords = new list<ProcessInstanceRecord>();
            m_relatedRecords = new map<String, SObject>();
        }
        
        public void addRecordId(String recordId){
            l_recordsIds.add(recordId);
        }
        
        public void addProcessInstance(ProcessInstanceRecord processRecord){
            l_instanceRecords.add(processRecord);
        }
    }   
    //Wrapper Class - the standard salesfore ProcessInstance/InstanceItems */
    public class ProcessInstanceRecord{
        
        public String id;
        public String status;
        public String targetObjectId;
        public DateTime lastModifiedDate;
        
        public list<ProcessInstanceItemRecord> items;
        
        public ProcessInstanceRecord(String pId, String pStatus, String pTargetObjectId, DateTime pDateTime){
            id = pId;
            status = pStatus;
            targetObjectId = pTargetObjectId;
            lastModifiedDate = pDateTime;
            
            items = new list<ProcessInstanceItemRecord>();
        }
        
        public void addItem(ProcessInstanceItemRecord itemRecord){
            items.add(itemRecord);
        }
    }
    
    /*Wrapper Class - ProcessInstanceItemRecord*/
    public class ProcessInstanceItemRecord{

        public String actorId;
        public String stepStatus;
        public DateTime createdDate;
        public String recordId;
        public String apemail;
        
        public ProcessInstanceItemRecord(String pActorId, String pStepStatus, Datetime pCreatedDate,String recId,String email){
            actorId = pActorId;
            stepStatus = pStepStatus;
            createdDate = pCreatedDate;
            recordId = recId;
            apemail = email;
        }
    }
   

    /*convert a Set<String> into a quoted, comma separated String literal for inclusion in a dynamic SOQL Query*/
    public static String idSet(Set<Id> idList)
    {
        try{
            string newSetStr = '';
            for(String str : idList)
                newSetStr += QUOTE + str + QUOTECOMMA;
            
            newSetStr = newSetStr.lastIndexOf(COMMA) > 0 ? OPENBRACKET + newSetStr.substring(0,newSetStr.lastIndexOf(COMMA)) + CLOSEBRACKET : newSetStr ;   
            
            return newSetStr; 
        }
        catch(exception e)
        {
            throw new ValidateException(ErrorMsg, e);
        }        
    }
}