@isTest(seealldata=false)
/**
*Class Name   : ARV_AP_GWCCOEXISTANCERules_Test
*Date Created : 14-Sep-2020
*Created By   : IDC Offshore
*Description  : This class is used for testing ARV_AP_GWCCOEXISTANCERules.
**/
public without sharing class ARV_AP_GWCCOEXISTANCERules_Test {
   // Initializing variables and constants.
     private static final string PROFILENAME='BCBSM Agent';
     private static final string PROFILENAME1='Retention Sales';
     private static final string NAME='AP33LastName';
     private static final string NAME1='AP33RateGrid';
     private static final string USERNAME='bcbsm1@bcbsm.com';
     private static final String HEALTHYACHIEVE  = 'Healthy Blue Achieve';
     private static final string PHYSCHOICE='Physician Choice Plan';
     private static final string COMMUNITYBLUE='Community Blue';
     private static final string MULTIEMPLOYEE='MultiEmployee';
     private static final string MULTILOCATION='MultiLocation';
     private static final string COMMONCONTROL='CommonControl';
     private static final string YES='Yes';  
     private static final string STRINGNO='No';
     private static final string GROUPINFORMATION='GroupInformation';
     private static final string TYPE='Dental';
     private static final string TYPE1='Vision';
     private static final string BLANK='';
     private static final string CHECK='Yes';
     private static final string VOLUNTARY  = 'Voluntary';
     private static final string PEDIATRICPLAN  = 'Pediatric Plan';
     private static final string BCNHMO='BCN HMO';
     private static final string HEALTHYLIVING='Healthy Blue Living';
     private static final string SIMPLYBLUE='Simply Blue';
     private static final string SIMPLYBLUEHSA='Simply Blue HSA';
     private static final string SIMPLYBLUEPPO='Simply Blue PPO';
     private static final string SIMPLYBLUEHRA='Simply Blue HRA';
     private static final string PACKAGE1='package';
     private static final string ERRORMSG='Coexistence rules have been violated within  ';
    
     private String medPrdId;
     private String denPrdId;
     private String visPrdId;
     
    
    /**************  
    Method name : testDataSetup
    Params     : NA
    Return Type : testmethod
    Description :  testDataSetup() method 
    *************/   
     @testSetup static void testDataSetup() {  
    
     List<GA_County_Code__c> countyLst = ARV_AP05_TestDataCreation.createCounties(1);
     database.insert(countyLst);     
     Account acnt= ARV_AP05_TestDataCreation.accRec();
     acnt.GA_Mailing_County_id__c = countyLst[0].id;     
     database.insert(acnt);     
     Contract cntrct = ARV_AP05_TestDataCreation.createContractRec(acnt.id);               
     database.insert(cntrct);   
     GA_Common_Control__c cmnc = ARV_AP05_TestDataCreation.commonControlRec(acnt.id);
     database.insert(cmnc); 
     Contact cntc=GA_OBJ_TD01_TestDataCreation.cntactRec(acnt.Id);
     database.insert(cntc); 
     contract cont= ARV_AP05_TestDataCreation.createContractRec(acnt.Id);        
     database.insert(cont);   
     Product2 sisProd= ARV_AP05_TestDataCreation.productRec();
     sisProd.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCBSTYPE;
     sisProd.Family=SIMPLYBLUE;     
     database.insert(sisProd,true);
     Product2 prod= ARV_AP05_TestDataCreation.productRec();
     prod.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCBSTYPE;
     prod.Family=SIMPLYBLUE;
     prod.ARV_PCPFocus_SisterPlan__c = sisProd.id; 
     database.insert(prod,true);                
     Product2 prod1= ARV_AP05_TestDataCreation.productRec();
     prod1.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCNTYPE; 
     prod1.Family=BCNHMO;
     prod1.PCP_Focus__c = true;
     database.insert(prod1,true);          
     Product2 prod2= ARV_AP05_TestDataCreation.productRec();
     prod2.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCNTYPE; 
     prod2.Family=HEALTHYLIVING;     
     database.insert(prod2,true);         
     Product2 prod3= ARV_AP05_TestDataCreation.productRec();
     prod3.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCBSTYPE; 
     prod3.Family=HEALTHYACHIEVE;
     prod3.PCP_Focus__c = true;
     prod3.ARV_PCPFocus_SisterPlan__c = sisProd.id;
     database.insert(prod3,true);         
     Product2 prod4= ARV_AP05_TestDataCreation.productRec();
     prod4.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCBSTYPE;
     prod4.Family=SIMPLYBLUEHSA;
     prod4.PCP_Focus__c = true;
     prod4.ARV_PCPFocus_SisterPlan__c = sisProd.id;
     database.insert(prod4,true);  
     Product2 prod5= ARV_AP05_TestDataCreation.productRec();
     prod5.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCBSTYPE; 
     prod5.Family=COMMUNITYBLUE;
     database.insert(prod5,true);
     Package__c pck1=ARV_AP05_TestDataCreation.packageRec(cont.Id);
     pck1.name = PACKAGE1;
     pck1.Medical_Product_Id__c=prod.id;
     pck1.Dental_Product_Id__c=prod1.id;
     pck1.Vision_Product_Id__c=prod2.id;
     insert pck1;
         
     GA_Group_Segment__c gs= ARV_AP05_TestDataCreation.groupSegmentRec(acnt.id,cntrct.id);   
     //GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acnt);
     gs.GA_Administrative_Contact_Id__c=cntc.Id;
     gs.GA_Billing_Contact_Id__c=cntc.Id;
     gs.ARV_Package__c=pck1.Id;
     insert(gs);
     system.debug('************gs'+gs);     
     List<GA_Group_Segment__c> gslst= new List<GA_Group_Segment__c>();
     gsLst.add(gs); 
         
     vlocity_ins__ContractLineItem__c  plan= ARV_AP05_TestDataCreation.planRec(prod.id,cntrct.id);
     database.insert(plan); 
     user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
     usr.LastName = NAME1;
     usr.Username=USERNAME;
     database.insert(usr,true);     
 }
    
    /**************  
    Method name : testProductPackage
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/     
    @isTest    
    static void testProductPackage() {        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> packageProd1 = new Map<String,Object>();
        Map<String,Object> packageProduct2 = new Map<String,Object>();
        //Map<String,Object> packageProduct3 = new Map<String,Object>();
        Map<String,Object> packageLctnStep = new Map<String,Object>(); 
        Map<String,Object> groupInfo = new Map<String,Object>();
        //Map<String,Object> packageSelection = new Map<String,Object>();
        Set<id> PrdSet= new Set<Id>();
        Map<Id,String> lobsLst = new Map<Id,String>();                        
        Account acc=[select id, name, MailingCountyFormula__c, BillingPostalCode from Account limit 1];
        Map<Id,String> prodMap1 = new Map<Id,String>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c,Family from product2 limit 10]){
                prodMap1.put(prod.Id,prod.carrier_type__c);
                prdSet.add(prod.Id);
                lobsLst.put(prod.Id,prod.carrier_type__c);  
        }

        Map<Id,String> prodMap = new Map<Id,String>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c,Family from product2 limit 10]){
                prodMap.put(prod.Id,prod.carrier_type__c);
                prdSet.add(prod.Id);
                lobsLst.put(prod.Id,prod.carrier_type__c);
            System.assertNotEquals(null,Prod.Id);
                
        }
        Map<String,Product2> prodMap2 = new Map<String,Product2>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c,Family from product2 limit 10]){
                prodMap2.put(prod.Family,prod);
        }
 
        Account acc1=GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        
        List<Object> countyLst = new List<Object>();
        countyLst.add('MACOMB'); 
        countyLst.add('ST. CLAIR');
        groupInfo.put('MultiEmployee','Yes'); 
        groupInfo.put('MultiLocation','Yes');
        groupInfo.put('CommonControl','No'); 
        groupInfo.put('SelectEmployeeSegments','Hourly/Salary');
        Map<String,Object> headquarters = new Map<String,Object>();
        headquarters.put('ALCounty','HQ: MACOMB');
        headquarters.put('ALZipCode',48005);
        headquarters.put('LocationName','HQ');
        headquarters.put('lKey','HQ-HQ: MACOMB-48005');        
        Map<String,Object> additionalLocs = new Map<String,Object>();
        additionalLocs.put('ALCounty','LAPEER');
        additionalLocs.put('ALZipCode',48003);
        additionalLocs.put('LocationName','test');
        additionalLocs.put('aLOutsideCounty',null);                 
        groupInfo.put('Headquarters',headquarters);
        groupInfo.put('AdditionalLocations',additionalLocs); 
        Map<String,Object> additionalLocs1 = new Map<String,Object>();
        additionalLocs1.put('ALCounty','LAPEER1');
        additionalLocs1.put('ALZipCode',480031);
        additionalLocs1.put('LocationName','test1');
        additionalLocs1.put('aLOutsideCounty',null);                 
        //additionalLocs1.put('Headquarters',headquarter1);
        Map<String,Object> finalgroupseg = new Map<String,Object>();
        finalgroupseg.put('pcpFocus',false);
        finalgroupseg.put('physicalCounty','Macomb');
        finalgroupseg.put('RenewalEffectiveDate',system.today()+1);
        finalgroupseg.put('ProductFamily',HEALTHYLIVING);
        finalgroupseg.put('groupSegmentId','a1Wc00000033ZDyEAM');
        finalgroupseg.put('visVolContains',false);
        finalgroupseg.put('medicalType','BCN');
        finalgroupseg.put('medPrdId','01tc0000007iz3MAAQ');
        finalgroupseg.put('denVolContains',false);
        
                               
        packageProd1.put('MedicalProductidFormula1',prodMap2.get(SIMPLYBLUE).id );
        packageProd1.put('MedicalPackLookup1',prodMap2.get(SIMPLYBLUE).id+'-'+prodMap2.get(SIMPLYBLUE).carrier_type__c);                        
        packageProduct2.put('MedicalProductidFormula2',prodMap2.get(HEALTHYACHIEVE).id);
        packageProduct2.put('MedicalPackLookup2',prodMap2.get(HEALTHYACHIEVE).id+'-'+
                            prodMap2.get(HEALTHYACHIEVE).Carrier_Type__c+'-'+'PCP');        
        packageLctnStep.put('PackageProduct1',packageProd1); 
        packageLctnStep.put('PackageProduct2',packageProduct2);        
        packageLctnStep.put('NoOfPackages',2);                        
        Map<String,Object> pckgSlctnStep = new Map<String,Object>();
        pckgSlctnStep.put('Hourly-HQ-48005-HQ: MACOMB','Package1');
        pckgSlctnStep.put('Hourly-test-48003-LAPEER','Package1;Package2'); 
        inputMap.put('PackageLocation',packageLctnStep);
        inputMap.put('GroupInformation',groupInfo);
        inputMap.put('PackageSelection',pckgSlctnStep);
        inputMap.put('countyList',countyLst);
        inputMap.put('finalGroupSegmentsPlans',finalgroupseg);
            Set<String> dntlOrthoSet= new Set<String>();
            Set<String> dntlVlntrySet= new Set<String>();
            Set<String> vsnVlntrySet= new Set<String>();
            
            dntlOrthoSet.add('No');
            
            dntlVlntrySet.add('False');
            
            vsnVlntrySet.add('False');
            
        List<String> bcnMap=new List<String>();
        bcnMap.add('BCN');
        bcnMap.add('BCNHMO');
        bcnMap.add('HEALTHYLIVING');
        
        List<String> pcpList = new List<String>();
        pcpList.add('HEALTHYLIVING');
        
        Account acnt1= ARV_AP05_TestDataCreation.accRec();   
        database.insert(acnt1);   
         
        Contract cntrct1 = ARV_AP05_TestDataCreation.createContractRec(acnt1.id);               
        database.insert(cntrct1);  
        
         GA_Group_Segment__c gs= ARV_AP05_TestDataCreation.groupSegmentRec(acnt1.id,cntrct1.id);   
         insert gs;
         List<String> bcbsmMap = new List<String>();
                        bcbsmMap.add('SIMPLYBLUE');
                        bcbsmMap.add('SIMPLYBLUEHSA');
                        bcbsmMap.add(PHYSCHOICE);
                        bcbsmMap.add(HEALTHYACHIEVE);
        
               
        user usr1  = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){                                 
        ARV_AP_GWCCOEXISTANCERules arvProd = new ARV_AP_GWCCOEXISTANCERules();      
        ARV_AP_GWCCOEXISTANCERules.GroupSgmntsDtails gsdetails1= new ARV_AP_GWCCOEXISTANCERules.GroupSgmntsDtails();
            try{            
                        system.test.startTest();
                        String lobMsg=null; 
                       // gsdetails1.medPrdId = 'Test1';
                       // system.debug('++++++++medPrdId'+gsdetails1.medPrdId);
                        //gsdetails1.ProductFamily='Healthy Blue Living';
                        arvProd.invokemethod('enrollMedicalValidation',inputMap,outMap,options); 
                        arvProd.gwcCoExistanceRules(inputMap,outMap,options);
                        arvProd.validatePackage(prdSet,prodMap1);
                        arvProd.bcBsmPrdValidation(bcbsmMap);
                        arvProd.bcnPrdValidation(bcnMap, pcpList, 1);
                        //arvProd.lobCoExistanceCheck(dntlOrthoSet, dntlVlntrySet, vsnVlntrySet); 
                        
                        system.test.stoptest();
                        //System.assertNotEquals(null,acc.id);
                        //System.assertEquals(null, gsdetails.medPrdId);

                 }Catch(Exception e){return ;}
        }
    }
    /**************  
    Method name : testProductPackage1
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/     
    @isTest    
    static void testProductPackage1() {        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> packageProd1 = new Map<String,Object>();
        Map<String,Object> packageProduct2 = new Map<String,Object>();
        Map<String,Object> packageProduct3 = new Map<String,Object>();
        Map<String,Object> packageLctnStep = new Map<String,Object>(); 
        Map<String,Object> groupInfo = new Map<String,Object>();
        Map<String,Object> packageSelection = new Map<String,Object>();
        List<Object> countyLst = new List<Object>();
        countyLst.add('MACOMB'); 
        countyLst.add('ST. CLAIR');
        Set<id> PrdSet= new Set<Id>();
        Map<Id,String> lobsLst = new Map<Id,String>();                       
        Account acc=[select id, name, MailingCountyFormula__c, BillingPostalCode from Account limit 1];
        Map<Id,String> prodMap1 = new Map<Id,String>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c,Family from product2 limit 10]){
                prodMap1.put(prod.Id,prod.carrier_type__c);
                prdSet.add(prod.Id);
                lobsLst.put(prod.Id,prod.carrier_type__c);  
        }
        Map<String,Product2> prodMap = new Map<String,Product2>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c,Family from product2 limit 10]){
                prodMap.put(prod.Family,prod);
        }
 
        Account acc1=GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        Map<String,Object> headquarters = new Map<String,Object>();
        headquarters.put('ALCounty','HQ: MACOMB');
        headquarters.put('ALZipCode',48005);
        headquarters.put('LocationName','HQ');
        headquarters.put('lKey','HQ-HQ: MACOMB-48005');  
        Map<String,Object> additionalLocs = new Map<String,Object>();
        additionalLocs.put('ALCounty','LAPEER');
        additionalLocs.put('ALZipCode',48003);
        additionalLocs.put('LocationName','test');
        additionalLocs.put('aLOutsideCounty',null);
        additionalLocs.put('CompanyNameLOC','');
        additionalLocs.put('CommonControlTaxID','');
        groupInfo.put('MultiEmployee','Yes'); 
        groupInfo.put('MultiLocation','Yes');
        groupInfo.put('CommonControl','No'); 
        groupInfo.put('SelectEmployeeSegments','Hourly/Salary');            
        groupInfo.put('Headquarters',headquarters);
        groupInfo.put('AdditionalLocations',additionalLocs); 
        Map<String,Object> additionalLocs1 = new Map<String,Object>();
        additionalLocs1.put('ALCounty','LAPEER1');
        additionalLocs1.put('ALZipCode',480031);
        additionalLocs1.put('LocationName','test1');
        additionalLocs1.put('aLOutsideCounty',null);                 
        //additionalLocs1.put('Headquarters',headquarter1);
        Map<String,Object> finalgroupseg = new Map<String,Object>();
        finalgroupseg.put('pcpFocus',false);
        finalgroupseg.put('physicalCounty','Macomb');
        finalgroupseg.put('RenewalEffectiveDate',system.today()+1);
        finalgroupseg.put('ProductFamily',HEALTHYLIVING);
        finalgroupseg.put('groupSegmentId','a1Wc00000033ZDyEAM');
        finalgroupseg.put('visVolContains',false);
        finalgroupseg.put('medicalType','BCN');
        finalgroupseg.put('medPrdId',null);
        finalgroupseg.put('denPrdId','01tc0000007iz3MAAQ');
        finalgroupseg.put('vinPrdId', 'test2');
        finalgroupseg.put('denVolContains',true);
        
                              
       //packageProd1.put('MedicalProductidFormula1',prodMap.get(BCNHMO).id );
       //packageProd1.put('MedicalPackLookup1',prodMap.get(BCNHMO).id+'-'+prodMap.get(BCNHMO).carrier_type__c);                        
       // packageProduct2.put('MedicalProductidFormula2',prodMap.get(HEALTHYACHIEVE).id);
        //packageProduct2.put('MedicalPackLookup2',prodMap.get(HEALTHYACHIEVE).id+'-'+
                           // prodMap.get(HEALTHYACHIEVE).Carrier_Type__c+'-'+'PCP');        
        packageLctnStep.put('PackageProduct1',packageProd1); 
        packageLctnStep.put('PackageProduct2',packageProduct2);        
        packageLctnStep.put('NoOfPackages',2);                        
        Map<String,Object> pckgSlctnStep = new Map<String,Object>();
        pckgSlctnStep.put('Hourly-HQ-48005-HQ: MACOMB','Package1');
        pckgSlctnStep.put('Hourly-test-48003-LAPEER','Package1;Package2'); 
        inputMap.put('PackageLocation',packageLctnStep);
        inputMap.put('GroupInformation',groupInfo);
        inputMap.put('PackageSelection',pckgSlctnStep);
        inputMap.put('countyList',countyLst);
        inputMap.put('finalGroupSegmentsPlans',finalgroupseg);
            Set<String> dntlOrthoSet= new Set<String>();
            Set<String> dntlVlntrySet= new Set<String>();
            Set<String> vsnVlntrySet= new Set<String>();
            dntlOrthoSet.add('Yes');
            dntlVlntrySet.add('True');       
            vsnVlntrySet.add('True');
            List<String> bcnMap=new List<String>();
            bcnMap.add('BCN');
            bcnMap.add('BCNHMO');
            bcnMap.add('HEALTHYLIVING');
            List<String> pcpList = new List<String>();
            pcpList.add('HEALTHYLIVING');
        
            Account acnt1= ARV_AP05_TestDataCreation.accRec();   
            database.insert(acnt1);   
         
            Contract cntrct1 = ARV_AP05_TestDataCreation.createContractRec(acnt1.id);               
            database.insert(cntrct1);  
        
            GA_Group_Segment__c gs= ARV_AP05_TestDataCreation.groupSegmentRec(acnt1.id,cntrct1.id);   
            insert gs;
            List<String> bcbsmMap = new List<String>();
                        bcbsmMap.add('SIMPLYBLUE');
                        bcbsmMap.add('SIMPLYBLUEHSA');
                        bcbsmMap.add(PHYSCHOICE);
                        bcbsmMap.add(COMMUNITYBLUE);
        
        user usr1  = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){                                 
        ARV_AP_GWCCOEXISTANCERules arvProd = new ARV_AP_GWCCOEXISTANCERules();      
        ARV_AP_GWCCOEXISTANCERules.GroupSgmntsDtails gsdetails1= new ARV_AP_GWCCOEXISTANCERules.GroupSgmntsDtails();
            try{            
                        system.test.startTest();
                                                //gsdetails1.medPrdId = 'Test1';
                        //system.debug('++++++++medPrdId'+gsdetails1.medPrdId);
                       // gsdetails1.ProductFamily='Healthy Blue Living';
                        arvProd.invokemethod('enrollMedicalValidation',inputMap,outMap,options); 
                        arvProd.gwcCoExistanceRules(inputMap,outMap,options);
                        arvProd.validatePackage(prdSet,prodMap1);
                        arvProd.bcBsmPrdValidation(bcbsmMap);
                        arvProd.bcnPrdValidation(bcnMap, pcpList, 1);
                        //arvProd.lobCoExistanceCheck(dntlOrthoSet, dntlVlntrySet, vsnVlntrySet);        
                        system.test.stoptest();
                        //System.assertNotEquals(null,acc.id);
                        //System.assertEquals(null, gsdetails.medPrdId);

                 }Catch(Exception e){return ;}
        }
    }

}