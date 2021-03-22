/**************************************************************************************************************
@Author : Dinesh
@Name: ASC_Product_CreateActionPlan
@CreatedDate:  05-Nov-2020 
@Description: ASC_Product_CreateActionPlan class is used to create the Action Plans and AP Tasks and Activities on the Quote Object.
@version : 1.0  
@US Number: US-4025/3935
*************************************************************************************************************/
public without sharing class ASC_Product_CreateActionPlan{
    private static final string CLASSNAME ='ASC_Product_CreateActionPlan';
    private static final string METHODNAME ='createActionPlanRecord';
    private static final string STR_EMPTY ='';
    public static final Id ASC_QUOTE_RECTYPEID = 
        Schema.SObjectType.Quote.getRecordTypeInfosByName().get('ASC Quote').getRecordTypeId();
    private static final string SEMICO=';';
    private static final string INDVIDVL='Individual';
    private static final string NOTSTARTED='Not Started';
    private static final string HIGH='High';
    private static final string INREVIEW='In Review';
    private static final string YES='Yes';
    private static final string UNDRSCR='_';
    private static final string ASCE='ASC';
    /************************************************************************************************************
    @Description        :   This method is used to call the createActionPlanRecord method functionality  
    @Name               :   createActionPlanRecord 
    @Param              :   string gspId
    @Return             :   String
    ***********************************************************************************************************/
    public static Void createActionPlanRecord(list<Quote> quoteList,map<id,Quote> quoteOldMap)
    {
        List<ActionPlan__c> planListToInsert = new List<ActionPlan__c>();
        List<ActionPlanTemplate__c> actnPlnTemp = new List<ActionPlanTemplate__c>();
        Set<Id> quotIdSet = new Set<Id>();
        
        try{      
            if(!quoteList.isEmpty()){
                for(Quote quoteRec :quoteList){
                    if(ASC_QUOTE_RECTYPEID.equals(quoteRec.RecordTypeId) && quoteOldMap!=null){
                        Quote oldQuote=quoteOldMap.get(quoteRec.Id);
                        if(String.isNotBlank(quoteRec.Status) 
                           && oldQuote.CreateActionPlanChk__c != quoteRec.CreateActionPlanChk__c 
                           && INREVIEW.equals(quoteRec.Status)
                           && YES.equals(quoteRec.CreateActionPlanChk__c)){
                               quotIdSet.add(quoteRec.Id);
                        }
                    }             
                }
            }
                        
            if(!quotIdSet.isEmpty()){
                for(QuoteLineItem qli:[Select Id,QuoteId,Quote.Name,Product2.Name,Product2.ASC_Product_Owner__c,Product2.Productcode,
                                       ASC_Line_Item_Extension__c,
                                       ASC_Line_Item_Extension__r.Fee_Amount__c,
                                       ASC_Line_Item_Extension__r.Original_Fee_Amount__c,
                                       ASC_Line_Item_Extension__r.Monthly_Cap_Amount__c,
                                       ASC_Line_Item_Extension__r.Original_Monthly_Cap_Amount__c,
                                       ASC_Line_Item_Extension__r.Minimum__c,
                                       ASC_Line_Item_Extension__r.Original_Minimum__c,
                                       ASC_Line_Item_Extension__r.Tier__c,                                    
                                       Quote.AccountId
                                       from QuoteLineItem where QuoteId IN:quotIdSet 
                                       AND ASC_Variance_For_Approval__c = true]){

                                       ActionPlan__c plan = new ActionPlan__c();            
                                       plan.Quote__c = qli.QuoteId;
                                       plan.ASC_Quote_Line_Item__c = qli.Id;
                                       plan.Name = qli.Quote.Name+' '+'-'+' '+qli.Product2.Name; 
                                       plan.ASC_Product_Code__c = qli.Product2.Productcode;
                                       plan.Description__c = qli.Product2.Name;
                                       plan.StartDate__c = Date.Today();
                                       plan.Account__c = qli.Quote.AccountId;               
                                       planListToInsert.add(plan);   
                                       
                }          
            }                                           
            
            if(!planListToInsert.isEmpty()){            
                Insert planListToInsert;
            } 
            
            Map<String,actionplan__c> actionPlanIdMap = new Map<String,actionplan__c>();
            for(actionplan__c aplan:[Select Id,ownerid,Name,Quote__c,ASC_Product_Code__c,
                                     Account__c,
                                     Account__r.GA_Underwriting__c,
                                     ASC_Quote_Line_Item__r.ASC_Pricing_Variance__c,
                                     ASC_Quote_Line_Item__r.ASC_Line_Item_Extension__r.Product_Approval__c,
                                     ASC_Quote_Line_Item__r.ASC_Line_Item_Extension__r.Create_Lead_Time_Approval_Task__c                                     
                                     from ActionPlan__c where Id IN:planListToInsert
                                     LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                 actionPlanIdMap.put(aplan.ASC_Product_Code__c,aplan);       
            }
            
            Map<Id, Product2> productSetMap = new Map<Id, Product2>();
            for (Product2 prd : [SELECT Id, ProductCode FROM Product2 
                                 Where ProductCode IN:actionPlanIdMap.KeySet()
                                 LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                                 
                                 productSetMap.put(prd.Id,prd);
                                 System.debug('*****************productSetMap'+productSetMap);                                   
            }
            
            list<APTaskTemplate__c> tasks = new list<APTaskTemplate__c>();
            list<ActionPlan__c> actionPlan = new list<ActionPlan__c>();            
            List<String> approvalTypeSet = new List<String>();
            Map<String,APTaskTemplate__c> tasksToUpdate = new Map<String,APTaskTemplate__c>();
            for(Product_Approvers__c approvers : [SELECT Id,Approval_Order__c,
                                                  Approval_Type__c,Product__c,
                                                  Role__c,User__c ,
                                                  UW_Product__c
                                                  FROM Product_Approvers__c 
                                                  WHERE Product__c IN :productSetMap.keySet()
                                                  ORDER BY Approval_Order__c ASC
                                                  NULLS FIRST                                                                                                                                          
                                                  LIMIT :UTIL_SLB.retrieveQueryLimitValue()
                                                 ]){
                                                     Product2 prd = productSetMap.get(approvers.Product__c);
                                                     if(approvers.Approval_Type__c.split(SEMICO).size() == 1
                                                        && (('Pricing'.equals(approvers.Approval_Type__c) && actionPlanIdMap.ContainsKey(prd.ProductCode) && actionPlanIdMap.get(prd.ProductCode).ASC_Quote_Line_Item__r.ASC_Pricing_Variance__c)
                                                            || ('Product'.equals(approvers.Approval_Type__c) && actionPlanIdMap.ContainsKey(prd.ProductCode) && actionPlanIdMap.get(prd.ProductCode).ASC_Quote_Line_Item__r.ASC_Line_Item_Extension__r.Product_Approval__c)  
                                                            || ('Short Lead Time'.equals(approvers.Approval_Type__c) && actionPlanIdMap.ContainsKey(prd.ProductCode) && actionPlanIdMap.get(prd.ProductCode).ASC_Quote_Line_Item__r.ASC_Line_Item_Extension__r.Create_Lead_Time_Approval_Task__c)                                                                                                                     
                                                                                                                     
                                                           )
                                                         ){
                                                         APTaskTemplate__c apTask = new APTaskTemplate__c();
                                                         apTask.DaysFromStart__c = 1;
                                                         apTask.Subject__c = approvers.Approval_Type__c+' '+'Approval';
                                                         apTask.Type__c = 'Email';
                                                         apTask.User__c = !approvers.UW_Product__c?approvers.User__c:actionPlanIdMap.get(prd.ProductCode).Account__r.GA_Underwriting__c;
                                                         apTask.Action_Plan__c = actionPlanIdMap.get(prd.ProductCode).Id;   
                                                         apTask.ASC_Approval_Order__c = approvers.Approval_Order__c;
                                                         apTask.Status__c = NOTSTARTED;
                                                         apTask.Priority__c = HIGH;
                                                         apTask.ASC_Product_Approvers_Key__c = actionPlanIdMap.get(prd.ProductCode).Id +UNDRSCR+ approvers.Approval_Order__c +UNDRSCR+ approvers.Approval_Type__c +UNDRSCR+ approvers.Role__c;
                                                         //tasks.add(apTask);
                                                         tasksToUpdate.put(actionPlanIdMap.get(prd.ProductCode).Id+'_'+approvers.Approval_Type__c,apTask);      
                                                     }
                                                     else{
                                                         List<String> appTypeString = approvers.Approval_Type__c.split(';');
                                                         approvalTypeSet.addAll(appTypeString);
                                                         for(String approvalType:approvalTypeSet){
                                                         
                                                         if(('Pricing'.equals(approvalType) && actionPlanIdMap.ContainsKey(prd.ProductCode) && actionPlanIdMap.get(prd.ProductCode).ASC_Quote_Line_Item__r.ASC_Pricing_Variance__c)
                                                            || ('Product'.equals(approvalType) && actionPlanIdMap.ContainsKey(prd.ProductCode) && actionPlanIdMap.get(prd.ProductCode).ASC_Quote_Line_Item__r.ASC_Line_Item_Extension__r.Product_Approval__c)  
                                                            || ('Short Lead Time'.equals(approvalType) && actionPlanIdMap.ContainsKey(prd.ProductCode) && actionPlanIdMap.get(prd.ProductCode).ASC_Quote_Line_Item__r.ASC_Line_Item_Extension__r.Create_Lead_Time_Approval_Task__c)                                                                                                                     
                                                                                                                     
                                                           ){
                                                                                                     
                                                             APTaskTemplate__c apTask = new APTaskTemplate__c();
                                                             apTask.DaysFromStart__c = 1;
                                                             apTask.Subject__c = approvalType+' '+'Approval';
                                                             apTask.Type__c = 'Email';
                                                             apTask.User__c = !approvers.UW_Product__c?approvers.User__c:actionPlanIdMap.get(prd.ProductCode).Account__r.GA_Underwriting__c;
                                                             apTask.Action_Plan__c = actionPlanIdMap.get(prd.ProductCode).Id;   
                                                             apTask.ASC_Approval_Order__c = approvers.Approval_Order__c;
                                                             apTask.Status__c = NOTSTARTED;
                                                             apTask.Priority__c = HIGH;
                                                             apTask.ASC_Product_Approvers_Key__c = actionPlanIdMap.get(prd.ProductCode).Id +UNDRSCR+ approvers.Approval_Order__c +UNDRSCR+ approvers.Approval_Type__c +UNDRSCR+ approvers.Role__c;
                                                             //tasks.add(apTask);  
                                                             tasksToUpdate.put(actionPlanIdMap.get(prd.ProductCode).Id+'_'+approvalType,apTask);  
                                                             
                                                          }
                                                         }                                                         
                                                     }                                                                                                                                                       
            }
            
            if(!tasks.isEmpty()){
                //database.insert(tasks);
            }
            if(!tasksToUpdate.isEmpty()){
              Insert tasksToUpdate.Values();
            }
            
            Map<String,APTaskTemplate__c> productApproversMap = new Map<String,APTaskTemplate__c>();
            Task auxTask; 
            List<Task> tskToInsert = new List<Task>();
            //Creating tasks in Standard Task object to be displayed in ASC Plan Mod Object            
            Map<Decimal,APTaskTemplate__c> indexMap = new Map<Decimal,APTaskTemplate__c>();
            for(APTaskTemplate__c apTasks : [Select Id,Subject__c,Priority__c,User__c,Action_Plan__r.Quote__c, 
                                                   ASC_Approval_Order__c, comments__c,
                                                   ASC_Product_Approvers_Key__c
                                                   from APTaskTemplate__c where ID IN: tasksToUpdate.Values()                                                  
                                                   AND APTaskTemplate__c = null
                                                   order by ASC_Approval_Order__c asc
                                                   LIMIT :UTIL_SLB.retrieveQueryLimitValue()
                                            ]){
                                                      
                  if(!productApproversMap.ContainsKey(apTasks.ASC_Product_Approvers_Key__c)){
                    indexMap.put(apTasks.ASC_Approval_Order__c,apTasks);                                                                                              
                    productApproversMap.put(apTasks.ASC_Product_Approvers_Key__c,apTasks);
                  } 
                  
                  if(apTasks.ASC_Approval_Order__c == null || !apTasks.ASC_Product_Approvers_Key__c.endsWith(INDVIDVL)) {
                      auxTask  = new Task();                       
                      auxTask.Subject = apTasks.Subject__c;
                      auxTask.Priority = HIGH;
                      auxTask.OwnerId = apTasks.User__c;                                                   
                      auxTask.WhatId = apTasks.Action_Plan__r.Quote__c;
                      auxTask.TaskTemplateId__c = apTasks.Id;
                      auxTask.Type = ASCE;
                      tskToInsert.add(auxTask);
                  }                
            }
            
            List<APTaskTemplate__c> taskdepenedencyListToUpdate = new List<APTaskTemplate__c>();
            for(APTaskTemplate__c apTT: [Select Id,Subject__c,Priority__c,User__c,Action_Plan__r.Quote__c, ASC_Approval_Order__c, comments__c
                                         from APTaskTemplate__c where ID IN: tasksToUpdate.Values()                                                  
                                         AND APTaskTemplate__c = null
                                         order by ASC_Approval_Order__c asc
                                         LIMIT :UTIL_SLB.retrieveQueryLimitValue()
                                        ]){
                    Decimal indexNum;
                    if(apTT.ASC_Approval_Order__c !=null && apTT.ASC_Approval_Order__c !=1){
                        indexNum = apTT.ASC_Approval_Order__c;
                        indexNum = indexNum - 1;
                    }
                    APTaskTemplate__c tempindex = new APTaskTemplate__c();
                    if(indexNum !=null){
                        tempindex = indexMap.get(indexNum);
                        apTT.APTaskTemplate__c = tempindex.Id;
                        taskdepenedencyListToUpdate.add(apTT);
                    }                                                                                             
            }
            
            if(!taskdepenedencyListToUpdate.isEmpty()){
                Update taskdepenedencyListToUpdate;
            }            
            if(!tskToInsert.isEmpty()){
                Insert tskToInsert;
            }             
        }        
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME); 
        } 
    }
}