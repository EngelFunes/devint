@isTest(seealldata=false)
public class ARV_AP103_GWC_SystemCheck_Criteria_Test {
    ARV_AP103_GWC_SystemCheck_Criteria_Test(){}
    private static final string PROFILENAME1='Retention Sales';
    private static final string NAME2='AP33RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string CntrctName='testcntrct';
    private static final string PACKAGE1='Package';
    private static final string Medical='med';
    private static final string Medical1='med1';
    private static final string BCNMedicalOldProdCode='bcnmedoldprodcode';
    private static final string BCNMedicalNewProdCode='bcnmednewprodcode';
    private static final string BCBSMMedicalOldProdCode='bcbsmmedoldprodcode';
    private static final string BCBSMMedicalNewProdCode='bcbsmmednewprodcode';
    private static final string DENTPROD='DENTPROD';
    private static final string RatingArea='B';
    private static final string DENTPROD1='DENTPROD1';
    private static final string DentalVolOldProdCode='denvololdprodcode';
    private static final string DentalVolNewProdCode='dennvolnewprodcode';
    private static final string DentalNonVolProdCode='dennonvolprodcode';
    private static final string VISIONPROD='VISIONPROD';
    private static final string VISIONPROD1='VISIONPROD1';
    private static final string VisionVolOldProdCode='visvololdprodcode';
    private static final string VisionVolNewProdCode='visvolnewprodcode';
    private static final string VisionNonVolProdCode='visnonvolprodcode';
    private static final string PEDIATRICVISIONPROD='Pediatric VISION';
    private static final string PEDIATRICVISIONPRODCode='pedvisprodcode';
    private static final string BCBSCARRIER='BCBS';
    private static final string BCNCARRIER='BCN';
    private static final string CDH='HSA';
    private static final string VOL='Voluntary';
    private static final string NonVOL='Non-Voluntary';
    private static final string PRODFAMILY1='Healthy Blue Achieve';
    private static final string PRODFAMILY2='HSA';
    private static string id_cntrct(map<String,Object> dd) 
    {
        Package__C pack=[SELECT Id, ARV_Contract_Id__c FROM Package__C WHERE Name=:PACKAGE1 LIMIT 1];
        String blobdata=JSON.serialize(dd);
        pack.ARV_GWC_Package_Change_Attributes__c=blobdata;
        update pack;
        System.assert(blobdata!='Null');
        return String.valueOf(pack.ARV_Contract_Id__c);
    }
    
    @testSetup static void testDataSetup()
    {
        Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);
        List<Contract> con=new List<Contract>();
        Contract cntrct=new Contract(AccountId=acc.id,name=CntrctName,
                                     ARV_RatingArea__c='A',ARV_Requested_Effective_Date__c=system.Today()+90
                                   );
        con.add(cntrct);
        Contract newCntrct=new Contract(AccountId=acc.id,ARV_RatingArea__c='B',
                                        ARV_Requested_Effective_Date__c=system.Today());
        newCntrct.name='Test';
        con.add(newCntrct);
        database.insert(con);
        pricebook2 pb=ARV_AP05_TestDataCreation.priceBookRec();
        database.insert(pb);
        opportunity opp=ARV_AP05_TestDataCreation.opportunityRec(acc.id,pb.id);
        database.insert(opp);
        Package__C pack=new Package__C(Name =PACKAGE1,ARV_Contract_Id__c=cntrct.id);
        database.insert(pack);
        Quote quoteRec=ARV_AP05_TestDataCreation.quoteRec(Opp.Id,pb.Id);
        database.insert(quoteRec);
        quoteRec.ARV_CF_Tech_RatingArea__C=RatingArea;
        database.update(quoteRec);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME2;
        usr.Username=USERNAME;
        database.insert(usr,true); 
         
    }
    @isTest    
    static void testaprvGWCContrct() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        String cntrctId=String.valueOf([select id from Contract where name=:CntrctName limit 1].id);
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){    
            ARV_AP103_GWC_SystemCheck_Criteria arvGwcSysch = new ARV_AP103_GWC_SystemCheck_Criteria();
         try{       
                system.test.startTest(); 
                arvGwcSysch.invokemethod('aprvGWCContrct',inputMap,outMap,options);
             inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());
                ARV_AP103_GWC_SystemCheck_Criteria.aprvGWCContrct(cntrctId); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
        }
        system.assert(cntrctId!=Null);
    }
     private static String StrRatingArea(){
        String StrRatingArea=String.valueOf( [select id,ARV_CF_Tech_RatingArea__c from quote
                              where ARV_CF_Tech_RatingArea__c=:RatingArea].ARV_CF_Tech_RatingArea__c);
         System.assert(StrRatingArea!='Null');
        return StrRatingArea;
        
    }
    private static Map<String,object> quoteDetails(){
        Map<String,object> quoteDetails=new Map<String,object>();
        quoteDetails.put('ARV_CF_Tech_RatingArea__c',StrRatingArea());
        return quoteDetails;
    }
   
    //condition#3
    @isTest    
    static void testGWCSysChCon3() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCBSCARRIER,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>Medical1,
            'Old Product Family:'=>PRODFAMILY1,
            'New Product Family:'=>PRODFAMILY1,
            'Old Product Code:'=>BCBSMMedicalOldProdCode,
            'New Product Code:'=>BCBSMMedicalNewProdCode,
            'Old Carrier:'=>BCBSCARRIER
            };
        inputMap.put('contractId',id_cntrct(blobmap));
        inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP103_GWC_SystemCheck_Criteria arvGwcSysch = new ARV_AP103_GWC_SystemCheck_Criteria();      
            //ARV_AP_systemCheckAfterPackageDeletion arvGwcSysch1= new ARV_AP_systemCheckAfterPackageDeletion(); 
            try{       
                inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());
                system.test.startTest(); 
                arvGwcSysch.invokemethod('gwcPlansSystemCheck',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
            System.assert(blobmap.size()!=Null);
        }
     }
    //condition#4
    @isTest    
    static void testGWCSysChCon4() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCBSCARRIER,
            'Old Product Family:'=>PRODFAMILY1,
            'New Product Family:'=>PRODFAMILY2,
            'Old Medical Product Code:'=>BCBSMMedicalOldProdCode,
            'New Medical Product Code:'=>BCBSMMedicalNewProdCode,
            'Old Carrier:'=>BCBSCARRIER
            };
            inputMap.put('contractId',id_cntrct(blobmap));
        inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());
         user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP103_GWC_SystemCheck_Criteria arvGwcSysch = new ARV_AP103_GWC_SystemCheck_Criteria();      
           /* inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());*/
            try{       
                system.test.startTest(); 
                arvGwcSysch.invokemethod('gwcPlansSystemCheck',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
            System.assert(blobmap.size()!=Null);
        }
    }
    
    //condition#6
    @isTest    
    static void testGWCSysChCon6() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'New Vision Type:'=>VOL,
            'Old Vision Type:'=>NonVOL,
            'Old BCN Product Code:'=>BCNMedicalOldProdCode,
            'New BCN Product Code:'=>BCNMedicalOldProdCode,
            'Old Vision Product Code:'=>VisionVolOldProdCode,
            'New Vision Product Code:'=>VisionNonVolProdCode,
            'Old Carrier:'=>BCNCARRIER};
               inputMap.put('contractId',id_cntrct(blobmap));
        inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP103_GWC_SystemCheck_Criteria arvGwcSysch = new ARV_AP103_GWC_SystemCheck_Criteria();      
            
            try{       
                system.test.startTest(); 
                arvGwcSysch.invokemethod('gwcPlansSystemCheck',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
            System.assert(blobmap.size()!=Null);
        }
    }
    //condition7
    @isTest    
    static void testGWCSysChCon7() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Vision Plan:'=>PEDIATRICVISIONPROD,
            'New Vision Plan:'=>VISIONPROD,
            'New Vision Type:'=>VOL,
            'Old Vision Product Code:'=>PEDIATRICVISIONPRODCode,
            'New Vision Product Code:'=>VisionNonVolProdCode,
            'Old BCN Product Code:'=>BCNMedicalOldProdCode,
            'New BCN Product Code:'=>BCNMedicalOldProdCode,
            'Old Carrier:'=>BCNCARRIER};
               inputMap.put('contractId',id_cntrct(blobmap));
        inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());
       user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP103_GWC_SystemCheck_Criteria arvGwcSysch = new ARV_AP103_GWC_SystemCheck_Criteria();      
            /*inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());*/
            try{       
                system.test.startTest(); 
                arvGwcSysch.invokemethod('gwcPlansSystemCheck',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
            System.assert(blobmap.size()!=Null);
        }
    }
    //condition1,5,8,10
    @isTest    
    static void testGWCSysChCon1_5_8_10() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>Medical1,
            'Old CDHPckgComb:'=>CDH,
            'New CDHPckgComb:'=>CDH,
            'Old Product Family:'=>PRODFAMILY2,
            'New Product Family:'=>PRODFAMILY2,
            'Old Vision Plan:'=>VISIONPROD,
            'New Vision Plan:'=>VISIONPROD1,
            'Old Dental Plan:'=>DENTPROD1,
            'New Dental Plan:'=>DENTPROD,
            'Old Dental Type:'=>VOL,
            'New Dental Type:'=>VOL,
            'Old Vision Type:'=>VOL,
            'New Vision Type:'=>VOL,
            'Old Dental Product Code:'=>DentalVolOldProdCode,
            'New Dental Product Code:'=>DentalVolNewProdCode,
            'Old Vision Product Code:'=>VisionVolOldProdCode,
            'New Vision Product Code:'=>VisionVolNewProdCode,
            'Old BCN Product Code:'=>BCNMedicalOldProdCode,
            'New BCN Product Code:'=>BCNMedicalOldProdCode,
            'New BCN Product Code:'=>BCNMedicalNewProdCode,
            'Old Carrier:'=>BCNCARRIER};
         inputMap.put('contractId',id_cntrct(blobmap));
        inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP103_GWC_SystemCheck_Criteria arvGwcSysch = new ARV_AP103_GWC_SystemCheck_Criteria();      
            /*inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());*/
            try{       
                system.test.startTest(); 
                arvGwcSysch.invokemethod('gwcPlansSystemCheck',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
            System.assert(blobmap.size()!=Null);
        }
    }
    //condition11
    @isTest    
    static void testGWCSysChCon9_11() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'New Dental Type:'=>NonVOL,
            'New Vision Type:'=>NonVOL,
            'Old Dental Type:'=>VOL,
            'Old Vision Type:'=>VOL,
            'Old Medical Plan:'=>Medical,
            'New Medical Plan:'=>Medical1,
            'Old Product Family:'=>PRODFAMILY2,
            'New Product Family:'=>PRODFAMILY2,
            'Old CDHPckgComb:'=>CDH,
            'New CDHPckgComb:'=>'no',
            'Old Vision Plan:'=>VISIONPROD,
            'New Vision Plan:'=>VISIONPROD1,
           'Old Dental Plan:'=>DENTPROD,
            'New Dental Plan:'=>DENTPROD1,
            'Old Dental Product Code:'=>DentalVolOldProdCode,
            'New Dental Product Code:'=>DentalNonVolProdCode,
            'Old Vision Product Code:'=>VisionVolOldProdCode,
            'New Vision Product Code:'=>VisionNonVolProdCode,
            'Old BCN Product Code:'=>BCNMedicalOldProdCode,
            'New BCN Product Code:'=>BCNMedicalOldProdCode,
            'New BCN Product Code:'=>BCNMedicalNewProdCode,
            'Old Carrier:'=>BCNCARRIER};
                system.debug('CDH::'+[SELECT Id,name,ARV_GWC_Package_Change_Attributes__c FROM Package__C
                              WHERE ARV_Contract_Id__c=:id_cntrct(blobmap) LIMIT 1]);
             inputMap.put('contractId',id_cntrct(blobmap));
        inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP103_GWC_SystemCheck_Criteria arvGwcSysch = new ARV_AP103_GWC_SystemCheck_Criteria();      
            /*inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());*/
            try{       
                system.test.startTest(); 
                arvGwcSysch.invokemethod('gwcPlansSystemCheck',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
            System.assert(blobmap.size()!=Null);
        }
    }
    //condition12
    @isTest    
    static void testGWCSysChCon12() 
    {
        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Dental Type:'=>VOL,
            'Old Vision Type:'=>VOL,
            'New Dental Type:'=>VOL,
            'New Vision Type:'=>NonVOL,
            'Old Vision Plan:'=>VISIONPROD,
            'New Vision Plan:'=>VISIONPROD1,
           'Old Dental Plan:'=>DENTPROD,
            'New Dental Plan:'=>DENTPROD1,
            'Old Dental Product Code:'=>DentalVolOldProdCode,
            'New Dental Product Code:'=>DentalVolNewProdCode,
            'Old Vision Product Code:'=>VisionVolOldProdCode,
            'New Vision Product Code:'=>VisionNonVolProdCode,
            'Old BCN Product Code:'=>BCNMedicalOldProdCode,
            'New BCN Product Code:'=>BCNMedicalOldProdCode,
            'Old Carrier:'=>BCNCARRIER};
                inputMap.put('contractId',id_cntrct(blobmap));
        inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP103_GWC_SystemCheck_Criteria arvGwcSysch = new ARV_AP103_GWC_SystemCheck_Criteria();      
            /*inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());*/
            try{       
                system.test.startTest(); 
                arvGwcSysch.invokemethod('gwcPlansSystemCheck',inputMap,outMap,options); 
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
            System.assert(blobmap.size()!=Null);
        }
    }
    //condition13
    @isTest    
    static void testGWCSysChCon2_13() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Dental Type:'=>VOL,
            'Old Vision Type:'=>VOL,
            'New Dental Type:'=>NonVOL,
            'New Vision Type:'=>VOL,
            'Old Vision Plan:'=>VISIONPROD,
            'New Vision Plan:'=>VISIONPROD1,
            'Old Dental Product Code:'=>DentalVolOldProdCode,
            'New Dental Product Code:'=>DentalNonVolProdCode,
            'Old Vision Product Code:'=>VisionVolOldProdCode,
            'New Vision Product Code:'=>VisionVolNewProdCode,
            'Old BCN Product Code:'=>BCNMedicalOldProdCode,
            'New BCN Product Code:'=>BCNMedicalOldProdCode,
            'Old Carrier:'=>BCNCARRIER};
               inputMap.put('contractId',id_cntrct(blobmap));
        inputMap.put('finalContRA',StrRatingArea());
             inputMap.put('quoteDetail',quoteDetails());
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            ARV_AP103_GWC_SystemCheck_Criteria arvGwcSysch = new ARV_AP103_GWC_SystemCheck_Criteria(); 
           // ARV_AP_systemCheckAfterPackageDeletion arvGwcSysch1= new ARV_AP_systemCheckAfterPackageDeletion();        
            try{       
                system.test.startTest(); 
                arvGwcSysch.invokemethod('gwcPlansSystemCheck',inputMap,outMap,options); 
               // arvGwcSysch1.invokemethod('systemCheckAfterPackageDeletion',inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
            System.assert(blobmap.size()!=Null);
        }
    }
     @isTest    
    static void testGWCSysChCon2_14() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Dental Type:'=>VOL,
            'Old Vision Type:'=>VOL,
            'New Dental Type:'=>NonVOL,
            'New Vision Type:'=>VOL,
            'Old Vision Plan:'=>VISIONPROD,
            'New Vision Plan:'=>VISIONPROD1,
            'Old Dental Product Code:'=>DentalVolOldProdCode,
            'New Dental Product Code:'=>DentalNonVolProdCode,
            'Old Vision Product Code:'=>VisionVolOldProdCode,
            'New Vision Product Code:'=>VisionVolNewProdCode,
            'Old BCN Product Code:'=>BCNMedicalOldProdCode,
            'New BCN Product Code:'=>BCNMedicalOldProdCode,
            'Old Carrier:'=>BCNCARRIER};
               inputMap.put('contractId',id_cntrct(blobmap));
        Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);
        Contract newCntrct=new Contract(AccountId=acc.id,ARV_RatingArea__c='B',
                                        ARV_Requested_Effective_Date__c=system.Today());
        newCntrct.name='Test';
        database.insert(newCntrct);
        //system.debug('newCntrct::'+newCntrct);
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            //ARV_AP103_GWC_SystemCheck_Criteria arvGwcSysch = new ARV_AP103_GWC_SystemCheck_Criteria();
            string conId=newCntrct.id;
            system.debug('conId:'+conId);
           // ARV_AP_systemCheckAfterPackageDeletion arvGwcSysch1= new ARV_AP_systemCheckAfterPackageDeletion();        
            try{       
                system.test.startTest(); 
                ARV_AP103_GWC_SystemCheck_Criteria.fetchUserprof(conId); 
               // arvGwcSysch1.invokemethod('systemCheckAfterPackageDeletion',inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
            System.assert(blobmap.size()!=Null);
        }
    }
   @isTest    
    static void testGWCSysChCon15() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> blobmap=new Map<String,Object>{'New Carrier:'=>BCNCARRIER,
            'Old Dental Type:'=>VOL,
            'Old Vision Type:'=>VOL,
            'New Dental Type:'=>NonVOL,
            'New Vision Type:'=>VOL,
            'Old Vision Plan:'=>VISIONPROD,
            'New Vision Plan:'=>VISIONPROD1,
            'Old Dental Product Code:'=>DentalVolOldProdCode,
            'New Dental Product Code:'=>DentalNonVolProdCode,
            'Old Vision Product Code:'=>VisionVolOldProdCode,
            'New Vision Product Code:'=>VisionVolNewProdCode,
            'Old BCN Product Code:'=>BCNMedicalOldProdCode,
            'New BCN Product Code:'=>BCNMedicalOldProdCode,
            'Old Carrier:'=>BCNCARRIER};
               inputMap.put('contractId',id_cntrct(blobmap));
        Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);
        Contract newCntrct=new Contract(AccountId=acc.id,ARV_RatingArea__c='B',
                                        ARV_Requested_Effective_Date__c=system.Today());
        newCntrct.name='Test';
        database.insert(newCntrct);
        //system.debug('newCntrct::'+newCntrct);
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){                                 
            //ARV_AP103_GWC_SystemCheck_Criteria arvGwcSysch = new ARV_AP103_GWC_SystemCheck_Criteria();
            string conId=newCntrct.id;
            system.debug('conId:'+conId);
           // ARV_AP_systemCheckAfterPackageDeletion arvGwcSysch1= new ARV_AP_systemCheckAfterPackageDeletion();        
            try{       
                system.test.startTest(); 
                ARV_AP103_GWC_SystemCheck_Criteria.aprvGWCContrct(conId); 
               // arvGwcSysch1.invokemethod('systemCheckAfterPackageDeletion',inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){
                return ;}
            System.assert(blobmap.size()!=Null);
        }
    }
   
     
       
}