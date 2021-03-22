/*******************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_ExternalAppealSrvcCls_NASCO 
@CreatedDate: 28 - June 2019 
@Description: GA_ExternalAppealSrvcCls_NASCO class is for creating and updating External Appeal records on Group Segment of Type NASCO.
@version : 1.0  
********************************************************************************************************************************/

public class GA_ExternalAppealSrvcCls_NASCO {
    
    public static boolean isExecuting=false;
    public Static final string clsName  = 'GA_ExternalAppealSrvcCls_NASCO';
    public Static final string metdcrtExtrlAppRcrdNASCO  = 'crtExtrlAppRcrdNASCO';
    public Static final string mtdcreateExternalAppealRecordForNasco  = 'createExternalAppealRecordForNasco';
    public Static final string mtdupdtNHREndDtOnExtnlApl  = 'updtNHREndDtOnExtnlApl';
    public Static final string mtdgetNHRStatusType  = 'getNHRStatusType';
    public static final integer occurence = 0;
    public static final String  excpSvrty='ERROR';
    public Static Final string bcbsmCarrier='BCBSM';
    public Static Final string nascoNtwrk='NASCO';
    
    
        /*******************************************************************************************************************************
@Description  :   createExternalAppealRecordForNasco 
@Name         :   createExternalAppealRecordForNasco
@Param        :   list<GA_Plan_Package__c> planPkgList
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 
    
    public static void createExternalAppealRecordForNasco(list<GA_Plan_Package__c> planPkgList)
    {
        try
        {  
            Set<id> gsIds = new Set<id>();
            //Capturing Ids of records
            for(GA_Plan_Package__c planPkgNew :planPkgList){
                if(planPkgNew.GA_Group_Segment__c != null){
                    gsIds.add(planPkgNew.GA_Group_Segment__c);
                }                
            }
            
            Map<ID,GA_Group_Segment__c> gsDetailsMap = new Map<ID,GA_Group_Segment__c>();
            if(!gsIds.isEmpty())
            {
                gsDetailsMap = new Map<ID,GA_Group_Segment__c>([Select Id,GA_Account__c,GA_Account__r.CID__c,GA_MTV_Group_Division__c,GA_MTV_Group__c,GA_ERISA_Exempt__c,GA_Rating_Type__c,GA_Regional_Office_Code__c from GA_Group_Segment__c 
                                                                where Id in :gsIds and Network__c ='NASCO' and GA_Carrier__c= 'BCBSM' and Status__c!='Canceled']);
            }
            system.debug('GS Detail Map '+gsDetailsMap);
            Map<ID,GA_External_Appeal__c> extAppDetailsMap = new Map<ID,GA_External_Appeal__c>();
            List <GA_External_Appeal__c> gsExtAppealList = [select id,GA_NHR_Eff_Date__c,GA_Group_Segment_Id__c from GA_External_Appeal__c where GA_Group_Segment_Id__c in :gsIds AND (GA_NHR_End_Date__c =null OR GA_NHR_End_Date__c>=Today) order by createdDate desc];
            system.debug('GS EXTAPPEAL LIST ' +gsExtAppealList);
            if(gsExtAppealList.size()>0)
            {
                for(GA_External_Appeal__c extnlApp : gsExtAppealList)
                {
                    if(extAppDetailsMap.get(extnlApp.GA_Group_Segment_Id__c) == null)
                    {
                        extAppDetailsMap.put(extnlApp.GA_Group_Segment_Id__c,extnlApp);
                    }                    
                }
                system.debug('EXTAPP DETAIL MAP '+extAppDetailsMap);
            }               
            Map<Id,List<GA_External_Appeal__c>> extAppealExistsForGSMap = new Map<Id,List<GA_External_Appeal__c>>();
            for(GA_Group_Segment__c gs : gsDetailsMap.values())
            {
                String accountId = gs.GA_Account__c;
                Set<id> gpSegIds = getGroupSegmentsAssociatedWithAccount(accountId);
                List<GA_External_Appeal__c> extAppealExists = [Select Id,GA_NHR_Status__c,GA_Package_Number__c,GA_NASCO_Group_Number__c from GA_External_Appeal__c where GA_Group_Segment_Id__c in: gpSegIds and GA_NHR_End_Date__c>=Today order by createddate desc]; 
                if(extAppealExists !=null && extAppealExists.size() > 0){
                    extAppealExistsForGSMap.put(accountId, extAppealExists);
                } 
            }
            system.debug('EXTAppealExistsForGSMap '+extAppealExistsForGSMap);
            
            List <GA_External_Appeal__c> extAppealList = new List <GA_External_Appeal__c>();
            List <GA_External_Appeal__c> UpdtExistingApplList = new List <GA_External_Appeal__c> (); 
            GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
            
            for(GA_Plan_Package__c planPkgNew :planPkgList){  
       
                if(gsDetailsMap.get(planPkgNew.GA_Group_Segment__c) != null){                    
                    GA_External_Appeal__c extnlApp = extAppDetailsMap.get(planPkgNew.GA_Group_Segment__c);
                    if(extnlApp != null)
                    {
                        if(planPkgNew.GA_Coverage_Begin_Date__c !=null && (extnlApp.GA_NHR_Eff_Date__c<=planPkgNew.GA_Coverage_Begin_Date__c-1))
                        {
                            extnlApp.GA_NHR_End_Date__c = planPkgNew.GA_Coverage_Begin_Date__c-1;
                        }
                        else
                        {
                            extnlApp.GA_NHR_End_Date__c = extnlApp.GA_NHR_Eff_Date__c;
                        }
                        
                        UpdtExistingApplList.add(extnlApp);
                    }
                    else
                    {
                        newExternalAppeal = new GA_External_Appeal__c();
                        newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
                        newExternalAppeal.GA_Group_Segment_Id__c = planPkgNew.GA_Group_Segment__c; 
                        newExternalAppeal.GA_NHR_Eff_Date__c =  planPkgNew.GA_Coverage_Begin_Date__c;
                        //newExternalAppeal.GA_NHR_End_Date__c = planPkgNew.GA_Coverage_End_Date__c;
                        newExternalAppeal.GA_Package_Number__c = planPkgNew.GA_Plan_Package__c;
                        newExternalAppeal.GA_Section_Number__c = gsDetailsMap.get(planPkgNew.GA_Group_Segment__c).GA_MTV_Group_Division__c;
                        newExternalAppeal.GA_NASCO_Group_Number__c = gsDetailsMap.get(planPkgNew.GA_Group_Segment__c).GA_MTV_Group__c;
                        
                        String nhrStatus = getNHRStatusType(planPkgNew.GA_Plan_Package__c, gsDetailsMap.get(planPkgNew.GA_Group_Segment__c).GA_MTV_Group__c, planPkgNew.GA_Group_Segment__c,gsDetailsMap.get(planPkgNew.GA_Group_Segment__c).GA_Account__c,'NASCO',gsDetailsMap.get(planPkgNew.GA_Group_Segment__c).GA_Account__r.CID__c,extAppealExistsForGSMap);
                        newExternalAppeal.GA_NHR_Status__c=nhrStatus;
                        
                        String externalAppealType = getExternalAppealType(nhrStatus,gsDetailsMap.get(planPkgNew.GA_Group_Segment__c).GA_Rating_Type__c, gsDetailsMap.get(planPkgNew.GA_Group_Segment__c).GA_Regional_Office_Code__c, gsDetailsMap.get(planPkgNew.GA_Group_Segment__c).GA_ERISA_Exempt__c);
                        newExternalAppeal.GA_External_Appeal_Type__c = externalAppealType;
                        
                        extAppealList.add(newExternalAppeal);
                    }
                }
            }
            //inserting ExternalAppeal Records
            if(extAppealList.size()>0)
            {
                database.insert(extAppealList);
            }
            if(UpdtExistingApplList.size()>0)
            { //create a map that will hold the values of the list 
                map<id,GA_External_Appeal__c> existingEAMap = new map<id,GA_External_Appeal__c>();
                
                //put all the values from the list to map. 
                existingEAMap.putall(UpdtExistingApplList);
                if(existingEAMap.size()>0){                    
                    System.debug('Updating MOS External APpeal');
                    database.update(existingEAMap.values());
                    //database.update(UpdtExistingApplList);
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, mtdcreateExternalAppealRecordForNasco);
        }
    }
    
    
/*******************************************************************************************************************************
@Description  :   getExternalAppealType 
@Name         :   getExternalAppealType
@Param        :   String nhrStatus,String ratingType,String regionalOfficeCode,boolean ErisaExempt
@Return       :   String externalAppealType
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 

    public static String getExternalAppealType(String nhrStatus,String ratingType,String regionalOfficeCode,boolean ErisaExempt)
    {
        String externalAppealType='';
         system.debug('STRING VALUES FROM THE TRIGGER '+nhrStatus+ratingType+regionalOfficeCode+ErisaExempt);     
        if(ratingType != null && ratingType.equals('IB'))
        {
            ratingType ='IB';
        }
        else if(ratingType != null && (ratingType.equals('Self-Funded (ASC)') || ratingType.equals('ASC 25-49') || ratingType.equals('ASC National ITS')))
        {
            ratingType ='ASC';
        }
        else
        {
            ratingType ='NON - ASC';
        }       
        
        if(regionalOfficeCode == null)
        {
            regionalOfficeCode = 'Any Value';
        }
        if(!regionalOfficeCode.equals('19') && !regionalOfficeCode.equals('02'))
        {
            regionalOfficeCode = 'Any Value';
        }
      
        system.debug('STRING VALUES AFETR THE TRIGGER '+nhrStatus+ratingType+regionalOfficeCode+ErisaExempt);
        list<GA_External_Appeal_Type__mdt> externalApplInfo = [select GA_External_Appeal_Type__c from GA_External_Appeal_Type__mdt 
                                                               where GA_Erisa_Exempt__c=:ErisaExempt and GA_NHR_Status__c=:nhrStatus 
                                                               and GA_Rating_Type__c=:ratingType and GA_Regional_Office_Code__c=:regionalOfficeCode limit 1];
        system.debug('GA_External_Appeal_Type__c '+ externalApplInfo);
        if(externalApplInfo != null && externalApplInfo.size()>0)
                {
                    externalAppealType = externalApplInfo[0].GA_External_Appeal_Type__c;                
                    
                }
        return externalAppealType;
    }
    
    /*******************************************************************************************************************************
@Description  :   getNHRStatusType 
@Name         :   getNHRStatusType
@Param        :   String packageNum,String nascoGroupNumber, String gsId
@Return       :   String NHRStatus
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 

    public static String getNHRStatusType(String packageNum,String nascoGroupNumber, String gsId,String accountId,String network,String cId,Map<Id,List<GA_External_Appeal__c>> extAppealExistsForGSMap)
    {
        String NHRStatus = '';
        try
        {
            NHRStatus = checkIfExternalAppealsExistsForGS(packageNum, nascoGroupNumber, gsId,network,accountId,extAppealExistsForGSMap);
            System.debug('NHRStatus1>> '+NHRStatus);
            if(NHRStatus.equals(''))
            {
                NHRStatus = getNHRFromCIDException(accountId, packageNum,cId);
                System.debug('NHRStatus2>> '+NHRStatus);
                if(NHRStatus.equals(''))
                {
                    if(network.equals('NASCO'))
                    {
                        NHRStatus =  getGrandfatherRetireeOptRulesforNASCO();
                    }
                    else
                    {
                        NHRStatus =  GA_ExternalAppealSrvcCls_MOS.getGrandfatherRetireeOptRulesforMOS(nascoGroupNumber);
                    }                    
                    System.debug('NHRStatus3>> '+NHRStatus);
                    if(NHRStatus.equals(''))
                    {
                        NHRStatus = 'Grandfather - No'; 
                    }
                }
            }
        } 
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, mtdgetNHRStatusType);
        }
        
        return NHRStatus;
    }
    
     /*******************************************************************************************************************************
@Description  :   checkIfExternalAppealsExistsForGS 
@Name         :   checkIfExternalAppealsExistsForGS
@Param        :   String packageNum,String nascoGroupNumber, String gsId
@Return       :   String NHRStatus
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 

    public static String checkIfExternalAppealsExistsForGS(String packageNum,String nascoGroupNumber, String gsId,String network,String accountId,Map<Id,List<GA_External_Appeal__c>> extAppealExistsForGSMap)
    {
        String NHRStatus = '';
       
        if(network.equals('NASCO'))
        {
            List<GA_External_Appeal__c> extAppealExists = extAppealExistsForGSMap.get(accountId);
            if(extAppealExists !=null && extAppealExists.size() > 0){
                for(integer i=0;i<extAppealExists.size();i++){
                    if(extAppealExists[i].GA_Package_Number__c.equals(packageNum) && extAppealExists[i].GA_NASCO_Group_Number__c.equals(nascoGroupNumber))
                    {
                        NHRStatus = extAppealExists[i].GA_NHR_Status__c;
                        break;
                    }
                }                
            }                        
        }else
        {
            List<GA_External_Appeal__c> extAppealExists = extAppealExistsForGSMap.get(gsId);
            //List<GA_External_Appeal__c> extAppealExists = [Select Id,GA_NHR_Status__c from GA_External_Appeal__c where GA_Group_Segment_Id__c =: gsId and (GA_NHR_End_Date__c =null OR GA_NHR_End_Date__c>=Today) order by createddate desc Limit 1]; 
            if(extAppealExists !=null && extAppealExists.size() > 0){
                NHRStatus = extAppealExists[0].GA_NHR_Status__c;
            }
        }
        
        return NHRStatus;        
    }
    
    public static Set<id> getGroupSegmentsAssociatedWithAccount(String accId)
    {
        List<GA_Group_Segment__c> gsRecList = [Select Id,GA_Account__c from GA_Group_Segment__c where GA_Account__c =: accId and Status__c!='Canceled' Limit 100]; 
        Set<id> gsIds = new Set<id>();
            //Capturing Ids of records
            for(GA_Group_Segment__c gpSegNew :gsRecList){
                if(gpSegNew.Id != null){
                    gsIds.add(gpSegNew.Id);
                }                
            }
        return gsIds;
    }
 
     /*******************************************************************************************************************************
@Description  :   getNHRFromCIDException 
@Name         :   getNHRFromCIDException
@Param        :   String accountId,String planPackageNumber
@Return       :   String NHRStatus
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 
   
    public static String getNHRFromCIDException(String accountId,String planPackageNumber,String cID)
    {
        String nhrStatus = '';
        //Account accRec = [Select Id,CID__c from Account where Id =: accountId Limit 1];
        //if(accRec != null)
        //{
            if(planPackageNumber == null)
            {
               planPackageNumber=''; 
            }  
            list<CID_Exceptions_Config__mdt> cidExceptionInfo = [select CID__c,NHR_Status__c,Operator__c,Plan_Package__c from CID_Exceptions_Config__mdt where CID__c =:cID and Plan_Package__c =:planPackageNumber LIMIT 1]; 
            system.debug('cidExceptionInfo '+cidExceptionInfo);
            if(cidExceptionInfo != null && cidExceptionInfo.size()>0)
            {
                nhrStatus = cidExceptionInfo[0].NHR_Status__c;
            }
            else
            {
                list<CID_Exceptions_Config__mdt> cidExceptionInfo1 = [select CID__c,NHR_Status__c,Operator__c,Plan_Package__c from CID_Exceptions_Config__mdt where CID__c =:cID and Plan_Package__c ='Any' LIMIT 1]; 
                system.debug('cidExceptionInfo1 '+cidExceptionInfo1);
                if(cidExceptionInfo1 != null&& cidExceptionInfo1.size()>0)
                {
                    nhrStatus = cidExceptionInfo1[0].NHR_Status__c;
                }
            }
        //}

        /*list<CID_Exceptions_Config__mdt> cidExceptionInfo = [select CID__c,NHR_Status__c,Operator__c,Plan_Package__c from CID_Exceptions_Config__mdt]; 
        system.debug('getNHRFromCIDException '+accountId+planPackageNumber); 
        if(cidExceptionInfo != null)
        {
            for(Integer i=0;i<cidExceptionInfo.size();i++)
            {
                List<Account> accDetail = [Select Id,CID__c from Account where Id =: accountId and CID__c =:cidExceptionInfo[i].CID__c Limit 1]; 
                if(accDetail != null && accDetail.size()>0)
                {                    
                    if(planPackageNumber.equals(cidExceptionInfo[i].Plan_Package__c))
                    {
                        nhrStatus = cidExceptionInfo[i].NHR_Status__c;
                        break;
                    }
                    else if(cidExceptionInfo[i].Plan_Package__c.equals('Any'))
                    {
                        nhrStatus = cidExceptionInfo[i].NHR_Status__c;  
                        break;
                    }                    
                }               
            }
        }*/

        /*List<Account> accDetail = [Select Id,CID__c from Account where Id =: accountId and CID__c in ('277864','172582','278557') Limit 1]; 
        if(accDetail != null && accDetail.size()>0)
        {
            String CID =accDetail[0].CID__c;
            if(CID.equals('277864') && planPackageNumber.equals('030'))
            {
                nhrStatus = 'Retiree Opt Out';
            }
            else
            {
                nhrStatus = 'Grandfather - No';
            }
        }*/
        return nhrStatus;
    }
    
    // Waiting for Inputs from Client
    public static String getGrandfatherRetireeOptRulesforNASCO()
    {
          String nhrStatus = '';
          return nhrStatus;
    }
    
    /*********************************************************************************************************************************************
@Description: crtExtrlAppRcrd() method 
@Name : crtExtrlAppRcrd
@Param :list<GA_Group_Segment__c> gsList
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
     
    public static void crtExtrlAppRcrdNASCO (list<GA_Group_Segment__c> gsList,boolean newAccErisaExmptVal){
        try{
            Set<id> gsIds = new Set<id>();
            //Capturing Ids of records            
            for(GA_Group_Segment__c gs : gsList)
            {
                if(gs.Id <> null){
                  gsIds.add(gs.Id); 
                }
            }
            system.debug('Inside crtExtrlAppRcrdNASCO');
            Map<ID,GA_Group_Segment__c> gsDetailsMap = new Map<ID,GA_Group_Segment__c>();            
            if(!gsIds.isEmpty())
            {
                gsDetailsMap = new Map<ID,GA_Group_Segment__c>([Select Id,GA_Account__c,GA_Account__r.CID__c,GA_MTV_Group_Division__c,GA_MTV_Group__c,GA_Rating_Type__c,GA_Regional_Office_Code__c from GA_Group_Segment__c 
                                                                where Id in :gsIds and Network__c ='NASCO' and GA_Carrier__c= 'BCBSM' and Status__c!='Canceled']);
            }
            
            Map<Id,List<GA_External_Appeal__c>> extAppealExistsForGSMap = new Map<Id,List<GA_External_Appeal__c>>();
            for(GA_Group_Segment__c gs : gsDetailsMap.values())
            {
                String accountId = gs.GA_Account__c;
                Set<id> gpSegIds = getGroupSegmentsAssociatedWithAccount(accountId);
                List<GA_External_Appeal__c> extAppealExists = [Select Id,GA_NHR_Status__c from GA_External_Appeal__c where GA_Group_Segment_Id__c in: gpSegIds and GA_NHR_End_Date__c>=Today order by createddate desc]; 
                if(extAppealExists !=null && extAppealExists.size() > 0){
                    extAppealExistsForGSMap.put(accountId, extAppealExists);
                } 
            }
            List <GA_External_Appeal__c> extAppealList = new List <GA_External_Appeal__c>();
            List <GA_External_Appeal__c> UpdtExistingApplList = new List <GA_External_Appeal__c> (); 
            GA_External_Appeal__c newExternalAppeal = new GA_External_Appeal__c();
            for(GA_Group_Segment__c gs : gsList){                
                if(gsDetailsMap.get(gs.Id) != null){
                    //For Updating Existing Appeal Records
                    List <GA_External_Appeal__c> existingAppealRecList = [select id,GA_NHR_Eff_Date__c,GA_NHR_End_Date__c,GA_Package_Number__c,GA_NHR_Status__c,GA_External_Appeal_Type__c,GA_Group_Segment_Id__c from GA_External_Appeal__c where GA_Group_Segment_Id__c =: gs.Id AND (GA_NHR_End_Date__c =null OR GA_NHR_End_Date__c>=Today) order by createdDate desc limit 1];
                    
                    if(existingAppealRecList.size()>0)
                    {
                    system.debug('existingAppealRecList Eris Exempt '+existingAppealRecList[0].GA_Group_Segment_Id__c);
                    String nhrStatus = getNHRStatusType(existingAppealRecList[0].GA_Package_Number__c, gsDetailsMap.get(gs.Id).GA_MTV_Group__c, gs.Id,gsDetailsMap.get(gs.Id).GA_Account__c,'NASCO',gsDetailsMap.get(gs.Id).GA_Account__r.CID__c,extAppealExistsForGSMap);
                    System.debug('nhrSTatusMethod>>> '+nhrStatus);    
                    
                    String externalAppealType = getExternalAppealType(nhrStatus,gsDetailsMap.get(gs.Id).GA_Rating_Type__c, gsDetailsMap.get(gs.Id).GA_Regional_Office_Code__c, newAccErisaExmptVal);
                    System.debug('externalAppealType>>> '+externalAppealType);
                        String prevExtAppType = existingAppealRecList[0].GA_External_Appeal_Type__c;
                        if(prevExtAppType == null)
                        {
                            prevExtAppType= '';
                        } 
                        
                    if(existingAppealRecList[0].GA_NHR_Status__c != nhrStatus || prevExtAppType != externalAppealType || existingAppealRecList[0].GA_NHR_Eff_Date__c != system.today()) 
                    {
                    newExternalAppeal = new GA_External_Appeal__c();
                    newExternalAppeal.GA_External_Appeals_Type_Override__c = False;
                    newExternalAppeal.GA_Group_Segment_Id__c = gs.Id; 
                    newExternalAppeal.GA_NHR_Eff_Date__c =  system.today();
                    newExternalAppeal.GA_NHR_End_Date__c = existingAppealRecList[0].GA_NHR_End_Date__c;
                    newExternalAppeal.GA_Package_Number__c = existingAppealRecList[0].GA_Package_Number__c;
                    newExternalAppeal.GA_Section_Number__c =  gsDetailsMap.get(gs.Id).GA_MTV_Group_Division__c; 
                    newExternalAppeal.GA_NASCO_Group_Number__c = gsDetailsMap.get(gs.Id).GA_MTV_Group__c;               
                    newExternalAppeal.GA_NHR_Status__c=nhrStatus;
                    newExternalAppeal.GA_External_Appeal_Type__c = externalAppealType;                    
                    
                    extAppealList.add(newExternalAppeal);  
 
                    existingAppealRecList[0].GA_NHR_End_Date__c = System.today().addDays(-1);
                    UpdtExistingApplList.add(existingAppealRecList[0]);
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
            GA_LogExceptionCls.LogExcp(e, clsName, metdcrtExtrlAppRcrdNASCO); 
        }  
    }
}