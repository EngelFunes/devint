/*****************************************************************************************
Class Name   : ARV_AP45_CreateLocationPackages. 
Date Created : 7-OCT-2019.
Created By   : IDC Offshore.
Description  :This is the class for package validation in enrollment process...
******************************************************************************************/
global without sharing class ARV_AP45_CreateLocationPackages  implements vlocity_ins.VlocityOpenInterface2{
    private static final string METHODNAME='createLocationPckg';
    private static final string GROUPINFORMATION='GroupInformation';
    private static final string ACCOUNTID='AccountId';
    private static final string CONTRACTID='contractId';
    private static final string GROUPNAME='GroupName';    
    private static final string SELECTEMPLYSEGMENTS='SelectEmployeeSegments';
    private static final string PACKAGELOCATION='PackageLocation';
    private static final string PLANS = 'Plans';
    private static final string DENTALISSLCTD  = 'DentalIsSelected';
    private static final string NOOFPACKAGES  = 'NoOfPackages';
    private static final string PACKAGEPRODUCT1  = 'PackageProduct1';
    private static final string PACKAGEPRODUCT2  = 'PackageProduct2';
    private static final string PACKAGEPRODUCT3  = 'PackageProduct3';
    private static final string MULTIEMPLOYEE  = 'MultiEmployee';
    private static final string MULTILOCATION  = 'MultiLocation';
    private static final string COMMONCONTROL  = 'CommonControl';
    private static final string ADTNLLOCATIONS  = 'AdditionalLocations';
    private static final string OPENBRACE  = '[';
    private static final string CLOSEBRACE  = ']';
    private static final string HEADQUARTERS  = 'Headquarters';
    private static final string HEADQ  = 'HQ';
    private static final string NOSEGMENT  = 'No Segmentation';
    private static final string PACKAGENM  = 'Package';
    private static final string PDTRCDENTAL  = 'Blue Dental PPO Plus℠ 80/50/50 Pediatric SG';
    private static final string PDTRCVISION  = 'Blue Vision PPO Plus℠ 80/50/50 Pediatric SG';
    private static final string PACKAGE1  = 'Package1';
    private static final string PACKAGE2  = 'Package2';
    private static final string PACKAGE3  = 'Package3';
    private static final string MEDICALID  = 'medicalId';
    private static final string DENTALID  = 'dentalId';
    private static final string VISIONID  = 'visionId';
    private static final string MEDICAL  = 'Medical';
    private static final string DENTAL  = 'Dental';
    private static final string VISION  = 'Vision';
    private static final string PDTRCNO  = 'no';
    //private static final string PEDIATRIC  = 'Pediatric';
    private static final string CNTNSPEDIATRIC  = '%Pediatric%';
    private static final string MDCLPACKLKUP  = 'MedicalPackLookup'; 
    private static final string MDCLPACKLKUP1  = 'MedicalPackLookup1'; 
    private static final string MDCLPACKLKUP2  = 'MedicalPackLookup2'; 
    private static final string MDCLPACKLKUP3  = 'MedicalPackLookup3'; 
    private static final string PCP  = 'PCP';
    private static final string DNTLPACKLKUP  = 'DentalPackLookup';
    private static final string VSNPACKLKUP  = 'VisionPackLookup';
    private static final string DNTLPACKPDTRCLKUP  = 'DentalPackPediatric';
    private static final string MDCLFORMULA = 'MedicalFormula';
    private static final string CMNCONTROL  = 'CommonControl';
    private static final string PEDDNTLADDED  = 'pedDentalAdded';
    private static final string PDTRCDNTL  = 'pediatricDental';
    private static final string PDTRCVSN  = 'pediatricVision';
    private static final string PRODUCTID  = 'ProductId';
    private static final string PCKGSELECTION  = 'PackageSelection';
    private static final string VOLUNTARY  = 'Voluntary';
    private static final string YESVAR  = 'Yes';
    private static final string HEADQCHECK  = 'HQ: ';
    private static final string NOVAR  = 'No';
    private static final string SPACE  = ' ';
    private static final string SLASH  = '/';
    private static final string HYPHEN  = '-';
    private static final string AMPH  = '&';
    private static final string COLON  = ':';
    private static final string BLANK  = '';
    private static final BOOLEAN TRUE_VAL = true;
    private static final BOOLEAN FALSE_VAL = false;
    private static final String STRINGNONMI = 'nonMI';
    private static final String STRINGSPLIT = ': ';
    private static final String ASSIGNMENTS = 'Assignments';
    private static final String STRINGNA = 'N/A';
    private static final String STRINGA = 'a';
    private static final string COMMONCNTRLINFO  = 'CommonControlInformation';
    private static final string PLANQUERY = 'Select Id,Voluntary_Contributory__c,vlocity_ins__ProductType__c from '+
        ' vlocity_ins__ContractLineItem__c';
    private static final string PLANWHERE = '  where vlocity_ins__ContractId__c = :paramId1 and '+ 
        ' Voluntary_Contributory__c= :paramName and vlocity_ins__ProductType__c=:paramName1';
    private static final string LIMITCLAUSE =' LIMIT 1';
    private static final string PRODUCTQUERY = 'select Id,ProductCode,Name from product2';
    private static final string PRODUCTWHERE = ' where Name like :paramName and vlocity_ins__Type__c=:paramName1';
    private static final string PACKAGEQUERY = 'select Id,ARV_Pediatric_Dental_Plan__c, '+
    ' ARV_Dental_Plan__r.vlocity_ins__ProductType__c,ARV_Vision_Plan__r.vlocity_ins__ProductType__c from Package__c';
    private static final string PACKAGEWHERE =' where ARV_Contract_Id__c=:paramId1 and '+
    ' (ARV_Dental_Plan__r.Voluntary_Contributory__c=:paramName or ARV_Vision_Plan__r.Voluntary_Contributory__c=:paramName)'+
    ' and (ARV_Dental_Plan__r.vlocity_ins__ProductType__c=:paramName1 or '+ 
       ' ARV_Vision_Plan__r.vlocity_ins__ProductType__c=:paramName1) ';
    private Id drAccountId;
    private Id drContractId;
    private Id pdtrcDntlId;
    private Id pdtrcVsnId;
    private Map<Id,Id> planProd = new Map<Id,Id>();
    private List<Id> prodId = new List<Id>();
    private Map<String,id> prodMap = new Map<String,id>();
    private Integer totalPackages;
    private Map<String,Object> packageProd1 = new MAP<String,Object>();
    private Map<String,Object> packageProd2 = new MAP<String,Object>();
    private Map<String,Object> packageProd3 = new MAP<String,Object>();
    private List<String> countyList = new List<String>();
    //private Map<String,String> countyMIMap = new MAP<String,String>();
    private String slctdPlans;
    private String pediatricdental;
    private Boolean quotingPdtrc;
    private Boolean containsnonPcpCounty =false;
    private Boolean containsPcpCounty =false;
    private Map<String,Object> locPckgMapData = new Map<String,Object>();
    private List<String> segments = new List<String>();
    private Set<String> asgndPcpPckg = new Set<String>();
    private Set<String> slctdPckgs = new Set<String>();
    private List<CommonCnrlList> commonCntrlList = new List<CommonCnrlList>();
    private List<CommonCnrlList> cctrlList = new List<CommonCnrlList>(); 
    private static final string  ERRMSG='errormsg';
    private static final String NBYASTRING = 'N/A';
    private static final String CDHQUESTION='CDHQuestion';
    private static final String CDHQUESTION2='CDHQuestion2';
    private static final String CDHQUESTION3='CDHQuestion3';
    private static final String DENTALCDHOPTIONS='DentalCDHOptions';
    private static final String DENTALCDHOPTIONS2='DentalCDHOptions2';
    private static final String CDHOPTIONS='CDHOptions';
    private static final String CDHOPTIONS2='CDHOptions2';
    private static final String CDHOPTIONS3='CDHOptions3';
    private static final String YES='Yes';
    private static final String  PACKAGETYPE='New Business Enrollment Package';
     private static Id devRecordTypeId = Schema.SObjectType.Package__c.getRecordTypeInfosByName().get(PACKAGETYPE).getRecordTypeId();

    //private static final String QUOTELINESELECTQRY = 'select id from vlocity_ins__ContractLineItem__c ';
    //private static final String QUOTEWHERECLAUSE = '  where id = :paramId1 ' ;  
/*************************************************************************************************  
Method name : invokeMethod
Params     : map
Return Type : null
Description :this method is used to invoke the enrollMedicalValidation method
******************************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options) 
    {           
        Boolean success = TRUE_VAL;
        try{
            if (methodName == METHODNAME) 
            {
                createLocationPckg(input,output,options);
            }
        }catch(Exception e){
            success = FALSE_VAL;
        }
        return success;
    }
 /*************************************************************************************************************  
Method name : createLocationPckg
Params     : map
Return Type : null
Description :createLocationPckg() method to fetch products data from dataJSON
***********************************************************************************************************/
    global void createLocationPckg(Map<String, Object> input,Map<String, Object> output,Map<String, Object> options){        
        Map<String,Object> groupInformationStep = (Map<String,Object>)input.get(GROUPINFORMATION); 
               
        drAccountId = (Id)input.get(ACCOUNTID);
        drContractId = (Id)options.get(CONTRACTID);        
        String multiEmply = (String)groupInformationStep.get(MULTIEMPLOYEE);
        String multiLctn = (String)groupInformationStep.get(MULTILOCATION);
        String commonCntrl = (String)groupInformationStep.get(CMNCONTROL);        
        List<LocationPackage__c> locations = new List<LocationPackage__c>();
        List<WrapperList> locationList = new List<WrapperList>();                
        Map<String,Object> packageLocation = (Map<String,Object>)input.get(PACKAGELOCATION);
        slctdPlans = (String)packageLocation.get(PLANS);
        pediatricdental = (String)packageLocation.get(DENTALISSLCTD);
        totalPackages = Integer.valueOf(packageLocation.get(NOOFPACKAGES));
        packageProd1 = (Map<String,Object>)packageLocation.get(PACKAGEPRODUCT1);
        packageProd2 = (Map<String,Object>)packageLocation.get(PACKAGEPRODUCT2);
        packageProd3 = (Map<String,Object>)packageLocation.get(PACKAGEPRODUCT3);
        quotingPdtrc = (boolean)packageLocation.get(PEDDNTLADDED);
        Map<String,Object> pediatricDental = (Map<String,Object>)input.get(PDTRCDNTL);
        pdtrcDntlId = (Id)pediatricDental.get(PRODUCTID);
        Map<String,Object> pediatricVision = (Map<String,Object>)input.get(PDTRCVSN);
        pdtrcVsnId = (Id)pediatricVision.get(PRODUCTID);
        Boolean isPCP = false;
        // To add Common controls
         if(commonCntrl==YESVAR){
               commonCntrlList = commonCntrlJsonToList(groupInformationStep.get(COMMONCNTRLINFO));               
        }
        List<LocationPackage__c> commonCntrlList2 = new List<LocationPackage__c>();
        if(commonCntrl==YESVAR && commonCntrlList.size()>=1){
            cctrlList =prepareCommonCntrlList(groupInformationStep);
                        
            commonCntrlList2 = createCCtrlPackageRecords(segments,cctrlList);
            if(!commonCntrlList2.isEmpty()){ Database.insert(commonCntrlList2); } 
        }
        if(multiEmply==YESVAR || (multiLctn==YESVAR && commonCntrl==NOVAR)){
            Map<String,Object> packageSelectionStep = (Map<String,Object>)input.get(PCKGSELECTION);
            locPckgMapData = (Map<String,Object>)packageSelectionStep.get(ASSIGNMENTS);            
        }        
        for(ARV_PCP_County__mdt county : [select id,ARV_PCP_County__c from ARV_PCP_County__mdt limit 100]){            
            countyList.add(county.ARV_PCP_County__c);
        }
        try{                           
            locationList = populateLctnList(groupInformationStep);
            if(multiEmply==YESVAR || (multiLctn==YESVAR && commonCntrl==NOVAR)){
                isPCP = pcpCountyAsgndPcp(locPckgMapData,segments,locationList);
            }            
            locations = createLctnPackageRcrds(segments,locationList,isPCP);            
            if(!locations.isEmpty()){ Database.insert(locations); } 
            createPackage();
            createPckgLocationRltnshp(multiEmply,multiLctn,commonCntrl);
            createPCPData();
            createPediatricRuls();
        }catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
        }        
    }
/*************************************************************************************************************  
Method name : prepareCommonCntrlList
Params     : map
Return Type : null
Description :prepareCommonCntrlList() method to fetch products data from dataJSON
***********************************************************************************************************/    
  public List<CommonCnrlList> prepareCommonCntrlList(Map<String,Object> groupInformationStep){ 
      try{ 
        String groupSegment = (String)groupInformationStep.get(SELECTEMPLYSEGMENTS);        
        List<CommonCnrlList> adtnlCCtrlList = new List<CommonCnrlList>();
        //List<CommonCnrlList> hQCCtrlList = new List<CommonCnrlList>();
        List<CommonCnrlList> tempCCtrlList = new List<CommonCnrlList>();
        adtnlCCtrlList = commonCntrlJsonToList(groupInformationStep.get(COMMONCNTRLINFO));
        if(groupInformationStep.get(MULTIEMPLOYEE)==YESVAR && groupSegment != null ){
                segments = groupSegment.split(SLASH); 
            } 
        if(!adtnlCCtrlList.isEmpty()){tempCCtrlList.addAll(adtnlCCtrlList);}
        
        return   tempCCtrlList; 
      }catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
        }
    }
   /*************************************************************************************************************  
Method name : createCCtrlPackageRecords
Params     : map
Return Type : null
Description :createCCtrlPackageRecords() method to fetch products data from dataJSON
***********************************************************************************************************/ 
    public List<LocationPackage__c> createCCtrlPackageRecords(List<String> sgmnts, List<CommonCnrlList> lctnList){
        try{            
        List<LocationPackage__c> tempLocations = new List<LocationPackage__c>();
        LocationPackage__c lctn1 = null;
            String county = null; 
            //String commonAccountIds=null;
            Boolean uwApprovalProcess=false;
            Set<String> str = new Set<String>();
            //ARV_TECH_Com_UW_Approval_Process__c 
                for(CommonCnrlList loc: lctnList){                                      
                        county = loc.CCCounty == NBYASTRING ?loc.CCOutsideCounty : loc.CCCounty;
                        String temp = loc.CompanyName+HYPHEN+loc.CCZipCode+HYPHEN+county;  
                        lctn1 = new LocationPackage__c();
                        lctn1.Name = loc.CCCounty != null && loc.CCCounty.contains(HEADQ) ? county : 
                                                                loc.CompanyName+COLON+SPACE+county;
                        lctn1.ARV_Location_Physical_City__c = loc.CityName; 
                     //added for US2584
                        if(loc.CommAccountId !=null )
                        {   
                        str.add(loc.CommAccountId);
                        }
                        if(loc.approvalProcessUW && !uwApprovalProcess){
                            uwApprovalProcess =true;
                        }
                        lctn1.ARV_Location_Name__c = loc.CompanyName;
                        lctn1.ARV_CC_Fed_Tax_ID__c =loc.CompanyFederalTaxID;
                        lctn1.ARV_Location_Physical_County__c = county;
                        lctn1.ARV_AccountId__c = drAccountId;
                        lctn1.ARV_Location_Physical_Zip_Code__c = loc.CCZipCode;                         
                        lctn1.ARV_HQ__c = loc.CCCounty != null && loc.CCCounty.contains(HEADQ) ? true:false;                        
                        lctn1.ARV_ContractId__c = drContractId; 
                        lctn1.ARV_IsCommonControll__c=true;
                        lctn1.ARV_Non_Billing__c= true;

                        tempLocations.add(lctn1);
                    }
               //added for US2584
                 String finalstr=ARV_AP41_StringLiteralUtils.MYBLANKVAL;
                for(String s:str){
                    finalstr=s+ARV_AP41_StringLiteralUtils.SEPERATOR+finalstr;
                 }
                string finalVar=finalstr.removeEnd(ARV_AP41_StringLiteralUtils.SEPERATOR);
                Contract contractObj = new Contract();
                contractObj.ARV_TECH_Common_Account_Merge__c=finalVar;
                contractObj.id=drContractId;    
                contractObj.ARV_TECH_Com_UW_Approval_Process__c=uwApprovalProcess;
                database.update(contractObj);
        
        return tempLocations;
        }catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
        }
    }  
 /*************************************************************************************************************  
Method name : populateLctnList
Params     : map
Return Type : null
Description : populateLctnList() to populate with list of Locations
***********************************************************************************************************/     
    public List<WrapperList> populateLctnList(Map<String,Object> groupInfoStep){ 
        String groupSegment = (String)groupInfoStep.get(SELECTEMPLYSEGMENTS);
        List<WrapperList> adtnlLctnList = new List<WrapperList>();
        List<WrapperList> hQLctnList = new List<WrapperList>();
        List<WrapperList> tempLctnList = new List<WrapperList>();        
        try{
            if(groupInfoStep.get(MULTIEMPLOYEE)==YESVAR && groupSegment != null ){
                segments = groupSegment.split(SLASH); 
            }                      
            if(groupInfoStep.get(MULTILOCATION)==YESVAR && groupInfoStep.get(COMMONCONTROL)==NOVAR ){           
                adtnlLctnList = jsonToList(groupInfoStep.get(ADTNLLOCATIONS));
                
                if(!adtnlLctnList.isEmpty()){ 
                    tempLctnList.addAll(adtnlLctnList);                     
                }
            }            
            hQLctnList = jsonToList(groupInfoStep.get(HEADQUARTERS));
            if(!hQLctnList.isEmpty()){ tempLctnList.addAll(hQLctnList); }
            for(WrapperList tempLoc: tempLctnList){
                String county = !STRINGNA.equals(tempLoc.aLCounty) && tempLoc.aLCounty.contains(HEADQCHECK)?
                                tempLoc.aLCounty.split(STRINGSPLIT)[1]:tempLoc.aLCounty; 
                if(STRINGNA.equals(tempLoc.aLCounty) || !countyList.contains(county)){
                    containsnonPcpCounty = true;
                }
                else if(countyList.contains(county)){
                    containsPcpCounty = true;
                }else{}                             
            }            
            return tempLctnList;
        }catch(Exception e){ throw new AuraHandledException(+e.getMessage()); }        
    }
    /*************************************************************************************************************  
    Method name : pcpCountyAsgndPcp
    Params     : map
    Return Type : boolean
    Description : pcpCountyAsgndPcp() to populate with list of Locations
    ***********************************************************************************************************/   
    public boolean pcpCountyAsgndPcp(Map<String,Object> asgnmntData,List<String> sgmnts,List<WrapperList> lctnList){
        try{
        Set<String> pcpPckg = new Set<String>();
        Map<String,Set<String>> countyPckg = new Map<String,Set<String>>();            
        if(packageProd1.get(MDCLPACKLKUP1)!=null && String.valueOf(packageProd1.get(MDCLPACKLKUP1)).contains(PCP))
        {pcpPckg.add(PACKAGE1);}
        if(totalPackages>1 && packageProd2.get(MDCLPACKLKUP2)!=null && String.valueOf(packageProd2.get(MDCLPACKLKUP2)).contains(PCP))
        {pcpPckg.add(PACKAGE2);}
        if(totalPackages>2 && packageProd3.get(MDCLPACKLKUP3)!=null && String.valueOf(packageProd3.get(MDCLPACKLKUP3)).contains(PCP))
        {pcpPckg.add(PACKAGE3);}
        for(Object pckg: asgnmntData.values()){
            slctdPckgs.addAll(String.valueof(pckg).split(ARV_AP41_StringLiteralUtils.SEPERATOR));
        }        
        Set<String> setPckg = null;
        for(wrapperList loc: lctnList){            
            if( !STRINGNA.equals(loc.aLCounty) ){
                String county = loc.aLCounty.contains(HEADQCHECK)?loc.aLCounty.split(STRINGSPLIT)[1]:loc.aLCounty;
                String temp = HYPHEN+loc.locationName+HYPHEN+loc.aLZipCode+HYPHEN+loc.aLCounty;
                if(!string.isBlank(county) && countyList.contains(county) && asgnmntData.containskey(temp) && 
                    asgnmntData.get(temp)!=null && sgmnts.isEmpty()){                    
                    setPckg = new Set<String>(String.valueof(asgnmntData.get(temp)).
                                                          split(ARV_AP41_StringLiteralUtils.SEPERATOR));
                    countyPckg.put(temp,setPckg);                    
                }
                for(String sgmnt : sgmnts){                    
                    temp = sgmnt+HYPHEN+loc.locationName+HYPHEN+loc.aLZipCode+HYPHEN+loc.aLCounty;
                    if(countyList.contains(county) && asgnmntData.containskey(temp) && asgnmntData.get(temp)!=null){                    
                        setPckg = new Set<String>
                        (String.valueof(asgnmntData.get(temp)).split(ARV_AP41_StringLiteralUtils.SEPERATOR));
                    countyPckg.put(temp,setPckg);                    
                    }
                }
            }               
        }        
        boolean isPcpPckg = false;
        for(String con: countyPckg.keySet()){
            for(String pckg: countyPckg.get(con)){
                if(pcpPckg.contains(pckg)){
                    isPcpPckg = true;
                    asgndPcpPckg.add(pckg);
                }
            }
        }
        return isPcpPckg;
        }catch(Exception e){ 
            throw new AuraHandledException(+e.getMessage());
        }
    }
 /*************************************************************************************************************  
Method name : createLctnPackageRcrds
Params     : map
Return Type : null
Description :createLctnPackageRcrds() to create record for LocationPackage object
***********************************************************************************************************/    
    public List<LocationPackage__c> createLctnPackageRcrds(List<String> sgmnts, List<WrapperList> lctnList,Boolean isPcpChk){ 
        List<LocationPackage__c> tempLocations = new List<LocationPackage__c>();
        try{
            LocationPackage__c lctn1 = null;
            String county = null;            
            if(!sgmnts.isEmpty() && !lctnList.isEmpty()){
                for(String sgmnt : sgmnts){                
                    for(wrapperList loc: lctnList){                        
                        county = STRINGNA.equals(loc.aLCounty)?loc.aLOutsideCounty : loc.aLCounty;
                        String temp = sgmnt+HYPHEN+loc.locationName+HYPHEN+loc.aLZipCode+HYPHEN+county;                                                
                        String hqCounty = county.contains(HEADQCHECK)?county.split(STRINGSPLIT)[1]:county;
                        if( (locPckgMapData.containsKey(temp) && locPckgMapData.get(temp) != BLANK) ||
                          (isPcpChk && (STRINGNA.equals(loc.aLCounty) || 
                                        (!STRINGNA.equals(hqCounty) && !countyList.contains(hqCounty))))){
                        lctn1 = new LocationPackage__c();
                        lctn1.Name = loc.aLCounty != null && loc.aLCounty.contains(HEADQ) ? county+HYPHEN+sgmnt : 
                                                                loc.locationName+COLON+SPACE+county+HYPHEN+sgmnt;
                        lctn1.ARV_Location_Name__c = loc.locationName;
                        lctn1.ARV_Location_Physical_County__c = county; lctn1.ARV_AccountId__c = drAccountId;
                        lctn1.ARV_Location_Physical_Zip_Code__c = loc.aLZipCode; lctn1.ARV_Segment__c = sgmnt;
                        lctn1.ARV_Segmentation_Group__c = sgmnts[0]+SPACE+AMPH+SPACE+sgmnts[1];
                        lctn1.ARV_HQ__c = loc.aLCounty != null && loc.aLCounty.contains(HEADQ) ? true:false;
                        lctn1.ARV_IsMI__c = loc.aLCounty != STRINGNA ? true:false;
                        lctn1.ARV_ContractId__c = drContractId; tempLocations.add(lctn1);
                        }
                    }
                }
            }
            else if(!lctnList.isEmpty()){
                for(wrapperList loc: lctnList){
                    county = loc.aLCounty.equals(STRINGNA)?loc.aLOutsideCounty : loc.aLCounty;
                    String hqCounty = loc.aLCounty.contains(HEADQ)? county:HEADQ+COLON+SPACE+county;
                    lctn1 = new LocationPackage__c();                    
                    lctn1.Name = loc.aLCounty.contains(HEADQ)||loc.locationName == null? 
                                            hqCounty : loc.locationName+COLON+SPACE+county;
                                            
                    lctn1.ARV_Location_Name__c = loc.locationName !=null ? loc.locationName:HEADQ;              
                    lctn1.ARV_Location_Physical_County__c = county; lctn1.ARV_Segmentation_Group__c = NOSEGMENT;
                    lctn1.ARV_Location_Physical_Zip_Code__c = loc.aLZipCode;                    
                    lctn1.ARV_HQ__c = loc.aLCounty.contains(HEADQ)||loc.locationName == null ? true:false;
                    lctn1.ARV_IsMI__c = loc.aLCounty != STRINGNA ? true:false;
                    lctn1.ARV_AccountId__c = drAccountId; lctn1.ARV_ContractId__c = drContractId;
                    tempLocations.add(lctn1);
                }            
            }else{}
            return tempLocations;
        }catch(Exception e){ throw new AuraHandledException(+e.getMessage()); }        
    }
 /*************************************************************************************************************  
Method name : jsonToList
Params     : map
Return Type : null
Description :jsonToList() method to convert object to List.
***********************************************************************************************************/     
    public List<WrapperList> jsonToList(Object lctnJson){
        try{
            string strJson = JSON.serialize(lctnJson);
            strJson = strJson.startsWith(OPENBRACE) ? strJson : OPENBRACE + strJson;
            strJson = strJson.endsWith(CLOSEBRACE) ? strJson : strJson + CLOSEBRACE;
            WrapperList wrap = new WrapperList();
            return wrap.parse(strJson);
        }catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
        }
    }
    /*************************************************************************************************************  
    Method name : jsonToList
    Params     : map
    Return Type : null
    Description :jsonToList() method to convert object to List.
    ***********************************************************************************************************/     
    public List<CommonCnrlList> commonCntrlJsonToList(Object lctnJson){
        try{
            string strJson = JSON.serialize(lctnJson);
            strJson = strJson.startsWith(OPENBRACE) ? strJson : OPENBRACE + strJson;
            strJson = strJson.endsWith(CLOSEBRACE) ? strJson : strJson + CLOSEBRACE;
            CommonCnrlList wrap = new CommonCnrlList();
            return wrap.parse(strJson);
        }catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
        }
    }  
 /*************************************************************************************************************  
Method name : createPackage
Params     : map
Return Type : null
Description :createPackage() method to fetch products data from dataJSON
***********************************************************************************************************/    
    public void createPackage(){
        List<String> packageList = new List<String>();
        Map<String,Id> package1Map = new Map<String,Id>();
        Map<String,Id> package2Map = new Map<String,Id>();
        Map<String,Id> package3Map = new Map<String,Id>();
        Id medId = null; 
        Id dntlId = null; 
        Id vsnId = null;
        try{                   
            for(Integer i=1; i<=totalPackages; i++){
                packageList.add(PACKAGENM+i);
                if(i == 1){ package1Map = createProductList(packageProd1,1,slctdPlans,pediatricdental); }
                else if(i == 2){ package2Map = createProductList(packageProd2,2,slctdPlans,pediatricdental); }
                else if(i == 3){ package3Map = createProductList(packageProd3,3,slctdPlans,pediatricdental); }else{}
            }
            if(slctdPckgs.isEmpty()){slctdPckgs.addAll(packageList);}
            deleteContractLineItems();        
            List<Package__c> packList = new List<Package__c>();
            Package__c pck1 = null;
            for(String pack:packageList){
                if(slctdPckgs.contains(pack)){
                medId =  pack==PACKAGE1 && package1Map.get(MEDICALID) != null ? planProd.get(package1Map.get(MEDICALID)) : 
                         pack==PACKAGE2 && package2Map.get(MEDICALID) != null ? planProd.get(package2Map.get(MEDICALID)):
                         pack==PACKAGE3 && package3Map.get(MEDICALID) != null ? planProd.get(package3Map.get(MEDICALID)):null;                   
                dntlId = pack==PACKAGE1 && package1Map.get(DENTALID) != null ? planProd.get(package1Map.get(DENTALID)) : 
                         pack==PACKAGE2 && package2Map.get(DENTALID) != null ? planProd.get(package2Map.get(DENTALID)):
                         pack==PACKAGE3 && package3Map.get(DENTALID) != null ? planProd.get(package3Map.get(DENTALID)):null;                   
                vsnId = pack==PACKAGE1 && package1Map.get(VISIONID) != null ? planProd.get(package1Map.get(VISIONID)) : 
                        pack==PACKAGE2 && package2Map.get(VISIONID) != null ? planProd.get(package2Map.get(VISIONID)):
                        pack==PACKAGE3 && package3Map.get(VISIONID) != null ? planProd.get(package3Map.get(VISIONID)):null;                                                    
                String cdhValue = pack==PACKAGE1 && packageProd1.get(CDHQUESTION) == YES? (String)packageProd1.get(CDHOPTIONS) :
                        pack==PACKAGE2 && packageProd2.get(CDHQUESTION2) == YES? (String)packageProd2.get(CDHOPTIONS2) :
                        pack==PACKAGE3 && packageProd3.get(CDHQUESTION3) == YES? (String)packageProd3.get(CDHOPTIONS3):null;
                String dntlValue = pack==PACKAGE1 && packageProd1.get(DENTALCDHOPTIONS)!= null? (String)packageProd1.get(DENTALCDHOPTIONS) :
                        pack==PACKAGE2 && packageProd2.get(DENTALCDHOPTIONS2)!= null? (String)packageProd2.get(DENTALCDHOPTIONS2) :null;
                pck1 =new Package__c();
                pck1.Name=pack; pck1.ARV_Contract_Id__c = drContractId; pck1.ARV_Medical_Plan__c = medId;
                pck1.ARV_CDH_Package_Combination__c = cdhValue!=null?cdhValue:dntlValue!=null?dntlValue:BLANK;
                pck1.ARV_Dental_Plan__c = dntlId; pck1.ARV_Vision_Plan__c = vsnId;
                pck1.RecordTypeId=devRecordTypeId;
                 packList.add(pck1);
                }
            }
            if(!packList.isEmpty()){ Database.insert(packList); } 
        }catch(Exception e){ throw new AuraHandledException(+e.getMessage()); }
    }
     
 /*************************************************************************************************************  
Method name : createPckgLocationRltnshp
Params     : map
Return Type : null
Description :createPckgLocationRltnshp() method is to create records for Package_Location_Segment_Rel__c object based on
packages assigned to each location.
***********************************************************************************************************/     
    public void createPckgLocationRltnshp(String multiEmployee, String multiLocation, String cmnCntrl){
        try{
        Map<String,id> pckgMap = new Map<String,id>();
        List<Package_Location_Segment_Rel__c> pckgRltnList = new List<Package_Location_Segment_Rel__c>();
        List<LocationPackage__c> locList = new List<LocationPackage__c>([select id,name from LocationPackage__c where 
                                                                         ARV_ContractId__c =: drContractId limit 500]);
        for(Package__c pckg: [select id,name from Package__c where ARV_Contract_Id__c =: drContractId limit 500]){
            pckgMap.put(pckg.name,pckg.Id);
        }
        Package_Location_Segment_Rel__c rltn = null;
        for(LocationPackage__c loc : [select id,name,ARV_IsMI__c,ARV_Location_Name__c,ARV_Location_Physical_County__c,
                                      ARV_Location_Physical_Zip_Code__c,
                                  ARV_Segment__c from LocationPackage__c where ARV_ContractId__c =: drContractId and 
                                      ARV_IsCommonControll__c = false limit 500]){
            String temp = multiEmployee.equals(YESVAR) ? 
                loc.ARV_Segment__c+HYPHEN+loc.ARV_Location_Name__c+HYPHEN+loc.ARV_Location_Physical_Zip_Code__c+
                HYPHEN+loc.ARV_Location_Physical_County__c : 
                            HYPHEN+loc.ARV_Location_Name__c+HYPHEN+loc.ARV_Location_Physical_Zip_Code__c+HYPHEN+
                                loc.ARV_Location_Physical_County__c;
            String con = loc.ARV_Location_Physical_County__c.contains(HEADQCHECK)? 
                loc.ARV_Location_Physical_County__c.split(STRINGSPLIT)[1]:
                                          loc.ARV_Location_Physical_County__c;                                                     
            if( multiEmployee==YESVAR || (multiLocation==YESVAR && cmnCntrl==NOVAR) ) { 
               if(locPckgMapData.containsKey(temp) && locPckgMapData.get(temp) != BLANK){                   
                   for(String pckgName: pckgMap.keySet()){
                       if(String.valueOf(locPckgMapData.get(temp)).contains(pckgName)){
                            rltn = new Package_Location_Segment_Rel__c();
                            rltn.name = loc.name+pckgName; rltn.Contract__c = drContractId;rltn.Location_Segment__c = loc.id;
                            rltn.Package__c = pckgMap.get(pckgName); pckgRltnList.add(rltn);
                       }
                   }
                   if((!loc.ARV_IsMI__c || (loc.ARV_IsMI__c && !countyList.contains(con))) && !asgndPcpPckg.isEmpty()){
                       
                        for(String str:asgndPcpPckg){
                            if(!String.valueOf(locPckgMapData.get(temp)).contains(str) ){
                                rltn = new Package_Location_Segment_Rel__c();
                                rltn.name = loc.name+str; rltn.Contract__c = drContractId;rltn.Location_Segment__c = loc.id;
                                rltn.Package__c = pckgMap.get(str); pckgRltnList.add(rltn);
                            }                           
                        }                      
                   }
               }else if( (!loc.ARV_IsMI__c || (loc.ARV_IsMI__c && !countyList.contains(con))) && 
                        !locPckgMapData.containsKey(temp) && !asgndPcpPckg.isEmpty()){
                    for(String str:asgndPcpPckg){
                        rltn = new Package_Location_Segment_Rel__c();
                        rltn.name = loc.name+str; rltn.Contract__c = drContractId;rltn.Location_Segment__c = loc.id;
                        rltn.Package__c = pckgMap.get(str); pckgRltnList.add(rltn);
                    }                      
                }else{}
                
            }
            else{
                for(String pckgName: pckgMap.keySet()){
                    rltn = new Package_Location_Segment_Rel__c();
                    rltn.name = loc.name+pckgName; rltn.Contract__c = drContractId; rltn.Location_Segment__c = loc.id;
                    rltn.Package__c = pckgMap.get(pckgName);  pckgRltnList.add(rltn);
                }
            }
        }
        if(!pckgRltnList.isEmpty()){ Database.insert(pckgRltnList); }
        }catch(Exception e){ throw new AuraHandledException(+e.getMessage()); }
    }
 /*************************************************************************************************************  
Method name : createProductList
Params     : map
Return Type : null
Description :createProductList() method is used to populate map of product type and id.
***********************************************************************************************************/     
    public Map<String,Id> createProductList(Map<String,Object> pack,Integer i,String plans,String pedtrcDental){
        try{        
            Map<String,Id> packProdId = new Map<String,Id>();
            String medId = (String)pack.get(MDCLPACKLKUP+i);        
            if(medId != null ){
                prodId.add(medId.split(HYPHEN)[0]);
                packProdId.put(MEDICALID,medId.split(HYPHEN)[0]);
            }else{
                packProdId.put(MEDICALID,medId);
            }               
            String dntlId = (((pedtrcDental != null && pedtrcDental.equals(PDTRCNO)) || quotingPdtrc) && !plans.contains(DENTAL)) ? 
                            pdtrcDntlId : plans.contains(DENTAL)?(String)pack.get(DNTLPACKLKUP+i):null;        
            if(dntlId != null){
                prodId.add(dntlId);            
            }
            packProdId.put(DENTALID,dntlId);
            String vsnId = !plans.contains(VISION) && plans.contains(MEDICAL)? pdtrcVsnId : 
                            plans.contains(VISION)?(String)pack.get(VSNPACKLKUP+i):null;        
            if(vsnId != null){
                prodId.add(vsnId);            
            }
            packProdId.put(VISIONID,vsnId);
            return packProdId;
        }catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
        }
    }
 /*************************************************************************************************************  
Method name : deleteContractLineItems
Params     : map
Return Type : null
Description :deleteContractLineItems() method is used to delete Plans that are not selected in the packages.
***********************************************************************************************************/     
    public void deleteContractLineItems(){        
        try{
        if(!prodId.isEmpty()){
            for(vlocity_ins__ContractLineItem__c item: [select id,vlocity_ins__Product2Id__c from 
                       vlocity_ins__ContractLineItem__c where 
                   vlocity_ins__ContractId__c =:drContractId and vlocity_ins__Product2Id__c IN :prodId limit 500]){
                if(!planProd.containsKey(item.vlocity_ins__Product2Id__c)){
                    planProd.put(item.vlocity_ins__Product2Id__c,item.id);
                }                
            }
            List<vlocity_ins__ContractLineItem__c> toDeleteList = new List<vlocity_ins__ContractLineItem__c>([select id 
                   from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c =:drContractId and 
                         vlocity_ins__Product2Id__c NOT IN :prodId limit 500]);            
            if(!toDeleteList.isEmpty()){
                Database.delete(toDeleteList);
            }
        }
        }catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
        }
        
    }
    
    /*************************************************************************************************************  
Method name : createPackage
Params     : map
Return Type : null
Description :createPackage() method to fetch products data from dataJSON
***********************************************************************************************************/
    public void createPediatricRuls()
    {
        try{
        List<vlocity_ins__ContractLineItem__c> plans=new List<vlocity_ins__ContractLineItem__c>();
        List<vlocity_ins__ContractLineItem__c> plans1=new List<vlocity_ins__ContractLineItem__c>();
        ARV_AP07_QueryDataHelper.paramId1 = drContractId;
        ARV_AP07_QueryDataHelper.paramName = VOLUNTARY;
        ARV_AP07_QueryDataHelper.paramName1 = DENTAL;
        plans=ARV_AP07_QueryDataHelper.getsObjects(PLANQUERY,PLANWHERE,NULL,LIMITCLAUSE); 
        ARV_AP07_QueryDataHelper.paramId1 = drContractId;
        ARV_AP07_QueryDataHelper.paramName = VOLUNTARY;
        ARV_AP07_QueryDataHelper.paramName1 = VISION;
        plans1=ARV_AP07_QueryDataHelper.getsObjects(PLANQUERY,PLANWHERE,NULL,LIMITCLAUSE);
        if(Plans.Size()==1){
           String dentalPlanType= DENTAL;
           createPediatricplans(dentalPlanType);
        }
        if(Plans1.Size()==1){
           String visionPlanType=VISION;
           createPediatricplans(visionPlanType);
        } 
        }catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
        }
    }
  /*****************************************************************************************
Method Name   : createPediatricplans
Date Created : 7-OCT-2019
Created By   : IDC Offshore
Description  : This method helps to create the Pediatric plans Data
******************************************************************************************/
   public void createPediatricplans(String Type)
   {
       try{
       List<Product2> prd = new List<Product2>();
       vlocity_ins__ContractLineItem__c contractLine = null;
       ARV_AP07_QueryDataHelper.paramName = CNTNSPEDIATRIC; 
       ARV_AP07_QueryDataHelper.paramName1 = Type;
       prd=ARV_AP07_QueryDataHelper.getsObjects(PRODUCTQUERY,PRODUCTWHERE,NULL,LIMITCLAUSE);
       contractLine = new vlocity_ins__ContractLineItem__c();
       contractLine.Name=prd[0].ProductCode+HYPHEN+prd[0].Name;
       contractLine.vlocity_ins__Product2Id__c=prd[0].Id;
       contractLine.vlocity_ins__ContractId__c=drContractId;
       Database.Insert(contractLine);
       
      List<Package__c> pack = new List<Package__c>();
        ARV_AP07_QueryDataHelper.paramId1 = drContractId;
        ARV_AP07_QueryDataHelper.paramName = VOLUNTARY;
        ARV_AP07_QueryDataHelper.paramName1 = Type; 
        pack=ARV_AP07_QueryDataHelper.getsObjects(PACKAGEQUERY,PACKAGEWHERE,NULL,NULL);
      for(Package__c pack1 : pack)
      {
          if (DENTAL.equals(Type)){
               pack1.ARV_Pediatric_Dental_Plan__c=contractLine.Id;
          }
          if (VISION.equals(Type)){
               pack1.ARV_Pediatric_Vision_Plan__c=contractLine.Id;
          }
     }  
       Database.Update(pack);
       }catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
        }
       
   }
/*****************************************************************************************
Method Name   : createPCPData
Date Created : 7-OCT-2019
Created By   : IDC Offshore
Description  : This method helps to create the PCP Data
******************************************************************************************/
    public void createPCPData(){
        try{
        Set<Package__c> pcpPckg = new Set<Package__c>();
        Map<Id,Id> sisterProdMap = new Map<Id,Id>();
        Set<Id> locPckgRltnMap = new Set<Id>();
        Set<Id> medicalId = new Set<Id>();
        Map<Id,Product2> sisProdData = new Map<Id,Product2>();        
        for(vlocity_ins__ContractLineItem__c prod: [select id,vlocity_ins__Product2Id__r.ARV_PCPFocus_SisterPlan__c 
                                                    from vlocity_ins__ContractLineItem__c 
                                                    where vlocity_ins__ContractId__c =:drContractId 
                                 and vlocity_ins__ProductType__c =: ARV_AP41_StringLiteralUtils.MEDICALTYPE LIMIT 1000]){
            sisterProdMap.put(prod.id,prod.vlocity_ins__Product2Id__r.ARV_PCPFocus_SisterPlan__c);
        }
        for(Product2 pod: [select id,name,ProductCode from Product2 where id IN : sisterProdMap.values() LIMIT 1000]){
            sisProdData.put(pod.id,pod);
        }
        
        Map<id,Package__c> pckgMap = new Map<id,Package__c>();
        for(Package__c pckg: [select id,name,ARV_Medical_Plan__c,ARV_Medical_Plan__r.PCP_Focus__c,
                              ARV_Dental_Plan__c,ARV_Vision_Plan__c,ARV_CDH_Package_Combination__c 
                              from Package__c where ARV_Contract_Id__c =:drContractId LIMIT 1000]){
            pckgMap.put(pckg.id,pckg);
        }       
        Map<id,List<Package__c>> locPckg = new Map<id,List<Package__c>>();//query on junction object map<locid,List<pckgobjct>>
        for(Package_Location_Segment_Rel__c rltn : [select id,Package__c,Location_Segment__c,Location_Segment__r.ARV_HQ__c,
                                                    Location_Segment__r.ARV_Location_Physical_County__c,
                                                    Location_Segment__r.ARV_IsMI__c
                                                    from Package_Location_Segment_Rel__c where Contract__c =:drContractId and
                                                   Location_Segment__r.ARV_IsCommonControll__c = false LIMIT 1000]){
            
            String county = rltn.Location_Segment__r.ARV_Location_Physical_County__c.contains(HEADQCHECK) ? 
                                                rltn.Location_Segment__r.ARV_Location_Physical_County__c.split(STRINGSPLIT)[1]:
                                                        rltn.Location_Segment__r.ARV_Location_Physical_County__c;
            //county = county.containsWhitespace() ? county.deleteWhitespace() : county;
            if( pckgMap.get(rltn.Package__c).ARV_Medical_Plan__r.PCP_Focus__c && 
                ((rltn.Location_Segment__r.ARV_IsMI__c && !countyList.contains(county)) || !rltn.Location_Segment__r.ARV_IsMI__c ||
                (rltn.Location_Segment__r.ARV_IsMI__c && countyList.contains(county) && containsnonPcpCounty )) ){
                
                pcpPckg.add(pckgMap.get(rltn.Package__c));
                medicalId.add(pckgMap.get(rltn.Package__c).ARV_Medical_Plan__c);
            }
            if( ((rltn.Location_Segment__r.ARV_IsMI__c && !countyList.contains(county)) || 
                !rltn.Location_Segment__r.ARV_IsMI__c) && pckgMap.get(rltn.Package__c).ARV_Medical_Plan__r.PCP_Focus__c){
                locPckgRltnMap.add(rltn.Id);
            }
        }                                   
        Map<Id,Id> sisItemIdMap = new Map<Id,Id>();
        if(!medicalId.isEmpty()){                       
            List<vlocity_ins__ContractLineItem__c> sisPlans = new List<vlocity_ins__ContractLineItem__c>();
            Set<Id> sisProdId = new Set<Id>();          
            vlocity_ins__ContractLineItem__c item = null;
            for(Id con : medicalId){           //create contract line item for sister product               
                sisProdId.add(sisterProdMap.get(con));
                item = new vlocity_ins__ContractLineItem__c();
                item.vlocity_ins__ContractId__c = drContractId;             
                item.vlocity_ins__Product2Id__c = sisterProdMap.get(con);
                item.Name=sisProdData.get(sisterProdMap.get(con)).ProductCode+HYPHEN+
                                   sisProdData.get(sisterProdMap.get(con)).name;
                sisPlans.add(item);             
            }
            database.insert(sisPlans);            
            for(vlocity_ins__ContractLineItem__c cont : [select id,vlocity_ins__Product2Id__c 
                                                         from vlocity_ins__ContractLineItem__c
                                                         where vlocity_ins__Product2Id__c IN: sisProdId 
                                                         and vlocity_ins__ContractId__c =:drContractId LIMIT 1000]){
                sisItemIdMap.put(cont.vlocity_ins__Product2Id__c,cont.id);
            }
        }
        Package__c pckg = null;
        List<Package__c> packList = new List<Package__c>();
        for(Package__c pack: pcpPckg){
            
            pckg = new Package__c();
            pckg.name = pack.name+STRINGA;
            pckg.ARV_Contract_Id__c = drContractId;
            pckg.Sister_Parent_ID__c = pack.name;
            pckg.ARV_Medical_Plan__c = sisItemIdMap.get(sisterProdMap.get(pack.ARV_Medical_Plan__c));
            pckg.ARV_Dental_Plan__c = pack.ARV_Dental_Plan__c;
            pckg.ARV_Vision_Plan__c = pack.ARV_Vision_Plan__c;
            pckg.ARV_CDH_Package_Combination__c = pack.ARV_CDH_Package_Combination__c;
            pckg.RecordTypeId=devRecordTypeId;
            packList.add(pckg);
        }
        database.insert(packList);
        Map<string,Package__c> packMap = new Map<string,Package__c>();
        for(Package__c pckg1 : [select id,name from Package__c where ARV_Contract_Id__c =:drContractId LIMIT 100]){
            packMap.put(pckg1.name,pckg1);
        }
        List<Package_Location_Segment_Rel__c> dltRltnItems = new List<Package_Location_Segment_Rel__c>();        
        List<Package_Location_Segment_Rel__c> rltnItemsList = new List<Package_Location_Segment_Rel__c>();
        Package_Location_Segment_Rel__c locItem = null;
        for(Package_Location_Segment_Rel__c rltn : [select id,name,Contract__c,Package__c,
                                                    Package__r.name,Location_Segment__c 
                                                    from Package_Location_Segment_Rel__c 
                                                    where Contract__c =:drContractId and id IN: locPckgRltnMap LIMIT 1000]){
            /*if(locPckgRltnMap.containsKey(rltn.Location_Segment__c) 
               && locPckgRltnMap.get(rltn.Location_Segment__c).equals(rltn.Package__c)){*/
                dltRltnItems.add(rltn);
                locItem = new Package_Location_Segment_Rel__c();
                locItem.Location_Segment__c = rltn.Location_Segment__c;
                locItem.Package__c = packMap.get(rltn.Package__r.name+STRINGA).id;
                locItem.name = rltn.name+STRINGA;
                locItem.Contract__c = rltn.Contract__c;
                rltnItemsList.add(locItem);
            //}
        }
        database.delete(dltRltnItems);
        database.insert(rltnItemsList);
        }catch(Exception e){            
            throw new AuraHandledException(+e.getMessage());
        }
        
    }    
 /*************************************************************************************************************  
Class name : WrapperList
Params     : map
Return Type : null
Description :WrapperList() class is used to convert json to List.
***********************************************************************************************************/         
    private without sharing class WrapperList{
        private string locationName;
        private string aLCounty;
        private string aLZipCode;
        private string aLOutsideCounty;
        
        public List<WrapperList> parse(String json) {
            try{
                return (List<WrapperList>) System.JSON.deserialize(json, List<WrapperList>.class);
            }catch(Exception e){
                throw new AuraHandledException('errormsg' +e.getMessage());
            }
            
        }
    }
    /*************************************************************************************************************  
    Class name : CommonCnrlList
    Description :CommonCnrlList() class is used to convert Common Control json to List.
    ***********************************************************************************************************/         
    private without sharing class CommonCnrlList{
        private string companyName;
        private string companyFederalTaxID;
        private string cityName;
        private string cCZipCode;
        private string cCCounty;
        private string cCOutsideCounty;
        private string commAccountId;
        private Boolean commApprovalProcessUW;
        private Boolean approvalProcessUW;
        public List<CommonCnrlList> parse(String json) {
            try{
                return (List<CommonCnrlList>) System.JSON.deserialize(json, List<CommonCnrlList>.class);
            }catch(Exception e){
                throw new AuraHandledException(ERRMSG +e.getMessage());
            }
            
        }
    } 
}