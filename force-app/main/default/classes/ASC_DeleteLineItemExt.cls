/********************************************************************************************************
@Author : ASC Team
@Name: ASC_DeleteLineItemExt
@CreatedDate: 24 -Sep 2020
@version : 1.0
**********************************************************************************************************/
public without sharing class ASC_DeleteLineItemExt{
               public static final string ASC_QUOTE  ='ASC_Quote';    

               public  static void deleteLineitemExt(list<Quotelineitem> qliOldMap){
                                
                   Set<String> lieIDSet = new Set<String>();
                   Set<String> lieIDSet_CLI = new Set<String>();
                   List<Line_Item_Extension__c> deleteLIEList = new List<Line_Item_Extension__c>();
                   Set<Id> qtIdSet = new Set<Id>();
                   Id quoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get(ASC_QUOTE).getRecordTypeId();

                   
                   for(Quotelineitem qli :qliOldMap){            
                         qtIdSet.add(qli.QuoteId);
                   }
                   
                   Map<Id,Quote> qtRecordTypeMap = new Map<Id,Quote>([Select Id,RecordTypeId from Quote where Id IN:qtIdSet   Limit :UTIL_SLB.retrieveQueryLimitValue()]);
                  
                   for(Quotelineitem qli :qliOldMap){            
                       if(qtRecordTypeMap.ContainsKey(qli.QuoteId) && quoteRecordTypeId.equals(qtRecordTypeMap.get(qli.QuoteId).RecordTypeId)){
                         lieIDSet.add(qli.ASC_Line_Item_Extension__c);             
                       }
                   }
                   
                   if(!lieIDSet.isEmpty()){                                                                                                                                                               
                       for(vlocity_ins__ContractLineItem__c listplan : [SELECT id, ASC_Line_Item_Extension__c FROM vlocity_ins__ContractLineItem__c 
                                                                        WHERE ASC_Line_Item_Extension__c IN:lieIDSet AND ASC_Line_Item_Extension__c !=NULL   Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                                       lieIDSet_CLI.add(listplan.ASC_Line_Item_Extension__c);                                   
                       }
                   }
                  
                   
                   if(!lieIDSet.isEmpty()){
                       for(Line_Item_Extension__c lIE:[Select Id from Line_Item_Extension__c where ID IN:lieIDSet   Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                                     
                                      if(!lieIDSet_CLI.Contains(lIE.Id)){
                                                    deleteLIEList.add(lIE);
                                      } 
                           
                       }
                   }
                   if(!deleteLIEList.isEmpty()){
                   delete deleteLIEList;
                   }              
                }  
}