/*****************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_WrkflowAutomatedCls
@CreatedDate: 28 - Sep 2018 
@Description: GA_WrkflowAutomatedCls class is used to automate the workflow process.
@version : 1.0  
*****************************************************************************************************************************************/
public with sharing class GA_WrkflowAutomatedCls {
    public static final string shrTyp = 'V';    
    public static final string usrVsiblty = 'AllUsers';
    public static final String ClsName  ='GA_WrkflowAutomatedCls';
    public static final String methodNme1  ='AutoCrteWrkFlw';
    public static final String methodNme2  ='deleteInvalidWF';
    public static TimeZone tz = UserInfo.getTimeZone();
    public static Datetime currenttime = system.now();
    
    /**
@Description: AutoCrteWrkFlw() method 
@Name : AutoCrteWrkFlw
@Param : list<GA_WF_Workflow__c> wrkFLwLst 
@Return : void
@throws Exception : N/A;
*/
    public static void AutoCrteWrkFlw(list<GA_WF_Workflow__c> wrkFLwLst)
    {
        try{
            list<GA_WF_Group_Segment__c> lstWFStepGroupSegments=new list<GA_WF_Group_Segment__c>();
            list<GA_WF_Group_Segment__c> lstPrntWFStepGroupSegments=new list<GA_WF_Group_Segment__c>();
            list<GA_WF_Workflow__c> wrkflwLstExtrnl=new list<GA_WF_Workflow__c>();
            set<id> wrTmpletIds=new set<id>();
            set<string> grpSegmentids=new set<string>();
            set<id> wfIdsNotInsert=new set<id>();
            set<id> supIds=new set<id>();
            map<id,id> wfSuppId=new map<id,id>();
            map<id,list<string>> FileTypesMap=new map<id,list<string>>();
            set<string> FileTypes=new set<string>();
            set<id> docIdsFltr=new set<id>();
            Map<id,id> wfAcctIdsMap =new Map<id,id>();
            set<Id> invalidAccnts = New Set<Id>();
            String smartSysOfRec = 'SMART';
             String inactv ='Inactive' ;
            
            for(GA_WF_Workflow__c wf:wrkFLwLst)
            {
                if(wf.GA_External_Initiated__c)
                {
                    wrTmpletIds.add(wf.GA_Workflow_Template__c );
                    wrkflwLstExtrnl.add(wf);
                    wfAcctIdsMap.put(wf.id,wf.GA_Account__c);
                    if(wf.GA_Selected_Group_Segments__c !=null)
                        grpSegmentids.addall(wf.GA_Selected_Group_Segments__c.split(','));
                    if(wf.GA_Support__c <> null)
                    {
                        wfSuppId.put(wf.Id,wf.GA_Support__c);
                        supIds.add(wf.GA_Support__c);
                    }
                    
                  //  wf.Name =  wf.GA_Type__c + '-' + wf.Sub_Type__c + '-' +Datetime.now().format( 'MMMM, YYYY');
                }
            }
            
           List<Account> acctlst =  [Select Id,GA_System_of_Record__c,Status__c  from Account where id in :wfAcctIdsMap.values()
                                           Limit 1000 ];
            // and (  GA_System_of_Record__c =: smartSysOfRec or Status__c = :inactv )
            // 
            if(acctlst.size() > 0){
            for(Account acc :acctlst){
                for(Id wfAcc : wfAcctIdsMap.keySet()){
                    If(acc.id == wfAcctIdsMap.get(wfAcc)  ){
                        if(acc.GA_System_of_Record__c == smartSysOfRec || acc.Status__c == inactv){
                        wfIdsNotInsert.add(wfAcc);
                        invalidAccnts.add(acc.id);
                            }
                    }
                }
                
            }
            }
            
            
            if(wrTmpletIds.size()>0)
            {
                /**list<GA_WF_Group_Segment__c> wfGrpSgmntOpenLst=[select id,GA_Group_Segment_ID__c from GA_WF_Group_Segment__c 
                                                                where GA_Group_Segment_ID__c in:grpSegmentids and GA_Status__c='Open' limit 10000];**/
               
                List<GA_Group_Segment__c> gsOpenLst = [Select Id,GA_In_Progress__c,            GA_In_Progress_Type__c from 
                                                      GA_Group_Segment__c where  id  in:grpSegmentids 
                                                       and GA_In_Progress__c = true limit 1000];
                
                Set<string> grpSgmntIdsOpen=new Set<string>();
                for(GA_Group_Segment__c gsOpen:gsOpenLst)
                {
                    
                    grpSgmntIdsOpen.add(string.valueof(gsOpen.Id).substring(0,15)); 
                }
                map<id,Automated_Workflow_Settings__mdt> wfTmpAutmtedwrflwMap=new map<id,Automated_Workflow_Settings__mdt>();
                
                list<Automated_Workflow_Settings__mdt> automaWrflwStngsLst=[select id,GA_Step_Name__c,GA_File_Type__c,GA_Workflow_Step_Id__c,GA_Owner_Id__c,GA_Workflow_Template_Id__c                from Automated_Workflow_Settings__mdt 
                                                                            where GA_Workflow_Template_Id__c in :wrTmpletIds limit 1000];
                
                if(test.isRunningTest())
                {
                  automaWrflwStngsLst=new list<Automated_Workflow_Settings__mdt>();
                  Automated_Workflow_Settings__mdt autmatdTstRec=[select id,GA_Step_Name__c,GA_File_Type__c,GA_Workflow_Step_Id__c,
                                                                  GA_Owner_Id__c,GA_Workflow_Template_Id__c from Automated_Workflow_Settings__mdt 
                                                                  limit 1];
                  autmatdTstRec.GA_Workflow_Template_Id__c=wrkFLwLst[0].GA_Workflow_Template__c;
                  autmatdTstRec.GA_Owner_Id__c=userinfo.getUserId();  
                  automaWrflwStngsLst.add(autmatdTstRec);
                    
                }
                if(automaWrflwStngsLst.size()>0)
                {
                    for(Automated_Workflow_Settings__mdt automateWrfstng:automaWrflwStngsLst)
                    {
                        wfTmpAutmtedwrflwMap.put(automateWrfstng.GA_Workflow_Template_Id__c,automateWrfstng);
                    }
                }
                
                list<GA_WF_Group_Segment__c> lstWFGroupSegments = new list<GA_WF_Group_Segment__c>();
                
                if(wfTmpAutmtedwrflwMap.keySet().size()>0)
                {
                    list<GA_WF_Step__c> wrkStpCretLst=new list<GA_WF_Step__c>();
                    map<id,string> wfGrpSgmntMp=new map<id,string>();
                    
                    for(GA_WF_Workflow__c wf:wrkflwLstExtrnl)
                    {
                       GA_WF_Step__c wfSTp = new GA_WF_Step__c(Name = wfTmpAutmtedwrflwMap.get(wf.GA_Workflow_Template__c).GA_Step_Name__c,
                                                                GA_WF_Workflow_ID__c = wf.Id, 
                                                                GA_Workflow_Template_Id__c=wf.GA_Workflow_Template__c,
                                                                GA_WF_Template_Step__c = wfTmpAutmtedwrflwMap.get(wf.GA_Workflow_Template__c).GA_Workflow_Step_Id__c,
                                                                GA_Start__c = currenttime,
                                                                GA_Status__c = 'Open');
                        
                        wrkStpCretLst.add(wfSTp);
                        
                        wfGrpSgmntMp.put(wf.id,wf.GA_Selected_Group_Segments__c);
                        //create list dummy workflow process records 
                        for(id groupSegmnt : wf.GA_Selected_Group_Segments__c.split(',')){
                            GA_WF_Group_Segment__c wfGrpsgmnt=new GA_WF_Group_Segment__c();
                            wfGrpsgmnt.GA_Workflow_ID__c=wf.id;
                            wfGrpsgmnt.GA_Group_Segment_ID__c=groupSegmnt;
                            wfGrpsgmnt.GA_Date_Opened__c=currenttime;
                            wfGrpsgmnt.GA_Date_Closed__c=currenttime;
                            wfGrpsgmnt.GA_Status__c='Closed';                                                    
                            lstPrntWFStepGroupSegments.add(wfGrpsgmnt);
                        }// end of for-each
                        
                       
                        //lstWFStepGroupSegments step id null and status is closed
                        if(wfTmpAutmtedwrflwMap.get(wf.GA_Workflow_Template__c).GA_File_Type__c!=null)
                        {
                            FileTypesMap.put(wf.id,wfTmpAutmtedwrflwMap.get(wf.GA_Workflow_Template__c).GA_File_Type__c.split(';'));
                            FileTypes.addAll(wfTmpAutmtedwrflwMap.get(wf.GA_Workflow_Template__c).GA_File_Type__c.split(';'));   
                        }                        
                    }
                    //fetch all list from wfGrpSgmntMp.getvalues()
                   
                    //query certs and  riders where id in wfGrpSgmntMp.getvalues()
                    List<GA_Certs_Riders__c> CertsRidrLst=[select id,Name,GA_Group_Segment_ID__c from GA_Certs_Riders__c 
                                                           where GA_AssetId__r.GA_Plan_Package_Id__r.GA_Group_Segment__r.Id in:grpSegmentids and GA_AssetId__r.GA_Plan_Package_Id__r.GA_ACTIVE_IND__c =: 'Active' limit 8000];
                    list<GA_Certs_Rider_Process__c> lstWFCertsRider= new list<GA_Certs_Rider_Process__c>();
                    List<GA_Certs_Riders__c> CertsRidrLstTmp=new list<GA_Certs_Riders__c>();
                    //loop through certs and riders and create a map of grp- list of cert and riders
                    map<id,List<GA_Certs_Riders__c>> GrpSegCrtRdrMp=new map<id,List<GA_Certs_Riders__c>>();
                    if(CertsRidrLst.size()>0)
                    {
                    for(GA_Certs_Riders__c CertsRider : CertsRidrLst)
                    {
                        if(GrpSegCrtRdrMp.get(CertsRider.GA_Group_Segment_ID__c) !=null)
                        {
                          CertsRidrLstTmp=  GrpSegCrtRdrMp.get(CertsRider.GA_Group_Segment_ID__c);
                        }
                        else
                        {
                            CertsRidrLstTmp=new list<GA_Certs_Riders__c>();
                        }
                        CertsRidrLstTmp.add(CertsRider);
                        GrpSegCrtRdrMp.put(CertsRider.GA_Group_Segment_ID__c,CertsRidrLstTmp);
                    }
                    map<id,list<GA_Certs_Riders__c>> wfcrtridersMap=new map<id,list<GA_Certs_Riders__c>>();
                    list<GA_Certs_Riders__c> crtridrslsttmp=new list<GA_Certs_Riders__c>();
                    //lopp wfGrpSgmntMp ids -> list of grps->loop through that-> list of cert and riders
                    for(GA_WF_Workflow__c wf:wrkflwLstExtrnl)
                    {
                        for(string wfgrpsgmnt : wf.GA_Selected_Group_Segments__c.split(',')){
                            if(wfcrtridersMap.get(wf.id)!=null)
                            {
                                crtridrslsttmp=wfcrtridersMap.get(wf.id);
                            }
                            else
                            {
                                crtridrslsttmp=new list<GA_Certs_Riders__c>();
                            }
                            crtridrslsttmp.addall(GrpSegCrtRdrMp.get(wfgrpsgmnt));
                           wfcrtridersMap.put(wf.id,crtridrslsttmp);  
                    }   
                    }
                    for(id wrflwcrt : wfcrtridersMap.keyset())
                    {
                         for(GA_Certs_Riders__c CertsRder : wfcrtridersMap.get(wrflwcrt))
                            {
                                GA_Certs_Rider_Process__c wfCertRidr=new GA_Certs_Rider_Process__c();
                                wfCertRidr.GA_Workflow__c=wrflwcrt;
                                wfCertRidr.GA_Certs_Rider__c=CertsRder.Id;                                
                                wfCertRidr.GA_Date_Opened__c=currenttime;
                                wfCertRidr.GA_Date_Closed__c=currenttime;
                                wfCertRidr.GA_Status__c='Closed';                                                    
                                lstWFCertsRider.add(wfCertRidr);
                            }
                    }
                    if(lstWFCertsRider.size() > 0){
                        database.insert(lstWFCertsRider,false);  
                    }
                    }
                    
               
                    for(id wfgrpsgmnt:wfGrpSgmntMp.keyset())
                    {
                        for(string groupSegmentId : wfGrpSgmntMp.get(wfgrpsgmnt).split(','))
                        {
                            if(grpSgmntIdsOpen.contains(groupSegmentId))
                            {
                                wfIdsNotInsert.add(wfgrpsgmnt);
                                break;
                            }
                        }
                    }
                    //  if(wfIdsNotInsert.size()==0)
                    // {
                    list<id> wfLstValid=new list<id>();
                    set<id> wfSetValid=new set<id>();
                    list<GA_WF_Step__c> wrkStpCretVldLst=new list<GA_WF_Step__c>();
                    for(GA_WF_Step__c wfST : wrkStpCretLst){
                        
                        if(!wfIdsNotInsert.contains(wfST.GA_WF_Workflow_ID__c)){
                            wfSetValid.add(wfST.GA_WF_Workflow_ID__c);
                            wrkStpCretVldLst.add(wfST);  
                        }
                    }
                    if(wrkStpCretVldLst.size()>0)
                        insert wrkStpCretVldLst;
                    wfLstValid.addAll(wfSetValid);
                    if(lstPrntWFStepGroupSegments.size()>0)
                    {
                        database.insert(lstPrntWFStepGroupSegments);
                    }
                    map<id,map<id,id>> prntWFPrcssMap=fetchParentWEFPrcess(wfLstValid);
                    list<id> wfSTpIds=new list<id>();
                    set<string> grpIdSet=new set<string>();
                    for(GA_WF_Step__c wfSTp:wrkStpCretVldLst)
                    {
                        wfSTpIds.add(wfSTp.Id);
                        list<id> grpIds=wfGrpSgmntMp.get(wfSTp.GA_WF_Workflow_ID__c).split(',');
                        
                        for(string groupSegmentIds : grpIds){
                            lstWFStepGroupSegments.add(new GA_WF_Group_Segment__c(
                                GA_Workflow_ID__c = wfSTp.GA_WF_Workflow_ID__c, 
                                GA_Group_Segment_ID__c = groupSegmentIds, 
                                ownerid = wfTmpAutmtedwrflwMap.get(wfSTp.GA_Workflow_Template_Id__c).GA_Owner_Id__c,
                                GA_Parent_WF_Process__c = prntWFPrcssMap.get(wfSTp.GA_WF_Workflow_ID__c).get(groupSegmentIds),
                                GA_WF_Step_ID__c = wfSTp.Id, 
                                GA_Date_Opened__c = currenttime ));
                            grpIdSet.add(groupSegmentIds);
                        }// end of for-each 
                        
                        
                    }
                    list<string> grpIdsFltLst=new list<string>();
                    
                    grpIdsFltLst.addAll(grpIdSet);
                    list<GA_Group_Segment__c> grpInprgssLst=new list<GA_Group_Segment__c>();
                    for(string grpRecId:grpIdsFltLst)
                    {
                        GA_Group_Segment__c gtpTmp=new GA_Group_Segment__c();
                        gtpTmp.Id=grpRecId;
                        gtpTmp.GA_In_Progress__c=true;
                        gtpTmp.GA_In_Progress_Type__c='Workflow';
                        gtpTmp.GA_Is_Mass_Updating__c=True;
                        grpInprgssLst.add(gtpTmp);
                    }
                    if(grpInprgssLst.size()>0)
                    {
                        GA_GS_AP02_Update_Address.isExecuting=true;
                       // GA_ExternlaAppleSrvcCls.isExecuting = true;
                        GA_GS_UpdateRatingType.isExecuting = true;
                        GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                        GA_GroupSegmentTriggerHandler.isExecuting = true;
                        GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                        GA_GS_AP04_UpdtStatus.isExecuting = true;
                        GA_GS_AP04_UpdtStatus.isInvoked = true;
                        GA_GS_UpdatWrappingFileTPA.isExecuting = true;                        
                        database.update(grpInprgssLst,false);
                    }
                    if(lstWFStepGroupSegments.size()>0 && lstWFStepGroupSegments.size()<=5000)
                       insert lstWFStepGroupSegments;  
                    else if(lstWFStepGroupSegments.size()>5000)
                    {
                        GA_WrkflowAutomatedBatchCls wflwAutoBtchCls = new GA_WrkflowAutomatedBatchCls(wfGrpSgmntMp,wfTmpAutmtedwrflwMap,wfSTpIds);
                        database.executeBatch(wflwAutoBtchCls,100);
                    }
                   /** if(supIds.size()>0)
                    {
                      set<id> docIds=new set<id>();
                        set<id> docIdsTotl=new set<id>();
                        map<id,set<id>> suppIdCntIdMap=new map<id,set<id>>();
                        list<ContentDocumentLink> cntLinkLst=[select id,contentdocumentId,linkedEntityId from ContentDocumentLink where linkedEntityId in:supIds limit 10000];
                        for(ContentDocumentLink doc:cntLinkLst)
                        {
                            if(suppIdCntIdMap.get(doc.linkedEntityId) !=null)
                                docIds=suppIdCntIdMap.get(doc.linkedEntityId);
                            else
                                docIds=new set<id>();
                            docIds.add(doc.contentdocumentId);
                            suppIdCntIdMap.put(doc.linkedEntityId,docIds);
                            docIdsTotl.add(doc.contentdocumentId);
                        }
                        if(docIds.size()>0)
                        {
                            list<contentversion> cntvLst=[select id,GA_Type__c,ContentDocumentId from contentversion where ContentDocumentId in:docIdsTotl and GA_Type__c in :fileTypes limit 100];
                            
                            for(contentversion cntv:cntvLst)
                            {
                                docIdsFltr.add(cntv.ContentDocumentId);
                            }                    
                        }
                        ContentDocumentLink cdl = new ContentDocumentLink();
                        list<ContentDocumentLink> docListTmp=new list<ContentDocumentLink>();
                        for(GA_WF_Workflow__c wf:wrkflwLstExtrnl)
                        {
                            id SupId=wfSuppId.get(wf.Id);
                            set<Id> docIdTotlTmp=suppIdCntIdMap.get(SupId);
                            for(id docId:docIdTotlTmp)
                            {
                                if(docIdsFltr.contains(docId))
                                {
                                    cdl = new ContentDocumentLink();
                                    cdl.ContentDocumentId = docId;
                                    cdl.LinkedEntityId = wf.Id;
                                    cdl.ShareType = shrTyp;
                                    cdl.Visibility = usrVsiblty; 
                                    docListTmp.add(cdl); 
                                }
                            }
                        }
                        if(docListTmp.size()>0)
                        {
                            database.insert(docListTmp);
                        } 
                    }**/
                }
                
                if(grpSgmntIdsOpen.size() > 0){
                    
                    ExceptionLog__c objLog = new ExceptionLog__c();
                    //  objLog.Object_ID__c =accId ;
                    objLog.ExceptionDescription__c = 'Selected Group segment is already part of an open workflow or CID Adjustment';
                    objLog.ExceptionCode__c =  'EX-OPENGRP';
                    objLog.NumberOfTimesOccured__c =  1;
                    objLog.ExceptionDetails__c = 'Selected Group segment is already part of an open workflow or CID Adjustment '+grpSgmntIdsOpen;
                    objLog.ClassName__c = 'GA_WrkflowAutomatedCls';
                    objLog.MethodName__c = 'AutoCrteWrkFlw';
                    objLog.Severity__c = 'ERROR';
                    Database.insert(objLog);   
                    
                }
                
                if(invalidAccnts.size() > 0){
                    
                    ExceptionLog__c objLog = new ExceptionLog__c();
                    //  objLog.Object_ID__c =accId ;
                    objLog.ExceptionDescription__c = 'Selected account is inactive or smart account';
                    objLog.ExceptionCode__c =  'EX-INVLDACC';
                    objLog.NumberOfTimesOccured__c =  1;
                    objLog.ExceptionDetails__c = 'Selected account is inactive or smart account '+invalidAccnts;
                    objLog.ClassName__c = 'GA_WrkflowAutomatedCls';
                    objLog.MethodName__c = 'AutoCrteWrkFlw';
                    objLog.Severity__c = 'ERROR';
                    Database.insert(objLog);   
                   
                }
                 if(wfIdsNotInsert.size() > 0){
                        deleteInvalidWF(wfIdsNotInsert);
                    }
                
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme1);
        }
    }
    private static map<id,map<id,id>> fetchParentWEFPrcess(list<id> wfIdLst)
    {
        list<GA_WF_Group_Segment__c> wfPrcssLst=[select id,GA_Group_Segment_ID__c,GA_Workflow_ID__c from GA_WF_Group_Segment__c where GA_WF_Step_ID__c=null and GA_Workflow_ID__c in:wfIdLst limit 5000];
        map<id,map<id,id>> wfgrpPrntWfPrcssMap=new map<id,map<id,id>>();
        map<id,id> grpPrntWfPrcssMap=new map<id,id>();
        for(GA_WF_Group_Segment__c wfGs:wfPrcssLst)
        {
            if(wfgrpPrntWfPrcssMap.get(wfGs.GA_Workflow_ID__c)!=null)
            {
                grpPrntWfPrcssMap=wfgrpPrntWfPrcssMap.get(wfGs.GA_Workflow_ID__c);
            }
            else
            {
                grpPrntWfPrcssMap=new map<id,id>();
            }
            grpPrntWfPrcssMap.put(wfGs.GA_Group_Segment_ID__c,wfGs.id);
            wfgrpPrntWfPrcssMap.put(wfGs.GA_Workflow_ID__c,grpPrntWfPrcssMap);
        }
        return wfgrpPrntWfPrcssMap;
    }
    /**
@Description: deleteInvalidWF() method 
@Name : deleteInvalidWF
@Param : Set<Id> wfIds 
@Return : void
@throws Exception : N/A;
*/    
    @future (callout=true)
    Public static void deleteInvalidWF(Set<Id> wfIds){
        try{
            List<Id> wflwId =  New List<Id> ();
            wflwId.addAll(wfIds);
            Database.delete(wflwId);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme2);
        } 
    }
}