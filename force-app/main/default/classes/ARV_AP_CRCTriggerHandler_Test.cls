@isTest(seealldata=false)
public class ARV_AP_CRCTriggerHandler_Test {
    private static final String cntName = 'TestCnt';
    private static Boolean recursive=true;
    private static boolean boolval;
    private static final string PROFILENAME='System Administrator';
 private static final string NAME='AP61LastName';
     private static final string NAME1='AP96LastName';  
 private static final String USERNAME='bcbsm1@bcbsm.com';
    private static final string PROFILENAME1='System Administrator';

    private static final string ACT='Active';
        private static final string SGRR='SG';
 
    /************************************************* 
Method name : testDataSetup1
Params     : NA
Return Type : testmethod
Description :  testDataSetup1() method 
**************************************************/  
    @testSetup static void testDataSetup() { 
        Account acc= ARV_AP05_TestDataCreation.accRec();
        acc.Account_Status__c=ACT;
        acc.ARV_Renewal_Account_Type__c=SGRR;
        acc.GA_Opportunity_Renewal_Date__c=system.today();
        database.insert(acc);
        
        vlocity_ins__GroupCensus__c Census=ARV_AP05_TestDataCreation.groupCensus(acc.id);
        database.insert(Census);
        vlocity_ins__GroupCensusMember__c groupCensusMember=ARV_AP05_TestDataCreation.groupCensusMember(Census.Id);
        database.insert(groupCensusMember);
        
         contract expCont= ARV_AP05_TestDataCreation.createContractRec(acc.Id); 
        expCont.Base_Rate_Effective_Date__c=System.today();
        expCont.vlocity_ins__EnrollmentCensusId__c=Census.id;
        database.insert(ExpCont);      
        
        contract cont= ARV_AP05_TestDataCreation.createContractRec(acc.Id); 
        cont.Name=cntName;
        cont.StartDate=System.today();
        cont.vlocity_ins__ExpiredContractId__c=ExpCont.id;
        cont.vlocity_ins__EnrollmentCensusId__c=Census.id;
        cont.ARV_Requested_Effective_Date__c=System.today();
        cont.ARV_RatingArea__c='B';
        cont.ARV_CF_CNTRCT_CarrierCodes__c='BCBSM';
        cont.Base_Rate_Effective_Date__c=System.today();
        
        database.insert(cont);       
        
             
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
        Carrier_Rate_Comparison__c crcRec = new Carrier_Rate_Comparison__c();
        crcRec.Future_Contract__c = cont.id;
        database.insert(crcRec);
    }
 
    @isTest
    static void testCrcHandler() {
        id futContId=[select id from contract where name=:cntName limit 1].id;
        List<Carrier_Rate_Comparison__c> corcList=[Select id,Future_Contract__c from Carrier_Rate_Comparison__c 
                                                   where Future_Contract__c=:futContId limit 1 ];
        system.debug('corcList'+corcList);
        Contract con=[select id from contract where name=:cntName limit 1];
        Carrier_Rate_Comparison__c corc=[Select id,Future_Contract__c from Carrier_Rate_Comparison__c 
                                                   where Future_Contract__c=:futContId limit 1 ];
                system.debug('corc'+corc);
         user usr1  = [SELECT Id from User where LastName =:NAME1 limit 1];
        system.runAs(usr1){    
         try{       
                system.test.startTest();
                ARV_AP_CRCTriggerHandler.updateIPCoRCData(corcList);
             ARV_AP_CRCTriggerHandler.updateContract(corc,con);
                system.test.stoptest();
            }
            Catch(Exception e){    
            }
        }
    }

}