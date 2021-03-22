/****************************************************************************************************************
@Author : Dinesh
@Name: ASC_PlanTriggerHelper
@CreatedDate: 20-Aug-2020 
@Description: ASC_PlanTriggerHelper class is used to support the ASC_PlanTriggerHandler class
@version : 1.0  
****************************************************************************************************************/
public with sharing class ASC_PlanTriggerHelper {
    private static final string STR_EMPTY = '';
    private static final string EXTENDEDCARESUITE_PRDCODE = 'ASC_0000401';
    public static final string CLSNAME  ='ASC_PlanTriggerHelper';
    public static final string METHODNME  ='createPlan';
    public static final string METHODNME1 ='createLie';
    public static final string SIGNED ='Signed';
    public static final string METHODNME_UPDATEFIELD  ='updateLastUpdatedDateonUpdation';
    public static final string METHODNME_INSERTFIELD  ='updateLastUpdatedDateonCreation'; 
    
    public static Map<String,String> accountNameMap = new Map<String,String>();
    /****************************************************************************************************************
@Description        :   This method is used to to create plan object record.                            
@Name               :   createPlan
@Param              :   list<vlocity_ins__ContractLineItem__c> cLIList
@Return             :   void        
@US Number          :   US-2909
****************************************************************************************************************/
    public static void createPlan(list<vlocity_ins__ContractLineItem__c> cLIList)
    {     
        Set<String> contractIdSet = new Set<String>();
        Set<String> childCLIidSet = new Set<String>();
        List<vlocity_ins__ContractLineItem__c> childCLIList = new List<vlocity_ins__ContractLineItem__c>();
        Set<String> parentCLIidSet = new Set<String>();
        Set<String> productCodeSet = new Set<String>();
        Map<String,vlocity_ins__ContractLineItem__c> cliParentIdMap = new Map<String,vlocity_ins__ContractLineItem__c>();
        List<vlocity_ins__ContractLineItem__c> cLIListToUpdate = new List<vlocity_ins__ContractLineItem__c>();
        vlocity_ins__ContractLineItem__c cLIins = new vlocity_ins__ContractLineItem__c();
        Map<String,vlocity_ins__ProductChildItem__c> prdCodeMap = new Map<String,vlocity_ins__ProductChildItem__c>();        
        List<vlocity_ins__ContractLineItem__c> parentCLIinsert = new List<vlocity_ins__ContractLineItem__c>();
        try
        {          
            //prdCodeMap : Map - Key-Child Product Code , Value vlocity_ins__ProductChildItem__c record.
            for(vlocity_ins__ProductChildItem__c prodCode:[select id,Name,vlocity_ins__ChildProductId__r.Name,
                                                           vlocity_ins__ChildProductId__c,vlocity_ins__ParentProductId__r.Id,
                                                           vlocity_ins__ParentProductId__c,ASC_Child_ProductCode__c,
                                                           vlocity_ins__ParentProductId__r.Productcode,
                                                           vlocity_ins__ParentProductId__r.Name
                                                           from vlocity_ins__ProductChildItem__c
                                                           where vlocity_ins__ParentProductId__r.vlocity_ins__Type__c = 'ASC Product' 
                                                           AND vlocity_ins__ParentProductId__r.isActive = true
                                                           AND vlocity_ins__ChildProductId__r.isActive = true
                                                           AND vlocity_ins__ParentProductId__r.Productcode !=: EXTENDEDCARESUITE_PRDCODE
                                                           LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                                                               prdCodeMap.put(prodCode.ASC_Child_ProductCode__c,prodCode);                                                          
                                                           }
            if(!cLIList.isEmpty()){
                for(vlocity_ins__ContractLineItem__c cLI:cLIList){
                    if(prdCodeMap.ContainsKey(cLI.vlocity_ins__ProductCode__c) && cLI.Products_Added_After_Signature__c){               
                        contractIdSet.add(cLI.vlocity_ins__ContractId__c);
                        childCLIidSet.add(cLI.Id);
                        childCLIList.add(cLI);
                    }               
                }
            }
            if(!contractIdSet.isEmpty()){ //getting all the plans related to Contract Id
                for(vlocity_ins__ContractLineItem__c cliListVal : [Select Id,Name,vlocity_ins__ProductCode__c,
                                                                   vlocity_ins__ContractId__c,
                                                                   vlocity_ins__ContractId__r.Account.Name
                                                                   from vlocity_ins__ContractLineItem__c 
                                                                   where vlocity_ins__ContractId__c IN: contractIdSet
                                                                   Limit :UTIL_SLB.retrieveQueryLimitValue()
                                                                  ]){
                                                                      productCodeSet.add(cliListVal.vlocity_ins__ProductCode__c+'_'+cliListVal.vlocity_ins__ContractId__c);                                                         
                                                                      if(!prdCodeMap.ContainsKey(cliListVal.vlocity_ins__ProductCode__c)){
                                                                          parentCLIidSet.add(cliListVal.Id);
                                                                      }
                                                                      accountNameMap.put(cliListVal.vlocity_ins__ContractId__c,cliListVal.vlocity_ins__ContractId__r.Account.Name);               
                                                                  }
            }
            if(!childCLIList.isEmpty() && !productCodeSet.isEmpty()){
                List<vlocity_ins__ContractLineItem__c> childCLIrecList = [Select id,Name,vlocity_ins__ContractId__r.StartDate,
                                                                          vlocity_ins__ContractId__r.endDate,ASC_Account__c,
                                                                          vlocity_ins__ProductCode__c,vlocity_ins__ContractId__c,
                                                                          vlocity_ins__Quantity__c,ASC_Effective_Start_Date__c,
                                                                          ASC_Effective_End_Date__c,vlocity_ins__Product2Id__r.Productcode
                                                                          from vlocity_ins__ContractLineItem__c where Id IN:childCLIList
                                                                          Limit :UTIL_SLB.retrieveQueryLimitValue()];
                if(!childCLIrecList.isEmpty()){
                    for(vlocity_ins__ContractLineItem__c cLI:childCLIrecList){            
                        String parentPrdCode = STR_EMPTY;
                        if(prdCodeMap.ContainsKey(cLI.vlocity_ins__ProductCode__c)){
                            parentPrdCode = prdCodeMap.get(cLI.vlocity_ins__ProductCode__c).vlocity_ins__ParentProductId__r.Productcode;
                        }
                        if(!productCodeSet.Contains(parentPrdCode+'_'+cLI.vlocity_ins__ContractId__c) 
                           && prdCodeMap.ContainsKey(cLI.vlocity_ins__ProductCode__c)
                           && !prdCodeMap.get(cLI.vlocity_ins__ProductCode__c).vlocity_ins__ParentProductId__r.Productcode.equals(cLI.vlocity_ins__Product2Id__r.Productcode)){
                               cLIins = new vlocity_ins__ContractLineItem__c();
                               cLIins.Products_Added_After_Signature__c =true;
                               cLIins.vlocity_ins__Quantity__c = 1;
                               cLIins.ASC_Effective_Start_Date__c = cLI.vlocity_ins__ContractId__r.StartDate;   
                               cLIins.ASC_Effective_End_Date__c = cLI.vlocity_ins__ContractId__r.endDate;
                               cLIins.vlocity_ins__Product2Id__c =  prdCodeMap.get(cLI.vlocity_ins__ProductCode__c).vlocity_ins__ParentProductId__c;
                               cLIins.vlocity_ins__ContractId__c = cLI.vlocity_ins__ContractId__c;
                               parentCLIinsert.add(cLIins);                    
                           }                
                    }
                }            
                if(!parentCLIinsert.isEmpty()){
                    Insert parentCLIinsert;//parent product Insertion              
                }
                if(!parentCLIinsert.isEmpty()){
                    for(vlocity_ins__ContractLineItem__c cLIParent:[Select Id,Name,ASC_Account__c,vlocity_ins__ProductCode__c
                                                                    from vlocity_ins__ContractLineItem__c where Id IN:parentCLIinsert
                                                                    LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                                                                        cliParentIdMap.put(cLIParent.vlocity_ins__ProductCode__c,cLIParent);
                                                                    }      
                }
                else{
                    for(vlocity_ins__ContractLineItem__c cLIexistingParentRecord:[Select Id,Name,ASC_Account__c,vlocity_ins__ProductCode__c
                                                                                  from vlocity_ins__ContractLineItem__c where Id IN:parentCLIidSet
                                                                                  LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                                                                                      cliParentIdMap.put(cLIexistingParentRecord.vlocity_ins__ProductCode__c,cLIexistingParentRecord);
                                                                                  }            
                }
                if(!childCLIList.isEmpty()){
                    Map<String,String> lieIdMap = createLie(childCLIList);
                    for(vlocity_ins__ContractLineItem__c cLI:[Select Id,Name,ASC_Effective_End_Date__c,
                                                              ASC_Account__c,ASC_Effective_Start_Date__c,vlocity_ins__Quantity__c,
                                                              vlocity_ins__AccountId__c,vlocity_ins__Product2Id__c,
                                                              vlocity_ins__ProductCode__c,vlocity_ins__ParentItemId__c,
                                                              vlocity_ins__ProductName__c
                                                              from vlocity_ins__ContractLineItem__c where Id IN:childCLIList
                                                              LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                                                                  if(prdCodeMap.ContainsKey(cLI.vlocity_ins__ProductCode__c) 
                                                                     && cliParentIdMap.ContainsKey(prdCodeMap.get(cLI.vlocity_ins__ProductCode__c).vlocity_ins__ParentProductId__r.ProductCode)){                           
                                                                         cLI.vlocity_ins__ParentItemId__c = cliParentIdMap.get(prdCodeMap.get(cLI.vlocity_ins__ProductCode__c).vlocity_ins__ParentProductId__r.ProductCode).Id;                                                                                 
                                                                         cLI.ASC_Line_Item_Extension__c = lieIdMap.ContainsKey(cLI.vlocity_ins__Product2Id__c)?lieIdMap.get(cLI.vlocity_ins__Product2Id__c):STR_EMPTY; // Updating LIE record Id on CLI
                                                                         cLIListToUpdate.add(cLI);
                                                                     }                
                                                              }                
                }
                if(!cLIListToUpdate.isEmpty()){
                    Update cLIListToUpdate;
                }
            } 
        }catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    }
    /************************************************************************************************************
@Description        :   This method is used to to create LIE object record and associate to CLI record                           
@Name               :   createLie
@Param              :   list<vlocity_ins__ContractLineItem__c> childCLIList
@Return             :   Map<String,String>    
@US Number          :   US-2909
***********************************************************************************************************/
    public static Map<String,String> createLie(list<vlocity_ins__ContractLineItem__c> childCLIList){ 
        List<Line_Item_Extension__c> lieListToInsert = new List<Line_Item_Extension__c>();
        Map<String,String> lieIdMap = new Map<String,String>();
        try{
            if(!childCLIList.isEmpty()){
                for(vlocity_ins__ContractLineItem__c cLI:childCLIList){
                    Line_Item_Extension__c lie = new Line_Item_Extension__c();
                    lie.Name = cLI.Name;
                    lie.Account__c = accountNameMap.get(cLI.vlocity_ins__ContractId__c); 
                    lie.Product__c = cLI.vlocity_ins__Product2Id__c;
                    lie.Effective_Start_Date__c = cLI.ASC_Effective_Start_Date__c;  
                    lie.Effective_End_Date__c = cLI.ASC_Effective_End_Date__c;
                    lie.Quantity__c=cLI.vlocity_ins__Quantity__c;
                    lie.Plan_ID__c=cLI.Id;
                    lie.LOU_Signed__c=SIGNED;//added US-4126
                    lieListToInsert.add(lie);            
                }
            }
            if(!lieListToInsert.isEmpty()){
                insert lieListToInsert;
                for(Line_Item_Extension__c lie:[Select Id,Product__c from Line_Item_Extension__c 
                                                where Id IN:lieListToInsert
                                                LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                                                    lieIdMap.put(lie.Product__c,lie.Id);
                                                }
            }
        }catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1);
        }
        return lieIdMap;
    }
    
    /**************************************************************************************************************
@Description: Update ASC_Last_Updated_Date__c field on line item extension.
@Name : updateLastUpdatedDateonUpdation
@Param :list<vlocity_ins__ContractLineItem__c> planLst
@Return : void
@throws Exception : N/A;
@Defect:D-1964
**************************************************************************************************************/     
    public static void updateLastUpdatedDateonUpdation(list<vlocity_ins__ContractLineItem__c> planLst)
    {
        try{
            Map<String,Line_Item_Extension__c> lineItemToUpdate = new Map<String,Line_Item_Extension__c>();
            
            if(!planLst.isEmpty()){
                
                
                
                if(!planLst.isEmpty()){
                    
                    for(vlocity_ins__ContractLineItem__c plan:planLst){
                        Line_Item_Extension__c lie = new Line_Item_Extension__c();
                        lie.Id = plan.ASC_Line_Item_Extension__c;
                     	lie.ASC_Last_Updated_Date__c = plan.LastModifiedDate;
                        if(lie.Id != null){
                            lineItemToUpdate.put(lie.Id+'_'+plan.Id,lie);
                        }
                        
                    }                          
                }
                
                if(!lineItemToUpdate.isEmpty()){
                    
                    Update lineItemToUpdate.Values();
                    
                }
            }
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME,METHODNME_UPDATEFIELD );
        }  
    }
}