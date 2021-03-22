public without sharing class ARV_AP59_GrpSegTestDataCreation {
    public static Product2 createProduct(){
        Product2 prod = new Product2();
        prod.Name='TestProduct';
        prod.RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.Carrier_Type__c= 'BCBSM';
        prod.Voluntary_Contributory__c = 'Voluntary';
        //prod.Voluntary_Contributory__c = 'Non-Voluntary';
        prod.Family = 'Medical';
        return prod;
    }
    
    public static Contract createContract(){
        Contract cont1=new Contract();
            //cont1.AccountId=testAccount.id;
            cont1.StartDate=system.today();
            cont1.Status='In Progress';
            cont1.ContractTerm=10;
            cont1.ARV_Fed_Tax_ID__c = '789456123';
            cont1.ARV_Requested_Effective_Date__c = system.today();
            cont1.ARV_Requested_Renewal_Month__c = 'March';
        	//cont1.ARV_Managing_Agent__c = managingAgency.Id;
            cont1.ARV_Mail_ID_Cards_to__c = 'Member' ; 
            //cont1.ARV_Leasing_Company_Acronym__c = testAccount.id ;
            cont1.ARV_Retiree_Surviving_Spouse_Option__c = 'No' ;
            //cont1.ARV_Previous_Carrier__c = prevCareer.Id;
            //cont1.vlocity_ins__ProducerId__c = testContact.Id;
            //cont1.ARV_Sponsored_Plan_Acronym__c = gaAccount.id;
            return cont1;
    }
    
    public static vlocity_ins__ContractLineItem__c createPlan(Id prodID, Id contractID){
        vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
            plan.Name = 'TestPlan';
            plan.vlocity_ins__Product2Id__c = prodId;
            plan.vlocity_ins__ContractId__c = contractId;
        return plan;
    }
    
    public static GA_City_Code__c createCity(){
        GA_City_Code__c city = new GA_City_Code__c();
            city.Name = 'TestCity';
            return city;
    }
    
    public static GA_County_Code__c createCounty(){
        GA_County_Code__c county = new GA_County_Code__c();
            county.Name= 'TestCounty';
        return county;
    }
    
    public static LocationPackage__c createLocationPackage(id acctId, id contId, id cityId, id countyId){
        LocationPackage__c locSegment = new LocationPackage__c();
            locSegment.Name = 'TestLocationSegment';
            locSegment.ARV_AccountId__c=acctId;
            locSegment.ARV_ContractId__c=contId;
            //locSegment.ARV_BCBSM_NewHire_Rehire_Code__c = '' ;
            //locSegment.ARV_BCN_NewHire_Rehire_Code__c ='' ;
            locSegment.ARV_NewHire_Rehire_Exceptions__c='';
            locSegment.ARV_Location_Physical_Address__c = 'Physical Address' ;
            locSegment.ARV_Physical_City__c = cityId;
            locSegment.ARV_Location_Physical_City_Other__c = '';
            locSegment.ARV_Location_Physical_State__c = 'TestState';
            locSegment.ARV_Location_Physical_Zip_Code__c = '48005';
            locSegment.ARV_Physical_County__c = countyId;
            locSegment.ARV_Admin_First_Name__c = 'FirstName';
            locSegment.ARV_Billing_First_Name__c = 'BillName';
            locSegment.ARV_Billing_Address__c = 'Billing Address';
            locSegment.ARV_Billing_City_Code__c = cityId;
            locSegment.ARV_Billing_City_Other__c = '';
            locSegment.ARV_Billing_State__c = 'BillingState';
            locSegment.ARV_Billing_Zip_Code__c = '48005';
            locSegment.ARV_Billing_County_Code__c = countyId;
        return locSegment;
    }
    
    public static Package__c createPackage(id usrId, id contId){
         Package__c pkg = new Package__c();
            pkg.Name='TestPackage';
            //pkg.OwnerId=usrId;
            pkg.ARV_Contract_Id__c = contId;
            return pkg;
    }
    
    public static Package_Location_Segment_Rel__c createPLSR(id pkgId, id locSegmentId, id contId){
        Package_Location_Segment_Rel__c pkgLocSeg = new Package_Location_Segment_Rel__c();
            pkgLocSeg.Name = 'TestPackageLocationSegment';
            pkgLocSeg.Package__c = pkgId;
            pkgLocSeg.Location_Segment__c = locSegmentId;
            pkgLocSeg.Contract__c=contId;
            pkgLocSeg.ARV_CF_CensusMember_Count__c = 2;
        return pkgLocSeg;
    }
}