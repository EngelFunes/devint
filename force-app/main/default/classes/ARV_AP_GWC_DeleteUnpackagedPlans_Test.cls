@isTest(seealldata=false)
public class ARV_AP_GWC_DeleteUnpackagedPlans_Test {
    
    private static final string CntrctName='testcntrct';
    private static final string CntrctName1='testcntrct1';
    private static final string METHOD_NAME ='gwcDeletePlans';
    private static final string PACKAGE_NAME='Package';
    private static final string PACKAGE_NAME1='Package1';
    
     @testsetup static void testDataSetup()
    {
        Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);
        Contract cntrct=new Contract(AccountId=acc.id,name=CntrctName);
        database.insert(cntrct);
        
        //used package
        Product2 medprd= ARV_AP05_TestDataCreation.productRec1();
        database.insert(medprd);

        vlocity_ins__ContractLineItem__c pln = ARV_AP05_TestDataCreation.planRec(medprd.id,cntrct.id);
        database.insert(pln);
        
        //List<vlocity_ins__ContractLineItem__c> planlist=[select id,name,
                                                     //  vlocity_ins__Product2Id__c,vlocity_ins__ContractId__c 
                                                       //from vlocity_ins__ContractLineItem__c where 
                                                       //vlocity_ins__ContractId__c=:cntrct.id];
        //system.debug('planlist:'+planlist);
        
        Package__C pack=new Package__C(Name =PACKAGE_NAME,ARV_Contract_Id__c=cntrct.id,ARV_Medical_Plan__c=pln.id);
        database.insert(pack);
        
        
        //Unused package
        Product2 medprd1= ARV_AP05_TestDataCreation.productRec1();
        database.insert(medprd1);
        
        vlocity_ins__ContractLineItem__c pln1 = ARV_AP05_TestDataCreation.planRec(medprd1.id,cntrct.id);
        database.insert(pln1);
        
        Package__C pack1=new Package__C(Name =PACKAGE_NAME1,ARV_Contract_Id__c=cntrct.id);
        database.insert(pack1);
        
    }
    
    @isTest
    public static void testDeletePlan() {
        
        String cntrctId=String.valueOf([select id from Contract where name=:CntrctName limit 1].id);
        
        Map<String,Object> inputMap = new Map<String,Object>();       
        inputMap.put('contractId',cntrctId);
        
        Map<String,Object> outMap = new Map<String,Object>();  
        Map<String,Object> options = new Map<String,Object>();  
        
        ARV_AP_GWC_DeleteUnpackagedPlans deleteUnpackagedPlans = new ARV_AP_GWC_DeleteUnpackagedPlans();
        
        deleteUnpackagedPlans.invokemethod(METHOD_NAME,inputMap,outMap,options);
    }
    
}