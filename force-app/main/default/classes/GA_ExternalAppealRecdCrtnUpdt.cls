/*******************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_ExternalAppealRecdCrtnUpdt 
@CreatedDate: 29 - May 2019 
@Description: GA_ExternalAppealRecdCrtnUpdt class is for creating and updating External Appeal records on Group Segment.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_ExternalAppealRecdCrtnUpdt {
    Public static boolean isExecuting=false;
    public Static final string CLSNAME  = 'GA_ExternalAppealRecdCrtnUpdt';
    public Static final string MTDCREATEEXTERNALAPPEALRECORD  = 'createExternalAppealRecord';   
    public Static final string MTDUPDTNHRENDDTONEXTNLAPL  = 'updtNHREndDtOnExtnlApl';
    public Static final string REACTIVATEPREVIOUSEARECORD  = 'reactivatePreviousEARecord';
    public Static final string REACTIVATEPREVIOUSEARECORDNASCO  = 'reactivatePreviousEARecordNASCO';
    public static final integer OCCURENCE = 0;
    public static final String  EXCPSVRTY='ERROR';
    public static final String  NASCO= 'NASCO';
    public static final String  MOS='MOS';
    public static final String  CNCLD='Canceled';
    public static final String  ACTIVE='Active';
    public static final String EXCPCODE = 'EXTERNAL APPEAL PROCESSING';
    
    /*******************************************************************************************************************************
@Description  :   updtNHREndDtOnExtnlApl 
@Name         :   updtNHREndDtOnExtnlApl
@Param        :   list<GA_Group_Segment__c> gSList, Map<Id,GA_Group_Segment__c> OldMap
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 
    public static void updtNHREndDtOnExtnlApl(list<GA_Group_Segment__c> gSList, Map<Id,GA_Group_Segment__c> OldMap)
    {
        try
        {   
            boolean isChnge=false;
            boolean isReinstated = false;
            
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            
            //Capturing Ids of records
            Set<Id> gsIds = New Set<Id>();
            Map<ID,GA_Group_Segment__c> gsDetailsMap = new Map<ID,GA_Group_Segment__c>();  
            for(GA_Group_Segment__c grpSeg :gSList)
            {
                gsIds.add(grpSeg.Id);
                gsDetailsMap.put(grpSeg.Id, grpSeg);
                if(OldMap !=null)
                {
                    GA_Group_Segment__c gsOld=OldMap.get(grpSeg.Id);
                    if((gsOld.Status__c !=grpSeg.Status__c)){
                        isChnge=true;     
                    }
                    if((gsOld.Status__c == CNCLD && grpSeg.Status__c == ACTIVE)){
                        isReinstated=true;     
                    }
                }
                else
                {
                    isChnge=true;
                    isReinstated=true; 
                }
            }
            
            List <GA_External_Appeal__c> updtExtnlAppList = new List <GA_External_Appeal__c>();
            Map<ID, List<GA_External_Appeal__c>> extnlAppMap = new Map <ID, List<GA_External_Appeal__c>>();
            for(GA_External_Appeal__c extnlApp :[select id,name,GA_NHR_End_Date__c,GA_Group_Segment_Id__c from GA_External_Appeal__c where GA_Group_Segment_Id__c IN :gsIds AND (GA_NHR_End_Date__c =null OR GA_NHR_End_Date__c>=Today) limit 2000])
           if(extnlAppMap.containskey(extnlApp.GA_Group_Segment_Id__c))
            {
                extnlAppMap.get(extnlApp.GA_Group_Segment_Id__c).add(extnlApp);
                
                
            }
            else
            {
                extnlAppMap.put(extnlApp.GA_Group_Segment_Id__c, new List<GA_External_Appeal__c>{extnlApp});
                
            }
            if(gsIds.size()>0)
            {
                //Updating NHR End Date on ExternalAppeal Records for NASCO Canceled GroupSegments 
                for(GA_Group_Segment__c grpSeg :gSList){
                    if(( NASCO.equalsIgnoreCase(grpSeg.Network__c)  || MOS.equalsIgnoreCase(grpSeg.Network__c )) &&
                       CNCLD.equalsIgnoreCase(grpSeg.Status__c) && isChnge){
                           Date currentDate = System.today();
                           for(GA_External_Appeal__c extnlApp :extnlAppMap.get(grpSeg.id)){
                               if(gsDetailsMap.get(extnlApp.GA_Group_Segment_Id__c) !=null)
                               {
                                   if(gsDetailsMap.get(extnlApp.GA_Group_Segment_Id__c).GA_PA_250__c)
                                   {
                                       extnlApp.GA_NHR_End_Date__c = currentDate.addMonths(50);
                                   }
                                   else if(gsDetailsMap.get(extnlApp.GA_Group_Segment_Id__c).GA_DOL__c)
                                   {
                                       extnlApp.GA_NHR_End_Date__c = currentDate.addMonths(32);
                                   }
                                   else{
                                       extnlApp.GA_NHR_End_Date__c = system.today();
                                   }                                
                                   updtExtnlAppList.add(extnlApp);
                               }                            
                           }
                       } else if(MOS.equalsIgnoreCase(grpSeg.Network__c) &&
                                 ACTIVE.equalsIgnoreCase(grpSeg.Status__c) && isReinstated){
                                     reactivatePreviousEARecord(grpSeg.Id,updtExtnlAppList,extnlAppMap);
                                 }
                    else
                    {
                        
                    }
                }
            }
            if(updtExtnlAppList.size()>0)
            {
                srList = Database.update(updtExtnlAppList,false);
            }
            
            ExceptionLog__c objLog = new ExceptionLog__c();
            if(!srList.isEmpty()){
                for(Database.SaveResult obj : srList){
                    for(Database.Error objErr : obj.getErrors()){
                        if(!obj.isSuccess()){
                            objLog = new ExceptionLog__c(
                                Object_ID__c =obj.getId(),
                                ExceptionDescription__c = objErr.getMessage(),
                                ExceptionCode__c =  EXCPCODE,
                                NumberOfTimesOccured__c = OCCURENCE + 1,
                                ExceptionDetails__c = objErr.getMessage(),
                                Severity__c = EXCPSVRTY);
                            excpLst.add(objLog);
                        } 
                    }
                }
            }
            if(!excpLst.isEmpty()){
                Database.upsert(excpLst,false);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTDUPDTNHRENDDTONEXTNLAPL);
        }
    }
    
    /*******************************************************************************************************************************
@Description  :   reactivatePreviousEARecordNASCO 
@Name         :   reactivatePreviousEARecordNASCO
@Param        :   list<GA_Plan_Package__c> planPkgList, map<id,GA_Plan_Package__c > plnPkgOldMap
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 
    public static void reactivatePreviousEARecordNASCO(list<GA_Plan_Package__c> planPkgList, map<id,GA_Plan_Package__c > plnPkgOldMap)
    {
         Set<Id> gsIds = New Set<Id>();
            for(GA_Plan_Package__c grpSeg :planPkgList)
            {
                gsIds.add(grpSeg.GA_Group_Segment__c);
            }
        Map<ID, List<GA_External_Appeal__c>> extnlAppMap = new Map <ID, List<GA_External_Appeal__c>>();
            for(GA_External_Appeal__c extnlApp :[select id,name,GA_NHR_End_Date__c,GA_Group_Segment_Id__c from GA_External_Appeal__c where GA_Group_Segment_Id__c IN :gsIds AND (GA_NHR_End_Date__c =null OR GA_NHR_End_Date__c>=Today) limit 2000])
           if(extnlAppMap.containskey(extnlApp.GA_Group_Segment_Id__c))
            {
                extnlAppMap.get(extnlApp.GA_Group_Segment_Id__c).add(extnlApp);
                
                
            }
            else
            {
                extnlAppMap.put(extnlApp.GA_Group_Segment_Id__c, new List<GA_External_Appeal__c>{extnlApp});
                
            }
        try
        {
            List <GA_External_Appeal__c> updtExtnlAppList = new List <GA_External_Appeal__c>();
            //Capturing Ids of records
            for(GA_Plan_Package__c planPkgNew :planPkgList){                
                if(planPkgNew.Id != null){
                    if(plnPkgOldMap !=null)
                    {
                        GA_Plan_Package__c plnPkgOld=plnPkgOldMap.get(planPkgNew.Id);
                        if(plnPkgOld.GA_ACTIVE_IND__c != planPkgNew.GA_ACTIVE_IND__c && planPkgNew.GA_ACTIVE_IND__c !=null && planPkgNew.GA_ACTIVE_IND__c.equalsIgnoreCase(ACTIVE)){
                            if(planPkgNew.GA_Group_Segment__c != null){
                                reactivatePreviousEARecord(planPkgNew.GA_Group_Segment__c,updtExtnlAppList,extnlAppMap);
                            }      }              
                    }                
                }       
            }if(updtExtnlAppList.size()>0)
            {
                database.update(updtExtnlAppList);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, REACTIVATEPREVIOUSEARECORDNASCO);
        }        
    }
    
    /*******************************************************************************************************************************
@Description  :   reactivatePreviousEARecord 
@Name         :   reactivatePreviousEARecord
@Param        :   String gsId
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 
    public static void reactivatePreviousEARecord(String gsId,List <GA_External_Appeal__c> updtExistingApplList, Map<ID, List<GA_External_Appeal__c>> extnlAppMap )
    {
        try
        {
            //List <GA_External_Appeal__c> existingAppealRecList = [select id,GA_NHR_Eff_Date__c,GA_NHR_End_Date__c,GA_Package_Number__c,GA_NHR_Status__c,GA_External_Appeal_Type__c from GA_External_Appeal__c where GA_Group_Segment_Id__c =: gsId AND (GA_NHR_End_Date__c =null OR GA_NHR_End_Date__c>=Today) order by createdDate desc limit 1];
            if(extnlAppMap.containskey(gsId))
            {
                for(GA_External_Appeal__c extnlApp : extnlAppMap.get(gsId))
                {
                    extnlApp.GA_NHR_End_Date__c = null;
                    updtExistingApplList.add(extnlApp);                        
                }            
            } 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, REACTIVATEPREVIOUSEARECORD);
        }        
    }    
}