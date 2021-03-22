/**
@Author : IDCOffshore
@Name: GA_TerritoryTriggerHandler
@CreatedDate: 1/7/2019
@Description: GA_TerritoryTriggerHandler class is for Territory object.
@version : 1.0  
*/
public without sharing class GA_TerritoryTriggerHandler {
    
    public Static Final string ClsName  ='GA_TerritoryTriggerHandler';
    public Static Final string methodNme  ='beforeupdate';
    public Static Final string methodNme1  ='beforeInsert';
    public Static Final string querybatch = 'Select Id,GA_RetentionSalesRepresentative__c from  GA_Territory__c where id in:idLst';
    /**
@Description: beforeupdate() method 
@Name : beforeupdate
@Param : list<GA_Territory__c > TerritoryLst, map<id,GA_Territory__c > TerritoryOldMap
@Return : void
@throws Exception : N/A;
*/   
    public static void beforeupdate(list<GA_Territory__c > TerritoryLst,
                                   map<id,GA_Territory__c > TerritoryOldMap)
    {
        try
        {
            if(!GA_UpdateAccOwner.isExecuting)
            {
                list<GA_Territory__c> trryListToUpt=new list<GA_Territory__c>();
                for(GA_Territory__c trty : TerritoryLst)
                {
                    if(trty.GA_RetentionSalesRepresentative__c !=null)
                    {
                        trryListToUpt.add(trty);
                    }
                    //Populating GOR Rep old value when GOR rep is changed
                    if((trty.ASC_GOR_Rep__C != TerritoryOldMap.get(trty.id).ASC_GOR_Rep__C) && (trty.ASC_GOR_Rep__c != null))
                    {
                        trty.ASC_Old_GOR_Rep__c = TerritoryOldMap.get(trty.id).ASC_GOR_Rep__C;
                    }
                }
                list<id> gIds = GA_UpdateAccOwner.constructMap(trryListToUpt); 
                
                //if( TerritoryLst.size() == 1){
                   
                    GA_UpdateAccOwner.updtFrmTerrtry(TerritoryLst, TerritoryOldMap);
                //}
            }
           // GA_UpdateAccOwner.updtLiasnRegMangr(TerritoryLst);
            
            GA_Territory_UpdtAccountASR.updtAccASRFrmTerrtry(TerritoryLst,TerritoryOldMap);

        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
        }
    }
        /**
@Description: beforeInsert() method 
@Name : beforeInsert
@Param : list<GA_Territory__c > TerritoryLst
@Return : void
@throws Exception : N/A;
*/ 
   /* public static void beforeInsert(list<GA_Territory__c > TerritoryLst){
        try{
            GA_UpdateAccOwner.updtLiasnRegMangr(TerritoryLst);
           
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme1);
        }
    } */
}