//Implemented as part of US:252
public class OpportunityTriggerHandler 
{

    public static final string OPPORTUNITY  ='Opportunity';    

    public static final string CLSNAME  ='OpportunityTriggerHandler';
    public static final string METHODNME_AFTRUPDT  ='afterUpdate';    
    public static final string METHODNMEAFTERINSERT  ='afterinsert';
    public static final string OPPORTUNITY_ASC = 'Opportunity_ASC';    

    public static void populateOpporunityNames(List<Opportunity> lstOpty, Map<Id, Opportunity> oldMap)
    {
        Map<Id, Id> mapOptyId_AccId  = new Map<Id, Id>(); 
        List<Account_Plan__c> lstAccAssessmentsForUpdate = new List<Account_Plan__c>();
        for(Opportunity objOpty :  lstOpty)
        {
            if(objOpty.Name != oldMap.get(objOpty.Id).Name && objOpty.AccountId != null)
            {
                mapOptyId_AccId.put(objOpty.Id, objOpty.AccountId); // Opp to Account map
            }
        }
        System.debug('====mapOptyId_AccId===='+mapOptyId_AccId);
        String currentYear = String.valueOf(System.Today().year());
        Map<Id, Account_Plan__c> mapAccId_AccountAssessment = new Map<Id,Account_Plan__c>();
        for(Account_Plan__c objAccAssessment : [SELECT Id, Name, Account__c,Account__r.Name,GA_AccountAssessmentYear__c, Current_Year_Assessment_Opportunities__c FROM Account_Plan__c 
                                                    WHERE Account__c IN : mapOptyId_AccId.values() AND GA_AccountAssessmentYear__c =: currentYear])
        {
            mapAccId_AccountAssessment.put(objAccAssessment.Account__c, objAccAssessment); // Account to account plan map    
        }
        System.debug('====mapAccId_AccountAssessment===='+mapAccId_AccountAssessment);
        for(Opportunity objOpty :  lstOpty)
        {
            Date d = System.Today();
            string dateStr = DateTime.newInstance(d.year(),d.month(),d.day()).format('yyyy-MM-dd');
            if(mapOptyId_AccId.containsKey(objOpty.Id) && mapAccId_AccountAssessment.containsKey(mapOptyId_AccId.get(objOpty.Id)))
            {
                Account_Plan__c objAssessment = mapAccId_AccountAssessment.get(mapOptyId_AccId.get(objOpty.Id));
                System.debug('====objAssessment===='+objAssessment); 
                if(objAssessment.Current_Year_Assessment_Opportunities__c != null)
                {
                    String optyName = objAssessment.Account__r.Name +' - '+dateStr+' - '+objOpty.Type;
                    objAssessment.Current_Year_Assessment_Opportunities__c  =objAssessment.Current_Year_Assessment_Opportunities__c +'\n'+ optyName;               
                }
                else
                {
                    objAssessment.Current_Year_Assessment_Opportunities__c = objOpty.Name;    
                }
                lstAccAssessmentsForUpdate.add(objAssessment);
            }
        }
        System.debug('====lstAccAssessmentsForUpdate===='+lstAccAssessmentsForUpdate);
        if(lstAccAssessmentsForUpdate.size() > 0)
        {
            update lstAccAssessmentsForUpdate;    
        }
    }
    
     /*********************************************************************************************************************************************
    @Description: afterinsert() method 
    @Name : afterinsert
    @Param : list<Quote> quoteList, map<id,Quote> quoteOldMap
    @Return : void
    @throws Exception : N/A;
    **********************************************************************************************************************************************/ 
    public static void afterinsert(List<Opportunity> oppList)
    {
        try
        {    
           /*US-3625 -Added By Dinesh -  after insert - This class is used to create/update the Status History Tracking records when there is an update on
           Contract - Status, Invoice Setup ,Signature Status
           Opportunity - StageName , Sub Stage
           Quote - Status
           Plan - Activation Status*/                   
           Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(OPPORTUNITY_ASC).getRecordTypeId();

           List<Opportunity> newoppList = new List<Opportunity>();
           if(!oppList.isEmpty()){
               for(Opportunity opp:oppList){
                  if(oppRecordTypeId.equals(opp.RecordTypeId)){
                     newoppList.add(opp);
                  }    
               }           
           }

           if(!ASC_StatusHistoryTracking.isExecuting){
           ASC_StatusHistoryTracking.isExecuting = true;
               if(!newoppList.isEmpty()){
                   ASC_StatusHistoryTracking.createUpdateStatusHistoryTracking(newoppList,null,OPPORTUNITY);
               }
           }             
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEAFTERINSERT);}
    } 

    /*********************************************************************************************************************************************
    @Description: afterUpdate() method 
    @Name : afterUpdate
    @Param : list<Quote> quoteList, map<id,Quote> quoteOldMap
    @Return : void
    @throws Exception : N/A;
    **********************************************************************************************************************************************/ 
    public static void afterUpdate(List<Opportunity> oppList, map<id,Opportunity> oppOldMap)
    {
        try{              

           /*US-3625 -Added By Dinesh -  after update - This class is used to create/update the Status History Tracking records when there is an update on
           Contract - Status, Invoice Setup ,Signature Status
           Opportunity - StageName , Sub Stage
           Quote - Status
           Plan - Activation Status*/                   
           Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(OPPORTUNITY_ASC).getRecordTypeId();

           List<Opportunity> newoppList = new List<Opportunity>();
           Map<Id, Opportunity> oldOppMap = new Map<Id, Opportunity>();

           if(!oppList.isEmpty()){
               for(Opportunity opp:oppList){
                  if(oppRecordTypeId.equals(opp.RecordTypeId) 
                     && !opp.ByPassValidation__c){
                     newoppList.add(opp);
                     oldOppMap.put(opp.Id,oppOldMap.get(opp.Id));
                  }    
               }           
           }
           if(!newoppList.isEmpty()){
               ASC_StatusHistoryTracking.createUpdateStatusHistoryTracking(newoppList,oldOppMap,OPPORTUNITY);           
           }
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME_AFTRUPDT);
        }
    }    
              
}