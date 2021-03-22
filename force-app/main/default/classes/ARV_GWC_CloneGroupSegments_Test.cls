@isTest
public with sharing class ARV_GWC_CloneGroupSegments_Test {
    
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
    private static final string METHODNAME ='updateGSRenewal';
    private static final string METHODNAME1 ='createGCMPRecords';
    private static final string METHODNAME2='updateGCMPRates';
    private static final string METHODNAME3='calculatePremiumPckg';
    private static final String PACKAGETYPE='Enrollment';
    private static final String PACKAGETYPE1='GWC';
    private static Id acRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
    private static Id devRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(PACKAGETYPE).getRecordTypeId();
    private static Id devRecordTypeId1 = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(PACKAGETYPE1).getRecordTypeId();
    private static finaL object MEDAT='{Status=true, census={AccountId=001c000002WK9bWAAT, EndDate=01/01/2019, Id=a58c0000000AipzAAC, StartDate=01/01/2018, censusType=Quote_Enrollment}, censusMember=({Id=a57c00000007M1iAAE, MemberAge__c=32, MemberName=Ryan Love, OriginalLocationPackage=a8oc0000002BvTxAAK, OriginalPackLocSegRel=a8pc0000000Lq1tAAC, OriginalPackage=a8nc0000001PT9lAAG, vlocity_ins__MemberIdentifier__c=1119324380283}, {Id=a57c00000007M1jAAE, MemberAge__c=27, MemberName=Chad Love, OriginalLocationPackage=a8oc0000002BvTxAAK, OriginalPackLocSegRel=a8pc0000000Lq1uAAC, OriginalPackage=a8nc0000001PT9SAAW, vlocity_ins__MemberIdentifier__c=1058826348226}, {Id=a57c00000007M1kAAE, MemberAge__c=23, MemberName=Dee Love, OriginalLocationPackage=a8oc0000002BvTxAAK, OriginalPackLocSegRel=a8pc0000000Lq1uAAC, OriginalPackage=a8nc0000001PT9SAAW, vlocity_ins__MemberIdentifier__c=857715081548}), f_countOfCensusMembers=3}';
    private static final string  MEMID='1233';
    private static final string CONTRACTID='contractId';
    private static final string MEMDETAILS='memberDetails';
    Private static final string SYSTEMCEN='systemCensus';
    Private static final string RENEWALCEN='renewalCensus';
    Private static final string CENSUSID='censusId';
    Private static final string STATUS ='Approved – Validate Data/Setup Group Segments';
    Private static final string QUOTEENROLLMENT='Quote_Enrollment';
    private static final String PACKAGETYPE1PCK='Group Segment Package';
    private static final string GCENNAME='gcmid';
    
    private static Id pckdevRecordTypeId1 = Schema.SObjectType.Package__c.getRecordTypeInfosByName().get(PACKAGETYPE1PCK).getRecordTypeId();

    public static testMethod void runTest(){
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);

        Account acc= ARV_AP05_TestDataCreation.accRec();
        acc.RecordTypeId = acRecordTypeId;
        acc.Account_Status__c=ACT;
        acc.ARV_Renewal_Account_Type__c=SGRR;
        acc.GA_Opportunity_Renewal_Date__c=system.today();
        database.insert(acc);

        vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(acc.Id);
        census.Name=NAME;
        census.vlocity_ins__CensusType__c= QUOTEENROLLMENT;
        database.insert(census);

        vlocity_ins__GroupCensus__c census1=ARV_AP05_TestDataCreation.groupCensus(acc.Id);
        census1.Name=NAME1;
        census1.vlocity_ins__CensusType__c=CENSUSTYPE;
        database.insert(census1);

        contract cont1= ARV_AP05_TestDataCreation.createContractRec(acc.Id); 
        cont1.Name=PACKAGETYPE1;
        cont1.Status = 'Draft';
        cont1.vlocity_ins__EnrollmentCensusId__c=census.Id;
        cont1.RecordTypeId=devRecordTypeId1;
        database.insert(cont1);  
        cont1.Status = 'Approved – Validate Data/Setup Group Segments';
        //cont1.ARV_Enrollment_Status__c = 'In Progress';
        
        List<GA_Group_Segment__c> gsslst=new List<GA_Group_Segment__c>();
        Map<string,string> gsMap=new Map<string,string>();
        List<GA_Group_Segment__c> gslist = new List<GA_Group_Segment__c>();
        List<Package__c> packglst= new List<Package__c>();
        update cont1;

        Package__c pck1=ARV_AP05_TestDataCreation.packageRec(cont1.Id);
        pck1.ARV_Contract_Id__c=cont1.Id;
        pck1.Name=PACKAGETYPE;
        pck1.ARV_GWC_Benefit_Package_Type__c = 'Modify Benefit Package';
        pck1.RecordTypeId=pckdevRecordTypeId1;
        pck1.ARV_GWC_Package_Change_Attributes__c = '{"BCN HSA Member Option:":null,"New Medical Product Code:":"98185MI0170009","Old Medical Product Code:":null,"New Vision Product Code:":"15560MIV000003","Old Vision Product Code:":"15560MIV000003","New Dental Product Code:":"15560MI0430001","Old Dental Product Code:":"15560MI0430001","HBA Level:":null,"Old Vision Plan:":"Blue Vision℠ 12/12/12","New Vision Plan:":"Blue Vision℠ 12/12/12","Old Dental Plan:":"Blue Dental PPO Plus℠ 100/80/50/50 SG","New Dental Plan:":"Blue Dental PPO Plus℠ 100/80/50/50 SG","Old Medical Plan:":"BCN Healthy Blue Living℠ HMO Gold $1500","New Medical Plan:":"BCN Healthy Blue Living℠ HMO Gold $1500","New CDH Package Combination:":"","Old CDH Package Combination:":"NA","New Product Family:":"Healthy Blue Living","Old Product Family:":"Healthy Blue Living","New Vision Type:":"Non-Voluntary","Old Vision Type:":"Non-Voluntary","New Dental Type:":"Non-Voluntary","Old Dental Type:":"Non-Voluntary","New Carrier:":"BCN","Old Carrier:":"BCN"}';
        database.insert(pck1);

        LocationPackage__c lck=ARV_AP05_TestDataCreation.locpkgRec(cont1.Id);
        database.insert(lck);

        Package_Location_Segment_Rel__c plsr=ARV_AP05_TestDataCreation.pkglocsgmrelRec(pck1.Id, lck.Id);
        plsr.Contract__c=cont1.Id;
        database.insert(plsr);

        GA_Group_Segment__c gseg1= ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont1.Id);
        gseg1.Name=NAME;
        gseg1.ARVPackage_Location_Segment_Relationship__c=plsr.Id;
        database.insert(gseg1);

        pck1.ARV_Tech_GWC_Legacy_Id__c = gseg1.Name;
        pck1.ARV_Tech_GWC_Legacy_Id__c = 'GS-00099478';
        pck1.ARV_GWC_Package_Change_Attributes__c = '{"BCN HSA Member Option:":null,"New Medical Product Code:":"98185MI0170009","Old Medical Product Code:":null,"New Vision Product Code:":"15560MIV000003","Old Vision Product Code:":"15560MIV000003","New Dental Product Code:":"15560MI0430001","Old Dental Product Code:":"15560MI0430001","HBA Level:":null,"Old Vision Plan:":"Blue Vision℠ 12/12/12","New Vision Plan:":"Blue Vision℠ 12/12/12","Old Dental Plan:":"Blue Dental PPO Plus℠ 100/80/50/50 SG","New Dental Plan:":"Blue Dental PPO Plus℠ 100/80/50/50 SG","Old Medical Plan:":"BCN Healthy Blue Living℠ HMO Gold $1500","New Medical Plan:":"BCN Healthy Blue Living℠ HMO Gold $1500","New CDH Package Combination:":"","Old CDH Package Combination:":"NA","New Product Family:":"Healthy Blue Living","Old Product Family:":"Healthy Blue Living","New Vision Type:":"Non-Voluntary","Old Vision Type:":"Non-Voluntary","New Dental Type:":"Non-Voluntary","Old Dental Type:":"Non-Voluntary","New Carrier:":"BCN","Old Carrier:":"BCBS"}';
        database.update(pck1);
        
        vlocity_ins__GroupCensusMember__c censusMem=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        censusMem.ARV_Group_Segment__c=gseg1.Id;
        censusMem.ARV_Package__c=pck1.Id;
        censusMem.vlocity_ins__MemberIdentifier__c=MEMID;
        censusMem.vlocity_ins__CensusId__c=census.Id;
        database.insert(censusMem);

        vlocity_ins__GroupCensusMember__c censusMem1=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        censusMem1.ARV_Group_Segment__c=gseg1.Id;
        censusMem1.ARV_Package__c=pck1.Id;
        censusMem1.vlocity_ins__MemberIdentifier__c=MEMID;
        censusMem1.vlocity_ins__CensusId__c=census.Id;
        database.insert(censusMem1);

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

        GA_Group_Association__c assoc = new GA_Group_Association__c();
        assoc.GA_Group_Segment__c = gseg1.Id;
        assoc.GA_Account__c = acc.Id;
        assoc.GA_Start_Date__c = Date.today();
        assoc.GA_End_Date__c = Date.today();
        assoc.ARV_Is_Mass_Updating__c = true;
        assoc.GA_Is_Processed__c = true;
        database.insert(assoc);

        String gsid = gseg1.Id;
		//String clonedGSId = ARV_GWC_CloneGroupSegments.cloneGroupSegmentRecord.grpsgmnt.Id;
		
        
        System.runAs(usr){
            Test.startTest();
            ARV_GWC_CloneGroupSegments.cloneGroupSegmentRecord(cont1.Id);
            ARV_GWC_CloneGroupSegments.cloneGSRecord(gsid,cont1,pck1);
            ARV_GWC_CloneGroupSegments.updateAccount(cont1, acc.Id);
            //ARV_GWC_CloneGroupSegments.updateCensusMem(cont1.Id);
            ARV_GWC_CloneGroupSegments.cloneAORRecords(gsid,cont1.Id,gsid);
            ARV_GWC_CloneGroupSegments.cloneASSOCRecords(assoc.Id,cont1.Id,gsid);
            Test.stopTest();
        }
    } 
}