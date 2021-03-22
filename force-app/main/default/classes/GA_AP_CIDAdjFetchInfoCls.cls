/*****************************************************************************************
Class Name   : GA_AP_CIDAdjFetchInfoCls
Date Created : 12/13/2018
Created By   : IDC Offshore
Description  : To fetch info and update the CID Adjustment Confirmation page
******************************************************************************************/
public without sharing class GA_AP_CIDAdjFetchInfoCls {   
    public static final string CLSNAME  ='GA_AP_CIDAdjFetchInfoCls';
    public static final string MTHDFETCHCIDADJRECINFO  ='fetchCIDAdjRecInfo';
    public static final string MTHDUPDATECIDADJSTATUS  ='UpdateCIDAdjStatus';
    public static final string MTHDUPDATEAPPRVSTATUS  ='UpdateApprvStatus';
    public static final string MTHDREQSTFRAPRVL  ='reqstFrAprvl'; 
    public static final string MTHDSENDFRADDINFO  ='SendFrAddInfo';
    public static final string MTHDCHKLOGGEDINUSRPRFLE  ='chkLoggedInUsrprfle';
    public static final string MTHDRESTADDTNLBTNACCESS  = 'restAddtnlbtnAccess';
    public static final String EXCEPSEPARTR=': ';
    public static final string CMPLETD =  'Completed' ;
    public static final string INACTIVE=  'Inactive' ;
    public static final string PENDNG =  'Pending' ;
    public static final string APPRVD =  'Approved' ;
    public static final string PENDNGAPPRVL =  'Pending Approval' ;
    public static final string TERTRY =  'Territory' ;
    public static final string SYSADMN =  'System Administrator' ;
    public static final string NULLSTRNG='';
    public static final string PROSPECTACC=  'Account - Prospect' ;
    public static final string ADDINFOTMP='GA_CID_Request_Additional_Information';
    public static final string ADDINFOSUB='Additional Information Requried:-';
    public static final string ADDINFOSENDAS='CID Adjustment Info';
    /**
@Description: fetchCIDAdjRecInfo() method 
@Name : fetchCIDAdjRecInfo
@Param : string CIDAdjID
@Return : GA_CID_Adjustment__c
@throws Exception : AuraHandledException
*/    
    @AuraEnabled
    public static GA_CID_Adjustment__c fetchCIDAdjRecInfo(string CIDAdjID)
    {
        try{
            GA_CID_Adjustment__c cidAdjRec=[select id,Name,GA_Status__c,ownerid,createdById,createdBy.Name,createdBy.Email,GA_Territory_Code_Approver__r.Name,GA_Federal_Tax_ID_Approver__r.Name,GA_All_Group_Segments__c,GA_Source_Account__c,GA_Source_Account__r.CID__c,GA_Source_Account__r.Name,
                                            GA_Federal_Tax_ID_Mismatch__c,GA_Territory_Code_Mismatch__c,GA_Source_Account__r.GA_Territory__r.GA_TerritoryCode__c,GA_Source_Account__r.Federal_Tax_ID__c,
                                            GA_Source_Account__r.GA_Decision_Maker__c,GA_Source_Account__r.GA_Decision_Maker__r.Name,
                                            GA_Source_Account__r.GA_Mutual_Voter__c,GA_Source_Account__r.GA_Mutual_Voter__r.Name,
                                            GA_Source_Account__r.Renewal_Month__c,GA_Source_Account__r.GA_System_of_Record__c,
                                            GA_Target_Account__c, GA_Target_Account__r.CID__c,GA_Target_Account__r.Name,
                                            GA_Target_Account__r.GA_Territory__r.GA_TerritoryCode__c,GA_Target_Account__r.Federal_Tax_ID__c,
                                            GA_Target_Account__r.GA_Decision_Maker__c,GA_Target_Account__r.GA_Decision_Maker__r.Name,
                                            GA_Target_Account__r.GA_Mutual_Voter__c,GA_Target_Account__r.GA_Mutual_Voter__r.Name,
                                            GA_Target_Account__r.Renewal_Month__c,GA_Target_Account__r.GA_System_of_Record__c,                                            
                                            (select id,Name,GA_Group_Segment__r.Name,GA_Group_Segment__r.Status__c,GA_Group_Segment__r.Network__c from Process_Group_Segments__r Limit 1000),
                                            (select id,GA_Approver__c,GA_Approver__r.Name,GA_Received__c,GA_Status__c,GA_Submitted__c,GA_Type__c from Approvals__r Limit 1000) from GA_CID_Adjustment__c  where id =:CIDAdjID Limit 1];
            
            return cidAdjRec;        
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDFETCHCIDADJRECINFO);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
@Description: UpdateCIDAdjStatus() method 
@Name : UpdateCIDAdjStatus
@Param : string CIDAdjID
@Return : void
@throws Exception : AuraHandledException
*/     
    @AuraEnabled
    public static void UpdateCIDAdjStatus(String CIDAdjID)
    {    
        try{
            String SPC=', ';
            Map<GA_CID_Adjustment__c, List<GA_Process_Group_Segment__c>> prgrpsgmt= new Map<GA_CID_Adjustment__c, List<GA_Process_Group_Segment__c>>();
            set<id> cntcIds=new set<id>();
            
            for (GA_CID_Adjustment__c cidAdj: [select id,Name,GA_Status__c,GA_Source_Account__c,GA_Federal_Tax_ID_Mismatch__c,GA_Source_Account__r.CID__c,GA_Target_Account__c,GA_All_Group_Segments__c,GA_List_of_Group_Segments__c,
                                               (select id,Name,GA_Group_Segment__r.id,GA_Group_Segment__r.Name,GA_Group_Segment__r.Status__c,GA_Group_Segment__r.Network__c,
                                                GA_Group_Segment__r.GA_Administrative_Contact_Id__c,GA_Group_Segment__r.GA_Billing_Contact_Id__c,GA_Group_Segment__r.GA_Servicing_Agent__c,GA_Group_Segment__r.GA_Commissioning_Agent__c,
                                                GA_Group_Segment__r.GA_Account__c from Process_Group_Segments__r Limit 1000)
                                               from GA_CID_Adjustment__c  where id =:CIDAdjID Limit 1]) {
                                                   prgrpsgmt.put(cidAdj, cidAdj.Process_Group_Segments__r);
                                               }
            
            List<GA_Group_Segment__c> gsLst = New List<GA_Group_Segment__c>();
            List<GA_CID_Adjustment__c> cidAdjLst = New List<GA_CID_Adjustment__c>();
            
            GA_CID_Adjustment__c currentCIDAdjust = New GA_CID_Adjustment__c();
            
            GA_group_segment__c grpsgmt = New GA_group_segment__c();
            for(GA_CID_Adjustment__c mkey : prgrpsgmt.keyset() )
            {
                for(GA_Process_Group_Segment__c pgs : prgrpsgmt.get(mkey) )
                {
                    grpsgmt = New GA_group_segment__c(id = pgs.GA_Group_Segment__r.id );
                    grpsgmt.GA_Account__c = mkey.GA_Target_Account__c;
                    grpsgmt.GA_Prior_CID__c=mkey.GA_Source_Account__r.CID__c;
                    grpsgmt.GA_Is_Mass_Updating__c=True;
                    grpsgmt.GA_In_Progress__c=false;
                    grpsgmt.GA_In_Progress_Type__c=NULLSTRNG;
                    //grpsgmt.GA_Commissionable__c=false;
                    //grpsgmt.GA_Commission_Effective_Date__c=null;
                    //grpsgmt.GA_Commission_Notes__c=NULLSTRNG;
                    //grpsgmt.GA_Servicing_Agent__c=null;
                    //grpsgmt.GA_Managing_Agency__c=null;
                    if(mkey.GA_List_of_Group_Segments__c!=''){
                      mkey.GA_List_of_Group_Segments__c= mkey.GA_List_of_Group_Segments__c+SPC+grpsgmt.name;  
                    }
                    else{
                      mkey.GA_List_of_Group_Segments__c= grpsgmt.name;
                    }
                    gsLst.add(grpsgmt);
                    
                    updateEndDateinGSRelatedRecords(pgs.GA_Group_Segment__r.id);
                    
                    if(pgs.GA_Group_Segment__r.GA_Administrative_Contact_Id__c !=null)
                    {
                       cntcIds.add(pgs.GA_Group_Segment__r.GA_Administrative_Contact_Id__c );
                    }
                    if(pgs.GA_Group_Segment__r.GA_Billing_Contact_Id__c !=null)
                    {
                        cntcIds.add(pgs.GA_Group_Segment__r.GA_Billing_Contact_Id__c);
                    }
                    if(pgs.GA_Group_Segment__r.GA_Servicing_Agent__c !=null)
                    {
                        cntcIds.add(pgs.GA_Group_Segment__r.GA_Servicing_Agent__c);
                    }
                    if(pgs.GA_Group_Segment__r.GA_Commissioning_Agent__c !=null)
                    {
                        cntcIds.add(pgs.GA_Group_Segment__r.GA_Commissioning_Agent__c);
                    }
                    
                }
                mkey.GA_Status__c = CMPLETD;   
                cidAdjLst.add(mkey);        
                currentCIDAdjust = mkey;
            } 
            List<Case> updtcsLst = New  List<Case>();
            List<GA_WF_Workflow__c> updtwfLst =  New   List<GA_WF_Workflow__c>();
            
            List<Account> updtsraccLst =  New  List<Account>();
            if(currentCIDAdjust.GA_Federal_Tax_ID_Mismatch__c){
                Account accTrgt=new Account();
                accTrgt.id=currentCIDAdjust.GA_Target_Account__c;
                accTrgt.GA_Tax_ID_Exception__c=true;
                accTrgt.GA_Is_Mass_Updating__c=True;
                updtsraccLst.add(accTrgt);
            }
            if(currentCIDAdjust.GA_All_Group_Segments__c)
            {
                for(case cs:[select id,AccountId from case where AccountId =:currentCIDAdjust.GA_Source_Account__c Limit 1000])
                {
                    cs.AccountId= currentCIDAdjust.GA_Target_Account__c;
                    cs.GA_Is_Mass_Updating__c=True;
                    updtcsLst.add(cs);
                }
                
                for(GA_WF_Workflow__c wf:[select id,GA_Account__c from GA_WF_Workflow__c where GA_Account__c=:currentCIDAdjust.GA_Source_Account__c Limit 5000])
                {
                    wf.GA_Account__c= currentCIDAdjust.GA_Target_Account__c;
                    updtwfLst.add(wf);
                }
                
                Id prsRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(PROSPECTACC).getRecordTypeId();
                Account sracc=new Account();
                sracc.Id=currentCIDAdjust.GA_Source_Account__c;
                sracc.Account_Status__c=INACTIVE;
                sracc.RecordTypeId=prsRecordTypeId;
                sracc.GA_Is_Mass_Updating__c=True;
                updtsraccLst.add(sracc);
            }
            
            List<AccountContactRelation> newAccCntRlntLst =  New  List<AccountContactRelation>();
            
            for(AccountContactRelation TrgtaccCntRl : [select id,AccountId,ContactId from AccountContactRelation where AccountId =:currentCIDAdjust.GA_Target_Account__c Limit 2000]){
                if(cntcIds.contains(TrgtaccCntRl.contactId))
                {
                    cntcIds.remove(TrgtaccCntRl.contactId);
                }
            }
            AccountContactRelation acntCntcRltn = new AccountContactRelation();
            if(cntcIds.size()>0)
            {
                for(Id cntctId:cntcIds)
                {
                    
                    acntCntcRltn = new AccountContactRelation();
                    acntCntcRltn.AccountId=currentCIDAdjust.GA_Target_Account__c;
                    acntCntcRltn.ContactId=cntctId;
                    newAccCntRlntLst.add(acntCntcRltn);   
                }
            }
            
            
            if(newAccCntRlntLst.size()>0)
            {
                database.insert(newAccCntRlntLst);
            }
            
            if(updtcsLst.size()>0)
            {
                database.update(updtcsLst);
            }
            
            if(updtwfLst.size()>0)
            {
                database.update(updtwfLst);
            }
            
            if(updtsraccLst.size()>0)
            {
                database.update(updtsraccLst);
            }
            GA_GS_AP02_Update_Address.isExecuting=true;
            GA_AccountTriggerHandlr.isExecuting=true;
            GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
            GA_Util_lockRecords.isExecuting = true;
            GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
            GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
            GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
            GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
            GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
           // GA_ExternlaAppleSrvcCls.isExecuting = true;
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
            
            if(!gsLst.isEmpty()){
                 Database.update(gsLst);
                // To update AOR Segment records
                UpdateAorSegmentController.updateAorSegment(gsLst);
            }
            if(!cidAdjLst.isEmpty()){
            Database.update(cidAdjLst);
            }
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDUPDATECIDADJSTATUS);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
@Description: UpdateApprvStatus() method 
@Name : UpdateApprvStatus
@Param : string aprvId
@Return : void
@throws Exception : AuraHandledException
*/       
    @AuraEnabled
    public static void UpdateApprvStatus(string aprvId)
    {
        try
        {
            GA_Approval__c aprv=new GA_Approval__c();
            aprv.Id=aprvId;
            aprv.GA_Status__c=APPRVD;
            aprv.GA_Submitted__c=system.today();
            database.update(aprv);   
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDUPDATEAPPRVSTATUS);
            throw new AuraHandledException(e.getMessage());  
        }
    }
  /**
@Description: reqstFrAprvl() method 
@Name : reqstFrAprvl
@Param : string terrApvr,string FedTaxApvr,string cidRecId
@Return : void
@throws Exception : AuraHandledException
*/       
    @AuraEnabled
    public static void reqstFrAprvl(string terrApvr,string FedTaxApvr,string cidRecId)
    {
        try
        {
            list<sObject> sobjctLst=new list<sObject>();
            list<GA_Approval__c> apprvlInfoLst=[select id,GA_Approver__c,GA_Type__c from GA_Approval__c where GA_CID_Adjustment__c =:cidRecId Limit 5000];
            for(GA_Approval__c apvl:apprvlInfoLst)
            {
                if(apvl.GA_Type__c==TERTRY)
                {
                    if(terrApvr !=null){
                        apvl.GA_Approver__c=terrApvr; 
                    }
                }
                
                else
                {
                    if(FedTaxApvr !=null){
                        apvl.GA_Approver__c=FedTaxApvr;  
                    }
                }
                apvl.GA_Received__c=system.today();
                apvl.GA_Status__c=PENDNG;
            }
            GA_CID_Adjustment__c cidAdjmnt=new GA_CID_Adjustment__c();
            cidAdjmnt.Id=cidRecId;
            cidAdjmnt.GA_Status__c=PENDNGAPPRVL;
            cidAdjmnt.GA_Territory_Code_Approver__c=terrApvr;
            cidAdjmnt.GA_Federal_Tax_ID_Approver__c=FedTaxApvr;
            sobjctLst.add(cidAdjmnt);
            sobjctLst.addAll(apprvlInfoLst);
            database.update(sobjctLst);
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDREQSTFRAPRVL);
            throw new AuraHandledException(e.getMessage());  
        }
    }
  /**
@Description: SendFrAddInfo() method 
@Name : SendFrAddInfo
@Param : GA_CID_Adjustment__c cidRec,string cmmnts
@Return : void
@throws Exception : AuraHandledException
*/          
    @AuraEnabled
    public static void SendFrAddInfo(GA_CID_Adjustment__c cidRec,string cmmnts)
    {
        try
        {
            string threadIdVal='';
            boolean mastCIDRqstAddinfo=false;
            GA_CID_Request_Additional_Info__c restApprvl=new GA_CID_Request_Additional_Info__c();
            list<GA_CID_Request_Additional_Info__c> cidReqApvlMstrLst=[select id,Name,GA_Sent_From__c,GA_Comments__c from GA_CID_Request_Additional_Info__c where GA_Sent_From__c=:userinfo.getUserId() and GA_Master_CID_Request_Additional_Info__c=null and GA_CID_Adjustment__c=:cidRec.Id order by createddate desc limit 1];
            
            if(cidReqApvlMstrLst.size()>0)
            {
                
                GA_CID_Request_Additional_Info__c cidReqApvlMstr=cidReqApvlMstrLst[0]; 
                threadIdVal=cidReqApvlMstr.Name;
                list<GA_CID_Request_Additional_Info__c> restApprvlLst=[select id,GA_Comments__c from GA_CID_Request_Additional_Info__c 
                                                                       where GA_Master_CID_Request_Additional_Info__c=:cidReqApvlMstr.Id and GA_CID_Adjustment__c=:cidRec.Id  order by createddate desc Limit 1]; 
                
                if(restApprvlLst.size()>0)
                {
                    restApprvl.GA_Sent_From__c=userInfo.getUserId();
                    restApprvl.GA_Sent_To__c= cidRec.createdById;  
                    restApprvl.GA_Master_CID_Request_Additional_Info__c=cidReqApvlMstr.Id;
                    restApprvl.GA_CID_Adjustment__c=cidRec.Id;
                 //   restApprvl.GA_Comments__c=cmmnts+'\n'+restApprvlLst[0].GA_Comments__c;
                    restApprvl.GA_Comments__c=cmmnts;
                    database.insert(restApprvl); 
                    mastCIDRqstAddinfo=true;
                }
                else
                {
                    restApprvl.GA_Sent_From__c=userInfo.getUserId();
                    restApprvl.GA_Sent_To__c= cidRec.createdById;  
                    restApprvl.GA_CID_Adjustment__c=cidRec.Id;
                //    restApprvl.GA_Comments__c=cmmnts+'\n'+cidReqApvlMstr.GA_Comments__c;
                    restApprvl.GA_Comments__c=cmmnts;
                    database.insert(restApprvl); 
                    mastCIDRqstAddinfo=false;
                }
                
            }
            else
            {
                restApprvl.GA_Sent_From__c=userInfo.getUserId();
                restApprvl.GA_Sent_To__c= cidRec.createdById;                 
                restApprvl.GA_CID_Adjustment__c=cidRec.Id;
                restApprvl.GA_Comments__c=cmmnts;
                database.insert(restApprvl); 
                threadIdVal=restApprvl.Name;
                mastCIDRqstAddinfo=false;
            }
            
            list<Messaging.SingleEmailMessage> emailList=new list<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            if(!mastCIDRqstAddinfo)
            {
                list<EmailTemplate> sendAddnfoTmp=[SELECT Id FROM EmailTemplate where developerName=:ADDINFOTMP  Limit 1];     
                msg.setTemplateId(sendAddnfoTmp[0].Id);
                msg.setTargetObjectId(restApprvl.GA_Sent_To__c);
                msg.setWhatId(restApprvl.Id);
                msg.setSaveAsActivity(false);
            }
            else
            {
                msg.setToAddresses(new String[] {restApprvl.GA_Sent_To__c});
                msg.setSubject(ADDINFOSUB+threadIdVal);
                msg.setPlainTextBody(restApprvl.GA_Comments__c);
            }
            
            
            msg.setReplyTo(system.label.GA_CID_EmailServiceId);
            msg.setSenderDisplayName(ADDINFOSENDAS);            
            
            emailList.add(msg);
            Messaging.sendEmail(emailList);               
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDSENDFRADDINFO);
            throw new AuraHandledException(e.getMessage());  
        }
    }
  /**
@Description: restAddtnlbtnAccess() method 
@Name : restAddtnlbtnAccess
@Param : id cidRecId
@Return : boolean
@throws Exception : AuraHandledException
*/    
    @AuraEnabled
    public static boolean restAddtnlbtnAccess(id cidRecId)
    {
        try{
        list<user> usrLst=[select id,profile.Name from user where id=:userInfo.getUserId() Limit 1];
        list<GA_CID_Adjustment__c> cidRecLst=[select id,GA_Territory_Code_Approver__c,GA_Federal_Tax_ID_Approver__c,OwnerId
                                              from GA_CID_Adjustment__c where id=:cidRecId Limit 1];
      /**  list<GA_Approval__c> applst=[select id,GA_Approver__c from GA_Approval__c 
                                     where GA_CID_Adjustment__c=:cidRecId and GA_Status__c=:PENDNG limit 2]; **/

        if(cidRecLst.size()>0)
        {
            GA_CID_Adjustment__c cidRec=cidRecLst[0];
            set<id> useraccssIds=new set<id>();
            for(GA_Approval__c appl:[select id,GA_Approver__c from GA_Approval__c 
                                     where GA_CID_Adjustment__c=:cidRecId and GA_Status__c=:PENDNG Limit 2])
            {
                if(appl.GA_Approver__c !=null)
                {
                    useraccssIds.add(appl.GA_Approver__c);
                }
            }
           /* if(cidRec.GA_Territory_Code_Approver__c !=null)
                useraccssIds.add(cidRec.GA_Territory_Code_Approver__c);
            if(cidRec.GA_Federal_Tax_ID_Approver__c !=null)
                useraccssIds.add(cidRec.GA_Federal_Tax_ID_Approver__c);*/
            useraccssIds.add(cidRec.OwnerId);
            if(usrLst[0].profile.Name==SYSADMN)
            {
                useraccssIds.add(userInfo.getUserId());   
            }
            if(useraccssIds.contains(userInfo.getUserId()))
            {
                return true; 
            }       
        }
        return false;  
    }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDRESTADDTNLBTNACCESS);
            throw new AuraHandledException(e.getMessage());  
        }
    }
      /**
@Description: chkLoggedInUsrprfle() method 
@Name : chkLoggedInUsrprfle
@Param : None
@Return : string
@throws Exception : AuraHandledException
*/    
    @AuraEnabled
    public static string chkLoggedInUsrprfle()
    {
        try{
        list<user> usrLst=[select profile.Name from user where id=:userInfo.getUserId() Limit 1];
        return usrLst[0].profile.Name;
    }
      catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDCHKLOGGEDINUSRPRFLE);
            throw new AuraHandledException(e.getMessage());  
        }   
    }
    
    public static void updateEndDateinGSRelatedRecords(String gsId)
    {
        List<GA_AOR_Group_Segment__c> aorGsLst= [Select id,name,GA_Cancel_Flag__c,
                                                     GA_Group_Segment_Id__c,GA_Cancel_Date__c                                          
                                                     from GA_AOR_Group_Segment__c where GA_Group_Segment_Id__c =: gsId Limit 1000];
        List<GA_AOR_Group_Segment__c> aorGsLstToUpdate = new List<GA_AOR_Group_Segment__c>();
        if(aorGsLst != null && aorGsLst.size()>0)
        {
            for(GA_AOR_Group_Segment__c aorGs :aorGsLst){
                //aorGs.GA_Cancel_Date__c=system.today();
                //aorGs.GA_Cancel_Flag__c=true;
                aorGs.GA_Is_Mass_updating__c=true;
                aorGsLstToUpdate.add(aorGs);
            }                
        }
        
        List<GA_Managing_Agency_History__c> mngAgencyList= [Select id,
                                                     	GA_Group_Segment__c,GA_End_Date__c                                          
                                                     from GA_Managing_Agency_History__c where GA_Group_Segment__c =: gsId Limit 1000];
        List<GA_Managing_Agency_History__c> mngAgencyToUpdate = new List<GA_Managing_Agency_History__c>();
        if(mngAgencyList != null && mngAgencyList.size()>0)
        {
            for(GA_Managing_Agency_History__c mngGs :mngAgencyList){
                //mngGs.GA_End_Date__c=system.today();                
                mngAgencyToUpdate.add(mngGs);
            }                
        }
        
        if(aorGsLstToUpdate.size()>0)
        {
            Database.update(aorGsLstToUpdate);
        }
        if(mngAgencyToUpdate.size()>0)
        {
            Database.update(mngAgencyToUpdate);
        } 
    }
}