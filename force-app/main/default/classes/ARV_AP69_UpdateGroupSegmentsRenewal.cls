/*****************************************************************************************
Class Name   : ARV_AP69_UpdateGroupSegmentsRenewal 
Date Created : 17-04-2020
Created By   : IDC  Offshore
Description  :This is the class for contract record updation after  submitting. 
******************************************************************************************/
global without sharing class ARV_AP69_UpdateGroupSegmentsRenewal implements vlocity_ins.VlocityOpenInterface2{
    Private Static Final String GROUPSEGMENTS='updateGSRenewal';
    Private Static Final String CREATEGCMPRECORDS='createGCMPRecords';
    Private Static Final String UPDATEGCMPRATES='updateGCMPRates';
    Private Static Final String CALCULATEPREMIUMPCKG= 'calculatePremiumPckg';
    Private Static Final String CONTRACTIDVAR='contractId';
    Private Static Final String RENEWALRECORDTYPE='Renewal';
    Private Static Final String CENSUSMEMBER= 'censusMember';
    Private Static Final String MEMBERDETAILS= 'memberDetails';
    Private Static Final String SGCENSUS= 'Id';
    Private Static Final String SGCENSUSAGE= 'MemberAge__c';
    private static String renewalContractId;
    private static String contractId;
    Private static final string CENSUSMEMQUERY='Select id,MemberAge__c,ARV_Package__c,CM_End_Date__c,CM_Start_Date__c,'+
        'vlocity_ins__CensusId__c,ARV_Group_Segment__c,ARV_Group_Segment__r.ARV_Pending_PackageId__c '
        +' from vlocity_ins__GroupCensusMember__c';
    Private static final string CENSUSMEMWHERE=' Where vlocity_ins__CensusId__c =:paramId1';
    Private static final string GCMPQUERY='Select id,PackageId__c,vlocity_ins__GroupCensusMemberId__c'+ 
        ' from vlocity_ins__GroupCensusMemberPlan__c';
    Private static final string GCMPWHERE=' Where vlocity_ins__GroupCensusMemberId__c in:paramId2';
    private static final String SYSTEMCENSUS='systemCensus';
    private static final String ENROLLMENTCENSUS='enrollmentCensus';
    private static final String RENEWALCENSUS='renewalCensus';
    private static final String NEWCENSUS='newCensus';
    private static final String GCMPCREATED='f_AllGCMPsCreatedSuccessfully';
    private static final String SYSTEMTYPE='System';
    private static final String SEPERATEDVAL='-';
    private static final String MEDICAL='Medical';
    private static final String DENTAL='Dental';
    private static final String VISION='Vision';
    private static final String GSUPDATED='f_GsUpdatesSuccessfully';
     private static final String GSUPDATED1='f_CheckCensusMember';
    private static final string PRODUCTDETAILS='ProductDetails';
    private static final string CENSUSID='censusId';
    private static final string CENSUSMEMID= 'vlocity_ins__CensusMemberId__c';
    private static final string  PRODUCTID='ProductId';
    private static final string PREMIUM='Premium';
    private static final string F_ALLGCMPRATES='f_AllGCMPsRatesUpdatedSuccessfully';
    private static final string PROFILENAME='Integration User';
    private static final string YEARVAL='2021';
    private static final string DATEVAL='01';
    /*****************************************************************************************
Class Name   : invokeMethod 
Date Created : May 2020
Created By   : IDC Offshore
Description  :This is the class for contract record updation after  submitting. 
******************************************************************************************/     
    global static Boolean invokeMethod(String methodName, Map<String,Object> inputMap,Map <String, Object> outMap, 
                                       Map<String,Object> options) {
                                           try{
                                               if(GROUPSEGMENTS.equals(methodName)){                                                   
                                                   updateGSRenewal(inputMap,outMap,options);    
                                               }                            
                                               else if(CREATEGCMPRECORDS.equals(methodName)){
                                                   createGCMPRecords(inputMap,outMap,options);
                                               }
                                               else if(UPDATEGCMPRATES.equals(methodName)){
                                                   updateGCMPRates(inputMap,outMap,options);
                                               }
                                               else if(CALCULATEPREMIUMPCKG.equals(methodName)){
                                                   calculatePremiumPckg(inputMap,outMap,options);
                                               }else{}   
                                               
                                           }catch(Exception e){ throw new AuraHandledException(e.getMessage());  }
                                           return true;   
                                       }
    /*****************************************************************************************
Class Name   : createGCMPRecords 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  : method to create group census member plan records for system census and renewal contract census.
******************************************************************************************/    
public static void createGCMPRecords(Map<String, Object> inputMap,Map < String, Object > outMap, 
                                         Map < String, Object > options){
                                             try{                                  
                                                 renewalContractId = (String)options.get(CONTRACTIDVAR);
                                                 Id oldCensusId = (Id)options.get(SYSTEMCENSUS)!=null?(Id)options.get(SYSTEMCENSUS):(Id)options.get(ENROLLMENTCENSUS);
                                                 Id newCensusId = (Id)options.get(RENEWALCENSUS)!=null?(Id)options.get(RENEWALCENSUS):(Id)options.get(NEWCENSUS);
                                                 string censusType=[select id,vlocity_ins__CensusType__c from vlocity_ins__GroupCensus__c 
                                                                    where id=:newCensusId limit 1].vlocity_ins__CensusType__c;
                                                 Boolean isSystemCnesus=(censusType==SYSTEMTYPE)?true:false;
                                                 Id systemCensusId = (Id)options.get(SYSTEMCENSUS);
                                                 List<vlocity_ins__GroupCensusMember__c> updateCensusMember = new List<vlocity_ins__GroupCensusMember__c>();
                                                 List<vlocity_ins__GroupCensusMemberPlan__c> insertGCMPList = new List<vlocity_ins__GroupCensusMemberPlan__c>();
                                                 vlocity_ins__GroupCensusMemberPlan__c gcmpNew=null;
                                                 vlocity_ins__GroupCensusMember__c cenMemNew=null;
                                                 Map<String,Id> memberIdentifierMap = new Map<String,Id>();
                                                 Map<Id,Id> originalLineItemIdMap = new Map<Id,Id>();
                                                 for(vlocity_ins__GroupCensusMember__c mem : [select id,vlocity_ins__MemberIdentifier__c
                                                                                              from vlocity_ins__GroupCensusMember__c
                                                                                              where vlocity_ins__CensusId__c =: newCensusId limit 500]){           
                                                                                                  memberIdentifierMap.put(mem.vlocity_ins__MemberIdentifier__c,mem.id);                                              
                                                                                              }
                                                 for(vlocity_ins__ContractLineItem__c cli : [select id,vlocity_ins__OriginalLineItemId__c
                                                                                             from vlocity_ins__ContractLineItem__c
                                                                                             where vlocity_ins__ContractId__c =: renewalContractId limit 500]){
                                                                                                 originalLineItemIdMap.put(cli.vlocity_ins__OriginalLineItemId__c,cli.id);    
                                                                                             }
                                                 for(vlocity_ins__GroupCensusMemberPlan__c gcmp: [select id,name,ARV_Member_Rate__c,
                                                                                                  vlocity_ins__GroupCensusMemberId__r.vlocity_ins__MemberIdentifier__c,
                                                                                                  Product_Type__c,vlocity_ins__ContractLineId__c
                                                                                                  from vlocity_ins__GroupCensusMemberPlan__c
                                                                                                  where Member_Census_Id__c =: oldCensusId limit 2000 ]){
                                                                                                      
                                                                                                      gcmpNew = new vlocity_ins__GroupCensusMemberPlan__c();
                                                                                                      gcmpNew.Product_Type__c = gcmp.Product_Type__c;            
                                                                                                      gcmpNew.vlocity_ins__GroupCensusMemberId__c = memberIdentifierMap.get(gcmp.vlocity_ins__GroupCensusMemberId__r.vlocity_ins__MemberIdentifier__c);                                              
                                                                                                      if(isSystemCnesus){
                                                                                                          gcmpNew.ARV_Member_Rate__c = gcmp.ARV_Member_Rate__c;
                                                                                                          gcmpNew.vlocity_ins__ContractLineId__c = gcmp.vlocity_ins__ContractLineId__c;
                                                                                                      }else{
                                                                                                          gcmpNew.vlocity_ins__ContractLineId__c = originalLineItemIdMap.get(gcmp.vlocity_ins__ContractLineId__c);                                                          
                                                                                                      }                                                            
                                                                                                      insertGCMPList.add(gcmpNew);   
                                                                                                      system.debug('insertGCMPList'+insertGCMPList);
                                                                                                  }
                                                for(vlocity_ins__GroupCensusMember__c cenMem: [select id,name,ARV_External_Id__c,
                                                                                                BNF_PKG_PLAN_PID__c from vlocity_ins__GroupCensusMember__c
                                                                                                  where vlocity_ins__CensusId__c =: oldCensusId limit 100 ]){
                                                                                                      cenMemNew = new vlocity_ins__GroupCensusMember__c();
                                                                                                      cenMemNew.ARV_External_Id__c = null;            
                                                                                                      cenMemNew.BNF_PKG_PLAN_PID__c = null;                                                            
                                                                                                      updateCensusMember.add(cenMemNew);  
                                                                                                      system.debug('updateCensusMember'+updateCensusMember);
                                                                                                  }
                                                 if(!insertGCMPList.isEmpty()){
                                                     database.insert(insertGCMPList); 
                                                 }
                                                 if(!updateCensusMember.isEmpty()){
                                                    database.insert(updateCensusMember);                                     
                                                }
                                                 outMap.put(GCMPCREATED,true);       
                                             }catch(Exception e){ //throw new AuraHandledException(+e.getMessage());
                                                 outMap.put(GCMPCREATED,false);       
                                             }        
                                         }
    /*****************************************************************************************
Class Name   : updateGCMPRates 
Date Created : JULY 2020
Created By   : IDC Offshore
Description  :This method is used for updateGCMPRates
******************************************************************************************/  
    public static void updateGCMPRates(Map < String, Object > inputMap,Map < String, Object > outMap, 
                                       Map < String, Object > options){
                                           try{
                                               renewalContractId = (String)options.get(CONTRACTIDVAR);
                                               Id censusId = (Id)options.get(CENSUSID);
                                               List<Object> ratesBreakoutList = new List<Object>();
                                               if(options.get(PRODUCTDETAILS) instanceof List<Object>){
                                                   ratesBreakoutList=(List<Object>)options.get(PRODUCTDETAILS);    
                                               }else{             
                                                   ratesBreakoutList.add((Object)options.get(PRODUCTDETAILS) );                                            
                                               }
                                               Map<String,Decimal> userRatesMap=new Map<String,Decimal>();
                                               List<vlocity_ins__GroupCensusMemberPlan__c> updateGCMPList = new List<vlocity_ins__GroupCensusMemberPlan__c>();
                                               List<vlocity_ins__GroupCensusMemberPlan__c> extractGCMPList = new List<vlocity_ins__GroupCensusMemberPlan__c>();
                                               if(!ratesBreakoutList.isEmpty()){
                                                   for(Object eachList:ratesBreakoutList){
                                                       Map<String,Object> entry=(Map<String,Object>)eachList;
                                                       userRatesMap.put((Id)entry.get(CENSUSMEMID)+SEPERATEDVAL+(Id)entry.get(PRODUCTID),(Decimal)entry.get(PREMIUM));
                                                   }                                      
                                               }    
                                               for(vlocity_ins__GroupCensusMemberPlan__c gcmp: [select id,name,ARV_Member_Rate__c,
                                                                                                vlocity_ins__PlanProductId__c,vlocity_ins__GroupCensusMemberId__c                                                             
                                                                                                from vlocity_ins__GroupCensusMemberPlan__c
                                                                                                where Member_Census_Id__c =: censusId limit 2000]){
                                                                                                    extractGCMPList.add(gcmp);
                                                                                                    if(gcmp.vlocity_ins__PlanProductId__c != null && gcmp.vlocity_ins__GroupCensusMemberId__c != null){
                                                                                                        string finalVal=gcmp.vlocity_ins__GroupCensusMemberId__c+SEPERATEDVAL+gcmp.vlocity_ins__PlanProductId__c;
                                                                                                        gcmp.ARV_Member_Rate__c = userRatesMap.get(finalVal);
                                                                                                        updateGCMPList.add(gcmp);
                                                                                                    }                                                
                                                                                                }
                                               if(!updateGCMPList.isEmpty()){
                                                   database.update(updateGCMPList);      
                                               }
                                               if(extractGCMPList.size() == updateGCMPList.size()){
                                                   outMap.put(F_ALLGCMPRATES,true);     
                                               }else{
                                                   outMap.put(F_ALLGCMPRATES,false);   
                                               }
                                           }catch(Exception e){ //throw new AuraHandledException(+e.getMessage());
                                               outMap.put(F_ALLGCMPRATES,false);
                                               
                                           }
                                           
                                       }
    /*****************************************************************************************
Class Name   : updateGSRenewal 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  :This is the class for contract record updation after  submitting. 
******************************************************************************************/    
    public static void updateGSRenewal(Map < String, Object > inputMap,Map < String, Object > outMap, 
                                       Map < String, Object > options){
                                           try{              
                                               renewalContractId = (String)options.get(CONTRACTIDVAR);
                                               Contract rnwlCon = [select id,vlocity_ins__ExpiredContractId__c,startdate,
                                                                   vlocity_ins__EnrollmentCensusId__c,RecordtypeId from Contract where id=: renewalContractId limit 1];
                                               contractId =rnwlCon.vlocity_ins__ExpiredContractId__c;
                                               Id censusId =rnwlCon.vlocity_ins__EnrollmentCensusId__c; 
                                               Date renewalStartDate=rnwlCon.startdate;                       
                                               Map<Id,String> packageMap = new Map<Id,String>();
                                               Map<String,Id> rnwlPackageMap = new Map<String,Id>();
                                               List<GA_Group_Segment__c> groupSgmntsUpdate = new List<GA_Group_Segment__c>();
                                               for(Package__c pkg : ([select id,name from Package__c where ARV_Contract_Id__c =: renewalContractId limit 500]) ){
                                                   rnwlPackageMap.put(pkg.name,pkg.id);                                  
                                               }
                                               for(Package__c pkg : ([select id,name from Package__c where ARV_Contract_Id__c =: contractId limit 500]) ){
                                                   packageMap.put(pkg.id,pkg.name);                                  
                                               }
                                               for(GA_Group_Segment__c gs: ([select id,ARVPackage_Location_Segment_Relationship__r.Package__c,
                                                                             ARV_Pending_ContractId__c,ARV_Pending_PackageId__c,ARV_Package__c
                                                                             from GA_Group_Segment__c
                                                                             where ARV_ContractID__c =: contractId limit 500])){   
                                                                                 gs.ARV_Pending_ContractId__c = renewalContractId;
                                                                                 gs.ARV_Pending_PackageId__c = rnwlPackageMap.get(packageMap.get(gs.ARV_Package__c));
                                                                                 groupSgmntsUpdate.add(gs);
                                                                             }
                                               if(!groupSgmntsUpdate.isEmpty()){
                                                   database.update(groupSgmntsUpdate);
                                               }
                                                Boolean isCensusMem=deleteCensusMembers(censusId,renewalStartDate,contractId,options);
                                               outMap.put(GSUPDATED,true); 
                                                 outMap.put(GSUPDATED1,isCensusMem); 
                                           }catch(Exception e){ //throw new AuraHandledException(+e.getMessage());
                                               outMap.put(GSUPDATED,false); 
                                               
                                           }     
                                       }            
    /*****************************************************************************************
Class Name   : deleteCensusMembers 
Date Created : May 2020
Created By   : IDC Offshore
Description  :This method is used to delete censusmembers who are not eligible for renewal contract 
******************************************************************************************/    
    public static Boolean deleteCensusMembers(Id censusId,date renewalStartDate,Id contractId,Map<String, Object> options){
          Boolean isCensus;
        ARV_AP07_QueryDataHelper.paramId1=censusId;
        list<vlocity_ins__GroupCensusMember__c> cenMemList=ARV_AP07_QueryDataHelper.getsObjects(CENSUSMEMQUERY,
                                                                                                CENSUSMEMWHERE,NULL,NULL);
        list<vlocity_ins__GroupCensusMember__c> deleteCensusMem=new  list<vlocity_ins__GroupCensusMember__c>();
        list<vlocity_ins__GroupCensusMember__c> finalCensusMem=new  list<vlocity_ins__GroupCensusMember__c>();
        if(cenMemList.size()>0){
            for(vlocity_ins__GroupCensusMember__c cml:cenMemList){
                if(cml.CM_End_Date__c<=renewalStartDate){
                    deleteCensusMem.add(cml);
                }else{
                    finalCensusMem.add(cml);
                }
            } 
            if(deleteCensusMem.size()>0){
                database.delete(deleteCensusMem);
            }
            if(finalCensusMem.size()>0){
                isCensus=true;
            }else{isCensus=false;}
        }
        updatePckOnCensusMem(finalCensusMem,contractId,options);
        return isCensus;
    }
    /*****************************************************************************************
Class Name   : updatePckOnCensusMem 
Date Created : May 2020
Created By   : IDC Offshore
Description  :This method is used for delete censusmembers 
******************************************************************************************/  
    public static void updatePckOnCensusMem(list<vlocity_ins__GroupCensusMember__c> updatePckOnCensusMem, Id contractId,Map<String, Object> options){
        list<vlocity_ins__GroupCensusMember__c> updateCensusMem=new  list<vlocity_ins__GroupCensusMember__c>();
        Map<String,Object> getCensusMemberMap = (Map<String,Object>)options.get(MEMBERDETAILS);                
        List<Object> userInputsList = new List<Object>();
        if(getCensusMemberMap.get(CENSUSMEMBER) instanceof List<Object>){
            userInputsList=(List<Object>)getCensusMemberMap.get(CENSUSMEMBER);    
        }else{             
            userInputsList.add((Object)getCensusMemberMap.get(CENSUSMEMBER));                                            
        }         
        Map<Id,Decimal> userInputsMap=new Map<Id,Decimal>();
        if(!userInputsList.isEmpty()){
            for(Object eachList:userInputsList){
                Map<String,Object> entry=(Map<String,Object>)eachList;
                userInputsMap.put((Id)entry.get(SGCENSUS),(Decimal)entry.get(SGCENSUSAGE) );
            }
        }
        for(vlocity_ins__GroupCensusMember__c cem:updatePckOnCensusMem){
            cem.ARV_Package__c=cem.ARV_Group_Segment__r.ARV_Pending_PackageId__c;
            if(userInputsMap.containsKey(cem.Id) ){
                cem.MemberAge__c = userInputsMap.get(cem.id);
            }
            updateCensusMem.add(cem);
        }
        if(updateCensusMem.size()>0){
            database.update(updateCensusMem);
            updatePckOnGCMP(updateCensusMem);
        }
    }
    /*****************************************************************************************
Class Name   : updatePckOnGCMP 
Date Created : May 2020
Created By   : IDC Offshore
Description  :This method is used for delete censusmembers 
******************************************************************************************/  
    public static void updatePckOnGCMP( list<vlocity_ins__GroupCensusMember__c> updateCensusMem){
        list<vlocity_ins__GroupCensusMemberPlan__c> updateGcmpList=new list<vlocity_ins__GroupCensusMemberPlan__c>();
        Map<Id,string> planKey=new Map<Id,String>();
        set<id> mycm=new set<Id>();
        set<id> gsId=new set<Id>();
        set<id> pckId=new set<Id>();
        set<id> enrollCensuId=new set<Id>();
        if(updateCensusMem.size()>0){
            for(vlocity_ins__GroupCensusMember__c cmps:updateCensusMem){
                mycm.add(cmps.Id);
                planKey.put(cmps.Id,cmps.ARV_Package__c);
                //added for premium
                gsId.add(cmps.ARV_Group_Segment__c);
                pckId.add(cmps.ARV_Package__c);
                enrollCensuId.add(cmps.vlocity_ins__CensusId__c);
            }
        }
        List<GA_Group_Segment__c> gsList=[Select id,Name,ARV_Pending_PackageId__c from GA_Group_Segment__c where id in:gsId limit 500];
        if(gsList.size()>0){
            Map<string,string> gsMap=new Map<string,string>();
            for(GA_Group_Segment__c gsr:gsList){
                gsMap.put(gsr.ARV_Pending_PackageId__c,gsr.Id);
            }
            ARV_AP88_GroupSegmentPackageCreation.calculatePremium(gsList,enrollCensuId);
            list<Package__c> pckList= [select id,ARV_Renewal_Dental_Premium__c,ARV_Renewal_Medical_Premium__c,
                                       ARV_Renewal_Vision_Premium__c,Name from Package__c where id in:pckId limit 500];
            list<Package__c> updatePckList=new  list<Package__c>();
            Package__c  upPck=Null;
            if(pckList.size()>0){
                for(Package__c pck:pckList){ 
                    string finalMedical=gsMap.get(pck.Id)+SEPERATEDVAL+MEDICAL;
                    string finalDental=gsMap.get(pck.Id)+SEPERATEDVAL+DENTAL;
                    string finalVision=gsMap.get(pck.Id)+SEPERATEDVAL+VISION;
                    upPck=new Package__c();
                    upPck.Id=pck.Id;
                    upPck.ARV_Renewal_Medical_Premium__c=ARV_AP88_GroupSegmentPackageCreation.cmpremium.get(finalMedical);
                    upPck.ARV_Renewal_Dental_Premium__c=ARV_AP88_GroupSegmentPackageCreation.cmpremium.get(finalDental);
                    upPck.ARV_Renewal_Vision_Premium__c=ARV_AP88_GroupSegmentPackageCreation.cmpremium.get(finalVision);
                    updatePckList.add(upPck);
                }
                if(updatePckList.size()>0){
                    database.update(updatePckList);
                }
            }
        }
        ARV_AP07_QueryDataHelper.paramId2=mycm;
        List<vlocity_ins__GroupCensusMemberPlan__c> gcmpList=ARV_AP07_QueryDataHelper.getsObjects(GCMPQUERY,GCMPWHERE,NULL,NULL);
        for(vlocity_ins__GroupCensusMemberPlan__c gcmp:gcmpList){
            gcmp.PackageId__c=planKey.get(gcmp.vlocity_ins__GroupCensusMemberId__c);
            updateGcmpList.add(gcmp);
        }
        if(updateGcmpList.size()>0){
            database.update(updateGcmpList);
        }
        
    }
    /*****************************************************************************************
Class Name   : calculatePremiumPckg 
Date Created : oct 2020
Created By   : IDC Offshore
Description  :This method is used for delete censusmembers 
******************************************************************************************/     
    public static void calculatePremiumPckg(Map < String, Object > inputMap,Map < String, Object > outMap,  Map < String, Object > options){
        Id contractId = (String)options.get(CONTRACTIDVAR);
        Id profileId=[select id, Name from Profile where Name=:PROFILENAME].Id;
        Contract con=[Select id,name,accountID ,vlocity_ins__FinalRatingGroupCensusId__c from contract where id =: contractId  ];
        Id accId=con.accountID;
        Id cenId=con.vlocity_ins__FinalRatingGroupCensusId__c;
        List<GA_Group_Segment__c> gsList=[Select id,name,ARV_Package__c,GA_Account__c from GA_Group_segment__c where GA_Account__c =:accId];
        set<id> gsId=new set<id>();
        Map<string,string> gsMap=new Map<string,string>();
        for(GA_Group_Segment__c gs:gsList){
            gsId.add(gs.Id);
            gsMap.put(gs.ARV_Package__c,gs.Id);
        }
        system.debug('^^^'+gsId+'&&&&'+cenId);
        list<vlocity_ins__GroupCensusMember__c> cenMemList=[select id,Enrollment_Medical_Premium__c,
                                                            Enrollment_Vision_Premium__c,   Enrollment_Dental_Premium__c,
                                                            vlocity_ins__CensusId__c,ARV_Group_Segment__c 
                                                            from vlocity_ins__GroupCensusMember__c            
                                                            where ARV_Group_Segment__c in:gsId and vlocity_ins__CensusId__c =:cenId ];
                                          system.debug('@@@@@@@@@@@@@@'+cenMemList.size());                  
        Map<String,Decimal>  cmpremium=new map<string,Decimal>();
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
        }
        system.debug('cmpremium####'+cmpremium);
         
        list<Package__c> pckList=[select id,ARV_Orginal_Dental_Premium__C,ARV_Orginal_Medical_Premium__c, ARV_Orginal_Vision_Premium__c from Package__c where ARV_Contract_Id__c =:contractId and recordtype.name='Group Segment Package'];
        list<Package__c> updatePckList=new list<Package__c>();
        Package__c pckg=null;
        for(Package__c pck: pckList){
            pckg=new Package__c();
            pckg.Id=pck.Id;
            pckg.ARV_Orginal_Medical_Premium__c=cmpremium.get(gsMap.get(pck.Id)+SEPERATEDVAL+MEDICAL);
            pckg.ARV_Orginal_Dental_Premium__C=cmpremium.get(gsMap.get(pck.Id)+SEPERATEDVAL+DENTAL);
            pckg.ARV_Orginal_Vision_Premium__c=cmpremium.get(gsMap.get(pck.Id)+SEPERATEDVAL+VISION);
            updatePckList.add(pckg);
              System.debug('updatePckList&&&&'+updatePckList);
        }
        System.debug('updatePckList&&&&'+updatePckList);
        if(updatePckList.size()>0){
        update updatePckList;
        }
        if(contractId!=null){
        poupulateDateOnContract(contractId);
        }
         list<vlocity_ins__GroupCensusMember__c> cenMemList1=[Select id,MemberAge__c,vlocity_ins__CensusId__c from vlocity_ins__GroupCensusMember__c Where vlocity_ins__CensusId__c=:cenId];
       if(!cenMemList1.isEmpty())
        calculateAge(options,cenMemList1);
        
    }
    /*****************************************************************************************
Class Name   : calculateAge 
Date Created : OCT 2020
Created By   : IDC Offshore
Description  :This method is used for delete censusmembers 
******************************************************************************************/  
    public static void calculateAge(Map < String, Object > options,list<vlocity_ins__GroupCensusMember__c> cenMemList){
        list<vlocity_ins__GroupCensusMember__c> updateCensusMem=new  list<vlocity_ins__GroupCensusMember__c>();
        if(!test.isRunningTest()){
            Map<String,Object> getCensusMemberMap = (Map<String,Object>)options.get(MEMBERDETAILS);                
            List<Object> userInputsList = new List<Object>();
            if(getCensusMemberMap.get(CENSUSMEMBER) instanceof List<Object>){ userInputsList=(List<Object>)getCensusMemberMap.get(CENSUSMEMBER);    
            }else{userInputsList.add((Object)getCensusMemberMap.get(CENSUSMEMBER)); }         
            Map<Id,Decimal> userInputsMap=new Map<Id,Decimal>();
            if(!userInputsList.isEmpty()){
                for(Object eachList:userInputsList){
                    Map<String,Object> entry=(Map<String,Object>)eachList;
                    userInputsMap.put((Id)entry.get(SGCENSUS),(Decimal)entry.get(SGCENSUSAGE) );
                }}
            //list<vlocity_ins__GroupCensusMember__c> updateCenAge=[Select id,MemberAge__c from vlocity_ins__GroupCensusMember__c where id in:userInputsMap.keyset()];
            for(vlocity_ins__GroupCensusMember__c cem: cenMemList){
                if(userInputsMap.containsKey(cem.Id) ){ cem.MemberAge__c = userInputsMap.get(cem.id);  }
                updateCensusMem.add(cem);
            }
            if(updateCensusMem.size()>0){  database.update(updateCensusMem); }
        }
    }
    /*****************************************************************************************
Class Name   : poupulateDateOnContract 
Date Created : oct 2020
Created By   : IDC Offshore
Description  :This method is used to populate dates on contract
******************************************************************************************/     
  Public static void poupulateDateOnContract(Id contractId){
      Id profileId=[select id, Name from Profile where Name='Integration User'].Id;
       List<Contract>cont=[select id,ARV_Requested_Renewal_Date_Month__c,ARV_Requested_Renewal_Month__c, Account.Renewal_month__c,ARV_Requested_Effective_Date__c,Account.GA_Renewal_Year__c from Contract where  vlocity_ins__FinalRatingGroupCensusId__c !=NULL and  vlocity_ins__QuoteId__c=null and  Id=:contractId and createdby.ProfileId =: profileId];
        List<contract>lstCon=new List<contract>();
        for(Contract con:cont){
            if(con.ARV_Requested_Effective_Date__c==null){
                con.ARV_Requested_Effective_Date__c=con.Account.GA_Renewal_Year__c;
            } if(con.ARV_Requested_Renewal_Month__c==null){
                con.ARV_Requested_Renewal_Month__c=con.Account.Renewal_month__c;  
            } if(con.ARV_Requested_Renewal_Date_Month__c==null){
                con.ARV_Requested_Renewal_Date_Month__c=con.Account.GA_Renewal_Year__c;
            }
            lstCon.add(con);
        }
        if(lstCon.size()>0){
          database.update(lstCon);
        }
  }
}