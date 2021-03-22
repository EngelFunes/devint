/**
* Used for all Agent Support request using LWC on FSA project
*/

public without sharing class FSA_SupportRequest {

    public class OptionWrapper {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }

        public OptionWrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    public class ReportDto {
        @AuraEnabled
        public String reportName { get; set; }
        @AuraEnabled
        public String reportDescription { get; set; }
        @AuraEnabled
        public String reportLink { get; set; }

        public ReportDto(String reportName, String reportDescription, String reportLink) {
            this.reportName = reportName;
            this.reportDescription = reportDescription;
            this.reportLink = reportLink;
        }
    }

    public class Agent {
        public Agent(string id, string agentCode, string name) {
            this.Id = id;
            this.Name = name;
            this.AgentCode = agentCode;
        }
        public string Id { get; set; }
        public string Name { get; set; }
        public string AgentCode { get; set; }
    }

    public class CaseDto {
        @AuraEnabled
        public Id Id { get; set; }
        @AuraEnabled
        public string Status { get; set; }
        @AuraEnabled
        public string AccountName { get; set; }
        @AuraEnabled
        public string CaseNumber { get; set; }
        @AuraEnabled
        public string CaseOwner { get; set; }
        @AuraEnabled
        public string AsrName { get; set; }
        @AuraEnabled
        public string Subject { get; set; }
        @AuraEnabled
        public string Description { get; set; }
        @AuraEnabled
        public string Origin { get; set; }
        @AuraEnabled
        public string WorkOrderCategory { get; set; }
        @AuraEnabled
        public string SupportRequestType { get; set; }
        @AuraEnabled
        public string CreatedBy { get; set; }
        @AuraEnabled
        public DateTime CreatedDate { get; set; }
        @AuraEnabled
        public string LastModifiedBy { get; set; }
        @AuraEnabled
        public DateTime LastModifiedDate { get; set; }
        @AuraEnabled
        public Id AccountId { get; set; }
        @AuraEnabled
        public string GaAgentName { get; set; }
        @AuraEnabled
        public Id GaAgentId { get; set; }
        @AuraEnabled
        public string GroupSegment { get; set; }
        @AuraEnabled
        public string ExternalStatus { get; set; }
        @AuraEnabled
        public Id CreatedById { get; set; }
        @AuraEnabled
        public Id DelegatedAgent { get; set; }
        @AuraEnabled
        public Boolean IsEdit { get; set; }


        public CaseDto(Id id, string status, string accountName, string caseNumber, string caseOwner, string asrName, string subject, string description, string origin, string workOrderCategory, string supportRequestType,
                string createdBy, string lastModifiedBy, Id accountId, DateTime createdDate, Datetime lastModifiedDate, String gaAgentName, Id gaAgentNameId, String groupSegment, String externalStatus, Id createdById, Id delegatedAgent, Boolean isEdit) {
            this.Id = id;
            if (status == 'Waiting on Internal Response') {
                this.Status = 'In Progress';
            } else {
                this.Status = status;
            }
            this.AccountName = accountName;
            this.CaseNumber = caseNumber;
            this.CaseOwner = caseOwner;
            this.AsrName = asrName;
            this.Subject = subject;
            this.Description = description;
            this.Origin = origin;
            this.WorkOrderCategory = workOrderCategory;
            this.SupportRequestType = supportRequestType;
            this.CreatedBy = createdBy;
            this.LastModifiedBy = lastModifiedBy;
            this.AccountId = accountId;
            this.LastModifiedDate = lastModifiedDate;
            this.CreatedDate = createdDate;
            this.GaAgentName = gaAgentName;
            this.GaAgentId = gaAgentNameId;
            this.GroupSegment = groupSegment;
            this.ExternalStatus = externalStatus;
            this.CreatedById = createdById;
            this.DelegatedAgent = delegatedAgent;
            this.IsEdit = isEdit;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Case getCase(string caseId) {
        System.debug('CaseId ' + caseId);
        Case newCase = [
                SELECT Id, Status, CaseNumber, Account.Name, GA_AgentName__r.Name, Subject, Description,
                        GA_WorkOrderCategory__c, GA_SupportRequest_Type__c, LastModifiedBy.Name, CreatedBy.Name,
                        External_Status__c
                FROM Case
                WHERE Id = :caseId
        ];
        System.debug(newCase);
        return newCase;
    }

    @AuraEnabled
    public static Boolean delCase(Id caseId) {
        System.debug('Del case' + caseId);
        try {
            Case newCase = [SELECT Id FROM Case WHERE Id = :caseId];
            Set<Id> contentDocumentLinkId = new Set<Id>();
            for(ContentDocumentLink contentDocumentLinkRecord : [Select Id, ContentDocumentId From ContentDocumentLink Where LinkedEntityId =: caseId]) {
                contentDocumentLinkId.add(contentDocumentLinkRecord.ContentDocumentId);
            }
            List<ContentDocument> contentDocumentList = new List<ContentDocument>();
            if(!contentDocumentLinkId.isEmpty()) {
                contentDocumentList = [SELECT Id FROM ContentDocument WHERE Id IN : contentDocumentLinkId];
            }
            if(contentDocumentList.size() > 0){
                delete contentDocumentList;
            }
            delete newCase;
            return true;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<CaseDto> getCaseDto(string caseId) {

        System.debug('getCaseList ' + caseId);
        
        Boolean isEdit = editSupportRequest(caseId);

        List<CaseDto> caseDtos = new List<CaseDto>();
        for (Case c : [
                SELECT Id, Status, Account.Name, CaseNumber, Case_Owner__c, GA_ASR__r.Name, Subject,
                        Description, Origin, GA_WorkOrderCategory__c, GA_SupportRequest_Type__c,
                        CreatedBy.Name, LastModifiedBy.Name, AccountId, CreatedDate, LastModifiedDate,
                        GA_AgentName__r.Name, GA_AgentName__c, GroupSegments__c,External_Status__c,
                        CreatedById, FSA_Delegated_Agent__c
                FROM Case
                WHERE Id = :caseId
        ]) {
            caseDtos.add(new CaseDto(c.Id, c.Status, c.Account.Name, c.CaseNumber, c.Case_Owner__c,
                    c.GA_ASR__r.Name, c.Subject, c.Description, c.Origin,
                    c.GA_WorkOrderCategory__c, c.GA_SupportRequest_Type__c,
                    c.CreatedBy.Name, c.LastModifiedBy.Name, c.AccountId, c.CreatedDate,
                    c.LastModifiedDate, c.GA_AgentName__r.Name, c.GA_AgentName__c,
                    c.GroupSegments__c, c.External_Status__c, c.CreatedById,
                    c.FSA_Delegated_Agent__c, isEdit));
        }

        System.debug(caseDtos);
        return caseDtos;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean isCurrentUserDelegate() {
        //Need to change the logic as per the new requirement
        System.debug('isCurrentUserDelegate ' + UserInfo.getUserId());
        Boolean isCurrentUserManagingAgent = isCurrentUserManagingAgent();
        id currentUserid = UserInfo.getUserId();
        //List<Account_Team_Interface__c> agentDelegateRelation = [SELECT Id FROM Account_Team_Interface__c WHERE Status__C = 'Active' AND Team_Member__c = :currentUserid];
        Id agentContactId = [SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId()].ContactId;
        //Id delegateAgentRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: System.label.Contact_Delegate_Agent_Record_Type].Id;
        List<String> delegatetype=System.label.Contact_Delegated_Agent.split('\\|');

        List<Contact> delegateAgentRecords = [SELECT Id, vlocity_ins__Type__c FROM Contact WHERE Id =: agentContactId AND vlocity_ins__Type__c IN: delegatetype];
        system.debug('delegateAgentRecords :' +delegateAgentRecords);
        system.debug('delegateAgentRecords Size :' +delegateAgentRecords.size());
        
        if (delegateAgentRecords.size() > 0 && !isCurrentUserManagingAgent) {
            return true;
        }
        else{
            return false;
        }
        
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean isCurrentUserManagingAgent() {
        id currentUserid = UserInfo.getProfileId();
    String managringAgentProfileName = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId() LIMIT 1].Name;
         if (managringAgentProfileName == System.label.User_Profile_Name_MAUser || managringAgentProfileName == System.label.User_Profile_Name_MAcommunityLogin) {
            return true;
        }
        else{
          return false;
        }
    }


    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getAgents(Id accountId) {
        System.debug('GetAgents AccountId:' + accountId);
         List<Account> accounts = [SELECT Id, Name,recordtype.name FROM Account WHERE Id = :accountId LIMIT 1];
            List<OptionWrapper> objWrapper = new List<OptionWrapper>();
         if (!accounts.isEmpty()&& accounts[0].recordtype.name == System.Label.GA_ProspectRecType){
             List<User> users = [SELECT Contact.Id,Contact.name, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
             objWrapper.add(new OptionWrapper(users[0].Contact.Name, users[0].Contact.Id));
             
         }else{ 

            List<GA_AOR__c> listOfAORs = [
                    SELECT Id, GA_Contact_Id__r.name, GA_Contact_Id__c, GA_Contact_Id__r.Agent_Code__c
                    FROM GA_AOR__c
                    WHERE GA_Service_Start_Date__c <= TODAY and GA_Service_End_Date__c >= TODAY and GA_Account_Id__c = :accountId
            ];

            List<Agent> agents = new List<Agent>();

            for (GA_AOR__C aor : listOfAORs) {
                agents.add(new Agent(aor.GA_Contact_Id__c, aor.GA_Contact_Id__r.Agent_Code__c, aor.GA_Contact_Id__r.name));
            }

            for (Agent agent : agents) {
                if ((isDuplicates(agent.Name, agents)) && (agent.AgentCode != null)) {
                    objWrapper.add(new OptionWrapper(agent.Name + ' (' + agent.AgentCode + ')', agent.Id));
                } else {
                    objWrapper.add(new OptionWrapper(agent.Name, agent.Id));
                }
            }
         }
        System.debug('GetAgents return value ' + objWrapper);
        return objWrapper;
    }
  
    private static Boolean isDuplicates(string agentName, list<Agent> agentList) {
        integer count = 0;
        for (Agent agent : agentList) {
            if (agent.Name == agentName) {
                count++;
            }
        }
        if (count > 1) return true; else return false;
    }
  
   @TestVisible private static Case createCase(string caseStatus, string accountName, string agentName, string supportRequestType, string subject, string description, string allGroupSegment, Case newCase) {

        // Temp hack until I change the JS File
        Id agentId = Id.valueOf(agentName);
        Id accountId = Id.valueOf(accountName);
       
       system.debug('+++++++111111'+agentId);
       system.debug('+++++++222222'+accountId);

        List<Account> accounts = [SELECT Id, Name,recordtype.name FROM Account WHERE Id = :accountId LIMIT 1];
      system.debug('+++++++'+accounts.size());
        if (accounts.isEmpty()) {
            throw new AuraHandledException('Account name not found');
        }else if(accounts[0].recordtype.name == System.Label.GA_ProspectRecType && supportRequestType !=System.Label.MA_Agent_Prospect_Support_Request_Type){
             throw new AuraHandledException('User allowed to create Account Reinstatement type Support request for Prospects Accounts');
        } else {  
            newCase.AccountId = accounts[0].id;

            if (!isCurrentUserDelegate() && !isCurrentUserManagingAgent()) {
                List<User> users = [SELECT Contact.Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
               system.debug('contacts size'+ users[0].Contact.Id);
                system.debug('users size'+ users.size());
                List<Contact> contacts = [SELECT Id, Account.Name, AccountId, Name FROM Contact WHERE Id = :users[0].Contact.Id LIMIT 1];
               system.debug('contacts size'+ contacts.size());
                
                if (contacts.isEmpty()) throw new AuraHandledException('Agent name not found');

                System.debug('Contact No DA :' + contacts[0].Name);
                
                newCase.GA_AgentName__c = contacts[0].Id;
                newCase.Submitter__c = accounts[0].Name;
                newCase.Status = caseStatus;
                newCase.GA_SupportRequest_Type__c = supportRequestType;
                newCase.Subject = subject;
                newCase.Description = description;
                newCase.Agency_Name__c = contacts[0].AccountId;
                newCase.submitter__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
                newCase.GroupSegments__c = allGroupSegment;
                if (caseStatus == 'Submitted') {
                    newCase.GA_Support_Submitted_Date__c = Datetime.now();
                }
                return newCase;

            } 
            else if (isCurrentUserManagingAgent()) {
                // If a Managing agent is submitting the request, the Contact ID Is the agent who got the case assigned
                // Set the Managing_Agent__c  to current user
                newCase.Managing_Agent__c  = UserInfo.getUserId();

                List<Contact> contacts = [SELECT Id,Account.Name, AccountId, Name FROM Contact WHERE Id = :agentId LIMIT 1];
                if (contacts.isEmpty()) throw new AuraHandledException('Agent name not found');

                System.debug('Contact DA :' + contacts[0].Name);
                newCase.GA_AgentName__c = contacts[0].Id;
                newCase.Submitter__c = accounts[0].Name;
                newCase.Status = caseStatus;
                newCase.GA_SupportRequest_Type__c = supportRequestType;
                newCase.Agency_Name__c = contacts[0].AccountId;
                newCase.Subject = subject;
                newCase.Description = description;
                newCase.submitter__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
                newCase.GroupSegments__c = allGroupSegment;
                if (caseStatus == 'Submitted') {
                    newCase.GA_Support_Submitted_Date__c = Datetime.now();
                }
                return newCase;
            }
            else {
                // If a delegate agent is submitting the request, the Contact ID Is the agent who got the case assigned
                // Set the FSA_Delegated_Agent__c to current user
                newCase.FSA_Delegated_Agent__c = UserInfo.getUserId();

                List<Contact> contacts = [SELECT Id,Account.Name, AccountId, Name FROM Contact WHERE Id = :agentId LIMIT 1];
                if (contacts.isEmpty()) throw new AuraHandledException('Agent name not found');

                System.debug('Contact DA :' + contacts[0].Name);
                newCase.GA_AgentName__c = contacts[0].Id;
                newCase.Submitter__c = accounts[0].Name;
                newCase.Status = caseStatus;
                newCase.GA_SupportRequest_Type__c = supportRequestType;
                newCase.Agency_Name__c = contacts[0].AccountId;
                newCase.Subject = subject;
                newCase.Description = description;
                newCase.submitter__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
                newCase.GroupSegments__c = allGroupSegment;
                if (caseStatus == 'Submitted') {
                    newCase.GA_Support_Submitted_Date__c = Datetime.now();
                }
                return newCase;
            }
        }
    }


    @AuraEnabled
    public static string submitNewRequest(string caseStatus, string accountName, string agentName, string supportRequestType, string subject, string description, string groupSegment) {

        String allGroupSegment;
        if (groupSegment == null) {
            allGroupSegment = '';
        } else {
            List<string> groupSegmentIds = (List<string>) JSON.deserialize(groupSegment, List<string>.class);
            allGroupSegment = String.join(groupSegmentIds, ',');
        }

        System.debug('New Case Creation Status:' + caseStatus + ' AccountId:' + accountName + ' Agent Id:' + agentName);

        Case newCase = createCase(caseStatus, accountName, agentName, supportRequestType, subject, description, allGroupSegment, new Case());

        try {
            insert newCase;
            return newCase.Id;

        } catch (DmlException e) {
            System.debug(e.getMessage());
            throw new AuraHandledException('Error Saving ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static string updateSubmitRequest(string caseId, string caseStatus, string accountName, string agentName, string supportRequestType, string subject, string description, String groupSegment) {
        System.debug('Update Case Status: ' + caseStatus + ' AccountId:' + accountName + ' Agent Id:' + agentName + ' Case Id:' + caseId);

        List<string> groupSegmentIds = (List<string>) JSON.deserialize(groupSegment, List<string>.class);
        String allGroupSegment = String.join(groupSegmentIds, ',');

        Case existingCase = [SELECT Id FROM Case WHERE Id = :caseId LIMIT 1];

        existingCase = createCase(caseStatus, accountName, agentName, supportRequestType, subject, description, allGroupSegment, existingCase);

        update existingCase;
        return existingCase.Id;
    }

    @AuraEnabled
    public static string changeCaseStatus(string caseId, string status) {
        System.debug('changeCaseStatus ' + ' ' + caseId + ':' + status);

        Case existingCase = [SELECT Id FROM Case WHERE Id = :caseId LIMIT 1];
        existingCase.Status = status;

        update existingCase;
        return existingCase.Id;
    }


    @AuraEnabled(cacheable=true)
    public static String agentContactUserId(string caseId) {
        Id agentContactId = [SELECT Id, GA_AgentName__c FROM Case WHERE Id = :caseId LIMIT 1].GA_AgentName__c;
        Id agentUserId = [SELECT Id FROM User WHERE ContactId = :agentContactId LIMIT 1].Id;
        return agentUserId;
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean agentContactUser(string caseId) {
        Id agentContactId = [SELECT Id, GA_AgentName__c FROM Case WHERE Id = :caseId LIMIT 1].GA_AgentName__c;
        User agentUser = [SELECT Id FROM User WHERE ContactId =: agentContactId LIMIT 1];
        if(agentUser.Id != null && agentUser.Id == UserInfo.getUserId()){
            return true;
        }else{
            return false;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Boolean agentDelegateDetails(string caseId) {
        Id agentContactId = [SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId()].ContactId;
        Id agencyId = [SELECT Id, Agency_Name__c  FROM Case WHERE Id = :caseId LIMIT 1].Agency_Name__c;
        List<String> delegatetype=System.label.Contact_Delegated_Agent.split('\\|');
        //Id delegateAgentRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: System.label.Contact_Delegate_Agent_Record_Type].Id;
        List<Contact> delegateAgentRecords = [SELECT Id, vlocity_ins__Type__c FROM Contact WHERE Id =: agentContactId AND AccountId =: agencyId AND vlocity_ins__Type__c IN: delegatetype];
        system.debug('delegateAgentRecords :' +delegateAgentRecords);
        system.debug('delegateAgentRecords Size :' +delegateAgentRecords.size());

        if (delegateAgentRecords.size() > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean isAORActive(string caseId) {
        Id agentContactId = [SELECT Id, GA_AgentName__c FROM Case WHERE Id = :caseId LIMIT 1].GA_AgentName__c;
        Boolean isActive;
        if(agentContactId != null){
            isActive = [SELECT Id, GA_Agent_Active__c FROM GA_AOR__c WHERE GA_Contact_Id__c =: agentContactId LIMIT 1].GA_Agent_Active__c;
        }
        if(isActive != null){
            return isActive;
        }
        else{
            return false;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean editSupportRequest(string caseId) {
        Boolean isAORActive;
        Id userId = userInfo.getUserId();
        List<CaseShare> caseShareList = [SELECT CaseId, RowCause, CaseAccessLevel 
                                         FROM CaseShare 
                                         WHERE UserorGroupId =:userId AND CaseId =: caseId 
                                         AND (RowCause = 'Manual' OR RowCause = 'Owner' or RowCause = 'ImplicitChild') 
                                         LIMIT 1];
        if(caseShareList.size() > 0){
            if(caseShareList[0].CaseAccessLevel == 'All' || caseShareList[0].CaseAccessLevel == 'Edit'){   
              return true;
          }
            else{
              return false;
          }
        }
        else{
            return false;
        }
        
         
    }
    
    public static Boolean isCurrentAgentDelegate() {
        System.debug('isCurrentAgentDelegate ' + UserInfo.getUserId());
        Id currentUserid = UserInfo.getUserId();
        List<Account_Team_Interface__c> agentDelegateRelation = [SELECT Id FROM Account_Team_Interface__c WHERE Status__C = 'Active' AND Team_Member__c = :currentUserid];
        if (agentDelegateRelation.size() > 0) {
            return true;
        }
        else{
            return false;
        }
        
    }

    @AuraEnabled(cacheable=true)
    public static List<ReportDto> getReportList(String maCommunity) {
    
    System.debug('*******maCommunity***********'+maCommunity);

        List<ReportDto> objWrapper = new List<ReportDto>();

        for (Report r : [SELECT Id,Name, Description FROM Report WHERE FolderName = 'Agent Reports']) {

            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            string reportLink ='';
            if(maCommunity != null && maCommunity.contains('MACommunity')){            
                reportLink = sfdcBaseURL + '/MACommunity/s/report/' + r.Id + '/agent-support-requests-report?queryScope=userFolders';
            }else{
                 reportLink = sfdcBaseURL + '/bcbsmquoting/s/report/' + r.Id + '/agent-support-requests-report?queryScope=userFolders';
            }

            objWrapper.add(new ReportDto(r.Name, r.Description, reportLink));
        }
        return objWrapper;
    }
}