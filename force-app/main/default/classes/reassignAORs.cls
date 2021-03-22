public without sharing class reassignAORs {
    @AuraEnabled
    public static String getAORsforContact(String contactId){
        Set<Id> aorGroupSegmentIds = new Set<Id>();
        Map<String,AOR_Reassign__c> aorRessignMapByGroupSegment = new Map<String,AOR_Reassign__c>();
        List< GA_AOR__c > AorRelatedToContact = [select Id, GA_Account_Id__c ,GA_Account_Id__r.Name, GA_Contact_Id__c ,GA_Contact_Id__r.Name, Name,
                                                    (Select Id, Name,Processed__c, GA_AOR_Id__r.GA_Account_Id__c, GA_Commission_Start_Date__c,GA_Service_Start_Date__c  from AOR_Group_Segments__r where GA_Status__c ='Active')    
                                                from 
                                                    GA_AOR__c
                                                Where 
                                                    GA_Contact_Id__c  =: contactId ORDER BY GA_Account_Id__r.Name];
        
        for(GA_AOR__c aor : AorRelatedToContact){
            for(GA_AOR_Group_Segment__c aorGS : aor.AOR_Group_Segments__r){
                aorGroupSegmentIds.add(aorGS.Id);
            }
        }
        System.debug('---aorGroupSegmentIds---'+aorGroupSegmentIds.size());
        for(AOR_Reassign__c aorReassign : [select id, Processed__c , AOR_Group_Segment__c   
                                           from AOR_Reassign__c where AOR_Group_Segment__c  IN : aorGroupSegmentIds ])
        {
            aorRessignMapByGroupSegment.put(aorReassign.AOR_Group_Segment__c,aorReassign);
        }
        System.debug('---aorRessignMapByGroupSegment---'+aorRessignMapByGroupSegment.size());
        
        List<wrapper> wrapperList = new List<wrapper>();                                            
        if(AorRelatedToContact != null && !AorRelatedToContact.isEmpty()){
            for(GA_AOR__c aor : AorRelatedToContact){
                for(GA_AOR_Group_Segment__c aorGS : aor.AOR_Group_Segments__r){
                    System.debug('---aorGS---'+aorGS);
                    
                    
                    wrapper wrapperObj = new wrapper();
                    wrapperObj.AccountId = aorGS.GA_AOR_Id__r.GA_Account_Id__c;
                    if(aorRessignMapByGroupSegment.containskey(aorGS.Id)){
                        AOR_Reassign__c tempReassign = aorRessignMapByGroupSegment.get(aorGS.Id);
                        wrapperObj.isProcessed = tempReassign.Processed__c;
                        wrapperObj.AORReassignId = tempReassign.Id;
                        wrapperObj.AORExist = 'Yes';
                    }else{
                        wrapperObj.isProcessed = false;
                        wrapperObj.AORExist = 'No';
                    }  
                    //wrapperObj.isProcessed = aorGS.Processed__c != null && aorGS.Processed__c == true? true : false;
                    wrapperObj.AccountName = aor.GA_Account_Id__r.Name;
                    wrapperObj.AORId = aorGS.GA_AOR_Id__c;
                    wrapperObj.fromContactId = aor.GA_Contact_Id__c;
                    wrapperObj.AORGroupSegmentId = aorGS.Id;
                    wrapperObj.AORName = aor.Name;
                    wrapperObj.AORGroupSegmentName = aorGS.Name;
                    wrapperObj.FromContactName = aor.GA_Contact_Id__r.Name;
                    wrapperObj.isCommisioningAgent = aorGS.GA_Commission_Start_Date__c != null ? true : false;
                    wrapperObj.isServicingAgent = aorGS.GA_Service_Start_Date__c != null ? true : false;
                    if(!wrapperObj.isProcessed){
                        wrapperList.add(wrapperObj); 
                    }                       
                }
            }
            
            //List<AOR_Reassign__c> aorAssignList = [SELECT Id,  AOR_Group_Segment__c FROM AOR_Reassign__c WHERE AOR_Group_Segment__c IN: aorGroupSegmentIds];
            
            //system.debug('--aorAssignList---'+aorAssignList);
        }
        System.debug('wrapperlist----->'+wrapperList);
        return JSON.serialize(wrapperList);
    }
    
    public class wrapper{
        public Id AccountId;
        public Id AORId;
        public Id AORReassignId;
        public Id fromContactId;
        public Id AORGroupSegmentId;
        public String FromContactName;
        public String AccountName;
        public String AORName;
        public String AORGroupSegmentName;
        public Boolean isCommisioningAgent;
        public Boolean isServicingAgent;
        public Boolean isProcessed;
        public String AORExist;
    }
    
    @AuraEnabled
    public static String createAorReassignRecords(String toContactIdVal, String serviceStartDate, String commisionStartDate, String aorRecs){
        List<wrapper> wrapperList =  (List<wrapper>)System.JSON.deserialize(aorRecs, List<wrapper>.class);
        Set<Id> aorGroupSegIds = new Set<Id>();
        system.debug('wrapperList ---->'+JSON.serializepretty(wrapperList));
        if(wrapperList != null && !wrapperList.isEmpty()){
            List< AOR_Reassign__c > NewAorReassignRecordsList = new List< AOR_Reassign__c >();
            for(wrapper wrap : wrapperList){
                AOR_Reassign__c aor = new AOR_Reassign__c ();
                if(wrap.AORReassignId != null){
                  aor.Id = wrap.AORReassignId;  
                }
                aor.AOR__c = wrap.AORId;
                aor.AOR_Group_Segment__c = wrap.AORGroupSegmentId;
                aor.AccountId__c  = wrap.AccountId; 
                aor.To_Contact__c  = toContactIdVal;
                aor.Commissioning_Agent__c   = wrap.isCommisioningAgent; 
                aor.Servicing_Agent__c  = wrap.isServicingAgent;
                aor.Service_Start_Date__c   = serviceStartDate != null ? date.valueOf(serviceStartDate) : null;
                aor.Commission_Start_Date__c   = commisionStartDate != null?  date.valueOf(commisionStartDate) : null;
                NewAorReassignRecordsList.add(aor);
                aorGroupSegIds.add(wrap.AORGroupSegmentId);
            }
            List<Id> successAorReassignIds = new  List<Id>();
            List< GA_AOR_Group_Segment__c > gsToUpdate = new List< GA_AOR_Group_Segment__c >();
            if(NewAorReassignRecordsList != null && !NewAorReassignRecordsList.isEmpty()){
                try{
                    //Insert NewAorReassignRecordsList;
                    Database.UpsertResult[] saveresult    =   Database.upsert(NewAorReassignRecordsList, true);
                    for (Database.UpsertResult resultRecord : saveresult) {
                        if (resultRecord.isSuccess()) {
                            system.debug('Success');
                            successAorReassignIds.add( resultRecord.getId());
                        }
                        else {
                            for(Database.Error errorRecord : resultRecord.getErrors()) {
                                system.debug('Error- '+errorRecord.getMessage());
                            }
                        }
                    }
                    
                    if(successAorReassignIds != null && !successAorReassignIds.isEmpty()){
                        for(Wrapper wrapObj : wrapperList){
                            GA_AOR_Group_Segment__c  GS = new GA_AOR_Group_Segment__c(Id = wrapObj.AORGroupSegmentId,Processed__c = true);
                            gsToUpdate.add(GS);
                        }
                        if(gsToUpdate != null && !gsToUpdate.isEmpty()){
                            Database.SaveResult[] saveresultGS    =   Database.update(gsToUpdate, true);
                        }
                    }
                } Catch(dmlException e){
                    system.debug('Exception Occured --'+e.getMessage());
                }
            }
        }
        return null;
    }
    
}