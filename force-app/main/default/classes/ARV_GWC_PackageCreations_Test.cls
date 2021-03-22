@isTest(seealldata=false)
public class ARV_GWC_PackageCreations_Test{
    private static final string PROFILENAME1='System Administrator';
    private static final string NAME2='AP33RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string CntrctName='testcntrct';
    private static final string PACKAGE1='Package';
    private static final string PACKAGE2='Package2';
    private static final string PACKAGE3='Package3';
    private static final string MedicalPlanName='Medical';
    private static final string Medical1='med1';
    private static final string MedicalProdID='med1';
    private static final string DentalPROD='DENTPROD';
    private static final string PediatricDental='peddent';
    private static final string PEDIATRICDentalProdCode='peddencode';
    private static final string VISIONPROD='VISIONPROD';
    private static final string PEDIATRICVISIONPROD='pedvisi';
    private static final string PEDIATRICVISIONPRODCode='pedviscode';
    private static final string PRD ='prd';
    private static final string BCBSCARRIER='BCBS';
    private static final string CDH='HSA';
    private static final string BCNCARRIER='BCN';
    private static final string VOL='Voluntary';
    private static final string NonVOL='Non-Voluntary';
    private static final string PRODFAMILY1='Healthy Blue Achieve';
    private static final string ExistDental ='ExistDentalCoverGWC';
    private static final string GSNAME ='Group Segment: 5';
    
    private static string GS1ID;

     @testsetup static void testDataSetup()
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
        vlocity_ins__GroupCensusMember__c groupCensusMember=ARV_AP05_TestDataCreation.groupCensusMember(Census.Id);
        database.insert(groupCensusMember);
        Contract cntrct=new Contract(AccountId=acc.id,name=CntrctName);
        database.insert(cntrct);
        Product2 medprd= ARV_AP05_TestDataCreation.productRec1();
        database.insert(medprd);
        Product2 prd1= ARV_AP05_TestDataCreation.productRec3();
        database.insert(prd1);
        System.debug('product:'+prd1);
        Product2 pedden1= ARV_AP05_TestDataCreation.productRec3();
        pedden1.name=PediatricDental;
        pedden1.ProductCode=PEDIATRICDentalProdCode;
        database.insert(pedden1);
        Product2 denplan= ARV_AP05_TestDataCreation.productRec3();
        database.insert(denplan);
        denplan.name=DentalPROD;
        database.update(denplan);
        Product2 visplan= ARV_AP05_TestDataCreation.productRec3();
        database.insert(visplan);
        visplan.name=VISIONPROD;
        database.update(visplan);
        Product2 pedvis1= ARV_AP05_TestDataCreation.productRec3();
        pedvis1.name=PEDIATRICVISIONPROD;
        pedvis1.ProductCode=PEDIATRICVISIONPRODCode;
        database.insert(pedvis1);
        System.debug('pedDentalproduct:'+pedvis1);
        
        Package__C pack=new Package__C(Name =PACKAGE1,ARV_Contract_Id__c=cntrct.id);
        database.insert(pack);
        
        Product2 pedvis2= ARV_AP05_TestDataCreation.productVisionRec();
        database.insert(pedvis2);
        
        vlocity_ins__ContractLineItem__c pedVisPlan = ARV_AP05_TestDataCreation.planRec(pedvis2.id,cntrct.id);
        database.insert(pedVisPlan);
        
        vlocity_ins__ContractLineItem__c medPlan = ARV_AP05_TestDataCreation.planRec(medprd.id,cntrct.id);
        database.insert(medPlan);
        
        Package__C pack1=new Package__C(Name =PACKAGE2,ARV_Contract_Id__c=cntrct.id,ARV_Vision_Plan__c=pedVisPlan.id,ARV_Medical_Plan__c=medPlan.id);
        database.insert(pack1);
        
        GA_Group_Segment__c gseg=ARV_AP05_TestDataCreation.groupSegmentRec2(acc.Id,cntrct.id);//srividya
        database.insert(gseg);
        gseg.Name=GSNAME;
        gseg.ARV_Package__c=pack1.id;
        database.update(gseg);
        
		GA_Group_Segment__c gseg1=ARV_AP05_TestDataCreation.groupSegmentRec2(acc.Id,cntrct.id);//srividya
        database.insert(gseg1);
        gseg1.Name='ParentGSPrvsMedType: GS-00039776';
        database.update(gseg1);
        GS1ID = gseg1.id;
        
        Package__C pack2=new Package__C(Name =PACKAGE3,ARV_Contract_Id__c=cntrct.id,ARV_Vision_Plan__c=pedVisPlan.id,ARV_Medical_Plan__c=medPlan.id,ARV_Tech_GWC_Legacy_Id__c=GSNAME);
        database.insert(pack2);
        
        vlocity_ins__ContractLineItem__c pln = ARV_AP05_TestDataCreation.planRec(prd1.id,cntrct.id);
        database.insert(pln);
        List<vlocity_ins__ContractLineItem__c> planlist=[select id,name,
                                                       vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c 
                                                       from vlocity_ins__ContractLineItem__c where 
                                                       vlocity_ins__ContractId__c=:cntrct.id];
        system.debug('planlist:'+planlist);

        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME2;
        usr.Username=USERNAME;
        database.insert(usr,true); 
    }

 /**************  
Method name : internalUserTest
Params     : NA
Return Type : testmethod
Description :  internalUserTest() method 
*************/ 
    @istest
    public static void testpackagecreation() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> pedDental = new Map<String,Object>();
        Map<String,Object> pedVision = new Map<String,Object>();
        Map<String,Object> SelectedGS= new Map<String,Object>();
        List<Map<String,Object>> SelectedGSLst= new List<Map<String,Object>>();
        Map<String,Object> Prodselection = new Map<String,Object>();
        String quoteId=String.valueOf([select id from Quote limit 1].id);   
        String cntrctId=String.valueOf([select id from Contract where name=:CntrctName limit 1].id);
        inputMap.put('contractId',cntrctId);
        options.put('QuoteId',quoteId);
        system.debug('Contract:'+cntrctId);
        String Peddenname=String.valueOf([select id,name,ProductCode from Product2 where name=:PediatricDental limit 1].name);
        pedDental.put('ProductName',Peddenname);
        String Peddenid=String.valueOf([select id,name,ProductCode from Product2 where name=:PediatricDental limit 1].id);
        pedDental.put('ProductId',Peddenid);
        String Peddencode=String.valueOf([select id,name,ProductCode from Product2 where name=:PediatricDental limit 1].ProductCode);
        pedDental.put('ProductCode',Peddencode);
        //denlst.put(Null,pedDental);
        system.debug('PediatricDental'+pedDental);
        String Pedvisname=String.valueOf([select id,name,ProductCode from Product2 where name=:PEDIATRICVISIONPROD limit 1].name);
        pedVision.put('ProductName',Pedvisname);
        String Pedvisid=String.valueOf([select id,name,ProductCode from Product2 where name=:PEDIATRICVISIONPROD limit 1].id);
        pedVision.put('ProductId',Pedvisid);
        String Pedviscode=String.valueOf([select id,name,ProductCode from Product2 where name=:PEDIATRICVISIONPROD limit 1].ProductCode);
        pedVision.put('ProductCode',Pedviscode);
        system.debug('PediatricVision'+pedVision);
        Prodselection.put('ExistingDentalCoverageGWC','No');
        String visid=String.valueOf([select id,name from Product2 where name=:VISIONPROD limit 1].id);
        List<Map<String,Object>> finalGroupSegmentsPlansLST = new List<Map<String,Object>>();
        Map<String,Object> finalGroupSegmentsPlans = new Map<String,Object>();
        Map<String,Object> finalGroupSegmentsPlans1 = new Map<String,Object>();
        Map<String,Object> finalGroupSegmentsPlans2 = new Map<String,Object>();
        String medPrdId=String.valueOf([select id,name from Product2 where name='Health Plan' limit 1].id);
        String medPrdname=String.valueOf([select id,name from Product2 where name='Health Plan' limit 1].name);
        String grgSeg=String.valueOf([select id,name from GA_Group_Segment__c where name=:GSNAME limit 1].name);
        String dentalPrdId=String.valueOf([select id,name from Product2 where name=:DentalPROD limit 1].id);
        //SelectedGS.put(null,grgSeg);
       // SelectedGSLst.add(SelectedGS);
        List<String> SelectedLst= new List<String>();
        SelectedLst.add(grgSeg);
        system.debug('SelectedGSLst'+SelectedGSLst);
        finalGroupSegmentsPlans.put('medPrdId',medPrdId);
        finalGroupSegmentsPlans.put('medicalPlan',medPrdname);
        finalGroupSegmentsPlans.put('denPrdId',dentalPrdId);
        finalGroupSegmentsPlans.put('isNewGS',true);
        finalGroupSegmentsPlans.put('isAddSegLoc',true);//srividya
        finalGroupSegmentsPlans.put('selectedGS',SelectedLst);
        finalGroupSegmentsPlans.put('visPrdId',visid);
        finalGroupSegmentsPlans.put('dentalPlan','Not Offered');
        
        String countryName = 'IND';
        GA_County_Code__c countyRec= new GA_County_Code__c(Name=countryName);
        database.insert(countyRec);
        
        Map<string,string> county = new Map<string,string>();
        county.put('name',countryName);
        finalGroupSegmentsPlans.put('County', county);
        
        
        finalGroupSegmentsPlans2.put('medPrdId',medPrdId);
        finalGroupSegmentsPlans2.put('medicalPlan',medPrdname);
        finalGroupSegmentsPlans2.put('isNewGS',false);
        finalGroupSegmentsPlans2.put('selectedGS',SelectedLst);
        
        
        
       // finalGroupSegmentsPlans2.put('visPrdId',Null);
        finalGroupSegmentsPlansLST.add(finalGroupSegmentsPlans);
        finalGroupSegmentsPlansLST.add(finalGroupSegmentsPlans1);
        finalGroupSegmentsPlansLST.add(finalGroupSegmentsPlans2);
        inputMap.put('finalGroupSegmentsPlans',finalGroupSegmentsPlansLST);
        inputMap.put('Productselection',Prodselection);
        inputMap.put('pediatricDental',pedDental);
        inputMap.put('pediatricVision',pedVision);
        
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){    
            ARV_GWC_PackageCreations packcreate = new ARV_GWC_PackageCreations();
         try{       
                system.test.startTest();
                packcreate.invokemethod('createPackages',inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
            }
        }
    }
       @istest
    public static void testpackagecreation1() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> pedDental1 = new Map<String,Object>();
        Map<String,Object> pedVision1 = new Map<String,Object>();
        Map<String,Object> SelectedGS1= new Map<String,Object>();
        List<Map<String,Object>> SelectedGSLst= new List<Map<String,Object>>();
        Map<String,Object> Prodselection1 = new Map<String,Object>();
        String quoteId=String.valueOf([select id from Quote limit 1].id);   
        String cntrctId=String.valueOf([select id from Contract where name=:CntrctName limit 1].id);
        inputMap.put('contractId',cntrctId);
        options.put('QuoteId',quoteId);
        system.debug('Contract:'+cntrctId);
        String Peddenname=String.valueOf([select id,name,ProductCode from Product2 where name=:PediatricDental limit 1].name);
        pedDental1.put('ProductName',Peddenname);
        String Peddenid=String.valueOf([select id,name,ProductCode from Product2 where name=:PediatricDental limit 1].id);
        pedDental1.put('ProductId',Peddenid);
        String Peddencode=String.valueOf([select id,name,ProductCode from Product2 where name=:PediatricDental limit 1].ProductCode);
        pedDental1.put('ProductCode',Peddencode);
        //denlst.put(Null,pedDental);
        system.debug('PediatricDental'+pedDental1);
            String Pedvisname=String.valueOf([select id,name,ProductCode from Product2 where name=:PEDIATRICVISIONPROD limit 1].name);
        pedVision1.put('ProductName',Pedvisname);
        String Pedvisid=String.valueOf([select id,name,ProductCode from Product2 where name=:PEDIATRICVISIONPROD limit 1].id);
        pedVision1.put('ProductId',Pedvisid);
        String Pedviscode=String.valueOf([select id,name,ProductCode from Product2 where name=:PEDIATRICVISIONPROD limit 1].ProductCode);
        pedVision1.put('ProductCode',Pedviscode);
        system.debug('PediatricVision'+pedVision1);
        Prodselection1.put('ExistingDentalCoverageGWC','No');
        String visid=String.valueOf([select id,name from Product2 where name=:VISIONPROD limit 1].id);
        List<Map<String,Object>> finalGroupSegmentsPlansLST1 = new List<Map<String,Object>>();
        Map<String,Object> finalGroupSegmentsPlans1 = new Map<String,Object>();
        String medPrdId=String.valueOf([select id,name from Product2 where name='Health Plan' limit 1].id);
        String medPrdname=String.valueOf([select id,name from Product2 where name='Health Plan' limit 1].name);
        List<GA_Group_Segment__c> GSList=[select id,name from GA_Group_Segment__c];
        //String Peddenid1=String.valueOf([select id,name,ProductCode from Product2 where name=:PediatricDental limit 1].id);
        List<String> SelectedLst1= new List<String>();
        for(GA_Group_Segment__c gSeg:GSList){
            SelectedLst1.add(gSeg.name);
        }
        system.debug('SelectedGSLst'+SelectedLst1);
        finalGroupSegmentsPlans1.put('dentalPlan','Not Offered');
        finalGroupSegmentsPlans1.put('medicalPlan','medPrdname');
        //finalGroupSegmentsPlans1.put('medPrdId','medPrdId');
        finalGroupSegmentsPlans1.put('visionPlan','Not Offered');
        finalGroupSegmentsPlans1.put('visPrdId','NOV');
        finalGroupSegmentsPlans1.put('pedDentalPrdId','NOV');
        finalGroupSegmentsPlans1.put('isNewGS',true);
        finalGroupSegmentsPlans1.put('isAddSegLoc',false);//srividya
        finalGroupSegmentsPlans1.put('medicalType','BCBS');//srividya
        finalGroupSegmentsPlans1.put('selectedGS',SelectedLst1);
        finalGroupSegmentsPlansLST1.add(finalGroupSegmentsPlans1);
        inputMap.put('finalGroupSegmentsPlans',finalGroupSegmentsPlansLST1);
        inputMap.put('Productselection',Prodselection1);
        inputMap.put('pediatricDental',pedDental1);
        inputMap.put('pediatricVision',pedVision1);
        
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){    
            ARV_GWC_PackageCreations packcreate = new ARV_GWC_PackageCreations();
         try{       
                system.test.startTest();
                packcreate.invokemethod('createPackages',inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){   
            }
        }
    }
    
    
    @istest
    public static void testpackagecreation2() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> pedDental1 = new Map<String,Object>();
        Map<String,Object> pedVision1 = new Map<String,Object>();
        Map<String,Object> SelectedGS1= new Map<String,Object>();
        List<Map<String,Object>> SelectedGSLst= new List<Map<String,Object>>();
        Map<String,Object> Prodselection1 = new Map<String,Object>();
        String quoteId=String.valueOf([select id from Quote limit 1].id);   
        String cntrctId=String.valueOf([select id from Contract where name=:CntrctName limit 1].id);
        inputMap.put('contractId',cntrctId);
        options.put('QuoteId',quoteId);
        system.debug('Contract:'+cntrctId);
        String Peddenname=String.valueOf([select id,name,ProductCode from Product2 where name=:PediatricDental limit 1].name);
        pedDental1.put('ProductName',Peddenname);
        String Peddenid=String.valueOf([select id,name,ProductCode from Product2 where name=:PediatricDental limit 1].id);
        pedDental1.put('ProductId',Peddenid);
        String Peddencode=String.valueOf([select id,name,ProductCode from Product2 where name=:PediatricDental limit 1].ProductCode);
        pedDental1.put('ProductCode',Peddencode);
        //denlst.put(Null,pedDental);
        system.debug('PediatricDental'+pedDental1);
            String Pedvisname=String.valueOf([select id,name,ProductCode from Product2 where name=:PEDIATRICVISIONPROD limit 1].name);
        pedVision1.put('ProductName',Pedvisname);
        String Pedvisid=String.valueOf([select id,name,ProductCode from Product2 where name=:PEDIATRICVISIONPROD limit 1].id);
        pedVision1.put('ProductId',Pedvisid);
        String Pedviscode=String.valueOf([select id,name,ProductCode from Product2 where name=:PEDIATRICVISIONPROD limit 1].ProductCode);
        pedVision1.put('ProductCode',Pedviscode);
        system.debug('PediatricVision'+pedVision1);
        Prodselection1.put('ExistingDentalCoverageGWC','No');
        String visid=String.valueOf([select id,name from Product2 where name=:VISIONPROD limit 1].id);
        List<Map<String,Object>> finalGroupSegmentsPlansLST1 = new List<Map<String,Object>>();
        Map<String,Object> finalGroupSegmentsPlans1 = new Map<String,Object>();
        String medPrdId=String.valueOf([select id,name from Product2 where name='Health Plan' limit 1].id);
        String medPrdname=String.valueOf([select id,name from Product2 where name='Health Plan' limit 1].name);
        List<GA_Group_Segment__c> GSList=[select id,name from GA_Group_Segment__c];
        List<String> SelectedLst1= new List<String>();
        for(GA_Group_Segment__c gSeg:GSList){
            SelectedLst1.add(gSeg.name);
        }
        system.debug('SelectedGSLst'+SelectedLst1);
        finalGroupSegmentsPlans1.put('dentalPlan','Not Offered');
        finalGroupSegmentsPlans1.put('medicalPlan','medPrdname');
        finalGroupSegmentsPlans1.put('groupSegmentName',GSNAME);
        finalGroupSegmentsPlans1.put('oldDentalPlan','Pediatric Dental');
        finalGroupSegmentsPlans1.put('oldDenVolType','Voluntary');
        finalGroupSegmentsPlans1.put('denVolType','Non-Voluntary');
        finalGroupSegmentsPlans1.put('visionPlan','Not Offered');
        finalGroupSegmentsPlans1.put('visPrdId','NOV');
        finalGroupSegmentsPlans1.put('pedDentalPrdId','NOV');
        finalGroupSegmentsPlans1.put('isNewGS',false);
        finalGroupSegmentsPlans1.put('isAddSegLoc',false);//srividya
        finalGroupSegmentsPlans1.put('medicalType','BCN');//srividya
        finalGroupSegmentsPlans1.put('selectedGS',SelectedLst1);
        finalGroupSegmentsPlansLST1.add(finalGroupSegmentsPlans1);
        inputMap.put('finalGroupSegmentsPlans',finalGroupSegmentsPlansLST1);
        inputMap.put('Productselection',Prodselection1);
        inputMap.put('pediatricDental',pedDental1);
        inputMap.put('pediatricVision',pedVision1);
        
		Map<String,Object> location = new Map<String,Object>();
        List<Object> locationList = new List<Object>();
        //public string ZipCode;
            //public string GroupSegmentName;
            //public string GSName;
            //public Map<string,string> County;
        location.put('LocationName', 'hyd');
        location.put('GroupSegmentName', GSNAME);
        location.put('GSName', GSNAME);
        Map<string,string> county = new Map<string,string>();
        county.put('name','IND');
        location.put('County', county);
        
        locationList.add(location);
        inputMap.put('NewLocationDetails_JS_No',locationList);
        //NewLocationDetails_JS_No
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){    
            ARV_GWC_PackageCreations packcreate = new ARV_GWC_PackageCreations();
         try{       
                system.test.startTest();
                packcreate.invokemethod('createPackages',inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){   
            }
        }
    }
}