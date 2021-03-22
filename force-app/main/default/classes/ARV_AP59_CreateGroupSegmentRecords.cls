/******************************************************************************************************************************************
@Author : Offshore
@Name: ARV_AP59_CreateGroupSegmentRecords
@CreatedDate: 13 - Dec 2019  
@Description: ARV_AP59_CreateGroupSegmentRecords contains the methods for group segment creation 
@version : 1.0  ---------
*****************************************************************************************************************************************/
public without sharing class ARV_AP59_CreateGroupSegmentRecords {
    
    public static final String SLCTLBL='select ';
    public static final String COMMAOP=',';
    public static final string CLSNAME  ='ARV_AP59_CreateGroupSegmentRecords';
    public static final string CRTGS_METHODNAME  ='createGroupSegmentRecords';
    public static final string BUILD_GS_REC_METHOD = 'buildGroupSegmentRecProps';
    public static final string BUILD_PROP_MDATA_METHOD ='buildPropsFromMetadata';
    public static final string CREAT_GSA_METHOD ='createGroupSegmentAssociation';
    public static final string PERFORMGSTTRANS_METHOD ='performGSTransformations';
    public static final string CREATENEWAOR_METHOD = 'createNewAOR';
    public static final string UPDATECENSUSMEM_METHOD = 'updateCensusMem';
    public static final string CONTRACT = 'Contract';
    public static final string LOCATIONPKG = 'LocationPackage__c';
    public static final string PACKAGELCATIONSGMENT = 'Package_Location_Segment_Rel__c';
    public static final string PACKGE = 'Package__c';
    public static final string ARVSTANDALONEDENTAL = 'ARV_Standalone_Dental__c';
    public static final string PACKAGECARRIER ='Package_Carrier__c';
    public static final string GSCARRIER ='GA_Carrier__c';
    public static final string ACCOUNTTYPE='GA_Account_Type__c';
    private static final string HMO='HMO';
    private static final string LOCAL='Local';
    public static final string BCBS = 'BCBS';
    public static final string BCBSM = 'BCBSM';
    public static final string ARVCONTAINSHBA = 'ARV_Contains_HBA_Product__c';
    public static final string ARVBCNHRA = 'ARV_Contains_BCN_HRA__c';
    public static final string S_FALSE = 'false';
    public static final string S_TRUE = 'true'; 
    public static final string BCN = 'BCN';
    public static final string ARVCONTAINSBCNHSA = 'ARV_Contains_BCN_HSA__c';
    public static final string R_ID = 'Id';
    public static final string SRVNGSPOUSEOPTION = 'GA_Surviving_Spouse_Option__c';
    public static final string RETIREE_SRVNGSPOUSEOPTION = 'ARV_Retiree_Surviving_Spouse_Option__c';
    public static final string S_YES = 'Yes';
    public static final string S_NO = 'No';
    public static final string GA_GRP_EFFT_DATE ='GA_Group_Effective_Date__c';
    public static final string GA_MAIL_ICODE = 'GA_Mail_Instruction_Code__c';
    public static final string GA_BENFT_EFFT_DATE = 'GA_Benefit_Effective_Date__c';
    public static final string S_MEMBER = 'Member';
    public static final string S_GROUP = 'Group';
    public static final string ARV_GS_DENT_TYPE = 'ARV_GS_Dental_Type__c';
    public static final string S_VOLUNTARY = 'Voluntary';
    public static final string S_PEDIATRIC = 'Pediatric';
    public static final string S_ENHANCED = 'Enhanced';
    public static final string GA_HBA = 'GA_HBA__c';
    public static final string GA_HBA_LVL = 'GA_HBA_Level__c';
    public static final string ARV_BCN_HSA_MBR_OPTION = 'ARV_BCN_HSA_Member_Option__c';
    public static final string S_OPT_IN = 'Opt-In';
    public static final string S_OPT_OUT = 'Opt-Out';
    public static final string ARV_BCN_HSA = 'ARV_BCN_HSA__c';
    public static final string S_STANDARD = 'Standard';
    public static final string ARV_GS_VISION_TYPE = 'ARV_GS_Vision_Type__c';
    public static final string GA_IS_MASS_UPDATE ='GA_Is_Mass_Updating__c';
    public static final string S_S = 'S = Subscriber';
    public static final string S_G = 'G = Group';
    public static final string NETWORK = 'Network__c';
    public static final string MOS = 'MOS';
    public static final string DNTLVOLUNTARY = 'DentalVoluntary';
    public static final string DNTLPEDIATRIC = 'DentalPediatric';
    public static final string VSNVOLUNTARY = 'VisionVoluntary';
    public static final string VSNPEDIATRIC = 'VisionPediatric';
    public static final string DENTAL = 'Dental';
    public static final string VISION = 'Vision';
    public static final string ENROLLING = 'Enrolling';
    public static final string NOCDH = 'No CDH';
    public static final string ARV_VOLUNTARY_DENTAL = 'ARV_Contains_Voluntary_Dental__c';
    public static final string ARV_VOLUNTARY_VISION = 'ARV_Contains_Voluntary_Vision__c';
    public static final string CENSUS_MEMBER_COUNT = 'ARV_CF_CensusMember_Count__c';
    public static final string UNDERSCORE = '_';
    public static final string EMPTY_STRING = '';
    public static final string CONTRACT_QRY_STRING = ' from Contract where Id in ';
    public static final string PLSR_QRY_1 = 'ARV_CF_CensusMember_Count__c, Location_Segment__c,Package__c,Contract__c,';
    public static final string PLSR_QRY_2 = 'Package_Carrier__c from Package_Location_Segment_Rel__c where Contract__c in ';
    public static final string LOCATION_QRY_STRING = 'Id,ARV_ContractId__c,ARV_Detailed_HireRehire_Narrative__c  from LocationPackage__c where Id in ';
    public static final string PKG_QRY_STRING = 'Id,ARV_Contract_Id__c,ARV_Dental_Plan__c,'+
        'ARV_Tech_Dental_Voluntary_Contributory__c,ARV_Vision_Plan__c, '+
        'ARV_Tech_Vision_Voluntary_Contributory__c ,ARV_CDH_Package_Combination__c from Package__c where Id in ';
    public static final string GS_QRY_1 = 'ARV_ContractID__r.ARV_Sponsored_Plan_Acronym__r.Id'; 
    public static final string GS_QRY_2 = 'ARV_ContractID__r.ARV_Date_Submitted__c from GA_Group_Segment__c ';
    public static final string GS_QRY_3 = 'where id in ';
    public static final string CONTRACTQRY = ',ARV_Sponsored_Plan_Acronym__r.ARV_Association_Cluster_Code__c,ARV_RatingArea__c,ARV_Contract_Type__c,vlocity_ins__QuoteId__c,vlocity_ins__QuoteId__r.pedDentalAdded__c,vlocity_ins__EnrollmentCensusId__c,vlocity_ins__FinalRatingGroupCensusId__c,ARV_Freestanding_Dental__c,ARV_Freestanding_Vision__c, ARV_Spending_Account_Manager__c,ARV_ExistingDentalCoverage__c';
    public static final string WHEREACCAORLSTQRY = 'where GA_Account_Id__c in ';
    public static final string ANDWHEREACCAORLSTQRY = ' and GA_Service_End_Date__c >= Today ';
    public static final string LIMITACCAORLSTQRY = ' LIMIT 1' ; 
    public static final string LIMITCONLSTQRY = ' LIMIT 1000';
    public static final string LIMIT1RECD = ' LIMIT 1' ; 
    public static final string LIMIT1000RECD = ' LIMIT 1000' ; 
    public static final string DML_INSERT = 'insert';
    public static final string GRP_1 = 'Name, GA_Carrier__c,GA_Benefit_Effective_Date__c';
    public static final string GRP_2 = 'ARV_BCN_HSA__c,ARV_BCN_HRA__c,ARV_ContractID__c from GA_Group_Segment__C ';
    public static final string CNTCT_1 = 'Name, Agent_Code__c, CreatedDate FROM Contact ';
    public static final string AORQ_1 = 'GA_Contact_Id__c from GA_AOR__c ';
    public static final string BCN_HRA = 'ARV_BCN_HRA__c';
    public static final string GA_NEW_HIRE_ID = 'GA_New_Hire_Rehire_Option_Id__c';
    public static final string ARV_BCN_REHIRE = 'ARV_BCN_NewHire_Rehire_Code__c';  //changed from BCN_Final_Code__c
    public static final string ARV_BCBSM_REHIRE = 'ARV_BCBSM_NewHire_Rehire_Code__c';
    //public static final string GA_DETAILED ='GA_Detailed_Rehire_Narrative__c';
   // public static final string LP_DETAILED='ARV_Detailed_HireRehire_Narrative__c';
    public static final string DMLERROR ='DML Error';
    public static final string CNTRCTID ='ARV_ContractID__c';
    public static boolean errorOccured = False; 
    public static final string ISMASSUPDATING = 'GA_Is_Mass_Updating__c';
    private static final string STANDALONEVOLUNTY='Standalone Voluntary';
    private static final string STANDALONENONVOLUNTY='Standalone Non-Voluntary';
    private static final string DENTALVOLUNTRYCONTRIBUTORY='ARV_Tech_Dental_Voluntary_Contributory__c';
    private static final string PEDIATRIC='Pediatric';
    private static final string DENTALPLAN='ARV_Dental_Plan__c';
    Private static final string NODENTAL='No Dental';
    Private static final string NONVOLUNTRY ='Non-Voluntary';
    Private static final string VOLUNTRY ='Voluntary';
    private static final string VISIONPLAN='ARV_Vision_Plan__c';
    private static final string VISIONPLANCONTRIBUTORY='ARV_Tech_Vision_Voluntary_Contributory__c';
    Private static final string NOVISION='No Vision';
    private static final string IFENVAL='-';
    private static final string PLANPACKAGECOMB='ARV_PlanPackage_Combinations__c';
    public static final string GSCLUSTER='GA_Current_Cluster_Code__c';
    public static final string BCNCON='D720';
    public static final string BCBSMNULLCLU ='00';
    public static final string CLUSTERFIRSTCHAR='F';
    public static final string NASTRING='N/A';
    public static boolean contrctGrpSeg = false;
    public static final string GA_FUTURE_CLUSTER_CODE_MONTH ='GA_GFF_Renewal_Month__c';
    public static Map<String, String> monthsMap = new Map<String, String>{'January'=>'01',
        'February' => '02','March'=>'03','April' => '04','May'=>'05',
        'June' => '06','July'=>'07','August' => '08','September'=>'09',
        'October' => '10','November' => '11','December' => '12'};
    public static final string LOCATION_PHYSICAL_CITY_OTHER='GA_Physical_City_Other__c';
    public static final string LOCATION_BILLING_CITY_OTHER='GA_Billing_City_Other__c';
    public static final string LOCATION_MAILING_CITY_OTHER='GA_Mailing_City_Other__c';
    public static final string LOCATION_PHYSICAL_CITY='GA_Physical_City__c';
    public static final string LOCATION_BILLING_CITY='GA_Billing_City__c';
    public static final string LOCATION_MAILING_CITY='GA_Mailing_City__c';
    public static final string OTHER=system.label.ARV_CL_53_OtherCityID;
    public static final string PRODUCERISMANDTRYFLD='Producer is a Mandatory Field';
    public static final string SPONSOREDACRNMISMANDTRYFLD='Association Acronym is a Mandatory Field';
    //public static final string  PEDDENTALKEY='BCBSM-Pediatric-Non-Voluntary';
    public static final string VISIONVAR='Va;';
    public static final string GSAPPEALSLEVEL1 ='GA_Appeals_Level_1__c';
    public static final string  WITHOUTCDH='Without CDH';
    public static final string CDHPACKAGECOMBINATION='ARV_CDH_Package_Combination__c';
    public static final string PEDDENTALKEY1='BCBSM-Pediatric-Non-Voluntary-false-true';
     public static final string PEDDENTALKEY2='BCBSM-Pediatric-Voluntary-false-true';
        /**
@Description: createGroupSegmentRecords() method 
@Name : createGroupSegmentRecords
@Param : String contractId
@throws Exception : DML Exception
*/   
    public static void createGroupSegmentRecords(String contractId)
    {
        
         
        Set<id> contractIds = new Set<id>();
        try
        {
            contractIds.add(contractId);
            if(contractIds.size()>0)
            {
                list<ARV_ContractToGS_Config__mdt> contractGSMappingMetadata =[SELECT Label,ARV_ConRI_API_Name__c,ARV_Grp_Seg_API_Name__c,
                                                                               ARV_Object_Name__c FROM ARV_ContractToGS_Config__mdt ORDER BY Label ASC limit 100];
                string contrctQry=SLCTLBL;
                string locationPkgQuery=SLCTLBL;
                string pkgGSRelationQuery=SLCTLBL;
                string pkgGSQuery=SLCTLBL;
                for(ARV_ContractToGS_Config__mdt contractGSMap:contractGSMappingMetadata)
                {
                    if(contractGSMap.ARV_Object_Name__c.equals(CONTRACT))
                    {
                        contrctQry=contrctQry+contractGSMap.ARV_ConRI_API_Name__c+COMMAOP;
                    }
                    else if(contractGSMap.ARV_Object_Name__c.equals(LOCATIONPKG)) 
                    {
                        locationPkgQuery=locationPkgQuery+contractGSMap.ARV_ConRI_API_Name__c+COMMAOP;
                    }                 
                    else if(contractGSMap.ARV_Object_Name__c.equals(PACKAGELCATIONSGMENT)) 
                    {
                        pkgGSRelationQuery=pkgGSRelationQuery+contractGSMap.ARV_ConRI_API_Name__c+COMMAOP;
                    }
                    else if(contractGSMap.ARV_Object_Name__c.equals(PACKGE))
                    {
                        pkgGSQuery=pkgGSQuery+contractGSMap.ARV_ConRI_API_Name__c+COMMAOP;
                    }
                    else{
                        
                    }
                }
                
                string contractQry = contrctQry.removeEnd(COMMAOP)+CONTRACTQRY;
                string whereclause = CONTRACT_QRY_STRING + GA_Util08_FilterProcessHelper.idSet(contractIds);
                system.debug('contractQry::'+contractQry);
                system.debug('whereclause::'+whereclause);
                List<Contract> contractLst= ARV_AP07_QueryDataHelper.getsObjects(contractQry,whereclause,EMPTY_STRING,LIMIT1RECD);
                Boolean isPedDental=contractLst[0].vlocity_ins__QuoteId__r.pedDentalAdded__c;
                pkgGSRelationQuery = pkgGSRelationQuery + PLSR_QRY_1;
                pkgGSRelationQuery = pkgGSRelationQuery + PLSR_QRY_2;
                string wherepkgGSRelationQuery = GA_Util08_FilterProcessHelper.idSet(contractIds);
                List<Package_Location_Segment_Rel__c> pkgGSRelationLst= ARV_AP07_QueryDataHelper.getsObjects(pkgGSRelationQuery,
                                                                                                             wherepkgGSRelationQuery ,EMPTY_STRING,LIMIT1000RECD);
                if(pkgGSRelationLst!=null && pkgGSRelationLst.size()>0)
                {   
                    Map<String,String> plsrPackageLGMap = new Map<String,String>();
                    Set<id> locationSegmentIds = new Set<id>();
                    Set<id> packageIds = new Set<id>();
                    for(Package_Location_Segment_Rel__c eachPLSR:pkgGSRelationLst)
                    {
                        locationSegmentIds.add(eachPLSR.Location_Segment__c);
                        packageIds.add(eachPLSR.Package__c);
                        plsrPackageLGMap.put(eachPLSR.Id,eachPLSR.Package__c+UNDERSCORE+eachPLSR.Location_Segment__c);
                    }
                    string wherelocationPkgQuery = LOCATION_QRY_STRING + GA_Util08_FilterProcessHelper.idSet(locationSegmentIds);
                    List<LocationPackage__c> locPkgLst= ARV_AP07_QueryDataHelper.getsObjects(locationPkgQuery,
                                                                                             wherelocationPkgQuery,EMPTY_STRING,LIMIT1000RECD);
                    string wherepkgGSQuery = PKG_QRY_STRING + GA_Util08_FilterProcessHelper.idSet(packageIds);
                    List<Package__c> packageLst = ARV_AP07_QueryDataHelper.getsObjects(pkgGSQuery,wherepkgGSQuery,EMPTY_STRING,LIMIT1000RECD);
                    buildGroupSegmentRecProps(contractGSMappingMetadata, contractLst, locPkgLst, pkgGSRelationLst,packageLst,plsrPackageLGMap,isPedDental); 
                }
                
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CRTGS_METHODNAME, contractId);
            errorOccured= true;
        }        
    }
    
    /**
@Description: buildGroupSegmentRecProps() method 
@Name : buildGroupSegmentRecProps
@Param : list<ARV_ContractToGS_Config__mdt> contractGSMappingMetadata,List<Contract> contractLst,List<LocationPackage__c> locPkgLst,
List<Package_Location_Segment_Rel__c> pkgGSRelationLst,List<Package__c> packageLst,Map<String,String> plsrPackageLGMa
@throws Exception : DML Exception
*/ 
    public static void buildGroupSegmentRecProps(list<ARV_ContractToGS_Config__mdt> contractGSMappingMetadata,
                                                 List<Contract> contractLst,List<LocationPackage__c> locPkgLst,
                                                 List<Package_Location_Segment_Rel__c> pkgGSRelationLst, 
                                                 List<Package__c> packageLst,Map<String,String> plsrPackageLGMap,Boolean isPedDental)
    {   
        //added code for US2865
           Boolean freeStandingDental=contractLst[0].ARV_Freestanding_Dental__c;
           Boolean freeStandingVision=contractLst[0].ARV_Freestanding_Vision__c;
            String spendingAccManager=contractLst[0].ARV_Spending_Account_Manager__c;
          string contractPedDental=contractLst[0].ARV_ExistingDentalCoverage__c;
        // add code for us2637
        map<string,string> planCombKey=new map<string,string>();
        map<string,string> planCombKeyBCBS=new map<string,string>();
       for(ARV_CM06_PlanCombinations__mdt plc:[select id,ARV_Dental_Type__c,Plan_Combination__c,
                                               ARV_Plan_Type__c,ARV_Vision_Type__c,ARV_Freestanding_Dental__c,ARV_Freestanding_Vision__c from ARV_CM06_PlanCombinations__mdt limit 500]){
           if(plc.ARV_Plan_Type__c==BCN ||plc.ARV_Plan_Type__c==NULL){                                    
           string finalKey=plc.ARV_Plan_Type__c+IFENVAL+plc.ARV_Dental_Type__c+IFENVAL+plc.ARV_Vision_Type__c;
            planCombKey.put(finalKey,plc.Plan_Combination__c);
           }
             if(plc.ARV_Plan_Type__c==BCBSM){
               String finalKey1=plc.ARV_Plan_Type__c+IFENVAL+plc.ARV_Dental_Type__c+IFENVAL+plc.ARV_Vision_Type__c+IFENVAL+plc.ARV_Freestanding_Dental__c+IFENVAL+plc.ARV_Freestanding_Vision__c;
                planCombKeyBCBS.put(finalKey1,plc.Plan_Combination__c);
           }
                                                  
        }
        List<GA_Group_Segment__c> insertGSList = new List<GA_Group_Segment__c>();
        Set<Id> grpSegmentId = new set<Id>();
        LocationPackage__c locPkgLstSingle =  new LocationPackage__c();
        Package__c packageLstSingle = new Package__c(); 
        // Looping PLSR Records to create GS Records
        for (Package_Location_Segment_Rel__c eachPkgLocRecord : pkgGSRelationLst) {
            //Getting Location Segment and Package Id
            String[] locationPackageDetailSplitArray=plsrPackageLGMap.get(eachPkgLocRecord.Id).split(UNDERSCORE);
            String packageId = locationPackageDetailSplitArray[0]; 
            String locationSegmentId = locationPackageDetailSplitArray[1];  
            
            locPkgLstSingle =  new LocationPackage__c();
            packageLstSingle = new Package__c(); 
            
            for (LocationPackage__c eachLocationSegRec : locPkgLst) {               
                if(eachLocationSegRec.get(R_ID).equals(locationSegmentId))
                {
                    locPkgLstSingle = eachLocationSegRec;
                    break;
                }
            }   
            for (Package__c eachPakageSegRec : packageLst) {
                if(eachPakageSegRec.get(R_ID).equals(packageId))                
                {
                    packageLstSingle = eachPakageSegRec;
                    break;
                }
            }   
            String volDental=packageLstSingle.get(ARV_VOLUNTARY_DENTAL).toString();
            String volVision=packageLstSingle.get(ARV_VOLUNTARY_VISION).toString(); 
          //removed for us2914
           //if(eachPkgLocRecord.get(CENSUS_MEMBER_COUNT)!= Null && Integer.valueOf(eachPkgLocRecord.get(CENSUS_MEMBER_COUNT)) >= 1)
           // {
          
                 // add code for us2637
          String dentalType=(packageLstSingle.get(DENTALPLAN)==null ? NODENTAL : (packageLstSingle.get(DENTALVOLUNTRYCONTRIBUTORY)==VOLUNTRY ? VOLUNTRY :
(packageLstSingle.get(DENTALVOLUNTRYCONTRIBUTORY)==NONVOLUNTRY ? NONVOLUNTRY : PEDIATRIC)));
                String visionType=(packageLstSingle.get(VISIONPLAN)==null ? NOVISION:(packageLstSingle.get(VISIONPLANCONTRIBUTORY)==VOLUNTRY? VOLUNTRY : 
(packageLstSingle.get(VISIONPLANCONTRIBUTORY)==NONVOLUNTRY ? NONVOLUNTRY : PEDIATRIC)));
                 if(packageLstSingle.get(ARVSTANDALONEDENTAL) !=null && packageLstSingle.get(ARVSTANDALONEDENTAL).equals(true))
                {   
                    GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                           locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                    // add code for us2637
                    String isVoluntryOrNonVoluntry=(volDental.equals(S_TRUE))?STANDALONEVOLUNTY:STANDALONENONVOLUNTY;
                    newGrpSeg.put(ARV_GS_DENT_TYPE,isVoluntryOrNonVoluntry);
                     newGrpSeg.put(ARV_GS_VISION_TYPE,NOVISION);
                    String finalKeys=null+IFENVAL+isVoluntryOrNonVoluntry+IFENVAL+NOVISION;
                    newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKeys));
                    insertGSList.add(newGrpSeg);
                }
                else if(eachPkgLocRecord.get(PACKAGECARRIER).equals(BCBS) || eachPkgLocRecord.get(PACKAGECARRIER).equals(BCBSM))
                {
                    if(packageLstSingle.get(ARVCONTAINSHBA) !=null && packageLstSingle.get(ARVCONTAINSHBA).equals(false))
                    {
                        if(volDental.equals(S_FALSE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            // add code for us2637
                             newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType); 
                             newGrpSeg.put(ARV_GS_VISION_TYPE,visionType);
                            String finalKey=BCBSM+IFENVAL+dentalType+IFENVAL+visionType+IFENVAL+freeStandingDental+IFENVAL+freeStandingVision;
                            String finalValue = ((finalKey==PEDDENTALKEY1 || finalKey==PEDDENTALKEY2) &&(isPedDental || contractPedDental =='no')) ? planCombKeyBCBS.get(finalKey)+VISIONVAR :planCombKeyBCBS.get(finalKey);
                            newGrpSeg.put(PLANPACKAGECOMB,finalValue);
                            newGrpSeg.put(GSAPPEALSLEVEL1,BCBSM); //added this for US2922
                            insertGSList.add(newGrpSeg);
                        }
                        else if(volDental.equals(S_TRUE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                              // add code for us2637
                              newGrpSeg.put(ARV_GS_VISION_TYPE,visionType);
                             String finalKey1=BCBSM+IFENVAL+S_VOLUNTARY+IFENVAL+visionType+IFENVAL+freeStandingDental+IFENVAL+freeStandingVision;
                            String finalValue1 = ((finalKey1==PEDDENTALKEY1 || finalKey1==PEDDENTALKEY2) && (isPedDental || contractPedDental =='no')) ? planCombKeyBCBS.get(finalKey1)+VISIONVAR : planCombKeyBCBS.get(finalKey1);
                            newGrpSeg.put(PLANPACKAGECOMB,finalValue1);
                            newGrpSeg.put(GSAPPEALSLEVEL1,BCBSM); //added this for US2922
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                             newGrpSeg.put(ARV_GS_VISION_TYPE,visionType);
                            String finalKeys=BCBSM+IFENVAL+S_PEDIATRIC+IFENVAL+visionType+IFENVAL+freeStandingDental+IFENVAL+freeStandingVision;
                            String finalValue2 = ((finalKeys==PEDDENTALKEY1  || finalKeys==PEDDENTALKEY2) && (isPedDental || contractPedDental =='no')) ? planCombKeyBCBS.get(finalKeys)+VISIONVAR :planCombKeyBCBS.get(finalKeys);
                             newGrpSeg.put(PLANPACKAGECOMB,finalValue2);
                             newGrpSeg.put(GSAPPEALSLEVEL1,BCBSM); //added this for US2922
                            insertGSList.add(newGrpSeg);
                        }
                        else{
                            
                        }
                        
                    }
                    else if(packageLstSingle.get(ARVCONTAINSHBA) !=null && packageLstSingle.get(ARVCONTAINSHBA).equals(true))
                    {
                        if(volDental.equals(S_FALSE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, 
                                                                                   contractLst, locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(GA_HBA_LVL,S_ENHANCED);
                            newGrpSeg.put(GA_HBA,true); 
                            // add code for us2637
                                newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType); 
                             newGrpSeg.put(ARV_GS_VISION_TYPE,visionType);
                            
                             String finalKey2=BCBSM+IFENVAL+dentalType+IFENVAL+visionType+IFENVAL+freeStandingDental+IFENVAL+freeStandingVision;
                             String finalValue3 = ((finalKey2==PEDDENTALKEY1  || finalKey2==PEDDENTALKEY2) && (isPedDental || contractPedDental =='no')) ? planCombKeyBCBS.get(finalKey2)+VISIONVAR : planCombKeyBCBS.get(finalKey2);
                            newGrpSeg.put(PLANPACKAGECOMB,finalValue3);
                            newGrpSeg.put(GSAPPEALSLEVEL1,BCBSM); //added this for US2922
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(GA_HBA_LVL,S_STANDARD);
                            newGrpSeg.put(GA_HBA,true);
                            // add code for us2637
                               newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType); 
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType);
                            String finalKey3=BCBSM+IFENVAL+dentalType+IFENVAL+visionType+IFENVAL+freeStandingDental+IFENVAL+freeStandingVision;
                           String finalValue4= ((finalKey3==PEDDENTALKEY1  || finalKey3==PEDDENTALKEY2) && (isPedDental || contractPedDental =='no')) ? planCombKeyBCBS.get(finalKey3)+VISIONVAR : planCombKeyBCBS.get(finalKey3);
                            newGrpSeg.put(PLANPACKAGECOMB,finalValue4);
                            newGrpSeg.put(GSAPPEALSLEVEL1,BCBSM); //added this for US2922
                            insertGSList.add(newGrpSeg);
                        }
                        else if(volDental.equals(S_TRUE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(GA_HBA_LVL,S_ENHANCED);
                            newGrpSeg.put(GA_HBA,true);
                             // add code for us2637
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType);
                            String finalKey4=BCBSM+IFENVAL+S_VOLUNTARY+IFENVAL+visionType+IFENVAL+freeStandingDental+IFENVAL+freeStandingVision;
                        String finalValue5= ((finalKey4==PEDDENTALKEY1  || finalKey4==PEDDENTALKEY2)&& (isPedDental || contractPedDental =='no')) ? planCombKeyBCBS.get(finalKey4)+VISIONVAR : planCombKeyBCBS.get(finalKey4);
                            newGrpSeg.put(PLANPACKAGECOMB,finalValue5);
                            newGrpSeg.put(GSAPPEALSLEVEL1,BCBSM); //added this for US2922
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(GA_HBA_LVL,S_ENHANCED);
                            newGrpSeg.put(GA_HBA,true);
                              // add code for us2637
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType);
                            String finalKey5=BCBSM+IFENVAL+S_PEDIATRIC+IFENVAL+visionType+IFENVAL+freeStandingDental+IFENVAL+freeStandingVision;
                           String finalValue6= ((finalKey5==PEDDENTALKEY1 || finalKey5==PEDDENTALKEY2) &&(isPedDental || contractPedDental =='no')) ? planCombKeyBCBS.get(finalKey5)+VISIONVAR : planCombKeyBCBS.get(finalKey5);
                            newGrpSeg.put(PLANPACKAGECOMB,finalValue6);
                            newGrpSeg.put(GSAPPEALSLEVEL1,BCBSM); //added this for US2922
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(GA_HBA_LVL,S_STANDARD);
                            newGrpSeg.put(GA_HBA,true);
                             // add code for us2637
                             newGrpSeg.put(ARV_GS_VISION_TYPE,visionType);
                            String finalKey6=BCBSM+IFENVAL+S_VOLUNTARY+IFENVAL+visionType+IFENVAL+freeStandingDental+IFENVAL+freeStandingVision;
                           String finalValue7= ((finalKey6==PEDDENTALKEY1  || finalKey6==PEDDENTALKEY2) && (isPedDental || contractPedDental =='no')) ? planCombKeyBCBS.get(finalKey6)+VISIONVAR :planCombKeyBCBS.get(finalKey6);
                            newGrpSeg.put(PLANPACKAGECOMB,finalValue7);
                            newGrpSeg.put(GSAPPEALSLEVEL1,BCBSM); //added this for US2922
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(GA_HBA_LVL,S_STANDARD);
                            newGrpSeg.put(GA_HBA,true);
                             // add code for us2637
                             newGrpSeg.put(ARV_GS_VISION_TYPE,visionType);
                             String finalKey7=BCBSM+IFENVAL+S_PEDIATRIC+IFENVAL+visionType+IFENVAL+freeStandingDental+IFENVAL+freeStandingVision;
                             String finalValue8= ((finalKey7==PEDDENTALKEY1  || finalKey7==PEDDENTALKEY2) && (isPedDental || contractPedDental =='no')) ? planCombKeyBCBS.get(finalKey7)+VISIONVAR :planCombKeyBCBS.get(finalKey7);
                            newGrpSeg.put(PLANPACKAGECOMB,finalValue8);
                            newGrpSeg.put(GSAPPEALSLEVEL1,BCBSM); //added this for US2922
                            insertGSList.add(newGrpSeg);
                        }
                        else{
                            
                        }
                    }
                    else{
                        
                    }
                }
                else if(eachPkgLocRecord.get(PACKAGECARRIER).equals(BCN))
                {
                    if(packageLstSingle.get(ARVCONTAINSBCNHSA) !=null && packageLstSingle.get(ARVCONTAINSBCNHSA).equals(true) && packageLstSingle.get(CDHPACKAGECOMBINATION)=='Health Savings Account' )
                    { 
                        if(volDental.equals(S_FALSE) && volVision.equals(S_FALSE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_OUT);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            // add code for us2637
                            newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType); 
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType); 
                            String finalKey8=BCN+IFENVAL+dentalType+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey8));
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_IN);                           
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            // add code for us2637
                              newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType); 
                              newGrpSeg.put(ARV_GS_VISION_TYPE,visionType); 
                            String finalKey9=BCN+IFENVAL+dentalType+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey9));
                            insertGSList.add(newGrpSeg);
                        }
                        else if(volDental.equals(S_TRUE)&& volVision.equals(S_FALSE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_IN);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            // add code for us2637
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType); 
                            String finalKey10=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey10));
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_IN);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            // add code for us2637
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType); 
                            String finalKeys11=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKeys11));
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_OUT);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            // add code for us2637
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType); 
                             String finalKey11=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey11));
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_OUT);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType); 
                             String finalKey12=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey12));
                            insertGSList.add(newGrpSeg);
                            
                        }
                        else if(volVision.equals(S_TRUE) && volDental.equals(S_FALSE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_IN);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                            newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType);
                            String finalKey13=BCN+IFENVAL+dentalType+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey13));
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_IN);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                            newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType);
                            String finalKey14=BCN+IFENVAL+dentalType+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey14));
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_OUT);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                            newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType);
                            String finalKey15=BCN+IFENVAL+dentalType+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey15));
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_OUT);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                            newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType);
                            String finalKey16=BCN+IFENVAL+dentalType+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey16));
                            insertGSList.add(newGrpSeg);
                        }
                        else if(volVision.equals(S_TRUE) && volDental.equals(S_TRUE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_IN);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                             String finalKey17=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey17));
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_IN);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                            String finalKey18=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey18));
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_OUT);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                           String finalKey19=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey19)); 
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_OUT);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                              String finalKey20=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey20));
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_IN);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                              String finalKey21=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey21));
                            insertGSList.add(newGrpSeg);   
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_IN);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                             String finalKey22=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey22));
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_OUT);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                            String finalKey23=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey23));
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,S_OPT_OUT);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                             String finalKey24=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey24));
                            insertGSList.add(newGrpSeg);
                        }
                        else{
                            
                        }
                    }   
                    //added for US3589
                     if(packageLstSingle.get(ARVCONTAINSBCNHSA) !=null && packageLstSingle.get(ARVCONTAINSBCNHSA).equals(true) && packageLstSingle.get(CDHPACKAGECOMBINATION)==null)
                    { 
                        if(volDental.equals(S_FALSE) && volVision.equals(S_FALSE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,WITHOUTCDH);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            // add code for us2637
                            newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType); 
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType); 
                            String finalKey8=BCN+IFENVAL+dentalType+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey8));
                            insertGSList.add(newGrpSeg);
                            
                        }
                        else if(volDental.equals(S_TRUE)&& volVision.equals(S_FALSE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,WITHOUTCDH);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            // add code for us2637
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType); 
                            String finalKey10=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey10));
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,WITHOUTCDH);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            // add code for us2637
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType); 
                            String finalKeys11=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKeys11));
                            insertGSList.add(newGrpSeg);
                            
                        }
                        else if(volVision.equals(S_TRUE) && volDental.equals(S_FALSE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,WITHOUTCDH);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                            newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType);
                            String finalKey13=BCN+IFENVAL+dentalType+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey13));
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,WITHOUTCDH);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                            newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType);
                            String finalKey14=BCN+IFENVAL+dentalType+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey14));
                            insertGSList.add(newGrpSeg);
                           
                        }
                        else if(volVision.equals(S_TRUE) && volDental.equals(S_TRUE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,WITHOUTCDH);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                             String finalKey17=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey17));
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,WITHOUTCDH);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                            String finalKey18=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey18));
                            insertGSList.add(newGrpSeg);
                            
                                                        //***********************************************
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,WITHOUTCDH);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                              String finalKey21=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey21));
                            insertGSList.add(newGrpSeg);   
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_BCN_HSA_MBR_OPTION,WITHOUTCDH);
                            newGrpSeg.put(ARV_BCN_HSA,true);
                            //add code for us2637
                             String finalKey22=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey22));
                            insertGSList.add(newGrpSeg);
                           } else{  }
                  }   
//END US3589
                    else if(packageLstSingle.get(ARVCONTAINSBCNHSA) !=null && packageLstSingle.get(ARVCONTAINSBCNHSA).equals(false))
                    {
                        if(volDental.equals(S_FALSE) && volVision.equals(S_FALSE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            //add code for us2637
                            newGrpSeg.put(ARV_GS_VISION_TYPE,visionType);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType);
                             String finalKey25=BCN+IFENVAL+dentalType+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey25));
                            insertGSList.add(newGrpSeg);
                        }
                        else if(volDental.equals(S_TRUE)&& volVision.equals(S_FALSE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                             //add code for us2637
                              newGrpSeg.put(ARV_GS_VISION_TYPE,visionType);
                             String finalKey26=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey26));
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                             newGrpSeg.put(ARV_GS_VISION_TYPE,visionType); 
                            //add code for us2637
                            String finalKey27=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+visionType;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey27));
                            insertGSList.add(newGrpSeg);
                        }
                        else if(volVision.equals(S_TRUE) && volDental.equals(S_FALSE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                             //add code for us2637
                                newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType);
                            String finalKey28=BCN+IFENVAL+dentalType+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey28));
                            insertGSList.add(newGrpSeg);
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            //add code for us2637
                                newGrpSeg.put(ARV_GS_DENT_TYPE,dentalType);
                            String finalKey29=BCN+IFENVAL+dentalType+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey29));
                            insertGSList.add(newGrpSeg);
                        }
                        else if(volVision.equals(S_TRUE) && volDental.equals(S_TRUE))
                        {
                            GA_Group_Segment__c newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                                                   locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                           //add code for us2637
                            String finalKey30=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey30));
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            //add code for us2637
                            String finalKey31=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey31));
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_VOLUNTARY);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_PEDIATRIC);
                            //add code for us2637
                            String finalKey32=BCN+IFENVAL+S_PEDIATRIC+IFENVAL+S_VOLUNTARY;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey32));
                            insertGSList.add(newGrpSeg);
                            
                            newGrpSeg = buildPropsFromMetadata(contractGSMappingMetadata, contractLst, 
                                                               locPkgLstSingle,eachPkgLocRecord,packageLstSingle);
                            newGrpSeg.put(ARV_GS_VISION_TYPE,S_PEDIATRIC);
                            newGrpSeg.put(ARV_GS_DENT_TYPE,S_VOLUNTARY);
                            //add code for us2637
                            String finalKey33=BCN+IFENVAL+S_VOLUNTARY+IFENVAL+S_PEDIATRIC;
                            newGrpSeg.put(PLANPACKAGECOMB,planCombKey.get(finalKey33));
                            insertGSList.add(newGrpSeg);
                        }
                        else{
                            
                        }
                        
                    }
                    else{
                        
                    }
                }
                else{
                    
                }
            //}
        }
        
        try{
            if(insertGSList.size()>0)
            { 
                contrctGrpSeg = true;
                string grpsSgmntListQry = SLCTLBL + R_ID + COMMAOP;
                grpsSgmntListQry = grpsSgmntListQry +GRP_1 +COMMAOP;
                grpsSgmntListQry = grpsSgmntListQry + GRP_2 ;
                database.insert(insertGSList);
                //ARV_AP100_AccountEnrollmentDatesUpdation.updateAccOrigandCurrEnrollDate(insertGSList);
                //_delete.updateAccountonGS(insertGSList);//for US3020
                List<GA_Group_Segment__C> grpsSgmntList = new List<GA_Group_Segment__C>();
                for (GA_Group_Segment__C grpsegment : insertGSList){
                    grpSegmentId.add(grpsegment.Id);
                }
               string wheregrpSegmentQry = GS_QRY_3 +GA_Util08_FilterProcessHelper.idSet(grpSegmentId);
                grpsSgmntList = ARV_AP07_QueryDataHelper.getsObjects(grpsSgmntListQry,wheregrpSegmentQry,EMPTY_STRING,LIMITCONLSTQRY);
                
                if(!errorOccured)
                {
                    createGroupSegmentAssociation (grpSegmentId,contractLst[0].id);
                }
                if(!errorOccured)
                {
                    createNewAOR(contractLst[0].AccountId,contractLst[0].vlocity_ins__ProducerId__c,grpsSgmntList,contractLst[0].id);                
                }
                if(!errorOccured)
                {
                    updateCensusMem(contractLst[0].Id); 
                }
                if(!errorOccured)
                {                    
                    ARV_AP88_GroupSegmentPackageCreation.createSystemCensus(contractLst[0]);
                    ARV_AP88_GroupSegmentPackageCreation.groupSegmentRec(grpsSgmntList);
                    ARV_AP62_ContractCreateWorkflow.updtCntrctStatus(grpsSgmntList,contractLst[0],contractLst[0].AccountId);
                }
                                
            }
            // TO avoid common control records being created during GS failure    
            if(!errorOccured)
            {        
                ARV_AP58_ApproveContract.commonControlCreate(contractLst[0].Id);
            }
        }
        Catch(Exception e){
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, BUILD_GS_REC_METHOD, contractLst[0].Id);
            errorOccured= true;
        }        
    }
    
    /**
@Description: buildPropsFromMetadata() method 
@Name : buildPropsFromMetadata
@Param : list<ARV_ContractToGS_Config__mdt> contractGSMappingMetadata,
List<Contract> contractLst,LocationPackage__c locPkgLstSingle,
Package_Location_Segment_Rel__c eachPLSR,Package__c packageLstSingle
@Return : GA_Group_Segment__c newGrpSeg
@throws Exception : DML Exception
*/ 
    public static GA_Group_Segment__c buildPropsFromMetadata(list<ARV_ContractToGS_Config__mdt> contractGSMappingMetadata,
                                                             List<Contract> contractLst,LocationPackage__c locPkgLstSingle,
                                                             Package_Location_Segment_Rel__c eachPLSR,Package__c packageLstSingle)
    { 
        GA_Group_Segment__c newGrpSeg = new GA_Group_Segment__c();
        try
        {
            for(ARV_ContractToGS_Config__mdt contractGSMap:contractGSMappingMetadata)
            {
                if(contractGSMap.ARV_Object_Name__c.equals(CONTRACT))
                {                 
                    if(contractLst[0].get(contractGSMap.ARV_ConRI_API_Name__c) !=null)
                    {
                        if(contractGSMap.ARV_Grp_Seg_API_Name__c == SRVNGSPOUSEOPTION && 
                           contractLst[0].get(RETIREE_SRVNGSPOUSEOPTION).toString() == S_YES)
                        {
                            newGrpSeg.put(contractGSMap.ARV_Grp_Seg_API_Name__c,True);
                        }
                        else if (contractGSMap.ARV_Grp_Seg_API_Name__c == SRVNGSPOUSEOPTION && 
                                 contractLst[0].get(RETIREE_SRVNGSPOUSEOPTION).toString() == S_NO)
                        {
                            newGrpSeg.put(contractGSMap.ARV_Grp_Seg_API_Name__c,False);
                        }
                        else{
                            newGrpSeg.put(contractGSMap.ARV_Grp_Seg_API_Name__c,contractLst[0].get(contractGSMap.ARV_ConRI_API_Name__c));
                        }
                    }                    
                }
                else if(contractGSMap.ARV_Object_Name__c.equals(LOCATIONPKG)) 
                {  
                    if(locPkgLstSingle.get(contractGSMap.ARV_ConRI_API_Name__c) !=null)
                    {
                        newGrpSeg.put(contractGSMap.ARV_Grp_Seg_API_Name__c,locPkgLstSingle.get(contractGSMap.ARV_ConRI_API_Name__c));
                    }  
                }
                else if(contractGSMap.ARV_Object_Name__c.equals(PACKAGELCATIONSGMENT)) 
                {  
                    if(eachPLSR.get(contractGSMap.ARV_ConRI_API_Name__c) !=null)
                    {
                        newGrpSeg.put(contractGSMap.ARV_Grp_Seg_API_Name__c,eachPLSR.get(contractGSMap.ARV_ConRI_API_Name__c));
                    }  
                }
                else{
                    
                }
            }
            newGrpSeg.put(ISMASSUPDATING,true);
            newGrpSeg = performGSTransformations(newGrpSeg,eachPLSR,packageLstSingle,locPkgLstSingle,contractLst[0]);
        }
        Catch(Exception e){
            system.debug('Error at Line????'+e.getLineNumber());
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, BUILD_PROP_MDATA_METHOD, contractLst[0].id); 
            errorOccured= true;
        }    
        return newGrpSeg;
        
    }
    
    /**
@Description: performGSTransformations() method 
@Name : performGSTransformations
@Param : GA_Group_Segment__c newGrpSeg,Package_Location_Segment_Rel__c packageLstSingle
@Return : GA_Group_Segment__c newGrpSeg
@throws Exception : DML Exception
*/ 
    public static GA_Group_Segment__c performGSTransformations(GA_Group_Segment__c newGrpSeg,
                                                               Package_Location_Segment_Rel__c eachPLSR, Package__c packageLstSingle, 
                                                               LocationPackage__c locPkgLstSingle,Contract con)
    {
        string contractID =  String.valueOf(newGrpSeg.get(CNTRCTID)) ;
        TRY{
            if(newGrpSeg.get(GA_GRP_EFFT_DATE) !=null)
            {
                newGrpSeg.put(GA_BENFT_EFFT_DATE,newGrpSeg.get(GA_GRP_EFFT_DATE));
            }
            if(newGrpSeg.get(GA_FUTURE_CLUSTER_CODE_MONTH) !=null)
            {
                String monthName =  String.valueof(newGrpSeg.get(GA_FUTURE_CLUSTER_CODE_MONTH));
                newGrpSeg.put(GA_FUTURE_CLUSTER_CODE_MONTH,convertMonthTextToNumber(monthName));
            }
            if(newGrpSeg.get(LOCATION_PHYSICAL_CITY_OTHER) !=null)
            {
                newGrpSeg.put(LOCATION_PHYSICAL_CITY,OTHER);
            }
            if(newGrpSeg.get(LOCATION_BILLING_CITY_OTHER) !=null)
            {
                newGrpSeg.put(LOCATION_BILLING_CITY,OTHER);
            }
            if(newGrpSeg.get(LOCATION_MAILING_CITY_OTHER) !=null)
            {
                newGrpSeg.put(LOCATION_MAILING_CITY,OTHER);
            }
            if(newGrpSeg.get(GA_MAIL_ICODE)!=null)
            {
                if(newGrpSeg.get(GA_MAIL_ICODE).equals(S_MEMBER))
                {
                    newGrpSeg.put(GA_MAIL_ICODE,S_S);
                }
                else if(newGrpSeg.get(GA_MAIL_ICODE).equals(S_GROUP))
                {
                    newGrpSeg.put(GA_MAIL_ICODE,S_G);
                }
                else{
                    
                }
            }
            if(eachPLSR.get(PACKAGECARRIER) !=null)
            {
                if(eachPLSR.get(PACKAGECARRIER).equals(BCN))
                {
                    newGrpSeg.put(ACCOUNTTYPE,HMO);
                    newGrpSeg.put(GSCARRIER,BCN);
                    newGrpSeg.put(GSCLUSTER,BCNCON);
                    //newGrp.Seg.put('GA_New_Hire_Rehire_Option_Id__c ','');
                    newGrpSeg.put(NETWORK,BCN);
                    //newGrpSeg.put(GA_NEW_HIRE_ID,locPkgLstSingle.get(ARV_BCN_REHIRE));
                  // newGrpSeg.put(GA_DETAILED,locPkgLstSingle.get(LP_DETAILED));

                    if(packageLstSingle.get(ARVBCNHRA) !=null && packageLstSingle.get(ARVBCNHRA).equals(true)){
                        newGrpSeg.put(BCN_HRA,True);
                    }
                }
                else if(eachPLSR.get(PACKAGECARRIER).equals(BCBS) || eachPLSR.get(PACKAGECARRIER).equals(BCBSM))
                {
                    String tempValue = con.ARV_Sponsored_Plan_Acronym__r.ARV_Association_Cluster_Code__c!=null?
                        con.ARV_Sponsored_Plan_Acronym__r.ARV_Association_Cluster_Code__c : BCBSMNULLCLU;
                    String code = con.ARV_RatingArea__c!=null? con.ARV_RatingArea__c+tempValue : tempValue;
                    String codeFinal = CLUSTERFIRSTCHAR+code;
                    newGrpSeg.put(ACCOUNTTYPE,LOCAL);
                    newGrpSeg.put(GSCARRIER,BCBSM);
                    //newGrpSeg.put('GA_New_Hire_Rehire_Option_Id__c','');
                    newGrpSeg.put(GSCLUSTER,codeFinal);
                    newGrpSeg.put(NETWORK,MOS);
                    newGrpSeg.put(GA_NEW_HIRE_ID,locPkgLstSingle.get(ARV_BCBSM_REHIRE));
                    //newGrpSeg.put(GA_DETAILED,locPkgLstSingle.get(LP_DETAILED));

                }
                else{
                    
                }
            }
            
            
        }
        catch(Exception EXCPTN){
            GA_LogExceptionCls.LogExcpContract(EXCPTN, CLSNAME, PERFORMGSTTRANS_METHOD, contractID); 
            errorOccured= true;
        }        
        return newGrpSeg;
    }
    
    /**
@Description: convertMonthTextToNumber() method 
@Name : convertMonthTextToNumber
@Param : String month
@Return : String month

*/ 
    private static String convertMonthTextToNumber(String month)
    {
        return monthsMap.get( month );
    }
    
    //create GS Association Records
    
    /**
@Description: createGroupSegmentAssociation() method 
@Name : createGroupSegmentAssociation
@Param : List <Id> lstGroupSegmentId 
@Return : List<GA_Group_Association__c>
@throws Exception : DML Exception
*/   
    public static List<GA_Group_Association__c> createGroupSegmentAssociation(set <Id> setGroupSegmentId,string cntrctId){
        List <GA_Group_Association__c>lstGroupSegmentAssociation = new List<GA_Group_Association__c>();
        string grpSegmentQry = SLCTLBL +R_ID+ COMMAOP;
        grpSegmentQry = grpSegmentQry +GS_QRY_1 +COMMAOP;
        grpSegmentQry = grpSegmentQry +GS_QRY_2 ;
        string wheregrpSegmentQry = GS_QRY_3 + GA_Util08_FilterProcessHelper.idSet(setGroupSegmentId);
        List <GA_Group_Segment__c> lstGAGrpSgment = ARV_AP07_QueryDataHelper.getsObjects(grpSegmentQry,
                                                                                         wheregrpSegmentQry,EMPTY_STRING,LIMITCONLSTQRY);
         if (lstGAGrpSgment.size()>0 && !lstGAGrpSgment.isempty()){
            GA_Group_Association__c gaGrpAssciation = new GA_Group_Association__c();
            for (GA_Group_Segment__c Gs : lstGAGrpSgment){
                if(Gs.ARV_ContractID__r.ARV_Sponsored_Plan_Acronym__r.Id==null )
                {
                    //GA_LogExceptionCls.LogExcpContractMsges(SPONSOREDACRNMISMANDTRYFLD, CLSNAME, CREAT_GSA_METHOD, cntrctId); 
                }
                else{
                    gaGrpAssciation = new GA_Group_Association__c();
                    gaGrpAssciation.GA_Account__c = Gs.ARV_ContractID__r.ARV_Sponsored_Plan_Acronym__r.Id;
                    gaGrpAssciation.GA_Group_Segment__c = Gs.id;
                    gaGrpAssciation.GA_Start_Date__c = system.Today();
                    gaGrpAssciation.ARV_Is_Mass_Updating__c = true;
                    lstGroupSegmentAssociation.add(gaGrpAssciation);
                }             
            }
        }
        try{
            if (!lstGroupSegmentAssociation.isempty() && lstGroupSegmentAssociation.size()>0){
                database.insert(lstGroupSegmentAssociation);
            }
        }catch(system.DmlException dmex){
            GA_LogExceptionCls.LogExcpContract(dmex, CLSNAME, CREAT_GSA_METHOD, cntrctId);
            errorOccured= true;
        }      
        return lstGroupSegmentAssociation;
    }
    /**
@Description: createNewAOR() method 
@Name : createNewAOR
@Param : List <GA_Group_Segment__c> GrpLst 
@Return : String aorAgntId
@throws Exception : DML Exception
*/    
    public static void createNewAOR(String accRec,String aorAgntId,List<GA_Group_Segment__c> GrpLst, string cntrctId){
        try{
            if(aorAgntId==null || aorAgntId.equals(EMPTY_STRING))
            {
                GA_LogExceptionCls.LogExcpContractMsges(PRODUCERISMANDTRYFLD, CLSNAME, CREATENEWAOR_METHOD, cntrctId); 
                //errorOccured = true;
            }
            else{
            list<GA_AOR__c> accAORLst = new list<GA_AOR__c>();
            list<GA_AOR__c> aorList = new list<GA_AOR__c>();
            list<GA_AOR__c> updatedaorlst = new list<GA_AOR__c>();
            GA_AOR__c aorRec = New GA_AOR__c();
            GA_AOR_Group_Segment__c newAorGs = New GA_AOR_Group_Segment__c();
            set<id>aorAgntIdSet = new set<Id>();
            aorAgntIdset.add(aorAgntId);
            set<id> accRecSet = new set<id>();
            accRecSet.add(accRec);
            List<GA_AOR_Group_Segment__c> newAorGsLst = New  List<GA_AOR_Group_Segment__c>();
            string conListQry = SLCTLBL + R_ID + COMMAOP;
            conListQry = conListQry + CNTCT_1;
            string whereconListQry = GS_QRY_3 +GA_Util08_FilterProcessHelper.idSet(aorAgntIdSet);
            List<Contact> conList = ARV_AP07_QueryDataHelper.getsObjects(conListQry,whereconListQry,EMPTY_STRING,LIMITACCAORLSTQRY);
            string accAORLstQry = SLCTLBL + R_ID + COMMAOP;
            accAORLstQry = accAORLstQry + AORQ_1 ;
            string whereAORLstquery = WHEREACCAORLSTQRY + GA_Util08_FilterProcessHelper.idSet(accRecSet)+
                ANDWHEREACCAORLSTQRY; 
            accAORLst= ARV_AP07_QueryDataHelper.getsObjects(accAORLstQry,whereAORLstquery,EMPTY_STRING,LIMITACCAORLSTQRY);
           if(accAORLst.size() > 0){
                for(GA_AOR__c currAor : accAORLst){
                    if(accAORLst[0].GA_Contact_Id__c == aorAgntId ){
                        for(GA_Group_Segment__c gs: GrpLst ){
                            newAorGs = New GA_AOR_Group_Segment__c();
                            newAorGs.Name = conList[0].Name + gs.Name + conList[0].CreatedDate;
                            newAorGs.GA_AOR_Id__c = accAORLst[0].id;
                            newAorGs.GA_Group_Segment_Id__c = gs.id; 
                            newAorGs.GA_Is_Mass_Updating__c = true;
                            newAorGsLst.add(newAorGs);
                        }
                    }
                    else{
                        aorRec.Name= conList[0].Name + conList[0].Agent_Code__c + conList[0].CreatedDate;
                        aorRec.GA_Account_Id__c=accRec;
                        aorRec.GA_Contact_Id__c=aorAgntId;
                        aorRec.GA_Commission_Start_Date__c=(GrpLst[0].GA_Benefit_Effective_Date__c <> null ? 
                                                            GrpLst[0].GA_Benefit_Effective_Date__c : system.today() );
                        aorRec.GA_Commission_End_Date__c = date.parse(system.label.ARV_Commission_End_Date);
                        aorRec.GA_Service_Start_Date__c=  system.today();
                        aorList.add(aorRec);
                         for(GA_Group_Segment__c gs: GrpLst ){
                            newAorGs = New GA_AOR_Group_Segment__c();
                            newAorGs.Name = conList[0].Name + gs.Name + conList[0].CreatedDate;
                            newAorGs.GA_AOR_Id__c = aorRec.id;
                            newAorGs.GA_Group_Segment_Id__c = gs.id; 
                            newAorGs.GA_Is_Mass_Updating__c = true;
                            newAorGsLst.add(newAorGs);
                        }
                        
                    }  
                }
                if(aorList.size() > 0){
                database.insert(aorList);
                }
                
                
            }
            else{
                aorRec.Name= conList[0].Name + conList[0].Agent_Code__c + conList[0].CreatedDate;
                aorRec.GA_Account_Id__c=accRec;
                aorRec.GA_Contact_Id__c=aorAgntId;
                aorRec.GA_Commission_Start_Date__c= (GrpLst[0].GA_Benefit_Effective_Date__c <> null ? 
                                                     GrpLst[0].GA_Benefit_Effective_Date__c : system.today() );
                aorRec.GA_Commission_End_Date__c = date.parse(system.label.ARV_Commission_End_Date);
                aorRec.GA_Service_Start_Date__c=  system.today();
                updatedaorlst.add(aorRec);
               database.insert(updatedaorlst);
                for(GA_Group_Segment__c gs: GrpLst ){
                    newAorGs = New GA_AOR_Group_Segment__c();
                    newAorGs.Name = conList[0].Name + gs.Name + conList[0].CreatedDate;
                    newAorGs.GA_AOR_Id__c = aorRec.id;
                    newAorGs.GA_Group_Segment_Id__c = gs.id;  
                    newAorGs.GA_Is_Mass_updating__c = true;
                    newAorGsLst.add(newAorGs);
                }
            }
            
            if(newAorGsLst.size() > 0){
            database.insert(newAorGsLst);
            }
            }
        }
        catch(Exception excp){
            GA_LogExceptionCls.LogExcpContract(excp, CLSNAME, CREATENEWAOR_METHOD, cntrctId); 
            errorOccured= true;
        }
    }
    
    /**
@Description: updateCensusMem() method 
@Name : updateCensusMem
@Param : List <GA_Group_Segment__c> GrpLst 
@Return : String aorAgntId
@throws Exception : DML Exception
*/     
    public static void updateCensusMem(Id conId){
        try{
            Map<id,List<GA_Group_Segment__c>> plsrGsMap = new Map<id,List<GA_Group_Segment__c>>();
            Map<String,id> bCBSMMap = new Map<String,id>();
            Map<String,id> bCNMMap = new Map<String,id>();
            Map<Id,Id> censusGS = new Map<Id,Id>();
            List<vlocity_ins__GroupCensusMember__c> updateMbrs = new List<vlocity_ins__GroupCensusMember__c>();
            Contract con = [select id,name,StartDate,vlocity_ins__EnrollmentCensusId__c from Contract where id=: conId limit 1];
            Date endDate = date.newinstance(2099, 12, 31);
            for(GA_Group_Segment__c gsgmnt : [select id,ARV_GS_Dental_Type__c,ARV_GS_Vision_Type__c,GA_HBA_Level__c,
                                              ARVPackage_Location_Segment_Relationship__c,ARV_BCN_HSA_Member_Option__c,
                                              ARVPackage_Location_Segment_Relationship__r.Package_Carrier__c from GA_Group_Segment__c 
                                              where GA_HBA_Level__c !=: S_STANDARD and ARV_ContractID__c =: conId limit 500]){
                if(!plsrGsMap.containskey(gsgmnt.ARVPackage_Location_Segment_Relationship__c)){                         
                    plsrGsMap.put(gsgmnt.ARVPackage_Location_Segment_Relationship__c,new List<GA_Group_Segment__c>());
                }
                plsrGsMap.get(gsgmnt.ARVPackage_Location_Segment_Relationship__c).add(gsgmnt);
                                                  
                String temp = gsgmnt.ARVPackage_Location_Segment_Relationship__c;
                if(gsgmnt.ARVPackage_Location_Segment_Relationship__r.Package_Carrier__c == BCBS && 
                    gsgmnt.ARV_GS_Dental_Type__c !=NODENTAL){
                    temp = temp+gsgmnt.ARV_GS_Dental_Type__c;                    
                    temp= gsgmnt.GA_HBA_Level__c != null ? temp+gsgmnt.GA_HBA_Level__c:temp;
                    bCBSMMap.put(temp,gsgmnt.Id);
                }
                else if(gsgmnt.ARVPackage_Location_Segment_Relationship__r.Package_Carrier__c == BCN && 
                            (gsgmnt.ARV_GS_Dental_Type__c!=NODENTAL || gsgmnt.ARV_GS_Vision_Type__c!=NOVISION) &&
                    gsgmnt.ARV_BCN_HSA_Member_Option__c == null){
                    temp = gsgmnt.ARV_GS_Dental_Type__c!=NODENTAL? temp+gsgmnt.ARV_GS_Dental_Type__c:temp;
                    temp = gsgmnt.ARV_GS_Vision_Type__c!=NOVISION? temp+gsgmnt.ARV_GS_Vision_Type__c:temp;
                    bCNMMap.put(temp,gsgmnt.Id);
                }
                else if(gsgmnt.ARVPackage_Location_Segment_Relationship__r.Package_Carrier__c == BCN && 
                        (gsgmnt.ARV_GS_Dental_Type__c!=NODENTAL || gsgmnt.ARV_GS_Vision_Type__c!=NOVISION) &&
                        gsgmnt.ARV_BCN_HSA_Member_Option__c != null ){
                                                                              
                    temp=gsgmnt.ARV_BCN_HSA_Member_Option__c!=null? temp+gsgmnt.ARV_BCN_HSA_Member_Option__c:temp;
                    temp=gsgmnt.ARV_GS_Dental_Type__c!=NODENTAL? temp+gsgmnt.ARV_GS_Dental_Type__c:temp;
                    temp = gsgmnt.ARV_GS_Vision_Type__c!=NOVISION? temp+gsgmnt.ARV_GS_Vision_Type__c:temp;
                    bCNMMap.put(temp,gsgmnt.Id);                           
                }else{}
                                                  
            }
            for(vlocity_ins__GroupCensusMember__c mem: [select id,ARV_Is_Dental_Selected__c,ARV_Is_Vision_Selected__c,
                                                        ARV_Group_Segment__c,ARV_Census_Member_Selected_Package__c,
                                                        ARV_Package__r.ARV_Contains_HBA_Product__c,
                                                        ARV_Package__r.ARV_Contains_BCN_HSA__c,ARV_CDH_Member__c,
                                                        ARV_Package__r.ARV_Dental_Plan__c,ARV_Package__r.ARV_Vision_Plan__c,
                                                        ARV_Census_Member_Selected_Package__r.Package_Carrier__c,
                                                        ARV_Package__r.ARV_Tech_Dental_Voluntary_Contributory__c,
                                                        ARV_Package__r.ARV_Tech_Vision_Voluntary_Contributory__c,
                                                        CM_Start_Date__c,CM_End_Date__c,Status__c
                                                        from vlocity_ins__GroupCensusMember__c where 
                                                        vlocity_ins__CensusId__c =: con.vlocity_ins__EnrollmentCensusId__c and 
                                                        vlocity_ins__IsPrimaryMember__c = true limit 500]){
                                                            
                mem.CM_Start_Date__c = con.StartDate;
                mem.CM_End_Date__c = endDate;
                if(mem.Status__c == ENROLLING && mem.ARV_Census_Member_Selected_Package__c!=null && 
                    plsrGsMap.get(mem.ARV_Census_Member_Selected_Package__c).size() == 1){
                    mem.ARV_Group_Segment__c = plsrGsMap.get(mem.ARV_Census_Member_Selected_Package__c)[0].id;
                    censusGS.put(mem.id,plsrGsMap.get(mem.ARV_Census_Member_Selected_Package__c)[0].id);
                    //updateMbrs.add(mem);
                }
                else if(mem.Status__c == ENROLLING && mem.ARV_Census_Member_Selected_Package__c!=null && 
                        plsrGsMap.get(mem.ARV_Census_Member_Selected_Package__c).size() > 1){
                    //Id segmentId;
                    String temp = mem.ARV_Census_Member_Selected_Package__c;
                    if(mem.ARV_Census_Member_Selected_Package__r.Package_Carrier__c == BCBS && 
                        mem.ARV_Package__r.ARV_Dental_Plan__c != null){
                        temp = mem.ARV_Is_Dental_Selected__c ? temp+S_VOLUNTARY : temp+S_PEDIATRIC;
                        temp = mem.ARV_Package__r.ARV_Contains_HBA_Product__c ? temp+S_ENHANCED : temp;
                        if(temp!=null && bCBSMMap.containskey(temp) && bCBSMMap.get(temp)!=null){
                            mem.ARV_Group_Segment__c = bCBSMMap.get(temp);
                            censusGS.put(mem.id,bCBSMMap.get(temp));
                            //updateMbrs.add(mem);
                        }
                    }
                    else if(mem.Status__c == ENROLLING && mem.ARV_Census_Member_Selected_Package__r.Package_Carrier__c == BCN && 
                            !mem.ARV_Package__r.ARV_Contains_BCN_HSA__c && 
                    (mem.ARV_Package__r.ARV_Dental_Plan__c != null || mem.ARV_Package__r.ARV_Vision_Plan__c != null)){
                                                                                                        
                        temp = mem.ARV_Package__r.ARV_Dental_Plan__c == null ? temp : 
                             (mem.ARV_Package__r.ARV_Tech_Dental_Voluntary_Contributory__c == S_VOLUNTARY && 
                               !mem.ARV_Is_Dental_Selected__c ? temp+PEDIATRIC : 
                               (mem.ARV_Package__r.ARV_Tech_Dental_Voluntary_Contributory__c == S_VOLUNTARY ? 
                                temp+S_VOLUNTARY: 
                               (mem.ARV_Package__r.ARV_Tech_Dental_Voluntary_Contributory__c == NONVOLUNTRY ?
                               temp+NONVOLUNTRY : temp+PEDIATRIC))); 
                        temp = mem.ARV_Package__r.ARV_Vision_Plan__c == null ? temp : 
                             (mem.ARV_Package__r.ARV_Tech_Vision_Voluntary_Contributory__c == S_VOLUNTARY && 
                               !mem.ARV_Is_Vision_Selected__c ? temp+PEDIATRIC : 
                               (mem.ARV_Package__r.ARV_Tech_Vision_Voluntary_Contributory__c == S_VOLUNTARY ? 
                                temp+S_VOLUNTARY: 
                               (mem.ARV_Package__r.ARV_Tech_Vision_Voluntary_Contributory__c == NONVOLUNTRY ?
                               temp+NONVOLUNTRY : temp+PEDIATRIC))); 
                                                                                      
                        if(temp!=null && bCNMMap.containskey(temp) && bCNMMap.get(temp)!=null){
                            mem.ARV_Group_Segment__c = bCNMMap.get(temp);
                            censusGS.put(mem.id,bCNMMap.get(temp));
                            //updateMbrs.add(mem);    
                        }
                    }
                    else if(mem.Status__c == ENROLLING && 
                            mem.ARV_Census_Member_Selected_Package__r.Package_Carrier__c == BCN && 
                            mem.ARV_Package__r.ARV_Contains_BCN_HSA__c &&( mem.ARV_CDH_Member__c!=null ||
                            mem.ARV_Package__r.ARV_Dental_Plan__c != null || mem.ARV_Package__r.ARV_Vision_Plan__c != null) ){
                                                                                                                                                      
                        temp = mem.ARV_CDH_Member__c!=null && (mem.ARV_CDH_Member__c!=NOCDH && mem.ARV_CDH_Member__c!=NASTRING)? 
                               temp+S_OPT_IN : temp+S_OPT_OUT;
                        temp = mem.ARV_Package__r.ARV_Dental_Plan__c == null ? temp : 
                             (mem.ARV_Package__r.ARV_Tech_Dental_Voluntary_Contributory__c == S_VOLUNTARY && 
                               !mem.ARV_Is_Dental_Selected__c ? temp+PEDIATRIC : 
                               (mem.ARV_Package__r.ARV_Tech_Dental_Voluntary_Contributory__c == S_VOLUNTARY ? 
                                temp+S_VOLUNTARY : 
                               (mem.ARV_Package__r.ARV_Tech_Dental_Voluntary_Contributory__c == NONVOLUNTRY ?
                               temp+NONVOLUNTRY : temp+PEDIATRIC)));                                   
                        temp = mem.ARV_Package__r.ARV_Vision_Plan__c == null ? temp : 
                             (mem.ARV_Package__r.ARV_Tech_Vision_Voluntary_Contributory__c == S_VOLUNTARY && 
                               !mem.ARV_Is_Vision_Selected__c ? temp+PEDIATRIC : 
                               (mem.ARV_Package__r.ARV_Tech_Vision_Voluntary_Contributory__c == S_VOLUNTARY ? 
                               temp+S_VOLUNTARY : 
                               (mem.ARV_Package__r.ARV_Tech_Vision_Voluntary_Contributory__c == NONVOLUNTRY ?
                               temp+NONVOLUNTRY : temp+PEDIATRIC))); 
                                   system.debug('print temp value'+temp);
                        if(temp!=null && bCNMMap.containskey(temp) && bCNMMap.get(temp)!=null){
                            mem.ARV_Group_Segment__c = bCNMMap.get(temp);
                            censusGS.put(mem.id,bCNMMap.get(temp));
                            //updateMbrs.add(mem);    
                        }                               
                    }else{}
                                                                        
                }else{}
                updateMbrs.add(mem);                                                            
            }
            if(!updateMbrs.isEmpty()){
                for(vlocity_ins__GroupCensusMember__c mem: [select id,ARV_Group_Segment__c,vlocity_ins__RelatedCensusMemberId__c,
                                                            CM_Start_Date__c,CM_End_Date__c,Status__c 
                                                            from vlocity_ins__GroupCensusMember__c
                                                where vlocity_ins__CensusId__c =: con.vlocity_ins__EnrollmentCensusId__c and 
                                                vlocity_ins__IsPrimaryMember__c = false limit 500]){
                    
                    if(mem.Status__c == ENROLLING){
                        mem.ARV_Group_Segment__c = censusGS.get(mem.vlocity_ins__RelatedCensusMemberId__c);                                   
                    }                                            
                    mem.CM_Start_Date__c = con.StartDate;
                    mem.CM_End_Date__c = endDate;
                    updateMbrs.add(mem); 
                }
                database.update(updateMbrs);
            }
        }
        catch(Exception e){
           GA_LogExceptionCls.LogExcpContract(e, CLSNAME, UPDATECENSUSMEM_METHOD, conId); 
            errorOccured= true;           
        }
        
    }
    
    
}