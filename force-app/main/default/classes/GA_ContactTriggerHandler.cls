/*******************************************************************************************************************************

@Author : Dilip Junapala

@Name: GA_ContactTriggerHandler

@CreatedDate: 19 - Apr 2018

@Description: GA_ContactTriggerHandler class is for creating/updating records When Contact is changed.

@version : 1.0

********************************************************************************************************************************/

public with sharing class GA_ContactTriggerHandler {
    
    public static final String ClsName  ='GA_ContactTriggerHandler';
    
    public static final String methodNmeafterupdate  ='afterupdate';
    
    public static final String methodNamebeforeInsert  ='beforeInsert';
    
    public static final String methodNamebeforeUpdate  ='beforeUpdate';
    
    public static Integer cntlckLimit=Integer.valueof(system.label.GA_Contact_Lock_Limit);
    
    /*******************************************************************************************************************************

@Description        :   beforeInsert() method

@Name               :   afterupdate

@Param              :   list<Contact> cntList

@Return             :   void

@throws Exception   :   N/A;

********************************************************************************************************************************/
    
    public static void beforeInsert(list<Contact> cntList)
        
    {
        
        try
            
        {
            
            if(!GA_CON_AP01_Owner_Update.isExecuting ) {
                
                GA_CON_AP01_Owner_Update.isExecuting = true;
                
                GA_CON_AP01_Owner_Update.updateContactOwner(cntList);
                
            }
            
            for(Contact contactrec:cntList) {
                
                if(String.isNotBlank(contactrec.vlocity_ins__Type__c)) {
                    
                    contactrec.Updated_Contact_Type__c=contactrec.vlocity_ins__Type__c;
                    
                }
                
            }
            
        }
        
        catch(exception e)
            
        {
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNamebeforeInsert);
            
        }
        
    }
    
    /*******************************************************************************************************************************

@Description        :   beforeUpdate() method

@Name               :   beforeUpdate

@Param              :   list<Contact> cntList, map<id,Contact> cntNewMap,map<id,Contact> cntoldMap

@Return             :   void

@throws Exception   :   N/A;

********************************************************************************************************************************/
    
    public static void beforeUpdate(list<Contact> cntList, map<id,Contact> cntoldMap)
        
    {
        set<id> contactid = New set<id>();
        try
        {
            if(!GA_CON_AP01_Owner_Update.isExecuting && !GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch) {
                GA_CON_AP01_Owner_Update.isExecuting = true;
                GA_CON_AP01_Owner_Update.updateContactOwnerOnAccChange(cntList, cntoldMap);
            }
            for(Contact contactrec:cntList) {
                Contact oldContact= cntoldMap.get(contactrec.id);
                if(String.isNotBlank(contactrec.vlocity_ins__Type__c) && oldContact !=null && String.isNotBlank(oldContact.vlocity_ins__Type__c) && contactrec.vlocity_ins__Type__c != oldContact.vlocity_ins__Type__c) {
                    contactrec.Updated_Contact_Type__c=oldContact.vlocity_ins__Type__c;
                }else if(String.isNotBlank(contactrec.vlocity_ins__Type__c)) {
                    contactrec.Updated_Contact_Type__c=contactrec.vlocity_ins__Type__c;
                }
                if ((contactRec.vlocity_ins__Type__c == 'Agent' || cntoldMap.get(contactRec.id).vlocity_ins__Type__c == null ) &&  (cntoldMap.get(contactRec.id).vlocity_ins__Type__c == 'Agent and Delegate'|| cntoldMap.get(contactRec.id).vlocity_ins__Type__c == 'Delegate')  ){
                    contactRec.Batch_Action_Flag__c='Updated to Agent';
                    
                }
                else if (((contactRec.vlocity_ins__Type__c == 'Agent and Delegate' || contactRec.vlocity_ins__Type__c == 'Delegate')|| cntoldMap.get(contactRec.id).vlocity_ins__Type__c == null)  &&  cntoldMap.get(contactRec.id).vlocity_ins__Type__c == 'Agent') {
                    contactRec.Batch_Action_Flag__c= 'Updated to DA';
                }
                
            }
            
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNamebeforeUpdate);
        }
    }
    
    /*******************************************************************************************************************************

@Description        :   afterupdate() method

@Name               :   afterupdate

@Param              :   list<Contact> cntList, map<id,Contact> cntNewMap,map<id,Contact> cntoldMap

@Return             :   void

@throws Exception   :   N/A;

********************************************************************************************************************************/
    
    public static void afterupdate(list<Contact> cntList, map<id,Contact> cntNewMap,map<id,Contact> cntoldMap)
        
    {
        
        try
            
        {
            
            if(cntList.size()<cntlckLimit)
                
            {
                
                if(!GA_CON_AP01_Deactivate_AccntConReltnshps.isExecuting ) {
                    
                    GA_CON_AP01_Deactivate_AccntConReltnshps.isExecuting = true;
                    
                    GA_CON_AP01_Deactivate_AccntConReltnshps.deactivateAccountContactRelationships(cntList, cntNewMap, cntoldMap );
                    
                }
                
            }
            
            
        }
        
        catch(exception e)
            
        {
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterupdate);
            
        }
        
    }
    
    
    /*******************************************************************************************************************************

@Description        :   afterinsert() method

@Name               :   afterinsert

@Param              :   list<Contact> cntList, map<id,Contact> cntNewMap

@Return             :   void

@throws Exception   :   N/A;

********************************************************************************************************************************/
    
    public static void afterinsert(list<Contact> cntList, map<id,Contact> cntNewMap)
        
    {
        
        try
            
        {
            
            list<Contact> delegatecontactList = new List<Contact>();
            
            for (Contact contactRec : cntList) {
                
                if (contactRec.vlocity_ins__Type__c == 'Delegate Agent') {
                    
                    delegatecontactList.add(contactRec);
                    
                }
                
            }
            
            
        }
        
        catch(exception e)
            
        {
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterupdate);
            
        }
        
    }
    
/*******************************************************************************************************************************
@Description        :   afterinsert() method
@Name               :   afterinsert
@Param              :   list<Contact> cntList, map<id,Contact> cntNewMap
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/
  public static void checkExistingContactsForDuplicate(list<Contact> lstCont)
    {
        try{
            if(GA_AP_ASEPRecordMatchCls.duplicateChecker){
                List<String> contactData = new List<String>();
                Set<String> setContactString = new Set<String>();
                Set<Id> setAccId = new Set<Id>();
                
                for(Contact objCon : lstCont){
                    if(objCon.AccountId != null){
                        setContactString.add(objCon.FirstName+'-'+objCon.LastName+'-'+objCon.AccountId+'-'+objCon.GA_Account_CID__c);
                        setAccId.add(objCon.AccountId);
                    }
                }
                if(setAccId.size() > 0){
                    for(Contact objCon:[SELECT Id, FirstName, LastName, Title, AccountId, GA_Account_CID__c
                                        FROM Contact 
                                        WHERE AccountId IN :setAccId]){
                            if(setContactString.contains(objCon.FirstName+'-'+objCon.LastName+'-'+objCon.AccountId+'-'+objCon.GA_Account_CID__c)){
                                String s = objCon.Id+': '+objCon.FirstName+' '+objCon.LastName;
                                contactData.add(s);
                            }
                    }
                }
                if(contactData.size() > 0){
                    system.assertEquals(0, contactData.size(), 'Duplicate Contact detected - ' +contactData);
                }else{
                    return;
                }
            }else return;     
        }catch(exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, 'checkExistingContactsForDuplicate');
        }
    }
}