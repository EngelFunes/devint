/*********************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_ACC_UpdtGSLastMdfdDt
@CreatedDate: 10 - Jan 2017 
@Description: GA_ACC_UpdtGSLastMdfdDt class to update GS Last Modified Date for DOL,PA 250 fields
@version : 1.0  
**********************************************************************************************************************************************/
public without sharing class GA_ACC_UpdtGSLastMdfdDt {  
    public Static Final string CLSNAME='GA_ACC_UpdtGSLastMdfdDt';
    public Static Final string METDUPDTGSLSTMDFDDT='UpdtGSLstMdfdDt';
    public Static Final string METDUPDTMOSEXTRLAPPRCRD='updtMOSExtrlAppRcrd';
    public Static Final string ERRMSG='Could not update GS records';
    public Static Final string BCBSMCARRIER='BCBSM';
    public Static Final string NASCONTWRK='NASCO';
    public Static Final string MOSNTWRK='MOS';
    public Static Final string SELFFUNDASC='Self-Funded (ASC)';
    public Static Final string ASC2549='ASC 25-49';
    public Static Final string ASCNTNLITS='ASC National ITS';
    Public static boolean isExecuting=false;
    
    /*********************************************************************************************************************************************
@Description: UpdtGSLstMdfdDt() method 
@Name : UpdtGSLstMdfdDt
@Param :list<Account> accList, map<id,Account>  accoldMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/     
    public static void UpdtGSLstMdfdDt (list<Account> accList, map<id,Account>  accoldMap)
    {
        try
        {
            set<id> accIdLst = new set<id> ();
            boolean oldAccErisaExmptVal=false;
            boolean newAccErisaExmptVal=false;
            
            for(Account selAcct : accList){
                if(selAcct.GA_ERISA_Exempt__c != accOldMap.get(selAcct.Id).GA_ERISA_Exempt__c){
                    accIdLst.add(selAcct.Id); 
                    oldAccErisaExmptVal = accOldMap.get(selAcct.Id).GA_ERISA_Exempt__c;
                    newAccErisaExmptVal = selAcct.GA_ERISA_Exempt__c;
                }
                
            }
            
            List <GA_Group_Segment__c> gsUpdLst = new List <GA_Group_Segment__c> ();
            gsUpdLst = [select  Id,LastModifiedDate,GA_Rating_Type__c from  GA_Group_Segment__c where GA_Account__c IN: accIdLst Limit 5000];
            
            List <GA_Group_Segment__c> gsUpdRecLst = new List <GA_Group_Segment__c> ();
            if(!gsUpdLst.isEmpty()){
                for(GA_Group_Segment__c GrpRec : gsUpdLst)
                {
                    GrpRec.GA_Is_Mass_Updating__c = True;
                    gsUpdRecLst.add(GrpRec);
                }
                
                GA_GS_AP02_Update_Address.isExecuting=true;
                // GA_ExternlaAppleSrvcCls.isExecuting = true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                GA_GroupSegAccUpdateCls.isExecuting = true;
                //GA_GS_UpdateNHRDate.isExecuting = true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_AP02_Update_Address.isInvoked  = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                
                database.update(gsUpdRecLst);
                
                GA_ExternalAppealSrvcCls_NASCO.crtExtrlAppRcrdNASCO(gsUpdRecLst,newAccErisaExmptVal);                    
                GA_ExternalAppealSrvcCls_MOS.updtMOSExtrlAppRcrd(gsUpdRecLst,oldAccErisaExmptVal,newAccErisaExmptVal);
                
            }
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METDUPDTGSLSTMDFDDT); 
            accList[0].adderror(ERRMSG);
        }
    }
    /*********************************************************************************************************************************************
@Description: updtMOSExtrlAppRcrd() method 
@Name : updtMOSExtrlAppRcrd
@Param :list<GA_Group_Segment__c> gsList,boolean oldAccErisaExmptVal,boolean newAccErisaExmptVal
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/           
    /*public static void updtMOSExtrlAppRcrd (list<GA_Group_Segment__c> gsList,boolean oldAccErisaExmptVal,boolean newAccErisaExmptVal){
        try{
            Set<Id> gsIds = New Set<Id>();   
            boolean isChngPA250 = False;
            List <GA_External_Appeal__c> updtoldExtApplList = new List <GA_External_Appeal__c> ();   
            for(GA_Group_Segment__c gs : gsList)
            {
                if(gs.id <> null){
                    gsIds.add(gs.Id); 
                }
            }
            if(gsIds.size()>0)
            {
                //for(Id grpSegId :gsIds)
                for(GA_Group_Segment__c grpSegId : [select id,name,GA_Rating_Type__c from GA_Group_Segment__c where ID IN: gsIds  and GA_Carrier__c=: BCBSMCARRIER and Network__c=: MOSNTWRK limit 5000])
                {   
                    
                    if((oldAccErisaExmptVal)&&(!newAccErisaExmptVal && (grpSegId.GA_Rating_Type__c == SELFFUNDASC || 
                                                                                        grpSegId.GA_Rating_Type__c == ASC2549 ||
                                                                                        grpSegId.GA_Rating_Type__c == ASCNTNLITS)))
                    {
                        isChngPA250 = True;
                    }
                    if((!oldAccErisaExmptVal && (grpSegId.GA_Rating_Type__c == SELFFUNDASC || 
                                                         grpSegId.GA_Rating_Type__c == ASC2549 || 
                                                         grpSegId.GA_Rating_Type__c == ASCNTNLITS))&&
                       (newAccErisaExmptVal))
                    {
                        isChngPA250 = True;
                    }
                    
                    
                    updtoldExtApplList = new List <GA_External_Appeal__c> ();                  
                    List <GA_External_Appeal__c> oldExtApplList = [select id,name,GA_NHR_Eff_Date__c,GA_NHR_End_Date__c,GA_Group_Segment_Id__c,GA_Package_Number__c from GA_External_Appeal__c where GA_Group_Segment_Id__c =: grpSegId.Id order by createddate desc limit 5000];
                    
                    if(oldExtApplList.size()>0 && isChngPA250)
                    {
                        for(GA_External_Appeal__c extnlApp : oldExtApplList)
                        {
                            extnlApp.GA_NHR_Eff_Date__c = system.today();
                            updtoldExtApplList.add(extnlApp);                        
                        }                 
                    }              
                    
                    if(updtoldExtApplList.size()>0)
                    {
                        database.update(updtoldExtApplList);
                    }
                    
                    
                }
                
                
            }
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METDUPDTMOSEXTRLAPPRCRD); 
        }  
    }*/
    
}