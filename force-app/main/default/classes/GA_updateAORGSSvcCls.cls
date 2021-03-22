/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_updateAORGSSvcCls 
@CreatedDate: 18 - June 2019 
@Description: GA_updateAORGSSvcCls class for AOR clone/update.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_updateAORGSSvcCls {
    public static Boolean stopSrvEndtLogic = false;
    public static Boolean changedSrvEndtLogic = false;
    public static Boolean isExecuting = false;
    public static Map<Id,Date> aorSrvEndDtMap = New Map<Id,Date>();
    public static Map<Id,Date> aorSrvStartDtMap = New Map<Id,Date>();
    public static final String CLSNAM  = 'GA_updateAORGSSvcCls';
    public static final String METHODNAME  = 'updateAORGSInfo' ;
    public static final String SRVCENDDT  ='GA_Service_End_Date__c';
    public static final String CLNSTR  ='_Clone';
    public static final String AORGSOBJNM = 'GA_AOR_Group_Segment__c';
    public static final String AORFLD =   'GA_AOR_Id__c';
    public static final String AORCNTCFLD =   'GA_Contact_Id__c';
    public static final String BLNK =   '';
    public static final string AORGSQUERY ='Select id,name,GA_Process_Start_Date__c,GA_Process_End_Date__c,GA_Cancel_Flag__c,'+
        'GA_Group_Segment_Id__c,GA_ProcessAgentId__c,GA_Cancel_Date__c,GA_Service_Start_Date__c,'+
        'GA_Service_End_Date__c,GA_AOR_Id__r.GA_Service_End_Date__c,GA_AOR_Id__r.GA_Service_Start_Date__c  '+
        'from GA_AOR_Group_Segment__c ';
    public static final string AORGSWHERE1=' where GA_AOR_Id__c in ';
    public static final string AORGSLIMIT=' Limit 1000';
    public static final string SPC=' ';
    
    /*******************************************************************************************************************************
@Description    :  updateAORGSInfo 
@Name         :   updateAORGSInfo
@Param         :  list<GA_AOR__c> aorLst,map<Id,GA_AOR__c> aorOldMap
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updateAORGSInfo(list<GA_AOR__c> aorLst,map<Id,GA_AOR__c> aorOldMap){
        try{
            String cloneAoRId = BLNK;
            String previousRecordId = BLNK;
            Set<Id> aorSrvEndDtIds = New Set<Id> ();
            aorSrvEndDtMap = New Map<Id,Date>();
            aorSrvStartDtMap = New Map<Id,Date>();
            
            for(GA_AOR__c aor : aorLst){
                String prevRecord = aor.GA_Prevs_RecordID__c;
                if(!STring.isEmpty(prevRecord)){
                    if(   prevRecord.contains(CLNSTR)){
                        previousRecordId=prevRecord.removeEnd(CLNSTR);
                        aor.GA_Prevs_RecordID__c=previousRecordId;
                        cloneAoRId = aor.id;
                    }
                }
                if(aorOldMap<> null){
                    if((aor.GA_Service_End_Date__c <> aorOldMap.get(aor.id).get(SRVCENDDT))||(aor.GA_Contact_Id__c <> aorOldMap.get(aor.id).get('GA_Contact_Id__c'))){
                        aorSrvEndDtIds.add(aor.id);
                        aorSrvEndDtMap.put(aor.id,aor.GA_Service_End_Date__c);
                        aorSrvStartDtMap.put(aor.id,aor.GA_Service_Start_Date__c);
                    }   
                    
                    if( (aor.GA_Contact_Id__c <> aorOldMap.get(aor.id).get(AORCNTCFLD)) ){
                        aor.Name =  aor.GA_Agent_Contact_Name__c +SPC+  aor.GA_Agent_Code__c;
                       // aor.GA_Is_Mass_Updating__c =  true;
                    } 
                }
                
            }
            
            if(!String.isEmpty(cloneAoRId) ){
                stopSrvEndtLogic = true;
                GA_CloneAORCls.cloneChildRecords(AORGSOBJNM, previousRecordId,  cloneAoRId,AORFLD);
                
            }
            
            if(aorSrvEndDtIds.size() > 0 && !stopSrvEndtLogic  ){
                GA_AORGS_RestrictDuplicateAORGS.restrictDuplicateRule = true;
                changedSrvEndtLogic= True;
                String aorIdSet = GA_Util08_FilterProcessHelper.idSet(aorSrvEndDtIds);
                List<GA_AOR_Group_Segment__c> aorGsLst=  GA_Util24_AORGSDataAccesHelper.fetchAORGSMap(AORGSQUERY,AORGSWHERE1+aorIdSet, AORGSLIMIT).values();
                if(aorGsLst.size() > 0){
                  //  GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.updtDateInfo(aorGsLst,null);
                   // GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.updtSrvcAgntToGS(aorGsLst, null);
                  GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.isChnge = true;
                   Database.update(aorGsLst);
                }
            }
        }
        catch(Exception excpDtls){
            GA_LogExceptionCls.LogExcp(excpDtls, CLSNAM, METHODNAME);
        }
        
    }
    
}