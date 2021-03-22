/**
@Author : Rahul
@Name: GA_MA_AddSegmentsController
@CreatedDate: 09-Mar-2020
@Description: GA_MA_AddSegmentsController  class is to add Group segments to Managing Agency
@version : 1.0  
*/ 
public with Sharing class GA_MA_AddSegmentsController 
{
    public static final string CLSNAME='GA_MA_AddSegmentsController';
    public static final string METHODNMLST='fetchAccsgrSgmntLst';
    public static final string GRPSEGERRMSG='Unable to fetch group segments';
    /**
    @Description: fetchAccsgrSgmntLst() method 
    @Name : fetchAccsgrSgmntLst
    @Param : string accId
    @Return : List
    @throws Exception : N/A;
    */    
    @AuraEnabled     
    public static List<GrpSegmntWrapper> fetchAccsgrSgmntLst(string accId, String maId) 
    {
        List<GrpSegmntWrapper> gSWrperLst =  New List<GrpSegmntWrapper> ();
        
        try{
                GrpSegmntWrapper obj =  New  GrpSegmntWrapper();
                for(GA_Group_Segment__c gs : [SELECT Id, Name,GA_Account__c ,  GA_Group_Name__c, Status__c, GA_MTV_Group__c, GA_Rating_Type__c, GA_Group_Effective_Date__c, Network__c 
                                                    FROM GA_Group_Segment__c
                                                    WHERE Status__c <> 'Canceled' AND GA_Account__c =: accId]) //'0013J000002V7inQAC'
                    {
                        obj = new GrpSegmntWrapper();
                        obj.gsId = gs.id;
                        obj.Name = gs.name;
                        obj.GsName = gs.GA_Group_Name__c;
                        obj.Status = gs.Status__c;
                        obj.GroupNumber = gs.GA_MTV_Group__c;
                        obj.ratingTyp = gs.GA_Rating_Type__c;
                        obj.GroupEffectiveDate = gs.GA_Group_Effective_Date__c;
                        obj.isSelected = true;
                        obj.typeVal = gs.Network__c;
                                                                    
                        gSWrperLst.add(obj);
                    }
            	return gSWrperLst;    
        }
        catch(Exception e)
        {
            System.debug('====Exception==='+e);
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMLST);
            throw new AuraHandledException(GRPSEGERRMSG);
        }
    }  
    
    /**
    @Description: createMAGSrecords() method 
    @Name : createMAGSrecords
    @Param : string grpSegRecords,string aorId
    @Return : void
    @throws Exception : N/A;
    */    
    @AuraEnabled
    Public static void createMAGSrecords(string grpSegRecords, string maId)
    {
        
        try{
                List<GrpSegmntWrapper> gSList = new  List<GrpSegmntWrapper>();
                List<GA_Group_Segment__c>  uptGsLst = New   List<GA_Group_Segment__c> ();
                List<Account> accList = New List<Account>();
                Managing_Agency_Group_Segment__c newMAGs = New Managing_Agency_Group_Segment__c();
                List<Managing_Agency_Group_Segment__c> newMAGsLst = New  List<Managing_Agency_Group_Segment__c>();
                Managing_Agency__c objMA = [SELECT Id, Start_Date__c, End_Date__c, MA_Override_Start_Date__c, MA_Override_End_Date__c, Mng_Agency_Acc_Filter__c FROM Managing_Agency__c WHERE Id =: maId];
                GA_Managing_Agency_History__c objGrpSegHistory = new GA_Managing_Agency_History__c();
                List<GA_Managing_Agency_History__c> lstMngAgncyHistory = new List<GA_Managing_Agency_History__c>();
                
                if(!string.isBlank(grpSegRecords))
                {
                    gSList = (List<GrpSegmntWrapper>)System.JSON.deserialize(grpSegRecords,List<GrpSegmntWrapper>.class);
                    for(GrpSegmntWrapper gs : gSList )
                    {
                        newMAGs = New Managing_Agency_Group_Segment__c();
                        newMAGs.Managing_Agency__c = maId;
                        newMAGs.Group_Segment__c = gs.gsId;
                       
                        newMAGsLst.add(newMAGs);
                        
                        objGrpSegHistory = new GA_Managing_Agency_History__c();
                        objGrpSegHistory.GA_Group_Segment__c = gs.gsId;
                        objGrpSegHistory.GA_Start_Date__c = objMA.Start_Date__c;
                        // US 3339 Start
                        // if(gs.GroupEffectiveDate != null){
                        if(objMA.MA_Override_Start_Date__c != null){
                            objGrpSegHistory.MA_Override_Start_Date__c = objMA.MA_Override_Start_Date__c; //gs.GroupEffectiveDate; 
                        }
                        // US 3339 End
                        if(objMA.End_Date__c != null)
                        {
                        	objGrpSegHistory.GA_End_Date__c = objMA.End_Date__c;
                        }
                        // Start US 3339
                        if(objMA.MA_Override_End_Date__c != null)
                        {
                        	objGrpSegHistory.MA_Override_End_Date__c = objMA.MA_Override_End_Date__c;
                        }
                        // End US 3339
                        objGrpSegHistory.GA_Managing_Agency__c = objMA.Mng_Agency_Acc_Filter__c;
                            
                        lstMngAgncyHistory.add(objGrpSegHistory);
                    }
                    System.debug('====lstMngAgncyHistory==='+lstMngAgncyHistory);
                      
                    if(lstMngAgncyHistory.size() > 0)
                    {
                        insert lstMngAgncyHistory;
                    }
                    if(newMAGsLst.size() > 0)
                    {
                        insert newMAGsLst;
                    }
                }
        }
        catch(Exception e)
        {
            System.debug('====Exception==='+e);
            GA_LogExceptionCls.LogExcp(e, CLSNAME, 'createMAGSrecords');
            throw new AuraHandledException('Unable to insert ManagingAgency & ManagingAgencyHistory Records.');
        }
    }
   
    /**
    @Description: GrpSegmntWrapper wrapper 
    @Name : GrpSegmntWrapper
    @Param : N/Aa
    @Return : N/A
    @throws Exception : N/A;
    */     
    public without sharing class GrpSegmntWrapper{
        @AuraEnabled
        public String gsId {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String GsName {get;set;}
        @AuraEnabled
        public String Status {get;set;}
        @AuraEnabled
        public String GroupNumber {get;set;}
        @AuraEnabled
        public Date GroupEffectiveDate {get;set;}
        @AuraEnabled
        public boolean isSelected {get;set;}
        @AuraEnabled
        public String typeVal {get;set;}
        @AuraEnabled
        public String ratingTyp {get;set;}
    }
}