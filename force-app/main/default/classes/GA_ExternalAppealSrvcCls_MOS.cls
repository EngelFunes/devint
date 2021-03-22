/*******************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_ExternalAppealSrvcCls_MOS 
@CreatedDate: 01 - July 2019 
@Description: GA_ExternalAppealSrvcCls_MOS class is for creating and updating External Appeal records on Group Segment of Type MOS.
@version : 1.0  
********************************************************************************************************************************/

public class GA_ExternalAppealSrvcCls_MOS {
    
    Public static boolean isExecuting=false;
    public Static final string clsName  = 'GA_ExternalAppealSrvcCls_MOS';
    public Static final string mtdcreateExternalAppealRecord  = 'createExternalAppealRecordMOS';
    public static final String methodNme  ='updateExternalAppealNHRDate';
    public static final String methodupdtMOSExtrlAppRcrd  ='updtMOSExtrlAppRcrd';
    public Static Final string bcbsmCarrier='BCBSM';
    public Static Final string nascoNtwrk='NASCO';
    public Static Final string mosNtwrk='MOS';
    public Static Final string selfFundASC='Self-Funded (ASC)';
    public Static Final string asc2549='ASC 25-49';
    public Static Final string ascNtnlITS='ASC National ITS';
    public static final String noClstrCod  =System.Label.GA_RatingType_No_Cluster_Code;
    public static final String seeSysAdm  =System.Label.GA_RatingType_See_System_Admin;
    public static final String accTypIBU  ='IBU';
    public static final String rtngTypIB  ='IB';
    public static final String sysOfRec  ='SMART';
    public static final String noRntgTyp  =System.Label.GA_RatingType_No_Rating_Type;
    public static final String Active  = 'Active';
    
    /*******************************************************************************************************************************
@Description  :   createExternalAppealRecordMOS 
@Name         :   createExternalAppealRecordMOS
@Param        :   list<GA_Plan_Package__c> planPkgList soldPrdtList
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 
    
    public static void createExternalAppealRecordMOS(list<Asset> soldPrdtList)
    {
        try
        {                    
            Map<String,String> soldProductMap = new Map<String,String>();
            Map<String,String> plnPkgGSMap = new Map<String,String>();
            Map<String,String> pkgNumberMap = new Map<String,String>();
            
            Set<id> planPkgIds = new Set<id>();
            //Capturing Ids of records
            for(Asset soldProduct :soldPrdtList){
                if(soldProduct.GA_Plan_Package_Id__c != null){
                    planPkgIds.add(soldProduct.GA_Plan_Package_Id__c);
                    soldProductMap.put(soldProduct.Id,soldProduct.GA_Form_Numbers__c);                  
                }                
            }            
            List<GA_Plan_Package__c> planPkgList = ([Select Id,  GA_Group_Segment__c,GA_Plan_Package__c from GA_Plan_Package__c where Id in :planPkgIds]);
            Set<id> gsIds = new Set<id>();
            //Capturing Ids of records
            for(GA_Plan_Package__c planPkgNew :planPkgList){
                if(planPkgNew.GA_Group_Segment__c  != null){
                    gsIds.add(planPkgNew.GA_Group_Segment__c);
                    plnPkgGSMap.put(planPkgNew.Id,planPkgNew.GA_Group_Segment__c);
                    pkgNumberMap.put(planPkgNew.Id,planPkgNew.GA_Plan_Package__c);
                }                
            }
            
            Map<ID,GA_Group_Segment__c> gsDetailsMap = new Map<ID,GA_Group_Segment__c>();            
            if(!gsIds.isEmpty())
            {
                gsDetailsMap = new Map<ID,GA_Group_Segment__c>([Select Id,GA_Account__c,GA_Account__r.CID__c,GA_MTV_Group_Division__c,GA_MTV_Group__c,GA_ERISA_Exempt__c,GA_Rating_Type__c,GA_Regional_Office_Code__c,GA_Benefit_Effective_Date__c from GA_Group_Segment__c 
                                                                where Id in :gsIds and Network__c ='MOS' and GA_Carrier__c= 'BCBSM' and Status__c!='Canceled']);
            }
            Map<Id,List<GA_External_Appeal__c>> extAppealExistsForGSMap = new Map<Id,List<GA_External_Appeal__c>>();
            List<GA_External_Appeal__c> extAppList = new List<GA_External_Appeal__c>();
                
            Map<ID,GA_External_Appeal__c> extAppDetailsMap = new Map<ID,GA_External_Appeal__c>();
            List <GA_External_Appeal__c> gsExtAppealList = [select id,GA_NHR_Eff_Date__c,GA_NHR_End_Date__c,GA_Package_Number__c,GA_NHR_Status__c,GA_External_Appeal_Type__c,GA_Group_Segment_Id__c from GA_External_Appeal__c where GA_Group_Segment_Id__c in :gsIds AND (GA_NHR_End_Date__c = null OR GA_NHR_End_Date__c>=Today) order by createdDate desc];
            system.debug('GS EXTAPPEAL LIST ' +gsExtAppealList);
            if(gsExtAppealList.size()>0)
            {
                for(GA_External_Appeal__c extnlApp : gsExtAppealList)
                {
                    if(extAppDetailsMap.get(extnlApp.GA_Group_Segment_Id__c) == null)
                    {
                        extAppDetailsMap.put(extnlApp.GA_Group_Segment_Id__c,extnlApp);
                        extAppList.add(extnlApp);
                        extAppealExistsForGSMap.put(extnlApp.GA_Group_Segment_Id__c,extAppList);
                    }                    
                }
                system.debug('EXTAPP DETAIL MAP '+extAppDetailsMap);
            }
            
            List <GA_External_Appeal__c> extAppealList = new List <GA_External_Appeal__c>();
            List <GA_External_Appeal__c> UpdtExistingApplList = new List <GA_External_Appeal__c> (); 
            GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
            system.debug('planPkgList '+planPkgList);   
            
            for(Asset soldProduct :soldPrdtList){
                if(soldProduct.GA_Plan_Package_Id__c != null){
                    String gsRecord = plnPkgGSMap.get(soldProduct.GA_Plan_Package_Id__c);
                    if(gsDetailsMap.get(gsRecord) != null){
                        system.debug('GSID '+gsDetailsMap.get(gsRecord));
                        //For Updating Existing Appeal Records
                 
                        GA_External_Appeal__c existingAppealRecList = extAppDetailsMap.get(gsRecord);
                        //List <GA_External_Appeal__c> existingAppealRecList = [select id,GA_NHR_Eff_Date__c,GA_NHR_End_Date__c,GA_Package_Number__c,GA_NHR_Status__c,GA_External_Appeal_Type__c from GA_External_Appeal__c where GA_Group_Segment_Id__c =: gsRecord AND (GA_NHR_End_Date__c = null OR GA_NHR_End_Date__c>=Today) order by createdDate desc limit 1];
                        
                        String formNumber = soldProductMap.get(soldProduct.Id);
                        system.debug('Form Number '+formNumber);
                        
                        String packageNumber = pkgNumberMap.get(soldProduct.GA_Plan_Package_Id__c);
                        system.debug('Package Number '+packageNumber); 
                        
                        String nhrStatus = GA_ExternalAppealSrvcCls_NASCO.getNHRStatusType(packageNumber,formNumber, gsRecord,gsDetailsMap.get(gsRecord).GA_Account__c,'MOS',gsDetailsMap.get(gsRecord).GA_Account__r.CID__c,extAppealExistsForGSMap);
                        
                        String externalAppealType = GA_ExternalAppealSrvcCls_NASCO.getExternalAppealType(nhrStatus,gsDetailsMap.get(gsRecord).GA_Rating_Type__c, gsDetailsMap.get(gsRecord).GA_Regional_Office_Code__c, gsDetailsMap.get(gsRecord).GA_ERISA_Exempt__c);
                        
                        
                        if(existingAppealRecList !=null)
                        {
                            String prevExtAppType = existingAppealRecList.GA_External_Appeal_Type__c;
                            if(prevExtAppType == null)
                            {
                                prevExtAppType= '';
                            }                           
                            
                            if(existingAppealRecList.GA_NHR_Status__c != nhrStatus || prevExtAppType != externalAppealType) 
                            {
                                newExternalAppeal = new GA_External_Appeal__c();
                                newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
                                newExternalAppeal.GA_Group_Segment_Id__c = gsRecord; 
                                newExternalAppeal.GA_NHR_Eff_Date__c =  gsDetailsMap.get(gsRecord).GA_Benefit_Effective_Date__c;          
                                newExternalAppeal.GA_NHR_Status__c=nhrStatus;
                                newExternalAppeal.GA_External_Appeal_Type__c = externalAppealType;
                                extAppealList.add(newExternalAppeal);
                                
                                if(gsDetailsMap.get(gsRecord).GA_Benefit_Effective_Date__c != null)
                                {
                                    existingAppealRecList.GA_NHR_End_Date__c = gsDetailsMap.get(gsRecord).GA_Benefit_Effective_Date__c-1;
                                }
                                else
                                {
                                    existingAppealRecList.GA_NHR_End_Date__c = existingAppealRecList.GA_NHR_Eff_Date__c;
                                }
                                UpdtExistingApplList.add(existingAppealRecList);   
                            }                                            
                        } else
                        {
                            newExternalAppeal = new GA_External_Appeal__c();
                            newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
                            newExternalAppeal.GA_Group_Segment_Id__c = gsRecord; 
                            newExternalAppeal.GA_NHR_Eff_Date__c =  gsDetailsMap.get(gsRecord).GA_Benefit_Effective_Date__c;          
                            newExternalAppeal.GA_NHR_Status__c=nhrStatus;
                            newExternalAppeal.GA_External_Appeal_Type__c = externalAppealType;
                            extAppealList.add(newExternalAppeal);
                        }
                    }
                }                
            }
            
            //inserting ExternalAppeal Records
            if(extAppealList.size()>0)
            {
                System.debug('Inserting MOS External APpeal');
                database.insert(extAppealList);
            }
            if(UpdtExistingApplList.size()>0)
            {
                //create a map that will hold the values of the list 
                map<id,GA_External_Appeal__c> existingEAMap = new map<id,GA_External_Appeal__c>();
                
                //put all the values from the list to map. 
                existingEAMap.putall(UpdtExistingApplList);
                if(existingEAMap.size()>0){                    
                    System.debug('Updating MOS External APpeal');
                    database.update(existingEAMap.values());
                }
            }
        }
        catch(exception e)
        {
            System.debug('MOS External Appeal Exceptione '+e);
            GA_LogExceptionCls.LogExcp(e, clsName, mtdcreateExternalAppealRecord);
        }
    }
    
    /**
@Description: updateExternalAppealNHRDate() method
@Name : updateExternalAppealNHRDate
@Param : list<GA_Group_Segment__c> gsLst,map<id,GA_Group_Segment__c> gsoldMap
@Return : void
@throws Exception : N/A;
*/        
    public static void updateExternalAppealNHRDate(list<GA_Group_Segment__c> gsLst,map<id,GA_Group_Segment__c> gsoldMap){
        try{
            
            GA_Group_Segment__c grpSgmntOld;
            Set<id> gsIds = new Set<id>();
            
            for(GA_Group_Segment__c gs :gsLst){
                if(gsoldMap!=null){
                    //gs.GA_Is_Mass_Updating__c = true;
                    grpSgmntOld=gsoldMap.get(gs.Id);                    
                    if(gs.GA_Risk_Cell__c != grpSgmntOld.GA_Risk_Cell__c || gs.GA_Current_Cluster_Code__c!= grpSgmntOld.GA_Current_Cluster_Code__c || gs.GA_SIC_Code__c != grpSgmntOld.GA_SIC_Code__c){
                        gsIds.add(gs.Id);
                    }              
                }
            } 
            Map<ID,GA_Group_Segment__c> gsDetailsMap = new Map<ID,GA_Group_Segment__c>();            
            if(!gsIds.isEmpty())
            {
                gsDetailsMap = new Map<ID,GA_Group_Segment__c>([Select Id,Network__c,GA_Account__c,GA_Account__r.CID__c,GA_MTV_Group_Division__c,GA_MTV_Group__c,GA_Rating_Type__c,GA_Regional_Office_Code__c,GA_ERISA_Exempt__c from GA_Group_Segment__c 
                                                                where Id in :gsIds and GA_Carrier__c= 'BCBSM' and Status__c!='Canceled']);
            }
            system.debug('OnChange Method');
            Map<Id,List<GA_External_Appeal__c>> extAppealExistsForGSMap = new Map<Id,List<GA_External_Appeal__c>>();
            List<GA_External_Appeal__c> extAppList = new List<GA_External_Appeal__c>();
                
            List <GA_External_Appeal__c> gsExtAppealList = [select id,GA_NHR_Eff_Date__c,GA_NHR_End_Date__c,GA_Package_Number__c,GA_NHR_Status__c,GA_External_Appeal_Type__c,GA_Group_Segment_Id__c from GA_External_Appeal__c where GA_Group_Segment_Id__c in :gsIds AND (GA_NHR_End_Date__c = null OR GA_NHR_End_Date__c>=Today) order by createdDate desc];
            system.debug('GS EXTAPPEAL LIST ' +gsExtAppealList);
            if(gsExtAppealList.size()>0)
            {
                for(GA_External_Appeal__c extnlApp : gsExtAppealList)
                {
                    if(extAppealExistsForGSMap.get(extnlApp.GA_Group_Segment_Id__c) == null)
                    {
                        extAppList.add(extnlApp);
                        extAppealExistsForGSMap.put(extnlApp.GA_Group_Segment_Id__c,extAppList);
                    }                    
                }
          
            }

            List <GA_External_Appeal__c> extAppealList = new List <GA_External_Appeal__c>();
            List <GA_External_Appeal__c> UpdtExistingApplList = new List <GA_External_Appeal__c> (); 
            GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
            for(GA_Group_Segment__c gs : gsLst){
                system.debug('OnChange MethodgsLst '+gsLst);                
                if(gsDetailsMap.get(gs.Id) != null ){
                    //For Updating Existing Appeal Records
                    List <GA_External_Appeal__c> existingAppealRecList = [select id,GA_NHR_Eff_Date__c,GA_NHR_End_Date__c,GA_Package_Number__c,GA_NHR_Status__c,GA_External_Appeal_Type__c from GA_External_Appeal__c where GA_Group_Segment_Id__c =: gs.Id AND (GA_NHR_End_Date__c = null OR GA_NHR_End_Date__c>=Today) order by createdDate desc limit 1];
                    
                    if(existingAppealRecList.size()>0)
                    {
                        system.debug('OnChange existingAppealRecList '+existingAppealRecList); 
                        if(gsDetailsMap.get(gs.Id).Network__c.equals('NASCO'))
                        {                    
                            String nhrStatus = GA_ExternalAppealSrvcCls_NASCO.getNHRStatusType(existingAppealRecList[0].GA_Package_Number__c, gsDetailsMap.get(gs.Id).GA_MTV_Group__c, gs.Id,gsDetailsMap.get(gs.Id).GA_Account__c,'NASCO',gsDetailsMap.get(gs.Id).GA_Account__r.CID__c,extAppealExistsForGSMap);
                            System.debug('nhrSTatusMethod>>> '+nhrStatus);    
                            
                            String ratingType= getRatingType(gs);   
                            System.debug('RatingType NASCO >> '+ratingType);  
                            String externalAppealType = GA_ExternalAppealSrvcCls_NASCO.getExternalAppealType(nhrStatus,ratingType, gsDetailsMap.get(gs.Id).GA_Regional_Office_Code__c, gsDetailsMap.get(gs.Id).GA_ERISA_Exempt__c);
                            System.debug('externalAppealType>>> '+externalAppealType);
                            
                            String prevExtAppType = existingAppealRecList[0].GA_External_Appeal_Type__c;
                            if(prevExtAppType == null)
                            {
                                prevExtAppType= '';
                            }                        
                            if(existingAppealRecList[0].GA_NHR_Status__c != nhrStatus || prevExtAppType != externalAppealType) 
                            {
                                newExternalAppeal = new GA_External_Appeal__c();
                                newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
                                newExternalAppeal.GA_Group_Segment_Id__c = gs.Id; 
                                newExternalAppeal.GA_NHR_Eff_Date__c =  existingAppealRecList[0].GA_NHR_Eff_Date__c;
                                newExternalAppeal.GA_NHR_End_Date__c = existingAppealRecList[0].GA_NHR_End_Date__c;
                                newExternalAppeal.GA_Package_Number__c = existingAppealRecList[0].GA_Package_Number__c;
                                newExternalAppeal.GA_Section_Number__c =  gsDetailsMap.get(gs.Id).GA_MTV_Group_Division__c; 
                                newExternalAppeal.GA_NASCO_Group_Number__c = gsDetailsMap.get(gs.Id).GA_MTV_Group__c;               
                                newExternalAppeal.GA_NHR_Status__c=nhrStatus;
                                newExternalAppeal.GA_External_Appeal_Type__c = externalAppealType;                    
                                
                                extAppealList.add(newExternalAppeal);  
                                system.debug('extAppealList ' +extAppealList);
                                
                                existingAppealRecList[0].GA_NHR_End_Date__c = System.today().addDays(-1);
                                UpdtExistingApplList.add(existingAppealRecList[0]);
                                system.debug('UpdtExistingApplList ' +UpdtExistingApplList);
                            }                    
                        }  //FOR MOS
                        if(gsDetailsMap.get(gs.Id).Network__c.equals('MOS'))
                        {
                            String nhrStatus = existingAppealRecList[0].GA_NHR_Status__c;
                            String ratingType= getRatingType(gs);   
                            System.debug('RatingType MOS >> '+ratingType); 
                            String externalAppealType = GA_ExternalAppealSrvcCls_NASCO.getExternalAppealType(nhrStatus,ratingType, gsDetailsMap.get(gs.Id).GA_Regional_Office_Code__c, gsDetailsMap.get(gs.Id).GA_ERISA_Exempt__c);
                            System.debug('externalAppealType MOS>>> '+externalAppealType);
                            String prevExtAppType = existingAppealRecList[0].GA_External_Appeal_Type__c;
                            if(prevExtAppType == null)
                            {
                                prevExtAppType= '';
                            } 
                            if(prevExtAppType != externalAppealType) 
                            {
                                newExternalAppeal = new GA_External_Appeal__c();
                                newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
                                newExternalAppeal.GA_Group_Segment_Id__c = gs.Id; 
                                newExternalAppeal.GA_NHR_Eff_Date__c =  existingAppealRecList[0].GA_NHR_Eff_Date__c;
                                newExternalAppeal.GA_NHR_End_Date__c = existingAppealRecList[0].GA_NHR_End_Date__c;
                                newExternalAppeal.GA_Package_Number__c = existingAppealRecList[0].GA_Package_Number__c;                                
                                newExternalAppeal.GA_NHR_Status__c=nhrStatus;
                                newExternalAppeal.GA_External_Appeal_Type__c = externalAppealType;                    
                                
                                extAppealList.add(newExternalAppeal);  
                                
                                existingAppealRecList[0].GA_NHR_End_Date__c = System.today().addDays(-1);
                                UpdtExistingApplList.add(existingAppealRecList[0]);
                            }
                        }
                    }                    
                }                     
            }
            //inserting ExternalAppeal Records
            if(extAppealList.size()>0)
            {
                database.insert(extAppealList);
            }
            if(UpdtExistingApplList.size()>0)
            {
                //database.update(UpdtExistingApplList);
                // //create a map that will hold the values of the list 
                map<id,GA_External_Appeal__c> existingEAMap = new map<id,GA_External_Appeal__c>();
                
                //put all the values from the list to map. 
                existingEAMap.putall(UpdtExistingApplList);
                if(existingEAMap.size()>0){                    
                    System.debug('Updating MOS External APpeal');
                    database.update(existingEAMap.values());
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
        }
    }
    
    public static String getGrandfatherRetireeOptRulesforMOS(String formString)
    {
        String nhrStatus = '';       
        
        if(formString !=null){
            List<String> formStringNumber = new  List<String>();
            if(formString.contains(','))
            {
                formStringNumber = formString.split(',');
            }
            else
            {
                formStringNumber.add(formString);
            }
            system.debug('FORM STRING ' +formStringNumber);
            list<GrandfatherRetireeOptOutRule_MOS__mdt> nhrStatusInfo = [select NHR_Status__c,Form_String__c from GrandfatherRetireeOptOutRule_MOS__mdt 
                                                                         where Form_String__c in :formStringNumber limit 1];
            system.debug('nhrStatusInfo '+nhrStatusInfo);
            if(nhrStatusInfo != null && nhrStatusInfo.size()>0)
            {
                nhrStatus = nhrStatusInfo[0].NHR_Status__c;             
                
            }
        }          
        return nhrStatus;
    }
    
    /*********************************************************************************************************************************************
@Description: updtMOSExtrlAppRcrd() method 
@Name : updtMOSExtrlAppRcrd
@Param :list<GA_Group_Segment__c> gsList,boolean oldAccErisaExmptVal,boolean newAccErisaExmptVal
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    
    
    public static void updtMOSExtrlAppRcrd (list<GA_Group_Segment__c> gsList,boolean oldAccErisaExmptVal,boolean newAccErisaExmptVal){
        try{
            Set<Id> gsIds = New Set<Id>();   
            boolean isChngPA250 = False;
            List <GA_External_Appeal__c> UpdtoldExtApplList = new List <GA_External_Appeal__c> ();   
            for(GA_Group_Segment__c gs : gsList)
            {
                if(gs.id <> null){
                    gsIds.add(gs.Id); 
                }
            }            
            System.debug('ERISA CHANGE updtMOSExtrlAppRcrd');
            Map<ID,GA_Group_Segment__c> gsDetailsMap = new Map<ID,GA_Group_Segment__c>();            
            if(!gsIds.isEmpty())
            {
                gsDetailsMap = new Map<ID,GA_Group_Segment__c>([Select Id,Network__c,GA_Account__c,GA_MTV_Group_Division__c,GA_MTV_Group__c,GA_Rating_Type__c,GA_Regional_Office_Code__c from GA_Group_Segment__c 
                                                                where Id in :gsIds and GA_Carrier__c= 'BCBSM' and Status__c!='Canceled' limit 100]);
            }
            
            List <GA_External_Appeal__c> extAppealList = new List <GA_External_Appeal__c>();
            List <GA_External_Appeal__c> UpdtExistingApplList = new List <GA_External_Appeal__c> (); 
            GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
            for(GA_Group_Segment__c gs : gsList){                
                if(gsDetailsMap.get(gs.Id) != null ){
                    //For Updating Existing Appeal Records
                    List <GA_External_Appeal__c> existingAppealRecList = [select id,GA_NHR_Eff_Date__c,GA_NHR_End_Date__c,GA_Package_Number__c,GA_NHR_Status__c,GA_External_Appeal_Type__c from GA_External_Appeal__c where GA_Group_Segment_Id__c =: gs.Id AND (GA_NHR_End_Date__c =null OR GA_NHR_End_Date__c>=Today) order by createdDate desc limit 1];
                    System.debug('ERISA CHANGE existingAppealRecList '+existingAppealRecList);
                    system.debug('Rating Type '+gs.GA_Rating_Type__c);
                    if((oldAccErisaExmptVal == True)&&(newAccErisaExmptVal == False ))
                    {
                        isChngPA250 = True;
                    }
                    if((oldAccErisaExmptVal == False)&&(newAccErisaExmptVal == True ))
                    {
                        isChngPA250 = True;
                    }
                    isChngPA250 = True;
                    if(existingAppealRecList.size()>0 && isChngPA250 == True)
                    {                   
                        //FOR MOS
                        System.debug('ERISA CHANGE MOS');
                        if(gsDetailsMap.get(gs.Id).Network__c.equals('MOS'))
                        {
                            String nhrStatus = existingAppealRecList[0].GA_NHR_Status__c;
                            String externalAppealType = GA_ExternalAppealSrvcCls_NASCO.getExternalAppealType(nhrStatus,gsDetailsMap.get(gs.Id).GA_Rating_Type__c, gsDetailsMap.get(gs.Id).GA_Regional_Office_Code__c, newAccErisaExmptVal);
                            String prevExtAppType = existingAppealRecList[0].GA_External_Appeal_Type__c;
                            if(prevExtAppType == null)
                            {
                                prevExtAppType= '';
                            } 
                            if(prevExtAppType != externalAppealType || existingAppealRecList[0].GA_NHR_Eff_Date__c != system.today()) 
                            {
                                newExternalAppeal = new GA_External_Appeal__c();
                                newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
                                newExternalAppeal.GA_Group_Segment_Id__c = gs.Id; 
                                newExternalAppeal.GA_NHR_Eff_Date__c =  system.today();
                                newExternalAppeal.GA_NHR_End_Date__c = existingAppealRecList[0].GA_NHR_End_Date__c;                                                               
                                newExternalAppeal.GA_NHR_Status__c=nhrStatus;
                                newExternalAppeal.GA_External_Appeal_Type__c = externalAppealType;                                 
                                extAppealList.add(newExternalAppeal); 
                                
                                existingAppealRecList[0].GA_NHR_End_Date__c = System.today().addDays(-1);
                                UpdtExistingApplList.add(existingAppealRecList[0]);
                            }
                        }
                    }                    
                }                     
            }
            //inserting ExternalAppeal Records
            if(extAppealList.size()>0)
            {
                database.insert(extAppealList);
            }
            if(UpdtExistingApplList.size()>0)
            {
                //database.update(UpdtExistingApplList);
                // //create a map that will hold the values of the list 
                map<id,GA_External_Appeal__c> existingEAMap = new map<id,GA_External_Appeal__c>();
                
                //put all the values from the list to map. 
                existingEAMap.putall(UpdtExistingApplList);
                if(existingEAMap.size()>0){                    
                    System.debug('Updating MOS External APpeal');
                    database.update(existingEAMap.values());
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, methodupdtMOSExtrlAppRcrd); 
        }  
    }
    
    public static String getRatingType(GA_Group_Segment__c gs)
    {
        String ratingType ='';
        if(gs.GA_Account_Type__c==accTypIBU){
            ratingType=rtngTypIB;
        }else if(gs.GA_System_of_Record__c == sysOfRec && gs.GA_Smart_Rating_Type__c !=null){
            ratingType = gs.GA_Smart_Rating_Type__c;
        }else if(gs.GA_System_of_Record__c == sysOfRec && gs.GA_Smart_Rating_Type__c ==null){
            ratingType =noRntgTyp;
        }else if(gs.GA_Current_Cluster_Code__c == null){
            ratingType=noClstrCod;
        }else{
            List<GA_GS_Rating_Type_Config__mdt> ratngType = [select GA_Rating_Type__c,GA_Rating_Method__c,GA_Start_Cluster_Code__c, 
                                                             GA_End_Cluster_Code__c,GA_Sort_Order__c
                                                             from GA_GS_Rating_Type_Config__mdt where 
                                                             //GA_Start_Cluster_Code__c<=:gs.GA_Cluster_Code_Formula__c AND 
                                                             //GA_End_Cluster_Code__c>=:gs.GA_Cluster_Code_Formula__c 
                                                             GA_Start_Cluster_Code__c<=:gs.GA_Current_Cluster_Code__c AND 
                                                             GA_End_Cluster_Code__c>=:gs.GA_Current_Cluster_Code__c 
                                                             ORDER BY GA_Sort_Order__c DESC Limit 50];
            if(ratngType.size()>0){
                for(GA_GS_Rating_Type_Config__mdt rtngtp:ratngType){
                    if(rtngtp.GA_Rating_Method__c == null){
                        ratingType=rtngtp.GA_Rating_Type__c;
                        
                    }
                    else if(rtngtp.GA_Rating_Method__c == gs.GA_Rating_Method__c){
                        ratingType=rtngtp.GA_Rating_Type__c;
                    }
                }
            }
            else{
                ratingType = seeSysAdm;
            }
        }
        
        return ratingType;
    }
}