/**
@Author : Mida Komal
@Name: ASC_PlanTriggerHandler
@CreatedDate: 8- May 2020 
@Description: ASC_PlanTriggerHandler class is for Plan object.
@version : 1.0  
*/
public with sharing class ASC_PlanTriggerHandler {
    public static final string CLSNAME  ='ASC_Product_TriggerHandler';
    public static final string METHODNME  ='beforeInsert';
    public static final string METHODNAME  ='beforeUpdate';
    public static final string METHODNME1  ='duplicatePlanInsert';
    public static final string METHODNME2  ='afterInsert';
    public static final string RXOPTOUT = 'Rx Opt Out';
    public static boolean call =true;
    private static final String ASCPRODUCT = 'ASC Product';
    private static final String PLANOBJNAME = 'vlocity_ins__ContractLineItem__c';
    public static final string METHODNME_AFTRUPDT  ='afterUpdate';  
    public static final string ASC_CONTRACT = 'ASC_Contract';
    
    /*******************************************************************************************************************************
@Description        :   beforeInsert() method 
@Name               :   beforeInsert
@Param              :   list<vlocity_ins__ContractLineItem__c> cLIList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    
    public static void beforeInsert(list<vlocity_ins__ContractLineItem__c> cLIList)
    {
        List<Line_Item_Extension__c> LIEListToInsert=new List<Line_Item_Extension__c>();
        try
        {          
            for(vlocity_ins__ContractLineItem__c eachCli : cLIList){
                if(eachCli.Name == null && eachCli.ASC_ProductName__c != null)
                {
                    eachCli.Name = eachCli.ASC_ProductName__c;
                }
                
                if(String.isNotBlank(eachCli.ASC_ProductName__c))
                {                                
                    if(eachCli.ASC_ProductName__c.startsWith('Your Dedicated Nurse Program Year'))
                    {
                        String contractYear = String.valueOf(eachCli.ASC_Effective_Start_Date__c);
                        if(contractYear !=null)
                        {
                            contractYear = contractYear.substring(0,4);
                            eachCli.Product_Label__c = 'Your Dedicated Nurse: consultant-sponsored Care Mgmt '+contractYear;
                        }                    
                    }                             
                    else if(RXOPTOUT.equals(eachCli.ASC_ProductName__c)){
                        eachCli.Product_Label__c = '3rd Party Rx Vendor Fee';                   
                    }                
                    else if(eachCli.ASC_ProductName__c.startsWith('Rx Accumulator Fee'))
                    {
                        String lineExtensionId = eachCli.ASC_Line_Item_Extension__c;
                        if(lineExtensionId !=null)
                        {
                            Line_Item_Extension__c lineItemExtension = [Select Id,Type__c from Line_Item_Extension__c where Id =:lineExtensionId]; 
                            if(lineItemExtension.Type__c !=null)
                            {
                                eachCli.Product_Label__c = 'Rx Accumulator Fee - '+lineItemExtension.Type__c;
                            }
                            else
                            {
                                eachCli.Product_Label__c = eachCli.ASC_ProductName__c;
                            }
                        }
                    }
                    else if('Stop-Loss Coverage Opt Out'.equals(eachCli.ASC_ProductName__c))
                    {
                        eachCli.Product_Label__c = '3rd Party Stop-Loss Vendor Fee';
                    }
                    else if('Pharmacy Rx Rebate: Option 2 Admin Fee Credit'.equals(eachCli.ASC_ProductName__c))
                    {
                        eachCli.Product_Label__c = 'Rx Rebate Admin Fee Credit';
                    }
                    else if('ECC Suite Admin Fee Credit'.equals(eachCli.ASC_ProductName__c))
                    {
                        eachCli.Product_Label__c = 'Extended Coordinated Care Suite Admin Fee Credit';
                    }
                    else if(('Blue Cross Coordinated Care Buy Up Program - Custom'.equals(eachCli.ASC_ProductName__c) ||
                             eachCli.ASC_ProductName__c.startsWith('Blue Cross Coordinated Care Buy Up Program - Standard')))
                    {
                        eachCli.Product_Label__c = 'Blue Cross Coordinated Care Buy Up Program';
                    }
                    else if(('Fixed Admin Fee'.equals(eachCli.ASC_ProductName__c) ||
                             eachCli.ASC_ProductName__c.startsWith('Multi Year Admin Fee Year')))
                    {
                        String contractYear = String.valueOf(eachCli.ASC_Effective_Start_Date__c);
                        if(contractYear !=null)
                        {
                            contractYear = contractYear.substring(0,4);
                            eachCli.Product_Label__c = contractYear+' Base Admin Fee';
                        }     
                        
                    }
                    else if(eachCli.ASC_ProductName__c.startsWith('Data Feeds'))
                    {
                        String lineExtensionId = eachCli.ASC_Line_Item_Extension__c;
                        if(lineExtensionId !=null)
                        {
                            Line_Item_Extension__c lineItemExtension = [Select Id,Tier__c,DataFeed_Type__c from Line_Item_Extension__c where Id =:lineExtensionId]; 
                            if(lineItemExtension.Tier__c !=null && lineItemExtension.Tier__c.contains('Year 1'))
                            {
                                if(lineItemExtension.DataFeed_Type__c != null)
                                {
                                    eachCli.Product_Label__c = lineItemExtension.DataFeed_Type__c+' - Year 1';
                                }
                                else
                                {
                                    eachCli.Product_Label__c = eachCli.ASC_ProductName__c+' - Year 1';
                                }                            
                            }
                            else
                            {
                                if(lineItemExtension.DataFeed_Type__c != null)
                                {
                                    eachCli.Product_Label__c = lineItemExtension.DataFeed_Type__c+' - Maintenance';
                                }
                                else
                                {
                                    eachCli.Product_Label__c = eachCli.ASC_ProductName__c+' - Maintenance';
                                }
                            }
                        }
                        else
                        {
                            eachCli.Product_Label__c = eachCli.ASC_ProductName__c+' - Maintenance';
                        }
                        
                    }
                    else
                    {
                        eachCli.Product_Label__c = eachCli.ASC_ProductName__c;
                    }
                } 
                
                if(eachCli.ASC_AAC_PCNT__c != null)
                {
                    if(eachCli.ASC_AAC_PCNT__c.ToPlainString().substringAfter('.').equals('00'))
                    {
                        
                        String numberToWord = ASC_ConvertNumberToWords.english_number(Long.valueOf(eachCli.ASC_AAC_PCNT__c.toPlainString()));
                        eachCli.ASC_AAC_PCNT_Words__c = numberToWord.toLowerCase()+' percent ('+ eachCli.ASC_AAC_PCNT__c.ToPlainString() + '%)';
                    }
                    else
                    {
                        eachCli.ASC_AAC_PCNT_Words__c = eachCli.ASC_AAC_PCNT__c.ToPlainString()+' percent';
                    }
                }  
                
            }
            
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
            system.debug('Exception '+e.getMessage());                    
        }
    }
    
    /*******************************************************************************************************************************
@Description        :   beforeUpdate() method 
@Name               :   beforeUpdate
@Param              :   list<vlocity_ins__ContractLineItem__c> cLIList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/           
    public static void beforeUpdate(list<vlocity_ins__ContractLineItem__c> cLIList)
    {
        try{
            for(vlocity_ins__ContractLineItem__c eachCli : cLIList){
                if(eachCli.ASC_AAC_PCNT__c != null)
                {
                    if(eachCli.ASC_AAC_PCNT__c.ToPlainString().substringAfter('.').equals('00'))
                    {
                        
                        String numberToWord = ASC_ConvertNumberToWords.english_number(Long.valueOf(eachCli.ASC_AAC_PCNT__c.toPlainString()));
                        eachCli.ASC_AAC_PCNT_Words__c = numberToWord.toLowerCase()+' percent ('+ eachCli.ASC_AAC_PCNT__c.ToPlainString() + '%)';
                    }
                    else
                    {
                        eachCli.ASC_AAC_PCNT_Words__c = eachCli.ASC_AAC_PCNT__c.ToPlainString()+' percent';
                    }
                }
            }
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME);
            system.debug('Exception '+e.getMessage());                    
        }
    } 
    
    /*******************************************************************************************************************************
@Description        :   duplicatePlanInsert() method 
@Name               :   beforeInsert
@Param              :   list<vlocity_ins__ContractLineItem__c> cLIList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/      
    public static void duplicatePlanInsert(list<vlocity_ins__ContractLineItem__c> PlnList){
        
        try{
            
            Set<String> ContractId = new Set<String>();
            Map<String,String> prdNamemMap = new Map<String,String>();
            Map<String ,vlocity_ins__ContractLineItem__c> DoctypeMap = new Map<String,vlocity_ins__ContractLineItem__c>();
            
            if(!PlnList.isEmpty()){
                for(vlocity_ins__ContractLineItem__c plans : PlnList){
                    if(ASCPRODUCT.equals(plans.vlocity_ins__ProductType__c)){
                        plans.Name = plans.ASC_ProductName__c;
                    }
                    if(plans.Products_Added_After_Signature__c){
                        ContractId.add(plans.vlocity_ins__ContractId__c);
                    }
                }
                
                if(!ContractId.isEmpty()){
                    
                    List<vlocity_ins__ContractLineItem__c> LineItemQuery = [select Name,id,vlocity_ins__ProductCode__c,
                                                                            Parent_Product_Code__c,ASC_ProductName__c,
                                                                            Products_Added_After_Signature__c  from 
                                                                            vlocity_ins__ContractLineItem__c
                                                                            where vlocity_ins__ContractId__c in :ContractId
                                                                            LIMIT :UTIL_SLB.retrieveQueryLimitValue()];
                    
                    if(!LineItemQuery.isEmpty()){                                                 
                        for(vlocity_ins__ContractLineItem__c ContractLineItem: LineItemQuery)
                        {
                            DoctypeMap.put(ContractLineItem.vlocity_ins__ProductCode__c ,ContractLineItem);
                        }
                    }                                
                }
                
                for(vlocity_ins__ContractLineItem__c ContractLineItem : PlnList){
                    
                    if(DoctypeMap.containsKey(ContractLineItem.vlocity_ins__ProductCode__c) 
                       && ContractLineItem.Products_Added_After_Signature__c)
                    {
                        ContractLineItem.addError('You can not add this product because it is already part of this contract. ');
                    }
                }       
            } 
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1);        
        }
    }
    
    /*******************************************************************************************************************************
@Description        :   afterInsert() method 
@Name               :   afterInsert
@Param              :   list<vlocity_ins__ContractLineItem__c> cLIList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/   
    public static void afterInsert(list<vlocity_ins__ContractLineItem__c> plnList){        
        try{
            if(!plnList.isEmpty()){
                for(vlocity_ins__ContractLineItem__c cLI:plnList){
                    if(cLI.Products_Added_After_Signature__c){               
                        ASC_PlanTriggerHelper.createPlan(plnList);
                        
                    }               
                }
                
            }
            
            
            /*US-3625 -Added By Dinesh -  after update - This class is used to create/update the Status History Tracking records when there is an update on
Contract - Status, Invoice Setup ,Signature Status
Opportunity - StageName , Sub Stage
Quote - Status
Plan - Activation Status*/                   
            Id contractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get(ASC_CONTRACT).getRecordTypeId();
            
            List<vlocity_ins__ContractLineItem__c> newplanList = new List<vlocity_ins__ContractLineItem__c>();
            Set<Id> contractIdSet = new Set<Id>();
            if(!plnList.isEmpty()){
                for(vlocity_ins__ContractLineItem__c pln:plnList){
                    contractIdSet.add(pln.vlocity_ins__ContractId__c);
                }
            }
            
            Map<Id,Contract> contractrecTypeMap = new Map<Id,Contract>([Select Id,RecordTypeId from Contract where Id IN:contractIdSet 
                                                                        LIMIT :UTIL_SLB.retrieveQueryLimitValue()]);
            
            
            if(!plnList.isEmpty()){
                for(vlocity_ins__ContractLineItem__c pln:plnList){ //vlocity_ins__ContractId__c
                    if(contractrecTypeMap.ContainsKey(pln.vlocity_ins__ContractId__c) 
                       && contractrecTypeMap.get(pln.vlocity_ins__ContractId__c).RecordTypeId !=null
                       && contractRecordTypeId.equals(contractrecTypeMap.get(pln.vlocity_ins__ContractId__c).RecordTypeId)){                                          
                           
                           newplanList.add(pln);
                       }    
                }           
            }
            
            if(!ASC_StatusHistoryTracking.isExecuting){
                ASC_StatusHistoryTracking.isExecuting = true;
                if(!newplanList.isEmpty()){
                    ASC_StatusHistoryTracking.createUpdateStatusHistoryTracking(newplanList,null,PLANOBJNAME);
                }
            }
            
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME2);           
        }
    }
    
    /*******************************************************************************************************************************
@Description        :   afterUpdate() method 
@Name               :   afterUpdate
@Param              :   list<vlocity_ins__ContractLineItem__c> cLIList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/   
    public static void afterUpdate(list<vlocity_ins__ContractLineItem__c> plnList,map<id,vlocity_ins__ContractLineItem__c> plnOldMap){        
        try{              
            
            /*US-3625 -Added By Dinesh -  after update - This class is used to create/update the Status History Tracking records when there is an update on
Contract - Status, Invoice Setup ,Signature Status
Opportunity - StageName , Sub Stage
Quote - Status
Plan - Activation Status*/                   
            Id contractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get(ASC_CONTRACT).getRecordTypeId();
            
            List<vlocity_ins__ContractLineItem__c> newplanList = new List<vlocity_ins__ContractLineItem__c>();
            Map<Id, vlocity_ins__ContractLineItem__c> oldplanMap = new Map<Id, vlocity_ins__ContractLineItem__c>();
            Set<Id> contractIdSet = new Set<Id>();
            if(!plnList.isEmpty()){
                for(vlocity_ins__ContractLineItem__c pln:plnList){
                    contractIdSet.add(pln.vlocity_ins__ContractId__c);
                }
            }
            
            Map<Id,Contract> contractrecTypeMap = new Map<Id,Contract>([Select Id,RecordTypeId from Contract where Id IN:contractIdSet 
                                                                        LIMIT :UTIL_SLB.retrieveQueryLimitValue()]);
            
            if(!plnList.isEmpty()){
                for(vlocity_ins__ContractLineItem__c pln:plnList){ //vlocity_ins__ContractId__c
                    if(contractrecTypeMap.ContainsKey(pln.vlocity_ins__ContractId__c) 
                       && contractrecTypeMap.get(pln.vlocity_ins__ContractId__c).RecordTypeId !=null
                       && contractRecordTypeId.equals(contractrecTypeMap.get(pln.vlocity_ins__ContractId__c).RecordTypeId)){                                          
                           newplanList.add(pln);
                           oldplanMap.put(pln.Id,plnOldMap.get(pln.Id));
                       }    
                }           
            }
            
            if(!ASC_StatusHistoryTracking.isExecuting){
                ASC_StatusHistoryTracking.isExecuting = true;
                if(!newplanList.isEmpty()){
                    ASC_StatusHistoryTracking.createUpdateStatusHistoryTracking(newplanList,oldplanMap,PLANOBJNAME);
                }
            }
            ASC_PlanTriggerHelper.updateLastUpdatedDateonUpdation(plnList);
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME_AFTRUPDT);
        }
    }
}