public with sharing class FsaListViewController {
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
        public DateTime submittedDate { get; set; }
        @AuraEnabled
        public string ExternalStatus { get; set; }
        
        public CaseDto(Id id, string status, string accountName, string caseNumber, string caseOwner, string asrName, string subject, string description, string origin, string workOrderCategory,
                       string supportRequestType, string createdBy, string lastModifiedBy, Id accountId, DateTime createdDate, Datetime lastModifiedDate, String gaAgentName, Id gaAgentNameId, Datetime submittedDate, String externalStatus) {
                           this.Id = id;
                           
                           if(status == 'Waiting on Internal Response'){
                           		this.Status = 'In Progress';
                           }
                           else{
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
                           this.submittedDate = submittedDate;
                           this.ExternalStatus = externalStatus;
                       }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<CaseDto> getCaseDtoList() {
        List<Case> caseList = [SELECT Id, CaseNumber, OwnerId, Subject, Status, Description, 
                               AccountId, Account.Name, GA_ASR__c, GA_ASR__r.Name, GA_SupportRequest_Type__c, 
                               GA_Support_Submitted_Date__c, Owner.Name, Origin, GA_WorkOrderCategory__c, Created_By__c,
                               LastModifiedBy.Name, LastModifiedDate, CreatedDate, GA_AgentName__r.Name, GA_AgentName__c,External_Status__c
                               FROM Case 
                               LIMIT 1000];
        List<CaseDto> caseDtos = new List<CaseDto>();
        // for (Integer i = 0; i < 100; i++) {
        for(Case caseRecord: caseList){
            caseDtos.add(new CaseDto(caseRecord.Id, caseRecord.Status, caseRecord.Account.Name, caseRecord.CaseNumber, caseRecord.Owner.Name, caseRecord.GA_ASR__r.Name, caseRecord.Subject, caseRecord.Description, caseRecord.Origin, caseRecord.GA_WorkOrderCategory__c, caseRecord.GA_SupportRequest_Type__c, caseRecord.Created_By__c, caseRecord.LastModifiedBy.Name, caseRecord.AccountId, caseRecord.LastModifiedDate, caseRecord.CreatedDate, caseRecord.GA_AgentName__r.Name, caseRecord.GA_AgentName__c, caseRecord.GA_Support_Submitted_Date__c, caseRecord.External_Status__c ));
        }
        return caseDtos;
    }
    @AuraEnabled(cacheable=true)
    public static List<CaseDto> getCaseList(String listName) {
        Id userId = UserInfo.getUserId();
        List<Case> caseList = new List<Case>();
        if(listName == 'MySupportRequest'){
            caseList = [SELECT Id, CaseNumber, OwnerId, Subject, Status, Description, 
                        AccountId, Account.Name, GA_ASR__c, GA_ASR__r.Name, GA_SupportRequest_Type__c, 
                        GA_Support_Submitted_Date__c, Owner.Name, Origin, GA_WorkOrderCategory__c, Created_By__c,
                        LastModifiedBy.Name, LastModifiedDate, CreatedDate, GA_AgentName__r.Name, GA_AgentName__c, External_Status__c
                        FROM Case
                        WHERE CreatedById =: userId
                        ORDER BY CreatedDate DESC 
                        LIMIT 1000];
        }
        else if(listName == 'AllSupportRequest'){
            caseList = [SELECT Id, CaseNumber, OwnerId, Subject, Status, Description, 
                        AccountId, Account.Name, GA_ASR__c, GA_ASR__r.Name, GA_SupportRequest_Type__c, 
                        GA_Support_Submitted_Date__c, Owner.Name, Origin, GA_WorkOrderCategory__c, Created_By__c,
                        LastModifiedBy.Name, LastModifiedDate, CreatedDate, GA_AgentName__r.Name, GA_AgentName__c, External_Status__c
                        FROM Case
						ORDER BY CreatedDate DESC 
                        LIMIT 1000];
        }
        else if(listName == 'OpenSupportRequest'){
            caseList = [SELECT Id, CaseNumber, OwnerId, Subject, Status, Description, 
                        AccountId, Account.Name, GA_ASR__c, GA_ASR__r.Name, GA_SupportRequest_Type__c, 
                        GA_Support_Submitted_Date__c, Owner.Name, Origin, GA_WorkOrderCategory__c, Created_By__c,
                        LastModifiedBy.Name, LastModifiedDate, CreatedDate, GA_AgentName__r.Name, GA_AgentName__c, External_Status__c
                        FROM Case
                        WHERE CreatedById =: userId AND Status = 'New'
						ORDER BY CreatedDate DESC 
                        LIMIT 1000];
        }
        
        List<CaseDto> caseDtos = new List<CaseDto>();
        // for (Integer i = 0; i < 100; i++) {
        for(Case caseRecord: caseList){
            caseDtos.add(new CaseDto(caseRecord.Id, caseRecord.Status, caseRecord.Account.Name, caseRecord.CaseNumber, caseRecord.Owner.Name, 
                                     caseRecord.GA_ASR__r.Name, caseRecord.Subject, caseRecord.Description, caseRecord.Origin, caseRecord.GA_WorkOrderCategory__c, 
                                     caseRecord.GA_SupportRequest_Type__c, caseRecord.Created_By__c, caseRecord.LastModifiedBy.Name, caseRecord.AccountId, 
                                     caseRecord.CreatedDate, caseRecord.LastModifiedDate, caseRecord.GA_AgentName__r.Name, caseRecord.GA_AgentName__c, caseRecord.GA_Support_Submitted_Date__c, 
                                     caseRecord.External_Status__c));
        }
        return caseDtos;
    }
}