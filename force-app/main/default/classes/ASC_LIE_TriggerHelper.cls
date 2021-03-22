/****************************************************************************************************************
@Author : Offshore
@Name: ASC_LIE_TriggerHelper is used to implement the logic for the ASC_LIE_TriggerHandler class methods.
@CreatedDate: 14 -July- 2020 
@Description: 
@version : 1.0  
@US3193 - Added By Dinesh- update the LIE RecordType when LIE record is created - 07/14/2020
*****************************************************************************************************************/
public without sharing class ASC_LIE_TriggerHelper {
    public static final string CLASSNAME  ='ASC_LIE_TriggerHelper';
    public static final string METHODNME_UPDTRECTYPE  ='updateLIERecType'; 
    public static final string METHODNME_UPDATEFIELD  ='updateLastUpdatedDateonUpdation';
    public static final string METHODNME_INSERTFIELD  ='updateLastUpdatedDateonCreation'; 
    /*************************************************************************************************************
    @Description        :   This method is used to update the LIE RecordType when LIE record is created.                            
    @Name               :   updateLIERecType
    @Param              :   List<Line_Item_Extension__c> litemExtList
    @Return             :   void
    @throws Exception   :   N/A;    
    *************************************************************************************************************/ 
    public static void updateLIERecType(List<Line_Item_Extension__c> litemExtList) {
        try{        
            Map<Id,Product2> productMap = new Map<Id,Product2>();
            Set<Id> prdIdSet = new Set<Id>();
            if(!litemExtList.isEmpty()){                 
              for(Line_Item_Extension__c litemExtRec:litemExtList){
                prdIdSet.add(litemExtRec.Product__c);
              }   
              if(!prdIdSet.isEmpty()){
                productMap = new Map<Id,Product2>([Select id,ASC_LIE_RecordType__c from Product2 where Id IN:prdIdSet
                                                   Limit :UTIL_SLB.retrieveQueryLimitValue()]);
              }
              for(Line_Item_Extension__c litemExtRec:litemExtList){
                if(productMap.ContainsKey(litemExtRec.Product__c) && 
                   String.isNotBlank(productMap.get(litemExtRec.Product__c).ASC_LIE_RecordType__c)){
                    lItemExtRec.RecordTypeId = Schema.SObjectType.Line_Item_Extension__c.getRecordTypeInfosByDeveloperName().
                                               get(productMap.get(litemExtRec.Product__c).ASC_LIE_RecordType__c).getRecordTypeId();  
                }                  
              }                            
            }             
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNME_UPDTRECTYPE);
        }                    
    }            


    

}