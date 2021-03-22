/*****************************************************************************************
Class Name   : GA_AP_CIDAdjustMentCls
Date Created : 12/13/2018
Created By   : IDC Offshore
Description  : To create CID Adjustment records.
******************************************************************************************/
public class GA_AP_CIDAdjustMentCls {
    
    public static final string ClsName  ='GA_AP_CIDAdjustMentCls';
    public static final string fetchSourceAcntInfo  ='fetchSourceAcntInfo';
    public static final string fetchTrgtAcntInfo  ='fetchTrgtAcntInfo';
    public static final string creteCIDAdjustmntRecs  ='creteCIDAdjustmntRecs';
    public static final string submitCIDAjustment  ='submitCIDAjustment';
    public static final string fectCIDInfo  ='fectCIDInfo';   
    public static final String excepSepartr=': ';
    public static final string Pending = 'Pending';
    public static final string Active = 'Active';
    public static final string MOS = 'MOS';
    public static final string Nw = 'New';
    public static final string None = 'None';
    public static final string Queue = 'Queue' ;
    public static final string DataAdministration = 'GA_Data_Administration' ;
  
        /**
@Description: fetchCIDAdjCreate() method 
@Name : fetchCIDAdjCreate
@Param :null
@Return : GA_Trigger_Functionality_By_Pass__c
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static boolean fetchCIDAdjCreate(){
        try
        {
            return GA_Trigger_Functionality_By_Pass__c.getInstance().GA_CID_Adjustment__c;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchSourceAcntInfo);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+excepSepartr+e.getMessage()); 
        }
    }
    
    /**
@Description: fetcAccInfo() method 
@Name : fetcAccInfo
@Param : string recId
@Return : accGrpDataCls
@throws Exception : None
*/    
    private static accGrpDataCls fetcAccInfo(string recId)
    {
        Account acc=[select id,CID__c,Name,GA_RecordType__c,GA_Territory__r.GA_TerritoryCode__c,
                     Federal_Tax_ID__c,GA_Decision_Maker__c,GA_Decision_Maker__r.Name,
                     GA_Mutual_Voter__c,GA_Mutual_Voter__r.Name,
                     Renewal_Month__c,GA_System_of_Record__c,Account_Status__c,
                     GA_SIC_Code_Lookup__r.Name,GA_SIC_Code_Lookup__c, 
                     BillingStreet, BillingCity, BillingState, BillingPostalCode,
                     BillingCountry,ShippingStreet, ShippingCity,ShippingState,
                     ShippingPostalCode,ShippingCountry, Phone,(select id,Name,Status__c,Network__c,GA_In_Progress__c,GA_In_Progress_Type__c,GA_MTV_Group__c from Group_Segments__r order by Status__c asc) 
                     from Account where id =:recId];
        GrpDataCls grpDta=new GrpDataCls();
        list<GrpDataCls> grpDtaLst=new list<GrpDataCls>();
        for(GA_Group_Segment__c grp:acc.Group_Segments__r)
        {
            grpDta=new GrpDataCls();
            /*if(grp.Status__c!=Pending && !grp.GA_In_Progress__c)
            {
                if(grp.Network__c==MOS && grp.Status__c==Active)
                {
                    grpDta.disbleGrp=true;
                }
                else
                {
                    grpDta.disbleGrp=false;
                }
            }
            else
            {
                if(grp.GA_In_Progress__c)
                grpDta.inProgrssType=grp.GA_In_Progress_Type__c;
                grpDta.disbleGrp=true; 
            }*/
            if(grp.Status__c ==Pending){
                grpDta.disbleGrp=true;
            }
            else if(grp.GA_MTV_Group__c != null && grp.Status__c==Active){
                grpDta.disbleGrp=true;
            } 
            else{
               grpDta.disbleGrp=false; 
            }
            grpDta.grpSgmnt=grp;
            grpDtaLst.add(grpDta);
        }
        
        list<GrpDataCls> grpDtLstSrtedSlt=new list<GrpDataCls>();
        list<GrpDataCls> grpDtLstSrtedNonSlt=new list<GrpDataCls>();
        
        for(GrpDataCls grpDt:grpDtaLst)
        {
            if(!grpDt.disbleGrp)
            {
                grpDtLstSrtedSlt.add(grpDt);
            }
            else
            {
                grpDtLstSrtedNonSlt.add(grpDt);
            }
        }
        grpDtLstSrtedSlt.addAll(grpDtLstSrtedNonSlt);
        accGrpDataCls accDataPrcs=new accGrpDataCls();
        accDataPrcs.acc=acc;
        accDataPrcs.GrpDataLst=grpDtLstSrtedSlt;
        accDataPrcs.NonslctGrp=grpDtLstSrtedNonSlt.size();
        return accDataPrcs;
    }
    
    public class accGrpDataCls
    {
        @AuraEnabled
        public account acc;
        @AuraEnabled
        public list<GrpDataCls> GrpDataLst;
        @AuraEnabled
        public integer NonslctGrp;
    }
    
    public class GrpDataCls 
    {   
        @AuraEnabled
        public boolean disbleGrp;
        @AuraEnabled
        public string inProgrssType;
        @AuraEnabled
        public GA_Group_Segment__c grpSgmnt;
        
    }
    /**
@Description: fetchSourceAcntInfo() method 
@Name : fetchSourceAcntInfo
@Param : string recId
@Return : accGrpDataCls
@throws Exception : AuraHandledException
*/    
    @AuraEnabled
    public static accGrpDataCls fetchSourceAcntInfo(string recId)
    {
        try{
            accGrpDataCls acc=fetcAccInfo(recId);
            return acc;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchSourceAcntInfo);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+excepSepartr+e.getMessage()); 
        }
    }
    /**
@Description: fetchTrgtAcntInfo() method 
@Name : fetchTrgtAcntInfo
@Param : string recId
@Return : accGrpDataCls
@throws Exception : AuraHandledException
*/     
    @AuraEnabled
    public static accGrpDataCls fetchTrgtAcntInfo(string recId)
    {
        try{
            accGrpDataCls acc=fetcAccInfo(recId);
            return acc;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchTrgtAcntInfo);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+excepSepartr+e.getMessage()); 
        }
    }
    /**
@Description: creteCIDAdjustmntRecs() method 
@Name : creteCIDAdjustmntRecs
@Param : account sourceAcnt,account trgtAcnt,list<GA_Group_Segment__c> grpSgmnts,
boolean allGrpSlect,boolean terrMisMatch,boolean FexTaxmidMatch,string cidRecId
@Return : string
@throws Exception : AuraHandledException
*/      
    @AuraEnabled
    public static string creteCIDAdjustmntRecs(account sourceAcnt,account trgtAcnt,list<GA_Group_Segment__c> grpSgmnts,
                                               boolean allGrpSlect,boolean terrMisMatch,boolean FexTaxmidMatch,string cidRecId)
    {
        try{
            
            GA_CID_Adjustment__c cidadjustmnt=new GA_CID_Adjustment__c();
            cidadjustmnt.GA_Source_Account__c=sourceAcnt.Id;
            cidadjustmnt.GA_Target_Account__c=trgtAcnt.Id;
            cidadjustmnt.GA_Federal_Tax_ID_Mismatch__c=FexTaxmidMatch;
            cidadjustmnt.GA_Territory_Code_Mismatch__c=terrMisMatch;
            cidadjustmnt.GA_All_Group_Segments__c=allGrpSlect;
            cidadjustmnt.GA_Status__c=None;
            if(cidRecId ==null)
            {
               
                database.insert(cidadjustmnt);
            }
            
            else
            {
                
                cidadjustmnt.id=cidRecId;
                database.update(cidadjustmnt);
                list<GA_Process_Group_Segment__c> grpCIDLstToDelete=[select id from GA_Process_Group_Segment__c where GA_CID_Adjustment__c =:cidRecId]; 
                if(grpCIDLstToDelete.size()>0)
                {
                    database.delete(grpCIDLstToDelete);
                }
            }
            list<GA_Process_Group_Segment__c> grpCIDLst=new list<GA_Process_Group_Segment__c>();
            GA_Process_Group_Segment__c grpCIDRec=new GA_Process_Group_Segment__c();
            for(GA_Group_Segment__c grpGmnt:grpSgmnts)
            {
                grpCIDRec=new GA_Process_Group_Segment__c();
                grpCIDRec.GA_CID_Adjustment__c=cidadjustmnt.Id;
                grpCIDRec.GA_Group_Segment__c=grpGmnt.Id;
                grpCIDLst.add(grpCIDRec);
                grpGmnt.GA_In_Progress__c=true;
                grpGmnt.GA_In_Progress_Type__c='CID Adjustment';
                grpGmnt.GA_Is_Mass_Updating__c=true;
            }
            database.insert(grpCIDLst);
            GA_GS_AP02_Update_Address.isExecuting=true;
            //GA_ExternlaAppleSrvcCls.isExecuting = true;
            GA_GS_UpdateRatingType.isExecuting = true;
            GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
            GA_GroupSegmentTriggerHandler.isExecuting = true;
            GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
            GA_GS_AP04_UpdtStatus.isExecuting = true;
            GA_GS_AP04_UpdtStatus.isInvoked = true;
            GA_GS_UpdatWrappingFileTPA.isExecuting = true;
            database.update(grpSgmnts);
            return cidadjustmnt.Id;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, creteCIDAdjustmntRecs);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+excepSepartr+e.getMessage()); 
        }
    }
    /**
@Description: submitCIDAjustment() method 
@Name : submitCIDAjustment
@Param : string recId
@Return : void
@throws Exception : AuraHandledException
*/   
    @AuraEnabled
    public static void submitCIDAjustment(string recId)
    {
        try{
            list<Group> queLst=[select Id from Group where Type =:Queue AND DeveloperNAME =:DataAdministration limit 1];
            GA_CID_Adjustment__c CIDAdjRec=[select id,GA_Status__c,OwnerId,GA_Territory_Code_Mismatch__c,GA_Federal_Tax_ID_Mismatch__c
                                            from GA_CID_Adjustment__c where id=:recId];
            CIDAdjRec.Id=recId;
            CIDAdjRec.GA_Status__c=Nw;
            if(queLst.size()>0)
                CIDAdjRec.OwnerId=queLst[0].Id;
            
            database.update(CIDAdjRec);
            
            
            list<GA_Approval__c> apprvlInfoLst=new list<GA_Approval__c>();
            if(CIDAdjRec.GA_Territory_Code_Mismatch__c)
            {
                GA_Approval__c appvlTerr=new GA_Approval__c();
                appvlTerr.GA_CID_Adjustment__c=recId;
                appvlTerr.GA_Type__c='Territory';
                
                
                apprvlInfoLst.add(appvlTerr);
            }
            if(CIDAdjRec.GA_Federal_Tax_ID_Mismatch__c)
            {
                GA_Approval__c appvlFedTx=new GA_Approval__c();
                appvlFedTx.GA_CID_Adjustment__c=recId;
                appvlFedTx.GA_Type__c='Federal Tax Id';
               
                
                apprvlInfoLst.add(appvlFedTx);
            }
            if(apprvlInfoLst.size()>0)
            {
                database.insert(apprvlInfoLst);
            }
            

        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, submitCIDAjustment);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+excepSepartr+e.getMessage()); 
        }
    }
    /**
@Description: fectCIDInfo() method 
@Name : fectCIDInfo
@Param : string recId
@Return : cidAjstCnfrimCls
@throws Exception : AuraHandledException
*/     
    @AuraEnabled
    public static cidAjstCnfrimCls fectCIDInfo(string recId)
    {
        try{
            GA_CID_Adjustment__c CIDAdjRec=[select id,Name,GA_Status__c,GA_Source_Account__c,
                                            GA_Target_Account__c,
                                            (select id,Name,GA_Group_Segment__r.Name,GA_Group_Segment__r.Status__c,GA_Group_Segment__r.Network__c 
                                             from Process_Group_Segments__r) from GA_CID_Adjustment__c  where id =:recId];
            
            
            set<id> acIds=new set<id> ();
            acIds.add(CIDAdjRec.GA_Source_Account__c);
            acIds.add(CIDAdjRec.GA_Target_Account__c);
            list<Account> accLst=[select id,CID__c,Name,GA_Territory__r.GA_TerritoryCode__c,
                                  Federal_Tax_ID__c,GA_Decision_Maker__c,GA_Decision_Maker__r.Name,
                                  GA_Mutual_Voter__c,GA_Mutual_Voter__r.Name,
                                  Renewal_Month__c,GA_System_of_Record__c,Account_Status__c,
                                  GA_SIC_Code_Lookup__r.Name,GA_SIC_Code_Lookup__c, 
                                  BillingStreet, BillingCity, BillingState, BillingPostalCode,
                                  BillingCountry,ShippingStreet, ShippingCity,ShippingState,
                                  ShippingPostalCode,ShippingCountry, Phone from account where id in:acIds];
            account srcAcc;
            account trgtAcc;
            for(account acc: accLst)
            {
                if(acc.Id==CIDAdjRec.GA_Source_Account__c)
                {
                    srcAcc=acc;
                }
                else
                {
                    trgtAcc=acc;
                }
            }
            cidAjstCnfrimCls cidAjstCnfrm=new cidAjstCnfrimCls();
            cidAjstCnfrm.srcAccnt=srcAcc;
            cidAjstCnfrm.trgtAccnt=trgtAcc;
            list<GA_Group_Segment__c> grpSGmntssLst=new list<GA_Group_Segment__c>();
            GA_Group_Segment__c grpTmp=new GA_Group_Segment__c();
            
            for(GA_Process_Group_Segment__c prcssGrp:CIDAdjRec.Process_Group_Segments__r)
            {
                grpTmp=new GA_Group_Segment__c();
                grpTmp.Id=prcssGrp.GA_Group_Segment__c;
                grpTmp.Network__c=prcssGrp.GA_Group_Segment__r.Network__c;
                grpTmp.Name=prcssGrp.GA_Group_Segment__r.Name;
                grpTmp.Status__c=prcssGrp.GA_Group_Segment__r.Status__c;
                grpSGmntssLst.add(grpTmp);
            }
            cidAjstCnfrm.grpSGmntsPrcssLst=grpSGmntssLst;
            return cidAjstCnfrm;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fectCIDInfo);
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+excepSepartr+e.getMessage()); 
        }
    }
    
    public class cidAjstCnfrimCls
    {
        @AuraEnabled
        public account srcAccnt;
        @AuraEnabled
        public account trgtAccnt;
        @AuraEnabled
        public list<GA_Group_Segment__c> grpSGmntsPrcssLst;
    }
}