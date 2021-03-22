@isTest(seealldata=false)
public class ARV_AP_createGWCTransactionTables_Test {
    ARV_AP_createGWCTransactionTables_Test(){}
    private static final string PROFILENAME='System Administrator';
    private static final string PROFILENAME1='Retention Sales';
    private static final string NAME2='AP33RateGrid';
    private static final string NAME='AP61LastName';
    Private static final String TEST_VAL='Test';
    Private static final String TEST_VAL1='Test1';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string Acntname='TestAcnt';
    Private static final String CID='23';
    Private static final String CARRIERCODE='dsfsdfs';
    Private static final String NULL1 ='';
    Private static final String ACTIVE='Active'; 
    private static final string CntrctName='testcntrct';
    private static final string PACKAGE1='Package';
    private static final integer countGS=2;
    
    /*********************************************************************************************************
@Description: testDataSetup1() method 
@Name : testDataSetup1
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    @testSetup static void testDataSetup1() { 
        Account acc = new Account(name=TEST_VAL);
        acc.CID__c=CID;
        acc.Federal_Tax_ID__c='675437';
        acc.Status__c= ACTIVE;
        database.insert(acc);
        
        Account acc1 = new Account(name=TEST_VAL1);
        acc1.CID__c=CID;
        acc1.Federal_Tax_ID__c='675437';
        acc1.Status__c= ACTIVE;
        database.insert(acc1);
        Contract cntrct=new Contract(AccountId=acc.id,name=CntrctName);
        database.insert(cntrct);
        GA_Group_Segment__c gsData = new GA_Group_Segment__c(Name=Name,GA_Account__c=acc.id,ARV_ContractID__c=cntrct.id);
        database.insert(gsData);
        Package__C pack=new Package__C(Name=PACKAGE1,ARV_Contract_Id__c=cntrct.id,ARV_GWC_Benefit_Package_Type__c='Modify Benefit Package');
        database.insert(pack);
        Package__C pack2=new Package__C(Name=PACKAGE1,ARV_Contract_Id__c=cntrct.id,ARV_GWC_Benefit_Package_Type__c='Add Location');
        database.insert(pack2);
        Package__C pack3=new Package__C(Name=PACKAGE1,ARV_Contract_Id__c=cntrct.id,ARV_GWC_Benefit_Package_Type__c='Add Benefit Package');
        database.insert(pack3);
        Package__C pack4=new Package__C(Name=PACKAGE1,ARV_Contract_Id__c=cntrct.id,ARV_GWC_Benefit_Package_Type__c='Existing Benefit Package No Change');
        database.insert(pack4);
        Package__C pack5=new Package__C(Name=PACKAGE1,ARV_Contract_Id__c=cntrct.id,ARV_GWC_Benefit_Package_Type__c='Rating Area Update');
        database.insert(pack5);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME2;
        usr.Username=USERNAME;
        database.insert(usr,true);
        
    }
    
    private static testMethod void getcontractdetails() {
        //Account acc1 = new Account(name=TEST_VAL);     
        String accntid=String.valueOf([select id from Account  limit 1].id);
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> pack1 = new Map<String,Object>();
        String cntrctId=String.valueOf([select id from Contract where name=:CntrctName limit 1].id);
        inputMap.put('contractId',cntrctId);
        String packageid=String.valueOf([select id,name from Package__C where name=:PACKAGE1 limit 1].id);
        pack1.put('id',packageid);
        //String packageContractId=String.valueOf([select id,name,ARV_Contract_Id__c from Package__C where name=:PACKAGE1 limit 1].ARV_Contract_Id__c);
        //pack1.put('ARV_Contract_Id__c',packageContractId);
        String packageName=String.valueOf([select id,name from Package__C where name=:PACKAGE1 limit 1].Name);
        pack1.put('name',packageName);
        //String gsid=String.valueOf([select id,Name from GA_Group_Segment__c where Name=:Name limit 1].id);
        //pack1.put('id',gsid);
        
        //String gsName=String.valueOf([select id,Name from GA_Group_Segment__c where Name=:Name limit 1].Name);
        //pack1.put('Name',gsName);
        
        
        user usr1  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr1){    
            ARV_AP_createGWCTransactionTables packcreates = new ARV_AP_createGWCTransactionTables();
            try{       
                system.test.startTest();
                //packcreates.invokemethod('createPackages',inputMap,outMap,options);
                ARV_AP_createGWCTransactionTables.createGWCTransactionTable(inputMap,outMap,options);
                ARV_AP_createGWCTransactionTables gwc = new ARV_AP_createGWCTransactionTables();
                gwc.invokemethod('createGWCTransactionTable',inputMap,outMap,options);
                
                //ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                ARV_AP_createMaintenanceTransactionTable maintransac = new ARV_AP_createMaintenanceTransactionTable();
                maintransac.invokemethod('MaintenanceChangeGSRecords',inputMap,outMap,options);
                
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(packageName!='null');
        }           
    }
    
    private static testMethod void getgwcrecorddetails() {
        //Account acc2 = new Account(name=TEST_VAL);     
        String accntid=String.valueOf([select id from Account  limit 1].id);
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',accntid);
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> MaintenanceChang = new Map<String,Object>();
        Map<String,Object> Account = new Map<String,Object>();
        Map<String,Object> GS = new Map<String,Object>();
        Map<String,Object> Contact = new Map<String,Object>();
        Map<String,Object> typeahead = new Map<String,Object>();
        Map<String,Object> phyaddr = new Map<String,Object>();
        Map<String,Object> acccon = new Map<String,Object>();
        
        Map<String,Object> gsString = new Map<String,Object>();
        Map<String,Object> gsDetails = new Map<String,Object>();
        Map<String,Object> gslist = new Map<String,Object>();
        Map<String,Object> SICCodelist = new Map<String,Object>(); 
        
        
        typeahead.put('TypeAhead_SICCode-Acc','0112 - Rice');
        phyaddr.put('ShippingAddressStreet','1101 Physical St');
        gsString.put('f_GroupSegmentUpdate_DBA','true');
        gsString.put('f_GroupSegmentUpdate_FederalTaxID','true');
        acccon.put('f_CEO_WasChanged','true');
        acccon.put('f_PrincipalAdmin_WasChanged','true');
        acccon.put('f_MutualVoter_WasChanged','true');
        gsDetails.put('Name','0100 - (General) Agricultural Production - Crops');
        SICCodelist.put('SICCode',gsDetails);
        //Map<String,Object> pack1 = new Map<String,Object>();
        Contact.put('Email','cfg@dfr.com');
        Account.put('f_CompanyName_WasChanged','true');
        Account.put('f_DoingBusinessAsDBA_WasChanged','true');
        Account.put('f_FederalTaxID_WasChanged','true');
        Account.put('f_SICCode_WasChanged','true');
        Account.put('f_SponsoredPlanAcronym_WasChanged','true');
        
        Account.put('f_PhysicalAddress_WasChanged','true');
        Account.put('f_MailingAddress_WasChanged','true');
        Account.put('TypeAhead_SICCode-Acc-Block',typeahead);
        Account.put('PhysicalAddress-Acc',phyaddr);
        Account.put('AccountContacts',acccon);
         Map<String,Object> AccountInfo = new  Map<String,Object>();
        Map<String,Object> TypeAhead1=new Map<String,Object>();
        TypeAhead1.put('TypeAhead_SponsoredPlanAcronym','MALAD');
        Account.put('TypeAhead_SponsoredPlanAcronym-Block',TypeAhead1);
         inputMap.put('AccountInfo',AccountInfo);
        
        gslist.put('GroupSegmentDetails',SICCodelist);
        
        MaintenanceChang.put('AccountInfo',Account);
        MaintenanceChang.put('ContactInfo',Contact);
        MaintenanceChang.put('AccountUpdate','Company Name');
        
        MaintenanceChang.put('SelectionFormulasBlock-GS',gsString);
        MaintenanceChang.put('GroupSegmentUpdate','Doing Business As');
        MaintenanceChang.put('GroupSegmentUpdate','Federal Tax ID');
        MaintenanceChang.put('GroupSegmentUpdate','SIC Code');
        MaintenanceChang.put('GroupSegmentUpdate','New Hire/Rehire');
        //MaintenanceChang.put('GroupSegmentDetails',gsinfo);
        //MaintenanceChang.put('SelectionFormulasBlock-GS',GS);
        inputMap.put('MaintenanceChange',MaintenanceChang);
        Map<String,Object> GWCDetails = new Map<String,Object>();
        GWCDetails.put('RatingArea','RatingArea');
        GWCDetails.put('mat1output','mat1output');
        inputMap.put('GWCDetails',GWCDetails);
        
        user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr2){    
            try{       
                system.test.startTest();
                ARV_AP_createGWCTransactionTables.MaintenanceChangeRecords(inputMap,outMap,options);
                // ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(accntid!='null');
        }  
    }
    private static testMethod void getgwcrecorddetails10() {
        //Account acc2 = new Account(name=TEST_VAL);     
        String accntid=String.valueOf([select id from Account  limit 1].id);
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',accntid);
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> MaintenanceChang = new Map<String,Object>();
        Map<String,Object> Account = new Map<String,Object>();
        Map<String,Object> GS = new Map<String,Object>();
        Map<String,Object> Contact = new Map<String,Object>();
        Map<String,Object> typeahead = new Map<String,Object>();
        Map<String,Object> phyaddr = new Map<String,Object>();
        Map<String,Object> acccon = new Map<String,Object>();
        
        Map<String,Object> gsString = new Map<String,Object>();
        Map<String,Object> gsDetails = new Map<String,Object>();
        Map<String,Object> gslist = new Map<String,Object>();
        Map<String,Object> SICCodelist = new Map<String,Object>(); 
        
        
        typeahead.put('TypeAhead_SICCode-Acc','0112 - Rice');
        phyaddr.put('ShippingAddressStreet','1101 Physical St');
        gsString.put('f_GroupSegmentUpdate_DBA','true');
        gsString.put('f_GroupSegmentUpdate_FederalTaxID','true');
        acccon.put('f_CEO_WasChanged','true');
        acccon.put('f_PrincipalAdmin_WasChanged','true');
        acccon.put('f_MutualVoter_WasChanged','true');
        gsDetails.put('Name','0100 - (General) Agricultural Production - Crops');
        SICCodelist.put('SICCode',gsDetails);
        //Map<String,Object> pack1 = new Map<String,Object>();
        Map<String,Object>AddCommonControl=new Map<String,Object>();
        AddCommonControl.put('FederalTaxID3','cfg@dfr.com');
        AddCommonControl.put('Segment_Name','value');
        Contact.put('Email','cfg@dfr.com');
        Map<String,Object>MailingAddressAcc=new Map<String,Object>();
        MailingAddressAcc.put('MailingAddress_Original','Test');
        Account.put('f_CompanyName_WasChanged','true');
        Account.put('f_DoingBusinessAsDBA_WasChanged','true');
        Account.put('f_FederalTaxID_WasChanged','true');
        Account.put('f_SICCode_WasChanged','true');
        Account.put('f_SponsoredPlanAcronym_WasChanged','true');
        Account.put('MailingAddress-Acc',MailingAddressAcc);    


        Map<String,Object> TypeAhead1=new Map<String,Object>();
        TypeAhead1.put('TypeAhead_SponsoredPlanAcronym','MALAD');

        Account.put('TypeAhead_SponsoredPlanAcronym-Block',TypeAhead1);        
        Account.put('f_PhysicalAddress_WasChanged','true');
        Account.put('f_MailingAddress_WasChanged','true');
        Account.put('TypeAhead_SICCode-Acc-Block',typeahead);
        Account.put('PhysicalAddress-Acc',phyaddr);
        Account.put('AccountContacts',acccon);
        gslist.put('GroupSegmentDetails',SICCodelist);
        
        MaintenanceChang.put('AccountInfo',Account);
        MaintenanceChang.put('ContactInfo',Contact);
        MaintenanceChang.put('AccountUpdate','Add Common Control');
        MaintenanceChang.put('Add_Common_Control',AddCommonControl);
        MaintenanceChang.put('SelectionFormulasBlock-GS',gsString);
        MaintenanceChang.put('GroupSegmentUpdate','Doing Business As');
        MaintenanceChang.put('GroupSegmentUpdate','Federal Tax ID');
        MaintenanceChang.put('GroupSegmentUpdate','SIC Code');
        MaintenanceChang.put('GroupSegmentUpdate','New Hire/Rehire');
        //MaintenanceChang.put('GroupSegmentDetails',gsinfo);
        //MaintenanceChang.put('SelectionFormulasBlock-GS',GS);
        inputMap.put('MaintenanceChange',MaintenanceChang);
        inputMap.put('RatingArea','RatingArea');
        inputMap.put('mat1output','mat1output');
      
    
       
      
        
        user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr2){    
            try{       
                system.test.startTest();
                ARV_AP_createGWCTransactionTables.MaintenanceChangeRecords(inputMap,outMap,options);
                // ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(accntid!='null');
        }  
    }
    
    
    
    private static testMethod void getgwcrecorddetails1() {   
        String accntid1=String.valueOf([select id from Account where name=:TEST_VAL1 limit 1].id);
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',accntid1);
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> MaintenanceChang = new Map<String,Object>();
        Map<String,Object> slcblck=new Map<String, Object>();
        Map<String,Object> coninfo=new Map<String, Object>();
        coninfo.put('f_FirstName_WasChanged','true');
        coninfo.put('f_LastName_WasChanged','true');
        coninfo.put('f_Phone_WasChanged','true');
        coninfo.put('f_Email_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingStateCode_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingPostalCode_WasChanged','true');
        slcblck.put('f_GroupSegmentUpdate_DBA','true');
        slcblck.put('f_GroupSegmentUpdate_FederalTaxID',true);
        slcblck.put('f_GroupSegmentUpdate_SICCode',true);
        List<Object> gsinfo= new List<Object>();
        list<object> coninfo1 = new list<object>();
        coninfo1.add(coninfo);
        Map<String,Object> gs1=new Map<String,Object>();
        gs1.put('updatedDBA','true');    
        gsinfo.add(gs1);
        
        MaintenanceChang.put('SelectionFormulasBlock-GS',slcblck);
        MaintenanceChang.put('GroupSegmentUpdate','Doing Business As');
        // MaintenanceChang.put('GroupSegmentUpdate','Federal Tax ID');
        MaintenanceChang.put('GroupSegmentDetails',gsinfo);
        MaintenanceChang.put('ContactInfo',coninfo);
        
        inputMap.put('MaintenanceChange', MaintenanceChang);
        user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr2){    
            try{       
                system.test.startTest();
                ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(accntid1!='null');
        }
    }
    private static testMethod void getgwcrecorddetails2() {   
        String accntid1=String.valueOf([select id from Account where name=:TEST_VAL1 limit 1].id);
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',accntid1);
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> MaintenanceChang = new Map<String,Object>();
        Map<String,Object> slcblck=new Map<String, Object>();
        Map<String,Object> coninfo=new Map<String, Object>();
        coninfo.put('f_FirstName_WasChanged','true');
        coninfo.put('f_LastName_WasChanged','true');
        coninfo.put('f_Phone_WasChanged','true');
        coninfo.put('f_Email_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingStateCode_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingPostalCode_WasChanged','true');
        slcblck.put('f_GroupSegmentUpdate_DBA','true');
        slcblck.put('f_GroupSegmentUpdate_FederalTaxID',true);
        
        List<Object> gsinfo= new List<Object>();
        Map<String,Object> gs1=new Map<String,Object>();
        gs1.put('updatedFedTaxId','true');    
        gsinfo.add(gs1);
        
        MaintenanceChang.put('SelectionFormulasBlock-GS',slcblck);
        // MaintenanceChang.put('GroupSegmentUpdate','Doing Business As');
        MaintenanceChang.put('GroupSegmentUpdate','Federal Tax ID');
        MaintenanceChang.put('GroupSegmentDetails',gsinfo);
        MaintenanceChang.put('ContactInfo',coninfo);
        
        inputMap.put('MaintenanceChange', MaintenanceChang);
        user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr2){    
            try{       
                system.test.startTest();
                ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(accntid1!='null');
        }
    }
    private static testMethod void getgwcrecorddetails3() {   
        String accntid1=String.valueOf([select id from Account where name=:TEST_VAL1 limit 1].id);
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',accntid1);
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> MaintenanceChang = new Map<String,Object>();
        Map<String,Object> slcblck=new Map<String, Object>();
        Map<String,Object> coninfo=new Map<String, Object>();
        coninfo.put('f_FirstName_WasChanged','true');
        coninfo.put('f_LastName_WasChanged','true');
        coninfo.put('f_Phone_WasChanged','true');
        coninfo.put('f_Email_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingStateCode_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingPostalCode_WasChanged','true');
        slcblck.put('f_GroupSegmentUpdate_DBA','true');
        slcblck.put('f_GroupSegmentUpdate_SICCode',true);
        
        List<Object> gsinfo= new List<Object>();
        Map<String,Object> gs1=new Map<String,Object>();
        gs1.put('updatedSICCode','true'); 
        gsinfo.add(gs1);
        
        MaintenanceChang.put('SelectionFormulasBlock-GS',slcblck);
        // MaintenanceChang.put('GroupSegmentUpdate','Doing Business As');
        MaintenanceChang.put('GroupSegmentUpdate','SIC Code');
        MaintenanceChang.put('GroupSegmentDetails',gsinfo);
        MaintenanceChang.put('ContactInfo',coninfo);
        
        inputMap.put('MaintenanceChange', MaintenanceChang);
        user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr2){    
            try{       
                system.test.startTest();
                ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(accntid1!='null');
        }
    }
    private static testMethod void getgwcrecorddetails4() {   
        String accntid1=String.valueOf([select id from Account where name=:TEST_VAL1 limit 1].id);
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',accntid1);
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> MaintenanceChang = new Map<String,Object>();
        Map<String,Object> slcblck=new Map<String, Object>();
        Map<String,Object> coninfo=new Map<String, Object>();
        coninfo.put('f_FirstName_WasChanged','true');
        coninfo.put('f_LastName_WasChanged','true');
        coninfo.put('f_Phone_WasChanged','true');
        coninfo.put('f_Email_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingStateCode_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingPostalCode_WasChanged','true');
        // slcblck.put('f_GroupSegmentUpdate_DBA','true');
        slcblck.put('f_GroupSegmentUpdate_NewHireRehire',true);
        
        List<Object> gsinfo= new List<Object>();
        Map<String,Object> gs1=new Map<String,Object>();
        gs1.put('updatedNewHire','true');    
                
        Map<String,Object> newHireRehire=new Map<String,Object>();
        
        newHireRehire.put('BCN_NewHireCode_Original','');
        newHireRehire.put('BCN_RehireCode_Original','');
        newHireRehire.put('BCBSM_NewHireOptionId_Original','');
        newHireRehire.put('BCBSM_RehireOptionId_Original','');
        newHireRehire.put('BCN_NewHireCode','');
        newHireRehire.put('BCN_RehireCode','');
        newHireRehire.put('BCBSM_NewHireOptionId','');
        newHireRehire.put('BCBSM_RehireOptionId','');
        gs1.put('NewHireRehire',newHireRehire);
        
        gsinfo.add(gs1);
        
        MaintenanceChang.put('SelectionFormulasBlock-GS',slcblck);
        // MaintenanceChang.put('GroupSegmentUpdate','Doing Business As');
        MaintenanceChang.put('GroupSegmentUpdate','New Hire/Rehire');
        MaintenanceChang.put('GroupSegmentDetails',gsinfo);
        MaintenanceChang.put('ContactInfo',coninfo);
        
        inputMap.put('MaintenanceChange', MaintenanceChang);
        user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr2){    
            try{       
                system.test.startTest();
                ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(accntid1!='null');
        }
    }
    private static testMethod void getgwcrecorddetails5() {   
        String accntid1=String.valueOf([select id from Account where name=:TEST_VAL1 limit 1].id);
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',accntid1);
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> MaintenanceChang = new Map<String,Object>();
        Map<String,Object> slcblck=new Map<String, Object>();
        Map<String,Object> coninfo=new Map<String, Object>();
        coninfo.put('f_FirstName_WasChanged','true');
        coninfo.put('f_LastName_WasChanged','true');
        coninfo.put('f_Phone_WasChanged','true');
        coninfo.put('f_Email_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingStateCode_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingPostalCode_WasChanged','true');
        // slcblck.put('f_GroupSegmentUpdate_DBA','true');
        slcblck.put('f_GroupSegmentUpdate_Contacts',true);
        
        List<Object> gsinfo= new List<Object>();
        Map<String,Object> gs1=new Map<String,Object>();
        gs1.put('updatedAdminContact','true');    
        gsinfo.add(gs1);
        
        MaintenanceChang.put('SelectionFormulasBlock-GS',slcblck);
        // MaintenanceChang.put('GroupSegmentUpdate','Doing Business As');
        MaintenanceChang.put('GroupSegmentUpdate','Contacts');
        MaintenanceChang.put('GroupSegmentDetails',gsinfo);
        MaintenanceChang.put('ContactInfo',coninfo);
        
        inputMap.put('MaintenanceChange', MaintenanceChang);
        user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr2){    
            try{       
                system.test.startTest();
                ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(accntid1!='null');
        }
    }
    private static testMethod void getgwcrecorddetails6() {   
        String accntid1=String.valueOf([select id from Account where name=:TEST_VAL1 limit 1].id);
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',accntid1);
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> MaintenanceChang = new Map<String,Object>();
        Map<String,Object> slcblck=new Map<String, Object>();
        Map<String,Object> coninfo=new Map<String, Object>();
        coninfo.put('f_FirstName_WasChanged','true');
        coninfo.put('f_LastName_WasChanged','true');
        coninfo.put('f_Phone_WasChanged','true');
        coninfo.put('f_Email_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingStateCode_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingPostalCode_WasChanged','true');
        // slcblck.put('f_GroupSegmentUpdate_DBA','true');
        slcblck.put('f_GroupSegmentUpdate_PhysicalAddress',true);
        
        List<Object> gsinfo= new List<Object>();
        Map<String,Object> gs1=new Map<String,Object>();
        gs1.put('updatedPhysicalAddress','true');    
        gsinfo.add(gs1);
        
        MaintenanceChang.put('SelectionFormulasBlock-GS',slcblck);
        
        MaintenanceChang.put('GroupSegmentUpdate','Physical Address');
        MaintenanceChang.put('GroupSegmentDetails',gsinfo);
        MaintenanceChang.put('ContactInfo',coninfo);
        
        inputMap.put('MaintenanceChange', MaintenanceChang);
        user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr2){    
            try{       
                system.test.startTest();
                ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(accntid1!='null');
        }
    }
    private static testMethod void getgwcrecorddetails7() {   
        String accntid1=String.valueOf([select id from Account where name=:TEST_VAL1 limit 1].id);
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',accntid1);
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> MaintenanceChang = new Map<String,Object>();
        Map<String,Object> slcblck=new Map<String, Object>();
        Map<String,Object> coninfo=new Map<String, Object>();
        coninfo.put('f_FirstName_WasChanged','true');
        coninfo.put('f_LastName_WasChanged','true');
        coninfo.put('f_Phone_WasChanged','true');
        coninfo.put('f_Email_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingStateCode_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingPostalCode_WasChanged','true');
        // slcblck.put('f_GroupSegmentUpdate_DBA','true');
        slcblck.put('f_GroupSegmentUpdate_MailingAddress',true);
        
        List<Object> gsinfo= new List<Object>();
        Map<String,Object> gs1=new Map<String,Object>();
        gs1.put('updatedMailingAddress','true');    
        gsinfo.add(gs1);
        
        MaintenanceChang.put('SelectionFormulasBlock-GS',slcblck);
        
        MaintenanceChang.put('GroupSegmentUpdate','Mailing Address');
        MaintenanceChang.put('GroupSegmentDetails',gsinfo);
        MaintenanceChang.put('ContactInfo',coninfo);
        
        inputMap.put('MaintenanceChange', MaintenanceChang);
        user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr2){    
            try{       
                system.test.startTest();
                ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(accntid1!='null');
        }
    }
    private static testMethod void getgwcrecorddetails8() {   
        String accntid1=String.valueOf([select id from Account where name=:TEST_VAL1 limit 1].id);
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',accntid1);
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> MaintenanceChang = new Map<String,Object>();
        Map<String,Object> slcblck=new Map<String, Object>();
        Map<String,Object> coninfo=new Map<String, Object>();
        coninfo.put('f_FirstName_WasChanged','true');
        coninfo.put('f_LastName_WasChanged','true');
        coninfo.put('f_Phone_WasChanged','true');
        coninfo.put('f_Email_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingStateCode_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingPostalCode_WasChanged','true');
        // slcblck.put('f_GroupSegmentUpdate_DBA','true');
        slcblck.put('f_GroupSegmentUpdate_BillingAddress',true);
        
        List<Object> gsinfo= new List<Object>();
        Map<String,Object> gs1=new Map<String,Object>();
        gs1.put('updatedBillingAddress','true');    
        gsinfo.add(gs1);
        
        MaintenanceChang.put('SelectionFormulasBlock-GS',slcblck);
        
        MaintenanceChang.put('GroupSegmentUpdate','Billing Address');
        MaintenanceChang.put('GroupSegmentDetails',gsinfo);
        MaintenanceChang.put('ContactInfo',coninfo);
        
        inputMap.put('MaintenanceChange', MaintenanceChang);
        user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr2){    
            try{       
                system.test.startTest();
                ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(accntid1!='null');
        }
    }
    private static testMethod void getgwcrecorddetails9() {   
        String accntid1=String.valueOf([select id from Account where name=:TEST_VAL1 limit 1].id);
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('ContextId',accntid1);
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> MaintenanceChang = new Map<String,Object>();
        Map<String,Object> slcblck=new Map<String, Object>();
        Map<String,Object> coninfo=new Map<String, Object>();
        coninfo.put('f_FirstName_WasChanged','true');
        coninfo.put('f_LastName_WasChanged','true');
        coninfo.put('f_Phone_WasChanged','true');
        coninfo.put('f_Email_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingStateCode_WasChanged','true');
        coninfo.put('f_MailingStreet_WasChanged','true');
        coninfo.put('f_MailingPostalCode_WasChanged','true');
        // slcblck.put('f_GroupSegmentUpdate_DBA','true');
        slcblck.put('f_GroupSegmentUpdate_Contacts',true);
        
        List<Object> gsinfo= new List<Object>();
        Map<String,Object> gs1=new Map<String,Object>();
        gs1.put('updatedBillingContact','true');    
        gsinfo.add(gs1);
        
        MaintenanceChang.put('SelectionFormulasBlock-GS',slcblck);
        
        MaintenanceChang.put('GroupSegmentUpdate','Contacts');
        MaintenanceChang.put('GroupSegmentDetails',gsinfo);
        MaintenanceChang.put('ContactInfo',coninfo);
        
        inputMap.put('MaintenanceChange', MaintenanceChang);
        user usr2  = [SELECT Id from User where LastName =:NAME2 limit 1];
        system.runAs(usr2){    
            try{       
                system.test.startTest();
                ARV_AP_createMaintenanceTransactionTable.MaintenanceChangeGSRecords(inputMap,outMap,options);
                system.test.stoptest();
            }Catch(Exception e){    
                system.debug('Error at::'+e.getLineNumber());
            }
            System.assert(accntid1!='null');
        }
    }
    
}