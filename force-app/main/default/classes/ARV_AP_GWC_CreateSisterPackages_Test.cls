@isTest(seealldata=false)
public class ARV_AP_GWC_CreateSisterPackages_Test {
    private static final string PROFILENAME1='Retention Sales';
    private static final string NAME2='AP33RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string CntrctName='testcntrct';
    private static final string PACKAGE1='Package';
    private static final string Medical='med';
    private static final string Medical1='med1';
    private static final string DENTPROD='DENTPROD';
    private static final string DENTPROD1='DENTPROD1';
    private static final string VISIONPROD='VISIONPROD';
    private static final string VISIONPROD1='VISIONPROD1';
    private static final string PEDIATRICVISIONPROD='Pediatric VISION';
    private static final string BCBSCARRIER='BCBS';
    private static final string BCNCARRIER='BCN';
    private static final string CH='Update';
    private static final string noCH='No Change';
    private static final string CDH='HSA';
    private static final string VOL='Voluntary';
    private static final string NonVOL='Non-Voluntary';
    private static final string PRODFAMILY1='Healthy Blue Achieve';
    private static final string PRODFAMILY2='BCN HSA';
    private static final string MODIFY='Modify Benefit Package';
    private static final string RatingArea='B';
    private static final string county='MACOMB';
    /*private static string id_cntrct(map<String,Object> dd) 
    {
        Package__C pack=[SELECT Id,ARV_GWC_Package_Change_Attributes__c,ARV_Contract_Id__c FROM Package__C WHERE Name=:PACKAGE1 LIMIT 1];
        String blobdata=JSON.serialize(dd);
        pack.ARV_GWC_Package_Change_Attributes__c=blobdata;
        pack.ARV_GWC_Benefit_Package_Type__c=MODIFY;
        update pack;
        return String.valueOf(pack.ARV_Contract_Id__c);
    }*/
    
    @testSetup static void testDataSetup()
    {
        Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);
        vlocity_ins__GroupCensus__c Census=ARV_AP05_TestDataCreation.groupCensus(acc.id);
        database.insert(Census);
        pricebook2 pb=ARV_AP05_TestDataCreation.priceBookRec();
        database.insert(pb);
        opportunity opp=ARV_AP05_TestDataCreation.opportunityRec(acc.id,pb.id);
        database.insert(opp);
        Quote quoteRec=ARV_AP05_TestDataCreation.quoteRec(Opp.Id,pb.Id);
        database.insert(quoteRec);
        quoteRec.ARV_CF_Tech_RatingArea__C=RatingArea;
        database.update(quoteRec);
        vlocity_ins__GroupCensusMember__c groupCensusMember=ARV_AP05_TestDataCreation.groupCensusMember(Census.Id);
        database.insert(groupCensusMember);
        Contract cntrct=new Contract(AccountId=acc.id,name=CntrctName,vlocity_ins__EnrollmentCensusId__c=Census.Id);
        database.insert(cntrct);
        Package__C pack=new Package__C(Name =PACKAGE1,ARV_Contract_Id__c=cntrct.id);
        database.insert(pack);
        GA_County_Code__c ccode=new GA_County_Code__c(Name=county);
        database.insert(ccode);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME2;
        usr.Username=USERNAME;
        database.insert(usr,true); 
    }
    private static string id_cntrct(map<String,Object> dd, String medTransac,String denTransac,String visTransac) 
    {
        String blobdata=JSON.serialize(dd);
        Package__C pack=new Package__C();
            pack=[SELECT Id, ARV_Contract_Id__c FROM Package__C WHERE Name=:PACKAGE1 LIMIT 1];
        pack.ARV_GWC_Package_Change_Attributes__c=blobdata;
        pack.ARV_GWC_Medical_Transaction__c=medTransac;
        pack.ARV_GWC_Dental_Transaction__c=denTransac;
        pack.ARV_GWC_Vision_Transaction__c=visTransac;
        pack.ARV_GWC_Benefit_Package_Type__c=MODIFY;
        update pack;
        return String.valueOf( [SELECT Id, ARV_Contract_Id__c FROM Package__C WHERE Name=:PACKAGE1 LIMIT 1].ARV_Contract_Id__c);
    }
    private static String StrRatingArea(){
        String StrRatingArea=String.valueOf( [select id,ARV_CF_Tech_RatingArea__c from quote
                              where ARV_CF_Tech_RatingArea__c=:RatingArea].ARV_CF_Tech_RatingArea__c);
        return StrRatingArea;
    }
    private static Map<String,object> quoteDetails(){
        Map<String,object> quoteDetails=new Map<String,object>();
        quoteDetails.put('ARV_CF_Tech_RatingArea__c',StrRatingArea());
        return quoteDetails;
    }
    private static Map<String,object> groupInfoMapFinal()
    {
        String physicalcounty=String.valueOf([select id,name from GA_County_Code__c where name=:county limit 1].name);
        Map<String,object> groupInfoMapFinal =new Map<String,object>();
        Map<String,object> groupInfoMap =new Map<String,object>();
        groupInfoMap.put('GWCReqEffDateFormula',system.today());
  		groupInfoMap.put('CountyCode',physicalcounty);
        groupInfoMap.put('PhyAdd','h');
        groupInfoMap.put('City','New York');
        groupInfoMap.put('County',county);
        groupInfoMap.put('ZIPCode','48005');
		groupInfoMap.put('Country','United States');
        groupInfoMapFinal.put(null,groupInfoMap);
        return groupInfoMapFinal;
    }
  
    @isTest    
    static void testGWCSP1() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCBSCARRIER,
            'Old Dental Plan:'=>DENTPROD1,
            'New Dental Plan:'=>DENTPROD,
            'New Dental Type:'=>VOL,
            'Old Dental Type:'=>NonVOL};
        inputMap.put('GroupInformation',groupInfoMapFinal());
        inputMap.put('finalContReqEffDate',system.today());
        inputMap.put('finalContRA',StrRatingArea());
        inputMap.put('quoteDetail',quoteDetails());
        inputMap.put('contractId',id_cntrct(blobmap,noCH,CH,noCH));
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP_GWC_CreateSisterPackages arvGwcSP = new ARV_AP_GWC_CreateSisterPackages();               
            try{       
                system.test.startTest();
                System.debug('inputMap '+inputMap);
                arvGwcSP.invokeMethod('gwcPackageClone',inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
    @isTest  
    static void testGWCSP2() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCBSCARRIER,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>Medical1,
            'Old Product Family:'=>PRODFAMILY2,
            'New Product Family:'=>PRODFAMILY1};
                inputMap.put('contractId',id_cntrct(blobmap,CH,noCH,noCH));
        inputMap.put('GroupInformation',groupInfoMapFinal());
        inputMap.put('finalContReqEffDate',system.today());
        inputMap.put('finalContRA',StrRatingArea());
        inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP_GWC_CreateSisterPackages arvGwcSP = new ARV_AP_GWC_CreateSisterPackages();      
            
            try{       
                system.test.startTest(); 
                arvGwcSP.invokeMethod('gwcPackageClone',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
    @isTest  
    static void testGWCSP3() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCBSCARRIER,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>Medical1,
            'Old Product Family:'=>PRODFAMILY2,
            'New Product Family:'=>PRODFAMILY1,
            'Old Dental Plan:'=>VISIONPROD,
            'New Dental Plan:'=>VISIONPROD1,
            'Old Dental Type:'=>NonVOL,
            'New Dental Type:'=>VOL};
                inputMap.put('contractId',id_cntrct(blobmap,CH,CH,noCH));
                inputMap.put('GroupInformation',groupInfoMapFinal());
        inputMap.put('finalContReqEffDate',system.today());
        inputMap.put('finalContRA',StrRatingArea());
        inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP_GWC_CreateSisterPackages arvGwcSP = new ARV_AP_GWC_CreateSisterPackages();      
            
            try{       
                system.test.startTest(); 
                arvGwcSP.invokeMethod('gwcPackageClone',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
    @isTest  
    static void testGWCSP4() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Vision Plan:'=>VISIONPROD,
            'New Vision Plan:'=>VISIONPROD1,
            'Old Vision Type:'=>NonVOL,
            'New Vision Type:'=>VOL};
                inputMap.put('contractId',id_cntrct(blobmap,noCH,noCH,CH));
                inputMap.put('GroupInformation',groupInfoMapFinal());
        inputMap.put('finalContReqEffDate',system.today());
        inputMap.put('finalContRA',StrRatingArea());
        inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP_GWC_CreateSisterPackages arvGwcSP = new ARV_AP_GWC_CreateSisterPackages();      
            
            try{       
                system.test.startTest(); 
                arvGwcSP.invokeMethod('gwcPackageClone',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
    @isTest  
    static void testGWCSP5() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Dental Plan:'=>VISIONPROD,
            'New Dental Plan:'=>VISIONPROD1,
            'Old Dental Type:'=>NonVOL,
            'New Dental Type:'=>VOL,
            'Old Vision Plan:'=>VISIONPROD,
            'New Vision Plan:'=>VISIONPROD1,
            'Old Vision Type:'=>NonVOL,
            'New Vision Type:'=>VOL};
               inputMap.put('contractId',id_cntrct(blobmap,noCH,CH,CH));
                inputMap.put('GroupInformation',groupInfoMapFinal());
        inputMap.put('finalContReqEffDate',system.today());
        inputMap.put('finalContRA',StrRatingArea());
        inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP_GWC_CreateSisterPackages arvGwcSP = new ARV_AP_GWC_CreateSisterPackages();      
            
            try{       
                system.test.startTest(); 
                arvGwcSP.invokeMethod('gwcPackageClone',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
    @isTest  
    static void testGWCSP6() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>Medical1,
            'Old Product Family:'=>PRODFAMILY1,
            'New Product Family:'=>PRODFAMILY2,
            'New CDH Package Combination:'=>CDH};
                inputMap.put('contractId',id_cntrct(blobmap,CH,noCH,noCH));
        inputMap.put('GroupInformation',groupInfoMapFinal());
        inputMap.put('finalContReqEffDate',system.today());
        inputMap.put('finalContRA',StrRatingArea());
        inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP_GWC_CreateSisterPackages arvGwcSP = new ARV_AP_GWC_CreateSisterPackages();      
            
            try{       
                system.test.startTest(); 
                arvGwcSP.invokeMethod('gwcPackageClone',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
    @isTest  
    static void testGWCSP7() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>Medical1,
            'Old Product Family:'=>PRODFAMILY1,
            'New Product Family:'=>PRODFAMILY2,
            'New CDH Package Combination:'=>CDH,
            'Old Dental Plan:'=>VISIONPROD,
            'New Dental Plan:'=>VISIONPROD1,
            'Old Dental Type:'=>NonVOL,
            'New Dental Type:'=>VOL};
               inputMap.put('contractId',id_cntrct(blobmap,CH,CH,noCH));
         inputMap.put('GroupInformation',groupInfoMapFinal());
        inputMap.put('finalContReqEffDate',system.today());
        inputMap.put('finalContRA',StrRatingArea());
        inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP_GWC_CreateSisterPackages arvGwcSP = new ARV_AP_GWC_CreateSisterPackages();      
            
            try{       
                system.test.startTest(); 
                arvGwcSP.invokeMethod('gwcPackageClone',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
    @isTest  
    static void testGWCSP8() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>Medical1,
            'Old Product Family:'=>PRODFAMILY1,
            'New Product Family:'=>PRODFAMILY2,
            'New CDH Package Combination:'=>CDH,
            'Old Vision Plan:'=>VISIONPROD,
            'New Vision Plan:'=>VISIONPROD1,
            'Old Vision Type:'=>NonVOL,
            'New Vision Type:'=>VOL};
              inputMap.put('contractId',id_cntrct(blobmap,CH,noCH,CH));
         inputMap.put('GroupInformation',groupInfoMapFinal());
        inputMap.put('finalContReqEffDate',system.today());
        inputMap.put('finalContRA',StrRatingArea());
        inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP_GWC_CreateSisterPackages arvGwcSP = new ARV_AP_GWC_CreateSisterPackages();      
            
            try{       
                system.test.startTest(); 
                arvGwcSP.invokeMethod('gwcPackageClone',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
    @isTest  
    static void testGWCSP9() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>Medical1,
            'Old Product Family:'=>PRODFAMILY1,
            'New Product Family:'=>PRODFAMILY2,
            'New CDH Package Combination:'=>CDH,
            'Old Dental Plan:'=>VISIONPROD,
            'New Dental Plan:'=>VISIONPROD1,
            'Old Dental Type:'=>NonVOL,
            'New Dental Type:'=>VOL,
            'Old Vision Plan:'=>VISIONPROD,
            'New Vision Plan:'=>VISIONPROD1,
            'Old Vision Type:'=>NonVOL,
            'New Vision Type:'=>VOL};
               inputMap.put('contractId',id_cntrct(blobmap,CH,CH,CH));
        inputMap.put('GroupInformation',groupInfoMapFinal());
        inputMap.put('finalContReqEffDate',system.today());
        inputMap.put('finalContRA',StrRatingArea());
        inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP_GWC_CreateSisterPackages arvGwcSP = new ARV_AP_GWC_CreateSisterPackages();      
            
            try{       
                system.test.startTest(); 
                arvGwcSP.invokeMethod('gwcPackageClone',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
    }
}