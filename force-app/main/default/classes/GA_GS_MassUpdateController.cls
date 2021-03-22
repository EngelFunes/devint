/**
@Author : Dilip
@Name: GA_GS_MassUpdateController
@CreatedDate: 19 - June 2018 
@Description: GA_GS_MassUpdateController class is for mass updation of Group Segment fields.
@version : 1.0  
*/ 
public without Sharing class GA_GS_MassUpdateController {
    public static final string gSgmtQuery='select id,name, GA_Record_Url__c, GA_Group_Name__c, Status__c, GA_MTV_Group__c, GA_Bill_Adj_Seq_Code__c, '+
        'GA_Bill_Period_Code__c, GA_ID_Card_Seq_Code__c, GA_Invoice_Code__c, GA_Mail_Instruction_Code__c, '+
        'GA_Type_Eligible__c , GA_Billing_Cycle_Day__c, GA_Surviving_Spouse_Option__c, GA_System_of_Record__c, '+
        'GA_Previous_Carrier__c, GA_New_Hire_Change__c, '+
        'GA_New_Hire_Effective_Date__c, GA_Federal_Tax_ID_Number__c, GA_New_Hire_Rehire_Option_Id__c,  '+
        'GA_New_Hire_Exception__c, GA_Transfer_Clause_Indicator__c, GA_HBA_Division_Link__c, GA_HBI_Enhanced__c, '+
        'GA_HBI_Standard__c, GA_HBA_Level__c, GA_HBA__c, GA_MVP__c , GA_Account__r.Name, GA_Group_Effective_Date__c, '+
        'GA_Is_Selected__c, GA_Rel_Accom_Orig_Company__c from GA_Group_Segment__c ';
    
    public static final string gSgmtWhere='where GA_Account__c in'; 
    public static final string gSgmtWhere4=' or id =';
    public static final string gSgmtWhere3=' and (Status__c =';
    public static final string gSgmtWhere5=' and Status__c =';
    public static final string gSgmtWhere6=' where  id =';
    public static final string gsStatus='Active';
    public static final string statsInactv='Inactive';
    public static final string gSegOrdrBy=' order by createddate desc';
    public static final string gsLstLimit=' Limit 1000';
    public static final string gsLimit=' Limit 1';
    public static final string ClsName='GA_GS_MassUpdateController';
    public static final string methodNmeLst='gSgmtLst';
    public static final string methodPrcsng='processSelectedRecords';
    public static final string methodsavFed='saveFedTaxId';
    public static final string grpSegmntErrMsg='Unable to fetch group segments';
    public static final string PrcsngErrMsg='Unable to process group segments';
    public static final string savFedTaxId='Unable to update federal Tax Id';
    public static final string smartStr = 'SMART';
    public static final string insuffPrv = 'Insufficient privilege';
    public static final string noFedTaxId ='NoFedTaxId';
    public static final string grpSgmnt ='grpsegment';
    public static final string accValue ='account';
    public static final string noGrpSgmnt ='No Group Segments';
    /**
@Description: grSgmntLst() method 
@Name : grSgmntLst
@Param : string accId, string currentId, Boolean fetchAcc 
@Return : List
@throws Exception : N/A;
*/     
    @AuraEnabled     
    public static List<GrpSegmntWrapper> grSgmntLst(string accId, string currentId, Boolean fetchAcc) {
        List<GrpSegmntWrapper> gSWrperLst =  New List<GrpSegmntWrapper> ();
        List<GA_Group_Segment__c> gLst = New List<GA_Group_Segment__c>();
        try{
            
            GA_Mass_Update_Access__c mssUpdtAccess =  GA_Mass_Update_Access__c.getInstance();
            if(mssUpdtAccess.Access__c){
                set<id> CurIdSet=new set<id>();
                CurIdSet.add(accId);
                String ActIdString = GA_Util08_FilterProcessHelper.idSet(CurIdSet);
                Map<Id,GA_Group_Segment__c> gsMap = GA_Util17_GrpSgmntDataAccesHelper.fetchGrpSgmMap(gSgmtQuery, gSgmtWhere + ActIdString + gSgmtWhere3 + GA_Util08_FilterProcessHelper.FltrString(gsStatus) +gSgmtWhere4 + GA_Util08_FilterProcessHelper.FltrString(currentId) + GA_Util08_FilterProcessHelper.CLOSEBRACKET, gSegOrdrBy, gsLstLimit);
                
                if(gsMap.containsKey(currentId)){
                    GA_Group_Segment__c currRec =  gsMap.get(currentId);
                    if(currRec.GA_System_of_Record__c == smartStr){
                        GrpSegmntWrapper obj = new GrpSegmntWrapper();
                        obj.gsId = insuffPrv;                        
                        List<GrpSegmntWrapper> Wrplst =  New List<GrpSegmntWrapper> ();
                        Wrplst.add(obj);
                        return Wrplst;   
                    }
                    if(currRec.Status__c <> gsStatus){
                        GrpSegmntWrapper obj = new GrpSegmntWrapper();
                        obj.gsId = statsInactv;
                        
                        List<GrpSegmntWrapper> Wrplst =  New List<GrpSegmntWrapper> ();
                        Wrplst.add(obj);
                        return Wrplst;   
                    }
                    if(currRec.GA_Federal_Tax_ID_Number__c == null && fetchAcc){
                        GrpSegmntWrapper obj = new GrpSegmntWrapper();
                        obj.gsId = noFedTaxId;
                        
                        List<GrpSegmntWrapper> Wrplst =  New List<GrpSegmntWrapper> ();
                        Wrplst.add(obj);
                        return Wrplst;   
                    }
                    
                    if(gsMap!= null && !gsMap.isEmpty() ){
                        for(GA_Group_Segment__c gs : gsMap.values()){
                            if(fetchAcc){
                                GrpSegmntWrapper objAcc = new GrpSegmntWrapper();
                                objAcc.gsId = accId;
                                objAcc.Name = gs.GA_Account__r.Name;
                                objAcc.typeVal = accValue;
                                objAcc.isSelected = true;
                                gSWrperLst.add(objAcc);
                                fetchAcc = false;
                            } 
                            if(gs.id <> currentId){
                                GrpSegmntWrapper obj = new GrpSegmntWrapper();
                                obj.gsId = gs.id;
                                obj.Name = gs.name;
                                obj.GsName = gs.GA_Group_Name__c;
                                obj.Status = gs.Status__c;
                                obj.GroupNumber = gs.GA_MTV_Group__c;
                                obj.GroupEffectiveDate = gs.GA_Group_Effective_Date__c;
                                obj.isSelected = true;
                                obj.typeVal = grpSgmnt;
                                gSWrperLst.add(obj);
                            }
                        }
                    }
                    if(gSWrperLst.size() == 0){
                        GrpSegmntWrapper obj = new GrpSegmntWrapper();
                        obj.gsId = noGrpSgmnt;
                        gSWrperLst.add(obj);
                    }
                }
            }
            else{
                GrpSegmntWrapper obj = new GrpSegmntWrapper();
                obj.gsId = insuffPrv;
                gSWrperLst.add(obj);
            }
            
            return gSWrperLst;  
        }
        catch(Exception e){
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeLst);
            throw new AuraHandledException(grpSegmntErrMsg);
        }
    }
    /**
@Description: fetchAccsgrSgmntLst() method 
@Name : fetchAccsgrSgmntLst
@Param : string accId
@Return : List
@throws Exception : N/A;
*/    
    @AuraEnabled     
    public static List<GrpSegmntWrapper> fetchAccsgrSgmntLst(string accId) {
        List<GrpSegmntWrapper> gSWrperLst =  New List<GrpSegmntWrapper> ();
        List<GA_Group_Segment__c> gLst = New List<GA_Group_Segment__c>();
        try{
            
            GA_Mass_Update_Access__c mssUpdtAccess =  GA_Mass_Update_Access__c.getInstance();
            if(mssUpdtAccess.Access__c){
                set<id> CurIdSet=new set<id>();
                CurIdSet.add(accId);
                String ActIdString = GA_Util08_FilterProcessHelper.idSet(CurIdSet);
                gLst = GA_Util17_GrpSgmntDataAccesHelper.fetchGrpSgmMap(gSgmtQuery, gSgmtWhere + ActIdString + gSgmtWhere5 + GA_Util08_FilterProcessHelper.FltrString(gsStatus), gSegOrdrBy, gsLstLimit).values();
                if(!gLst.isEmpty()){
                    for(GA_Group_Segment__c gs : gLst){
                        GrpSegmntWrapper obj = new GrpSegmntWrapper();
                        obj.gsId = gs.id;
                        obj.Name = gs.name;
                        obj.GsName = gs.GA_Group_Name__c;
                        obj.Status = gs.Status__c;
                        obj.GroupNumber = gs.GA_MTV_Group__c;
                        obj.GroupEffectiveDate = gs.GA_Group_Effective_Date__c;
                        obj.isSelected = true;
                        
                        gSWrperLst.add(obj);
                    }
                }
                else{
                    GrpSegmntWrapper obj = new GrpSegmntWrapper();
                    obj.gsId = noGrpSgmnt;
                    gSWrperLst.add(obj);
                }
            }
            else{
                GrpSegmntWrapper obj = new GrpSegmntWrapper();
                obj.gsId = insuffPrv;
                gSWrperLst.add(obj);
            }
            return gSWrperLst;    
        }
        catch(Exception e){
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeLst);
            throw new AuraHandledException(grpSegmntErrMsg);
        }
    }  
    /**
@Description: processSelectedRecords() method 
@Name : processSelectedRecords
@Param : string grpSegRecords,String currentGrpSgmnt, Boolean fedTxId
@Return : void
@throws Exception : N/A;
*/
    @AuraEnabled
    Public static void processSelectedRecords(string grpSegRecords,String currentGrpSgmnt, Boolean fedTxId){
        try{
            List<GrpSegmntWrapper> gSList = new  List<GrpSegmntWrapper>();
            List<GA_Group_Segment__c>     gLst = GA_Util17_GrpSgmntDataAccesHelper.fetchGrpSgmMap(gSgmtQuery, gSgmtWhere6 +GA_Util08_FilterProcessHelper.FltrString(currentGrpSgmnt), gSegOrdrBy, gsLimit).values();
            List<GA_Group_Segment__c>  uptGsLst = New   List<GA_Group_Segment__c> ();
            List<Account> accList = New List<Account>();
            List<Sobject> accGsList = New List<Sobject>();
            if(!string.isBlank(grpSegRecords)){
                gSList = (List<GrpSegmntWrapper>)System.JSON.deserialize(grpSegRecords,List<GrpSegmntWrapper>.class);
                for(GrpSegmntWrapper gs :gSList ){
                    if(gs.typeVal !=accValue){
                        GA_Group_Segment__c  gst = New GA_Group_Segment__c();
                        gst.id = gs.gsid;
                        if(fedTxId){
                            gst.GA_Federal_Tax_ID_Number__c = gLst[0].GA_Federal_Tax_ID_Number__c; 
                            gst.GA_Is_Mass_Updating__c = true;
                        }
                        else{
                            gst.GA_Bill_Adj_Seq_Code__c = gLst[0].GA_Bill_Adj_Seq_Code__c;
                            gst.GA_Bill_Period_Code__c = gLst[0].GA_Bill_Period_Code__c;
                            gst.GA_ID_Card_Seq_Code__c = gLst[0].GA_ID_Card_Seq_Code__c;
                            gst.GA_Invoice_Code__c = gLst[0].GA_Invoice_Code__c;
                            gst.GA_Mail_Instruction_Code__c = gLst[0].GA_Mail_Instruction_Code__c;
                            gst.GA_Type_Eligible__c = gLst[0].GA_Type_Eligible__c;
                            gst.GA_Billing_Cycle_Day__c = gLst[0].GA_Billing_Cycle_Day__c;
                            gst.GA_Surviving_Spouse_Option__c = gLst[0].GA_Surviving_Spouse_Option__c;
                            gst.GA_Rel_Accom_Orig_Company__c = gLst[0].GA_Rel_Accom_Orig_Company__c;
                            gst.GA_New_Hire_Change__c = gLst[0].GA_New_Hire_Change__c;
                            gst.GA_New_Hire_Effective_Date__c = gLst[0].GA_New_Hire_Effective_Date__c;
                            gst.GA_New_Hire_Rehire_Option_Id__c = gLst[0].GA_New_Hire_Rehire_Option_Id__c;
                          //  gst.GA_Detailed_Rehire_Narrative__c = gLst[0].GA_Detailed_Rehire_Narrative__c;
                            gst.GA_New_Hire_Exception__c = gLst[0].GA_New_Hire_Exception__c;
                            gst.GA_Transfer_Clause_Indicator__c = gLst[0].GA_Transfer_Clause_Indicator__c;
                            gst.GA_HBA_Division_Link__c = gLst[0].GA_HBA_Division_Link__c;
                            gst.GA_HBI_Enhanced__c = gLst[0].GA_HBI_Enhanced__c;
                            gst.GA_HBI_Standard__c = gLst[0].GA_HBI_Standard__c;
                            gst.GA_HBA_Level__c = gLst[0].GA_HBA_Level__c;
                            gst.GA_HBA__c = gLst[0].GA_HBA__c;
                            gst.GA_MVP__c = gLst[0].GA_MVP__c;
                            gst.GA_Is_Mass_Updating__c = true;
                        }
                        accGsList.add(gst); 
                    }
                    else{
                        Account acc = new Account();
                        acc.id = gs.gsid;
                        acc.Federal_Tax_ID__c = gLst[0].GA_Federal_Tax_ID_Number__c;
                        acc.GA_Is_Mass_Updating__c = true;
                        accGsList.add(acc);
                    }
                }
                if(!accGsList.isEmpty()){
                    Database.update(accGsList, false);
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodPrcsng);
            throw new AuraHandledException(PrcsngErrMsg);
        }
    }
    /**
@Description: saveFedTaxId() method 
@Name : saveFedTaxId
@Param : string grpSegRecords,String acFedTaxId
@Return : void
@throws Exception : N/A;
*/    
    @AuraEnabled
    Public static void saveFedTaxId(string grpSegRecords,String acFedTaxId){
        
        try{
            List<GrpSegmntWrapper> gSList = new  List<GrpSegmntWrapper>();
            List<GA_Group_Segment__c>  uptGsLst = New   List<GA_Group_Segment__c> ();
            List<Account> accList = New List<Account>();
            if(!string.isBlank(grpSegRecords)){
                gSList = (List<GrpSegmntWrapper>)System.JSON.deserialize(grpSegRecords,List<GrpSegmntWrapper>.class);
                for(GrpSegmntWrapper gs :gSList ){
                    GA_Group_Segment__c  gst = New GA_Group_Segment__c();
                    gst.id = gs.gsId;               
                    gst.GA_Federal_Tax_ID_Number__c = acFedTaxId;
                    gst.GA_Is_Mass_Updating__c = true;
                    uptGsLst.add(gst); 
                }
                
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true; 
                
                Database.update(uptGsLst, false);
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodsavFed);
            throw new AuraHandledException(savFedTaxId);
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
    }
}