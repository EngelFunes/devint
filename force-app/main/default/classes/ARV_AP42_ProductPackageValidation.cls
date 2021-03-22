/*****************************************************************************************
Class Name   : ARV_AP42_ProductPackageValidation. 
Date Created : 26-july-2019
Created By   : IDC Offshore
Description  :This is the class for package validation in enrollment process.
******************************************************************************************/
global without sharing class ARV_AP42_ProductPackageValidation  implements vlocity_ins.VlocityOpenInterface2{
    private static final string METHODNAME='enrollMedicalValidation';
    private static final string ENROLLMEDICALVALIDATION='enrollMedicalValidation';
    private static final string VALERROR='error';
    private static final string PACKAGELOCATION='PackageLocation';
    private static final string PACKAGESELECTION='PackageSelection';
    private static final string PACKAGEPRODUCT1='PackageProduct1';
    private static final string PACKAGEPRODUCT2='PackageProduct2';
    private static final string PACKAGEPRODUCT3='PackageProduct3';
    private static final string NOOFPACKAGES='NoOfPackages';
    private static final string MEDICALLOOKUP1='MedicalProductidFormula1';
    private static final string MEDICALLOOKUP2='MedicalProductidFormula2';
    private static final string MEDICALLOOKUP3='MedicalProductidFormula3';
    private static final string MEDICALPACK1='MedicalPackLookup1';
    private static final string MEDICALPACK2='MedicalPackLookup2';
    private static final string MEDICALPACK3='MedicalPackLookup3';
    private static final string SELECTEMPLOYEESEGMENTS='SelectEmployeeSegments'; 
    private static final string ADDITIONALLOCATIONS ='AdditionalLocations';
    private static final string GROUPINFORMATION='GroupInformation';
    private static final string MULTIEMPLOYEE='MultiEmployee';
    private static final string MULTILOCATION='MultiLocation';
    private static final string COMMONCONTROL='CommonControl';     
    private static final string SIMPLYBLUE='Simply Blue';
    private static final string CBH='Community Blue HRA';
    private static final string SIMPLYBLUEPPO='Simply Blue PPO';
    private static final string SIMPLYBLUEHRA='Simply Blue HRA';
    private static final string SIMPLYBLUEHSA='Simply Blue HSA';
    private static final string BLUEROUTINECARE='Simply Blue Routine Care';
    private static final string PHYSCHOICE='Physician Choice Plan';
    private static final string HEALTHYACHIEVE='Healthy Blue Achieve';
    private static final string COMMUNITYBLUE='Community Blue';
    private static final string BCNHMO='BCN HMO';
    private static final string BLUEELECTPLUS='Blue Elect Plus'; 
    private static final string ROUTINECARE='Routine Care';
    private static final string BCNHRA='BCN HRA';  
    private static final string BCNHSA='BCN HSA';
    private static final string YES='Yes';  
    private static final string NOSTRING='No';
    private static final string HEALTHYLIVING='Healthy Blue Living';
    private static final string ERRORMSG='The selection of these products violates the coexistence rules. '+
    'Please select a different combination of products.';
    private static final string ERROROK='OK';
    private static final string SELECTQUERY = System.Label.ARV_CL24_ProductQuery;
    private static final string WHERECLAUSE  = ' where id IN : products and vlocity_ins__Type__c=: paramName ' ;
    private static final BOOLEAN TRUE_VAL = true;
    private static final BOOLEAN FALSE_VAL = false;
    private static final string OPENBRACE  = '[';
    private static final string CLOSEBRACE  = ']';
    private static final string HYPHEN  = '-';
    private static final string  HEADQUARTERS='Headquarters';
    private static final string LOCATION='Location';
    private static final string VALIDATE_PACKAGE='Please validate packages.';
    private static final string PACKAGE1= 'Package1';
    private static final string PACKAGE2= 'Package2';
    private static final string PACKAGE3= 'Package3';
    private static final string PACKAGENAME= 'Package';
    private static final string  PROCESSLOCATIONSONLY='processLocationsOnly';
    private static final string  PROCESSSEGMENTSONLY='processSegmentsOnly';
    private static final String NOTAVAILABLESTRING='N/A';
    private static final String ISPCPGROUP='isPCPGroup';
    private static final String PCPVALUE='PCP';
    private boolean isPCPCounty = false;
    private static final string HQCHECK ='HQ: ';
    private static final string SPLITWORD =': ';
    private static final string COUNTYLIST ='countyList';
    private static final string NAVALUE = 'N/A';
    private static final string MISTR ='MI';
    private static final string NONMI = 'nonMI';    
    private Set<Id> prodId = new Set<Id>();
    private Map<Id,Id> sisProdMap = new Map<Id,Id>();
    private Set<String> asgndPcpPckg = new Set<String>();
    private Set<String> slctdPckgs = new Set<String>();
    private List<String> segments = new List<String>();
    private Boolean isPCP = false;
    private Integer planPackage;    

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
        if (methodName == ENROLLMEDICALVALIDATION) 
        {
            enrollMedicalValidation(input,output);
        }        
        
    }catch(Exception e){
        success = FALSE_VAL;        
    }
    return success;
}
/*************************************************************************************************************  
Method name : enrollMedicalValidation
Params     : map
Return Type : null
Description :enrollMedicalValidation() method to fetch products data from dataJSON
***********************************************************************************************************/
global void enrollMedicalValidation(Map<String, Object> input, Map<String, Object> output)
{     
    Map<String,Object> packageLocationStep = (Map<String,Object>)input.get(PACKAGELOCATION);
    Map<String,Object> groupInformation = (Map<String,Object>)input.get(GROUPINFORMATION);        
    Map<String,Object> packageSelection = (Map<String,Object>)input.get(PACKAGESELECTION);        
    Map<String,Object> packageProduct1 = (Map<String,Object>)packageLocationStep.get(PACKAGEPRODUCT1);String msg ='';        
    Map<String,Object> packageProduct2 = (Map<String,Object>)packageLocationStep.get(PACKAGEPRODUCT2);
    Map<String,Object> packageProduct3 = (Map<String,Object>)packageLocationStep.get(PACKAGEPRODUCT3);    
    List<Object> countiesList = (List<Object>)input.get(COUNTYLIST);    
    List<WrapperList> adtnlLctnList = new List<WrapperList>();
    List<WrapperList> hQLctnList = new List<WrapperList>(); 
    List<WrapperList> allLctnList = new List<WrapperList>();    
    String multiEmployee=(String)groupInformation.get(MULTIEMPLOYEE);
    String multiLocation=(String)groupInformation.get(MULTILOCATION);
    String commonControl=(String)groupInformation.get(COMMONCONTROL);
    String employeeSegments =(String)groupInformation.get(SELECTEMPLOYEESEGMENTS);            
    adtnlLctnList = jsonToList(groupInformation.get(ADDITIONALLOCATIONS));    
    hQLctnList = jsonToList(groupInformation.get(HEADQUARTERS));     
    Boolean preError=false;
    Boolean postError =false;                   
    String firstSegment=multiEmployee==YES && employeeSegments !=null ?
                        employeeSegments.split(ARV_AP41_StringLiteralUtils.SLASH)[0]:'';
    String secondSegment=multiEmployee==YES && employeeSegments !=null ?
                        employeeSegments.split(ARV_AP41_StringLiteralUtils.SLASH)[1]:'';
    allLctnList.addAll(hQLctnList);
    if(!adtnlLctnList.isEmpty() && multiLocation == YES && commonControl == NOSTRING){allLctnList.addAll(adtnlLctnList);}    
    planPackage = Integer.valueOf(packageLocationStep.get(NOOFPACKAGES));     
    Id mP1 = (Id)packageProduct1.get(MEDICALLOOKUP1);
    Id mP2 = (packageProduct2 == null || planPackage == 1) ? null : (Id)packageProduct2.get(MEDICALLOOKUP2);
    Id mP3 = (packageProduct3 == null || planPackage != 3) ? null : (Id)packageProduct3.get(MEDICALLOOKUP3);    
    if(mP1 != null){
        prodId.add(mP1);
    }    
    if(mP2 != null){
        prodId.add(mP2); 
    } 
    if(mP3 != null){
        prodId.add(mP3); 
    }         
    for(Product2 prod: [select id,ARV_PCPFocus_SisterPlan__c from Product2 where id IN: prodId and 
                        PCP_Focus__c = true limit 500]){
            sisProdMap.put(prod.id,prod.ARV_PCPFocus_SisterPlan__c);
    }
    if(multiEmployee==YES){
        if(multiEmployee==YES && employeeSegments != null){
            segments = employeeSegments.split(ARV_AP41_StringLiteralUtils.SLASH);            
        }             
        isPCP = pcpCountyAsgndPcp(packageSelection,segments,allLctnList,packageProduct1,packageProduct2,packageProduct3,
                                  countiesList);
        preError=processSegmentDetails(allLctnList,packageSelection,firstSegment,countiesList,packageProduct1,
                                       packageProduct2,packageProduct3);
        postError=processSegmentDetails(allLctnList,packageSelection,secondSegment,countiesList,packageProduct1,
                                        packageProduct2,packageProduct3);
        output.put(firstSegment+VALERROR,preError);
        output.put(secondSegment+VALERROR,postError);        
    }/*if( multiLocation==NOSTRING && multiEmployee==YES){
        msg =validatePackage(prodId);
        system.debug('&&&&'+msg);
        output.put(VALERROR,msg);
    }*/     
    if( !adtnlLctnList.isEmpty() && multiLocation==YES && multiEmployee==NOSTRING ){                
        //HQ and location details fetching.
        isPCP = pcpCountyAsgndPcp(packageSelection,segments,allLctnList,packageProduct1,packageProduct2,packageProduct3,
                                  countiesList);
        
        List<Boolean> locErrs=processLocationDetails( packageSelection,allLctnList,countiesList,packageProduct1,
                                                     packageProduct2,packageProduct3);
        Boolean locErr = locErrs.contains(true) ? true : false ;
        output.put(LOCATION+VALERROR,locErr);
    }
    if(PlanPackage > 1 && ((commonControl == NOSTRING && multiLocation == NOSTRING && multiEmployee == NOSTRING) || 
                           (commonControl == YES && multiEmployee == NOSTRING))){
        Set<Id>  pcpId = new Set<Id>();
        if(!countiesList.contains(hQLctnList[0].aLCounty) ){
            for(Id prId : prodId){
              if(sisProdMap.containsKey(prId) && sisProdMap.get(prId) != null){
                pcpId.add(sisProdMap.get(prId));
              }else{
                pcpId.add(prId);
              }
            }
        }else{pcpId.addAll(prodId);}
          msg =validatePackage(pcpId);
          output.put(VALERROR,msg);
    } 
    //output.put(VALERROR,msg);
    if(multiEmployee == YES || (multiLocation == YES && commonControl == NOSTRING)){        
        pcpWarningLogic(allLctnList,countiesList,packageProduct1,packageProduct2,packageProduct3);
    }
    output.put(ISPCPGROUP,isPCPCounty);
} 
/***********************************************************************************************************  
Method name : validatePackage
Params     : List
Return Type : String
Description :validatePackage() logic to validate products selected for a package in enrollment process
*****************************************************************************************************************/    
public String validatePackage(Set<Id> prodList){
    try{
        List<String> bcbsmMap = new List<String>();
        List<String> bcnMap = new List<String>();
        List<String> pcpList = new List<String>();
        Integer bcnProducts =0;
        String validateMsg='';        
        ARV_AP07_QueryDataHelper.products = prodList;
        ARV_AP07_QueryDataHelper.paramName = ARV_AP41_StringLiteralUtils.MEDICALTYPE;                
        for(Product2 prod: (List<Product2>)ARV_AP07_QueryDataHelper.getsObjects(SELECTQUERY,WHERECLAUSE,null,null)){            
            if(prod.Carrier_Type__c == ARV_AP41_StringLiteralUtils.BCBSTYPE){
                bcbsmMap.add(prod.Family);                
            }else if(prod.Carrier_Type__c == ARV_AP41_StringLiteralUtils.BCNTYPE && !prod.PCP_Focus__c){
                bcnMap.add(prod.Family);                
            }else if(prod.PCP_Focus__c){
                pcpList.add(prod.Family);                
            }
            else{}
        } 
        bcnProducts = bcnMap.size()+pcpList.size();        
        validateMsg = productValidation(bcbsmMap,bcnMap,pcpList,bcnProducts); 
        system.debug('validatemsg:::'+validateMsg);
        return validateMsg;
    }
    catch(Exception e){            
        throw new AuraHandledException(+e.getMessage());
    }
}
    
   /***********************************************************************************************************  
Method name : pcpWarningLogic
Params     : List, Map, Map, Map
Return Type : Void
Description :PCP Warning Logic
*****************************************************************************************************************/  
    public void pcpWarningLogic(List<WrapperList> lctnList,List<Object> counties,Map<String,Object> pckg1,
                                Map<String,Object> pckg2,Map<String,Object> pckg3 ){   
        try{                                        
            String med1 = (String)pckg1.get(MEDICALPACK1);
            String med2 = (String)pckg2.get(MEDICALPACK2);
            String med3 = (String)pckg3.get(MEDICALPACK3);        
            for(WrapperList loc :lctnList){            
                String tempCounty = loc.aLCounty.contains(HQCHECK)?loc.aLCounty.split(SPLITWORD)[1]:loc.aLCounty;            
                if((!counties.contains(tempCounty) || loc.aLOutSideCounty!=null) && 
                        ( (med1 != null && med1.contains(PCPVALUE) ) ||
                      (med2!=null && med2.contains(PCPVALUE) ) || (med3!=null && med3.contains(PCPVALUE) ) )){
                    isPCPCounty = true;
                    break;
                }
            }
        }  catch(Exception e){ throw new AuraHandledException(+e.getMessage()); } 
    }
   /***********************************************************************************************************  
Method name : pcpWarningLogic
Params     : List, Map, Map, Map
Return Type : Void
Description :PCP Warning Logic
*****************************************************************************************************************/     
    public boolean pcpCountyAsgndPcp(Map<String,Object> asgnmntData,List<String> sgmnts,
            List<WrapperList> lctnList,Map<String,Object> packageProduct1,Map<String,Object> packageProduct2,
                                    Map<String,Object> packageProduct3,List<Object> counties){
        try{
        Set<String> pcpPckg = new Set<String>();
        Map<String,Set<String>> countyPckg = new Map<String,Set<String>>();
        if(packageProduct1.get(MEDICALPACK1)!=null && String.valueOf(packageProduct1.get(MEDICALPACK1)).contains(PCPVALUE)){
            pcpPckg.add(PACKAGE1);
        }
        if(planPackage>1 && packageProduct2.get(MEDICALPACK2)!=null && 
           String.valueOf(packageProduct2.get(MEDICALPACK2)).contains(PCPVALUE)){
            pcpPckg.add(PACKAGE2);
        }
        if(planPackage>2 && packageProduct3.get(MEDICALPACK3)!=null && 
           String.valueOf(packageProduct3.get(MEDICALPACK3)).contains(PCPVALUE)){
            pcpPckg.add(PACKAGE3);
        }
        for(Object pckg: asgnmntData.values()){
            slctdPckgs.addAll(String.valueof(pckg).split(ARV_AP41_StringLiteralUtils.SEPERATOR));
        }
        Set<String> setPckg = null;
        for(wrapperList loc: lctnList){            
            if( !NOTAVAILABLESTRING.equals(loc.aLCounty) ){
                String county = loc.aLCounty.contains(HQCHECK)?loc.aLCounty.split(SPLITWORD)[1]:loc.aLCounty;                                
                String temp = HYPHEN+loc.locationName+HYPHEN+loc.aLZipCode+HYPHEN+loc.aLCounty;                                  
                if(!string.isBlank(county) && counties.contains(county) && asgnmntData.containskey(temp) && 
                    asgnmntData.get(temp)!=null && sgmnts.isEmpty()){                    
                    setPckg = new Set<String>(String.valueof(asgnmntData.get(temp)).
                                                          split(ARV_AP41_StringLiteralUtils.SEPERATOR));
                    countyPckg.put(temp,setPckg);                   
                }
                for(String sgmnt : sgmnts){ 
                    temp = sgmnt+HYPHEN+loc.locationName+HYPHEN+loc.aLZipCode+HYPHEN+loc.aLCounty;                                        
                    if(counties.contains(county) && asgnmntData.containskey(temp) && asgnmntData.get(temp)!=null){                    
                        setPckg = new Set<String>(String.valueof(asgnmntData.get(temp)).
                                                          split(ARV_AP41_StringLiteralUtils.SEPERATOR));
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
/***********************************************************************************************************  
Method name : productValidation
Params     : List
Return Type : String
Description :productValidation() logic to validate products selected for a package in enrollment process
*****************************************************************************************************************/    
public String productValidation(List<String> bcbsmMap,List<String> bcnMap,List<String> pcpList,Integer bcnProducts){
    try{
        String message='';
        if(!bcbsmMap.isEmpty() && (bcbsmMap.contains(SIMPLYBLUE) || bcbsmMap.contains(SIMPLYBLUEHRA) 
                                   || bcbsmMap.contains(BLUEROUTINECARE))
           && (bcbsmMap.contains(HEALTHYACHIEVE) || bcbsmMap.contains(COMMUNITYBLUE))){                                
               message = ERRORMSG;
        }else if(!bcbsmMap.isEmpty() && bcbsmMap.size() > 1 && bcbsmMap.contains(SIMPLYBLUEHSA)
                    && bcbsmMap.contains(HEALTHYACHIEVE)){
                        message=ERRORMSG; 
        }
        //commented for HBA+HBA co exisance
       /* else if(bcbsmMap.size() > 1 && bcbsmMap.contains(HEALTHYACHIEVE)){          
            message=ERRORMSG;
        }*/ // Req:2904 starts here
        else if(!bcbsmMap.isEmpty()&&bcbsmMap.contains(PHYSCHOICE)&&
        (bcbsmMap.contains(COMMUNITYBLUE)||bcbsmMap.contains(CBH)||bcbsmMap.contains(SIMPLYBLUE)||
        bcbsmMap.contains(SIMPLYBLUEHRA)||bcbsmMap.contains(BLUEROUTINECARE)||bcbsmMap.contains(HEALTHYACHIEVE)))
        {
            message=ERRORMSG;
        }
//ReqId 2904 ends here
        
        else if(!bcnMap.isEmpty() && (bcnMap.contains(BCNHMO) || bcnMap.contains(BLUEELECTPLUS) || 
                                      bcnMap.contains(ROUTINECARE) || bcnMap.contains(BCNHRA) || bcnMap.contains(BCNHSA)) 
                && (bcnMap.contains(HEALTHYLIVING) || !pcpList.isEmpty())){
                    message=ERRORMSG;
                }
        //for HBL+HBL coexistance
        else if(pcpList.contains(HEALTHYLIVING) && bcnProducts >1  ){
            message=ERRORMSG;
        }
        else{
            message=ERROROK;
        }
        return message;
    }
    catch(Exception e){            
        throw new AuraHandledException(+e.getMessage());
    }
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
Class name : WrapperList
Params     : map
Return Type : null
Description :processMultiLocationDetails() class is used to convert json to List.
***********************************************************************************************************/  
private Boolean validatingMultiLocationDetails(Map<WrapperList,Set<String>>pckgList,List<Object>cntyList,
     Map<String,Object> packageProduct1,Map<String,Object> packageProduct2,Map<String,Object> packageProduct3){
   
    Set<Id> packagesIdSet = new Set<Id>();
    String err=ERROROK;   
    for(WrapperList locDtls: pckgList.keyset()){
        String county=locDtls.aLCounty !=NOTAVAILABLESTRING?locDtls.aLCounty:locDtls.aLOutsideCounty;
        String tempCounty = county.contains(HQCHECK)?county.split(SPLITWORD)[1]:county;
        Boolean isMI = locDtls.aLCounty !=NOTAVAILABLESTRING?true:false;        
        for(String str: pckgList.get(locDtls)){
            Id medId = null;
            String medProd = null;
            if( (isMI && !cntyList.contains(tempCounty)) || !isMI){                 
                if(str== PACKAGE1){
                  medProd = (String)packageProduct1.get(MEDICALPACK1);
                    medId = medProd.contains(PCPVALUE)?
                        sisProdMap.get((Id)packageProduct1.get(MEDICALLOOKUP1)) :(Id)packageProduct1.get(MEDICALLOOKUP1);
                }else if(str== PACKAGE2){
                     medProd = (String)packageProduct2.get(MEDICALPACK2);
                     medId = medProd.contains(PCPVALUE)?
                         sisProdMap.get((Id)packageProduct2.get(MEDICALLOOKUP2)) :(Id)packageProduct2.get(MEDICALLOOKUP2);   
                }else if(str== PACKAGE3){
                     medProd = (String)packageProduct3.get(MEDICALPACK3);
                     medId = medProd.contains(PCPVALUE)?
                         sisProdMap.get((Id)packageProduct3.get(MEDICALLOOKUP3)) :(Id)packageProduct3.get(MEDICALLOOKUP3);   
                }else{}
            }
            else{               
             medId=(str== PACKAGE1 && str!=null? (Id)packageProduct1.get(MEDICALLOOKUP1) :(str== PACKAGE2 &&
             str!=null ? (Id)packageProduct2.get(MEDICALLOOKUP2) :( str== PACKAGE3 && str!=null ? 
                                                            (Id)packageProduct3.get(MEDICALLOOKUP3) :null) ) );
            }       
           packagesIdSet.add(medId);
        }       
    }
    if(packagesIdSet.size()>1){           
       err =validatePackage(packagesIdSet); 
       system.debug('&&& err'+ err);      
   }
   return  err.equals(ERROROK)?false:true;
   
}
/*************************************************************************************************************  
Class name : WrapperList
Params     : map
Return Type : null
Description :processMultiLocationDetails() class is used to convert json to List.
***********************************************************************************************************/  
private Boolean processSegmentDetails(List<WrapperList> lctnList,Map<String,Object> packageSelection,
                      String firstSegment,List<Object>cntyList,Map<String,Object> packageProduct1,
                            Map<String,Object> packageProduct2,Map<String,Object> packageProduct3 ){
                                          
    Map<WrapperList,Set<String>> pckgSet = new Map<WrapperList,Set<String>>();
    Boolean errMsg=false;  
        
    for(WrapperList wrapper: lctnList){     
        String countyName=wrapper.aLCounty !=NOTAVAILABLESTRING?wrapper.aLCounty:wrapper.aLOutsideCounty;
        String county = countyName.contains(HQCHECK)?countyName.split(SPLITWORD)[1]:countyName;           
        String temp = firstSegment+HYPHEN+wrapper.locationName+HYPHEN+wrapper.aLZipCode+HYPHEN+countyName;                 
        Set<String> locSet = null;                                          
        if( packageSelection.containskey(temp) && packageSelection.get(temp)!= null){                 
            locSet = new set<String>(                 
              String.valueOf(packageSelection.get(temp)).split(ARV_AP41_StringLiteralUtils.SEPERATOR) );
            
            if( ((!cntyList.contains(county) && wrapper.aLCounty !=NOTAVAILABLESTRING) || 
                            wrapper.aLCounty == NOTAVAILABLESTRING) && isPCP){                          
                for(String pkg: asgndPcpPckg){
                    if(!locSet.contains(pkg)){
                        locSet.add(pkg);        
                    }
                }
            }
            pckgSet.put(wrapper,locSet);
        }
        else if(((!cntyList.contains(county) && wrapper.aLCounty !=NOTAVAILABLESTRING) || 
                            wrapper.aLCounty == NOTAVAILABLESTRING) && isPCP){
            
            locSet = new set<String>();
            for(String pkg: asgndPcpPckg){
                if(!locSet.contains(pkg)){
                    locSet.add(pkg);        
                }
            }
            if(!locSet.isEmpty()){pckgSet.put(wrapper,locSet);}
         }else{}    
    }                                         
     errMsg= validatingMultiLocationDetails(pckgSet,cntyList,packageProduct1,packageProduct2,packageProduct3);                                                   
      return errMsg;                                      
}   
/*************************************************************************************************************  
Class name : WrapperList
Params     : map
Return Type : null
Description :processMultiLocationDetails() class is used to convert json to List.
***********************************************************************************************************/    
private  List<Boolean> processLocationDetails(Map<String,Object> packageSelection,List<WrapperList> hQLctnList,
                                                List<Object>cntyList,Map<String,Object> packageProduct1,
                                              Map<String,Object> packageProduct2,Map<String,Object> packageProduct3){
                                                    
       Boolean hqlocError = false;
       Set<String> locSet = null;
       List<Boolean> errListLoc= new List<Boolean>();
       Map<WrapperList,Set<String>> tempMap = null;
       for(WrapperList wrapper: hQLctnList){           
           String countyName=wrapper.aLCounty !=NOTAVAILABLESTRING?wrapper.aLCounty:wrapper.aLOutsideCounty;
           String county = countyName.contains(HQCHECK)?countyName.split(SPLITWORD)[1]:countyName;           
           String temp = HYPHEN+wrapper.locationName+HYPHEN+wrapper.aLZipCode+HYPHEN+countyName;
           tempMap = new Map<WrapperList,Set<String>>();
           
            if(packageSelection.containsKey(temp) && packageSelection.get(temp)!=null){
                string packages=String.valueof(packageSelection.get(temp)).contains(PACKAGEName)?
                                                  String.valueof(packageSelection.get(temp)):null;                  
                locSet= new set<String>(String.valueof(packageSelection.get(temp)).
                                               split(ARV_AP41_StringLiteralUtils.SEPERATOR));           
                if( ((!cntyList.contains(county) && wrapper.aLCounty !=NOTAVAILABLESTRING) || 
                            wrapper.aLCounty == NOTAVAILABLESTRING) && isPCP){                  
                    for(String pkg: asgndPcpPckg){
                        if(!locSet.contains(pkg)){
                            locSet.add(pkg);        
                        }
                    }
                }
                tempMap.put(wrapper,locSet);
                hqlocError = validatingMultiLocationDetails(tempMap,cntyList,packageProduct1,packageProduct2,packageProduct3);
                errListLoc.add(hqlocError);                   
            }           
       }
    return errListLoc;
}

}