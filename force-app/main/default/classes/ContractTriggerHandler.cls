/**************************************************************************************************
* @Author : Jose Lopez Sanchez
* @Description: Trigger handler for Automatic Opportunity Stage updates, Quote Status updates,
*               and Plan Sold Product updates           
* @Story Number: 1907
*************************************************************************************************/
public class ContractTriggerHandler {
    public static final String ACTIVATEDSTATUS ='Activated';
    public static final String CANCELLEDSTATUS ='Cancelled';
    public static final String DENIEDSTATUS ='Denied';
    public static final String CLOSEWONSTAGE ='Closed - Won';
    public static final String CLOSEREASON ='Relationship with Blue Cross';
    public static final String CLSNAME = 'ContractTriggerHandler';
    public static final String UPDOPPONACTCNTS = 'updateOpportunitiesOnActivatedContracts';
    public static final String UPDQTEONCNCCNTS = 'updateQuotesOnCancelledContracts';
    public static final String UPDPLNSONACTCNTS = 'updatePlansOnActivatedContracts';
    public static final String METHODNMEHISTRACKING = 'createUpdateHistoryTrackingrecords';
    public static final String METHODNMEBASECNTRVALIDATION  = 'ascBaseContractValidation';
    public static final String METHODNMEUPDTOPPSTAGE = 'updateOpportunityStage';
    public static final string ASC_CONTRACT = 'ASC_Contract';
    public static final string CONTRACTOBJNAME = 'Contract';
    public static final string GROUPSIGST = 'Group';
    public static final string STATUS = 'Status';
    public static final string ACCEPTED = 'Accepted';
    public static final string PRESENTED = 'Presented';
    public static final string REQUESTED = 'Requested';
	public static final string ERROR_MSG='There is already a Base Contract on the Account during this date range.The End Date of the existing base contract must be prior to the start date of a new base contract.';
    /*
* Update the contract's opportunity stage to close-won 
* if all the contracts associated with it have a status of
* Activated, Activated and/or Cancelled
*/
    public static void updateOpportunitiesOnActivatedContracts(List<Contract> activatedContracts) {
        //Find all Contracts related to this Opportunity
        Set<Id> opportunityIds = new Set<Id>();
        List<Contract> contracts = [SELECT vlocity_ins__QuoteId__r.OpportunityId FROM Contract WHERE Id IN :activatedContracts];
        for(Contract c : contracts) {
            opportunityIds.add(c.vlocity_ins__QuoteId__r.OpportunityId);
        }
        
        List<Contract> opportunityContracts = [SELECT Id, Status, vlocity_ins__QuoteId__r.OpportunityId 
                                               FROM Contract WHERE vlocity_ins__QuoteId__r.OpportunityId IN :opportunityIds];
        
        
        Map<Id, List<Contract>> oppctMap = new Map<Id, List<Contract>>();
        List<Contract> cts = new List<Contract>();
        for(Id oppId : opportunityIds) {
            for(Contract ct : opportunityContracts) {
                if(ct.vlocity_ins__QuoteId__r.OpportunityId == oppId) {
                    cts.add(ct);
                }
            }
            oppctMap.put(oppId, cts);
        }
        
        //Identify if the statuses of all the contracts in this opportunity
        Set<Id> opportunityIdsToUpdate = new Set<Id>();
        Integer allContractsActivated = 0;
        Integer allContractsCancelled = 0;
        for(Id oId : oppctMap.keyset()) {
            for(Contract cont : oppctMap.get(oId)) {
                if(cont.Status == ACTIVATEDSTATUS) {
                    allContractsActivated++;
                }
                if(cont.Status == CANCELLEDSTATUS) {
                    allContractsCancelled++;
                }
            }
            
            if(allContractsActivated == oppctMap.get(oId).size()) {
                //all contracts are activated
                opportunityIdsToUpdate.add(oId);
            }
            else if((allContractsActivated + allContractsCancelled) == oppctMap.get(oId).size()) {
                //Contracts are activated and cancelled
                opportunityIdsToUpdate.add(oId);
            }
            else if(allContractsCancelled == oppctMap.get(oId).size()) {
                //all contracts are cancelled
                System.debug('** All Contracts are cancelled **');
            }
            else {
                //There is at least one contract with a different status
                System.debug('** There is at least one contract with a status different than activated or cancelled **');
            }
        }
        
        //Update the Opportunity Stage and Close Reason 
        try {
            if(opportunityIdsToUpdate.size() > 0) {
                List<Opportunity> opportunitiesToUpdate = [SELECT Id, StageName FROM Opportunity WHERE Id IN :opportunityIdsToUpdate];
                List<Opportunity> updatedOpportunities = new List<Opportunity>();
                for(Opportunity opp : opportunitiesToUpdate) {
                    opp.StageName = CLOSEWONSTAGE;
                    opp.GA_ClosedReason__c = CLOSEREASON;
                    updatedOpportunities.add(opp);
                }
                
                update updatedOpportunities;
            }
        }
        catch(Exception ex) {
            GA_LogExceptionCls.LogExcp(ex, CLSNAME, UPDOPPONACTCNTS);
        }
    }
    
    /*
* Update the contract's quote to Denied when a contract has been marked as cancelled
*/
    public static void updateQuotesOnCancelledContracts(List<Contract> cancelledContracts) {
        Set<Id> quoteIds = new Set<Id>();
        for(Contract ctrct : cancelledContracts) {
            quoteIds.add(ctrct.vlocity_ins__QuoteId__c);
        }
        
        List<Quote> quotesToDenied = [SELECT Id, Status FROM Quote WHERE Id IN :quoteIds];
        List<Quote> quotesToUpdate = new List<Quote>();
        
        try {
            for(Quote qt : quotesToDenied) {
                qt.Status = DENIEDSTATUS;
                quotesToUpdate.add(qt);
            }
            
            update quotesToUpdate;
        }
        catch(Exception ex) {
            GA_LogExceptionCls.LogExcp(ex, CLSNAME, UPDQTEONCNCCNTS);
        }
    }
    
    /*
* Populate this contract's plan's sold product with the correct account.
* This will allow the Sold Products to show directly on the account record
*/
    public static void updatePlansOnActivatedContracts(List<Contract> activatedContracts) {
        List<vlocity_ins__ContractLineItem__c> plansToUpdate = new List<vlocity_ins__ContractLineItem__c>();
        List<vlocity_ins__ContractLineItem__c> contractPlans = new List<vlocity_ins__ContractLineItem__c>();
        
        contractPlans = [SELECT Id, ASC_Sold_Product__c, vlocity_ins__ContractId__r.AccountId 
                         FROM vlocity_ins__ContractLineItem__c WHERE vlocity_ins__ContractId__c IN :activatedContracts];
        
        try {
            if(contractPlans.size() > 0) {
                for(vlocity_ins__ContractLineItem__c plan : contractPlans) {
                    plan.ASC_Sold_Product__c = plan.vlocity_ins__ContractId__r.AccountId;
                    plansToUpdate.add(plan);
                }
                
                update plansToUpdate;
            }
        }
        catch(Exception ex) {
            GA_LogExceptionCls.LogExcp(ex, CLSNAME, UPDPLNSONACTCNTS);
        }
    }
    
    /*
* Remove this contract's plan's sold product association with the parent account.
* This will remove the Sold Products related list on the account record
*/
    public static void updatePlansOnCancelledContracts(List<Contract> cancelledContracts) {
        List<vlocity_ins__ContractLineItem__c> plansToUpdate = new List<vlocity_ins__ContractLineItem__c>();
        List<vlocity_ins__ContractLineItem__c> contractPlans = new List<vlocity_ins__ContractLineItem__c>();
        
        contractPlans = [SELECT Id, ASC_Sold_Product__c FROM vlocity_ins__ContractLineItem__c 
                         WHERE vlocity_ins__ContractId__c IN :cancelledContracts];
        
        try {
            if(contractPlans.size() > 0) {
                for(vlocity_ins__ContractLineItem__c plan : contractPlans) {
                    plan.ASC_Sold_Product__c = null;
                    plansToUpdate.add(plan);
                }
                
                update plansToUpdate;
            }
        }
        catch(Exception ex) {
            GA_LogExceptionCls.LogExcp(ex, CLSNAME, UPDPLNSONACTCNTS);
        }
    }
    
    
    /*US-3625 -Added By Dinesh -  after update - Quote - Status, Opportunity - StageName ,Sub Stage.*/        
    public static final string CONTRACT  ='Contract';    
    public static void updateOpportunityStage(List<Contract> contractList, map<id,Contract> contractOldMap) {
        List<Contract> contractsList_ERISAExempt = new List<Contract>();
        List<Contract> contractsList_SSLRunOutCoverage = new List<Contract>();
        set<id> accountIds_ERISAExempt=new set<id>();
        try{           
            Id contractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get(ASC_CONTRACT).getRecordTypeId();
            
            List<Contract> newcontractList = new List<Contract>();
            if(!contractList.isEmpty()){
                for(Contract cntr:contractList){
                    if(contractRecordTypeId.equals(cntr.RecordTypeId)){
                        newcontractList.add(cntr);
                    }

                    /* US-4016--Added by Mohan */                    
                    if(contractRecordTypeId.equals(cntr.RecordTypeId) && cntr.ASC_ERISA__c !=contractOldMap.get(cntr.id).ASC_ERISA__c){
                        contractsList_ERISAExempt.add(cntr);
                        accountIds_ERISAExempt.add(cntr.AccountId);
                    } 
                    /* US-4013--Added by Mohan */                    
                    if(contractRecordTypeId.equals(cntr.RecordTypeId) && cntr.ASC_SSL_Run_Out_Coverage_Elected__c !=contractOldMap.get(cntr.id).ASC_SSL_Run_Out_Coverage_Elected__c){
                        contractsList_SSLRunOutCoverage.add(cntr);
                    } 
                    
                }           
            }
            if(!newcontractList.isEmpty()){
                ASC_ContractQuoteStatus_OppStageUpdate.updateValues(newcontractList,contractOldMap,CONTRACT);
            }
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEUPDTOPPSTAGE);
        }
       system.debug('contractsList_ERISAExempt>>>>'+contractsList_ERISAExempt);
        if(contractsList_ERISAExempt.size()>0) updateContractERISAExempt(contractsList_ERISAExempt,accountIds_ERISAExempt);
        system.debug('contractsList_SSLRunOutCoverage>>>>'+contractsList_SSLRunOutCoverage);
        if(contractsList_SSLRunOutCoverage.size()>0) updatePlanItems(contractsList_SSLRunOutCoverage); 
    }
    
    /*US-3625 -Added By Dinesh -  after update - This method is used to create/update the Status History Tracking records when there is an update on
Contract - Status, Invoice Setup ,Signature Status
Opportunity - StageName , Sub Stage
Quote - Status
Plan - Activation Status*/                   
    public static void createHistoryTrackingrecords(List<Contract> contractList) { //after Insert
        try{            
            
            Id contractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get(ASC_CONTRACT).getRecordTypeId();
            
            List<Contract> newcontractList = new List<Contract>();           
            if(!contractList.isEmpty()){
                for(Contract cntr:contractList){
                    if(contractRecordTypeId.equals(cntr.RecordTypeId)){
                        newcontractList.add(cntr);
                    }    
                }           
            }
            //after Insert
            if(!newcontractList.isEmpty()){
                ASC_StatusHistoryTracking.createUpdateStatusHistoryTracking(newcontractList,null,CONTRACT);
            }
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEBASECNTRVALIDATION);
        }
    }
    
    
    
    /**************************************************************************************************************
@Description        : This method is used to throw an error while creation base contract with start date before than the existing records end dates.
@Name               :   ascBaseContractValidation
@Param              :   List<Contract> contractList
@Return             :   void
@throws Exception   :   N/A;
@User Story Number  :  #US-4433
**************************************************************************************************************/
    
    public static void ascBaseContractValidation(List<Contract> contractList) { //before Insert
        try{            
           // system.debug('hello from handler');
            Id contractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('ASC_Base_Contract').getRecordTypeId();
          //  List<Account> Accid = [Select Id From Account  Limit :UTIL_SLB.retrieveQueryLimitValue() ];
            List<Contract> oldBaseContractList = [Select Id,ASC_Carrier__c,RecordTypeId,CID__c,ASC_Sub_Segment__c,AccountId,StartDate,EndDate from Contract 
                                                     where RecordTypeId =: contractRecordTypeId and AccountId= '0011D00000jtAM3QAM'	 ];
            //system.debug('old map'+oldBaseContractList);
           
            if(!contractList.isEmpty() && !oldBaseContractList.isEmpty()){
                for(Contract cntr:contractList){
                    // system.debug('old map1'+cntr);
                    for(Contract oldcntr : oldBaseContractList){
                       // system.debug('old map2'+oldcntr);
                        
 					 if(cntr.AccountId == oldcntr.AccountId && cntr.RecordTypeId==contractRecordTypeId && cntr.ASC_Carrier__c == oldcntr.ASC_Carrier__c  &&
                       cntr.CID__c == oldcntr.CID__c  && ( cntr.StartDate <= oldcntr.EndDate)){ //( cntr.StartDate <= oldcntr.EndDate ||
                          	/*system.debug('in if start'+cntr.StartDate+'in if end '+ oldcntr.EndDate );
                            system.debug('in not if start'+cntr.EndDate+'in not  if end '+ oldcntr.StartDate );
                     		system.debug('in if start'+cntr.ASC_Carrier__c+'in if end '+ oldcntr.ASC_Carrier__c );*/
                           
                           cntr.adderror(ERROR_MSG);  
                           
                    }
               
                    }    
                }           
            }
            
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEHISTRACKING);
        }
    }
    
    /*US-3625 -Added By Dinesh -  after update - This class is used to create/update the Status History Tracking records when there is an update on
Contract - Status, Invoice Setup ,Signature Status
Opportunity - StageName , Sub Stage
Quote - Status
Plan - Activation Status*/                   
    public static void updateHistoryTrackingrecords(List<Contract> contractList, map<id,Contract> contractOldMap) { //after Update
        try{            
            
            Id contractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get(ASC_CONTRACT).getRecordTypeId();
            
            List<Contract> newcontractList = new List<Contract>();
            Map<Id, Contract> oldContractMap = new Map<Id, Contract>();
            
            if(!contractList.isEmpty()){
                for(Contract cntr:contractList){
                    if(contractRecordTypeId.equals(cntr.RecordTypeId)){
                        newcontractList.add(cntr);
                        oldContractMap.put(cntr.Id,contractOldMap.get(cntr.Id));                     
                    }    
                }           
            }
            //after Update
            if(!newcontractList.isEmpty()){
               ASC_StatusHistoryTracking.createUpdateStatusHistoryTracking(newcontractList,oldContractMap,CONTRACT);
            }
            
            /*US-4394 Added By Dinesh - Start */
            if(!newcontractList.isEmpty()){
            ASC_UpdateComplianceStatusOnAccount.UpdateCompliance(newcontractList,oldContractMap);
            }
            /*US-4394 - End */
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEHISTRACKING);
        }
    }
    
    public static void updateContractStatus(List<Contract> contractList, map<id,Contract> contractOldMap) { //before update
        
        try{                        
            Id contractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get(ASC_CONTRACT).getRecordTypeId();
            Id LIERecordTypeId = Schema.SObjectType.Line_Item_Extension__c.getRecordTypeInfosByDeveloperName().get('LIE_Stop_Loss_Products').getRecordTypeId();
            List<Contract> newcontractList = new List<Contract>();           
            Date today = Date.Today(); 
                       
            if(!contractList.isEmpty()){
                for(Contract cntr:contractList){                                                      
                    sObject oldMapInContext = Schema.getGlobalDescribe().get(CONTRACTOBJNAME).newSObject();                 
                    if(contractOldMap !=null){
                        oldMapInContext = contractOldMap.get(cntr.Id);
                    }
                    /*US-3625 -Added By Dinesh -Start before update - logic to update the Signature Status when there is change in Contract Status */
                   if(contractRecordTypeId.equals(cntr.RecordTypeId) 
                       && String.isNotBlank(cntr.Status) 
                       && (oldMapInContext !=null && cntr.Status != String.valueOf(oldMapInContext.get(STATUS)))
                       && ACCEPTED.equals(cntr.Status)
                      ){
                          //cntr.ASC_Signature_Status__c = GROUPSIGST;
                      }
                    if(contractRecordTypeId.equals(cntr.RecordTypeId) 
                       && String.isNotBlank(cntr.Status) 
                       && (oldMapInContext !=null && cntr.Status != String.valueOf(oldMapInContext.get(STATUS)))
                       && PRESENTED.equals(cntr.Status)
                      ){
                         //cntr.ASC_Signature_Status__c = REQUESTED;

                      }
                    /*US-3625 -Added By Dinesh - End  */       
                    
                    if(contractRecordTypeId.equals(cntr.RecordTypeId) && cntr.Status==ACCEPTED && cntr.StartDate<=today){
                       cntr.Status= ACTIVATEDSTATUS;
                    }            
                    
                    //Added By Dinesh - Start
                    //ASC_UpdateComplianceStatusOnAccount.UpdateCompliance(contractList,contractOldMap);
                }           
            }                     
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEHISTRACKING);
        }       
    }
    /*US-4016 -Added By Mohan -  Update ERISA Exempt field on Base Contract record */
    
   public static void updateContractERISAExempt(list<contract> contractsList_ERISAExempt, set<id> accountIds_ERISAExempt) {
        system.debug('updateContractERISAExempt....method Start..');
        map<id, list<contract>> ASC_Base_Contract_Map=new map<id, list<contract>>();        
        for(contract con: [select Id,StartDate,endDate,AccountId,ASC_Carrier__c
                            from contract 
                            where AccountId IN: accountIds_ERISAExempt 
                            AND RecordType.DeveloperName='ASC_Base_Contract' 
                            ]){
                            
            if(!ASC_Base_Contract_Map.containsKey(con.AccountId)){
                ASC_Base_Contract_Map.put(con.AccountId, new list<contract>());
            }
            ASC_Base_Contract_Map.get(con.AccountId).add(con);
            
        }
        system.debug('ASC_Base_Contract_Map...'+ASC_Base_Contract_Map);
        list<contract> ERISAExemptConList=new list<contract>();
        for(contract con: contractsList_ERISAExempt){
            if(ASC_Base_Contract_Map.containsKey(con.AccountId)){
                for(contract ERISAExemptCon: ASC_Base_Contract_Map.get(con.AccountId)){
                    system.debug('start date comparision......ERISAExemptCon>>>'+ERISAExemptCon.StartDate+'.....con>>>'+con.StartDate);
                    if(con.StartDate>=ERISAExemptCon.StartDate && con.EndDate<=ERISAExemptCon.EndDate
                        && ERISAExemptCon.ASC_Carrier__c==con.ASC_Carrier__c){
                        ERISAExemptCon.ASC_ERISA_Exempt__c=(con.ASC_ERISA__c== 'Yes') ? 'No':'Yes';
                        ERISAExemptConList.add(ERISAExemptCon);                     
                    }
                }
            }
        }
        system.debug('ERISAExemptConList...'+ERISAExemptConList);
        if(ERISAExemptConList.size()>0) database.update(ERISAExemptConList,false);
    } 
 /*US-4013-Added By Mohan -  Update Coverage Elected field on LIE record for Specific Stop Loss Coverage Run-Out */ 
    
    public static void updatePlanItems(list<contract> contractsList_SSLRunOutCoverage) {
        map<id,vlocity_ins__ContractLineItem__c> PlanMap_SpecificStopLossCoverageRunOut=new map<id,vlocity_ins__ContractLineItem__c>();//map<contractid,plan>       
        for(vlocity_ins__ContractLineItem__c plan: [SELECT Id,Name,vlocity_ins__ContractId__r.StartDate,
                                                      vlocity_ins__ContractId__r.EndDate,
                                                      vlocity_ins__ContractId__r.ASC_SSL_Run_Out_Coverage_Elected__c,
                                                      vlocity_ins__ProductCode__c,
                                                      vlocity_ins__ContractId__c,
                                                      vlocity_ins__Product2Id__c,
                                                      ASC_Line_Item_Extension__c 
                                                      FROM vlocity_ins__ContractLineItem__c 
                                                      WHERE vlocity_ins__ContractId__c IN:contractsList_SSLRunOutCoverage
                                                      AND vlocity_ins__ProductCode__c='ASC_0000350']){
            PlanMap_SpecificStopLossCoverageRunOut.put(plan.vlocity_ins__ContractId__c,plan);
        }
        product2 prod = [SELECT Id, Name, ProductCode FROM Product2 where ProductCode ='ASC_0000350' limit 1];      
        Id LIERecordTypeId = Schema.SObjectType.Line_Item_Extension__c.getRecordTypeInfosByDeveloperName().get('LIE_Stop_Loss_Products').getRecordTypeId();
        map<id,Line_Item_Extension__c> contract_LineItemExtension_Map=new map<id,Line_Item_Extension__c>();
        map<id,vlocity_ins__ContractLineItem__c> contract_Plan_Map=new map<id,vlocity_ins__ContractLineItem__c>();
        
        for(contract con:contractsList_SSLRunOutCoverage){
            if(!PlanMap_SpecificStopLossCoverageRunOut.containsKey(con.id)){
                Line_Item_Extension__c ltmExt1 = new Line_Item_Extension__c();
                ltmExt1.RecordTypeId=  LIERecordTypeId;
                ltmExt1.Name = prod.Name;
                ltmExt1.Product__c = prod.id;
                ltmExt1.Activation_Type__c = 'New';
                ltmExt1.Account__c=con.Group_Label__c;
                ltmExt1.Effective_Start_Date__c= con.StartDate;
                ltmExt1.Effective_End_Date__c = con.endDate;                
               if(con.ASC_SSL_Run_Out_Coverage_Elected__c == 'Yes'){
                    ltmExt1.Coverage_Elected__c = 'Elected';    
                }else{
                    ltmExt1.Coverage_Elected__c = 'Not Elected'; 
                }
                contract_LineItemExtension_Map.put(con.id,ltmExt1);
                
                vlocity_ins__ContractLineItem__c plan =new vlocity_ins__ContractLineItem__c();
                plan.Name = prod.Name;
                plan.vlocity_ins__Product2Id__c = prod.Id;
                //plan.ASC_Line_Item_Extension__c = contract_LineItemExtension_Map.get(con.id).Id;
                plan.vlocity_ins__ContractId__c = con.id;
                plan.ASC_Effective_Start_Date__c= con.StartDate;
                plan.ASC_Effective_End_Date__c = con.endDate;
                plan.vlocity_ins__Quantity__c = 1;
                contract_Plan_Map.put(con.id,plan);
            }
            if(PlanMap_SpecificStopLossCoverageRunOut.containsKey(con.id) && 
                PlanMap_SpecificStopLossCoverageRunOut.get(con.id).ASC_Line_Item_Extension__c!=NULL){
                Line_Item_Extension__c ltmExt1=new Line_Item_Extension__c();
                ltmExt1.id=PlanMap_SpecificStopLossCoverageRunOut.get(con.id).ASC_Line_Item_Extension__c;
                if(con.ASC_SSL_Run_Out_Coverage_Elected__c == 'Yes'){
                    ltmExt1.Coverage_Elected__c = 'Elected';    
                }else{
                    ltmExt1.Coverage_Elected__c = 'Not Elected'; 
                }
                contract_LineItemExtension_Map.put(con.id,ltmExt1);
            }
        }
        if(!contract_LineItemExtension_Map.isEmpty()) database.upsert(contract_LineItemExtension_Map.values(),false);
        if(!contract_Plan_Map.isEmpty()) database.insert(contract_Plan_Map.values(),false);
        
        for(vlocity_ins__ContractLineItem__c plan:contract_Plan_Map.values()){
            if(contract_LineItemExtension_Map.containsKey(plan.vlocity_ins__ContractId__c))
                plan.ASC_Line_Item_Extension__c = contract_LineItemExtension_Map.get(plan.vlocity_ins__ContractId__c).Id;               
        }       
        if(!contract_Plan_Map.isEmpty()) database.update(contract_Plan_Map.values(),false);
        list<Line_Item_Extension__c> ltmExt_UpdateList=new list<Line_Item_Extension__c>();
        for(vlocity_ins__ContractLineItem__c plan:contract_Plan_Map.values()){
            if(plan.ASC_Line_Item_Extension__c!=NULL){
                Line_Item_Extension__c ltmExt=new Line_Item_Extension__c();
                ltmExt.id=plan.ASC_Line_Item_Extension__c;
                ltmExt.Plan_ID__c=plan.id;
                ltmExt_UpdateList.add(ltmExt);
            }
        }
        system.debug('ltmExt_UpdateList...>>> '+ltmExt_UpdateList);
        if(ltmExt_UpdateList.size()>0) database.update(ltmExt_UpdateList,TRUE);
    }
}