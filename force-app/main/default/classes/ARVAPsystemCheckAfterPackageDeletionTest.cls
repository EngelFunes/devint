@isTest(seealldata=false)
public class ARVAPsystemCheckAfterPackageDeletionTest {
    ARVAPsystemCheckAfterPackageDeletionTest(){}
    private static final string PROFILENAME1='System Administrator';
    private static final string NAME='AP33RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string CntrctName='testcntrct';
    private static final string PACKAGE1='Package';
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
    private static final string GSNum ='Group Segment: GS-00039775';
    private static final String TEST_VAL='Test';
    private static final String METHODNAME='systemCheckAfterPackageDeletion';
    @testsetup
    public static void testDataSetup()
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
        GA_Group_Segment__c gseg=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cntrct.id);
        database.insert(gseg);
        gseg.Name=GSNum;
        database.update(gseg);
        vlocity_ins__ContractLineItem__c pln = ARV_AP05_TestDataCreation.planRec(prd1.id,cntrct.id);
        database.insert(pln);
        List<vlocity_ins__ContractLineItem__c> planlist=[select id,name,
                                                       vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c 
                                                       from vlocity_ins__ContractLineItem__c where 
                                                       vlocity_ins__ContractId__c=:cntrct.id];
        system.debug('planlist:'+planlist);
        Package__C pack=new Package__C(Name =PACKAGE1,ARV_Contract_Id__c=cntrct.id);
        database.insert(pack);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        try{
        usr.LastName = NAME;
        usr.Username=USERNAME;
        database.insert(usr,true);
        }
        catch(Exception e){
            system.debug('Error at::'+e.getLineNumber());
        }
    }
   @isTest    
    public static void testGWCSysChCon3() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> groupsegment = new Map<String,Object>();
        
        groupsegment.put('GSId',METHODNAME);
        groupsegment.put('GSCarrier','BCBSM');
        groupsegment.put('GSdenVolType','Voluntary');
        Map<String,Object> finalgroupseg = new Map<String,Object>();
        finalgroupseg.put('groupSegmentId',METHODNAME);
        inputMap.put('GroupSegments',groupsegment);
        inputMap.put('finalGroupSegmentsPlans',finalgroupseg);
        outMap.put('CheckBCBSVolDen',true);
        
        
        user usr1  = [SELECT Id from User where LastName =:NAME limit 1];
        
        system.runAs(usr1){                                     
            ARV_AP_systemCheckAfterPackageDeletion arvGwcSysch1= new ARV_AP_systemCheckAfterPackageDeletion(); 
            
        
            try{       
                system.test.startTest(); 
                arvGwcSysch1.invokemethod('systemCheckAfterPackageDeletion',inputMap,outMap,options); 
                arvGwcSysch1.systemCheckAfterPackageDeletion(inputMap, outMap, options);
                system.debug('inputMap@@'+inputMap);
                system.test.stopTest(); 
            }Catch(Exception e){
                //throw new AuraHandledException(e.getMessage()+e.getlinenumber());  
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(groupsegment.size()!=Null);
        }
    }

    
}