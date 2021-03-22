/*****************************************************************************************
Class Name   : ARV_AP88_GroupSegmentPackageCreation 
Date Created : 3-April-2020
Created By   : IDC Offshore
Description  :This is the class to create groupsegmentpackagecreation
******************************************************************************************/
Public without sharing class ARV_AP88_GroupSegmentPackageCreation  {
    Public static Boolean isExecute88=False;
    Private static final string GROUPSEGMENTQUERY='Select id,Status__c,GA_GS_Auto_No__c,Name, ARV_Package__c,ARV_ContractID__c, '+ 
        ' ARVPackage_Location_Segment_Relationship__c,ARV_GS_Dental_Type__c,ARV_GS_Vision_Type__c, '+
        'GA_Carrier__c,ARV_PlanPackage_Combinations__c,ARV_Pending_PackageId__c,ARV_Pending_ContractId__c from GA_Group_Segment__c';
    Private static final string GROUPSEGMENTWHERE=' Where '+
        'ARV_ContractID__c in:paramId2 and ARV_Package__c=null';
    Private static final string GROUPSEGMENTWHERE1=' Where id in:paramId2 ';
    private static final String DENTALPLAN='ARV_Dental_Plan__c';
    private static final String PEDIATRICDENTAL='ARV_Pediatric_Dental_Plan__c';
    private static final String VISIONPLAN='ARV_Vision_Plan__c';
    private static final String BCBS='BCBS';
    private static final String PEDIATRICVISION='ARV_Pediatric_Vision_Plan__c';
    private static final String  PACKAGETYPE='Group Segment Package';
    private static Id devRecordTypeId = Schema.SObjectType.Package__c.getRecordTypeInfosByName()
        .get(PACKAGETYPE).getRecordTypeId();
    private static final String PEDIATRIC='Pediatric';
    private static final String NODENTAL='No Denatl';
    private static final String NOVISION='No Vision';
    private static final String SEPERATEDVAL='-';
    private static final string PACKAGEQUERY='select id,ARV_Medical_Plan__c,ARV_Dental_Plan__c,Sister_Parent_ID__c,ARV_Vision_Plan__c,Name,'
        +' ARV_Contract_Id__c,ARV_Pediatric_Dental_Plan__c,ARV_Pediatric_Vision_Plan__c,Package_Carrier__c,ARV_Contains_Voluntary_Vision__c,ARV_CDH_Package_Combination__c from Package__c';
    private static final string PACKAGEWHERE= ' where ARV_Contract_Id__c in:paramId2';
    private static final string PLSRQUERY='Select id,Package__c,Contract__c from Package_Location_Segment_Rel__c ';
    Private static final string PLSRWHERE=' where Contract__c in:paramId2';
    Private static final string CONTRACTQUERY='Select id,vlocity_ins__FinalRatingGroupCensusId__c from Contract';
    private static final string CONTRACTWHERE=' Where  id in:paramId2 ';
    private static final String  ENROLLMENTCENSUSID ='enrollmentCensusId';
    private static final String  CONTRACTID1='contractId';
    private static final String ENROLLMENTSYSCENSUS ='Enrollment_systemCensus';
    private static final String SYSTEMCENSUSID='systemCensusId';
    Public static Map<String,Decimal> cmpremium;
    private static final String MEDICAL='Medical';
    private static final String DENTAL='Dental';
    private static final String VISION='Vision';
    private static Map<Id,string> gsNameContract;
    private static String CLASSNAME = 'ARV_AP88_GroupSegmentPackageCreation';
    
    /**************  
Method name : createSystemCensus
Params     : list
Return Type : null
Description :createSystemCensus() method to clone census, censumembers and GCMP Plans.
*************/    
    public static void createSystemCensus(Contract cont){
        Map<String, Object> ipInputJson = new Map<String, Object>();        
        Map<String, Object> ipOptions = new Map <String, Object> ();
        Map<String, Object> ipOutput = new Map <String, Object> ();                                              
        ipInputJson.put(ENROLLMENTCENSUSID,cont.vlocity_ins__EnrollmentCensusId__c);
        ipInputJson.put(CONTRACTID1,cont.Id);
        ipOutput = (Map<String,Object>)vlocity_ins.IntegrationProcedureService.runIntegrationService(ENROLLMENTSYSCENSUS,
                                                                                                     ipInputJson, ipOptions);
        cont.vlocity_ins__FinalRatingGroupCensusId__c = (String)ipOutput.get(SYSTEMCENSUSID);
        database.update(cont);
    }
    /**************  
Method name : groupSegmentRec
Params     : list
Return Type : null
Description :groupSegmentRec() method is called from group segment trigger.
*************/
    public static void groupSegmentRec(List<GA_Group_Segment__c> gsList){
        try{
        system.debug('gslist in groupSegmentRec'+ gsList);
        set<Id> contractId =new set<id>();
        for(GA_Group_Segment__c gsp:gsList){
            contractId.add(gsp.ARV_ContractID__c);
        }
        ARV_AP07_QueryDataHelper.paramId2=contractId;
        List<contract> contractList=ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,CONTRACTWHERE,NULL,NULL);
        system.debug('contract list in groupSegmentRec'+ contractList);
        if(contractList.size()>0){
            groupSegmentPckRec(contractList);
        }
    }catch(Exception ex){
         system.debug('Error at Line no::'+ex.getLineNumber());
        GA_LogExceptionCls.LogExcp(ex, CLASSNAME, 'groupSegmentRec'); 
    }
    }
    /**************  
Method name : groupSegmentPackageCreation
Params     : Id
Return Type : null
Description :groupSegmentPackageCreation() method for to create new package based on group segment conditions.
*************/
    public static void groupSegmentPckRec(list<contract> updatedContracts){
        try{
        set<id> contId=new set<id>();
        Set<Id> finalCensusId = new Set<Id>();
        for(contract cont:updatedContracts ){
            contId.add(cont.Id);            
        }
        for(contract con: [select id,vlocity_ins__FinalRatingGroupCensusId__c from Contract where id IN: contId limit 500]){
            finalCensusId.add(con.vlocity_ins__FinalRatingGroupCensusId__c);   
        }
        Map<Id,Id> plsrMap=new Map<Id,Id>();
        ARV_AP07_QueryDataHelper.paramId2=contId;
        List<Package_Location_Segment_Rel__c> plsrList=ARV_AP07_QueryDataHelper.getsObjects(PLSRQUERY,PLSRWHERE,null,null);
        for(Package_Location_Segment_Rel__c plsr:plsrList){
            plsrMap.put(plsr.Id,plsr.Package__c);
        }
        Map<Id,Package__c> pckgRec=new Map<Id,Package__c>();
        Map<Id,String> pckSisterMap=new Map<Id,String>();
        ARV_AP07_QueryDataHelper.paramId2=contId;
        List<Package__c> packageList=ARV_AP07_QueryDataHelper.getsObjects(PACKAGEQUERY,PACKAGEWHERE,null,null);
        id pediatricplan;
        for(Package__c pck:packageList){
            pckgRec.put(pck.Id,Pck);
            pckSisterMap.put(pck.Id,pck.Sister_Parent_ID__c);
            pediatricplan=pck.ARV_Pediatric_Vision_Plan__c;
        }
        Map<Id,string> gsNameWithPck=new Map<Id,string>();
         gsNameContract=new Map<Id,string>();
        ARV_AP07_QueryDataHelper.paramId2=contId;
        list<GA_Group_Segment__c> gsList=ARV_AP07_QueryDataHelper.getsObjects(GROUPSEGMENTQUERY,GROUPSEGMENTWHERE,NULL,NULL);
        List<Package__c> pckgList=new List<Package__c>();
        Package__c pckg = null;
        calculatePremium(gsList,finalCensusId);
        for(GA_Group_Segment__c gseg:gsList){
           gsNameContract.put(gseg.Id,gseg.ARV_ContractID__c);
            gsNameWithPck.put(gseg.Id,gseg.GA_GS_Auto_No__c);
            String finalDentalPlan=gseg.ARV_GS_Dental_Type__c==PEDIATRIC?
                PEDIATRICDENTAL:(gseg.ARV_GS_Dental_Type__c==NODENTAL?null:DENTALPLAN);
                    String finalVisionPlan=(gseg.ARV_GS_Vision_Type__c==PEDIATRIC)?
                    PEDIATRICVISION:((gseg.ARV_GS_Vision_Type__c==NOVISION)?null:VISIONPLAN);
                        string PLANTYPE;
            			string VISIONPLANTYPE;
                        pckg = new Package__c();
            pckg.Name=pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c)).Name+SEPERATEDVAL+gseg.GA_GS_Auto_No__c;
            if(pckSisterMap.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c))!=null)
            {
            pckg.Sister_Parent_ID__c=pckSisterMap.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c));
            }
            pckg.ARV_Medical_Plan__c = pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c))
                .ARV_Medical_Plan__c;
            if(pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c)).ARV_Medical_Plan__c != null){
                   id Medical_Plan= pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c)).ARV_Medical_Plan__c;
                 PLANTYPE= [select id,Carrier_Type__c from vlocity_ins__ContractLineItem__c where id=:Medical_Plan].Carrier_Type__c;
                   system.debug('this is medplanype'+PLANTYPE);
               }
            if(finalDentalPlan==PEDIATRICDENTAL){
                pckg.ARV_Dental_Plan__c =pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c))
                    .ARV_Pediatric_Dental_Plan__c;
                if(pckg.ARV_Dental_Plan__c==null){
                    pckg.ARV_Dental_Plan__c =pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c))
                        .ARV_Dental_Plan__c;
                }
            }else if(finalDentalPlan==DENTALPLAN){
                pckg.ARV_Dental_Plan__c =pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c))
                    .ARV_Dental_Plan__c;
            }else {}
            if(finalVisionPlan==PEDIATRICVISION){
                pckg.ARV_Vision_Plan__c =pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c))
                    .ARV_Pediatric_Vision_Plan__c;
                if( pckg.ARV_Vision_Plan__c ==null){
                    pckg.ARV_Vision_Plan__c =pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c))
                        .ARV_Vision_Plan__c;
                }
            }else if(finalVisionPlan==VISIONPLAN){
                pckg.ARV_Vision_Plan__c =pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c))
                    .ARV_Vision_Plan__c;
                if(pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c))
               .ARV_Vision_Plan__c != null){
                id VISIONPLAN= pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c))
                .ARV_Vision_Plan__c;
                VISIONPLANTYPE= [select id,Voluntary_Contributory__c from vlocity_ins__ContractLineItem__c where id=:VISIONPLAN].Voluntary_Contributory__c;
                   system.debug('this is voltype'+VISIONPLANTYPE);
              }
                if(PLANTYPE == BCBS && VISIONPLANTYPE== 'Voluntary' ){
                    system.debug('hi i entered'+pediatricplan);
                    pckg.ARV_Pediatric_Vision_Plan__c=pediatricplan;
                    }else{}
            }else{}
            pckg.ARV_Contract_Id__c=gseg.ARV_ContractID__c;
            pckg.RecordTypeId=devRecordTypeId;
            pckg.ARV_Orginal_Medical_Premium__c=cmpremium.get(gseg.Id+SEPERATEDVAL+MEDICAL);
            pckg.ARV_Orginal_Dental_Premium__C=cmpremium.get(gseg.Id+SEPERATEDVAL+DENTAL);
            pckg.ARV_Orginal_Vision_Premium__c=cmpremium.get(gseg.Id+SEPERATEDVAL+VISION);
            pckg.ARV_Plan_Package_Combinations__c=gseg.ARV_PlanPackage_Combinations__c;
            pckg.ARV_CDH_Package_Combination__c=pckgRec.get(plsrMap.get(gseg.ARVPackage_Location_Segment_Relationship__c)).ARV_CDH_Package_Combination__c;
            pckgList.add(pckg);
        }
        if(pckgList.size()>0){
            database.insert(pckgList);
            system.debug('in groupSegmentPckRec'+ pckgList);
               system.debug('in groupSegmentPckRec'+ gsList);
            updateGSpackage(pckgList,gsNameWithPck,finalCensusId);
            updateGSRenewalValues(pckgList, gsList);
        }
    }catch(Exception ex){
        system.debug('Error at Line no::'+ex.getLineNumber());
        GA_LogExceptionCls.LogExcp(ex, CLASSNAME, 'groupSegmentPckRec'); 
    }
    }
    
    /**************  
Method name : updateGSpackage
Params     : Id
Return Type : null
Description :updateGSpackage() method for to update package id on group segment .
*************/
    public  static void updateGSpackage(list<package__c> pckgList, Map<Id,string> gsNameWithPck, Set<Id> censusId){
        try{
        map<string,Id> packageMap=new map<string,Id>();        
        for(package__c pck:pckgList){
            string pckNmae=pck.Name;
            String[] res = pckNmae.split(SEPERATEDVAL);
            string finalp=res[1]+SEPERATEDVAL+res[2];
            packageMap.put(finalp,Pck.Id);            
        }
        GA_Group_Segment__c gsp=null;
        list<GA_Group_Segment__c> updateGSList=new list<GA_Group_Segment__c> ();
        for(Id  gsl:gsNameWithPck.keyset()){
            gsp=new GA_Group_Segment__c();
            gsp.Id=gsl;
            gsp.ARV_Package__c=packageMap.get(gsNameWithPck.get(gsl));
            gsp.ARV_Pending_PackageId__c=packageMap.get(gsNameWithPck.get(gsl));
            gsp.ARV_Pending_ContractId__c=gsNameContract.get(gsl);
            updateGSList.add(gsp);
        }        
        if(updateGSList.size()>0){
            isExecute88=true;
            database.update(updateGSList);
            isExecute88=false;
            createContractPackageHistory(updateGSList);
            updateMembersandGcmpPlans(censusId);
        }
        }catch(Exception ex){
             system.debug('Error at Line no::'+ex.getLineNumber());
             GA_LogExceptionCls.LogExcp(ex, CLASSNAME, 'updateGSpackage');
        }
    }
    
    /**************  
Method name : updateMembersandGcmpPlans
Params     : Id
Return Type : null
Description :updateMembersandGcmpPlans() method to update censusmembers and GCMP Plans with Group Segment packages .
*************/    
    public static void updateMembersandGcmpPlans(Set<Id> censusId){        
        List<vlocity_ins__GroupCensusMember__c> updateMemList = new List<vlocity_ins__GroupCensusMember__c>();
        Set<Id> memId = new Set<Id>();
        List<vlocity_ins__GroupCensusMemberPlan__c> updateGcmpList = new List<vlocity_ins__GroupCensusMemberPlan__c>();    
        for(vlocity_ins__GroupCensusMember__c mem : [select id,ARV_Group_Segment__c,ARV_Package__c,
                                                     ARV_Group_Segment__r.ARV_Package__c
                                                     from vlocity_ins__GroupCensusMember__c
                                                     where vlocity_ins__CensusId__c IN: censusId limit 500]){
                                                         //system.debug('print package id'+mem.ARV_Group_Segment__r.ARV_Package__c);
                                                         if(mem.ARV_Group_Segment__c != null){                                                        
                                                             mem.ARV_Package__c = mem.ARV_Group_Segment__r.ARV_Package__c;
                                                             updateMemList.add(mem);
                                                             memId.add(mem.id);
                                                         }
                                                     }
        if(updateMemList.size()>0){
            database.update(updateMemList);    
        }
        for(vlocity_ins__GroupCensusMemberPlan__c gcmp : [select id,PackageId__c,vlocity_ins__GroupCensusMemberId__c,
                                                          vlocity_ins__GroupCensusMemberId__r.ARV_Package__c
                                                          from vlocity_ins__GroupCensusMemberPlan__c 
                                                          where vlocity_ins__GroupCensusMemberId__c IN:memId limit 500]){           
                                                              if(gcmp.vlocity_ins__GroupCensusMemberId__r.ARV_Package__c != null ){
                                                                  gcmp.PackageId__c = gcmp.vlocity_ins__GroupCensusMemberId__r.ARV_Package__c;
                                                                  updateGcmpList.add(gcmp);
                                                              }            
                                                          }        
        if(updateGcmpList.size()>0){
            database.update(updateGcmpList);    
        }
        
        
    }
    /**************  
Method name : createContractPackageHistory
Params     : Id
Return Type : null
Description :createContractPackageHistory() method for to create ContractPackageHistory .
*************/
    public  static void createContractPackageHistory(list<GA_Group_Segment__c> updateGSList){
        set<id> gId=new set<id>();
        for(GA_Group_Segment__c gsId:updateGSList){
            gId.add(gsId.Id);
        }
        ARV_AP07_QueryDataHelper.paramId2=gId;
        list<GA_Group_Segment__c> gsList=ARV_AP07_QueryDataHelper.getsObjects(GROUPSEGMENTQUERY,GROUPSEGMENTWHERE1,NULL,NULL);
        List<ARV_Contract_Package_History__c> cpklist=new List<ARV_Contract_Package_History__c>();
        ARV_Contract_Package_History__c conPck=null;
        for(GA_Group_Segment__c gseg:gsList){
            conPck=new ARV_Contract_Package_History__c();
            conPck.ARV_GS_Package__c=gseg.ARV_Package__c;
            conPck.ARV_GS_Contract__c=gseg.ARV_ContractID__c;
            conPck.ARV_Group_Segment_Id__c=gseg.Id;
            cpklist.add(conPck);  
        }
        if(cpklist.size()>0){
            database.insert(cpklist);
        }
    }
    /**************  
Method name : calculatePremium
Params     : List
Return Type : null
Description :calculatePremium() method to update premiums on Group Segment packages .
*************/    
    public static void calculatePremium(List<GA_Group_Segment__c> gsList,set<id> finalCensusId){
        set<id> gsId=new set<id>();
        for(GA_Group_Segment__c gs:gsList){
            gsId.add(gs.Id);
        }
        list<vlocity_ins__GroupCensusMember__c> cenMemList=[select id,Enrollment_Medical_Premium__c,Enrollment_Vision_Premium__c,   Enrollment_Dental_Premium__c,
                                                            vlocity_ins__CensusId__c,ARV_Group_Segment__c from vlocity_ins__GroupCensusMember__c            
                                                            where ARV_Group_Segment__c in:gsId and vlocity_ins__CensusId__c in:finalCensusId ];
        cmpremium=new map<string,Decimal>();
        Decimal medicalPremium;
        Decimal dentalPremium;
        Decimal VisionPremium;
        for(vlocity_ins__GroupCensusMember__c cmList:cenMemList){                   
            if(cmpremium.ContainsKey(cmList.ARV_Group_Segment__c+SEPERATEDVAL+MEDICAL)){
                medicalPremium+=cmList.Enrollment_Medical_Premium__c;
                cmpremium.put(cmList.ARV_Group_Segment__c+SEPERATEDVAL+MEDICAL,  medicalPremium);
            }else{
                medicalPremium=0;
                medicalPremium=cmList.Enrollment_Medical_Premium__c;
                cmpremium.put(cmList.ARV_Group_Segment__c+SEPERATEDVAL+MEDICAL, medicalPremium);
            }
            if(cmpremium.ContainsKey(cmList.ARV_Group_Segment__c+SEPERATEDVAL+DENTAL)){
                dentalPremium+=cmList.Enrollment_Dental_Premium__c;
                cmpremium.put(cmList.ARV_Group_Segment__c+SEPERATEDVAL+DENTAL, dentalPremium);
            }else{
                dentalPremium=0;
                dentalPremium=cmList.Enrollment_Dental_Premium__c;
                cmpremium.put(cmList.ARV_Group_Segment__c+SEPERATEDVAL+DENTAL,dentalPremium);
            }
            if(cmpremium.ContainsKey(cmList.ARV_Group_Segment__c+SEPERATEDVAL+VISION)){
                VisionPremium+=cmList.Enrollment_Vision_Premium__c;
                cmpremium.put(cmList.ARV_Group_Segment__c+SEPERATEDVAL+VISION,VisionPremium);
            }else{
                VisionPremium=0;
                VisionPremium=cmList.Enrollment_Vision_Premium__c;
                cmpremium.put(cmList.ARV_Group_Segment__c+SEPERATEDVAL+VISION,VisionPremium);
                
            }
            system.debug('lllll'+cmpremium);
        }
         
    }
    
    /**************  
Method name : updateGDRenewalValues
Params     : List
Return Type : null
Description :method to calculate total of premiums on Group Segment packages .
*************/
	public static void updateGSRenewalValues(List<Package__c> pkgList, List<GA_Group_Segment__c> gsList){
        try{
        system.debug('gsList in updateGSRenewalValues'+ gsList);
		Map<Id, Package__c> pckMap = new Map<Id, Package__c>();
		
		for(Package__c pck: pkgList){
			pckMap.put(pck.Id, pck);
		}
		
		List<GA_Group_Segment__c> gsToUpdate = new List<GA_Group_Segment__c>();
		
		if(!pckMap.keySet().isEmpty()){
			for(GA_Group_Segment__c gs: gsList){
				if(pckMap.get(gs.ARV_Pending_PackageId__c) != null){
					gs.ARV_CF_GS_Renewal_Total_Premium__c = pckMap.get(gs.ARV_Pending_PackageId__c).ARV_Renewal_Dental_Premium__c + pckMap.get(gs.ARV_Pending_PackageId__c).ARV_Renewal_Medical_Premium__c + pckMap.get(gs.ARV_Pending_PackageId__c).ARV_Renewal_Vision_Premium__c;					
					gs.ARV_CF_GS_Last_Year_Total_Premium__c = pckMap.get(gs.ARV_Pending_PackageId__c).ARV_Orginal_Dental_Premium__c + pckMap.get(gs.ARV_Pending_PackageId__c).ARV_Orginal_Medical_Premium__c + pckMap.get(gs.ARV_Pending_PackageId__c).ARV_Orginal_Vision_Premium__c;
					
                    System.debug('lasttotalpremium ' +gs.ARV_CF_GS_Last_Year_Total_Premium__c);
                    System.debug('renewaldentalpremium ' +pckMap.get(gs.ARV_Pending_PackageId__c).ARV_Orginal_Dental_Premium__c);
                    System.debug('renewalmedicalpremium ' +pckMap.get(gs.ARV_Pending_PackageId__c).ARV_Orginal_Medical_Premium__c);
                    System.debug('renewalvisionpremium ' +pckMap.get(gs.ARV_Pending_PackageId__c).ARV_Orginal_Vision_Premium__c);
                    
                    System.debug('GSafterupdate '+gs);
                    
                    gsToUpdate.add(gs);
				}
			}
		}
	
		Database.update(gsToUpdate);
    }catch(Exception ex){
        system.debug('Error at Line no::'+ex.getLineNumber());
        GA_LogExceptionCls.LogExcp(ex, CLASSNAME, 'updateGSRenewalValues'); 
    }
    }
    
}