/*****************************************************************************************
Class Name   : ARV_AP87_ContractTriggerHandler_Test 
Date Created : 17-Jan-2020
Created By   : IDC Offshore
Description  : This class is used for validate contract records
******************************************************************************************/
@isTest(SeeAllData=false)
public class ARV_AP87_ContractTriggerHandler_Test {
    private static  string name12='admin';
    private static final string PROFILENAME1='System Administrator';
    private static final string IDS = 'id';
    private static final string PROFILENAME2='Small Group Underwriter';
    private static final string NAME='AP96LastName';
    private static final string NAME1='AP96LastName';    
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string GCENNAME='gcmid';
    private static final string MEDICAL='medical';
    private static final string DENTAL='dntal';
    private static final string VISION='vision';
    private static final string PODCODE='prodcod';
    private static final string PACKAGE1='package';
    private static final string ACT='Active';
    private static final string SGRR='SG';
    private static final String COMPLETED='Completed';
    private static final String ACTIVATED='Activated';    
    private static final string MANUALENROLLMENT='Manual Enrollment Setup - Complete';   
    private static final string STATFUTURE='Future';
    private static final string CONNAME='Renewal';
    private static final string STATCOMP='Completed';
    /*********************************************************************************************************
@Description: testDataSetup() method 
@Name : testDataSetup1
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    public ARV_AP87_ContractTriggerHandler_Test(){
        system.assertEquals(name12,'admin','assertion');
        name12='admin';      
    }
    
    @testSetup static void testDataSetup() { 
        Account acc= ARV_AP05_TestDataCreation.accRec();
        acc.Account_Status__c=ACT;
        acc.ARV_Renewal_Account_Type__c=SGRR;
        acc.GA_Opportunity_Renewal_Date__c=system.today();
        if(Account.SObjectType.getDescribe().isAccessible()){database.insert(acc); }
        contract cont= ARV_AP05_TestDataCreation.createContractRec(acc.Id);        
        if(contract.SObjectType.getDescribe().isAccessible()){database.insert(cont); }  
        Contract con21 = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        if(contract.SObjectType.getDescribe().isAccessible()){database.insert(con21);}
        con21.Name=STATFUTURE;
        con21.Status=STATFUTURE;
        if(contract.SObjectType.getDescribe().isAccessible()){database.update(con21); }      
        Package__c pck1=ARV_AP05_TestDataCreation.packageRec(cont.Id);
        if(Package__c.SObjectType.getDescribe().isAccessible()){database.insert(pck1);}
        Product2 prd = ARV_AP05_TestDataCreation.productRec2();
        if(Product2.SObjectType.getDescribe().isAccessible()){database.insert(prd);}
        vlocity_ins__ContractLineItem__c planobj = new vlocity_ins__ContractLineItem__c();
        planobj.vlocity_ins__ContractId__c=cont.id;
        planobj.name=MEDICAL;
        planobj.vlocity_ins__Product2Id__c = prd.id;
        if(vlocity_ins__ContractLineItem__c.SObjectType.getDescribe().isAccessible()){database.insert(planobj); }     
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        if(user.SObjectType.getDescribe().isAccessible()){database.insert(usr,true);}
        cont.status=ACTIVATED;
        cont.ARV_Renewal_Status__c=COMPLETED;
        cont.EndDate =system.today()-1;
        cont.Name=CONNAME;
        cont.vlocity_ins__ExpiredContractId__c=con21.Id;
        if(contract.SObjectType.getDescribe().isAccessible()){database.update(cont);}
    }
    /**************  
Method name : internalUserTest
Params     : NA
Return Type : testmethod
Description :  internalUserTest() method 
*************/ 
    private static testmethod void contractDataTest(){
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){
            Account acc= ARV_AP05_TestDataCreation.accRec();       
            database.insert(acc);
            contract cont= ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            cont.startdate=system.today();
            cont.ARV_Renewal_Status__c =STATCOMP;
            cont.RecordtypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
            database.insert(cont);
            Set<ID> setconids = new Set<ID>();
            setconids.add(cont.id);
            list<Contract> contractList=new list<Contract>();
            contractList.add(cont);
            map<id,Contract> contOldMap=new map<id,Contract>();  
            LocationPackage__c lck=ARV_AP05_TestDataCreation.locpkgRec(cont.Id);
            database.insert(lck);
            contOldMap.put(cont.Id,cont);           
            vlocity_ins__GroupCensus__c grpcs = new vlocity_ins__GroupCensus__c();
            grpcs.name = GCENNAME;
            grpcs.vlocity_ins__GroupId__c = acc.id;
            database.insert(grpcs);  
            vlocity_ins__GroupCensusMember__c gcm = new vlocity_ins__GroupCensusMember__c();
            gcm.name = GCENNAME;
            gcm.ARV_External_Id__c = '1234';
            gcm.BNF_PKG_PLAN_PID__c = '0101';
            gcm.ARV_Person_Id__c = 'p1';
            gcm.vlocity_ins__CensusId__c =grpcs.id;
            database.insert(gcm);
            system.debug('groupCensusMember'+gcm);
            Product2 prd = ARV_AP05_TestDataCreation.productRec2();
            prd.name=MEDICAL;
            prd.ProductCode=PODCODE;
            database.insert(prd);
            Product2 prd1 = ARV_AP05_TestDataCreation.productRec2();
            prd1.name=DENTAL;
            prd1.ProductCode=PODCODE;
            database.insert(prd1);           
            vlocity_ins__ContractLineItem__c planattr = new vlocity_ins__ContractLineItem__c();
            planattr.name=PODCODE;
            planattr.vlocity_ins__ContractId__c= cont.id;          
            planattr.vlocity_ins__Product2Id__c=prd.id;
            database.insert(planattr);
            Package__c pck1=ARV_AP05_TestDataCreation.packageRec(cont.Id);
            pck1.name = PACKAGE1;
            pck1.Medical_Product_Id__c=prd.id;
            pck1.Dental_Product_Id__c=prd1.id;
            pck1.Vision_Product_Id__c=prd1.id;
            database.insert(pck1);
            Package_Location_Segment_Rel__c plsr=ARV_AP05_TestDataCreation.pkglocsgmrelRec(pck1.Id, lck.Id);
            database.insert(plsr);
            Package__c activepck =ARV_AP05_TestDataCreation.packageRec(cont.Id);
            activepck.name = PACKAGE1;
            activepck.ARV_Medical_Plan__c = planattr.id;
            activepck.ARV_Dental_Plan__c= planattr.id;
            activepck.ARV_Vision_Plan__c = planattr.id;   
            activepck.Medical_Product_Id__c=prd.id;
            activepck.Dental_Product_Id__c=prd1.id;
            activepck.Vision_Product_Id__c=prd1.id;
            database.insert(activepck);
            Package__c pendpck =ARV_AP05_TestDataCreation.packageRec(cont.Id);
            pendpck.name = PACKAGE1;
            pendpck.ARV_Medical_Plan__c = planattr.id;
            pendpck.ARV_Dental_Plan__c= planattr.id;
            pendpck.ARV_Vision_Plan__c = planattr.id;
            pendpck.Medical_Product_Id__c=prd.id;
            pendpck.Dental_Product_Id__c=prd1.id;
            pendpck.Vision_Product_Id__c=prd1.id;
            database.insert(pendpck);
            vlocity_ins__GroupCensusMemberPlan__c cen = new vlocity_ins__GroupCensusMemberPlan__c();
            cen.vlocity_ins__GroupCensusMemberId__c = gcm.id;
            cen.ARV_Member_Rate__c=123;
            cen.name=PACKAGE1;
            cen.PackageId__c = pck1.id;
            cen.vlocity_ins__ContractLineId__c=  planattr.id;  
            database.insert(cen);          
            GA_Group_Segment__c gseg2= ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont.Id);
            gseg2.Status__c=ACT;
            gseg2.ARV_ContractID__c=cont.id;
            gseg2.ARV_Pending_ContractId__c=cont.id;
            gseg2.ARV_Package__c=activepck.id;
            gseg2.ARV_Pending_PackageId__c=pendpck.id;
            database.insert(gseg2);
            List<GA_Group_Segment__c> nullGpList = new List<GA_Group_Segment__c>();
            nullGpList.add(gseg2);          
            ARV_AP87_ContractTriggerHandler renpkg = new ARV_AP87_ContractTriggerHandler();
            test.startTest();
            ARV_AP87_ContractTriggerHandler.updateContractStaustoFuture(setconids);  
            ARV_AP87_ContractTriggerHandler.updateContractStatus(setconids);
            ARV_AP87_ContractTriggerHandler.updateGpRenewalContract(setconids);
            ARV_AP87_ContractTriggerHandler.updateContractStatusAfterGS(setconids);
            ARV_AP87_ContractTriggerHandler.updateStatusToCancelled(contractList,contOldMap);
            ARV_AP87_ContractTriggerHandler.aprGWCEmail(acc.name,acc.Id);
            ARV_AP87_ContractTriggerHandler.updateCensusMembers(cont.RecordTypeId,cont.vlocity_ins__EnrollmentCensusId__c,cont.vlocity_ins__FinalRatingGroupCensusId__c);
            test.stopTest();
            
            system.assertNotEquals(activepck,pendpck);
            
        }
        
    }
    
    
}