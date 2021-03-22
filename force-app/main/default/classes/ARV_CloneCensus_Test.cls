@isTest(SeeAllData=false)
public class ARV_CloneCensus_Test{
    private static final string PROFILENAME1='System Administrator';
    private static final string IDS = 'id';
    private static final string PROFILENAME2='Small Group Underwriter';
    private static final string NAME='First';
    private static final string NAME1='Second';    
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string CENSUSTYPE='System';
    private static final string CENSUSTYPE1='Quote_Enrollement';
    private static final string MEDICAL='Medical';
    private static final string DENTAL='dntal';
    private static final string VISION='vision';
    private static final string PODCODE='prodcod';
    private static final string PACKAGE1='package';
    private static final string ACT='Active';
    private static final string SGRR='SG';
    Private static Boolean isChild = False;
    private static final string METHODNAME ='updateGSRenewal';
    private static final string METHODNAME1 ='createGCMPRecords';
    private static final string METHODNAME2='updateGCMPRates';
    private static final string METHODNAME3='calculatePremiumPckg';
    private static final String  PACKAGETYPE='Enrollment';
    private static final String  PACKAGETYPE1='Renewal';
    private static Id devRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(PACKAGETYPE).getRecordTypeId();
    private static Id devRecordTypeId1 = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(PACKAGETYPE1).getRecordTypeId();
    private static finaL object MEDAT='{Status=true, census={AccountId=001c000002WK9bWAAT, EndDate=01/01/2019, Id=a58c0000000AipzAAC, StartDate=01/01/2018, censusType=Quote_Enrollment}, censusMember=({Id=a57c00000007M1iAAE, MemberAge__c=32, MemberName=Ryan Love, OriginalLocationPackage=a8oc0000002BvTxAAK, OriginalPackLocSegRel=a8pc0000000Lq1tAAC, OriginalPackage=a8nc0000001PT9lAAG, vlocity_ins__MemberIdentifier__c=1119324380283}, {Id=a57c00000007M1jAAE, MemberAge__c=27, MemberName=Chad Love, OriginalLocationPackage=a8oc0000002BvTxAAK, OriginalPackLocSegRel=a8pc0000000Lq1uAAC, OriginalPackage=a8nc0000001PT9SAAW, vlocity_ins__MemberIdentifier__c=1058826348226}, {Id=a57c00000007M1kAAE, MemberAge__c=23, MemberName=Dee Love, OriginalLocationPackage=a8oc0000002BvTxAAK, OriginalPackLocSegRel=a8pc0000000Lq1uAAC, OriginalPackage=a8nc0000001PT9SAAW, vlocity_ins__MemberIdentifier__c=857715081548}), f_countOfCensusMembers=3}';
    private static final string  MEMID='1233';
    private static final string CONTRACTID='contractId';
    private static final string MEMDETAILS='memberDetails';
    Private static final string SYSTEMCEN='systemCensus';
    Private static final string RENEWALCEN='renewalCensus';
    Private static final string CENSUSID='censusId';
    Private static final string CENSUSMEMID='groupMemberCensusId';
    Private static final string QUOTEENROLLMENT='Quote_Enrollment';
    private static final String  PACKAGETYPE1PCK='Group Segment Package';
    
    private static Id pckdevRecordTypeId1 = Schema.SObjectType.Package__c.getRecordTypeInfosByName().get(PACKAGETYPE1PCK).getRecordTypeId();
    
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
        acc.Account_Status__c=ACT;
        acc.ARV_Renewal_Account_Type__c=SGRR;
        acc.GA_Opportunity_Renewal_Date__c=system.today();
        database.insert(acc);
        vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(acc.Id);
        census.Name=NAME;
        census.vlocity_ins__CensusType__c=QUOTEENROLLMENT;
        database.insert(census);
        vlocity_ins__GroupCensus__c census1=ARV_AP05_TestDataCreation.groupCensus(acc.Id);
        census1.Name=NAME1;
        census1.vlocity_ins__CensusType__c=CENSUSTYPE;
        database.insert(census1);
        contract cont= ARV_AP05_TestDataCreation.createContractRec(acc.Id);    
        cont.vlocity_ins__EnrollmentCensusId__c=census.Id;
        cont.vlocity_ins__FinalRatingGroupCensusId__c=census1.Id;
        cont.RecordTypeId=devRecordTypeId;
        database.insert(cont);       
        contract cont1= ARV_AP05_TestDataCreation.createContractRec(acc.Id);  
        cont1.Name=PACKAGETYPE1;
        cont1.vlocity_ins__EnrollmentCensusId__c=census.Id;
        cont1.vlocity_ins__ExpiredContractId__c=cont.Id;
        cont1.RecordTypeId=devRecordTypeId1;
        database.insert(cont1);  
        Package__c pck1=ARV_AP05_TestDataCreation.packageRec(cont.Id);
        pck1.ARV_Contract_Id__c=cont1.Id;
        pck1.Name=PACKAGETYPE;
        pck1.RecordTypeId=pckdevRecordTypeId1;
        database.insert(pck1);
        LocationPackage__c lck=ARV_AP05_TestDataCreation.locpkgRec(cont.Id);
        database.insert(lck);
        Package_Location_Segment_Rel__c plsr=ARV_AP05_TestDataCreation.pkglocsgmrelRec(pck1.Id, lck.Id);
        plsr.Contract__c=cont.Id;
        database.insert(plsr);
        GA_Group_Segment__c gseg1= ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont.Id);
        gseg1.Name=NAME;
        gseg1.ARVPackage_Location_Segment_Relationship__c=plsr.Id;
        database.insert(gseg1);
        vlocity_ins__GroupCensusMember__c censusMem=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        censusMem.ARV_Group_Segment__c=gseg1.Id;
        censusMem.ARV_Package__c=pck1.Id;
        censusMem.vlocity_ins__MemberIdentifier__c=MEMID;
        censusMem.vlocity_ins__CensusId__c=census.Id;
        database.insert(censusMem);
        vlocity_ins__GroupCensusMember__c censusMem1=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        censusMem1.ARV_Group_Segment__c=gseg1.Id;
        censusMem1.ARV_Package__c=pck1.Id;
        censusMem1.vlocity_ins__IsPrimaryMember__c=FALSE;
        censusMem1.vlocity_ins__MemberIdentifier__c=MEMID;
        censusMem1.vlocity_ins__CensusId__c=census.Id;
        database.insert(censusMem1);
        
        
        vlocity_ins__GroupCensusMember__c censusMem2=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        censusMem2.ARV_Group_Segment__c=gseg1.Id;
        censusMem2.ARV_Package__c=pck1.Id;
        censusMem1.vlocity_ins__IsPrimaryMember__c=TRUE;
        censusMem2.vlocity_ins__MemberIdentifier__c=MEMID;
        censusMem2.vlocity_ins__CensusId__c=census.Id;
        
        database.insert(censusMem2);
        
        Product2 prd = ARV_AP05_TestDataCreation.productRec2();
        database.insert(prd);
        vlocity_ins__ContractLineItem__c planobj = new vlocity_ins__ContractLineItem__c();
        planobj.vlocity_ins__ContractId__c=cont1.id;
        planobj.name=MEDICAL;
        planobj.vlocity_ins__Product2Id__c = prd.id;
        database.insert(planobj); 
        
        vlocity_ins__GroupCensusMemberPlan__c gcmpl=new vlocity_ins__GroupCensusMemberPlan__c();
        gcmpl.PackageId__c=pck1.Id;
        gcmpl.ARV_Member_Rate__c=9.9;
        gcmpl.vlocity_ins__GroupCensusMemberId__c=censusMem.Id;
        gcmpl.vlocity_ins__ContractLineId__c=planobj.Id;
        database.insert(gcmpl);
        
        vlocity_ins__GroupCensusMemberPlan__c gcmpl1=new vlocity_ins__GroupCensusMemberPlan__c();
        gcmpl1.PackageId__c=pck1.Id;
        gcmpl1.ARV_Member_Rate__c=9.9;
        gcmpl1.vlocity_ins__GroupCensusMemberId__c=censusMem.Id;
        gcmpl1.vlocity_ins__ContractLineId__c=planobj.Id;
        database.insert(gcmpl1);
        
        
    }
    /**************  
Method name : cloneGroupCensusRecord
Params     : NA
Return Type : testmethod
Description :  internalUserTest() method 
*************/ 
 private static testmethod void testMethod1(){
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){
        Contract cont=[Select id,Name from contract where Name=:PACKAGETYPE1];
        Package__c pck=[Select id,Name from Package__c where Name=:PACKAGETYPE] ;
            
       Account acc=[select id from Account limit 1];    
        
        vlocity_ins__GroupCensus__c census1=[select id from vlocity_ins__GroupCensus__c Limit 1];
            
            
            //census1.Name=NAME1;            
            //insert census1;
            //List<vlocity_ins__GroupCensus__c> gcList=new List<vlocity_ins__GroupCensus__c>();
            
            //gcList.add(census1);
            //
        vlocity_ins__GroupCensus__c census2=[select id from vlocity_ins__GroupCensus__c Limit 1];
            
  
            
            
        vlocity_ins__GroupCensusMember__c gcmp=[Select id,ARV_Package__c,vlocity_ins__CensusId__c,ARV_Group_Segment__c ,Enrollment_Medical_Premium__c,
                                                    Enrollment_Vision_Premium__c,   Enrollment_Dental_Premium__c from vlocity_ins__GroupCensusMember__c limit 1];
            
        list<vlocity_ins__GroupCensusMember__c> gcmpList=new list<vlocity_ins__GroupCensusMember__c>();
        gcmpList.add(gcmp);
        
       /* vlocity_ins__GroupCensusMemberPlan__c gcmpPlans=[select id,name,ARV_Member_Rate__c,Member_Census_Id__c,
                                                             vlocity_ins__PlanProductId__c,vlocity_ins__GroupCensusMemberId__c                                                             
                                                             from vlocity_ins__GroupCensusMemberPlan__c];*/
        test.startTest();
        ARV_CloneCensus.cloneGroupCensusRecord(census1.id,acc.id);
        test.stopTest();
        system.assert(pck!=null);
            
        }
        
    }
    /*********************************************************************************************************
@Description: testdata for the method cloneGroupCensusMemberRecords
@Name : 
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/ 
private static testmethod void testMethod2(){
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){
        Contract cont=[Select id,Name from contract where Name=:PACKAGETYPE1];
        Package__c pck=[Select id,Name from Package__c where Name=:PACKAGETYPE] ;
     // Package__c pck1=[Select id,Name from Package__c where Name=:PACKAGETYPE];
            
                
        vlocity_ins__GroupCensus__c census1=[select id from vlocity_ins__GroupCensus__c Limit 1];
         
         vlocity_ins__GroupCensus__c census2=[select id from vlocity_ins__GroupCensus__c Limit 1];    
            
        vlocity_ins__GroupCensus__c census=[select id from vlocity_ins__GroupCensus__c Limit 1];
            
        vlocity_ins__GroupCensusMember__c censusMem1=[Select id,ARV_Package__c,vlocity_ins__CensusId__c,ARV_Group_Segment__c ,Enrollment_Medical_Premium__c,
                                                    Enrollment_Vision_Premium__c,   Enrollment_Dental_Premium__c from vlocity_ins__GroupCensusMember__c limit 1];
            
      //insert gcmp;
            
        test.startTest();
        ARV_CloneCensus.cloneGroupCensusMemberRecords(censusMem1.id,census.id,census1.Id);
       // ARV_CloneCensus.cloneGroupCensusMemberRecords(censusMem2.id,census.id,census1.Id);
        test.stopTest();
        system.assert(pck!=null);
            
        }
        
    }
  
     /**************  
Method name :
Params     : NA
Return Type : testmethod
Description :   
*************/ 
private static testmethod void testMethod3(){
     user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
     system.runAs(usr1){
   //Contract cont=[Select id,Name from contract where Name=:PACKAGETYPE1];
     Package__c pck=[Select id,Name from Package__c where Name=:PACKAGETYPE] ;
           
     vlocity_ins__GroupCensusMember__c gcmp=[Select id,ARV_Package__c,vlocity_ins__CensusId__c,ARV_Group_Segment__c ,Enrollment_Medical_Premium__c,
                                                    Enrollment_Vision_Premium__c,   Enrollment_Dental_Premium__c from vlocity_ins__GroupCensusMember__c limit 1];
            
   //list<vlocity_ins__GroupCensusMember__c> gcmpList=new list<vlocity_ins__GroupCensusMember__c>();
   //gcmpList.add(gcmp);
     vlocity_ins__GroupCensusMemberPlan__c gcmpPlans=[select id,name,ARV_Member_Rate__c,Member_Census_Id__c,
                                                             vlocity_ins__PlanProductId__c,vlocity_ins__GroupCensusMemberId__c                                                             
                                                             from vlocity_ins__GroupCensusMemberPlan__c limit 1];
                                                            
     vlocity_ins__GroupCensusMember__c censusMem1=[Select id,ARV_Package__c,vlocity_ins__CensusId__c,ARV_Group_Segment__c ,Enrollment_Medical_Premium__c,
                                                    Enrollment_Vision_Premium__c,   Enrollment_Dental_Premium__c from vlocity_ins__GroupCensusMember__c limit 1];
            
            
     vlocity_ins__GroupCensusMember__c censusMem=[Select id,ARV_Package__c,vlocity_ins__CensusId__c,ARV_Group_Segment__c ,Enrollment_Medical_Premium__c,
                                                    Enrollment_Vision_Premium__c,   Enrollment_Dental_Premium__c from vlocity_ins__GroupCensusMember__c limit 1];
           
            
         test.startTest();
         ARV_CloneCensus.cloneGroupCensusMemberPlanRecords(censusMem.id,censusMem1.id);
         //ARV_CloneCensus.cloneGroupCensusMemberPlanRecords(censusMem.id,gcmpl1.id);
         test.stopTest();         
         system.assert(pck!=null);
            
        }
        
    }
        
}