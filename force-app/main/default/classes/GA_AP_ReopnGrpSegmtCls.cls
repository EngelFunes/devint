/**
@Author : IDC Offshore
@Name: GA_AP_CancelWorkflowCls
@CreatedDate: 21 - Oct 2017 
@Description: GA_AP_CancelWorkflowCls class to cancel group segments or  Workflow 
@version : 1.0  
*/
public with sharing class GA_AP_ReopnGrpSegmtCls { 
    public Static Final string CLSNAME='GA_AP_ReopnGrpSegmtCls';
    public Static Final  string WRKFLWINFO='wrkFlwInfo';
    public Static Final  string CHCKREOPNGRPSGMNTS = 'checkReopnGrpSgmntAccss';
    public Static Final  string CMPLTD = 'Completed'; 
    public Static Final  string RETRIEVGRPSGMNTS = 'retrievGrpSgmnts';
    public Static Final  string ERRMSG=System.label.GA_SystemErr;
    public Static Final  string CLSDSTS= 'Closed';
    public Static Final  string OPENSTS= 'Open';
    public static Final String WFINPROGSS = 'Workflow';
    public Static Final  string CNCLD = 'Canceled';
    public static final Datetime TODAYDT = Datetime.now();
    public static final String TODAYDATETIME = TODAYDT.format('MM/dd/yyyy h:mm:ss a');
    public static final String SPACESTR = ' ';
    public static final String DLMTR = '\n' ;
    public static final String BLNK = '' ;
    public static final String ABRTYP = 'ABR' ;
     public static final String COMMSTR = ',' ;
    public static final String  REOPENWRKFLWGRPS = 'reopnWrkFlwGrps';
  
    
    
    /**
@Description: wrkFlwInfo() method 
@Name : wrkFlwInfo
@Param : string wfId
@Return : Boolean
@throws Exception : ValidateException;
*/    
    @AuraEnabled
    public static boolean wrkFlwInfo(string wfId)
    {
        try{
            String wfStatus = BLNK;
            Boolean rtrnResp =  false;
            GA_WF_Workflow__c currntWF = [Select id,GA_Status__c from  GA_WF_Workflow__c where id=: wfId Limit 1];
            wfStatus =  currntWF.GA_Status__c ;
            List<GA_WF_Group_Segment__c>  wfGrpLst = retrievGrpSgmnts(wfId);
            if(!wfStatus.equalsIgnoreCase(CNCLD) && !wfGrpLst.isEmpty())
            {
                rtrnResp =  true;
            }
            return rtrnResp;
        }
        catch(Exception e){
            
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WRKFLWINFO);
            throw new AuraHandledException(ERRMSG);
        }
        
    }
    /**
@Description: reopnWrkFlwGrps() method 
@Name : reopnWrkFlwGrps
@Param : string wfId,string cnclCmnts,List<String> grpIds
@Return : string
@throws Exception : ValidateException;
*/  
    
    @AuraEnabled
    public static string reopnWrkFlwGrps(string wfId,string reopenComnts,List<String> grpIds)
    {
        try
        { 
            
                    GA_WF_Group_Segment__c wfGrpsgmnt =  New GA_WF_Group_Segment__c();
                    GA_Group_Segment__c gtpTmp = New GA_Group_Segment__c();
                    GA_WF_Step__c pevWfStp = New GA_WF_Step__c();
                    List<GA_WF_Group_Segment__c> wfGrpsgmntLst =  New List<GA_WF_Group_Segment__c> ();
                  List<GA_WF_Group_Segment__c> delWfGrpsgmntLst =  New List<GA_WF_Group_Segment__c> ();
                    List<GA_WF_Step__c> wfPrvStpLst  =  New List<GA_WF_Step__c> ();
                 List<GA_WF_Step__c> delStpLst  =  New List<GA_WF_Step__c> ();
                    List<GA_Group_Segment__c> grpSgmntLst  =  New List<GA_Group_Segment__c> ();
            Map<Id,String> prvStpMap = New Map<Id,String>();
            
            Map<Id,GA_WF_Step__c>  compltWfStp= New  Map<Id,GA_WF_Step__c>([Select id,Name,GA_WF_Workflow_ID__c,GA_Notes__c,GA_End_Time__c from  GA_WF_Step__c 
                                                                            where GA_WF_Workflow_ID__c =:wfId
                                                                            and Name =: CMPLTD Limit 100]);
           list<GA_WF_Group_Segment__c> compGrpSgmentLst=[select Id,GA_Status__c,GA_WF_Step_ID__c,GA_Group_Segment_ID__c,
                                                           OwnerId,GA_Is_Owner_Queue__c,GA_Workflow_Next_Step__c,GA_Type__c
                                                           from GA_WF_Group_Segment__c where GA_Workflow_ID__c=:wfId  
                                                           and GA_WF_Step_ID__c in: compltWfStp.keyset() Limit 2000];
            
            if(!compltWfStp.isEmpty()){
                
                   for(GA_WF_Group_Segment__c clsdWfgs :  compGrpSgmentLst){
                       if(grpIds.contains(clsdWfgs.GA_Group_Segment_ID__c)){
                           wfGrpsgmnt  =  new GA_WF_Group_Segment__c(
                           id = clsdWfgs.id
                           );
                           delWfGrpsgmntLst.add(wfGrpsgmnt);
                       }
                       
                   }
                
                if(delWfGrpsgmntLst.size() == compGrpSgmentLst.size()){
                     delStpLst.add(compltWfStp.values());
                }
                list<GA_WF_Group_Segment__c> grpSgmentLst=[select Id,GA_Status__c,GA_WF_Step_ID__c,GA_Group_Segment_ID__c,
                                                           OwnerId,GA_Is_Owner_Queue__c,GA_Workflow_Next_Step__c,
                                                           GA_Type__c,GA_Group_Segment_Name__c,GA_Notes__c
                                                           from GA_WF_Group_Segment__c where GA_Workflow_ID__c=:wfId  
                                                           and GA_Workflow_Next_Step__c in: compltWfStp.keyset() Limit 2000];
                
                
                
                for(GA_WF_Group_Segment__c wfgs :  grpSgmentLst){
                    if(grpIds.contains(wfgs.GA_Group_Segment_ID__c))
                    {
                        String wfType = wfgs.GA_Type__c ;
                        wfGrpsgmnt =  new GA_WF_Group_Segment__c(
                            id = wfgs.id,
                            GA_Date_Closed__c=null,
                            GA_Status__c=OPENSTS,
                            GA_Workflow_Next_Step__c = null,
                            GA_Notes__c= TODAYDATETIME + SPACESTR + userinfo.getName() + SPACESTR + wfgs.GA_Group_Segment_Name__c +SPACESTR
                            + reopenComnts + ( wfgs.GA_Notes__c <> null ? DLMTR + wfgs.GA_Notes__c : BLNK)
                        );
                        wfGrpsgmntLst.add(wfGrpsgmnt);
                        
                        gtpTmp=new GA_Group_Segment__c();
                        gtpTmp.Id=wfgs.GA_Group_Segment_ID__c;
                        if(!wfType.equalsIgnoreCase(ABRTYP))
                        {  
                            gtpTmp.GA_In_Progress__c=true;
                            gtpTmp.GA_In_Progress_Type__c=WFINPROGSS;
                            gtpTmp.GA_Is_Mass_Updating__c=True;
                            grpSgmntLst.add(gtpTmp);                    
                        }
                       
                        if(prvStpMap.containsKey(wfgs.GA_WF_Step_ID__c)){
                           String keyValue = prvStpMap.get(wfgs.GA_WF_Step_ID__c); 
                            prvStpMap.remove(wfgs.GA_WF_Step_ID__c);
                            prvStpMap.put(wfgs.GA_WF_Step_ID__c,keyValue+COMMSTR+ wfgs.GA_Group_Segment_Name__c);
                        }
                        else{
                            prvStpMap.put(wfgs.GA_WF_Step_ID__c,wfgs.GA_Group_Segment_Name__c) ;
                        }
                    } 
                }
                
                GA_WF_Workflow__c wfRec=new GA_WF_Workflow__c();
                wfRec.Id=wfId;
                wfRec.GA_Status__c=OPENSTS;
                
                if(!prvStpMap.isEmpty()){
                    Map<Id,GA_WF_Step__c> prvWFStpsInfoMap = New  Map<Id,GA_WF_Step__c>([Select id,GA_Notes__c from GA_WF_Step__c where id in: prvStpMap.keyset() ]);
                    for(Id stpId : prvStpMap.keyset()){
                        pevWfStp = New GA_WF_Step__c(
                            id = stpId,
                            GA_End_Time__c = null,
                            GA_Status__c =  OPENSTS,
                            GA_Notes__c = TODAYDATETIME + SPACESTR + userinfo.getName() + SPACESTR + prvStpMap.get(stpId) + SPACESTR +
                            reopenComnts +  DLMTR + prvWFStpsInfoMap.get(stpId).GA_Notes__c
                            );
                        wfPrvStpLst.add(pevWfStp);
                        
                    }
                }
                
                Database.update(wfRec);
                if(!delWfGrpsgmntLst.isEmpty()){
                    Database.delete(delWfGrpsgmntLst);
                }
                 if(!delWfGrpsgmntLst.isEmpty()){
                    Database.delete(delStpLst);
                }
                if(!wfGrpsgmntLst.isEmpty()){
                    Database.update(wfGrpsgmntLst);
                }
                if(!wfPrvStpLst.isEmpty()){
                    Database.update(wfPrvStpLst);  
                }
                 if(grpSgmntLst.size()>0)
                {
                    GA_GS_AP02_Update_Address.isExecuting=true;
                    //GA_ExternlaAppleSrvcCls.isExecuting = true;
                    GA_GS_UpdateRatingType.isExecuting = true;
                    GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                    GA_GroupSegmentTriggerHandler.isExecuting = true;
                    GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                    GA_GS_AP04_UpdtStatus.isExecuting = true;
                    GA_GS_AP04_UpdtStatus.isInvoked = true;
                    GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                    GA_GroupSegAccUpdateCls.isExecuting = true;
                    database.update(grpSgmntLst);
                }
                
            }
            
            return system.label.GA_ReopenGrpSuccMsg;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, REOPENWRKFLWGRPS);
            throw new AuraHandledException(ERRMSG); 
        }
        
    }
    /**
@Description: checkReopnGrpSgmntAccss() method 
@Name : checkReopnGrpSgmntAccss
@Param : string wfId
@Return : boolean
@throws Exception : ValidateException;
*/     
    @AuraEnabled
    public static boolean checkReopnGrpSgmntAccss(string wfId)
    {
        try{
            Boolean rtrnResp = false;
            GA_Trigger_Functionality_By_Pass__c bypssErr=GA_Trigger_Functionality_By_Pass__c.getInstance();
            if(bypssErr.GA_ReOpenWFGrpSgmnt__c){
                rtrnResp = true;
            }
            else
            {
                rtrnResp = false;                
            }            
            return rtrnResp;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, CHCKREOPNGRPSGMNTS);
            throw new AuraHandledException(ERRMSG); 
        }
    }
    /**
@Description: retrievGrpSgmnts() method 
@Name : retrievGrpSgmnts
@Param : string wfId
@Return : list<GA_WF_Group_Segment__c>
@throws Exception : ValidateException;
*/      
    @AuraEnabled
    public static  list<GA_WF_Group_Segment__c>  retrievGrpSgmnts(string wfId)
    {
        try{  
            list<GA_WF_Group_Segment__c> grpSgmentLst=[select Id,GA_Status__c,OwnerId,GA_Group_Segment_ID__r.Name,GA_Group_Segment_ID__c
                                                       from GA_WF_Group_Segment__c where GA_Workflow_ID__c=:wfId 
                                                       and GA_Status__c =: CLSDSTS and GA_WF_Step_ID__r.Name =: CMPLTD  Limit 2000] ;
            
            
            return grpSgmentLst;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, RETRIEVGRPSGMNTS);
            throw new AuraHandledException(ERRMSG); 
        }
    }

}