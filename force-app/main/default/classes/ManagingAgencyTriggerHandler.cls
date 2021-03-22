/**
@Author : Rahul
@Name: ManagingAgencyTriggerHandler
@CreatedDate: 10 - Mar 2020 
@Description: Handler class for ManagingAgencyTrigger to handle update ManagingAgencyHistory when there is an EndDate update.
@version : 1.0  
*/ 
////Implemented as part of US-1633
public class ManagingAgencyTriggerHandler
{
    public static void updateMAHEndDate(List<Managing_Agency__c> lstMA, Map<Id, Managing_Agency__c> oldMap)
    {
        List<Id> lstMAIds = new List<Id>(); 
        List<Managing_Agency__c> lstUpdatedMAs = new List<Managing_Agency__c>();
        Map<Id, Set<Id>> mapMAId_setGSIds = new Map<Id, Set<Id>>();
        Map<Id, GA_Managing_Agency_History__c> mapGSId_lstMAH = new Map<Id, GA_Managing_Agency_History__c>();
        List<GA_Managing_Agency_History__c> lstMAHForUpdate = new List<GA_Managing_Agency_History__c>();
        Set<Id> gsIds = new Set<Id>();
        
        List<Id> lstMAServicingDateUpdatedIds = new List<Id>(); // US 3339 
        List<Id> lstMAOverrideDateUpdatedIds = new List<Id>(); // US 3339
        List<Id> lstMAOverrideStartDateUpdatedIds = new List<Id>(); // D 1880
        List<Id> lstMAStartDateUpdatedIds = new List<Id>(); // D 1880
        
        //To identifying MA Servicing End_Date updated Managing_Agency records.
        for(Managing_Agency__c objMA :  lstMA)
        {
            if(objMA.End_Date__c != oldMap.get(objMA.Id).End_Date__c && objMA.End_Date__c != null)
            {
                lstMAIds.add(objMA.Id);  
                lstUpdatedMAs.add(objMA);
                lstMAServicingDateUpdatedIds.add(objMA.Id);
            }
            // Added for US 3339
            // To identifying MA Override End_Date updated Managing_Agency records.
            if(objMA.MA_Override_End_Date__c != oldMap.get(objMA.Id).MA_Override_End_Date__c && objMA.MA_Override_End_Date__c != null)
            {
                if(!lstMAIds.contains(objMA.Id)){
                    lstMAIds.add(objMA.Id);  
                	lstUpdatedMAs.add(objMA);
                }
                lstMAOverrideDateUpdatedIds.add(objMA.Id);
            } // End US 3339
            // Added for D 1880
            if(objMA.MA_Override_Start_Date__c != oldMap.get(objMA.Id).MA_Override_Start_Date__c && objMA.MA_Override_Start_Date__c != null)
            {
                if(!lstMAIds.contains(objMA.Id)){
                    lstMAIds.add(objMA.Id);  
                	lstUpdatedMAs.add(objMA);
                }
                lstMAOverrideStartDateUpdatedIds.add(objMA.Id);
            }
            if(objMA.Start_Date__c != oldMap.get(objMA.Id).Start_Date__c && objMA.Start_Date__c != null)
            {
                if(!lstMAIds.contains(objMA.Id)){
                    lstMAIds.add(objMA.Id);  
                	lstUpdatedMAs.add(objMA);
                }
                lstMAStartDateUpdatedIds.add(objMA.Id);
            } // End D 1880
        } 
        
        if(lstMAIds.size() > 0)
        {
            for(Managing_Agency_Group_Segment__c objMAGS : [SELECT Id, Managing_Agency__c, Group_Segment__c  FROM Managing_Agency_Group_Segment__c WHERE Managing_Agency__c IN: lstMAIds])          
            {
                if(!mapMAId_setGSIds.containsKey(objMAGS.Managing_Agency__c))
                {
                    gsIds.add(objMAGS.Group_Segment__c);
                    mapMAId_setGSIds.put(objMAGS.Managing_Agency__c, gsIds);
                }
                else
                {
                    gsIds = mapMAId_setGSIds.get(objMAGS.Managing_Agency__c);
                    gsIds.add(objMAGS.Group_Segment__c);
                    mapMAId_setGSIds.put(objMAGS.Managing_Agency__c,  gsIds);
                }
            }
        }
        System.debug('====mapMAId_setGSIds.size==='+mapMAId_setGSIds.size());
        
        if(mapMAId_setGSIds.size() > 0)
        {
            // Updated SOQL for US 3339 & D1880
            for(GA_Managing_Agency_History__c objMAH : [SELECT Id, GA_Group_Segment__c, GA_Start_Date__c, GA_End_Date__c, MA_Override_End_Date__c, MA_Override_Start_Date__c FROM GA_Managing_Agency_History__c WHERE GA_Group_Segment__c IN :gsIds order by GA_End_Date__c desc])
            {
                if(!mapGSId_lstMAH.containsKey(objMAH.GA_Group_Segment__c))
                {
                    mapGSId_lstMAH.put(objMAH.GA_Group_Segment__c, objMAH);
                    
                    continue; 
                }
            }
        }
        
        for(Managing_Agency__c objMA : lstUpdatedMAs)
        {
            if(mapMAId_setGSIds.containsKey(objMA.Id))
            {
               for(Id objGSId : mapMAId_setGSIds.get(objMA.Id))
                {
                   if( mapGSId_lstMAH.containsKey(objGSId) )
                   {
                       GA_Managing_Agency_History__c objMAH = mapGSId_lstMAH.get(objGSId);
                       if(lstMAServicingDateUpdatedIds.contains(objMA.Id)){
                           objMAH.GA_End_Date__c = objMA.End_Date__c;
                       }
						                       
                       if(lstMAOverrideDateUpdatedIds.contains(objMA.Id)){ // Added for US 3339
                           objMAH.MA_Override_End_Date__c = objMA.MA_Override_End_Date__c; 
                       }
                       
                       if(lstMAOverrideStartDateUpdatedIds.contains(objMA.Id)){ // Added for D 1880
                           objMAH.MA_Override_Start_Date__c = objMA.MA_Override_Start_Date__c; 
                       }
                       if(lstMAStartDateUpdatedIds.contains(objMA.Id)){
                           objMAH.GA_Start_Date__c = objMA.Start_Date__c; 
                       } // End D 1880
                       
                       lstMAHForUpdate.add(objMAH);
                    }
                }
            }
        }
        System.debug('====lstMAHForUpdate====='+lstMAHForUpdate);
        if(lstMAHForUpdate.size() > 0)
        {
            update lstMAHForUpdate;
        }
    }
    
    //Implemented as part of US-1633
    public static void updateMAName(List<Managing_Agency__c> lstMA)
    {
        Set<Id> setAccIds =  new Set<Id>();
        for(Managing_Agency__c objMA : lstMA)
        {
            if(objMA.Account__c != null && objMA.Mng_Agency_Acc_Filter__c != null)
            {
                setAccIds.add(objMA.Account__c);
            	setAccIds.add(objMA.Mng_Agency_Acc_Filter__c);
            }
        }
        Map<Id,Account> mapAccId_Acc= new Map<Id,Account>();
        if(setAccIds!=null)
        {
        	mapAccId_Acc = new Map<Id,Account>([SELECT Id, Name FROM Account WHERE ID IN :setAccIds]);  
        }
          
        for(Managing_Agency__c objMA : lstMA)
        {
            if(mapAccId_Acc.containsKey(objMA.Account__c) && mapAccId_Acc.containsKey(objMA.Mng_Agency_Acc_Filter__c))
            {
                objMA.Name = mapAccId_Acc.get(objMA.Account__c).Name+'-'+mapAccId_Acc.get(objMA.Mng_Agency_Acc_Filter__c).Name; 
            } 
        }
    }
    
    //Implemented as part of US-2728
    public static void updateMAEndDate(List<Managing_Agency__c> lstMA)
    {
        Set<Id> setAccId = new Set<Id>();
        Map<Id, Managing_Agency__c> mapAccId_MA = new Map<Id, Managing_Agency__c>();
        List<Managing_Agency__c> lstMAForUpdate = new List<Managing_Agency__c>();
        Date endDate = Date.newInstance(2200, 1, 1);
        
        for(Managing_Agency__c objMA :  lstMA)
        {
            if(objMA.Account__c != null && objMA.Mng_Agency_Acc_Filter__c != null)
            {
                setAccId.add(objMA.Account__c);
                mapAccId_MA.put(objMA.Account__c, objMA);
            }
        }
        for(Account objAcc : [SELECT Id, Name, (SELECT Id, Name, Start_Date__c, End_Date__c, MA_Override_End_Date__c, MA_Override_Start_Date__c FROM Managing_Agencies__r WHERE  End_Date__c=:endDate OR MA_Override_End_Date__c =:endDate) FROM Account WHERE Id IN : setAccId])
        {
           for(Managing_Agency__c objMA : objAcc.Managing_Agencies__r)
           {
               if(mapAccId_MA.containsKey(objAcc.Id))	
               {
                   if(objMA.Id != mapAccId_MA.get(objAcc.Id).Id)
                   {
                       if(objMA.End_Date__c == endDate){
                           objMA.End_Date__c =   mapAccId_MA.get(objAcc.Id).Start_Date__c - 1;
                       }
                       // US 3339
                       if(objMA.MA_Override_End_Date__c == endDate){
                           objMA.MA_Override_End_Date__c =   mapAccId_MA.get(objAcc.Id).MA_Override_Start_Date__c - 1;
                       }
                       
                       lstMAForUpdate.add(objMA);	    
                   }
               }
           }
        }
        System.debug('====lstMAForUpdate===='+lstMAForUpdate.size());
        if(lstMAForUpdate.size() > 0)
        {
            update lstMAForUpdate;
        }
    }
}