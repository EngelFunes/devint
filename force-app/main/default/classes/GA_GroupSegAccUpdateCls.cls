/**
@Author : IDCOffshore
@Name: GA_GroupSegAccUpdateCls
@CreatedDate: 1/7/2019 
@Description: GA_GroupSegAccUpdateCls class to update Group segment infor 
@version : 1.0  
*/ 
public without sharing class GA_GroupSegAccUpdateCls {    
    public static final string CLASSNM='GA_GroupSegAccUpdateCls';
    public static boolean isExecuting = false;
    public static final string METHOD1='updateAccountEnrollmentDates';
    public static final string METHOD2='checkLocalGroupUniqueness';
    public static final string LCLINFOGRPSEGERRMSG='Local Group Number/Suffix already exists. Please contact the System Administrator';
    public static final String NASCOGRP= 'NASCO';
    public static final String MOSGRP = 'MOS';
    public static final String MEDICRADV ='Medicare Advantage';
    public static final String BCNGRP ='BCN';
    public static final String CUSTRECTYP = 'Account - Customer';
    public static final String PRSPCTRECTYP = 'Account - Prospect';
    
    /****
*@Description: updateAccountEnrollmentDates() method 
@Name : updateAccountEnrollmentDates
@Param : List<GA_Group_Segment__c> gpSegLst,Map<ID,GA_Group_Segment__c> gpSegOldMap
@Return : void
@throws Exception : N/A;
****/      
    public static void updateAccountEnrollmentDates(List<GA_Group_Segment__c> gpSegLst,Map<ID,GA_Group_Segment__c> gpSegOldMap)
    {
        try
        {      
            Set<id> accIds = new Set<id>();
            for(GA_Group_Segment__c grpSegNew :gpSegLst){
                if(grpSegNew.GA_Group_Effective_Date__c != null && gpSegOldMap.get(grpSegNew.id).GA_Group_Effective_Date__c <> grpSegNew.GA_Group_Effective_Date__c ){
                    accIds.add(grpSegNew.GA_Account__c);
                }
				if(grpSegNew.GA_Group_Effective_Date__c != null && (gpSegOldMap.get(grpSegNew.id).GA_Account__r.GA_Original_Enrollment_Date__c==null || gpSegOldMap.get(grpSegNew.id).GA_Account__r.GA_Current_Enrollment_Date__c==null) ){
                    if(!accIds.contains(grpSegNew.GA_Account__c)){
                     accIds.add(grpSegNew.GA_Account__c);   
                    }
                }                
            }
            Map<ID,Account> accountDetailsMap = new Map<ID,Account>();
            if(!accIds.isEmpty())
            {
                accountDetailsMap = new Map<ID,Account>([Select Id,Name,GA_Current_Enrollment_Date__c, GA_Original_Enrollment_Date__c from Account 
                                                         where Id in :accIds Limit 10000]);
           
            List<Account> accLst = New  List<Account>();
            for(GA_Group_Segment__c grpSegNew :gpSegLst){
                if(grpSegNew.GA_Group_Effective_Date__c != null){
                    Account accRec = accountDetailsMap.get(grpSegNew.GA_Account__c);
                    if(accRec.GA_Current_Enrollment_Date__c == null)
                    {
                        accRec.GA_Current_Enrollment_Date__c=grpSegNew.GA_Group_Effective_Date__c;
                    }
                    if(accRec.GA_Original_Enrollment_Date__c == null)
                    {
                        accRec.GA_Original_Enrollment_Date__c=grpSegNew.GA_Group_Effective_Date__c;                        
                    }
                    accRec.GA_Is_Mass_Updating__c = true;
                    accLst.add(accRec);                    
                }                
            }
            Database.update (accLst);
                 }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLASSNM, METHOD1);
        }
    } 
 /****
*@Description: checkLocalGroupUniqueness() method 
@Name : checkLocalGroupUniqueness
@Param : List<GA_Group_Segment__c> gpSegLst,Map<ID,GA_Group_Segment__c> gpSegOldMap
@Return : void
@throws Exception : N/A;
****/       
    public static void checkLocalGroupUniqueness(List<GA_Group_Segment__c> gpSegLst,map<id,GA_Group_Segment__c> gsoldMap)
    {
        try
        {      
            if(gpSegLst.size()==1)
            {
                for(GA_Group_Segment__c grp : gpSegLst){
                    //  GA_Group_Segment__c grp = gpSegLst[0]; 
                    //
                    if(gsoldMap!=null)
                    {
                        if(((gsoldMap.get(grp.Id).GA_Group_Number__c != grp.GA_Group_Number__c) && (grp.GA_Group_Number__c != null)) ||
                           ((gsoldMap.get(grp.Id).GA_Group_Suffix__c != grp.GA_Group_Suffix__c) && (grp.GA_Group_Suffix__c != null)))
                        {
                            String groupSegmentType = grp.Network__c;
                            String localGroupNumber = grp.GA_Group_Number__c;
                            String localGroupSuffix = grp.GA_Group_Suffix__c;
                            
                            if(groupSegmentType.contains(NASCOGRP) || groupSegmentType.contains(MOSGRP) || groupSegmentType.contains(MEDICRADV) || groupSegmentType.contains(BCNGRP)) 
                            {  
                                List<GA_Group_Segment__c> grpExistsLst = [Select Id from GA_Group_Segment__c where GA_Group_Number__c =: localGroupNumber and GA_Group_Suffix__c =: localGroupSuffix Limit 5000];
                                if(grpExistsLst.size() > 0 && !grpExistsLst.isEmpty())
                                {
                                    grp.addError(LCLINFOGRPSEGERRMSG);
                                }
                            }
                        }
                    }
                    else{
                        if(grp.GA_Group_Number__c != null || grp.GA_Group_Suffix__c!=null)
                        {
                            String groupSegmentType = grp.Network__c;
                            String localGroupNumber = grp.GA_Group_Number__c;
                            String localGroupSuffix = grp.GA_Group_Suffix__c;
                            
                            if(groupSegmentType.contains(NASCOGRP) || groupSegmentType.contains(MOSGRP) ||groupSegmentType.contains(MEDICRADV) || groupSegmentType.contains(BCNGRP)) 
                            {  
                                List<GA_Group_Segment__c> grpExistsLst = [Select Id from GA_Group_Segment__c where GA_Group_Number__c =: localGroupNumber and GA_Group_Suffix__c =: localGroupSuffix Limit 5000];
                                if(grpExistsLst.size() > 0 && !grpExistsLst.isEmpty())
                                {
                                    grp.addError(LCLINFOGRPSEGERRMSG);
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLASSNM, METHOD2);
        }
    } 

/* 
To create GA AOR Group Segment - on creation of Group Segment
*/

    public static void createGaAorGroup(Map<Id,sobject> gSMap) {
        try{
            list<GA_AOR_Group_Segment__c> lstgaAORgroup = new list<GA_AOR_Group_Segment__c>();  
        
            Map<ID,ID> AccGAAorID = new Map<Id,Id>();
            
            List<GA_AoR__c> gaAorList = [select id,GA_Account_Id__c from GA_AOR__c where GA_Account_Id__c =: gSMap.keyset()];
        
            if(gaAorList.size() > 0){
                for(GA_AoR__c gaor : gaAorList){
                    AccGAAorID.put(gaor.GA_Account_Id__c, gaor.Id);
                }
            }
        
            if(AccGAAorID.keyset().size() > 0){
                for(GA_group_segment__c ga : (List<GA_group_segment__c>)gSMap.values()){
                    GA_AOR_Group_Segment__c gaAORgroup = new GA_AOR_Group_Segment__c();
                    gaAORgroup.GA_Group_Segment_Id__c = ga.id;
                    gaAORgroup.GA_AOR_Id__c = AccGAAorID.get(ga.GA_Account__c);
                    gaAORgroup.GA_Is_Mass_updating__c = true;
                    lstgaAORgroup.add(gaAORgroup);
                }
            }
            if(lstgaAORgroup.size()>0){
                Database.insert(lstgaAORgroup);
            }
        }
        catch(exception e)
        {
            System.debug('Exception occured : '+e);
        }
    }
    
}