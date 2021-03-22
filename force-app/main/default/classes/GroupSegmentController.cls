public class GroupSegmentController {
    
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
    
    // Return a list of records that match the given criteria in a LIKE condition, remove values passed in the selectedGroupSegments
    @AuraEnabled(cacheable=true)
    public static List<LookupSearchResult> getGroupListForSearch(string searchTerm, List<string> selectedIds) {
        Set<String> mtvGroupAndFacetGroup = new Set<String>();
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        List<GA_Group_Segment__c> groupSegmentList = new List<GA_Group_Segment__c>();
        List<GA_Group_Segment__c> uniqueGroupSegmentList = new List<GA_Group_Segment__c>();
        List<List<SObject>> searchResults = new List<List<SObject>>();
        List<GA_Group_Segment__c> selectedGroupSegmentList = new List<GA_Group_Segment__c>();
        
        if (selectedIds != null && selectedIds.size() > 0) {
            searchResults = [
                FIND :searchTerm
                IN ALL FIELDS
                RETURNING
                GA_Group_Segment__c(Id, GA_Account__c, GA_Account__r.Name, Name, GA_Facets_Group_ID__c, GA_MTV_Group__c WHERE id NOT IN :selectedIds and status__c = 'Active')
                LIMIT 5
            ];
            selectedGroupSegmentList = [
                SELECT Id,GA_Account__c,GA_Account__r.Name, GA_Facets_Group_ID__c,GA_MTV_Group__c
                FROM GA_Group_Segment__c
                WHERE Id In:selectedIds and status__c = 'Active'
            ];
        } else {
            searchResults = [
                FIND :searchTerm
                IN ALL FIELDS
                RETURNING
                GA_Group_Segment__c(Id, GA_Account__c, GA_Account__r.Name, Name, GA_Facets_Group_ID__c, GA_MTV_Group__c where status__c = 'Active')
                LIMIT 5
            ];
        }
        
        if (searchResults.size() > 0) {
            System.debug(searchResults);
            groupSegmentList = searchResults[0];
        }
        
        if (groupSegmentList.size() > 0) {
            for (GA_Group_Segment__c gs : groupSegmentList) {
                if (gs.GA_Facets_Group_ID__c != null && mtvGroupAndFacetGroup.contains(gs.GA_Facets_Group_ID__c) == false){
                    mtvGroupAndFacetGroup.add(gs.GA_Facets_Group_ID__c);
                    uniqueGroupSegmentList.add(gs);
                } 
                else if (gs.GA_MTV_Group__c != null && mtvGroupAndFacetGroup.contains(gs.GA_MTV_Group__c) == false){
                    mtvGroupAndFacetGroup.add(gs.GA_MTV_Group__c);
                    uniqueGroupSegmentList.add(gs);
                } 
                
            }
            if(uniqueGroupSegmentList.size()>0){
                for (GA_Group_Segment__c gd : uniqueGroupSegmentList) {
                    if (selectedIds == null || selectedIds.contains(String.valueOf(gd.Id)) == false) {
                        String groupTitle;
                        If (gd.GA_Facets_Group_ID__c != null) groupTitle = gd.GA_Facets_Group_ID__c; else if (gd.GA_MTV_Group__c != null) groupTitle = gd.GA_MTV_Group__c; else groupTitle = 'No Matching Value';
                        
                        LookupSearchResult searchResult;
                        if (selectedGroupSegmentList.size() > 0) {
                            if (selectedGroupSegmentList[0].GA_Account__c == gd.GA_Account__c) {
                                searchResult = new LookupSearchResult(
                                    gd.Id,
                                    'GA_Group_Segment__c',
                                    'standard:account',
                                    groupTitle,
                                    gd.GA_Account__r.Name
                                );
                            }
                        } else {
                            searchResult = new LookupSearchResult(
                                gd.Id,
                                'GA_Group_Segment__c',
                                'standard:account',
                                groupTitle,
                                gd.GA_Account__r.Name
                            );
                        }
                        
                        results.add(searchResult);
                    }
                }
            }
            results.sort();
        }
        System.debug('Results :' + results);
        return results;
    }
    
    
    // return a list of group segments for a given account Id
    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getGroupList(Id accountId) {
        System.debug('Get Group List Account Id: ' + accountId);
        Set<String> mtvGroup = new Set<String>();
        Set<String> facetGroup = new Set<String>();
        List<OptionWrapper> optionWrappers = new List<OptionWrapper>();
        if(accountId == null) return optionWrappers;
        
        List<GA_Group_Segment__c> groupSegmentList = [
            select Id,GA_Account__c,GA_Facets_Group_ID__c,GA_MTV_Group__c, GA_Account__r.Name
            FROM GA_Group_Segment__c
            WHERE GA_Account__c = :accountId and status__c='Active'
        ];
        
        System.debug(groupSegmentList);
        for (GA_Group_Segment__c g : groupSegmentList) {
            if(g.GA_MTV_Group__c != null){
                if(mtvGroup.contains(g.GA_MTV_Group__c) == false)
                {
                    optionWrappers.add(new OptionWrapper(g.GA_MTV_Group__c, g.GA_MTV_Group__c)); 
                    mtvGroup.add(g.GA_MTV_Group__c);
                }
                
            }
            if(g.GA_Facets_Group_ID__c != null) {
                if(facetGroup.contains(g.GA_Facets_Group_ID__c) == false)
                {
                    optionWrappers.add(new OptionWrapper(g.GA_Facets_Group_ID__c, g.GA_Facets_Group_ID__c));
                    facetGroup.add(g.GA_Facets_Group_ID__c);
                }
            }
        }
        System.debug('Get Group List Reply :' + optionWrappers);
        return optionWrappers;
    }
    
    public class AccountDto {
        public AccountDto(string id, string name) {
            this.Id = id;
            this.Name = name;
            
        }
        @AuraEnabled
        public string Id { get; set; }
        @AuraEnabled
        public string Name { get; set; }
        
    }
    
    @AuraEnabled(cacheable=true)
    public static AccountDto getAccountId(string groupSegmentId) {
        System.debug(groupSegmentId);
        List<GA_Group_Segment__c> groupSegmentList = [SELECT Id,GA_Account__r.Id,GA_Account__r.Name
                                                      FROM GA_Group_Segment__c
                                                      WHERE Id = :groupSegmentId];
        
        if(groupSegmentList.size() > 0)
            return new GroupSegmentController.AccountDto(groupSegmentList[0].GA_Account__r.Id, groupSegmentList[0].GA_Account__r.Name);
        return null;
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds) {
        // Prepare query paramters
        searchTerm += '*';
        List<List<SObject>> searchResults = new List<List<SObject>>();
          Id curentUserContactId = [SELECT Id, ContactId FROM User where Id =: UserInfo.getUserId()].ContactId;
        String currentUserprofile = UserInfo.getProfileId();
        Boolean isManagingAgent = false;
        for(Profile profileRec: [SELECT Id FROM profile WHERE Name =: System.label.User_Profile_Name_MAUser OR Name =:System.label.User_Profile_Name_MAcommunityLogin]){
            if(profileRec.Id == currentUserprofile ){
                isManagingAgent = true;
            }
        }
        
        // Execute search query
        if(selectedIds != null && selectedIds.size()>0)
        {
            if(isManagingAgent){
                searchResults = [
                    FIND :searchTerm
                    IN ALL FIELDS
                    RETURNING
                    Account(Id, Name WHERE id NOT IN :selectedIds AND RecordType.Name in( 'Account - Customer','Account - Prospect'))
                    LIMIT 5
                ];
            }else{
                searchResults = [
                    FIND :searchTerm
                    IN ALL FIELDS
                    RETURNING
                    Account(Id, Name WHERE id NOT IN :selectedIds AND RecordType.Name = 'Account - Customer')
                    LIMIT 5
                ];
            }
        }else{
            if(isManagingAgent){
                searchResults = [
                    FIND :searchTerm
                    IN ALL FIELDS
                    RETURNING
                    Account(Id, Name WHERE  RecordType.Name in( 'Account - Customer','Account - Prospect'))
                    LIMIT 5
                ];
            }else{
                searchResults = [
                    FIND :searchTerm
                    IN ALL FIELDS
                    RETURNING
                    Account(Id, Name WHERE  RecordType.Name = 'Account - Customer')
                    LIMIT 5
                ];
            }
        }
      
        List<GA_AOR__c> listOfAORs = [
                SELECT Id,GA_Account_Id__c, GA_Contact_Id__r.name, GA_Contact_Id__c, GA_Contact_Id__r.Agent_Code__c
                FROM GA_AOR__c
                WHERE GA_Service_Start_Date__c <= TODAY and GA_Service_End_Date__c >= TODAY AND GA_Contact_Id__c =: curentUserContactId];
        
        Set<Id> accountIdActiveForAor = new Set<Id>();
        Boolean isCurrentUserDelegate = isCurrentUserDelegate();
        for(GA_AOR__c aor: [SELECT GA_Account_Id__c
                            FROM GA_AOR__c
                            WHERE GA_Service_Start_Date__c <= TODAY and GA_Service_End_Date__c >= TODAY 
                            AND GA_Contact_Id__c =: curentUserContactId]){
          accountIdActiveForAor.add(aor.GA_Account_Id__c);          
        }
        // Prepare results
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        
        // Extract Accounts & convert them into LookupSearchResult
        String accountIcon = 'standard:account';
        Account[] accounts = (List<Account>) searchResults[0];
        for (Account account : accounts) {
            if((accountIdActiveForAor.contains(account.Id) || isCurrentUserDelegate) && isManagingAgent){
                results.add(
                    new LookupSearchResult(
                        account.Id,
                        'Account',
                        accountIcon,
                        account.Name,
                        'Account • ' + account.Name
                    )
                );
            }
            else{
                results.add(
                    new LookupSearchResult(
                        account.Id,
                        'Account',
                        accountIcon,
                        account.Name,
                        'Account • ' + account.Name
                    )
                );
            }
        }
        results.sort();
        System.debug('Search Results ' + JSON.serializePretty(results));
        return results;
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean isCurrentUserDelegate() {
        //Need to change the logic as per the new requirement
        System.debug('isCurrentUserDelegate ' + UserInfo.getUserId());
        id currentUserid = UserInfo.getUserId();
        //List<Account_Team_Interface__c> agentDelegateRelation = [SELECT Id FROM Account_Team_Interface__c WHERE Status__C = 'Active' AND Team_Member__c = :currentUserid];
        Id agentContactId = [SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId()].ContactId;
        //Id delegateAgentRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: System.label.Contact_Delegate_Agent_Record_Type].Id;
            List<String>  delegatecontacttype= System.label.Contact_Delegated_Agent.split('\\|');
        List<Contact> delegateAgentRecords = [SELECT Id, vlocity_ins__Type__c FROM Contact WHERE Id =: agentContactId  ];
       
        if (delegateAgentRecords!=null && delegateAgentRecords.size() > 0 && delegatecontacttype.contains(delegateAgentRecords[0].vlocity_ins__Type__c) ) {
            return true;
        }
        return false;
    }
}