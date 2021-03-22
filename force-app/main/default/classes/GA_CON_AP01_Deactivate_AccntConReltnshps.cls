/*******************************************************************************************************************************
@Author             :   Dilip Junapala
@Name               :   GA_CON_AP01_Deactivate_AccntConReltnshps
@CreatedDate        :   19 - Apr 2018 
@Description        :   GA_CON_AP01_Deactivate_AccntConReltnshps is for performing required logic on insert/update of contact.
@version            :   1.0  
********************************************************************************************************************************/
public without sharing class GA_CON_AP01_Deactivate_AccntConReltnshps {
    public static boolean isExecuting = false;
    public static final string delErrMsg = 'Unable to deactivate Account Contact Relationship :';
    public static final string ClsName  ='GA_CON_AP01_Deactivate_AccntConReltnshps';
    public static final string methodNme  ='deactivateAccountContactRelationships';
    
    /*******************************************************************************************************************************
@Description        :   deactivateAccountContactRelationships() method 
@Name               :   deactivateAccountContactRelationships
@Param              :   list<Contact> cntList, map<id,Contact> cntNewMap,map<id,Contact> cntoldMap
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/
    public static void deactivateAccountContactRelationships(list<Contact> cntList, map<id,Contact> cntNewMap,map<id,Contact> cntoldMap)
    {
        try{
            Set<Id> conIdSet = New Set<Id>();
            Set<Id> conIdSet2 = New Set<Id>();
            List<AccountContactRelation> acnListToUpdate = New List<AccountContactRelation>();
            
            Map<Id,Boolean> contactStatusMap = New  Map<Id,Boolean>();
            
            for(Contact con : cntList){
                if(con.Active__c != cntoldMap.get(con.Id).Active__c){
                    conIdSet.add(con.Id); 
                    contactStatusMap.put(con.Id,con.Active__c);
                }                 
            }
            
            List<AccountContactRelation>  acrLst = [Select Id,IsActive,ContactID from AccountContactRelation Where ContactID IN : contactStatusMap.keyset() Limit 50000];
            
            if(!contactStatusMap.isEmpty()) {
                for(Id conId : contactStatusMap.keyset()){
                    for(AccountContactRelation ar : acrLst){
                        if(ar.contactid == conId){
                            ar.IsActive = contactStatusMap.get(conId);
                            acnListToUpdate.add(ar);
                        }
                    }
                }
            }
            Database.update(acnListToUpdate);
            
        }catch (Exception e){
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            cntList[0].adderror(delErrMsg);
        }
    }
}