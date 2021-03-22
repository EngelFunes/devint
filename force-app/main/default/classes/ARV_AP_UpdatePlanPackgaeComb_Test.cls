@isTest(seealldata=false)
public class ARV_AP_UpdatePlanPackgaeComb_Test {
    private static final string PROFILENAME1='System Administrator';
    private static final string NAME2='AP33RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string CntrctName='testcntrct';
    private static final string METHODNAME1 ='updatePlnPckgCmb';
    private static final string MedicalPlan='medplan';
    private static final string BCNMEDICALPlan='bcnmed';
    private static final string BCBSMMEDICALPlan='bcbsmmed';
    private static final string DENTALPlan='denplan';
    private static final string DentvolContr='Voluntary';
    private static final string PedDENTALPlan='peden';
    private static final string VISIONPlan='visplan';
    private static final string VisvolContr='Voluntary';
    private static final string PACKAGE1='Package';
    private static final string PedVISIONPlan='pedvis';
    private static boolean FreeStandingDental=Null;
    private static boolean FreeStandingVision=Null;

     @testSetup static void testDataSetup(){
        Account acc=ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);
        Contract cntrct=new Contract(AccountId=acc.id,name=CntrctName,ARV_Freestanding_Dental__c=false,
                                    ARV_Freestanding_Vision__c=false);
        database.insert(cntrct);
        Product2 medlprd= ARV_AP05_TestDataCreation.productRec1();
        database.insert(medlprd);
        medlprd.name=MedicalPlan;
        database.update(medlprd);
         
         
        Product2 dentplan= ARV_AP05_TestDataCreation.productRec3();
        database.insert(dentplan);
        dentplan.name=DENTALPlan;
        database.update(dentplan);
         
        
         
        Product2 visnplan= ARV_AP05_TestDataCreation.productRec3();
        database.insert(visnplan);
        visnplan.name=VISIONPlan;
        database.update(visnplan);
         vlocity_ins__ContractLineItem__c mplan =ARV_AP05_TestDataCreation.planRec(medlprd.id,cntrct.id );
         database.insert(mplan);
         vlocity_ins__ContractLineItem__c dplan =ARV_AP05_TestDataCreation.planRec(dentplan.id,cntrct.id );
         database.insert(dplan);
         vlocity_ins__ContractLineItem__c vplan =ARV_AP05_TestDataCreation.planRec(visnplan.id,cntrct.id );
         database.insert(vplan);
        Package__C pack1=new Package__C(Name =PACKAGE1,ARV_Contract_Id__c=cntrct.id,ARV_Medical_Plan__c=mplan.id,
                                        ARV_Vision_Plan__c=dplan.id,
                                        ARV_Dental_Plan__c=vplan.id
                                        );
        database.insert(pack1);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME2;
        usr.Username=USERNAME;
        database.insert(usr,true); 
    }
    @istest
     static void testpackcreat1() 
    {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object>  Pack= new Map<String,Object>();
        Map<String,Object>  ProdSelection= new Map<String,Object>();
        String cntrctId=String.valueOf([select id from Contract where name=:CntrctName limit 1].id);
        inputMap.put('contractId',cntrctId);
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){    
            ARV_AP_UpdatePlanPackgaeComb packcreate1 = new ARV_AP_UpdatePlanPackgaeComb();
         try{       
                system.test.startTest();
                packcreate1.invokemethod(METHODNAME1,inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){
            }
        }
    }
}