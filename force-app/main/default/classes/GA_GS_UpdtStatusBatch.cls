/**
@Author : IDC offshore
@Name: GA_GS_UpdtStatusBatch 
@CreatedDate: 05-Jan-2018  
@Description: GA_GS_UpdtStatusBatch class to update the third party history record,
group segment assocication on Group segement and flip GS  related acct record type 
@version : 1.0  
*/
global class GA_GS_UpdtStatusBatch implements Database.Batchable<sObject>{
    public final string query ;
    public static final string BCN='BCN'; 
    public static final string INTGRTNUSR='Integration User'; 
    public static final string CNCLD='Canceled';
    public static final string PNDG='Pending';
    public static final string ACTV='Active';
    
    /**Constructor*/
    global GA_GS_UpdtStatusBatch(string gsQry)
    {
        query=gsQry;
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<GA_Group_Segment__c> scope)
    {
        list<GA_Group_Segment__c> gpsgmntTocnl=new list<GA_Group_Segment__c>();
        list<GA_Group_Segment__c> gpsgmntToActv=new list<GA_Group_Segment__c>();
        String profileName = [Select Name from Profile where Id = :UserInfo.getProfileId() limit 1].Name;
        
        for(GA_Group_Segment__c grpSgmnt:scope)
        {
            if(grpSgmnt.GA_Cancellation_Date__c<=system.today() && grpSgmnt.GA_Cancellation_Date__c!=null){
                gpsgmntTocnl.add(grpSgmnt);   
            }           
            if( grpSgmnt.Network__c==BCN){
                gpsgmntToActv.add(grpSgmnt);  
            }         
            if( grpSgmnt.Status__c==PNDG && ((grpSgmnt.GA_Transaction_Posted__c || grpSgmnt.GA_Post_Transaction__c))){
                gpsgmntToActv.add(grpSgmnt);                          
            }
            
            if(profileName==INTGRTNUSR){
                if(grpSgmnt.Status__c==CNCLD && grpSgmnt.GA_Group_Effective_Date__c<=system.today() 
                   && (grpSgmnt.GA_Cancellation_Date__c>system.today() 
                       || grpSgmnt.GA_Cancellation_Date__c==null))
                {
                    gpsgmntToActv.add(grpSgmnt);
                }
            }
        }
        list<GA_Group_Segment__c> grpSgmntActv=new list<GA_Group_Segment__c>();
        list<GA_Group_Segment__c> grpSgmnttoCncl=new list<GA_Group_Segment__c>();
        List<Id> cancelLst = New List<Id>();
        Date futrEndDate = null;
        Date futrEndDateAssign = Date.newInstance(2099, 12, 31);
        for(GA_Group_Segment__c grpSgmnt:gpsgmntToActv)
        {
            if(grpSgmnt.GA_Group_Effective_Date__c<=system.today() && 
               grpSgmnt.GA_Cancellation_Date__c==null){
                   futrEndDate = futrEndDateAssign;
               }
            else{
                futrEndDate = grpSgmnt.GA_Cancellation_Date__c;
            }
            if(grpSgmnt.GA_WF_Group_Segment__r.size()>0)
            {
                if(grpSgmnt.Status__c==PNDG && grpSgmnt.Network__c==BCN)
                {
                    grpSgmnt.GA_Is_Mass_Updating__c=true;
                    grpSgmnt.Status__c=ACTV;
                    grpSgmnt.GA_Is_Processed__c=true;
                    grpSgmntActv.add(grpSgmnt); 
                }
                else{
                    if(grpSgmnt.Status__c==PNDG  && 
                       (grpSgmnt.GA_Transaction_Posted__c || grpSgmnt.GA_Post_Transaction__c))
                    {
                        grpSgmnt.GA_Is_Mass_Updating__c=true;
                        grpSgmnt.Status__c=ACTV;
                        grpSgmnt.GA_Is_Processed__c=true;
                        grpSgmntActv.add(grpSgmnt); 
                    }  
                }
            }
            
            if(profileName==INTGRTNUSR){
                if(grpSgmnt.Status__c==CNCLD && futrEndDate>system.today() 
                   && grpSgmnt.GA_Group_Effective_Date__c<=system.today())
                {
                    grpSgmnt.GA_Is_Mass_Updating__c=true;
                    grpSgmnt.Status__c=ACTV;
                    grpSgmnt.GA_Is_Processed__c=true;
                    grpSgmntActv.add(grpSgmnt);
                }
            }
        }
        
        for(GA_Group_Segment__c grpSgmnt:gpsgmntTocnl)
        {
            if(grpSgmnt.Status__c <> CNCLD){
                cancelLst.add(grpSgmnt.id);
            }
            if(grpSgmnt.GA_Cancellation_Date__c!=null && grpSgmnt.GA_Cancellation_Date__c<=system.today())
            {
                grpSgmnt.GA_Is_Mass_Updating__c=true;
                grpSgmnt.Status__c=CNCLD;
            }
            
            grpSgmnttoCncl.add(grpSgmnt);
            
        }
        GA_GS_AP02_Update_Address.isExecuting=true;
        GA_GS_UpdateRatingType.isExecuting = true;
        GA_GroupSegmentTriggerHandler.isExecuting = true;
        GA_GS_UpdatWrappingFileTPA.isExecuting = true;
        GA_GroupSegAccUpdateCls.isExecuting = true;
        GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
        GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
        GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
        GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
        database.update(grpSgmntActv,false);
        database.update(grpSgmnttoCncl,false);
        
        GA_GS_AP04_UpdtStatus.cnclgsList = cancelLst;       
        GA_GS_AP04_UpdtStatus.updtCnclStatusGS(grpSgmnttoCncl,null);
        GA_GS_AP04_UpdtStatus.updtRecTypeAcc(grpSgmntActv);
        
        GA_ExternalAppealRecdCrtnUpdt.updtNHREndDtOnExtnlApl(grpSgmnttoCncl,null);
        GA_ExternalAppealRecdCrtnUpdt.updtNHREndDtOnExtnlApl(grpSgmntActv,null);
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}