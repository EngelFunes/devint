/**
@Author : IDC Offshore
@Name: GA_AP_UpdateGSBenefitEffDtFromWF
@CreatedDate: 8-May 2019
@Description: GA_AP_UpdateGSBenefitEffDtFromWF class to Update group segment's Benefit Effective Date. 
@version : 1.0  
*/
public class GA_AP_UpdateGSBenefitEffDtFromWF {
	public Static Final string ClsName='GA_AP_UpdateGSBenefitEffDtFromWF';
    public Static Final  string UpdtGSBenefitEffDt='canclWrflw';
    public Static Final String opnSts= 'Open';
        public Static Final String ClsdSts= 'Closed';
    public Static Final  string wrkFlwInfo='wrkFlwInfo';
    public Static Final  string ErrMsg='Something went wrong. Please contact your System Admin';
   
      /**
@Description: UpdtGSBenefitEffDt() method 
@Name : UpdtGSBenefitEffDt
@Param : string wfId,string cnclCmnts,List<String> grpIds
@Return : string
@throws Exception : ValidateException;
*/  
    
      public static void UpdtGSBenefitEffDt(list<GA_WF_Workflow__c> wrkFLwLst)
    {
        try
        { 
            
            list<id> wrfwIds=new list<id>();
            for(GA_WF_Workflow__c wflw:wrkFLwLst) 
            {
                if(wflw.GA_Benefit_Effective_Date__c != null)
                {
                wrfwIds.add(wflw.Id);
                }
            }
            
            if(wrfwIds.size()>0)
            {
            
            list<GA_WF_Workflow__c> wfRecLst=[select id,GA_Status__c,GA_Benefit_Effective_Date__c from GA_WF_Workflow__c 
                                              where id=:wrfwIds[0] and GA_Status__c =:opnSts Limit 2000];
            
            List<String> grpIds = new  List<String> ();
           
            for(GA_WF_Group_Segment__c wfgrpSgmnt : [select Id,GA_Status__c,OwnerId,GA_Group_Segment_ID__r.Name,GA_Group_Segment_ID__c
                                                       from GA_WF_Group_Segment__c where GA_Workflow_ID__c=:wrfwIds[0] 
                                                       and GA_Status__c =: ClsdSts and GA_WF_Step_ID__c = null Limit 2000]){
              grpIds.add(wfgrpSgmnt.GA_Group_Segment_ID__c);  
            }
                            
            list<GA_Group_Segment__c> grpSgmentLst=[select Id,GA_Benefit_Effective_Date__c
                                                       from GA_Group_Segment__c where id in:grpIds and GA_Benefit_Effective_Date__c =:null 
                                                       Limit 2000] ;
                          
            list<GA_Group_Segment__c> UpdtgrpLst=new list<GA_Group_Segment__c>();
                
            if(grpSgmentLst.size()>0)
                {
                    for(GA_Group_Segment__c grpsgmnt:grpSgmentLst)
                    {
                        grpsgmnt.GA_Benefit_Effective_Date__c = wfRecLst[0].GA_Benefit_Effective_Date__c;
                        UpdtgrpLst.add(grpsgmnt);
                    }
                
                }
                                
             if(UpdtgrpLst.size()>0)
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
                    database.update(UpdtgrpLst);
                }
            }
        }
       catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, ErrMsg);
            throw new AuraHandledException(ErrMsg); 
        } 
}
}