/**
@Author : IDC offshore
@Name: ASC_PlanTriggerHandler_Test
@CreatedDate: 6 - June 2020 
@Description: ASC_PlanTriggerHandler_Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
 private class ASC_PlanTriggerHandler_Test {
    /* Constructor defined */
    private ASC_PlanTriggerHandler_Test (){
        ACTIVE ='Active';
    }
    
    private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME1='System Administrator';
    private static final string TYPE2='Dental';
    private static final string TYPE1='Vision';
    private static final string BLANK='';
    private static final string NAME1='Agent';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string PRD_TYPE='ASC Product';
    private static final string PRD_LOB1 = 'Non-Benefit';
    private static final string COV_SPEC = 'Coverage Spec';
    private static final string PRODT = 'Product';
    private static final string CARR_BCBSM = 'BCBSM';
    private static final string CARR_BCN = 'BCN';
    private static  string ACTIVE ='Active';
    private static Id prdCovSpecRecordTypeId =
     Schema.SObjectType.Product2.getRecordTypeInfosByName().get(COV_SPEC).getRecordTypeId();
    
    
    
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string PARPRD_CD = 'ASC_0000068';
    private static final string PARPRD_FAMILY = 'Medical';
    private static final string PRD_FAMILY = 'Admin Fees';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string ACCCID = '12345';
    private static final string FEDTID = '123456789';
    private static final string BILL_PCODE = '48005';
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();   
    private static final string PRD_CODE = 'ASC_0000370';
    private static final string PRD_NAME = 'Variable Administrative Fees';
    private static final String LIENAMEPRD = 'Data Feeds 1';
    private static final Integer QUANTITY = 20;
    private static final Double COUPONSAVINGS = 20;
    private static final Double AWP1 = 20;
    private static final Double AWP1DECIMAL = 20.65;
    private static final Double AWP2 = 20;

    /*******************************************************************************************************************************
    @Description        :   createProductRecords() method 
    @Name               :   createProductRecords
    @Param              :   None
    @Return             :   void
    @throws Exception   :   N/A;
    ********************************************************************************************************************************/ 
    private static testMethod void createPlanRecords(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        //Product2 prd2 = [Select Id from Product2 where ProductCode ='ASC_0000186'];         
          
        Product2 prd2= new product2();
        prd2.Name = PRD_NAME;
        prd2.productcode = 'ASC_0000186';
        prd2.Family = PRD_FAMILY;
        prd2.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd2.vlocity_ins__SubType__c = TYPE;
        prd2.vlocity_ins__Type__c = TYPE;
        prd2.vlocity_ins__EffectiveDate__c = system.today();
        
        Database.insert(prd2,false);
        
        Account acc=new Account();
            acc.Name=NAME;
            acc.Phone=PHONE;
            acc.CID__c=ACCCID;
            acc.Federal_Tax_ID__c=ACCCID;
            acc.Requested_Effective_Date__c=system.today();
            acc.GA_CoverageCancellationDate__c=system.today();        
          
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            Database.insert(acc); 
        
        Contract con= new Contract(
            AccountId=acc.Id,Status='Draft',
            StartDate =system.today(),ContractTerm=4);
        Database.insert(con);
        
        Product2 prd1 = new Product2();
        prd1.vlocity_ins__Type__c = TYPE;
        prd1.ProductCode = PARPRD_CD;
        prd1.IsActive = true;
        prd1.Name = 'Your Dedicated Nurse Program Year';//'Multi Year Admin Fee Year';
        prd1.Family = PARPRD_FAMILY;
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd1, false); 
               
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=Prd2.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan2); 
        
        Product2 prd3 = new Product2();
        prd3.vlocity_ins__Type__c = TYPE;
        prd3.ProductCode = PARPRD_CD;
        prd3.IsActive = true;
        prd3.Name = 'Rx Opt Out';
        prd3.Family = PARPRD_FAMILY;
        prd3.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd3.RecordTypeId = prdRecordTypeId;
        prd3.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd3, false); 
               
        vlocity_ins__ContractLineItem__c plan3 = new vlocity_ins__ContractLineItem__c();
        plan3.vlocity_ins__Product2Id__c=Prd3.Id;
        plan3.ASC_Effective_Start_Date__c=system.today();
        plan3.ASC_AAC_PCNT__c=10.00;
        plan3.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan3); 
        
        Product2 prd4 = new Product2();
        prd4.vlocity_ins__Type__c = TYPE;
        prd4.ProductCode = PARPRD_CD;
        prd4.IsActive = true;
        prd4.Name = 'Stop-Loss Coverage Opt Out'; //'Pharmacy Rx Rebate: Option 2 Admin Fee Credit';
        prd4.Family = PARPRD_FAMILY;
        prd4.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd4.RecordTypeId = prdRecordTypeId;
        prd4.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd4, false); 
               
        vlocity_ins__ContractLineItem__c plan4 = new vlocity_ins__ContractLineItem__c();
        plan4.vlocity_ins__Product2Id__c=Prd4.Id;
        plan4.ASC_Effective_Start_Date__c=system.today();
        plan4.ASC_AAC_PCNT__c=1000.00;
        plan4.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan4);
        
        vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
        plan.vlocity_ins__Product2Id__c=Prd1.Id;
        plan.ASC_Effective_Start_Date__c=system.today();
        plan.vlocity_ins__ParentItemId__c = plan2.Id;
        plan.vlocity_ins__ContractId__c=con.id;
        plan.ASC_AAC_PCNT__c=10.00;
        
        List<vlocity_ins__ContractLineItem__c> contractList = new List<vlocity_ins__ContractLineItem__c>();
        vlocity_ins__ProductChildItem__c childitem = new vlocity_ins__ProductChildItem__c(
        );
                  
        system.runAs(usr){            
            Test.startTest();            
            Database.insert(plan); 
           
            plan.ASC_AAC_PCNT__c=25.45;
            plan2.ASC_AAC_PCNT__c=101.00;
            contractList.add(plan);
            contractList.add(plan2);            
            ASC_PlanTriggerHandler.duplicatePlanInsert(contractList);            
            ASC_PlanTriggerHandler.beforeUpdate(contractList);
            ASC_PlanTriggerHandler.beforeInsert(contractList);
            ASC_PlanTriggerHandler.afterInsert(contractList);
            ASC_PlanTriggerHelper.createPlan(contractList);
            ASC_PlanTriggerHelper.createLie(contractList);
            ASC_PlanActionController.hasAccessToCreate();
            Test.stopTest();     
            System.assertNotEquals(null,acc.id);
        }
    }
    
    /*******************************************************************************************************************************
    @Description        :   createProductRecords1() method 
    @Name               :   createProductRecords1
    @Param              :   None
    @Return             :   void
    @throws Exception   :   N/A;
    ********************************************************************************************************************************/ 
    private static testMethod void createPlanRecords1(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
               
        //Product2 prd2 = [Select Id from Product2 where ProductCode ='ASC_0000186'];         
          
        Product2 prd2= new product2(
        Name = 'Data Feeds',
        productcode = 'ASC_0000186',
        Family = PRD_FAMILY,
        vlocity_ins__LineOfBusiness__c = PRD_LOB,
        vlocity_ins__SubType__c = TYPE,
        vlocity_ins__Type__c = TYPE,
        vlocity_ins__EffectiveDate__c = system.today()
        );
        Database.insert(prd2,false);
        
        Account acc=new Account();
            acc.Name=NAME;
            acc.Phone=PHONE;
            acc.CID__c=ACCCID;
            acc.Federal_Tax_ID__c=ACCCID;
            acc.Requested_Effective_Date__c=system.today();
            acc.GA_CoverageCancellationDate__c=system.today();        
          
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            Database.insert(acc); 
        
        Contract con= new Contract(
            AccountId=acc.Id,Status='Draft',
            StartDate =system.today(),ContractTerm=4);
        Database.insert(con);
        
        Product2 prd1 = new Product2();
        prd1.vlocity_ins__Type__c = TYPE;
        prd1.ProductCode = 'ASC_0000185';
        prd1.IsActive = true;
        prd1.Name = 'Rx Accumulator Fee';//'Multi Year Admin Fee Year';
        prd1.Family = PARPRD_FAMILY;
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd1, false); 
        
        Line_Item_Extension__c lie2 = new Line_Item_Extension__c();
        lie2.name = LIENAMEPRD;
        lie2.Product__c = prd2.Id;
        lie2.Activation_Type__c = 'New';
        lie2.Quantity__c = QUANTITY;
        lie2.DataFeed_Type__c = 'Laboratory Data';
        lie2.Tier__c ='Year 1';
        lie2.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie2.AWP_1__c=AWP1;
        lie2.AWP_2__c=AWP2;
        Database.insert(lie2,false);
        
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=Prd2.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.vlocity_ins__ContractId__c=con.id;
        plan2.ASC_Line_Item_Extension__c =lie2.Id;
        Database.insert(plan2); 
        
        Product2 prd3 = new Product2();
        prd3.vlocity_ins__Type__c = TYPE;
        prd3.ProductCode = PARPRD_CD;
        prd3.IsActive = true;
        prd3.Name = 'Rx Opt Out';
        prd3.Family = PARPRD_FAMILY;
        prd3.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd3.RecordTypeId = prdRecordTypeId;
        prd3.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd3, false); 
               
        vlocity_ins__ContractLineItem__c plan3 = new vlocity_ins__ContractLineItem__c();
        plan3.vlocity_ins__Product2Id__c=Prd3.Id;
        plan3.ASC_Effective_Start_Date__c=system.today();
        plan3.ASC_AAC_PCNT__c=10.00;
        plan3.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan3); 
        
        Product2 prd4 = new Product2();
        prd4.vlocity_ins__Type__c = TYPE;
        prd4.ProductCode = PARPRD_CD;
        prd4.IsActive = true;
        prd4.Name = 'Blue Cross Coordinated Care Buy Up Program - Custom';
        prd4.Family = PARPRD_FAMILY;
        prd4.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd4.RecordTypeId = prdRecordTypeId;
        prd4.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd4, false); 
               
        vlocity_ins__ContractLineItem__c plan4 = new vlocity_ins__ContractLineItem__c();
        plan4.vlocity_ins__Product2Id__c=Prd4.Id;
        plan4.ASC_Effective_Start_Date__c=system.today();
        plan4.ASC_AAC_PCNT__c=1000.00;
        plan4.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan4);
        
        

        vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
        plan.vlocity_ins__Product2Id__c=Prd1.Id;
        plan.ASC_Effective_Start_Date__c=system.today();
        plan.vlocity_ins__ParentItemId__c = plan2.Id;
        plan.vlocity_ins__ContractId__c=con.id;
        plan.ASC_AAC_PCNT__c=10.00;
        plan.ASC_Line_Item_Extension__c = lie2.Id;
        List<vlocity_ins__ContractLineItem__c> contractList = new List<vlocity_ins__ContractLineItem__c>();
        
        system.runAs(usr){            
            Test.startTest();            
            Database.insert(plan); 
            
            plan.ASC_AAC_PCNT__c=25.45;
            plan2.ASC_AAC_PCNT__c=101.00;
            contractList.add(plan);
            contractList.add(plan2);
            ASC_PlanTriggerHandler.duplicatePlanInsert(contractList);            
            ASC_PlanTriggerHandler.beforeUpdate(contractList);
            ASC_PlanTriggerHandler.beforeInsert(contractList);
            ASC_PlanTriggerHandler.afterInsert(contractList);
            ASC_PlanTriggerHelper.createPlan(contractList);
            ASC_PlanTriggerHelper.createLie(contractList);
            ASC_PlanActionController.hasAccessToCreate();           
            Test.stopTest();         
            System.assertNotEquals(null,acc.id);
        }
    }
        /*******************************************************************************************************************************
    @Description        :   createProductRecords2() method 
    @Name               :   createProductRecords2
    @Param              :   None
    @Return             :   void
    @throws Exception   :   N/A;
    ********************************************************************************************************************************/ 
    private static testMethod void createPlanRecords2(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);                            

        Product2 prd2= new product2(
        Name = PRD_NAME,
        productcode = 'ASC_0000186',
        Family = PRD_FAMILY,
        vlocity_ins__LineOfBusiness__c = PRD_LOB,
        vlocity_ins__SubType__c = TYPE,
        vlocity_ins__Type__c = TYPE,
        vlocity_ins__EffectiveDate__c = system.today()
        );
        Database.insert(prd2,false);
        
        Account acc=new Account();
            acc.Name=NAME;
            acc.Phone=PHONE;
            acc.CID__c=ACCCID;
            acc.Federal_Tax_ID__c=ACCCID;
            acc.Requested_Effective_Date__c=system.today();
            acc.GA_CoverageCancellationDate__c=system.today();        
          
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            Database.insert(acc); 
        
        Contract con= new Contract(
            AccountId=acc.Id,Status='Draft',
            StartDate =system.today(),ContractTerm=4);
        Database.insert(con);
        Contract con1= new Contract(
            AccountId=acc.Id,Status='Draft',
            StartDate =system.today(),ContractTerm=4);
        Database.insert(con1);
        
        Product2 prd1 = new Product2();
        prd1.vlocity_ins__Type__c = TYPE;
        prd1.ProductCode = 'ASC_0000081';
        prd1.IsActive = true;
        prd1.Name = 'Data Feeds';//'Multi Year Admin Fee Year';
        prd1.Family = PARPRD_FAMILY;
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd1, false); 
     
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=Prd2.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan2); 
        
        Line_Item_Extension__c lie3 = new Line_Item_Extension__c();
        lie3.name = LIENAMEPRD;
        lie3.Product__c = prd2.Id;
        lie3.Quantity__c = QUANTITY;
        lie3.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie3.AWP_1__c=AWP1;
        lie3.AWP_2__c=AWP2;
        lie3.Tier__c ='Years 1';
        lie3.DataFeed_Type__c='Laboratory Data';
        Database.insert(lie3,false);
        
        vlocity_ins__ContractLineItem__c plan5 = new vlocity_ins__ContractLineItem__c();
        plan5.vlocity_ins__Product2Id__c=Prd1.Id;
        plan5.ASC_Effective_Start_Date__c=system.today();
        plan5.vlocity_ins__ParentItemId__c = plan2.Id;
        plan5.vlocity_ins__ContractId__c=con1.id;
        plan5.ASC_AAC_PCNT__c=10.00;
        plan5.ASC_Line_Item_Extension__c = lie3.Id;
       Database.insert(plan5);
        
        Line_Item_Extension__c lie2 = new Line_Item_Extension__c();
        lie2.name = LIENAMEPRD;
        lie2.Product__c = prd2.Id;
        lie2.Quantity__c = QUANTITY;
        lie2.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie2.AWP_1__c=AWP1;
        lie2.AWP_2__c=AWP2;
        Database.insert(lie2,false);
        
        vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
        plan.vlocity_ins__Product2Id__c=Prd1.Id;
        plan.ASC_Effective_Start_Date__c=system.today();
        plan.vlocity_ins__ParentItemId__c = plan2.Id;
        plan.vlocity_ins__ContractId__c=con.id;
        plan.ASC_AAC_PCNT__c=10.00;
        plan.ASC_Line_Item_Extension__c = lie2.Id;
        List<vlocity_ins__ContractLineItem__c> contractList = new List<vlocity_ins__ContractLineItem__c>();
        
        system.runAs(usr){            
            Test.startTest();            
            Database.insert(plan); 
            plan.ASC_AAC_PCNT__c=25.45;
            plan2.ASC_AAC_PCNT__c=101.00;
            contractList.add(plan);
            contractList.add(plan2);
           ASC_PlanTriggerHandler.duplicatePlanInsert(contractList);            
            ASC_PlanTriggerHandler.beforeUpdate(contractList);
            ASC_PlanTriggerHandler.beforeInsert(contractList);
            ASC_PlanTriggerHandler.afterInsert(contractList);
            ASC_PlanTriggerHelper.createPlan(contractList);
            ASC_PlanTriggerHelper.createLie(contractList);
            ASC_PlanActionController.hasAccessToCreate();
            Test.stopTest();  
            System.assertNotEquals(null,acc.id);
        }
    }
    /*******************************************************************************************************************************
    @Description        :   createProductRecords3() method 
    @Name               :   createProductRecords3
    @Param              :   None
    @Return             :   void
    @throws Exception   :   N/A;
    ********************************************************************************************************************************/ 
    private static testMethod void createPlanRecords3(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);                            

        Product2 prd2= new product2(
        Name = 'Pharmacy Rx Rebate: Option 2 Admin Fee Credit',
        productcode = 'ASC_0000186',
        Family = PRD_FAMILY,
        vlocity_ins__LineOfBusiness__c = PRD_LOB,
        vlocity_ins__SubType__c = TYPE,
        vlocity_ins__Type__c = TYPE,
        vlocity_ins__EffectiveDate__c = system.today()
        );
        Database.insert(prd2,false);
        
        Account acc=new Account();
            acc.Name=NAME;
            acc.Phone=PHONE;
            acc.CID__c=ACCCID;
            acc.Federal_Tax_ID__c=ACCCID;
            acc.Requested_Effective_Date__c=system.today();
            acc.GA_CoverageCancellationDate__c=system.today();        
          
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            Database.insert(acc); 
        
        Contract con= new Contract(
            AccountId=acc.Id,Status='Draft',
            StartDate =system.today(),ContractTerm=4);
        Database.insert(con);
        
        Product2 prd1 = new Product2();
        prd1.vlocity_ins__Type__c = TYPE;
        prd1.ProductCode = 'ASC_0000005';
        prd1.IsActive = true;
        prd1.Name = 'Fixed Admin Fee';//'Multi Year Admin Fee Year';
        prd1.Family = PARPRD_FAMILY;
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd1, false); 
     
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=Prd2.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan2); 
        
        Line_Item_Extension__c lie2 = new Line_Item_Extension__c();
        lie2.name = LIENAMEPRD;
        lie2.Product__c = prd2.Id;
        lie2.Quantity__c = QUANTITY;
        lie2.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie2.AWP_1__c=AWP1;
        lie2.AWP_2__c=AWP2;
        lie2.Tier__c = 'Years 1';
        lie2.DataFeed_Type__c='Laboratory Data';
        Database.insert(lie2,false);
        
        vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
        plan.vlocity_ins__Product2Id__c=Prd1.Id;
        plan.ASC_Effective_Start_Date__c=system.today();
        plan.vlocity_ins__ParentItemId__c = plan2.Id;
        plan.vlocity_ins__ContractId__c=con.id;
        plan.ASC_AAC_PCNT__c=10.00;
        //plan.ASC_Line_Item_Extension__c = lie2.Id;
        List<vlocity_ins__ContractLineItem__c> contractList = new List<vlocity_ins__ContractLineItem__c>();
        
        system.runAs(usr){            
            Test.startTest();            
            Database.insert(plan); 
            plan.ASC_AAC_PCNT__c=25.45;
            plan2.ASC_AAC_PCNT__c=101.00;
            contractList.add(plan);
            contractList.add(plan2);
            ASC_PlanTriggerHandler.duplicatePlanInsert(contractList);            
            ASC_PlanTriggerHandler.beforeUpdate(contractList);
            ASC_PlanTriggerHandler.beforeInsert(contractList);
            ASC_PlanTriggerHandler.afterInsert(contractList);
            ASC_PlanTriggerHelper.createPlan(contractList);
            ASC_PlanTriggerHelper.createLie(contractList);
            ASC_PlanActionController.hasAccessToCreate();
            Test.stopTest();      
            System.assertNotEquals(null,acc.id);
        }
    }
    /*******************************************************************************************************************************
    @Description        :   createProductRecords4() method 
    @Name               :   createProductRecords4
    @Param              :   None
    @Return             :   void
    @throws Exception   :   N/A;
    ********************************************************************************************************************************/ 
    private static testMethod void createPlanRecords4(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);                            

        Product2 prd2= new product2(
        Name = PRD_NAME,
        productcode = 'ASC_0000186',
        Family = PRD_FAMILY,
        vlocity_ins__LineOfBusiness__c = PRD_LOB,
        vlocity_ins__SubType__c = TYPE,
        vlocity_ins__Type__c = TYPE,
        vlocity_ins__EffectiveDate__c = system.today()
        );
        Database.insert(prd2,false);
        
        Account acc=new Account();
            acc.Name=NAME;
            acc.Phone=PHONE;
            acc.CID__c=ACCCID;
            acc.Federal_Tax_ID__c=ACCCID;
            acc.Requested_Effective_Date__c=system.today();
            acc.GA_CoverageCancellationDate__c=system.today();        
          
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            Database.insert(acc); 
        
        Contract con= new Contract(
            AccountId=acc.Id,Status='Draft',
            StartDate =system.today(),ContractTerm=4);
        Database.insert(con);
        
        Product2 prd1 = new Product2();
        prd1.vlocity_ins__Type__c = TYPE;
        prd1.ProductCode = 'ASC_0000081';
        prd1.IsActive = true;
        prd1.Name = 'Data Feeds';//'Multi Year Admin Fee Year';
        prd1.Family = PARPRD_FAMILY;
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd1, false); 
     
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=Prd2.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan2); 
        
        Line_Item_Extension__c lie2 = new Line_Item_Extension__c();
        lie2.name = LIENAMEPRD;
        lie2.Product__c = prd2.Id;
        lie2.Quantity__c = QUANTITY;
        lie2.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie2.AWP_1__c=AWP1;
        lie2.AWP_2__c=AWP2;
        lie2.Tier__c = 'Year 1';
        //lie2.DataFeed_Type__c='Hearing Data';
        Database.insert(lie2,false);
        
        vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
        plan.vlocity_ins__Product2Id__c=Prd1.Id;
        plan.ASC_Effective_Start_Date__c=system.today();
        plan.vlocity_ins__ParentItemId__c = plan2.Id;
        plan.vlocity_ins__ContractId__c=con.id;
        plan.ASC_AAC_PCNT__c=10.00;
        plan.ASC_Line_Item_Extension__c = lie2.Id;
        List<vlocity_ins__ContractLineItem__c> contractList = new List<vlocity_ins__ContractLineItem__c>();
        
        system.runAs(usr){            
            Test.startTest();            
            Database.insert(plan); 
            plan.ASC_AAC_PCNT__c=25.45;
            plan2.ASC_AAC_PCNT__c=101.00;
            contractList.add(plan);
            contractList.add(plan2);
            ASC_PlanTriggerHandler.duplicatePlanInsert(contractList);            
            ASC_PlanTriggerHandler.beforeUpdate(contractList);
            ASC_PlanTriggerHandler.beforeInsert(contractList);
            ASC_PlanTriggerHandler.afterInsert(contractList);
            ASC_PlanTriggerHelper.createPlan(contractList);
            ASC_PlanTriggerHelper.createLie(contractList);
            ASC_PlanActionController.hasAccessToCreate();
            Test.stopTest();       
            System.assertNotEquals(null,acc.id);
        }
    }
    /*******************************************************************************************************************************
    @Description        :   createProductRecords5() method 
    @Name               :   createProductRecords5
    @Param              :   None
    @Return             :   void
    @throws Exception   :   N/A;
    ********************************************************************************************************************************/ 
    private static testMethod void createPlanRecords5(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
               
        //Product2 prd2 = [Select Id from Product2 where ProductCode ='ASC_0000186'];         
          
        Product2 prd2= new product2(
        Name = 'ECC Suite Admin Fee Credit',
        productcode = 'ASC_0000186',
        Family = PRD_FAMILY,
        vlocity_ins__LineOfBusiness__c = PRD_LOB,
        vlocity_ins__SubType__c = TYPE,
        vlocity_ins__Type__c = TYPE,
        vlocity_ins__EffectiveDate__c = system.today()
        );
        Database.insert(prd2,false);
        
        Account acc=new Account();
            acc.Name=NAME;
            acc.Phone=PHONE;
            acc.CID__c=ACCCID;
            acc.Federal_Tax_ID__c=ACCCID;
            acc.Requested_Effective_Date__c=system.today();
            acc.GA_CoverageCancellationDate__c=system.today();        
          
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            Database.insert(acc); 
        
        Contract con= new Contract(
            AccountId=acc.Id,Status='Draft',
            StartDate =system.today(),ContractTerm=4);
        Database.insert(con);
        
        Product2 prd1 = new Product2();
        prd1.vlocity_ins__Type__c = TYPE;
        prd1.ProductCode = 'ASC_0000185';
        prd1.IsActive = true;
        prd1.Name = 'Rx Accumulator Fee';//'Multi Year Admin Fee Year';
        prd1.Family = PARPRD_FAMILY;
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd1, false); 
               
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=Prd2.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan2); 
        
        Product2 prd3 = new Product2();
        prd3.vlocity_ins__Type__c = TYPE;
        prd3.ProductCode = PARPRD_CD;
        prd3.IsActive = true;
        prd3.Name = 'Rx Opt Out';
        prd3.Family = PARPRD_FAMILY;
        prd3.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd3.RecordTypeId = prdRecordTypeId;
        prd3.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd3, false); 
               
        vlocity_ins__ContractLineItem__c plan3 = new vlocity_ins__ContractLineItem__c();
        plan3.vlocity_ins__Product2Id__c=Prd3.Id;
        plan3.ASC_Effective_Start_Date__c=system.today();
        plan3.ASC_AAC_PCNT__c=10.00;
        plan3.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan3); 
        
        Product2 prd4 = new Product2();
        prd4.vlocity_ins__Type__c = TYPE;
        prd4.ProductCode = PARPRD_CD;
        prd4.IsActive = true;
        prd4.Name = 'Pharmacy Rx Rebate: Option 2 Admin Fee Credit';
        prd4.Family = PARPRD_FAMILY;
        prd4.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd4.RecordTypeId = prdRecordTypeId;
        prd4.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd4, false); 
               
        Line_Item_Extension__c lie1 = new Line_Item_Extension__c();
        lie1.name = LIENAMEPRD;
        lie1.Product__c = prd1.Id;
        lie1.Quantity__c = QUANTITY;
        lie1.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie1.AWP_1__c=AWP1;
        lie1.AWP_2__c=AWP2;
        //lie1.Type__c = 'Test';
        lie1.DataFeed_Type__c= 'Dental Claims Data';
        Database.insert(lie1,false);
        
        Line_Item_Extension__c lie2 = new Line_Item_Extension__c();
        lie2.name = LIENAMEPRD;
        lie2.Product__c = prd2.Id;
        lie2.Quantity__c = QUANTITY;
        lie2.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie2.AWP_1__c=AWP1;
        lie2.AWP_2__c=AWP2;
        lie2.Type__c = 'Test';
        lie2.DataFeed_Type__c= 'Dental Claims Data';
        Database.insert(lie2,false);

        vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
        plan.vlocity_ins__Product2Id__c=Prd1.Id;
        plan.ASC_Effective_Start_Date__c=system.today();
        plan.vlocity_ins__ParentItemId__c = plan2.Id;
        plan.vlocity_ins__ContractId__c=con.id;
        plan.ASC_AAC_PCNT__c=10.00;
        //plan.vlocity_ins__ProductCode__c='Test';
        plan.Products_Added_After_Signature__c= true;
        plan.ASC_Line_Item_Extension__c = lie2.Id;
        List<vlocity_ins__ContractLineItem__c> contractList = new List<vlocity_ins__ContractLineItem__c>();
        
        vlocity_ins__ContractLineItem__c plan4 = new vlocity_ins__ContractLineItem__c();
        plan4.vlocity_ins__Product2Id__c=Prd1.Id;
        plan4.ASC_Effective_Start_Date__c=system.today();
        plan4.ASC_AAC_PCNT__c=1000.00;
        plan4.vlocity_ins__ContractId__c=con.id;
        plan4.Products_Added_After_Signature__c =true;
        Database.insert(plan4);
        
        system.runAs(usr){            
            Test.startTest();            
            try{
            Database.insert(plan);  
                plan.ASC_AAC_PCNT__c=25.45;
                contractList.add(plan);
            }
            catch(DMLException e){               
             e.getMessage();
            }
            
            plan2.ASC_AAC_PCNT__c=101.00;
            
            contractList.add(plan2);
            contractList.add(plan4);
            
            ASC_PlanTriggerHandler.duplicatePlanInsert(contractList);            
            ASC_PlanTriggerHandler.beforeUpdate(contractList);
            ASC_PlanTriggerHandler.beforeInsert(contractList);
            ASC_PlanTriggerHandler.afterInsert(new List<vlocity_ins__ContractLineItem__c>());
            ASC_PlanTriggerHelper.createPlan(contractList);
            ASC_PlanTriggerHelper.createLie(contractList);
            ASC_PlanActionController.hasAccessToCreate();
            Test.stopTest();     
            System.assertNotEquals(null,acc.id);
        }
    }
    /*******************************************************************************************************************************
    @Description        :   createProductRecords6() method 
    @Name               :   createProductRecords6
    @Param              :   None
    @Return             :   void
    @throws Exception   :   N/A;
    ********************************************************************************************************************************/ 
    private static testMethod void createPlanRecords6(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);                            

        Product2 prd2= new product2(
        Name = PRD_NAME,
        productcode = 'ASC_0000186',
        Family = PRD_FAMILY,
        vlocity_ins__LineOfBusiness__c = PRD_LOB,
        vlocity_ins__SubType__c = TYPE,
        vlocity_ins__Type__c = TYPE,
        vlocity_ins__EffectiveDate__c = system.today()
        );
        Database.insert(prd2,false);
        
        Account acc=new Account();
            acc.Name=NAME;
            acc.Phone=PHONE;
            acc.CID__c=ACCCID;
            acc.Federal_Tax_ID__c=ACCCID;
            acc.Requested_Effective_Date__c=system.today();
            acc.GA_CoverageCancellationDate__c=system.today();        
          
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            Database.insert(acc); 
        
        Contract con= new Contract(
            AccountId=acc.Id,Status='Draft',
            StartDate =system.today(),ContractTerm=4);
        Database.insert(con);
        
        Product2 prd1 = new Product2();
        prd1.vlocity_ins__Type__c = TYPE;
        prd1.ProductCode = 'ASC_0000081';
        prd1.IsActive = true;
        prd1.Name = 'Data Feeds';//'Multi Year Admin Fee Year';
        prd1.Family = PARPRD_FAMILY;
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd1, false); 
     
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=Prd2.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan2); 
        
        Line_Item_Extension__c lie2 = new Line_Item_Extension__c();
        lie2.name = LIENAMEPRD;
        lie2.Product__c = prd2.Id;
        lie2.Quantity__c = QUANTITY;
        lie2.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie2.AWP_1__c=AWP1;
        lie2.AWP_2__c=AWP2;
        lie2.Tier__c = 'Year 1';
        lie2.DataFeed_Type__c = 'Test';
        Database.insert(lie2,false);
        
        vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
        plan.vlocity_ins__Product2Id__c=Prd2.Id;
        plan.ASC_Effective_Start_Date__c=system.today();
        plan.vlocity_ins__ParentItemId__c = plan2.Id;
        plan.vlocity_ins__ContractId__c=con.id;
        plan.ASC_AAC_PCNT__c=10.00;
        plan.ASC_Line_Item_Extension__c = lie2.Id;
        List<vlocity_ins__ContractLineItem__c> contractList = new List<vlocity_ins__ContractLineItem__c>();
        
        system.runAs(usr){            
            Test.startTest();            
            Database.insert(plan); 
            plan.ASC_AAC_PCNT__c=25.45;
            plan2.ASC_AAC_PCNT__c=101.00;
            contractList.add(plan);
            contractList.add(plan2);
            ASC_PlanTriggerHandler.duplicatePlanInsert(contractList);            
            ASC_PlanTriggerHandler.beforeUpdate(contractList);
            ASC_PlanTriggerHandler.beforeInsert(contractList);
            ASC_PlanTriggerHandler.afterInsert(contractList);
            ASC_PlanTriggerHelper.createPlan(contractList);
            ASC_PlanTriggerHelper.createLie(contractList);
            ASC_PlanActionController.hasAccessToCreate();
            Test.stopTest();  
            System.assertNotEquals(null,acc.id);
        }
    }
/*test method for helper class
 * 
 * 
 * ************************************/
   private static testMethod void createPlantest(){
    
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
                
        Account acc=new Account();
            acc.Name=NAME;
            acc.Phone=PHONE;
            acc.CID__c=ACCCID;
            acc.Federal_Tax_ID__c=ACCCID;
            acc.Requested_Effective_Date__c=system.today();
            acc.GA_CoverageCancellationDate__c=system.today();        
          
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            Database.insert(acc); 
        
        Contract con= new Contract(
            AccountId=acc.Id,Status='Draft',
            StartDate =system.today(),ContractTerm=4);
        Database.insert(con);

        Product2 prd1 = new Product2();
        prd1.vlocity_ins__Type__c = TYPE;
        prd1.ProductCode = 'ASC_00401';
        prd1.IsActive = true;
        prd1.Name = 'Data Feeds';//'Multi Year Admin Fee Year';
        prd1.Family = PARPRD_FAMILY;
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd1);
        
        
        Product2 prd2= new product2(
        Name = PRD_NAME,
        productcode = 'ASC_0000401',
        Family = PRD_FAMILY,
            isActive =true,
        vlocity_ins__LineOfBusiness__c = PRD_LOB,
        vlocity_ins__SubType__c = TYPE,
        vlocity_ins__Type__c = TYPE,
        vlocity_ins__EffectiveDate__c = system.today()
        );
        
        Database.insert(prd2);
        
        vlocity_ins__ProductChildItem__c chld = new vlocity_ins__ProductChildItem__c();
        chld.vlocity_ins__ParentProductId__c = prd1.Id;
        chld.vlocity_ins__ChildProductId__c = prd2.Id;
        chld.vlocity_ins__ChildLineNumber__c = '12';
        Database.insert(chld);
        
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=Prd1.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan2); 
        
         Line_Item_Extension__c lie2 = new Line_Item_Extension__c();
        lie2.name = LIENAMEPRD;
        lie2.Product__c = prd2.Id;
        lie2.Quantity__c = QUANTITY;
        lie2.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie2.AWP_1__c=AWP1;
        lie2.AWP_2__c=AWP2;
        lie2.Tier__c = 'Year 1';
        lie2.DataFeed_Type__c = 'Test';
        Database.insert(lie2,false);
        
        vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
        plan.vlocity_ins__Product2Id__c=Prd2.Id;
        plan.ASC_Effective_Start_Date__c=system.today();
        plan.vlocity_ins__ParentItemId__c = plan2.Id;
        plan.vlocity_ins__ContractId__c=con.id;
        plan.ASC_AAC_PCNT__c=10.00;
        plan.Products_Added_After_Signature__c =true;
        plan.ASC_Line_Item_Extension__c = lie2.Id;
        List<vlocity_ins__ContractLineItem__c> contractList = new List<vlocity_ins__ContractLineItem__c>();       
        
        system.runAs(usr){            
            Test.startTest();            
            Database.insert(plan); 
            plan.ASC_AAC_PCNT__c=25.45;
            plan2.ASC_AAC_PCNT__c=101.00;
            contractList.add(plan);
            contractList.add(plan2);
            ASC_PlanTriggerHandler.duplicatePlanInsert(contractList);            
            ASC_PlanTriggerHandler.beforeUpdate(contractList);
            ASC_PlanTriggerHandler.beforeInsert(contractList);
            ASC_PlanTriggerHandler.afterInsert(contractList);
            ASC_PlanTriggerHelper.createPlan(contractList);
            ASC_PlanTriggerHelper.createLie(contractList);
            ASC_PlanActionController.hasAccessToCreate();
            ASC_PlanActionController.getContract(con.Id);
            Test.stopTest();
            System.assertNotEquals(null,acc.id);
}
}
}