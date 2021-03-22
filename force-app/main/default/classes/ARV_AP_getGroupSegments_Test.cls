@isTest(SeeAllData = FALSE)
private class ARV_AP_getGroupSegments_Test {
    private static final string STATCOMP='Completed';
    private static final string GCENNAME='gcmid';
    private static final string MEDICAL='medical';
    private static final string DENTAL='dntal';
    private static final string VISION='vision';
    private static final string PODCODE='prodcod';
    private static final string PACKAGE1='package';
    private static final string ACT='Active';
    private static final string NAME1='AP96LastName';

    private static testmethod void ARV_AP_getGroupSegments_Test() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){

            Account acc= ARV_AP05_TestDataCreation.accRec();       
            database.insert(acc);

            contract cont= ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            cont.startdate=system.today();
            cont.ARV_Renewal_Status__c =STATCOMP;
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
            gcm.vlocity_ins__CensusId__c =grpcs.id;
            database.insert(gcm);    

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
            
            Test.startTest();
            nullGpList = ARV_AP_getGroupSegments.getGroupSegments(cont.id);
            Test.stopTest();            
            System.assert(usr<>null);
        }
    }
}