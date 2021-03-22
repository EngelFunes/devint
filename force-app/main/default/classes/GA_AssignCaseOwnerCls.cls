/**
@Author : Prasant Kumar Satpathy
@Name: GA_AssignCaseOwnerCls
@CreatedDate:  18- Dec 2017 
@Description: GA_AssignCaseOwnerCls class is for updating Case Owner based on associated Reps
@version : 1.0  
*/ 
public without sharing class GA_AssignCaseOwnerCls {
    
    public static final String ClsName  ='GA_AssignCaseOwnerCls';
    public static final String methodNmeBefore  ='caseOwnerAssignBefore';
    public static final String methodNmeAfter  ='caseOwnerAssignAfter';
    public static final String CaseOrigin='Email';
    public static boolean isExecuting=false;
    public static boolean FirstTimeExecuting=false;
    public Static final String agentsrdefaultqueue = 'SR_ASR_Queue';
    public Static final String supportReqRecType = 'Support - Request';
    public Static final Id supportReqRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(supportReqRecType).getRecordTypeId();
    public static  id currentUserId = userinfo.getUserId();
    public static User currentUser = [SELECT profile.name, Delegate_User__c FROM user WHERE Id =: currentUserId];
    
    /**
@Description: caseOwnerAssignBefore() method 
@Name : caseOwnerAssignBefore
@Param : list<Case> caseList, map<id,Case> caseoldMap  
@Return : void
@throws Exception : N/A;
*/
    public static void caseOwnerAssignBefore(list<case> CaseLst,map<id,Case>caseoldMap)
    {
        try
        {
            Support_Request_Assignment__mdt suprRqstAssignMnt;
            list<queuesobject> queid=new list<queuesobject>();
            set<id> accid = new set<id>();
            string CaseRecTypeId;
            map<string,id> queNmIdMap=new map<string,id>();
            map<id,id> CasRecQueIdMap=new map<id,id>();
            map<id,string> accRegMap = new map<id,String>();
            map<id,Support_Request_Assignment__mdt> recTypSuprstMap=new map<id,Support_Request_Assignment__mdt>();
            set<string> queSet=new set<string>();
            string PrflName=[select name from profile where id=:userinfo.getProfileId() limit 1].name;
            
            list<Support_Request_Assignment__mdt> suprRqstAssignMntLst=[select label,GA_Record_Type_To_Change__c,GA_Assign_To_Queue__c,GA_Assign_To_Rep__c,GA_Profile_Name__c,GA_Record_Type__c from Support_Request_Assignment__mdt where GA_Profile_Name__c=:PrflName limit 100];
            
            if(suprRqstAssignMntLst.size()>0)
            {
                for(Support_Request_Assignment__mdt sprRst:suprRqstAssignMntLst)
                {
                    string queNm=sprRst.GA_Assign_To_Queue__c;
                    queSet.add(queNm);
                }
                queid=[select queueid,queue.developername from queuesobject where queue.developername in:queSet limit 100];
                
                for(queuesobject queVal:queid)
                {
                    queNmIdMap.put(queVal.queue.developername,queVal.queueid); 
                    system.debug('queNmIdMap:'+queNmIdMap);
                }
                
                for(case cse:CaseLst)
                {
                    accid.add(cse.AccountId); 
                }   
                
                
                list<Account> accRegionLst=[select id,GA_Territory__r.GA_Region__c from Account where Id in:accid and Account_Services_Representative__c = null];
                
                system.debug('accRegionLst:'+accRegionLst);
                
                for (Account accRegn:accRegionLst)
                {
                    String Rgn = accRegn.ga_territory__r.GA_Region__c;               
                    accRegMap.put(accRegn.id,Rgn);               
                }
                system.debug('accRegMap:'+accRegMap);
                
                if(queNmIdMap.values().size()>0)
                {
                    
                    for(Support_Request_Assignment__mdt sprRst:suprRqstAssignMntLst)
                    {
                        CaseRecTypeId=Schema.SObjectType.case.getRecordTypeInfosByName().get(sprRst.GA_Record_Type__c).getRecordTypeId(); 
                        recTypSuprstMap.put(CaseRecTypeId,sprRst);
                        CasRecQueIdMap.put(CaseRecTypeId,queNmIdMap.get(sprRst.GA_Assign_To_Queue__c));
                    }
                    
                    for(case cse:CaseLst)
                    {
                        system.debug('CaseLst:'+cse);
                        
                        boolean agntPrtlCase=false;
                        boolean ownerupdte=false;
                        /*** change the case queue if account does not have account an assigned ASR submitted from Agent Portal **/
                        if(accRegMap.keyset().contains(cse.AccountId) && cse.GA_Envelope_Id__c != null)                                 
                        {
                            agntPrtlCase=true;
                        }
                        system.debug('AgentPortalCase:'+agntPrtlCase);
                        if(caseoldMap ==null)
                        {
                            if(cse.Origin == CaseOrigin)
                                ownerupdte=false; 
                            else
                            {
                                if(cse.GA_Submit_to_Support__c || cse.RecordTypeId !=supportReqRecTpeId || (agntPrtlCase))
                                    ownerupdte=true; 
                                else
                                    ownerupdte=false;   
                            }
                            
                            
                        }
                        
                        else
                        {
                            case caseOld=caseoldMap.get(cse.id);
                            
                            if((((caseOld.AccountId !=cse.AccountId)||(caseOld.GA_ASR__c !=cse.GA_ASR__c))  && cse.RecordTypeId !=supportReqRecTpeId)     || (caseOld.GA_Submit_to_Support__c !=cse.GA_Submit_to_Support__c) || (agntPrtlCase))
                            {
                                ownerupdte=true; 
                            }
                        }
                        system.debug('OwnerUpdte:'+ownerupdte);
                        
                        system.debug('agntPrtlCase:'+agntPrtlCase);
                        
                        if(ownerupdte)
                        {
                            
                            if(recTypSuprstMap.keyset().contains(cse.RecordTypeId))
                            {
                                
                                
                                if(string.isBlank(string.valueof(cse.get(recTypSuprstMap.get(cse.RecordTypeId).GA_Assign_To_Rep__c)))) 
                                {
                                    
                                    string oldREcTyp=cse.RecordTypeId;
                                    if(!string.isBlank(recTypSuprstMap.get(cse.RecordTypeId).GA_Record_Type_To_Change__c))
                                    {
                                        cse.GA_IsRecTypeChanged__c = true;
                                        cse.RecordTypeId=  Schema.SObjectType.case.getRecordTypeInfosByName().get(recTypSuprstMap.get(cse.RecordTypeId).GA_Record_Type_To_Change__c).getRecordTypeId();
                                    }
                                    if((cse.GA_ASR__c <> null) )
                                    {             
                                        System.debug('entered here');
                                        cse.ownerid= cse.GA_ASR__c; 
                                    }
                                    else
                                        cse.OwnerId=CasRecQueIdMap.get(oldREcTyp);
                                    
                                }
                                else
                                {
                                    string oldREcTyp=cse.RecordTypeId;
                                    if(!string.isBlank(recTypSuprstMap.get(cse.RecordTypeId).GA_Record_Type_To_Change__c))
                                    {
                                        cse.GA_IsRecTypeChanged__c = true;
                                        cse.RecordTypeId=  Schema.SObjectType.case.getRecordTypeInfosByName().get(recTypSuprstMap.get(cse.RecordTypeId).GA_Record_Type_To_Change__c).getRecordTypeId();
                                    }
                                    if((cse.GA_ASR__c <> null) )
                                    {             
                                        cse.ownerid= cse.GA_ASR__c; 
                                    }
                                    else
                                        cse.OwnerId= string.valueof(cse.get(recTypSuprstMap.get(oldREcTyp).GA_Assign_To_Rep__c));
                                }
                                
                            } 
                        }
                        system.debug('FinalCaseLst:'+cse);
                    }   
                }
            }
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeBefore);
        }
        
    }
    
    
    /**
@Description: caseOwnerAssignAfter() method 
@Name : caseOwnerAssignAfter
@Param : list<Case> caseList, map<id,Case> caseoldMap  
@Return : void
@throws Exception : N/A;
*/
    public static void caseOwnerAssignAfter(list<case> CaseLst)
    {
        try
        {
            list<case> CaseToUpdate=new list<case>();
            map<string,string> queRepMap=new map<string,string>();
            list<Support_Request_Assignment__mdt> suprRqstAssignMntLst=[select label,GA_Assign_To_Queue__c,GA_Assign_To_Rep__c,GA_Profile_Name__c,GA_Record_Type__c from Support_Request_Assignment__mdt limit 50];
            for(Support_Request_Assignment__mdt supRqstAssgn:suprRqstAssignMntLst)
            {
                queRepMap.put(supRqstAssgn.GA_Assign_To_Queue__c, supRqstAssgn.GA_Assign_To_Rep__c);
            }
            for(case cse:CaseLst)
            {
                case cs=new case();
                cs.id=cse.id;
                If(cse.Origin == CaseOrigin && cse.AccountId !=null && cse.get(queRepMap.get(cse.GA_Queue_Name__c)) !=null)
                {
                    cs.OwnerId= string.valueof(cse.get(queRepMap.get(cse.GA_Queue_Name__c)));
                }
                cs.GA_CaseSupportManager__c=cse.GA_Support_Manager_Email_Frml__c;
                CaseToUpdate.add(cs); 
                break;
            }
            
            if(CaseToUpdate.size()>0){
                GA_Util19_CaseDataAccessHelper.dmlOnCase(CaseToUpdate, GA_Util19_CaseDataAccessHelper.UPDATE_OPERATION);
            }
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeAfter);
        }
        
    }
    
    public static void caseAccessSharetoSuperUserAfter(list<case> CaseLst, map<id,Case> caseoldMap)
        
    {
        try
        {
            id recTypeIdofSupportReq = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
            
            set<id> agentContatsAgnstSR = new set<id>();
            List<Case> caselstagentshare = new List<Case>();
            List<Id> queueCaseList= new List<Id>();
            
            for (Case  caserec: CaseLst) {         
                if (caserec.recordtypeid == recTypeIdofSupportReq) {
                    if (caseRec.Recordtypeid == recTypeIdofSupportReq && (currentUser.profile.name == System.label.User_Profile_Name_BCBSM_Both ||                                             
                                                                          currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_Both_Login ||
                                                                          currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA_login ||
                                                                          currentUser.profile.name == System.label.User_Profile_Name_BCBSM_FSA ||
                                                                          currentUser.profile.name == System.label.User_Profile_Name_MAUser ||
                                                                          currentUser.profile.name == System.label.User_Profile_Name_Pilot ||
                                                                          currentUser.profile.name == System.label.User_Profile_Name_MAcommunityLogin)
                        && caseRec.Status != null && caseRec.Status=='Submitted'    && ((caseOldMap ==null && CaseRec.GA_ASR__c == null )||(caseOldMap != null &&  caseOldMap.get(caseRec.id).Status != null && caseOldMap.get(caseRec.id).Status != 'Submitted' && caseOldMap.get(caseRec.id).GA_ASR__c==null)) ) 
                    {
                        caselstagentshare.add(caseRec);                             
                        agentContatsAgnstSR.add(caserec.GA_AgentName__c);
                        
                        if(caserec.Ownerid ==System.label.Agent_ASR_Support_request_Queue_ID){
                            queueCaseList.add(caserec.Id);
                        }
                    }
                }
                
            }
            
            if(queueCaseList !=null && queueCaseList.size()>0){
                List<Case> caseDMLList = new List<Case>();
                Database.DMLOptions dmo = new Database.DMLOptions();
                //dmo.AssignmentRuleHeader.useDefaultRule = true;
                dmo.EmailHeader.TriggerUserEmail = true;
                if(!FirstTimeExecuting){
                    FirstTimeExecuting=true;
                    for(Case c : [SELECT Id FROM Case WHERE Id IN: queueCaseList]) {
                        c.setOptions(dmo);
                        caseDMLList.add(c);
                    }
                    update caseDMLList ;
                }
            }
            
            map<id, id> contactiDUsermap = new map<id, id>();
            List<user> agentUser = [select id, contactid, name from user where contactid in: agentContatsAgnstSR];
            for (User userRec : agentUser) {
                contactiDUsermap.put(userRec.contactid, userRec.id);
            }
            
            List<CaseShare> allShares = new List<CaseShare>();                                    
            
            if (caselstagentshare.size() > 0 ) {
                for (case delgatedShare : caselstagentshare) {
                    
                    CaseShare caseShareRec = new CaseShare(); 
                    caseShareRec.Caseid  = delgatedShare.Id;
                    caseShareRec.UserOrGroupId = UserInfo.getuserid();
                    caseShareRec.CaseAccessLevel = 'edit';
                    caseShareRec.RowCause = Schema.CaseShare.RowCause.Manual;
                    allShares.add(caseShareRec);
                }
                // }
            }
            
            System.debug(logginglevel.info,'All shares' +  allShares);
            //System.debug(logginglevel.info,'Delegate share cases' + caselstToprocess);
            //System.debug(logginglevel.info,'share to agent ' + caseLstDelegatedShare);
            
            if (allShares.size() > 0 ) {
                List<Database.SaveResult> sr = Database.insert(allShares,false);
            }
            
            
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeAfter);
        }
        
        
    }
    
    /**
@Description: aSRAssignmentforAgnetCaseBefore() method 
@Name : aSRAssignmentforAgnetCaseBefore
@Param : list<Case> caseList, map<id,Case> caseoldMap  
@Return : void
@throws Exception : N/A;
*/
    
    public static void aSRAssignmentforAgnetCaseBefore(list<case> CaseList, map<id, case> caseOldMap){
        id recTypeIdofSupportReq = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
        id recTypeIdofRegionTrrMapID =  Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region Territory Map').getRecordTypeId();
        id recTypeIdofRegionASRMapID =  Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region ASR Map').getRecordTypeId();
        set<Id> caseAccountIdSet = new Set<id>(); 
        List<Case> CaseLst = new List<Case>(); 
        try{
            for (Case caseRec : CaseList) {
                // if (caseRec.Recordtypeid == recTypeIdofSupportReq && currentUser.profile.name == System.label.User_Profile_Name_Agent &&  CaseRec.GA_ASR__c == null  ) {
                /**&& (currentUser.profile.name == System.label.User_Profile_Name_BCBSM_Both ||
currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_Both_Login ||
currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA_login ||
currentUser.profile.name == System.label.User_Profile_Name_BCBSM_FSA ||
currentUser.profile.name == System.label.User_Profile_Name_MAUser ||
currentUser.profile.name == System.label.User_Profile_Name_Pilot ||
currentUser.profile.name == System.label.User_Profile_Name_MAcommunityLogin)&&caseRec.Recordtypeid == recTypeIdofSupportReq   **/
                Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Case.getRecordTypeInfosById();
                
                if ( System.Label.Round_Robin_Allowed_Case_Record_Types.contains(rtMap.get(caseRec.Recordtypeid).getName())&& 
                    CaseRec.GA_ASR__c == null && caseRec.Status != null && caseRec.Status=='Submitted'  && ((caseOldMap ==null )||(caseOldMap != null && 
                                                                                                                                   caseOldMap.get(caseRec.id).Status != null && caseOldMap.get(caseRec.id).Status != 'Submitted'))) {
                                                                                                                                       CaseLst.add(caseRec); 
                                                                                                                                       caseAccountIdSet.add(caseRec.AccountId);
                                                                                                                                   }  
            }
            Map<Id, Account> AccountMap = new map<id, Account> ([Select id, Account_Services_Representative__c,Account_Services_Representative__r.isactive, GA_Territory__c from Account where id in : caseAccountIdSet]);
            
            List<Case> territoryBasedLst = new List<case>(); 
            List<Case> deafultCaseLst = new List<Case>(); 
            set<Id> territoryIdSet = new set<id>(); 
            
            
            for (Case  CaseRec: CaseLst) {
                //if (CaseRec.RecordtypeId == recTypeIdofSupportReq) {
                if (AccountMap.get(CaseRec.Accountid).Account_Services_Representative__c != null && AccountMap.get(CaseRec.Accountid).Account_Services_Representative__r.isactive ) {
                    CaseRec.GA_ASR__c  = AccountMap.get(CaseRec.Accountid).Account_Services_Representative__c;
                    CaseRec.Ownerid = AccountMap.get(CaseRec.Accountid).Account_Services_Representative__c; 
                }
                else if(AccountMap.get(CaseRec.Accountid).GA_Territory__c != null){
                    territoryBasedLst.add(CaseRec); 
                    territoryIdSet.add(AccountMap.get(CaseRec.Accountid).GA_Territory__c); 
                }
                else {
                    deafultCaseLst.add(CaseRec);
                }
                // }
            }
            map<Id , String> terrRegionMap = new Map<Id, String>(); 
            Set<String> regionsSet = new Set<String>(); 
            List<Territory_ASR_Assignment_List__c> regionTerrList = [select id, Territory_Region__c, Territory__c from Territory_ASR_Assignment_List__c where Territory__c in : territoryIdSet
                                                                     and Active__c = true and recordtypeid = : recTypeIdofRegionTrrMapID ];
            
            System.debug(logginglevel.info,'territoryIdSet' + territoryIdSet); 
            System.debug(logginglevel.info,'regionTerrList' + regionTerrList); 
            
            
            
            for (Territory_ASR_Assignment_List__c regTrrRec : regionTerrList) {
                terrRegionMap.put(regTrrRec.Territory__c, regTrrRec.Territory_Region__c); 
                regionsSet.add(regTrrRec.Territory_Region__c);        
            }
            // regionsSet.add('Default');      
            
            List<Territory_ASR_Assignment_List__c> regionASRList = [select id, Territory_Region__c, ASR__c, ASR__r.isactive,Round_Robin_Turn__c from Territory_ASR_Assignment_List__c where Territory_Region__c in : regionsSet
                                                                    and Active__c = true and recordtypeid = : recTypeIdofRegionASRMapID and ASR__c != null and ASR__r.isactive =true  order by Territory_Region__c, createddate];
            map<String, List<Territory_ASR_Assignment_List__c>> regionASRLstMap = new map<String, List<Territory_ASR_Assignment_List__c>>(); 
            for (String regrec : regionsSet) {
                List<Territory_ASR_Assignment_List__c> regASRListVar = new List<Territory_ASR_Assignment_List__c>(); 
                for (Territory_ASR_Assignment_List__c regAsrRec : regionASRList) {
                    if (regAsrRec.Territory_Region__c == regrec) {
                        regASRListVar.add(regAsrRec); 
                    }
                }
                regionASRLstMap.put(regrec, regASRListVar); 
            }
            for (Case caseRec : territoryBasedLst) {
                Id territoryId = AccountMap.get(CaseRec.Accountid).GA_Territory__c; 
                if (terrRegionMap.get(territoryId) != null ){
                    String regionVar = terrRegionMap.get(territoryId); 
                    List<Territory_ASR_Assignment_List__c> regASRListVar = regionASRLstMap.get(regionVar); 
                    if (regASRListVar.size() > 0 ) {
                        Boolean isAssigned = false ; 
                        for (Territory_ASR_Assignment_List__c regASRRec : regASRListVar) {
                            if (regASRRec.Round_Robin_Turn__c == false && regASRRec.ASR__r.isactive) {
                                caseRec.GA_ASR__c = regASRRec.ASR__c; 
                                regASRRec.Round_Robin_Turn__c = true ;
                                CaseRec.Ownerid = regASRRec.ASR__c;
                                isAssigned = true; 
                                break ;
                            } /**else {
deafultCaseLst.add(CaseRec);
} **/
                        } 
                        if (isAssigned == false) {
                            for (Territory_ASR_Assignment_List__c regASRRec : regASRListVar) {
                                regASRRec.Round_Robin_Turn__c = false; 
                            }
                            for (Territory_ASR_Assignment_List__c regASRRec : regASRListVar) {
                                
                                if(regASRRec.ASR__c != null && regASRRec.ASR__r.isactive){
                                    caseRec.GA_ASR__c = regASRRec.ASR__c;
                                    CaseRec.Ownerid = regASRRec.ASR__c; 
                                    regASRRec.Round_Robin_Turn__c = true; 
                                    isAssigned = true; 
                                    break;
                                }/**else {
deafultCaseLst.add(CaseRec);
}**/
                            }
                        }
                        regionASRLstMap.put(regionVar, regASRListVar); 
                    }
                    else {
                        deafultCaseLst.add(CaseRec);
                    }
                }
                else {
                    deafultCaseLst.add(CaseRec);
                }  
            }
            if(deafultCaseLst!= null && deafultCaseLst.size()>0){
                for (Case caseRec : deafultCaseLst) {
                    List<queuesobject> queid=[select queueid,id,queue.developername from queuesobject where queue.developername =: agentsrdefaultqueue];
                    caseRec.OwnerId=queid[0].queueid;   
                    // caseRec.setOptions(option);
                    
                }
            }
            // for (Case caseRec : deafultCaseLst) {
            //     String regionVar = 'Default'; 
            //         List<Territory_ASR_Assignment_List__c> regASRListVar = regionASRLstMap.get(regionVar); 
            //         if (regASRListVar.size() > 0 ) {
            //             Boolean isAssigned = false ; 
            //             for (Territory_ASR_Assignment_List__c regASRRec : regASRListVar) {
            //                 if (regASRRec.Round_Robin_Turn__c == false) {
            //                     caseRec.GA_ASR__c = regASRRec.ASR__c; 
            //                     regASRRec.Round_Robin_Turn__c = true ; 
            //                     isAssigned = true; 
            //                     break ; 
            //                 } 
            //             } 
            //             if (isAssigned == false) {
            //                 for (Territory_ASR_Assignment_List__c regASRRec : regASRListVar) {
            //                     regASRRec.Round_Robin_Turn__c = false; 
            //                 }
            //                 caseRec.GA_ASR__c = regASRListVar[0].ASR__c; 
            //                 regASRListVar[0].Round_Robin_Turn__c = true; 
            //             }
            //             regionASRLstMap.put(regionVar, regASRListVar); 
            //         }
            //         else {
            //             System.debug('ASR assignment Criterias are not mainteded Contact Administrator'); 
            //         }
            // }
            List<Territory_ASR_Assignment_List__c> finalterrASRmapList = new List<Territory_ASR_Assignment_List__c>(); 
            for (List<Territory_ASR_Assignment_List__c> lstAsrTerrListRec : regionASRLstMap.values()) {
                for (Territory_ASR_Assignment_List__c  lstAsrTerrRec: lstAsrTerrListRec) {
                    finalterrASRmapList.add(lstAsrTerrRec); 
                }      
            }
            update finalterrASRmapList;  
        }
        catch(Exception e){
            
            system.debug(logginglevel.error,+ e.getMessage());
            GA_LogExceptionCls.LogExcp(e, ClsName, 'aSRAssignmentforAgnetCaseBefore');
            
        }
    }
    
}