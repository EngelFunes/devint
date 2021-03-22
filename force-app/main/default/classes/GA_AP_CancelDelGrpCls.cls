/**
@Author : IDC offshore
@Name: GA_AP_CancelDelGrpCls
@CreatedDate: 26 - Oct 2018 
@Description: GA_AP_CancelDelGrpCls class is to delete group segments created through ASEp processing
@version : 1.0  
*/
public without sharing class GA_AP_CancelDelGrpCls {
    private static string ClsName='GA_AP_CancelDelGrpCls';
    private static string methodNme='delGrpSgmnts';
    private static string inSuffMsg=system.label.GA_PostIsuffErrMsg;    
    private static string ErrMsg=system.label.GA_Group_Post_UnPost_Error;
    private static string NonASEPGrpSgmt=system.label.GA_ASEP_Process_Records;
    private static string LockAccPostedMsg=system.label.GA_Record_Lock_Post_Msg;
    private static string SmrtLbl='SMART';
    private static string StpOwnrLbl='PT1';
    private static string nme = 'Name';
    private static string pndng = 'Pending';
    /**
@Description: delGrpSgmnts() method 
@Name : delGrpSgmnts
@Param : GrpSgmntId   
@Return : String
@throws Exception : N/A;
*/   
    @AuraEnabled
    public static String delGrpSgmnts(string GrpSgmntId)
    {
        try
        {
            list<GA_Trigger_Functionality_By_Pass__c> delGrpgSgmntbypss = [select id,GA_Delete_Group_Segment__c,SetupOwner.Name from GA_Trigger_Functionality_By_Pass__c where SetupOwnerId=:userInfo.getProfileId() limit 1];
            if(delGrpgSgmntbypss.size()>0 && delGrpgSgmntbypss[0].  GA_Delete_Group_Segment__c){
                
                GA_Group_Segment__c grpSgmnt=[select id,Name,GA_Date_Posted__c,Status__c,GA_Account__r.GA_System_of_Record__c,GA_Post_Transaction__c,GA_Transaction_Posted__c,GA_SourceASG__c
                                              from GA_Group_Segment__c where id =:GrpSgmntId Limit 1];
                
                
                if(grpSgmnt.GA_Account__r.GA_System_of_Record__c!=SmrtLbl || delGrpgSgmntbypss[0].SetupOwner.Name ==StpOwnrLbl)
                {
                    if(grpSgmnt.GA_SourceASG__c==True)
                    {
                        //archiveGSRecs(grpSgmnt);
                        return 'Group Segment deleted Successfully';
                    }
                    else
                    {
                        return NonASEPGrpSgmt;
                    }
                }
                else
                {
                    return LockAccPostedMsg;
                }
                
                
            }
            else{
                return inSuffMsg;
            }
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            throw new AuraHandledException(ErrMsg); 
        }  
    }
    /**
@Description: archiveGSRecs() method 
@Name : archiveGSRecs
@Param : GrpSgmntId
@Return : void
@throws Exception : N/A;
*/ 
    @AuraEnabled
    public static void archiveGSRecs(string GrpSgmntId)
    {
        try
        {
            Id grpId = Id.valueOf(GrpSgmntId);
            DescribeSObjectResult describeResult = grpId.getSObjectType().getDescribe();
            
            List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
            
            String query =' SELECT ' + String.join( fieldNames, ',' ) +' FROM ' + describeResult.getName() + ' WHERE '+' id = :grpId ' + 'LIMIT 1 ';
            
            List<SObject> records = Database.query( query );
           
            
            
            
          //  list<GA_Archive_Group_Segment__mdt> archiveGSMapLst =[SELECT Label,GA_Archive_GS_API_Name__c,GA_GS_API_Name__c FROM GA_Archive_Group_Segment__mdt limit 100];
            map<string,string> archiveFiledMps=new map<string,string>();
            GA_Group_Segments_Arch__c archGSRec=new GA_Group_Segments_Arch__c();
            
            
            for(GA_Archive_Group_Segment__mdt gsArch:[SELECT Label,GA_Archive_GS_API_Name__c,GA_GS_API_Name__c FROM GA_Archive_Group_Segment__mdt limit 1000])
            {
                archGSRec.put(gsArch.GA_Archive_GS_API_Name__c,records[0].get(gsArch.GA_GS_API_Name__c));
                
            }
            
            
            archGSRec.Name = String.ValueOf(records[0].get(nme));
            database.insert(archGSRec);
            deleteGSRelatedWFData(GrpSgmntId);
            database.delete(records[0]);
            
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            throw new AuraHandledException(ErrMsg);             
        }
    }  
    
    /**
@Description: deleteGSRelatedWFData() method 
@Name : deleteGSRelatedWFData
@Param : GrpSgmntId
@Return : void
@throws Exception : N/A;
*/ 
    @AuraEnabled
    public static void deleteGSRelatedWFData(string GrpSgmntId)
    {
        try
        {
            Map<Id,Id> wfgsMap = New Map<Id,Id>();
            Map<Id,Id> allwfgsMap = New Map<Id,Id>();
            Set<Id>  multiplegsWfId = New Set<Id>(); 
            Set<Id>  singlegsWfIds = New Set<Id>(); 
            
            List<GA_WF_Group_Segment__c> wfgsLst = [Select Id,GA_Workflow_ID__c,GA_Group_Segment_ID__c from GA_WF_Group_Segment__c 
                                                    where GA_Group_Segment_ID__c =:  GrpSgmntId Limit 5000];
            if(wfgsLst.size()> 0){
                
                for(GA_WF_Group_Segment__c wfgs : wfgsLst ){
                    wfgsMap.put(wfgs.Id,wfgs.GA_Workflow_ID__c);
                    
                }
                
                
                
                //  List<GA_WF_Group_Segment__c> allwfgsLst = [Select Id,GA_Workflow_ID__c,GA_Group_Segment_ID__c from 
                //                                           GA_WF_Group_Segment__c where GA_Workflow_ID__c in:  wfgsMap.values()];
                
                
                
                for(GA_WF_Group_Segment__c wfgs : [Select Id,GA_Workflow_ID__c,GA_Group_Segment_ID__c from 
                                                   GA_WF_Group_Segment__c where GA_Workflow_ID__c in:  wfgsMap.values() Limit 6000] ){
                                                       allwfgsMap.put(wfgs.Id,wfgs.GA_Workflow_ID__c);
                                                   }
                
                
                
                
                for(Id wfgsId : allwfgsMap.keyset()){
                    if(!wfgsMap.containsKey(wfgsId)){
                        multiplegsWfId.add(allwfgsMap.get(wfgsId));
                    }
                }
                
                
                
                List<GA_WF_Group_Segment__c> wfgsmultipleLst = [Select Id,GA_Workflow_ID__c,GA_Group_Segment_ID__c 
                                                                from GA_WF_Group_Segment__c where 
                                                                GA_Group_Segment_ID__c =:  GrpSgmntId
                                                                and GA_Workflow_ID__c in: multiplegsWfId Limit 5000];
                
                
                for(Id wfId : wfgsMap.values())  {
                    if(!multiplegsWfId.contains(wfId)){
                        singlegsWfIds.add(wfId);
                    }
                }        
                
                
                List<GA_WF_Group_Segment__c> signleWfwfgsLst = [Select Id from GA_WF_Group_Segment__c 
                                                                where GA_Group_Segment_ID__c =:  GrpSgmntId 
                                                                and GA_Workflow_ID__c in: singlegsWfIds Limit 3000];
                
                List<GA_WF_Step__c> SignleWFwfStpsLst = [Select Id from GA_WF_Step__c 
                                                         where  GA_WF_Workflow_ID__c in :singlegsWfIds Limit 1000 ];
                
                List<GA_WF_Workflow__c> singleWfLst = [Select Id from GA_WF_Workflow__c 
                                                       where id in: singlegsWfIds Limit 20];
                
                if(wfgsmultipleLst.size() > 0)
                    Database.delete(wfgsmultipleLst) ;
                if(signleWfwfgsLst.size() > 0)
                    Database.delete(signleWfwfgsLst) ;
                if(SignleWFwfStpsLst.size() > 0)
                    Database.delete(SignleWFwfStpsLst) ;
                if(singleWfLst.size() > 0)
                    Database.delete(singleWfLst) ;
                
            }
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            throw new AuraHandledException(ErrMsg);             
        }
    }  
    
}