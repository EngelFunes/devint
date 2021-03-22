/**
@Author : Dilip
@Name: GA_GroupSegmentTriggerHandler
@CreatedDate: 8 - June 2018 
@Description: GA_GroupSegmentTriggerHandler class is for Group Segment object.
@version : 1.0  
*/
public with sharing class GA_GroupSegmentTriggerHandler {
    public static Boolean isTriggerExecuted = true;
    
    public static final string CLSNAME  ='GA_GroupSegmentTriggerHandler';
    public static final string METHODNME  ='beforeInsert';
    public static final string METHODNME1  ='beforeUpdate';
    public static final string METHODNME2  ='afterInsert';
    public static final string METHODNME3  ='afterUpdate';
    public static final string METHODNAME4 ='updateWFProcess';
    public static final string METHODNAME5 ='updateAgencyOnAccount';
    public static final string METHODNAME6 ='createMAH';
    public static final string QUERYBATCH = 'select id,GA_Physical_City_Other__c,GA_Mailing_City_Other__c ,GA_Billing_City_Other__c,GA_Physical_City__c,'+
        'GA_Billing_City__c,GA_Mailing_City__c, GA_Physical_City__r.Name,GA_Billing_City__r.Name,GA_Mailing_City__r.Name,'+
        'GA_Billing_Address_1__c,GA_Billing_State__c,GA_Billing_County_Id__c, GA_Billing_Zip__c,GA_Physical_Address_1__c,'+
        'GA_Physical_State__c, GA_Physical_County_Id__c,GA_Physical_Zip__c,GA_Mailing_Address_1__c,GA_Mailing_State__c,'+
        'GA_Mailing_County_Id__c,GA_Mailing_Zip__c ,GA_Copy_Address_From__c,GA_Billing_Address_2__c,GA_Billing_Address_3__c,'+
        'GA_Physical_Address_2__c,GA_Physical_Address_3__c,GA_Mailing_Address_2__c,GA_Mailing_Address_3__c from GA_Group_Segment__c where id in:idLst';
    public static integer BATCHLIMIT=Integer.valueof(system.label.GA_GSAddressUpdateLimit);
    public static integer STSBATCHLMT=Integer.valueof(system.label.GA_GSStatusUpdateLimit);
    public static final string QRYGS ='Select id,Name,Status__c,GA_Cancellation_Date__c,GA_Group_Effective_Date__c,'+
        'GA_Account_Record_Type__c,GA_Account__c from GA_Group_Segment__c where id in:idLst';
    public static final string OTHERVAL = 'OTHER';
    public static boolean isExecuting=false;
    public static boolean beforeUpdateExecuting=false;
    Private static final string BCBSMBCN='BCBSM & BCN';
    Private static final string BCBSM='BCBSM';
    Private static final string BCN='BCN';
    Private static final date endDate = Date.valueOf('2200-01-01');
    Private static final string VALUEN='N'; 
    Private static final string COMPLETED='Completed';  
    public static  id currentUserId = userinfo.getUserId(); 
    public static User currentUser = [SELECT profile.name FROM user WHERE Id =: currentUserId];
    private static final String SUBMITTED = 'Submitted';
    
/*******************************************************************************************************************************
@Description        :   beforeInsert() method
@Name               :   beforeInsert
@Param              :   list<GA_Group_Segment__c> gSList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void beforeInsert(list<GA_Group_Segment__c> gSList)
    {
        try
        {   
            //This is Implemented as part of US_3183 : Rahul
            for(GA_Group_Segment__c objGS :gSList){
                if(objGS.Network__c == 'Medicare Advantage' && objGS.GA_Group_Number__c != null && objGS.GA_Group_Suffix__c != null){
                    objGS.Name = objGS.GA_Group_Number__c+'_'+objGS.GA_Group_Suffix__c;
                }
            }
            GA_GroupSegmentSrvcCls.updateSoruceGrp(gSList);
            GA_GS_UpdateRatingType.updtRtngType(gsList,null);
            GA_GroupSegAccUpdateCls.checkLocalGroupUniqueness(gSList,null);  
            
            if(!GA_GS_AP02_Update_Address.isExecuting){
                GA_GS_AP02_Update_Address.insertCity(gSList); 
                GA_GS_AP02_Update_Address.updateCounty(gSList);   
                GA_GS_AP02_Update_Address.updateCountyByZipCode(gSList); // Populates the County Code
                
                if(gSList.size()==1)
                {
                    if((gSList[0].GA_Physical_City_Name__c !=null && gSList[0].GA_Physical_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                       (gSList[0].GA_Billing_City_Name__c !=null && gSList[0].GA_Billing_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                       (gSList[0].GA_Mailing_City_Name__c !=null && gSList[0].GA_Mailing_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                       gSList[0].GA_Copy_Address_From__c <> null)
                    {
                        GA_GS_AP02_Update_Address.updateCityCopyAddressUI(gSList[0]);  
                    }
                    
                }
                
            }
            
            /** if(!GA_ExternlaAppleSrvcCls.isExecuting){
GA_ExternlaAppleSrvcCls.isExecuting = true;
GA_ExternlaAppleSrvcCls.setExternalApplType(gSList,null);
}**/
            
            if(gSList.size()<STSBATCHLMT && gSList.size()>0){
                if(!GA_GS_AP04_UpdtStatus.isCnclGSChkd){                   
                    GA_GS_AP04_UpdtStatus.updtCnclStatusGSBfre(gSList,null);
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    }
    /*******************************************************************************************************************************
@Description        :   afterInsert() method 
@Name               :   afterInsert
@Param              :   list<GA_Group_Segment__c> gSList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void afterInsert(list<GA_Group_Segment__c> gSList, map<id,GA_Group_Segment__c> gSNewMap)
    {
        /*map<id,account> mymap= new map<id,account>();
list<account> acclist= new list<account>();*/
        try{
            /*for(GA_Group_Segment__c gs:gSList)
{
mymap.put(gs.GA_Account__c,[select id,GA_Current_Enrollment_Date__c,GA_Original_Enrollment_Date__c,recordtype.name from 
account where id=:gs.GA_Account__c]);
}
for(ga_group_segment__c gs: gSList)
{
if(mymap.keyset().contains(gs.GA_Account__c))
{
Account acc=mymap.get(gs.GA_Account__c);
acc.GA_Current_Enrollment_Date__c=gs.GA_Group_Effective_Date__c;
acc.GA_Original_Enrollment_Date__c =gs.GA_Group_Effective_Date__c;
acclist.add(acc);
}
}
update acclist;*/
            Set<Id> accIds = new Set<Id>();
            if(!GA_GS_AP02_Update_Address.isInvoked){
                GA_GS_AP02_Update_Address.isInvoked = true;
                list<GA_Group_Segment__c> gSListToUpt=new list<GA_Group_Segment__c>();
                for(GA_Group_Segment__c grp:gSList)
                {
                    //Added to update account renewal field
                        if(grp.GA_Rate_Renewal_Date__c != null && grp.Status__c == 'Active'){
                            accIds.add(grp.GA_Account__c);
                        }                        
                        //End
                    if((grp.GA_Physical_City_Name__c !=null && grp.GA_Physical_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                       (grp.GA_Billing_City_Name__c !=null && grp.GA_Billing_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                       (grp.GA_Mailing_City_Name__c !=null && grp.GA_Mailing_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                       grp.GA_Copy_Address_From__c <> null)
                    {
                        gSListToUpt.add(grp);
                    }
                }
                if(gSListToUpt.size()>0 && gSListToUpt.size() !=1)
                {
                    list<id> gIds = GA_GS_AP02_Update_Address.constructMap(gSListToUpt); 
                    if(gIds.size()<BATCHLIMIT && gIds.size()>0)
                    {
                        GA_GS_AP02_Update_Address.updateCityInfo(gIds);          
                    }
                    else 
                    {
                        if(!system.isBatch()){
                            GA_GroupSegmentBatchForAddressUpdate gsAddressBatch = new GA_GroupSegmentBatchForAddressUpdate(QUERYBATCH, gIds); 
                            ID gsAddressBatchPrsngid = Database.executeBatch(gsAddressBatch,200);
                        }
                    }  
                }
            }
            
            //Added to update account renewal field
            List<Account> accUpdateList = new List<Account>();
            
            Map<Id,Account> accountMap = new Map<Id,Account>([SELECT ID, Renewal_Month_Variation_in_Groups__c,GA_Opportunity_Renewal_Date__c from Account where id in: accIds and GA_Opportunity_Renewal_Date__c != null]);
                        
            for(GA_Group_Segment__c gsp:gsList){
                if(gsp.GA_Rate_Renewal_Date__c != null){
                    Integer segmentMonth = gsp.GA_Rate_Renewal_Date__c.month();
                    if(accountMap.containsKey(gsp.GA_Account__c)){
                        Account acc = accountMap.get(gsp.GA_Account__c);
                        Integer accMmonth = acc.GA_Opportunity_Renewal_Date__c.month();
                        if(segmentMonth != accMmonth){
                            acc.Renewal_Month_Variation_in_Groups__c = true;
                            accUpdateList.add(acc);
                        } else{
                            acc.Renewal_Month_Variation_in_Groups__c = false;
                            accUpdateList.add(acc);
                        }
                    }
                }
            }
            MAP<Id,Account> accMap = new MAP<Id,Account>(); 
            accMap.putall(accUpdateList); 
            if(accmap.size()>0){ 
                update accmap.values();
            }
            if(accUpdateList.size() > 0){
                //update accUpdateList;
            }
            //End
            
            if(gSList.size()<STSBATCHLMT && gSList.size()>0) {
                if(!GA_GS_AP04_UpdtStatus.isExecuting){
                    GA_GS_AP04_UpdtStatus.updtCnclStatusGS(gSList,null);
                }
                
                if(!GA_GS_AP04_UpdtStatus.isInvoked){
                    GA_GS_AP04_UpdtStatus.updtRecTypeAcc(gSList);
                }
                
                if(!GA_GS_UpdatWrappingFileTPA.isExecuting){
                    GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                    GA_GS_UpdatWrappingFileTPA.updtwrpinFileTPA(gSList,null);
                }
            }
            // To update Contract record's carrier - US2684.
            updateContractData(gSList);
            set<id> gsId=new set<id>(); 
            for(GA_Group_Segment__c gs:gSList){ 
                gsId.add(gs.Id);    
            }   
            if(!gsId.isEmpty()){
                updateContractIntegrationStatus(gsId);
            }
            // Copy AOR from account when manually creating a new group segment - US-2389.  
            Map<Id,sobject> gaGrpSegMap = new Map<Id,sobject>();    
            for(GA_group_segment__c ga : gSList){   
                if(ga.GA_Account__c != null){   
                    gaGrpSegMap.put(ga.GA_Account__c,ga);   
                }   
            }   
            //Bypass copying AOR from account to new group created by ICRT User and ASAP - D-1518   
            if(gaGrpSegMap.keyset().size() > 0 && (currentUser.profile.name == System.label.User_Profile_Name_WMichigan_Support || currentUser.profile.name == System.label.User_Profile_Name_Support)) {   
                GA_GroupSegAccUpdateCls.createGaAorGroup(gaGrpSegMap);  
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME2);
        }
    }
    /*******************************************************************************************************************************
@Description        :   beforeUpdate() method 
@Name               :   beforeUpdate
@Param              :   list<GA_Group_Segment__c> gSList, map<id,GA_Group_Segment__c> gSOldMap
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void beforeUpdate(list<GA_Group_Segment__c> gSList, map<id,GA_Group_Segment__c> gSOldMap)
    {
        try
        {    
            GA_GroupSegmentSrvcCls.updateSoruceGrpClone(gSList);
            for(GA_Group_Segment__c objGS :gSList){
                //This is implemneted as part of US-3183 : Rahul
                if(objGS.Network__c == 'Medicare Advantage' && objGS.GA_Group_Number__c != null && objGS.GA_Group_Suffix__c != null &&
                   (objGS.GA_Group_Number__c != gSOldMap.get(objGS.Id).GA_Group_Number__c ||
                    objGS.GA_Group_Suffix__c != gSOldMap.get(objGS.Id).GA_Group_Suffix__c)){
                    objGS.Name = objGS.GA_Group_Number__c+'_'+objGS.GA_Group_Suffix__c;
                }//End of US-3183
                //This is implemneted as part of US-4026 : Rahul
                if(objGS.GA_New_Hire_Exception__c != gSOldMap.get(objGS.Id).GA_New_Hire_Exception__c){
                    if(objGS.Is_Hire_Rehire_Exception_Changed__c){
                        objGS.Is_Hire_Rehire_Exception_Changed__c = false;
                    }else objGS.Is_Hire_Rehire_Exception_Changed__c = true;
                }//End of US-4026
            }
            if(!GA_GroupSegAccUpdateCls.isExecuting)
            {
                GA_GroupSegAccUpdateCls.isExecuting = true;
                GA_GroupSegAccUpdateCls.updateAccountEnrollmentDates(gSList,gSOldMap);
            }
            
            GA_GroupSegAccUpdateCls.checkLocalGroupUniqueness(gSList,gSOldMap);
            GA_GS_UpdateRatingType.updtRtngType(gsList,gSOldMap); 
            if(!GA_ExternalAppealSrvcCls_MOS.isExecuting)
            {
                GA_ExternalAppealSrvcCls_MOS.updateExternalAppealNHRDate(gsList,gSOldMap);
            }
            if(!system.isfuture())
            {
                if(!GA_GS_AP02_Update_Address.isExecuting){
                    GA_GS_AP02_Update_Address.updateCity(gSList, gSOldMap); 
                    GA_GS_AP02_Update_Address.updateCounty(gSList);
                    GA_GS_AP02_Update_Address.updateCountyByZipCode(gSList);
                    
                    if(gSList.size()==1)
                    {
                        if((gSList[0].GA_Physical_City_Name__c !=null && gSList[0].GA_Physical_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                           (gSList[0].GA_Billing_City_Name__c !=null && gSList[0].GA_Billing_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                           (gSList[0].GA_Mailing_City_Name__c !=null && gSList[0].GA_Mailing_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                           gSList[0].GA_Copy_Address_From__c <> null)
                        {
                            GA_GS_AP02_Update_Address.updateCityCopyAddressUI(gSList[0]);  
                        }
                    }
                }
                
                if(gSList.size()<STSBATCHLMT && gSList.size()>0 ){
                    if(!GA_GS_AP04_UpdtStatus.isCnclGSChkd){                   
                        GA_GS_AP04_UpdtStatus.updtCnclStatusGSBfre(gSList,gSOldMap);
                    }
                    if(!beforeUpdateExecuting){
                        beforeUpdateExecuting = true;
                        GA_GS_AP04_UpdtStatus.updtActivStatusGS(gsList);
                    }
                    
                }
            }
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1);
        }
    }
    /*******************************************************************************************************************************
@Description        :   afterUpdate() method 
@Name               :   afterUpdate
@Param              :   list<GA_Group_Segment__c> gSList, map<id,GA_Group_Segment__c> gSOldMap
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void afterUpdate(list<GA_Group_Segment__c> gSList, map<id,GA_Group_Segment__c> gSOldMap)
    {
        try
        {       
            Set<Id> accIds = new Set<Id>();
            if(!GA_GS_AP02_Update_Address.isInvoked && !ARV_AP88_GroupSegmentPackageCreation.isExecute88 ){
                GA_GS_AP02_Update_Address.isInvoked  = true;
                if(!system.isfuture() || !system.isBatch())
                {
                    
                    list<GA_Group_Segment__c> gSListToUpt=new list<GA_Group_Segment__c>();
                    for(GA_Group_Segment__c grp:gSList)
                    {
                        //Added to update account renewal field
                        if(grp.GA_Rate_Renewal_Date__c != null && grp.Status__c == 'Active'){
                            accIds.add(grp.GA_Account__c);
                        }                        
                        //End
                        
                        if((grp.GA_Physical_City_Name__c !=null && grp.GA_Physical_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                           (grp.GA_Billing_City_Name__c !=null && grp.GA_Billing_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                           (grp.GA_Mailing_City_Name__c !=null && grp.GA_Mailing_City_Name__c.equalsIgnoreCase(OTHERVAL)) || 
                           grp.GA_Copy_Address_From__c <> null)
                        {
                            gSListToUpt.add(grp);
                        }
                    }
                    if(gSListToUpt.size()>0 && gSListToUpt.size() !=1 && !system.isBatch())
                    {
                        
                        list<id> gIds = GA_GS_AP02_Update_Address.constructMap(gSListToUpt); 
                        if(gIds.size()<BATCHLIMIT && gIds.size()>0){
                            GA_GS_AP02_Update_Address.updateCityInfo(gIds);
                        }
                        else
                        {
                            if( !system.isBatch()){
                                GA_GroupSegmentBatchForAddressUpdate gsAddressBatch = new GA_GroupSegmentBatchForAddressUpdate(QUERYBATCH, gIds); 
                                ID gsAddressBatchPrsngid = Database.executeBatch(gsAddressBatch,200);
                            }
                        }  
                    }
                }
            }
			
            //Added to update account renewal field
            List<Account> accUpdateList = new List<Account>();
            
            Map<Id,Account> accountMap = new Map<Id,Account>([SELECT ID, Renewal_Month_Variation_in_Groups__c,GA_Opportunity_Renewal_Date__c from Account where id in: accIds and GA_Opportunity_Renewal_Date__c != null]);
                        
            for(GA_Group_Segment__c gsp:gsList){
                if(gsp.GA_Rate_Renewal_Date__c != null){
                    Integer segmentMonth = gsp.GA_Rate_Renewal_Date__c.month();
                    if(accountMap.containsKey(gsp.GA_Account__c)){
                        Account acc = accountMap.get(gsp.GA_Account__c);
                        Integer accMmonth = acc.GA_Opportunity_Renewal_Date__c.month();
                        if(segmentMonth != accMmonth){
                            acc.Renewal_Month_Variation_in_Groups__c = true;
                            accUpdateList.add(acc);
                        } else{
                            acc.Renewal_Month_Variation_in_Groups__c = false;
                            accUpdateList.add(acc);
                        }
                    }
                }
            }
            MAP<Id,Account> accMap = new MAP<Id,Account>(); 
            accMap.putall(accUpdateList); 
            if(accmap.size()>0){ 
                update accmap.values();
            }
            if(accUpdateList.size() > 0){
                //update accUpdateList;
            }
            //End 
            
            
            if(gSList.size()<STSBATCHLMT && gSList.size()>0 && !ARV_AP88_GroupSegmentPackageCreation.isExecute88 ){
                
                if(!GA_GS_AP04_UpdtStatus.isExecuting){
                    GA_GS_AP04_UpdtStatus.updtCnclStatusGS(gSList,gSOldMap);
                }
                
                if(!GA_GS_AP04_UpdtStatus.isInvoked){
                    GA_GS_AP04_UpdtStatus.updtRecTypeAcc(gSList);   
                }
                
                if(!isExecuting){
                    isExecuting=true;
                    GA_GS_AP04_UpdtStatus.updateEndDateTPB(gSList,gSOldMap);
                    
                }
                
                if(!GA_GS_UpdatWrappingFileTPA.isExecuting){
                    GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                    GA_GS_UpdatWrappingFileTPA.updtwrpinFileTPA(gSList,gSOldMap);
                }
                if(!GA_GS_Insert_ThrdPartyBillerRecs.isExecuting){
                    GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                    GA_GS_Insert_ThrdPartyBillerRecs.insertThrdPartyRecs(gSList,gSOldMap);
                }
                if(!GA_GS_Insert_ThrdPartyBillerRecs.isInvoked){
                    GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                    GA_GS_Insert_ThrdPartyBillerRecs.updtLinkedTPBEndDate(gSList,gSOldMap);
                }
                if(!GA_GS_Insert_ThrdPartyBillerRecs.isInvoking){
                    GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                    GA_GS_Insert_ThrdPartyBillerRecs.updtTPBdate(gSList,gSOldMap);
                }
                if(!GA_ExternalAppealRecdCrtnUpdt.isExecuting){
                    GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                    GA_ExternalAppealRecdCrtnUpdt.updtNHREndDtOnExtnlApl(gSList,gSOldMap);
                }
                if(!GA_GroupSegmentSrvcCls.isExecuting){
                    GA_GroupSegmentSrvcCls.updateGSNameOnChildRecs(gsList,gSOldMap);
                }
            }
            //Added for US3686  
            set<id> gsId1=new set<id>();    
            for(GA_Group_Segment__c gs:gSList){ 
                gsId1.add(gs.Id);   
            }
            if(!gsId1.isEmpty()){
                updateContractIntegrationStatus(gsId1);
            }
            // added for US3019
            set<id> gsId=new set<id>();
            for(GA_Group_Segment__c gsp:gsList){
                if(gSOldMap.get(gsp.Id).status__C!=gsp.Status__c && gsp.Status__c=='Active' &&gsp.ARV_ContractID__r.Status!='Activated'){
                    gsId.add(gsp.ARV_ContractID__c);
                }
            }
            if(!gsId.isEmpty()){
                ARV_AP87_ContractTriggerHandler.updateContractStatusAfterGS(gsId);
            }
            updateAccountDC.updateAccountDConGS(gSList);
            
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME3);
        }
    }
    
    // This method is implemented as part of US:2146(Add BCBSM and BCN group numbers to the workflow list view on Accounts)
    public static void updateWFProcess(Map<Id,GA_Group_Segment__c> newMap, Map<Id,GA_Group_Segment__c> oldMap){
        try{
            List<GA_WF_Group_Segment__c> lstWFPForUpdate = new List<GA_WF_Group_Segment__c>();
            Map<Id, GA_Group_Segment__c> mapGSId_GS = new Map<Id, GA_Group_Segment__c>();
            if(oldMap == null){ //for Insert
                if(!newMap.isEmpty()){
                    Map<Id,GA_WF_Group_Segment__c> mapGSId_WFP = getGroupSegmentMap(newMap.keySet());
                    for(GA_Group_Segment__c objGS : newMap.values()){
                        if(mapGSId_WFP.containsKey(objGS.Id)){
                            GA_WF_Group_Segment__c objWFP = mapGSId_WFP.get(objGS.Id);
                            objWFP.GA_Group_Seg_Name__c = objGS.Name;
                            lstWFPForUpdate.add(objWFP);
                        }
                    }
                }
            }
            else{ // for Update
                for(GA_Group_Segment__c objGS : newMap.values()){
                    if(objGS.Name != oldMap.get(objGS.Id).Name){
                        mapGSId_GS.put(objGS.Id, objGS);
                    }
                }
                if(!mapGSId_GS.isEmpty()){
                    Map<Id,GA_WF_Group_Segment__c> mapGSId_WFP = getGroupSegmentMap(mapGSId_GS.keySet());
                    for(GA_Group_Segment__c objGS : mapGSId_GS.values()){
                        if(mapGSId_WFP.containsKey(objGS.Id)){
                            GA_WF_Group_Segment__c objWFP = mapGSId_WFP.get(objGS.Id);
                            objWFP.GA_Group_Seg_Name__c = objGS.Name;
                            lstWFPForUpdate.add(objWFP);
                        }    
                    }
                } 
                
                if(lstWFPForUpdate.size() > 0){
                    update lstWFPForUpdate;
                }
            }
        }catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME4);
        }
    }
    
    public static Map<Id,GA_WF_Group_Segment__c> getGroupSegmentMap(Set<Id> objGSIds){
        Map<Id,GA_WF_Group_Segment__c> mapGSId_WFP = new Map<Id,GA_WF_Group_Segment__c>();
        List<GA_WF_Group_Segment__c> lstWFProcesses = [SELECT Id, GA_Group_Segment_ID__c,GA_Group_Seg_Name__c,
                                                       GA_Group_Segment_ID__r.Name 
                                                       FROM GA_WF_Group_Segment__c 
                                                       WHERE GA_Group_Segment_ID__c IN :objGSIds];
        for(GA_WF_Group_Segment__c objWFP : lstWFProcesses){
            mapGSId_WFP.put(objWFP.GA_Group_Segment_ID__c, objWFP);
        }
        return mapGSId_WFP;
    }
    
    // This method is implemented as part of US:2421(Auto Populate Assigned Managing Agency on Account)
    public static void updateAgencyOnAccount(List<GA_Group_Segment__c> lstGS, Map<Id,GA_Group_Segment__c> oldMap){
        try{
            List<Id> lstAccIds = new List<Id>();
            List<Account> lstAccForUpdate = new List<Account>();
            
            if(oldMap != null){ //for update
                for(GA_Group_Segment__c objGS : lstGS){
                    if((objGS.Status__c == 'Active' || objGS.Status__c == 'Pending') && (objGS.GA_Managing_Agency__c != oldMap.get(objGS.Id).GA_Managing_Agency__c)){
                        lstAccIds.add(objGS.GA_Account__c);            
                    }
                }
            }
            else{  //for insert
                for(GA_Group_Segment__c objGS : lstGS){
                    if(objGS.Status__c == 'Active' || objGS.Status__c == 'Pending'){
                        lstAccIds.add(objGS.GA_Account__c);            
                    }
                }     
            }
            if(lstAccIds.size()>0)
            {
                for(Account objAcc : [Select Id, Managing_Agent__c, (SELECT Id, GA_Managing_Agency__c, GA_Managing_Agency__r.Name 
                                                                     FROM Group_Segments__r 
                                                                     WHERE GA_Managing_Agency__c != null AND Status__c IN ('Active','Pending')) 
                                      FROM Account 
                                      WHERE Id IN: lstAccIds]){
                                          if(objAcc.Group_Segments__r.size() > 0 ){ //At least one Grp Segment has Managing Agency 
                                              objAcc.Assigned_Managing_Agency__c = objAcc.Group_Segments__r[0].GA_Managing_Agency__r.Name;
                                              lstAccForUpdate.add(objAcc);    
                                          }
                                          else{ //when None of the GS have Managing agency
                                              objAcc.Assigned_Managing_Agency__c = null; 
                                              lstAccForUpdate.add(objAcc); 
                                          }
                                      }
            }
            
            if(lstAccForUpdate.size() > 0){
                update lstAccForUpdate; 
            }
        }catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME5);
        }
    }
    
    // This method is implemented as part of US:2456(Automatically Add Managing Agent when creating new Group Segments)
    public static void createMAH(List<GA_Group_Segment__c> lstGS){
        try{
            Set<Id> setAccIds = new Set<Id>();
            List<GA_Managing_Agency_History__c> lstMAHForUpdate = new List<GA_Managing_Agency_History__c>();
            if(!GA_AP_ASEPRecordMatchCls.asepGrpSeg && UserInfo.getName() != 'ICRT User'){
                for(GA_Group_Segment__c objGS : lstGS){
                    if(objGS.GA_Account__c != null){
                        setAccIds.add(objGS.GA_Account__c);
                    }
                }
                Map<Id, String> mapAccId_MAName = new Map<Id, String>();
                if(setAccIds.size() > 0){
                    for(Account objAcc : [SELECT Id, Assigned_Managing_Agency__c 
                                          FROM Account 
                                          WHERE Id IN: setAccIds AND Assigned_Managing_Agency__c != null]){
                                              mapAccId_MAName.put(objAcc.Id, objAcc.Assigned_Managing_Agency__c);
                                          }
                }
                
                Map<String,Id> mapMAName_MAId = new Map<String, Id>();
                if(!mapAccId_MAName.isEmpty()){
                    for(Account objMA  : [SELECT Id, Name, GA_Managing_Agency_Code__c 
                                          FROM Account 
                                          WHERE Name IN:mapAccId_MAName.values()]){
                                              if(objMA.Name.equalsIgnoreCase('TGG Solutions')){
                                                  if(objMA.GA_Managing_Agency_Code__c == '01'){
                                                      mapMAName_MAId.put(objMA.Name, objMA.Id);
                                                  }
                                              }
                                              else{
                                                  mapMAName_MAId.put(objMA.Name, objMA.Id);
                                              }
                                          }
                }
                
                for(GA_Group_Segment__c objGS : lstGS){
                    if(objGS.GA_Account__c != null && mapAccId_MAName.containskey(objGS.GA_Account__c)){
                        if(mapMAName_MAId.containsKey(mapAccId_MAName.get(objGS.GA_Account__c))){
                            GA_Managing_Agency_History__c objMAH = new GA_Managing_Agency_History__c();
                            objMAH.GA_Group_Segment__c = objGS.Id;
                            objMAH.GA_Managing_Agency__c = mapMAName_MAId.get(mapAccId_MAName.get(objGS.GA_Account__c));
                            objMAH.GA_Start_Date__c = System.today();
                            objMAH.GA_End_Date__c = endDate;
                            objMAH.MA_Override_End_Date__c = endDate; // US 3339 Start
                            if( objGS.GA_Group_Effective_Date__c != null){
                                System.debug('GA_GroupSegmentTriggerHandler GA_Group_Effective_Date__c: '+ objGS.GA_Group_Effective_Date__c);
                                objMAH.MA_Override_Start_Date__c = objGS.GA_Group_Effective_Date__c; 
                            } // US 3339 End
                            lstMAHForUpdate.add(objMAH);
                        }
                    }
                } 
                
                if(lstMAHForUpdate.size() > 0){
                    insert lstMAHForUpdate;
                }
            }
        }catch(exception e){ GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME6);}
    }
    
    /*******************************************************************************************************************************
@Description        :   update Carrier on Enrollment Contract based on related Group Segments
@Name               :   updateContractData
Auther        :  Offshore IDC ARV
Purpose        :   As part of US2684
********************************************************************************************************************************/
    public static void updateContractData(list<GA_Group_Segment__c> gSList){
        Map<Id,set<string>> contractIdGScarriercodeMap = new Map<Id,Set<string>>();
        set<Id>contractidSet = new set<Id>();
        List<contract>updatecontractLst = new List<contract>();
        for (GA_Group_Segment__c gsRec : gSList){
            contractidSet.add(gsRec.ARV_ContractID__c);
            if (!contractIdGScarriercodeMap.containsKey(gsRec.ARV_ContractID__c)){
                contractIdGScarriercodeMap.put(gsRec.ARV_ContractID__c,new set<string>{gsRec.GA_Carrier__c});
            }
            
            else{
                set<string> existingstring = contractIdGScarriercodeMap.get(gsRec.ARV_ContractID__c);
                existingstring.add(gsRec.GA_Carrier__c);
                contractIdGScarriercodeMap.put(gsRec.ARV_ContractID__c,existingstring);
            }
        }
        for (Contract contractRec : [select id,name from contract where id in :contractidSet]){
            if (contractIdGScarriercodeMap.containsKey(contractRec.id) && contractIdGScarriercodeMap.get(contractRec.id).contains(BCBSM) && contractIdGScarriercodeMap.get(contractRec.id).contains(BCN))
            {
                contractRec.ARV_CF_CNTRCT_CarrierCodes__c = BCBSMBCN;
                updatecontractLst.add(contractRec);
            }
            else if (contractIdGScarriercodeMap.containsKey(contractRec.id) && contractIdGScarriercodeMap.get(contractRec.id).contains(BCBSM))
            {
                contractRec.ARV_CF_CNTRCT_CarrierCodes__c = BCBSM;
                updatecontractLst.add(contractRec);
            }
            else
            {
                contractRec.ARV_CF_CNTRCT_CarrierCodes__c = BCN;
                updatecontractLst.add(contractRec); 
            }
        }
        if (updatecontractLst.size()>0){
            update updatecontractLst;
        }
    }
/*******************************************************************************************************************************
@Description        :   updateContractIntegrationStatus
@Name               :   updateContractIntegrationStatus
Auther        :  Offshore IDC ARV
Purpose        :   As part of US3686
********************************************************************************************************************************/
    @Future
    public static void updateContractIntegrationStatus(set<id> gSList){
        //added for US3686
        set<id> updateContractId=new set<id>();
        set<Id> contId=new set<id>();
        integer gsVar=0;
        Integer contractGScount=0;
        for (GA_Group_Segment__c gsRec : [select id,ARV_ContractID__c from GA_Group_Segment__c where id in: gSList]){
             if(gsRec.ARV_ContractID__c!=null){
            contId.add(gsRec.ARV_ContractID__c); 
            }
        }
        if(!contId.isEmpty()){
        list<GA_Group_Segment__c> totalGSList=[Select id,ARV_ContractID__c,Suspend_Bill_Indicator__c from GA_Group_Segment__c where ARV_ContractID__c in:contId];
        contractGScount=totalGSList.size();
              if(!totalGSList.isEmpty()){
                 for (GA_Group_Segment__c gsRec :totalGSList ){
                    if(gsRec.Suspend_Bill_Indicator__c==VALUEN){
                       gsVar=gsVar+1; 
                       updateContractId.add(gsRec.ARV_ContractID__c);
                    }  
                }
            }
        }
        if(gsVar==contractGScount){
            list<Contract> conList=new List<Contract>();
            if(!updateContractId.isEmpty()){
                for (Contract contRec : [select id,name,ARV_Integration_Status__c from contract where id in :updateContractId and recordtype.name='Enrollment']){
                    contRec.ARV_Integration_Status__c=COMPLETED;
                    conList.add(contRec);
                }
            }
            if(conList.size()>0){
                update conList;
            }
        }
    }
 
/* This is implemented as part of US-3475(BCBSM-TAR-3475 Update active group segments on Billing Address change)
    Developer : Rahul*/ 
    public static void updateAddressOnRelatedGS(List<GA_Group_segment__c> lstGS, Map<Id, GA_Group_segment__c> oldMap){
        List<String> lstFGNames = new List<String>();
        List<GA_Group_segment__c> lstChangedGS = new List<GA_Group_segment__c>();   
        Map<String, List<String>> mapName_lstFacets = new Map<String, List<String>>();
        Map<String, GA_Group_segment__c> mapGrpSeg = new Map<String, GA_Group_segment__c>();
        
        for(GA_Group_segment__c objGS : lstGS){
            system.debug('pp'+objGS);
            system.debug('pps+'+oldMap);
            if((objGS.GA_Billing_Zip__c != oldMap.get(objGS.Id).GA_Billing_Zip__c || objGS.GA_Billing_County_Id__c != oldMap.get(objGS.Id).GA_Billing_County_Id__c || 
                objGS.GA_Billing_State__c != oldMap.get(objGS.Id).GA_Billing_State__c || objGS.GA_Billing_City_Other__c != oldMap.get(objGS.Id).GA_Billing_City_Other__c || 
                objGS.GA_Billing_City__c != oldMap.get(objGS.Id).GA_Billing_City__c || objGS.GA_Billing_Address_3__c != oldMap.get(objGS.Id).GA_Billing_Address_3__c ||
                objGS.GA_Billing_Address_2__c != oldMap.get(objGS.Id).GA_Billing_Address_2__c || objGS.GA_Billing_Address_1__c != oldMap.get(objGS.Id).GA_Billing_Address_1__c)
               && objGS.GA_Carrier__c == 'BCN' 
               && (objGS.GA_Bill_Level__c == 'G' || objGS.GA_Bill_Level__c == 'S')){
                   lstFGNames.add(objGS.GA_Facets_Group_ID__c);
                   lstChangedGS.add(objGS);
               } 
        }
        if(!lstFGNames.isEmpty() && !lstChangedGS.isEmpty()){
            updateBillingAddressOnGS(lstFGNames, lstGS);    
        }
    }
    
/* This is implemented as part of US-3475(BCBSM-TAR-3475 Update active group segments on Billing Address change)
    Developer : Rahul*/ 
    public static void updateBillingAddressOnGS(List<String> lstFGNames, List<GA_Group_segment__c> lstGS)
    {
        Map<String, List<String>> mapName_lstFacets = new Map<String, List<String>>();
        Map<String, GA_Group_segment__c> mapGrpSeg = new Map<String, GA_Group_segment__c>();
        Set<GA_Group_segment__c> setGSAddressUpdate = new Set<GA_Group_segment__c>();
        for(GA_Group_segment__c objGS : [SELECT Id, GA_Billing_Address_1__c, GA_Billing_Address_2__c, GA_Billing_Address_3__c, GA_Billing_City__c, GA_Billing_City_Other__c, 
                                                GA_Billing_State__c, GA_Billing_County_Id__c, GA_Billing_Zip__c, GA_Facets_Sub_Group_Number__c, GA_Facets_Group_ID__c, GA_Facets_Class_ID__c, GA_Bill_Level__c 
                                         FROM GA_Group_segment__c 
                                         WHERE GA_Facets_Group_ID__c IN: lstFGNames AND status__c != 'Canceled' limit 10000]){ 
            if(objGS.GA_Bill_Level__c == 'S' && objGS.GA_Facets_Group_ID__c != null && objGS.GA_Facets_Sub_Group_Number__c != null && objGS.GA_Facets_Class_ID__c != null){
                mapGrpSeg.put(objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c+'_'+objGS.GA_Facets_Class_ID__c, objGS);    
                if(!mapName_lstFacets.containsKey(objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c)){
                    mapName_lstFacets.put(objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c, new List<String> {objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c+'_'+objGS.GA_Facets_Class_ID__c});    
                }
                else{
                    List<String> lstName = mapName_lstFacets.get(objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c);
                    lstName.add(objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c+'_'+objGS.GA_Facets_Class_ID__c);
                    mapName_lstFacets.put(objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c, lstName);
                }  
            }else if(objGS.GA_Bill_Level__c == 'G' && objGS.GA_Facets_Group_ID__c != null && objGS.GA_Facets_Sub_Group_Number__c != null && objGS.GA_Facets_Class_ID__c != null){
                mapGrpSeg.put(objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c+'_'+objGS.GA_Facets_Class_ID__c, objGS);    
                if(!mapName_lstFacets.containsKey(objGS.GA_Facets_Group_ID__c)){
                    mapName_lstFacets.put(objGS.GA_Facets_Group_ID__c, new List<String> {objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c+'_'+objGS.GA_Facets_Class_ID__c});    
                }
                else{
                    List<String> lstName = mapName_lstFacets.get(objGS.GA_Facets_Group_ID__c);
                    lstName.add(objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c+'_'+objGS.GA_Facets_Class_ID__c);
                    mapName_lstFacets.put(objGS.GA_Facets_Group_ID__c, lstName);
                }  
            }
        }
        for(GA_Group_segment__c objGS : lstGS){
            if(objGS.GA_Bill_Level__c == 'S' && mapName_lstFacets.containsKey(objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c)){
                for(String str : mapName_lstFacets.get(objGS.GA_Facets_Group_ID__c+'_'+objGS.GA_Facets_Sub_Group_Number__c)){
                    if(mapGrpSeg.containsKey(str)){
                        GA_Group_segment__c objGrpSeg = mapGrpSeg.get(str);
                        objGrpSeg.GA_Billing_Address_1__c = objGS.GA_Billing_Address_1__c; 
                        objGrpSeg.GA_Billing_Address_2__c = objGS.GA_Billing_Address_2__c;
                        objGrpSeg.GA_Billing_Address_3__c = objGS.GA_Billing_Address_3__c;
                        objGrpSeg.GA_Billing_City__c = objGS.GA_Billing_City__c;
                        objGrpSeg.GA_Billing_City_Other__c = objGS.GA_Billing_City_Other__c;
                        objGrpSeg.GA_Billing_State__c = objGS.GA_Billing_State__c;
                        objGrpSeg.GA_Billing_County_Id__c = objGS.GA_Billing_County_Id__c;
                        objGrpSeg.GA_Billing_Zip__c = objGS.GA_Billing_Zip__c;
                        setGSAddressUpdate.add(objGrpSeg);
                    }
                }
            }else if(objGS.GA_Bill_Level__c == 'G' && mapName_lstFacets.containsKey(objGS.GA_Facets_Group_ID__c)){
                for(String str : mapName_lstFacets.get(objGS.GA_Facets_Group_ID__c)){
                    if(mapGrpSeg.containsKey(str)){
                        GA_Group_segment__c objGrpSeg = mapGrpSeg.get(str);
                        objGrpSeg.GA_Billing_Address_1__c = objGS.GA_Billing_Address_1__c; 
                        objGrpSeg.GA_Billing_Address_2__c = objGS.GA_Billing_Address_2__c;
                        objGrpSeg.GA_Billing_Address_3__c = objGS.GA_Billing_Address_3__c;
                        objGrpSeg.GA_Billing_City__c = objGS.GA_Billing_City__c;
                        objGrpSeg.GA_Billing_City_Other__c = objGS.GA_Billing_City_Other__c;
                        objGrpSeg.GA_Billing_State__c = objGS.GA_Billing_State__c;
                        objGrpSeg.GA_Billing_County_Id__c = objGS.GA_Billing_County_Id__c;
                        objGrpSeg.GA_Billing_Zip__c = objGS.GA_Billing_Zip__c;
                        setGSAddressUpdate.add(objGrpSeg);
                    }
                }
            }
        }
        if(!setGSAddressUpdate.isEmpty())
        {
            List<GA_Group_segment__c> lstGSAddressUpdate = new List<GA_Group_segment__c>(setGSAddressUpdate);
            GA_GS_AP02_Update_Address.isExecuting=true;
            GA_GS_UpdateRatingType.isExecuting = true;
            GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
            GA_GroupSegmentTriggerHandler.isExecuting = true;
            GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
            GA_GS_AP04_UpdtStatus.isExecuting = true;
            GA_GS_AP04_UpdtStatus.isInvoked = true;
            GA_GS_UpdatWrappingFileTPA.isExecuting = true;
            GA_GroupSegAccUpdateCls.isExecuting = true;
            GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
            GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
            GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
            GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
            GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
            GA_GroupSegmentSrvcCls.isExecuting = true;
            update lstGSAddressUpdate;
        }
    }
    
/*******************************************************************************************************************************
@Description        :   updateGWCTransacTableRecGS
@Name               :   updateGWCTransacTableRecGS
Auther        :  Offshore IDC ARV
Purpose        :   As part of US4444
********************************************************************************************************************************/
    public static void updateGWCTransacTableRecGS(Map<Id, GA_Group_Segment__c> oldMap, Map<Id,GA_Group_Segment__c> newMap){
        
        List<Id> GSIds = new List<Id>();
        for(Id gs : newMap.keySet()){
            GSIds.add(gs);
        }
        
        List<ARV_GWC_Transaction_Table__c> existingRecs = new List<ARV_GWC_Transaction_Table__c>();
        Set<ARV_GWC_Transaction_Table__c> updatedRecs = new Set<ARV_GWC_Transaction_Table__c>();
        List<ARV_GWC_Transaction_Table__c> updatedRecsList = new List<ARV_GWC_Transaction_Table__c>();
        Id recTypeId = Schema.SObjectType.ARV_GWC_Transaction_Table__c.getRecordTypeInfosByName().get('Maintenance Change').getRecordTypeId();
        
        existingRecs = [select Id, Status__c, Group_Name__c from ARV_GWC_Transaction_Table__c where Status__c =: SUBMITTED AND Group_Name__c IN:GSIds AND RecordTypeId =:recTypeId];
        
        if(existingRecs != null && !existingRecs.isEmpty()){
            for(ARV_GWC_Transaction_Table__c gs: existingRecs){
                
                if(newMap.get(gs.Group_Name__c) != null && oldMap.get(gs.Group_Name__c) != null){
                    
                    //for Doing Business As
                    if(newMap.get(gs.Group_Name__c).GA_Group_Name__c != oldMap.get(gs.Group_Name__c).GA_Group_Name__c){
                        gs.Status__c = COMPLETED;
                        updatedRecs.add(gs);
                    }
                    
                    //for Federal tax ID
                    if(newMap.get(gs.Group_Name__c).GA_Federal_Tax_ID_Number__c != oldMap.get(gs.Group_Name__c).GA_Federal_Tax_ID_Number__c){
                        gs.Status__c = COMPLETED;
                        updatedRecs.add(gs);
                    }
                    
                    //for SIC Code
                    if(newMap.get(gs.Group_Name__c).GA_SIC_Code__c != oldMap.get(gs.Group_Name__c).GA_SIC_Code__c){
                        gs.Status__c = COMPLETED;
                        updatedRecs.add(gs);
                    }
                    
                    //for new hire/ rehire
                    if(newMap.get(gs.Group_Name__c).GA_New_Hire_Rehire_Option_Id__c != oldMap.get(gs.Group_Name__c).GA_New_Hire_Rehire_Option_Id__c){
                        gs.Status__c = COMPLETED;
                        updatedRecs.add(gs);
                    }
                    
                    //for contacts
                    if(newMap.get(gs.Group_Name__c).GA_Administrative_Contact_Id__c != oldMap.get(gs.Group_Name__c).GA_Administrative_Contact_Id__c){
                        gs.Status__c = COMPLETED;
                        updatedRecs.add(gs);
                    }
                    
                    //for physical address
                    if((newMap.get(gs.Group_Name__c).GA_Physical_City__c != oldMap.get(gs.Group_Name__c).GA_Physical_City__c) || (newMap.get(gs.Group_Name__c).GA_Physical_County_Id__c != oldMap.get(gs.Group_Name__c).GA_Physical_County_Id__c) || (newMap.get(gs.Group_Name__c).GA_Physical_State__c != oldMap.get(gs.Group_Name__c).GA_Physical_State__c) || (newMap.get(gs.Group_Name__c).GA_Physical_Address_1__c != oldMap.get(gs.Group_Name__c).GA_Physical_Address_1__c) || (newMap.get(gs.Group_Name__c).GA_Physical_Zip__c != oldMap.get(gs.Group_Name__c).GA_Physical_Zip__c)){
                        gs.Status__c = COMPLETED;
                        updatedRecs.add(gs);
                    }
                    
                    //for mailing address
                    if((newMap.get(gs.Group_Name__c).GA_Mailing_City__c != oldMap.get(gs.Group_Name__c).GA_Mailing_City__c) || (newMap.get(gs.Group_Name__c).GA_Mailing_County_Id__c != oldMap.get(gs.Group_Name__c).GA_Mailing_County_Id__c) || (newMap.get(gs.Group_Name__c).GA_Mailing_State__c != oldMap.get(gs.Group_Name__c).GA_Mailing_State__c) || (newMap.get(gs.Group_Name__c).GA_Mailing_Address_1__c != oldMap.get(gs.Group_Name__c).GA_Mailing_Address_1__c) || (newMap.get(gs.Group_Name__c).GA_Mailing_Zip__c != oldMap.get(gs.Group_Name__c).GA_Mailing_Zip__c)){
                        gs.Status__c = COMPLETED;
                        updatedRecs.add(gs);
                    }
                    
                    //for billing address 
                    if((newMap.get(gs.Group_Name__c).GA_Billing_City__c != oldMap.get(gs.Group_Name__c).GA_Billing_City__c) || (newMap.get(gs.Group_Name__c).GA_Billing_County_Id__c != oldMap.get(gs.Group_Name__c).GA_Billing_County_Id__c) || (newMap.get(gs.Group_Name__c).GA_Billing_State__c != oldMap.get(gs.Group_Name__c).GA_Billing_State__c) || (newMap.get(gs.Group_Name__c).GA_Billing_Address_1__c != oldMap.get(gs.Group_Name__c).GA_Billing_Address_1__c) || (newMap.get(gs.Group_Name__c).GA_Billing_Zip__c != oldMap.get(gs.Group_Name__c).GA_Billing_Zip__c) || (newMap.get(gs.Group_Name__c).GA_Billing_Contact_Id__c != oldMap.get(gs.Group_Name__c).GA_Billing_Contact_Id__c)){
                        gs.Status__c = COMPLETED;
                        updatedRecs.add(gs);
                    }
                }
            }
            
            if(updatedRecs != null && !updatedRecs.isEmpty()){
                for(ARV_GWC_Transaction_Table__c ggs : updatedRecs){	
                	updatedRecsList.add(ggs);
                }
                Database.update(updatedRecsList);
            }
        }
    }
}