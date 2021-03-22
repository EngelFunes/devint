/*****************************************************************************************
Class Name   : ARV_AP88_GroupSegmentPackagecrt_Test 
Date Created : 17-Aug-2020
Created By   : IDC Offshore
Description  : This class is used for validate contract records
******************************************************************************************/
@isTest(SeeAllData=false)
public class ARV_AP88_GroupSegmentPackagecrt_Test {
    private static final string NAME='AP18LastName';
    private static final string PROFILENAME='System Administrator';
    private static final String  PACKAGETYPE='Group Segment Package';
    private static final String  PACKAGETYPE1='New Business Enrollment Package';
    private static Id devRecordTypeId = Schema.SObjectType.Package__c.getRecordTypeInfosByName().get(PACKAGETYPE).getRecordTypeId();
    private static Id devRecordTypeId1 = Schema.SObjectType.Package__c.getRecordTypeInfosByName().get(PACKAGETYPE1).getRecordTypeId();
    private static final String SEPERATEDVAL='-';
    private static final String PEDIATRICDENTAL='ARV_Pediatric_Dental_Plan__c';
    private static final String PCKNAME='Package1';
    private static final string GSNAME='GS-00008717';
    private static final string ACCOUNTAGENCY='Account - Agency';
    /************************************************* 
Method name : testDataSetup1
Params     : NA
Return Type : testmethod
Description :  testDataSetup1() method 
**************************************************/ 
    @testsetup static void testDataSetup1() { 
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        database.insert(usr,true);        
        Account accnt=ARV_AP05_TestDataCreation.AccRec();
        accnt.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACCOUNTAGENCY).getRecordTypeId();
        database.insert(accnt);
        Contract con = ARV_AP05_TestDataCreation.createContractRec(accnt.Id);
        database.insert(con);
        Package__c pck=ARV_AP05_TestDataCreation.packageRec(con.Id);
        pck.Name=PCKNAME;
        pck.RecordTypeId=devRecordTypeId1;
        database.insert(pck);
        LocationPackage__c lck=ARV_AP05_TestDataCreation.locpkgRec(con.Id);
        database.insert(lck);
        Package_Location_Segment_Rel__c plsr=ARV_AP05_TestDataCreation.pkglocsgmrelRec(pck.Id, lck.Id);
        plsr.Contract__c=con.Id;
        database.insert(plsr);
        GA_Group_Segment__c gsp= ARV_AP05_TestDataCreation.groupSegmentRec(accnt.Id,con.Id);
        gsp.Name=GSNAME;
        gsp.ARVPackage_Location_Segment_Relationship__c=plsr.Id;
        database.insert(gsp);
        vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(accnt.Id);
        database.insert(census);
        vlocity_ins__GroupCensusMember__c censusMem=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        censusMem.ARV_Group_Segment__c=gsp.Id;
        censusMem.ARV_Package__c=pck.Id;
        database.insert(censusMem);
        
        
        
    }
    /**************  
Method name : getContractCreation
Params     : NA
Return Type : testmethod
Description :  getContractCreation() method 
*************/
    private static testmethod void getGrpSegCreation()
    {
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            contract cont1=[select id from contract LIMIT 1];
            set<id> contId1=new set<id>();
            list<Contract> contractList1=new List<Contract>();
            contId1.add(cont1.id);
            GA_Group_Segment__c gsRec=[Select id,name,ARV_ContractID__c,ARVPackage_Location_Segment_Relationship__c from GA_Group_Segment__c LIMIT 1];
            list<GA_Group_Segment__c> gsList=new list<GA_Group_Segment__c>();
            Map<Id,String> gsNameWithPck=new Map<Id,String>();
            gsNameWithPck.put(gsRec.Id, gsRec.Name); 
            gsList.add(gsRec);
            Package_Location_Segment_Rel__c plsr=[Select id,Name,Package__c from Package_Location_Segment_Rel__c LIMIT 1 ];
            Map<Id,Id> plsrMap=new Map<Id,Id>();
            plsrMap.put(plsr.Id,plsr.Package__c);
            Map<Id,Package__c> pckgRec=new Map<Id,Package__c>();
            Package__c pck = [Select id,name from Package__c LIMIT 1];
            pckgRec.put(pck.Id,Pck);
            List<Package__c> pckList1 = new List<Package__c>();
            pckList1.add(pck);
            Package__c pckg=new package__C();
            pckg.Name=pckgRec.get(plsrMap.get(gsRec.ARVPackage_Location_Segment_Relationship__c)).Name+'-'+gsRec.Name;
            pckg.ARV_Contract_Id__c=cont1.Id;
            pck.RecordTypeId=devRecordTypeId;
            database.insert(pckg);
            test.startTest();
            ARV_AP88_GroupSegmentPackageCreation.groupSegmentRec(gsList); 
            test.stopTest();
            system.assert(pckg!=null);
        }
        
    } 
    /**************  
Method name : getContractCreation
Params     : NA
Return Type : testmethod
Description :  getContractCreation1() method 
*************/
    private static testmethod void getGrpSegCreation1()
    {
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            contract cont1=[select id from contract LIMIT 1];
            set<id> contId1=new set<id>();
            list<Contract> contractList1=new List<Contract>();
            contId1.add(cont1.id);
            GA_Group_Segment__c gsRec=[Select id,name,ARV_ContractID__c,ARVPackage_Location_Segment_Relationship__c from GA_Group_Segment__c LIMIT 1];
            list<GA_Group_Segment__c> gsList=new list<GA_Group_Segment__c>();
            Map<Id,String> gsNameWithPck=new Map<Id,String>();
            gsNameWithPck.put(gsRec.Id, gsRec.Name); 
            gsList.add(gsRec);
            Package_Location_Segment_Rel__c plsr=[Select id,Name,Package__c from Package_Location_Segment_Rel__c  LIMIT 1];
            Map<Id,Id> plsrMap=new Map<Id,Id>();
            plsrMap.put(plsr.Id,plsr.Package__c);
            Map<Id,Package__c> pckgRec=new Map<Id,Package__c>();
            Package__c pck = [Select id,name from Package__c LIMIt 1];
            pckgRec.put(pck.Id,Pck);
            List<Package__c> pckList1 = new List<Package__c>();
            pckList1.add(pck);
            Package__c pckg=new package__C();
            pckg.Name=pckgRec.get(plsrMap.get(gsRec.ARVPackage_Location_Segment_Relationship__c)).Name+'-'+gsRec.Name;
            pckg.ARV_Contract_Id__c=cont1.Id;
            pck.RecordTypeId=devRecordTypeId;
            database.insert(pckg);
            gsRec.ARV_Package__c=pck.Id;
            database.update(gsRec);
            set<Id> cenId=new set<id>();
            vlocity_ins__GroupCensus__c census=[Select id from vlocity_ins__GroupCensus__c Limit 1];
            cenId.add(census.Id);
            vlocity_ins__GroupCensusMember__c gcmp=[Select id from vlocity_ins__GroupCensusMember__c Limit 1];
            gcmp.ARV_Package__c=pck.Id;
            database.update(gcmp);
            List<vlocity_ins__GroupCensusMember__c> gcmpList = new List<vlocity_ins__GroupCensusMember__c>();
            gcmpList.add(gcmp);
            list<vlocity_ins__GroupCensusMemberPlan__c> gcmplList=new list<vlocity_ins__GroupCensusMemberPlan__c>();
            vlocity_ins__GroupCensusMemberPlan__c gcmpl=new vlocity_ins__GroupCensusMemberPlan__c();
            gcmpl.PackageId__c=pck.Id;
            gcmpl.vlocity_ins__GroupCensusMemberId__c=gcmp.Id;
            database.insert(gcmpl);
            gcmplList.add(gcmpl);
            cont1.vlocity_ins__EnrollmentCensusId__c=census.Id;
            database.update(cont1);
            test.startTest();
            ARV_AP88_GroupSegmentPackageCreation.updateMembersandGcmpPlans(cenId);
            ARV_AP88_GroupSegmentPackageCreation.createSystemCensus(cont1);
            test.stopTest();
            system.assert(cont1!=null);
        }
        
    } 
    
}