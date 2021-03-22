/********************************************************************************************
Class Name   : ARV_AP_GWC_CreateSisterPackages. 
Date Created : 15-Oct-2020
Created By   : IDC Offshore 
Description  : This is used for creating Sister Packages after Cencos & create GCMP/rate                
*******************************************************/
global without sharing class ARV_AP_GWC_CreateSisterPackages implements vlocity_ins.VlocityOpenInterface {
private Id ContractId;
private static final string IDSTRING = 'id';
public List<Package__c> pckRec{get;set;}
private static string MODIFY=ARV_AP41_StringLiteralUtils.MODIFYPACKAGE;
private static string ADD=ARV_AP41_StringLiteralUtils.ADDPACKAGE;
private static string finalattr='';
private static string Attr='';
public static final string BCBSMCLUSTERNULL ='00';  
private static string quoteDetail='quoteDetail';
private static string gwcRatingJson='ARV_CF_Tech_RatingArea__c';
private static string groupInformation='GroupInformation';
private static string gwcReqEffectiveDate='GWCReqEffDateFormula';
private static string prvsContrctReqEffectiveDate='finalContReqEffDate';
private static string finalcontractRatingArea='finalContRA';
private static string countyCodeJson='CountyCode';
private static string phyAddressJson='PhyAdd';
private static string cityJson='City';
private static string countyJson='County';
private static string zipcodeJson='ZIPCode';
private static string stateJson='state';
private static string countryJson='Country';
private static string bcnMemberOption='BCN HSA Member Option';
private static string Updates='Update';
private static String OptIn='Opt-In';
private static String HBA='HBA Level:';
private static String BCNHSA='BCN HSA Member Option:';
private static String OptOut='Opt Out';
private static String RATINGAREA='RatingArea';
private static String ADDBENEFITPACKAGE='Add Benefit Package';
private static String EXISTINGBENEFITPACKAGE='Existing Benefit Package No Change';
private static String RATINGAREAUPDATE='Rating Area Update';
private static string MODIFYBENEFITCHNAGE ='Modify Benefit Package';
private static string RATINGAREAMODIFY='Rating Area with Modify Benefit Package';
private static string REQEFFDATEUPD='Requested Effective Date Updated';
/*****************************************************************************************
Method Name : invokeMethod. 
Date Created : 15-OCT-2020
Created By   : IDC Offshore
Description  :This is the class for contract record updation after  submitting GWC Flow
*******************************************************************************************/
global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options){           
                                    Boolean success = true;
                                    try{
                                        if(methodName == 'gwcPackageClone') {
                                        gwcPackageClone(input,output,options);
                                        }
                                    }catch(Exception e){
                                        system.debug('getMessage @@ '+e.getMessage());
                                        system.debug('line number@@ '+e.getLineNumber());
                                    }
                                    return success;
}
public static void gwcPackageClone(Map<String,Object> input, Map<String,Object> output,Map<String,Object> options)
{
        Map<string,Object> quoteMap = (Map<string,Object>)input.get(quoteDetail);
        string gwcRatingArea=String.valueOf(quoteMap.get(gwcRatingJson));
        Map<string,Object> groupInfoMap = (Map<string,Object>)input.get(groupInformation);
        String gwcReqEffDate=String.valueOf(groupInfoMap.get(gwcReqEffectiveDate));
        String prvsContrctReqEffDate=String.valueOf(input.get(prvsContrctReqEffectiveDate));
        string prvsContrctRatingArea=String.valueOf(input.get(finalcontractRatingArea));
        //Map<string,Object> addressMap = (Map<string,Object>)input.get('GroupInformation');
        string CountyCode=String.valueOf(groupInfoMap.get(countyCodeJson));
        string physicalAddress=String.valueOf(groupInfoMap.get(phyAddressJson));
        String City=String.valueOf(groupInfoMap.get(cityJson));
        String County=String.valueOf(groupInfoMap.get(countyJson));
        string ZIPCode=String.valueOf(groupInfoMap.get(zipcodeJson));
        string state=String.valueOf(groupInfoMap.get(stateJson));
        string Country=String.valueOf(groupInfoMap.get(countryJson));
        //system.debug('gwcRatingArea::'+gwcRatingArea);
        List<GA_City_Code__c>  cityList=[select id,name from GA_City_Code__c limit 5000];
     //   system.debug('cityCode::'+cityList.size());
        map<string,id> cityMap=new map<string,id>();
        for(GA_City_Code__c cityCode:cityList){
            cityMap.put(cityCode.Name,cityCode.Id);
        }
        String contractId= String.valueof(input.get('contractId')); 
        Contract con= new contract();
        con = [select id,vlocity_ins__EnrollmentCensusId__c from Contract where id=:contractId];
       // system.debug('CensusId***'+con.vlocity_ins__EnrollmentCensusId__c);
        list<vlocity_ins__GroupCensusMember__c> lstcmember=[select id,ARV_CDH_Member__c,vlocity_ins__CensusId__c,ARV_Package__c,ARV_Is_Dental_Selected__c,ARV_Is_Medical_Selected__c,ARV_Is_Vision_Selected__c,Medical_Product_Id__c,Vision_Product_Id__c,Dental_Product_Id__c
                                                            from vlocity_ins__GroupCensusMember__c where vlocity_ins__CensusId__c=:con.vlocity_ins__EnrollmentCensusId__c ];
        //system.debug('NoofCensusMembers***'+lstcmember.size());
        //system.debug('CensusMembers***'+lstcmember);
        List<Package__c> packlist =[select id,ARV_GWC_Dental_Transaction__c,ARV_GWC_Medical_Transaction__c,ARV_GWC_Vision_Transaction__c,Package_Number__c,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Benefit_Package_Type__c,ARV_Pediatric_Vision_Plan__c from Package__c where 
                                    ARV_Contract_Id__c=:contractId /*AND (ARV_GWC_Benefit_Package_Type__c=:MODIFY OR ARV_GWC_Benefit_Package_Type__c=:ADD)*/];
       /* System.debug('ARV_GWC_Benefit_Package_Type__c'+packlist[0].ARV_GWC_Benefit_Package_Type__c);
    	System.debug('***NoOfPckgs***'+packlist.size());
        System.debug('***packlist***'+packlist);
        System.debug('::: Packlist::'+packlist[0].ARV_GWC_Package_Change_Attributes__c);*/
            for(Package__c pkg:packlist) {
            if(pkg!=null){
                if(pkg.ARV_GWC_Package_Change_Attributes__c!=null){
                Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(pkg.ARV_GWC_Package_Change_Attributes__c);   
               // System.debug('obj'+obj);
                string newDentalPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWDENTALPLAN);
                string oldDentalPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDDENTALPLAN);
                string newVisionPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWVISIONPLAN);
                string oldVisionPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDVISIONPLAN);
                string newDentalType=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWDENTALTYPE);
                string oldDentalType=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDDENTALTYPE);
                string newVisionType=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWVISIONTYPE);
                string oldVisionType=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDVISIONTYPE);
                string bcnoption=(string)obj.get(bcnMemberOption);
               // System.debug('newDentalType' +newDentalType);
                //System.debug('oldDentalType'+oldDentalType);
               // System.debug('newVisionType' +newVisionType);
               // System.debug('oldVisionType'+oldVisionType);
                string oldCarrier=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDCARRIER);
                string newCarrier=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWCARRIER);
                string oldMedicalPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDMEDICALPLAN);
                string newMedicalPlan=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWMEDICALPLAN);
                string oldProductFamily=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDPRODUCTFAMILY);
                string newProductFamily=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWPRODUCTFAMILY);
                string oldCDHPckgComb=(string)obj.get(ARV_AP41_StringLiteralUtils.OLDCDHPLAN);
                string newCDHPckgComb=(string)obj.get(ARV_AP41_StringLiteralUtils.NEWCDHPLAN);
                    if(newCarrier==ARV_AP41_StringLiteralUtils.BCBSTYPE) {
                      if(oldDentalType!=ARV_AP41_StringLiteralUtils.VOLUNTARY && newDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY)
                        {
                        //system.debug('BCBS Voluntary Dental');
                        Set<id> pckgId1= new Set<Id>();
                        List<Package__c> clonedPckgs = new List<Package__c>();
                        pckgId1.add(pkg.Id);
                        List<Package__c> packageslist1 = new List<Package__c>();
                        packageslist1=[SELECT Id,Sister_Parent_ID__c,ARV_Pediatric_Vision_Plan__c,ARV_Tech_GWC_Legacy_Id__c,Package_Number__c,Name,ARV_Contract_Id__c,Original_Package_Id__c,ARV_Medical_Plan__c,ARV_Dental_Plan__c,ARV_Vision_Plan__c,RecordTypeId,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Benefit_Package_Type__c FROM Package__c where id IN : pckgId1 AND (NOT( Name like '%SP%' ))];
                        for(Package__c pck:packageslist1)
                        {
                        Map<String, Object> objc = (Map<String, Object>) JSON.deserializeUntyped(pck.ARV_GWC_Package_Change_Attributes__c);  
                            objc.put(HBA,null);
                            objc.put(BCNHSA,null);
                            Attr=JSON.serialize(objc);
                           // system.debug('****Attr****'+Attr);
                            pck.ARV_GWC_Package_Change_Attributes__c=Attr;
                        }
                        update packageslist1;
                        Attr='';
                       // system.debug('packageslist1'+packageslist1);
                        list<vlocity_ins__ContractLineItem__c> plans =[select id,name,vlocity_ins__ProductType__c,vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c=:contractId AND vlocity_ins__ProductCode__c = '15560MI0480002'];
                        
                       // system.debug('***plans****'+plans);
                        if(packageslist1.size()>0){
                            for(Package__c pckg:packageslist1){        
                         //   System.debug('Packages-->'+pckg.Name);
                            Package__c clonePckg = pckg.clone(false,true,false,false);
                            clonePckg.Name = clonePckg.Name+'-SP';
                            clonePckg.Sister_Parent_ID__c = pckg.id;
                            clonePckg.ARV_Pediatric_Vision_Plan__c=pckg.ARV_Pediatric_Vision_Plan__c;
                                if(plans.size()>0){
                                    clonePckg.ARV_Dental_Plan__c=plans[0].id;
                                }
                                else{
                                    clonePckg.ARV_Dental_Plan__c=null;  
                                }
                            clonedPckgs.add(clonePckg);
                          // System.debug('**clonedPckgId**'+clonePckg.id);
                          // System.debug('**clonedPckgs**'+clonedPckgs);
                            }
                            insert clonedPckgs;
                           // system.debug('***insertedclonedpackage****'+clonedPckgs);
                            finalattr='';
                          }
                            //List<vlocity_ins__GroupCensusMember__c> denSelectd =[select id,ARV_Is_Dental_Selected__c from vlocity_ins__GroupCensusMember__c where ARV_Is_Dental_Selected__c!=true and vlocity_ins__CensusId__c=:con.vlocity_ins__EnrollmentCensusId__c ];
                            //system.debug('NoofdenSelectd***'+denSelectd.size());
                            if(clonedPckgs.size()>0){
                            for(vlocity_ins__GroupCensusMember__c gcm:lstcmember){
                                if(gcm.ARV_Is_Dental_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs[0].id;
                                }
                            }
                                update lstcmember;
                            }
                            
                        }  
                         
                        
                      //  system.debug('*****Condition2*****');
                        if(oldProductFamily!=ARV_AP41_StringLiteralUtils.HBACH && newProductFamily==ARV_AP41_StringLiteralUtils.HBACH && pkg.ARV_GWC_Dental_Transaction__c!=Updates && pkg.ARV_GWC_Vision_Transaction__c!=Updates)
                        {
                        //system.debug('BCBS HBA');
                        Set<id> pckgId2= new Set<Id>();
                        List<Package__c> clonedPckgs1 = new List<Package__c>();
                        pckgId2.add(pkg.Id);
                        List<Package__c> packageslist2 = new List<Package__c>();
                        packageslist2=[SELECT Id,Sister_Parent_ID__c,ARV_Pediatric_Vision_Plan__c,ARV_Tech_GWC_Legacy_Id__c,Name,ARV_Contract_Id__c,Original_Package_Id__c,ARV_Medical_Plan__c,ARV_Dental_Plan__c,ARV_Vision_Plan__c,RecordTypeId,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Benefit_Package_Type__c FROM Package__c where id IN : pckgId2 AND (NOT( Name like '%SP%' ))];
                        update packageslist2;
                        for(Package__c pck1:packageslist2)
                        {
                        Map<String, Object> objc1 = (Map<String, Object>) JSON.deserializeUntyped(pck1.ARV_GWC_Package_Change_Attributes__c);  
                        //    System.debug('objc1'+objc1);
                            objc1.put(HBA,ARV_AP41_StringLiteralUtils.ENHANCED);
                            objc1.put(BCNHSA,null);
                            Attr=JSON.serialize(objc1);
                          //  system.debug('****Attr****'+Attr);
                            pck1.ARV_GWC_Package_Change_Attributes__c=Attr;
                        }
                        update packageslist2;
                        Attr='';
 
                       system.debug('packageslist2'+packageslist2);
                        if(packageslist2.size()>0){
                            for(Package__c pckg1:packageslist2){       
                         //   System.debug('Packages-->'+pckg1.Name);
                            Package__c clonePckg1 = pckg1.clone(false,true,false,false);
                            clonePckg1.Name = clonePckg1.Name+'-SP';
                            clonePckg1.Sister_Parent_ID__c = pckg1.id;
                            clonePckg1.ARV_Pediatric_Vision_Plan__c=pckg1.ARV_Pediatric_Vision_Plan__c;
                            Map<String, Object> object1 = (Map<String, Object>) JSON.deserializeUntyped(pckg1.ARV_GWC_Package_Change_Attributes__c);  
                          //  System.debug('object'+object1);
                            object1.put(HBA,ARV_AP41_StringLiteralUtils.STANDARD);
                            finalAttr=JSON.serialize(object1);
                          //  system.debug('****finalAttr****'+finalAttr);
                            clonePckg1.ARV_GWC_Package_Change_Attributes__c=finalAttr;
                           // system.debug('****pckg1.ARV_GWC_Package_Change_Attributes__c****'+pckg1.ARV_GWC_Package_Change_Attributes__c);
                            clonedPckgs1.add(clonePckg1);
                          //System.debug('**clonedPckgId**'+clonePckg1.id);
                          //System.debug('**clonedPckgs1**'+clonedPckgs1);
                            }
                            insert clonedPckgs1;
                            system.debug('***insertedclonedpackage****'+clonedPckgs1);
                            finalAttr='';
                           
                        }
                        }
                      //  system.debug('*****Condition3*****');
                        if(oldDentalType!=ARV_AP41_StringLiteralUtils.VOLUNTARY && newDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY && oldProductFamily!='Healthy Blue Achieve' && newProductFamily=='Healthy Blue Achieve'&& pkg.ARV_GWC_Dental_Transaction__c==Updates && pkg.ARV_GWC_Medical_Transaction__c==Updates && pkg.ARV_GWC_Vision_Transaction__c!=Updates)
                        {
                        //system.debug('BCBS HBA Vol Dental'); 
                        Set<id> pckgId3= new Set<Id>();
                        List<Package__c> clonedPckgs2 = new List<Package__c>();
                        pckgId3.add(pkg.Id);
                        List<Package__c> packageslist3 = new List<Package__c>();
                        packageslist3=[SELECT Id,Sister_Parent_ID__c,ARV_Pediatric_Vision_Plan__c,ARV_Tech_GWC_Legacy_Id__c,Name,ARV_Contract_Id__c,Original_Package_Id__c,ARV_Medical_Plan__c,ARV_Dental_Plan__c,ARV_Vision_Plan__c,RecordTypeId,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Benefit_Package_Type__c FROM Package__c where id IN : pckgId3 AND (NOT( Name like '%SP%' ))];
                        for(Package__c pck2:packageslist3)
                        {
                        Map<String, Object> objc2 = (Map<String, Object>) JSON.deserializeUntyped(pck2.ARV_GWC_Package_Change_Attributes__c);  
                         //   System.debug('objc2'+objc2);
                            objc2.put(HBA,ARV_AP41_StringLiteralUtils.ENHANCED);
                            objc2.put(BCNHSA,null);
                            Attr=JSON.serialize(objc2);
                         //   system.debug('****Attr****'+Attr);
                            pck2.ARV_GWC_Package_Change_Attributes__c=Attr;
                        }
                        update packageslist3;
                        Attr='';
                        system.debug('packageslist3'+packageslist3);
                        list<vlocity_ins__ContractLineItem__c> plans2 =[select id,name,vlocity_ins__ProductType__c,vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c=:contractId AND vlocity_ins__ProductCode__c = '15560MI0480002'];
                        
                       // system.debug('***plans2****'+plans2);
                        if(packageslist3.size()>0){
                            for(Package__c pckg2:packageslist3){        
                           // System.debug('Packages-->'+pckg2.Name);
                            //system.debug('Sister Package 1');
                            Package__c sp1 = pckg2.clone(false,true,false,false);
                            sp1.Name = sp1.Name+'-SP';
                            sp1.Sister_Parent_ID__c = pckg2.id;
                            //sp1.ARV_Pediatric_Vision_Plan__c=pckg2.ARV_Pediatric_Vision_Plan__c;
                                if(plans2.size()>0){
                                    sp1.ARV_Dental_Plan__c=plans2[0].id;
                                }
                                else{
                                    sp1.ARV_Dental_Plan__c=null;  
                                }
                                clonedPckgs2.add(sp1);
                                finalAttr='';
                           /* System.debug('**clonedPckgId**'+sp1.id);
                            System.debug('**clonedPckgs2**'+clonedPckgs2);
                            System.debug('**SP1**'+sp1.Name);*/
                                
                          //  system.debug('Sister Package 2');
                            Package__c SP2 = pckg2.clone(false,true,false,false);
                            SP2.Name = SP2.Name+'-SP';
                            SP2.Sister_Parent_ID__c = pckg2.id;
                           // SP2.ARV_Pediatric_Vision_Plan__c=pckg2.ARV_Pediatric_Vision_Plan__c;
                            if(plans2.size()>0){
                                    SP2.ARV_Dental_Plan__c=plans2[0].id;
                                }
                                else{
                                    SP2.ARV_Dental_Plan__c=null;  
                                }
                            Map<String, Object> object21 = (Map<String, Object>) JSON.deserializeUntyped(pckg2.ARV_GWC_Package_Change_Attributes__c);  
                            //System.debug('object'+object21);
                            object21.put(HBA,ARV_AP41_StringLiteralUtils.STANDARD);
                            finalAttr=JSON.serialize(object21);
                            //system.debug('****finalAttr****'+finalAttr);
                            sp2.ARV_GWC_Package_Change_Attributes__c=finalAttr;
                            //system.debug('****pckg2.ARV_GWC_Package_Change_Attributes__c****'+pckg2.ARV_GWC_Package_Change_Attributes__c);
                            clonedPckgs2.add(SP2);
                            finalAttr ='';
                           /*System.debug('**clonedPckgId**'+sp2.id);
                           System.debug('**clonedPckgs2**'+clonedPckgs2);
                           System.debug('**SP2**'+sp2.Name);*/
                                
                           // system.debug('Sister Package 3');
                            Package__c sp3 = pckg2.clone(false,true,false,false);
                            sp3.Name = sp3.Name+'-SP';
                            sp3.Sister_Parent_ID__c = pckg2.id;
                           // sp3.ARV_Pediatric_Vision_Plan__c=pckg2.ARV_Pediatric_Vision_Plan__c;
                            Map<String, Object> object23 = (Map<String, Object>) JSON.deserializeUntyped(pckg2.ARV_GWC_Package_Change_Attributes__c);  
                           // System.debug('object'+object23);
                            object23.put(HBA,ARV_AP41_StringLiteralUtils.STANDARD);
                            finalAttr=JSON.serialize(object23);
                            //system.debug('****finalAttr****'+finalAttr);
                            sp3.ARV_GWC_Package_Change_Attributes__c=finalAttr;
                            //system.debug('****pckg2.ARV_GWC_Package_Change_Attributes__c****'+pckg2.ARV_GWC_Package_Change_Attributes__c);
                            clonedPckgs2.add(sp3);
                           /* System.debug('**clonedPckgId**'+sp3.id);
                            System.debug('**clonedPckgs2**'+clonedPckgs2);
                            System.debug('**SP3**'+sp3.Name);*/
                            }
                            insert clonedPckgs2;
                           // system.debug('***insertedclonedpackage****'+clonedPckgs2); 
                            finalattr='';
                            
                        }
                            if(clonedPckgs2.size()>0){
                            for(vlocity_ins__GroupCensusMember__c gcm:lstcmember){
                                if(gcm.ARV_Is_Dental_Selected__c!=TRUE){
                                    gcm.ARV_Package__c=clonedPckgs2[0].id;
                                    
                                }
                            }
                                update lstcmember;
                            }
                        }
                    }
                  if(newCarrier==ARV_AP41_StringLiteralUtils.BCNTYPE){
                      if(oldDentalType!=ARV_AP41_StringLiteralUtils.VOLUNTARY && newDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY && pkg.ARV_GWC_Vision_Transaction__c!=Updates && pkg.ARV_GWC_Medical_Transaction__c!=Updates)
                           //&& pkg.ARV_GWC_Medical_Transaction__c!='Update'&& pkg.ARV_GWC_Vision_Transaction__c!='Update'
                        {
                       // system.debug('BCN Vol Dental');
                        Set<id> pckgId1= new Set<Id>();
                        List<Package__c> clonedPckgs = new List<Package__c>();
                        pckgId1.add(pkg.Id);
                        List<Package__c> bcnvolden = new List<Package__c>();
                        bcnvolden=[SELECT Id,Sister_Parent_ID__c,ARV_Pediatric_Vision_Plan__c,ARV_Tech_GWC_Legacy_Id__c,Package_Number__c,Name,ARV_Contract_Id__c,Original_Package_Id__c,ARV_Medical_Plan__c,ARV_Dental_Plan__c,ARV_Vision_Plan__c,RecordTypeId,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Benefit_Package_Type__c FROM Package__c where id IN : pckgId1 AND (NOT( Name like '%SP%' ))];

                        for(Package__c pck:bcnvolden)
                        {
                        Map<String, Object> objc = (Map<String, Object>) JSON.deserializeUntyped(pck.ARV_GWC_Package_Change_Attributes__c);  
                        //    System.debug('objc'+objc);
                            objc.put(HBA,null);
                            objc.put(BCNHSA,null);
                            Attr=JSON.serialize(objc);
                          //  system.debug('****Attr****'+Attr);
                            pck.ARV_GWC_Package_Change_Attributes__c=Attr;
                        }
                        update bcnvolden;
                        Attr='';
                      //  system.debug('packages****'+packageslist1);
                        list<vlocity_ins__ContractLineItem__c> plans =[select id,name,vlocity_ins__ProductType__c,vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c=:contractId AND vlocity_ins__ProductCode__c = '15560MI0480002'];
                        
                       // system.debug('***plans****'+plans);
                        if(bcnvolden.size()>0){
                            for(Package__c pckg:bcnvolden){        
                         //   System.debug('Packages-->'+pckg.Name);
                            Package__c clonePckg = pckg.clone(false,true,false,false);
                            clonePckg.Name = clonePckg.Name+'-SP';
                            clonePckg.Sister_Parent_ID__c = pckg.id;
                            clonePckg.ARV_Pediatric_Vision_Plan__c=pckg.ARV_Pediatric_Vision_Plan__c;
                                if(plans.size()>0){
                                    clonePckg.ARV_Dental_Plan__c=plans[0].id;
                                }
                                else{
                                    clonePckg.ARV_Dental_Plan__c=null;  
                                }
                            clonedPckgs.add(clonePckg);
                           // System.debug('**clonedPckgId**'+clonePckg.id);
                           // System.debug('**clonedPckgs**'+clonedPckgs);
                            }
                            insert clonedPckgs;
                            //system.debug('***insertedclonedpackage****'+clonedPckgs);   
                            finalattr='';
                          }
                            //List<vlocity_ins__GroupCensusMember__c> denSelectd =[select id,ARV_Is_Dental_Selected__c from vlocity_ins__GroupCensusMember__c where ARV_Is_Dental_Selected__c!=true and vlocity_ins__CensusId__c=:con.vlocity_ins__EnrollmentCensusId__c ];
                            //system.debug('NoofdenSelectd***'+denSelectd.size());
                            if(clonedPckgs.size()>0){
                            for(vlocity_ins__GroupCensusMember__c gcm:lstcmember){
                                if(gcm.ARV_Is_Dental_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs[0].id;
                                }
                            }
                                update lstcmember;
                            }
                            
                        }
                       
                       if(newVisionType==ARV_AP41_StringLiteralUtils.VOLUNTARY && oldVisionType!=ARV_AP41_StringLiteralUtils.VOLUNTARY && pkg.ARV_GWC_Dental_Transaction__c!=Updates && pkg.ARV_GWC_Medical_Transaction__c!=Updates)
                        {
                        //system.debug('BCN Vol Vision');
                        Set<id> pckgId4= new Set<Id>();
                        List<Package__c> clonedPckgs3 = new List<Package__c>();
                        pckgId4.add(pkg.Id);
                        List<Package__c> packageslist4 = new List<Package__c>();
                        packageslist4=[SELECT Id,Sister_Parent_ID__c,ARV_Pediatric_Vision_Plan__c,ARV_Tech_GWC_Legacy_Id__c,Name,ARV_Contract_Id__c,Original_Package_Id__c,ARV_Medical_Plan__c,ARV_Dental_Plan__c,ARV_Vision_Plan__c,RecordTypeId,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Benefit_Package_Type__c FROM Package__c where id IN : pckgId4 AND (NOT( Name like '%SP%' ))];
                        for(Package__c pck3:packageslist4)
                        {
                        Map<String, Object> objc3 = (Map<String, Object>) JSON.deserializeUntyped(pck3.ARV_GWC_Package_Change_Attributes__c);  
                         //   System.debug('objc3'+objc3);
                            objc3.put(HBA,null);
                            objc3.put(BCNHSA,null);
                            Attr=JSON.serialize(objc3);
                           // system.debug('****Attr****'+Attr);
                            pck3.ARV_GWC_Package_Change_Attributes__c=Attr;
                        }
                        update packageslist4;
                        Attr='';
                       //system.debug('packageslist4'+packageslist4);
                        list<vlocity_ins__ContractLineItem__c> plans3 =[select id,name,vlocity_ins__ProductType__c,vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c=:contractId AND vlocity_ins__ProductCode__c = 'SGBCNPVSN00001'];
                        
                       // system.debug('***plans3****'+plans3);
                        if(packageslist4.size()>0){
                            for(Package__c pckg3:packageslist4){        
                         //   System.debug('Packages-->'+pckg3.Name);
                            Package__c clonePckg = pckg3.clone(false,true,false,false);
                            clonePckg.Name = clonePckg.Name+'-SP';
                            clonePckg.Sister_Parent_ID__c = pckg3.id;
                                if(plans3.size()>0){
                                    clonePckg.ARV_Vision_Plan__c=plans3[0].id;
                                }
                                else{
                                    clonePckg.ARV_Vision_Plan__c=null;  
                                }
                            clonedPckgs3.add(clonePckg);
                           /* System.debug('**clonedPckgId**'+clonePckg.id);
                            System.debug('**clonedPckgs3**'+clonedPckgs3);*/
                            }
                            insert clonedPckgs3;
                       //system.debug('***insertedclonedpackage****'+clonedPckgs3);   
                        }
                        if(clonedPckgs3.size()>0){
                            for(vlocity_ins__GroupCensusMember__c gcm:lstcmember){
                                if(gcm.ARV_Is_Vision_Selected__c!=TRUE){
                                    gcm.ARV_Package__c=clonedPckgs3[0].id;
                                }
                            }
                                update lstcmember;
                            }
                        }
                       
                      
                        if(newVisionType==ARV_AP41_StringLiteralUtils.VOLUNTARY && oldVisionType!=ARV_AP41_StringLiteralUtils.VOLUNTARY && oldDentalType!=ARV_AP41_StringLiteralUtils.VOLUNTARY && newDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY && pkg.ARV_GWC_Medical_Transaction__c!=Updates) 
                        {
                        //system.debug('BCN Vol Dental and Vol Vision'); 
                        Set<id> pckgId4= new Set<Id>();
                        List<Package__c> clonedPckgs4 = new List<Package__c>();
                        pckgId4.add(pkg.Id);
                        //system.debug('original package'+pkg.Id);
                        List<Package__c> packageslist5 = new List<Package__c>();
                        packageslist5=[SELECT Id,Sister_Parent_ID__c,ARV_Pediatric_Vision_Plan__c,ARV_Tech_GWC_Legacy_Id__c,Name,ARV_Contract_Id__c,Original_Package_Id__c,ARV_Medical_Plan__c,ARV_Dental_Plan__c,ARV_Vision_Plan__c,RecordTypeId,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Benefit_Package_Type__c FROM Package__c where id IN : pckgId4 AND (NOT( Name like '%SP%' ))];
                        //system.debug('packageslist5::'+packageslist5.size());
                        //system.debug('packageslist5::'+packageslist5);
                        for(Package__c pck4:packageslist5)
                        {
                        Map<String, Object> objc4 = (Map<String, Object>) JSON.deserializeUntyped(pck4.ARV_GWC_Package_Change_Attributes__c);  
                           // System.debug('objc4'+objc4);
                            objc4.put(HBA,null);
                            objc4.put(BCNHSA,null);
                            Attr=JSON.serialize(objc4);
                           // system.debug('****Attr****'+Attr);
                            pck4.ARV_GWC_Package_Change_Attributes__c=Attr;
                        }
                        update packageslist5;
                        Attr='';
                       // system.debug('packages****'+packageslist5);
                        list<vlocity_ins__ContractLineItem__c> plans3 =[select id,name,vlocity_ins__ProductType__c,vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c=:contractId AND vlocity_ins__ProductCode__c = 'SGBCNPVSN00001'];
                        list<vlocity_ins__ContractLineItem__c> plans31 =[select id,name,vlocity_ins__ProductType__c,vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c=:contractId AND vlocity_ins__ProductCode__c = '15560MI0480002'];
                       // system.debug('***plans3****'+plans3);
                        if(packageslist5.size()>0){
                            Integer num4= 0;
                            for(Package__c pckg3:packageslist5){        
                         //   System.debug('Packages-->'+pckg3.Name);
                           // system.debug('Sister Package 1');
                            Package__c sp1 = pckg3.clone(false,true,false,false);
                            sp1.Name = sp1.Name+'-SP';
                            sp1.Sister_Parent_ID__c = pckg3.id;
                            sp1.ARV_Pediatric_Vision_Plan__c=pckg3.ARV_Pediatric_Vision_Plan__c;
                                if(plans3.size()>0){
                                    sp1.ARV_Vision_Plan__c=plans3[0].id;
                                }
                                else{
                                    sp1.ARV_Vision_Plan__c=null;  
                                }
                            clonedPckgs4.add(sp1);
                                num4=num4+1;
                            //System.debug('**clonedPckgId**'+sp1.id);
                            //System.debug('**clonedPckgs4**'+clonedPckgs4);

                           // system.debug('Sister Package 2');
                            Package__c SP2 = pckg3.clone(false,true,false,false);
                            SP2.Name = SP2.Name+'-SP';
                            SP2.Sister_Parent_ID__c = pckg3.id;
                            SP2.ARV_Pediatric_Vision_Plan__c=pckg3.ARV_Pediatric_Vision_Plan__c;
                            if(plans31.size()>0){
                                    SP2.ARV_Dental_Plan__c=plans31[0].id;
                                }
                                else{
                                    SP2.ARV_Dental_Plan__c=null;  
                                }
                            clonedPckgs4.add(SP2);
                                num4=num4+1;
                           // System.debug('**clonedPckgId**'+sp2.id);
                           // System.debug('**clonedPckgs4**'+clonedPckgs4);

                           // system.debug('Sister Package 3');
                            Package__c sp3 = pckg3.clone(false,true,false,false);
                            sp3.Name = sp3.Name+'-SP';
                            sp3.Sister_Parent_ID__c = pckg3.id;
                            sp3.ARV_Pediatric_Vision_Plan__c=pckg3.ARV_Pediatric_Vision_Plan__c;
                            if(plans3.size()>0 ){
                                    
                                    SP3.ARV_Vision_Plan__c=plans3[0].id;
                                }
                                else{
                                    SP3.ARV_Vision_Plan__c=null;                                       
                                }
                                if(plans31.size()>0)
                                {
                                  SP3.ARV_Dental_Plan__c=plans31[0].id;  
                                }
                                else
                                {
                                    SP3.ARV_Dental_Plan__c=null; 
                                }
                            clonedPckgs4.add(sp3);
                           /* System.debug('**clonedPckgId**'+sp3.id);
                            System.debug('**clonedPckgs4**'+clonedPckgs4);*/
                            }
                            insert clonedPckgs4;
                            //system.debug('***insertedclonedpackage****'+clonedPckgs4);
                            finalattr='';
                            
                        }
                        if(clonedPckgs4.size()>0){
                            for(vlocity_ins__GroupCensusMember__c gcm:lstcmember){
                                if(gcm.ARV_Is_Vision_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE && gcm.ARV_Is_Dental_Selected__c==ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs4[0].id;
                                }
                                if(gcm.ARV_Is_Vision_Selected__c==ARV_AP41_StringLiteralUtils.TRUE_VALUE && gcm.ARV_Is_Dental_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs4[1].id;
                                }
                                if(gcm.ARV_Is_Vision_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE && gcm.ARV_Is_Dental_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs4[2].id;
                                }
                            }
                                update lstcmember;
                            }
                        }
                        
                       // system.debug('*****Condition6*****');
                        if(newProductFamily== ARV_AP41_StringLiteralUtils.HSA && oldProductFamily!= ARV_AP41_StringLiteralUtils.HSA && newCDHPckgComb!=null&& pkg.ARV_GWC_Dental_Transaction__c!=Updates && pkg.ARV_GWC_Vision_Transaction__c!=Updates)
                        {
                        //system.debug('BCN HSA with CDH');
                        Set<id> pckgId6= new Set<Id>();
                        List<Package__c> clonedPckgs5 = new List<Package__c>();
                        List<Package__c> clonedPckgs51 = new List<Package__c>();
                        pckgId6.add(pkg.Id);
                        List<Package__c> packageslist6 = new List<Package__c>();
                        packageslist6=[SELECT Id,Sister_Parent_ID__c,Name,ARV_Tech_GWC_Legacy_Id__c,Package_Number__c,ARV_Contract_Id__c,Original_Package_Id__c,ARV_Medical_Plan__c,ARV_Dental_Plan__c,
                                       ARV_Vision_Plan__c,RecordTypeId,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Benefit_Package_Type__c 
                                       FROM Package__c where id IN : pckgId6 AND (NOT( Name like '%SP%' ))]; 
                        for(Package__c pck5:packageslist6)
                        {
                        Map<String, Object> objc5 = (Map<String, Object>) JSON.deserializeUntyped(pck5.ARV_GWC_Package_Change_Attributes__c);  
                           // System.debug('objc5'+objc5);
                            objc5.put(HBA,null);
                            objc5.put(BCNHSA,OptIn);
                            Attr=JSON.serialize(objc5);
                          //  system.debug('****Attr****'+Attr);
                            pck5.ARV_GWC_Package_Change_Attributes__c=Attr;
                        }
                        update packageslist6;
                        Attr='';
                       // system.debug('packages****'+packageslist6);

                        if(packageslist6.size()>0){
                            for(Package__c pckg3:packageslist6){        
                         //   System.debug('Packages-->'+pckg3.Name);
                            Package__c clonePckg = pckg3.clone(false,true,false,false);
                            clonePckg.Name = clonePckg.Name+'-SP';
                            clonePckg.Sister_Parent_ID__c = pckg3.id;
                            Map<String, Object> object3 = (Map<String, Object>) JSON.deserializeUntyped(pckg3.ARV_GWC_Package_Change_Attributes__c);   
                           // System.debug('object'+object3);
                            object3.put(BCNHSA,OptOut);
                            String finalattr;
                            finalattr=JSON.serialize(object3);
                           // system.debug('****finalattr****'+finalattr);
                            clonePckg.ARV_GWC_Package_Change_Attributes__c=finalattr;
                           // system.debug('****pckg3.ARV_GWC_Package_Change_Attributes__c****'+pckg3.ARV_GWC_Package_Change_Attributes__c);
                            clonedPckgs5.add(clonePckg);
                            /*System.debug('**clonedPckgId**'+clonePckg.id);
                            System.debug('**clonedPckgs5**'+clonedPckgs5);*/
                            }
                            insert clonedPckgs5;
                            
                            finalattr='';
                        }
                        if(clonedPckgs5.size()>0){
                            for(vlocity_ins__GroupCensusMember__c gcm:lstcmember){
                                if(gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOTAVAILABLE){
                                    gcm.ARV_Package__c=clonedPckgs5[0].id;
                                }
                                }
                            }
                                update lstcmember;
                            }
                        
                       
                     //  system.debug('*****condition7*****');
                       if(newProductFamily==ARV_AP41_StringLiteralUtils.HSA && oldProductFamily!=ARV_AP41_StringLiteralUtils.HSA && newCDHPckgComb!=null && oldDentalType!=ARV_AP41_StringLiteralUtils.VOLUNTARY && newDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY && pkg.ARV_GWC_Vision_Transaction__c!='Update')
                        {
                       // system.debug('BCN HSA with CDH with Vol Den');
                        Set<id> pckgId7= new Set<Id>();
                        List<Package__c> clonedPckgs6 = new List<Package__c>();
                        pckgId7.add(pkg.Id);
                        List<Package__c> packageslist7 = new List<Package__c>();
                        packageslist7=[SELECT Id,Sister_Parent_ID__c,ARV_Pediatric_Vision_Plan__c,ARV_Tech_GWC_Legacy_Id__c,Name,ARV_Contract_Id__c,Original_Package_Id__c,ARV_Medical_Plan__c,ARV_Dental_Plan__c,ARV_Vision_Plan__c,RecordTypeId,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Benefit_Package_Type__c FROM Package__c where id IN : pckgId7 AND (NOT( Name like '%SP%' ))];
                        for(Package__c pck6:packageslist7)
                        {
                        Map<String, Object> objc6 = (Map<String, Object>) JSON.deserializeUntyped(pck6.ARV_GWC_Package_Change_Attributes__c);  
                         //   System.debug('objc6'+objc6);
                            objc6.put(HBA,null);
                            objc6.put(BCNHSA,OptIn);
                            Attr=JSON.serialize(objc6);
                           // system.debug('****Attr****'+Attr);
                            pck6.ARV_GWC_Package_Change_Attributes__c=Attr;
                        }
                        update packageslist7;
                        Attr='';
                       
                        
                       // system.debug('packages****'+packageslist7);
                        
                        list<vlocity_ins__ContractLineItem__c> plans3 =[select id,name,vlocity_ins__ProductType__c,vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c=:contractId AND vlocity_ins__ProductCode__c = '15560MI0480002'];
                       // system.debug('***plans3****'+plans3);
                        if(packageslist7.size()>0){
                            for(Package__c pckg3:packageslist7){        
                           // System.debug('Packages-->'+pckg3.Name);
                           // system.debug('Sister Package 1');
                            Package__c sp1 = pckg3.clone(false,true,false,false);
                            sp1.Name = sp1.Name+'-SP';
                            sp1.Sister_Parent_ID__c = pckg3.id;
                            Map<String, Object> object4 = (Map<String, Object>) JSON.deserializeUntyped(pckg3.ARV_GWC_Package_Change_Attributes__c);   
                           // System.debug('object'+object4);
                            object4.put(BCNHSA,OptOut);
                            finalattr=JSON.serialize(object4);
                           // system.debug('****finalattr****'+finalattr);
                            sp1.ARV_GWC_Package_Change_Attributes__c=finalattr;
                            clonedPckgs6.add(sp1);
                           System.debug('**clonedPckgId**'+sp1.id);
                           System.debug('**clonedPckgs6**'+clonedPckgs6);

                           // system.debug('Sister Package 2');
                            Package__c SP2 = pckg3.clone(false,true,false,false);
                            SP2.Name = SP2.Name+'-SP';
                            SP2.Sister_Parent_ID__c = pckg3.id;
                            if(plans3.size()>0){
                                    SP2.ARV_Dental_Plan__c=plans3[0].id;
                                }
                                else{
                                    SP2.ARV_Dental_Plan__c=null;  
                                }
                            clonedPckgs6.add(SP2);
                           /*System.debug('**clonedPckgId**'+sp2.id);
                           System.debug('**clonedPckgs6**'+clonedPckgs6);*/

                           // system.debug('Sister Package 3');
                            Package__c sp3 = pckg3.clone(false,true,false,false);
                            sp3.Name = sp3.Name+'-SP';
                            sp3.Sister_Parent_ID__c = pckg3.id;
                            if(plans3.size()>0){
                                    SP3.ARV_Dental_Plan__c=plans3[0].id;
                                }
                                else{
                                    SP3.ARV_Dental_Plan__c=null;  
                                }
                            Map<String, Object> object5 = (Map<String, Object>) JSON.deserializeUntyped(pckg3.ARV_GWC_Package_Change_Attributes__c);   
                           // System.debug('object'+object5);
                            object5.put(BCNHSA,OptOut);
                            finalattr=JSON.serialize(object5);
                           // system.debug('****finalattr****'+finalattr);
                            sp3.ARV_GWC_Package_Change_Attributes__c=finalattr; 
                            clonedPckgs6.add(sp3);
                            /*System.debug('**clonedPckgId**'+sp3.id);
                            System.debug('**clonedPckgs6**'+clonedPckgs6);*/
                            }
                            insert clonedPckgs6;
                            finalattr='';
                           }
                        if(clonedPckgs6.size()>0){
                            for(vlocity_ins__GroupCensusMember__c gcm:lstcmember){
                                if((gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOTAVAILABLE) && gcm.ARV_Is_Dental_Selected__c==ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs6[0].id;
                                }
                                if((gcm.ARV_CDH_Member__c!=ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c!=ARV_AP41_StringLiteralUtils.NOTAVAILABLE) && gcm.ARV_Is_Dental_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs6[1].id;
                                }
                                if((gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOTAVAILABLE) && gcm.ARV_Is_Dental_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs6[2].id;
                                }
                            }
                                update lstcmember;
                            }
                        }
                       
                     //  system.debug('*****condition8*****');
                       if(newProductFamily==ARV_AP41_StringLiteralUtils.HSA && oldProductFamily!=ARV_AP41_StringLiteralUtils.HSA && newCDHPckgComb!=null&& oldVisionType!=ARV_AP41_StringLiteralUtils.VOLUNTARY && newVisionType==ARV_AP41_StringLiteralUtils.VOLUNTARY && pkg.ARV_GWC_Dental_Transaction__c!=Updates)
                        {
                        system.debug('BCN HSA with CDH with Vol VIsion');
                        Set<id> pckgId8= new Set<Id>();
                        List<Package__c> clonedPckgs7 = new List<Package__c>();
                        pckgId8.add(pkg.Id);
                        List<Package__c> packageslist8 = new List<Package__c>();
                        packageslist8=[SELECT Id,Sister_Parent_ID__c,ARV_Pediatric_Vision_Plan__c,ARV_Tech_GWC_Legacy_Id__c,Name,ARV_Contract_Id__c,Original_Package_Id__c,ARV_Medical_Plan__c,ARV_Dental_Plan__c,ARV_Vision_Plan__c,RecordTypeId,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Benefit_Package_Type__c FROM Package__c where id IN : pckgId8 AND (NOT( Name like '%SP%' ))];
                       
                        for(Package__c pck7:packageslist8)
                        {
                        Map<String, Object> objc7 = (Map<String, Object>) JSON.deserializeUntyped(pck7.ARV_GWC_Package_Change_Attributes__c);  
                           // System.debug('objc7'+objc7);
                            objc7.put(HBA,null);
                            objc7.put(BCNHSA,OptIn);
                            Attr=JSON.serialize(objc7);
                         //   system.debug('****Attr****'+Attr);
                            pck7.ARV_GWC_Package_Change_Attributes__c=Attr;
                        }
                        update packageslist8;
                        Attr='';
                       // system.debug('packages****'+packageslist8);
                        
                        list<vlocity_ins__ContractLineItem__c> plans3 =[select id,name,vlocity_ins__ProductType__c,vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c=:contractId AND vlocity_ins__ProductCode__c = 'SGBCNPVSN00001'];
                       // system.debug('***plans3****'+plans3);
                        if(packageslist8.size()>0){
                            for(Package__c pckg3:packageslist8){        
                           // System.debug('Packages-->'+pckg3.Name);
                           // system.debug('Sister Package 1');
                            Package__c sp1 = pckg3.clone(false,true,false,false);
                            sp1.Name = sp1.Name+'-SP';
                            sp1.Sister_Parent_ID__c = pckg3.id;
                            sp1.ARV_Pediatric_Vision_Plan__c=pckg3.ARV_Pediatric_Vision_Plan__c;  
                            Map<String, Object> object7 = (Map<String, Object>) JSON.deserializeUntyped(pckg3.ARV_GWC_Package_Change_Attributes__c);   
                           // System.debug('object'+object7);
                            object7.put(BCNHSA,OptOut);
                            finalattr=JSON.serialize(object7);
                           // system.debug('****finalattr****'+finalattr);
                            sp1.ARV_GWC_Package_Change_Attributes__c=finalattr;
                            clonedPckgs7.add(sp1);
                            finalattr='';
                            System.debug('**clonedPckgId**'+sp1.id);
                            System.debug('**clonedPckgs7**'+clonedPckgs7);

                           // system.debug('Sister Package 2');
                            Package__c SP2 = pckg3.clone(false,true,false,false);
                            SP2.Name = SP2.Name+'-SP';
                            SP2.Sister_Parent_ID__c = pckg3.id;
                            SP2.ARV_Pediatric_Vision_Plan__c=pckg3.ARV_Pediatric_Vision_Plan__c;
                            if(plans3.size()>0){
                                    SP2.ARV_Vision_Plan__c=plans3[0].id;
                                }
                                else{
                                    SP2.ARV_Vision_Plan__c=null;  
                                }
                            clonedPckgs7.add(SP2);
                            System.debug('**clonedPckgId**'+sp2.id);
                            System.debug('**clonedPckgs7**'+clonedPckgs7);

                           // system.debug('Sister Package 3');
                            Package__c sp3 = pckg3.clone(false,true,false,false);
                            sp3.Name = sp3.Name+'-SP';
                            sp3.Sister_Parent_ID__c = pckg3.id;
                            sp3.ARV_Pediatric_Vision_Plan__c=pckg3.ARV_Pediatric_Vision_Plan__c;
                            if(plans3.size()>0){
                                    SP3.ARV_Vision_Plan__c=plans3[0].id;
                                }
                                else{
                                    SP3.ARV_Vision_Plan__c=null;  
                                }
                            Map<String, Object> object9 = (Map<String, Object>) JSON.deserializeUntyped(pckg3.ARV_GWC_Package_Change_Attributes__c);   
                           // System.debug('object'+object9);
                            object9.put(BCNHSA,OptOut);
                            finalattr=JSON.serialize(object9);
                           // system.debug('****finalattr****'+finalattr);
                            sp3.ARV_GWC_Package_Change_Attributes__c=finalattr;
                            clonedPckgs7.add(sp3);
                          //  System.debug('**clonedPckgId**'+sp3.id);
                          //  System.debug('**clonedPckgs7**'+clonedPckgs7);
                            }
                            insert clonedPckgs7;
                            finalattr='';
                        }
                        if(clonedPckgs7.size()>0){
                            for(vlocity_ins__GroupCensusMember__c gcm:lstcmember){
                                if((gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOTAVAILABLE) && gcm.ARV_Is_Vision_Selected__c==ARV_AP41_StringLiteralUtils.TRUE_VALUE ){
                                    gcm.ARV_Package__c=clonedPckgs7[0].id;
                                }
                                if((gcm.ARV_CDH_Member__c!=ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c!=ARV_AP41_StringLiteralUtils.NOTAVAILABLE) && gcm.ARV_Is_Vision_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs7[1].id;
                                }
                                if((gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOTAVAILABLE) && gcm.ARV_Is_Vision_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs7[2].id;
                                }
                            }
                                update lstcmember;
                            }
                        }
                       
                      // system.debug('*****condition9*****');
                        if(newProductFamily==ARV_AP41_StringLiteralUtils.HSA && oldProductFamily!=ARV_AP41_StringLiteralUtils.HSA && newCDHPckgComb!=null&& oldVisionType!=ARV_AP41_StringLiteralUtils.VOLUNTARY && newVisionType==ARV_AP41_StringLiteralUtils.VOLUNTARY && oldDentalType!=ARV_AP41_StringLiteralUtils.VOLUNTARY && newDentalType==ARV_AP41_StringLiteralUtils.VOLUNTARY)
                        {
                        //system.debug('BCN HSA with CDH with with Vol Den with Vol VIsion');
                        Set<id> pckgId9= new Set<Id>();
                        List<Package__c> clonedPckgs8 = new List<Package__c>();
                        pckgId9.add(pkg.Id);
                        List<Package__c> packageslist9 = new List<Package__c>();
                        packageslist9=[SELECT Id,Sister_Parent_ID__c,ARV_Pediatric_Vision_Plan__c,ARV_Tech_GWC_Legacy_Id__c,Name,ARV_Contract_Id__c,Original_Package_Id__c,ARV_Medical_Plan__c,ARV_Dental_Plan__c,ARV_Vision_Plan__c,RecordTypeId,ARV_GWC_Package_Change_Attributes__c,ARV_GWC_Benefit_Package_Type__c FROM Package__c where id IN : pckgId9 AND (NOT( Name like '%SP%' ))];
                        for(Package__c pck8:packageslist9)
                        {
                        Map<String, Object> objc8 = (Map<String, Object>) JSON.deserializeUntyped(pck8.ARV_GWC_Package_Change_Attributes__c);  
                           // System.debug('objc8'+objc8);
                            objc8.put(HBA,null);
                            objc8.put(BCNHSA,OptIn);
                            Attr=JSON.serialize(objc8);
                           // system.debug('****Attr****'+Attr);
                            pck8.ARV_GWC_Package_Change_Attributes__c=Attr;
                        }
                        update packageslist9;
                        Attr='';
                       // system.debug('packages****'+packageslist9);
                        list<vlocity_ins__ContractLineItem__c> visPlans =[select id,name,vlocity_ins__ProductType__c,vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c=:contractId AND vlocity_ins__ProductCode__c = 'SGBCNPVSN00001'];
                        list<vlocity_ins__ContractLineItem__c> denPlans =[select id,name,vlocity_ins__ProductType__c,vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c=:contractId AND vlocity_ins__ProductCode__c = '15560MI0480002'];
                        if(packageslist9.size()>0){
                            for(Package__c pckg3:packageslist9){        
                           // System.debug('Packages-->'+pckg3.Name);
                           // system.debug('Sister Package 1');
                            Package__c sp1 = pckg3.clone(false,true,false,false);
                            sp1.Name = sp1.Name+'-SP';
                            sp1.Sister_Parent_ID__c = pckg3.id;
                            sp1.ARV_Pediatric_Vision_Plan__c=pckg3.ARV_Pediatric_Vision_Plan__c;
                            Map<String, Object> object10 = (Map<String, Object>) JSON.deserializeUntyped(pckg3.ARV_GWC_Package_Change_Attributes__c);   
                           // System.debug('object'+object10);
                            object10.put(BCNHSA,OptOut);
                            finalattr=JSON.serialize(object10);
                           // system.debug('****finalattr****'+finalattr);
                            sp1.ARV_GWC_Package_Change_Attributes__c=finalattr;
                            clonedPckgs8.add(sp1);
                         /*  System.debug('**clonedPckgId**'+sp1.id);
                            System.debug('**clonedPckgs8**'+clonedPckgs8);*/

                           // system.debug('Sister Package 2');
                            Package__c sp2 = pckg3.clone(false,true,false,false);
                            sp2.Name = sp2.Name+'-SP';
                            sp2.Sister_Parent_ID__c = pckg3.id;
                            sp2.ARV_Pediatric_Vision_Plan__c=pckg3.ARV_Pediatric_Vision_Plan__c;   
                            if(visPlans.size()>0){
                                    sp2.ARV_Vision_Plan__c=visPlans[0].id;
                                }
                                else{
                                    sp2.ARV_Vision_Plan__c=null;  
                                }
                            clonedPckgs8.add(sp2);
                            /*System.debug('**clonedPckgId**'+sp2.id);
                            System.debug('**clonedPckgs8**'+clonedPckgs8);*/

                           // system.debug('Sister Package 3');
                            Package__c sp3 = pckg3.clone(false,true,false,false);
                            sp3.Name = sp3.Name+'-SP';
                            sp3.Sister_Parent_ID__c = pckg3.id;
                            sp3.ARV_Pediatric_Vision_Plan__c=pckg3.ARV_Pediatric_Vision_Plan__c;  
                            if(visPlans.size()>0){
                                    sp3.ARV_Vision_Plan__c=visPlans[0].id;
                                }
                                else{
                                    sp3.ARV_Vision_Plan__c=null;  
                                }
                            Map<String, Object> object12 = (Map<String, Object>) JSON.deserializeUntyped(pckg3.ARV_GWC_Package_Change_Attributes__c);   
                           // System.debug('object'+object12);
                            object12.put(BCNHSA,OptOut);
                            finalattr=JSON.serialize(object12);
                           // system.debug('****finalattr****'+finalattr);
                            sp3.ARV_GWC_Package_Change_Attributes__c=finalattr;
                            clonedPckgs8.add(sp3);
                                finalattr='';
                           /* System.debug('**clonedPckgId**'+sp3.id);
                            System.debug('**clonedPckgs8**'+clonedPckgs8);*/
                            
                           // system.debug('Sister Package 4');
                            Package__c sp4 = pckg3.clone(false,true,false,false);
                            sp4.Name = sp4.Name+'-SP';
                            sp4.Sister_Parent_ID__c = pckg3.id;
                            if(denPlans.size()>0){
                                    sp4.ARV_Dental_Plan__c=denPlans[0].id;
                                }
                                else{
                                    sp4.ARV_Dental_Plan__c=null;  
                                }
                                clonedPckgs8.add(sp4);
                          /*  System.debug('**clonedPckgId**'+sp4.id);
                            System.debug('**clonedPckgs8**'+clonedPckgs8);*/
                            
                           // system.debug('Sister Package 5');
                            Package__c sp5 = pckg3.clone(false,true,false,false);
                            sp5.Name = sp5.Name+'-SP';
                            sp5.Sister_Parent_ID__c = pckg3.id;
                            if(denPlans.size()>0){
                                    sp5.ARV_Dental_Plan__c=denPlans[0].id;
                                }
                                else{
                                    sp5.ARV_Dental_Plan__c=null;  
                                }
                            Map<String, Object> object14 = (Map<String, Object>) JSON.deserializeUntyped(pckg3.ARV_GWC_Package_Change_Attributes__c);   
                           // System.debug('object'+object14);
                            object14.put(BCNHSA,OptOut);
                            finalattr=JSON.serialize(object14);
                           // system.debug('****finalattr****'+finalattr);
                            sp5.ARV_GWC_Package_Change_Attributes__c=finalattr;
                            clonedPckgs8.add(sp5);
                                finalattr='';
                           /* System.debug('**clonedPckgId**'+sp5.id);
                            System.debug('**clonedPckgs8**'+clonedPckgs8);*/
                            
                           // system.debug('Sister Package 6');
                            Package__c sp6 = pckg3.clone(false,true,false,false);
                            sp6.Name = sp6.Name+'-SP';
                            sp6.Sister_Parent_ID__c = pckg3.id;
                            if(visPlans.size()>0){
                                    sp6.ARV_Vision_Plan__c=visPlans[0].id;
                                }
                                else{
                                    sp6.ARV_Vision_Plan__c=null;  
                                }
                            if(denPlans.size()>0){
                                    sp6.ARV_Dental_Plan__c=denPlans[0].id;
                                }
                                else{
                                    sp6.ARV_Dental_Plan__c=null;  
                                }
                            clonedPckgs8.add(sp6);
                            System.debug('**clonedPckgId**'+sp6.id);
                            System.debug('**clonedPckgs8**'+clonedPckgs8);
                            
                           // system.debug('Sister Package 7');
                            Package__c sp7 = pckg3.clone(false,true,false,false);
                            sp7.Name = sp7.Name+'-SP';
                            sp7.Sister_Parent_ID__c = pckg3.id;
                            if(visPlans.size()>0){
                                    sp7.ARV_Vision_Plan__c=visPlans[0].id;
                                }
                                else{
                                    sp7.ARV_Vision_Plan__c=null;  
                                }
                            if(denPlans.size()>0){
                                    sp7.ARV_Dental_Plan__c=denPlans[0].id;
                                }
                                else{
                                    sp7.ARV_Dental_Plan__c=null;  
                                }
                            Map<String, Object> object16 = (Map<String, Object>) JSON.deserializeUntyped(pckg3.ARV_GWC_Package_Change_Attributes__c);   
                           // System.debug('object'+object16);
                            object16.put(BCNHSA,OptOut);
                            finalattr=JSON.serialize(object16);
                           // system.debug('****finalattr****'+finalattr);
                            sp7.ARV_GWC_Package_Change_Attributes__c=finalattr;
                            clonedPckgs8.add(sp7);
                           /* System.debug('**clonedPckgId**'+sp7.id);
                            System.debug('**clonedPckgs8**'+clonedPckgs8);*/
                            }
                            insert clonedPckgs8;
                            finalattr='';
                        }
                        if(clonedPckgs8.size()>0){
                            for(vlocity_ins__GroupCensusMember__c gcm:lstcmember){
                                if((gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c=='N/A') && gcm.ARV_Is_Vision_Selected__c==ARV_AP41_StringLiteralUtils.TRUE_VALUE && gcm.ARV_Is_Dental_Selected__c==ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs8[0].id;
                                }
                                if((gcm.ARV_CDH_Member__c!=ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c!='N/A') && gcm.ARV_Is_Vision_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE && gcm.ARV_Is_Dental_Selected__c==ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs8[1].id;
                                }
                                if((gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOTAVAILABLE) && gcm.ARV_Is_Vision_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE && gcm.ARV_Is_Dental_Selected__c==ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs8[2].id;
                                }
                                if((gcm.ARV_CDH_Member__c!=ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c!=ARV_AP41_StringLiteralUtils.NOTAVAILABLE) && gcm.ARV_Is_Vision_Selected__c==ARV_AP41_StringLiteralUtils.TRUE_VALUE && gcm.ARV_Is_Dental_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs8[3].id;
                                }
                                if((gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOTAVAILABLE) && gcm.ARV_Is_Vision_Selected__c==ARV_AP41_StringLiteralUtils.TRUE_VALUE && gcm.ARV_Is_Dental_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs8[4].id;
                                }
                                if((gcm.ARV_CDH_Member__c!=ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c!=ARV_AP41_StringLiteralUtils.NOTAVAILABLE) && gcm.ARV_Is_Vision_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE && gcm.ARV_Is_Dental_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs8[5].id;
                                }
                                if((gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOCDH || gcm.ARV_CDH_Member__c==ARV_AP41_StringLiteralUtils.NOTAVAILABLE) && gcm.ARV_Is_Vision_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE && gcm.ARV_Is_Dental_Selected__c!=ARV_AP41_StringLiteralUtils.TRUE_VALUE){
                                    gcm.ARV_Package__c=clonedPckgs8[6].id;
                                }
                            }
                                update lstcmember;
                            }
                        }
                  }
                        
                    }
                   
                }
            }
    
       updatePackages(contractId,gwcRatingArea,prvsContrctRatingArea,gwcReqEffDate,prvsContrctReqEffDate,physicalAddress,City,County,ZIPCode,Country,CountyCode,cityMap,state);
    //ARV_GWC_CloneGroupSegments.cloneGroupSegmentRecord(contractId);
    
        }
/*****************************************************************************************
Method Name   : updatePackages
Created By   : IDC Offshore
Description  : This is the method for Updating Packages
******************************************************************************************/
public static void updatePackages(String conId,string gwcRatingArea,string prvsContRating,string gwcReqEffDate,string prvsContReqDate,string physicalAddress,string City,string County,string ZIPCode,string Country,String CountyCode,Map<string,id> cityMap,String state){
       
        List<Package__c> updatePkgList=new List<Package__c>();
        List<Package__c> pkglist=[select id,name,ARV_GWC_Benefit_Package_Type__c from Package__c where ARV_Contract_Id__c=:conId];
        for(Package__c pkg:pkglist){
            if(pkg.name.contains('SP')){
                pkg.ARV_GWC_Benefit_Package_Type__c=ADDBENEFITPACKAGE;
            }
            if(prvsContRating!=''){
                if(gwcRatingArea!=prvsContRating && pkg.ARV_GWC_Benefit_Package_Type__c==EXISTINGBENEFITPACKAGE){
                    pkg.ARV_GWC_Benefit_Package_Type__c= RATINGAREAUPDATE;
                    
                }
                else if(gwcRatingArea!=prvsContRating && pkg.ARV_GWC_Benefit_Package_Type__c==MODIFYBENEFITCHNAGE){
                    pkg.ARV_GWC_Benefit_Package_Type__c=RATINGAREAMODIFY;
                }
            }   
            else if(gwcReqEffDate!=prvsContReqDate && pkg.ARV_GWC_Benefit_Package_Type__c==MODIFYBENEFITCHNAGE){
                pkg.ARV_Tech_ReqEffDate__c=REQEFFDATEUPD;
                
            }
            updatePkgList.add(pkg);
        }
        if(updatePkgList.size()>0){
            database.update(updatePkgList);
        }
        
        updateContract(conId,gwcRatingArea,physicalAddress,City,County,ZIPCode,Country,CountyCode,cityMap,state);
    }
/*****************************************************************************************
Method Name   : updateContract
Created By   : IDC Offshore
Description  : This is the method for Updating GWC Contract
******************************************************************************************/
    public static void updateContract(String conId,string gwcRatingArea,string physicalAddress,string City,string County,string ZIPCode,string Country,string CountyCode,Map<string,id> cityMap,string state){
        try{
        
        set<string> pkgType=new set<string>();
        List<contract> conlist=new List<contract>();
        List<Package__c> pkglist=[select id,name,ARV_GWC_Benefit_Package_Type__c from Package__c where ARV_Contract_Id__c=:conId];
     //   system.debug('packageList::'+pkglist);
        
        for(Package__c pkg:pkglist){
            if(pkg.ARV_GWC_Benefit_Package_Type__c!=null){
                pkgType.add(pkg.ARV_GWC_Benefit_Package_Type__c);
                }
             //  system.debug('Package Type::'+pkgType);
            }
            contract con=new contract(id=conId);
            //con.ARV_Date_Submitted__c=system.today();
            con.GWC_Request_Type__c=format(pkgType);
            con.ShippingState='Michigan';
            //con.ShippingCountry=Country;
            con.ShippingPostalCode=ZIPCode;
            //con.ShippingState=City;
            //system.debug('Map1:'+cityMap.containskey(City));
            /*if(cityMap.containskey(City)){
                system.debug('Map:'+cityMap.containskey(City));*/
                   con.ShippingCity=City;
           /* }
                else{
                   con.ShippingCity='Other';
                }*/
           // system.debug('Con City::'+con.ShippingState);
            con.ShippingStreet=physicalAddress;
            //con.ShippingStateCode=County;
            //con.ShippingCountryCode='US';
            conlist.add(con);
            if(conlist.size()>0){
               // system.debug('Executing:');
               database.update(conlist);
            
            }
        }
        catch(exception e){
            system.debug('Error at::'+e.getLineNumber()+' '+e.getMessage());
            throw new AuraHandledException('error' +e.getMessage()+e.getlinenumber());
            
        }
        updateGSPendingContract(conId,gwcRatingArea);
       // updateGSPendingContract(conId,gwcRatingArea,physicalAddress,City,County,ZIPCode,Country,CountyCode,cityMap,state);
    }
     
    

/*****************************************************************************************
Method Name   : format
Created By   : IDC Offshore
Description  : This is the method for formatting picklist values
******************************************************************************************/
    public static String format(Set<String> packgType) {
      //  system.debug('string set::'+packgType);
    List<String> pckgTypeLst = new List<String>(packgType);
    return String.join(pckgTypeLst, ';');
   }
/*****************************************************************************************
Method Name   : updateGSPendingContract
Created By   : IDC Offshore
Description  : This is the method for Updating Existing Group Segments
******************************************************************************************/
public static void updateGSPendingContract(String conId,string ratingArea)
//public static void updateGSPendingContract(String conId,string ratingArea,string physicalAddress,string City,string County,string ZIPCode,string Country,string CountyCode,Map<string,id> cityMap,string state)
{
     /*GA_County_Code__c physicalcounty=[select id,name from GA_County_Code__c where name=:CountyCode limit 1];
    //system.debug('physicalcounty::'+physicalcounty.id);*/
   // system.debug('calling::');
    try{
        contract cont=[select id,ARV_Sponsored_Plan_Acronym__r.ARV_Association_Cluster_Code__c from contract where id=:conId];
        String assocCluster=cont.ARV_Sponsored_Plan_Acronym__r.ARV_Association_Cluster_Code__c!=null?cont.ARV_Sponsored_Plan_Acronym__r.ARV_Association_Cluster_Code__c : BCBSMCLUSTERNULL;
       // system.debug('spons::'+assocCluster);
        Map<string,Package__c> pkgMap=new Map<string,Package__c>();
        for(Package__c pkg:[select id,name,ARV_GWC_Benefit_Package_Type__c,ARV_Tech_GWC_Legacy_Id__c,ARV_Plan_Package_Combinations__c from Package__c where ARV_Contract_Id__c=:conId and (NOT ARV_GWC_Benefit_Package_Type__c LIKE '%Add Benefit%') AND (NOT ARV_GWC_Benefit_Package_Type__c LIKE '%Terminate%') AND (NOT ARV_GWC_Benefit_Package_Type__c LIKE '%Add Location%') AND (NOT( Name like '%SP%'))]){
          // select id,name,ARV_GWC_Benefit_Package_Type__c,ARV_Tech_GWC_Legacy_Id__c,ARV_Plan_Package_Combinations__c from Package__c where ARV_Contract_Id__c=:conId and (NOT ARV_GWC_Benefit_Package_Type__c LIKE '%Add Benefit%') AND (NOT ARV_GWC_Benefit_Package_Type__c LIKE '%Terminate%') AND (NOT( Name like '%SP%'))
            pkgMap.put(pkg.ARV_Tech_GWC_Legacy_Id__c,pkg);
        } 
        //system.debug('pkgMap::'+pkgMap);
        //system.debug('pkgMap.size()'+pkgMap.size());
       
        List<GA_Group_Segment__c> gsList=new List<GA_Group_Segment__c>();
        List<GA_Group_Segment__c> pkggsList=[select id,name,ARV_Pending_ContractId__c,ARV_PlanPackage_Combinations__c,ARV_Pending_PackageId__c,GA_Carrier__c,GA_Current_Cluster_Code__c,GA_Group_Factor_Cluster_Code__c,ARV_Tech_GWC_Type__c from GA_Group_Segment__c where name IN:pkgMap.keyset()];
        //system.debug('pkggsList::'+pkggsList);
        for(GA_Group_Segment__c gs:pkggsList){
            //system.debug('GS contains:'+pkgMap.containsKey(gs.name));
            if(pkgMap.containsKey(gs.name)){
                package__c pckg=pkgMap.get(gs.name);
                gs.ARV_Pending_PackageId__c=pckg.id;
                gs.ARV_Pending_ContractId__c= conId;
                gs.ARV_Tech_GWC_Type__c=pckg.ARV_GWC_Benefit_Package_Type__c;
                gs.ARV_PlanPackage_Combinations__c= pckg.ARV_Plan_Package_Combinations__c;
               /* gs.GA_Physical_Address_1__c=physicalAddress;
                gs.GA_Physical_State__c=state;
                gs.GA_Physical_County_Id__c=physicalcounty.id;
                if(cityMap.containskey(City)){
                   gs.GA_Physical_City__c=cityMap.get(City);
                }
                else{
                   gs.GA_Physical_City__c=cityMap.get('OTHER');
                   gs.GA_Physical_City_Other__c=City;
                }
			 	
                gs.GA_Physical_Zip__c=ZIPCode;
                gs.GA_Mailing_Address_1__c=physicalAddress;
                gs.GA_Mailing_State__c=state;
                gs.GA_Mailing_County_Id__c=physicalcounty.id;
                gs.GA_Mailing_Zip__c=ZIPCode;
                if(cityMap.containskey(City)){
                   gs.GA_Mailing_City__c=cityMap.get(City);
                }
                else{
                   gs.GA_Mailing_City__c=cityMap.get('OTHER');
                    gs.GA_Mailing_City_Other__c=City;
                }
                if(gs.Network__c=='Medicare Advantage'){
                    //gs.GA_Mailing_City__c=gs.GA_Physical_City__c;
                    gs.GA_Billing_Address_1__c=physicalAddress;
                    gs.GA_Billing_State__c=state;
                    gs.GA_Billing_County_Id__c=physicalcounty.id;
                    gs.GA_Billing_Zip__c=ZIPCode;
                    if(cityMap.containskey(City)){
                       gs.GA_Billing_City__c=cityMap.get(City);
                    }
                    else{
                       gs.GA_Billing_City__c=cityMap.get('OTHER');
                       gs.GA_Billing_City_Other__c=City;
                    }
               }*/
                //gs.GA_Billing_City__c=gs.GA_Physical_City__c;
                if(pckg.ARV_GWC_Benefit_Package_Type__c.contains(RATINGAREA) && gs.GA_Carrier__c==ARV_AP41_StringLiteralUtils.BCBSMVAL && gs.GA_Current_Cluster_Code__c!=ARV_AP41_StringLiteralUtils.NULLSTRING){
                String clustercode = gs.GA_Current_Cluster_Code__c;
                  //  system.debug('clustercode::'+clustercode);
                Integer [] nameArray =clustercode.getChars();
				nameArray.remove(1);
				String newclustercode= String.fromCharArray(nameArray);
				//gs.GA_Current_Cluster_Code__c = 'F'+ratingArea+newclustercode.right(2);
                gs.GA_Group_Factor_Cluster_Code__c ='F'+ratingArea+assocCluster;
              //  system.debug('newclustercode.right(2)::'+newclustercode.right(2));
               // system.debug('NewClusterCode***'+gs.GA_Current_Cluster_Code__c );
               	}
                else{
                    gs.GA_Group_Factor_Cluster_Code__c=gs.GA_Current_Cluster_Code__c;
                }
                gsList.add(gs);
                 
                }
        }
        
        if(gsList.size()>0){
            database.update(gsList);
        }
        }
        catch(Exception e){
        system.debug('Error att::'+e.getLineNumber()+' '+e.getMessage());
            throw new AuraHandledException('error:' +e.getMessage()+e.getlinenumber());
    }
    
    }
   
}