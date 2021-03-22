/**
@Author : PadmaHaarika Jayana
@Name: GA_AgenRelationTriggerhndlr
@CreatedDate: 31 - Jul 2017 
@Description: GA_AgentRelationTriggerhndlr class is for creating/updating AgencyRelationship 
is changed
@version : 1.0  
*/
public with sharing class GA_AgentRelationTriggerhndlr{
    public static final string ErrorMsg = 'Unable to create or update AgentRelation record';
    public static final string ClsName  ='GA_AgentRelationTriggerhndlr';
    public static final string arAfterinsert  ='afterinsert';
    public static final string arAfterupdate  ='afterupdate';
    public static final string arAfterdelete  ='afterdelete';
    public static final string qryUpdtePltnm='Select id,GA_Agency__c,GA_Account__c from GA_AgencyRelationship__c where id in:idLst and isDeleted = true ALL ROWS';
    
    
    /**
@Description: afterinsert() method 
@Name : afterinsert
@Param : list<GA_AgencyRelationship__c> arList, map<id,GA_AgencyRelationship__c> arNewMap  
@Return : void
@throws Exception : N/A;
*/ 
    public static void afterinsert(list<GA_AgencyRelationship__c> arList, map<id,GA_AgencyRelationship__c> arNewMap)
    {
        try
        {
            list<GA_AgencyRelationship__c> agencyRelLst=new list<GA_AgencyRelationship__c>();
            for(GA_AgencyRelationship__c agncyRel:arList)
            {
                
                if(agncyRel.GA_Is_Active__c)
                {
                    agencyRelLst.add(agncyRel);
                }
            }
            if(!GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting ){
                GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting = true;
                GA_AR_AP01_UpdatePlatinumStatusOnAccount.createAgencyRelation(agencyRelLst, arNewMap);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, arAfterinsert);
            arList[0].adderror(ErrorMsg);
        }
        
    }
    /**
@Description: afterupdate() method 
@Name : afterupdate
@Param : list<GA_AgencyRelationship__c> arList, map<id,GA_AgencyRelationship__c> arNewMap,map<id,GA_AgencyRelationship__c> arOldMap 
@Return : void
@throws Exception : N/A;
*/ 
    public static void afterupdate(list<GA_AgencyRelationship__c> arList, map<id,GA_AgencyRelationship__c> arNewMap,map<id,GA_AgencyRelationship__c> arOldMap )
    {
        try
        {
            if(!system.isBatch())
            {
                GA_AgencyRelationship__c agncyRelOld;
                list<GA_AgencyRelationship__c> agencyRelLst=new list<GA_AgencyRelationship__c>();
                map<id,GA_AgencyRelationship__c> agencyRelOldMap=new map<id,GA_AgencyRelationship__c>();
                list<id> agencyIds=new list<id>();
                for(GA_AgencyRelationship__c agncyRel:arList)
                {
                    agncyRelOld=arOldMap.get(agncyRel.Id);
                    if(agncyRelOld.GA_Is_Active__c !=agncyRel.GA_Is_Active__c)
                    {
                        agencyRelLst.add(agncyRel);
                        agencyRelOldMap.put(agncyRelOld.Id,agncyRelOld);
                        agencyIds.add(agncyRel.Id);
                    }
                }
                if(agencyRelLst.size()<=100 && agencyRelLst.size()>0)
                {
                    if(!GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting ){
                        GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting = true;
                        GA_AR_AP01_UpdatePlatinumStatusOnAccount.createAgencyRelation(agencyRelLst, arNewMap);
                    }   
                } 
            }
            
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, arAfterupdate);
            arList[0].adderror(ErrorMsg);
        }
    }
    
    /**
@Description: afterdelete() method 
@Name : afterdelete
@Param : list<GA_AgencyRelationship__c> arList, map<id,GA_AgencyRelationship__c> arNewMap,map<id,GA_AgencyRelationship__c> arOldMap 
@Return : void
@throws Exception : N/A;
*/ 
    public static void afterdelete(list<GA_AgencyRelationship__c> arList,map<id,GA_AgencyRelationship__c> arOldMap )
    {
        try
        {
            list<id> agencyIds=new list<id>();
            for(GA_AgencyRelationship__c agncyRel:arList)
            {
                agencyIds.add(agncyRel.Id);
            }
            if(arList.size()<=100 && arList.size()>0)
            {
                if(!GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting ){
                    GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting = true;
                    GA_AR_AP01_UpdatePlatinumStatusOnAccount.createAgencyRelation(arList, arOldMap);
                } 
            }
            else
            {
                if(!system.isBatch())
                {
                    GA_AR_AP_UpdatePlatinumStatusBatchCls updtePltnumrBatch=new GA_AR_AP_UpdatePlatinumStatusBatchCls(qryUpdtePltnm,agencyIds, arOldMap,arList);
                    ID updtePltnumrBatchrbatchprocessid = Database.executeBatch(updtePltnumrBatch,200);   
                }
                
            }
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, arAfterdelete);
            arList[0].adderror(ErrorMsg);
        }
    }
}