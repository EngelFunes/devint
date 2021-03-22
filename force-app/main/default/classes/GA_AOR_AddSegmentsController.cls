/**
@Author : IDC offshore
@Name: GA_AOR_AddSegmentsController
@CreatedDate: 19 - June 2018 
@Description: GA_AOR_AddSegmentsController  class is to add Group segments to AOR
@version : 1.0  
*/ 
public with Sharing class GA_AOR_AddSegmentsController {
    public static final string GSGMTQUERY='select id,name, GA_Record_Url__c, GA_Group_Name__c, Status__c, GA_MTV_Group__c, GA_Bill_Adj_Seq_Code__c, '+
        'GA_Bill_Period_Code__c, GA_ID_Card_Seq_Code__c, GA_Invoice_Code__c, GA_Mail_Instruction_Code__c, '+
        'GA_Type_Eligible__c , GA_Billing_Cycle_Day__c, GA_Surviving_Spouse_Option__c, GA_System_of_Record__c, '+
        'GA_Previous_Carrier__c, GA_New_Hire_Change__c, Network__c, '+
        'GA_New_Hire_Effective_Date__c, GA_Federal_Tax_ID_Number__c, GA_New_Hire_Rehire_Option_Id__c,  '+
        'GA_New_Hire_Exception__c, GA_Transfer_Clause_Indicator__c, GA_HBA_Division_Link__c, GA_HBI_Enhanced__c, '+
        'GA_HBI_Standard__c, GA_HBA_Level__c, GA_HBA__c,GA_Rating_Type__c, GA_MVP__c ,GA_Servicing_Agent__c, GA_Account__r.Name, GA_Group_Effective_Date__c, '+
        'GA_Is_Selected__c, GA_Rel_Accom_Orig_Company__c,GA_AOR_Group_Segment_Id__c,GA_AOR_Group_Segment_Id__r.GA_Cancel_Flag__c from GA_Group_Segment__c ';
    public static final string GSGMTWHERE='where GA_Account__c in'; 
    public static final string GSWHR7=' and Status__c !=';
    public static final string GSCNLSTS='Canceled';
    public static final string GSWHRAORGS=' and (GA_AOR_Group_Segment_Id__c = null or GA_AOR_Group_Segment_Id__r.GA_Cancel_Flag__c = true) ';
    public static final string GSEGORDYBY=' order by createddate desc';
    public static final string GSLSTLMT=' Limit 1000';
    public static final string CLSNAME='GA_GS_MassUpdateController';
    public static final string METHODNMLST='gSgmtLst';
    public static final string METHODSAVEFEXID='saveFedTaxId';
    public static final string GRPSEGERRMSG='Unable to fetch group segments';
    public static final string SEVFEDTAXID='Unable to update federal Tax Id';
    public static final string INSUFFPRV = 'Insufficient privilege';
    public static final string NOGRPSGMNT ='No Group Segments';  
    public static final string GRPSGMNTFOUND ='Group Segments Found'; 
    public static final string PRCAGNTID ='GA_ProcessAgentId__c';
    public static final string CNCLFLG ='GA_Cancel_Flag__c';
    public static final string SRVENDDT ='GA_Service_End_Date__c';
    public static final string AORGSQUERY ='Select id,name,GA_Cancel_Flag__c,GA_Group_Segment_Id__c,GA_ProcessAgentId__c,GA_Service_End_Date__c from GA_AOR_Group_Segment__c';
    public static final string AORGSWHERE3=' and GA_Cancel_Flag__c = false ';
    public static final string AORGSWHERE2=' where GA_AOR_Id__c =  ';
    public static final string AORGSLIMIT=' Limit 1000';
    public static final String AORGRPIDIN = ' where GA_Group_Segment_Id__c in ';
    public static final String AORIS = ' and    GA_AOR_Id__c= ';
    public static final String AORQRY = 'Select id,GA_Contact_Id__c from GA_Aor__C ';
    public static final String AORWHR = ' where id = ';
    public static final String AORLIMIT = ' Limit 1 ';
    public static final String BLNK = '';
    
    /**
@Description: fetchAccsgrSgmntLst() method 
@Name : fetchAccsgrSgmntLst
@Param : string accId
@Return : List
@throws Exception : N/A;
*/    
    @AuraEnabled     
    public static List<GrpSegmntWrapper> fetchAccsgrSgmntLst(string accId,String aorId) {
        List<GrpSegmntWrapper> gSWrperLst =  New List<GrpSegmntWrapper> ();
        List<GA_Group_Segment__c> gsLst =  New List<GA_Group_Segment__c> ();
        Map<Id,GA_Group_Segment__c> gsMap =  New  Map<Id,GA_Group_Segment__c> ();
        Map<Id,GA_AOR_Group_Segment__c> gsAORFlagMap =  New  Map<Id,GA_AOR_Group_Segment__c> (); 
        set<id> curIdSet=new set<id>();
        Map<Id,GA_AOR_Group_Segment__c>  aorGSMap = New Map<Id,GA_AOR_Group_Segment__c>();
        
        try{
            
            GA_Trigger_Functionality_By_Pass__c bypssErr=GA_Trigger_Functionality_By_Pass__c.getInstance();
            if(bypssErr.GA_AORAddGS__c){
                
                
                curIdSet.add(accId);
                String actIdString = GA_Util08_FilterProcessHelper.idSet(curIdSet);
                gsMap = GA_Util17_GrpSgmntDataAccesHelper.fetchGrpSgmMap(GSGMTQUERY, GSGMTWHERE + ActIdString + GSWHR7 + GA_Util08_FilterProcessHelper.FltrString(GSCNLSTS), GSEGORDYBY, GSLSTLMT);
                gsLst =  gsMap.values();
                String gsIdSet = GA_Util08_FilterProcessHelper.idSet(gsMap.keyset());
                system.debug('gsIdSet test++>' + gsIdSet);
                String   aorIdStr =   GA_Util08_FilterProcessHelper.FltrString(aorId);
                aorGSMap = GA_Util24_AORGSDataAccesHelper.fetchAORGSMap(AORGSQUERY, AORGRPIDIN+gsIdSet+AORIS+aorIdStr, AORGSLIMIT);
				             
                GA_Aor__C curreAOR = GA_Util23_AORDataAccesHelper.fetchAORMap(AORQRY, AORWHR + aorIdStr, AORLIMIT).values() ;
                for(GA_AOR_Group_Segment__c aorGs : aorGSMap.values()){
                    gsAORFlagMap.put(aorGs.GA_Group_Segment_Id__c, aorGs) ;                                 
                }
                
                
                GrpSegmntWrapper obj =  New  GrpSegmntWrapper();
                if(!gsLst.isEmpty() ){
                    for(GA_Group_Segment__c gs : gsLst){
                        
                        if((gsAORFlagMap.containsKey(gs.id) && ( curreAOR.GA_Contact_Id__c <> gsAORFlagMap.get(gs.id).get(PRCAGNTID) ||
                                                                ( (curreAOR.GA_Contact_Id__c == gsAORFlagMap.get(gs.id).get(PRCAGNTID)) && 
                                                                 (Boolean.ValueOf(gsAORFlagMap.get(gs.id).get(CNCLFLG)))  &&   
                                                                 (Date.ValueOf(gsAORFlagMap.get(gs.id).get(SRVENDDT)) >= System.today())    &&                     
                                                                 (gsAORFlagMap.get(gs.id).get(SRVENDDT) <> null)))) || (!gsAORFlagMap.containsKey(gs.id)) ){
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
                                                                     if(gsAORFlagMap.containsKey(gs.id) ){
                                                                         obj.removeAORflag = (gsAORFlagMap.get(gs.id).get(CNCLFLG)  == true ? true : false );
                                                                     }
                                                                     else{
                                                                         obj.removeAORflag = false;   
                                                                     }
                                                                     gSWrperLst.add(obj);
                                                                 }
                    }
                }
                else{
                    obj = new GrpSegmntWrapper();
                    obj.gsId = NOGRPSGMNT;
                    gSWrperLst.add(obj);
                }
            }
            else{
                GrpSegmntWrapper obj = new GrpSegmntWrapper();
                obj.gsId = INSUFFPRV;
                gSWrperLst.add(obj);
            }
            if(gSWrperLst.isEmpty() ){
                GrpSegmntWrapper obj = new GrpSegmntWrapper();
                obj.gsId = NOGRPSGMNT;
                gSWrperLst.add(obj);
            }
            return gSWrperLst;    
        }
        catch(Exception e){
           
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMLST);
            throw new AuraHandledException(GRPSEGERRMSG);
        }
    }  
    
    /**
@Description: createAORGSrecords() method 
@Name : createAORGSrecords
@Param : string grpSegRecords,string aorId
@Return : void
@throws Exception : N/A;
*/    
    @AuraEnabled
    Public static void createAORGSrecords(string grpSegRecords,string aorId){
        
        try{
            List<GrpSegmntWrapper> gSList = new  List<GrpSegmntWrapper>();
            List<GA_Group_Segment__c>  uptGsLst = New   List<GA_Group_Segment__c> ();
            List<Account> accList = New List<Account>();
            GA_AOR_Group_Segment__c newAorGs = New GA_AOR_Group_Segment__c();
            List<GA_AOR_Group_Segment__c> newAorGsLst = New  List<GA_AOR_Group_Segment__c>();
            
            if(!string.isBlank(grpSegRecords)){
                gSList = (List<GrpSegmntWrapper>)System.JSON.deserialize(grpSegRecords,List<GrpSegmntWrapper>.class);
                for(GrpSegmntWrapper gs :gSList ){
                    newAorGs = New GA_AOR_Group_Segment__c();
                    newAorGs.GA_AOR_Id__c = aorId;
                    newAorGs.GA_Group_Segment_Id__c = gs.gsId; 
                    newAorGs.GA_Is_Mass_Updating__c = true;
                    newAorGsLst.add(newAorGs);
                }
                
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true; 
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                
                GA_Util24_AORGSDataAccesHelper.dmlOnAORGs(newAorGsLst,GA_Util24_AORGSDataAccesHelper.INSERT_OPERATION);
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODSAVEFEXID);
            throw new AuraHandledException(SEVFEDTAXID);
        }
    }
    /**
@Description: checkAORaccess() method 
@Name : checkAORaccess
@Param : string accId
@Return : List
@throws Exception : N/A;
*/    
    @AuraEnabled     
    public static String checkAORaccess(String aorId) { 
        try{
            String respMsg = BLNK;
            if(GA_Trigger_Functionality_By_Pass__c.getInstance().GA_AORUpdateGS__c){
                set<id> curIdSet=new set<id>();
                curIdSet.add(aorId);
                String aorgsIdString = GA_Util08_FilterProcessHelper.FltrString(aorId);
                List<GA_AOR_Group_Segment__c> aorGsLst= GA_Util24_AORGSDataAccesHelper.fetchAORGSMap(AORGSQUERY, AORGSWHERE2 + aorgsIdString + AORGSWHERE3 ,AORGSLIMIT).values();
                if(!aorGsLst.isEmpty()){
                    respMsg =  GRPSGMNTFOUND;
                }
                else{
                    respMsg = NOGRPSGMNT;
                }}
            else{
                respMsg = INSUFFPRV ;
            }
            return respMsg;
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODSAVEFEXID);
            throw new AuraHandledException(SEVFEDTAXID);
        }
    }
    
    /**
@Description: saveCommissioninfo() method 
@Name : saveCommissioninfo
@Param : string accId
@Return : List
@throws Exception : N/A;
*/    
    @AuraEnabled     
    public static void saveCommissioninfo(string aorId,Boolean commFlag,Date commDt,String commNotes) { 
        try{
            List<GA_Group_Segment__c> updtGSLst = New List<GA_Group_Segment__c>();
            GA_Group_Segment__c updtGS = New GA_Group_Segment__c();
            Map<Id,GA_AOR_Group_Segment__c>  aorGSMap = New Map<Id,GA_AOR_Group_Segment__c>();
            String   aorIdStr =   GA_Util08_FilterProcessHelper.FltrString(aorId);
            
            aorGSMap = GA_Util24_AORGSDataAccesHelper.fetchAORGSMap(AORGSQUERY, AORGSWHERE2+aorIdStr+AORGSWHERE3, AORGSLIMIT);
            if(aorGSMap <> null){
                for(GA_AOR_Group_Segment__c aorGs : aorGSMap.values()){
                    updtGS = New GA_Group_Segment__c();
                    updtGS.id = aorGs.GA_Group_Segment_Id__c;
                    updtGS.GA_Commissionable__c =    commFlag;                        
                    updtGS.GA_Commission_Effective_Date__c = commDt;
                    
                    if( !String.isEmpty(commNotes))
                    {
                        updtGS.GA_Commission_Notes__c = commNotes;
                    }
                    updtGS.GA_Is_Mass_Updating__c=true;
                    
                    updtGSLst.add(updtGS); 
                }
            }
            if(!updtGSLst.isEmpty()){
                GA_GS_AP02_Update_Address.isExecuting=true;
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
                
                GA_Util17_GrpSgmntDataAccesHelper.dmlOnGS(updtGSLst,  GA_Util17_GrpSgmntDataAccesHelper.UPDATE_OPERATION);
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODSAVEFEXID);
            throw new AuraHandledException(SEVFEDTAXID);
        }
    }
    
    
    /**
@Description: GrpSegmntWrapper wrapper 
@Name : GrpSegmntWrapper
@Param : N/A
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
        public Boolean removeAORflag {get;set;}
        @AuraEnabled
        public String ratingTyp {get;set;}
    }
}