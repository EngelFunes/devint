/*********************************************************************************************************
@Description: ARV_AP_UpdateGroupCensusMembers_Test() class
@Name : ARV_AP_UpdateGroupCensusMembers_Test
@Param :  N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
@isTest(SeeAllData=false)
public class ARV_AP_UpdateGroupCensusMembers_Test {
    private static final string PROFILENAME1='System Administrator';
    private static final string IDS = 'id';
    private static final string PROFILENAME2='Small Group Underwriter';
    private static final string NAME='First';
    private static final string NAME1='Second';    
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string CENSUSTYPE='System';
    private static final string CENSUSTYPE1='Quote_Enrollement';
    private static final string ACT='Active';
    private static final string SGRR='SG';
    private static final string  MEMID='1233';
    public static final string CENSUSID='censusId';
    public static final string MTHD_UPDATEGCM='updateCensusMembers';
    private static final String CREATESYSTEMCENSUS='createSystemCensus';
    Private Static Final String ENRLMNTCONID='ContractId';
    private static final String  ENROLLMENTCENSUSID ='enrollmentCensusId';
    private static final String  CONTRACTID1='contractId';

    /*********************************************************************************************************
@Description: testDataSetup() method 
@Name : testDataSetup1
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    @testSetup static void testDataSetup() { 
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
        Account acc= ARV_AP05_TestDataCreation.accRec();
        database.insert(acc);
        vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(acc.Id);
        census.Name=NAME;
        census.vlocity_ins__CensusType__c='GWC';
        database.insert(census);
        Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        con.vlocity_ins__EnrollmentCensusId__c=census.Id;
        database.insert(con);
        vlocity_ins__GroupCensusMember__c censusMem=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        censusMem.vlocity_ins__MemberIdentifier__c=MEMID;
        censusMem.vlocity_ins__CensusId__c=census.Id;
        censusMem.ARV_External_Id__c='2';
        censusMem.BNF_PKG_PLAN_PID__c='2';
        database.insert(censusMem);
    }
    /**************  
Method name : contractDataTest
Params     : NA
Return Type : testmethod
Description :  internalUserTest() method 
*************/ 
    private static testmethod void contractDataTest(){
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){
     
            map<string,object> inputMap = new map<string,object>();       
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            vlocity_ins__GroupCensus__c census=[select id,vlocity_ins__CensusType__c from vlocity_ins__GroupCensus__c Where Name=:NAME];
            options.put(CENSUSID,census.Id);
            vlocity_ins__GroupCensusMember__c gcmp=[Select id from vlocity_ins__GroupCensusMember__c limit 1];
                   test.startTest();
            ARV_AP_UpdateGroupCensusMembers upcm=new ARV_AP_UpdateGroupCensusMembers();
            ARV_AP_UpdateGroupCensusMembers.invokeMethod(MTHD_UPDATEGCM,inputMap,outMap,options);
            system.assert(census.Id!=null);
            test.stopTest();
            
        }
    }
       
   
           
    }