/*
@Author : IDC Offshore
@Name: GA_OBJ_TD01_TestDataCreation
@CreatedDate: 24- Jul 2017 
@Description: GA_OBJ_TD01_TestDataCreation class is used for test data creation
@version : 1.0  
*/
public without sharing class GA_OBJ_TD01_TestDataCreation {
    /**
@Description: jeoprdyRec() method 
@Name : jeoprdyRec
@Param : User assignTo,Account compny   
@Return : GA_Jeopardy__c
@throws Exception : N/A;
*/ 
    public static GA_Jeopardy__c jeoprdyRec(User assignTo,Account compny)
    {
        try{
            GA_Jeopardy__c jeo=new GA_Jeopardy__c();
            jeo.GA_AssignedTo__c=assignTo.id;
            jeo.GA_JeopardyReason__c='Competitor';
            jeo.GA_Competitor__c='Aetna';
            jeo.GA_OtherPleaseSpecify__c='Test Other';
            jeo.GA_ProbabilityToCancel__c=10;
            jeo.GA_ProjectedCancellationDate__c=System.today();
            jeo.GA_Company__c=compny.id;
            jeo.GA_Product__c='Medical';
            jeo.GA_Status__c='Open';
            jeo.GA_ReasonDetail__c='Test Reason';
            jeo.GA_ResolutionCategory__c='Pricing';
            jeo.GA_ResolutionDetail__c='Test Resolution Detail';
            jeo.GA_ResolvedDate__c=system.today()+1;
            return jeo;  
        }
        catch(Exception e){
            return null;
        }
    }
    
    /**
@Description: AccRec() method 
@Name : AccRec
@Param : N/A   
@Return : Account 
@throws Exception : N/A;
*/  
    public static Account AccRec()
    {
        try{
            Account acc=new Account();
            acc.Name='Test Acc';
            acc.Phone='1234567089';
            acc.Account_Status__c='Active';
            acc.Type='Customer';
            acc.NumberOfEmployees=123;
            acc.GA_Total_Eligible__c= 500;
            acc.CID__c='123456';  
            acc.GA_ContractExpirationDate__c=system.today();
            acc.Industry='Agriculture';
            acc.GA_Other__c='Test Other';
            acc.SicDesc='Test';
            acc.Status__c='Active';
            acc.Website='www.xyz.com';
            //acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Union').getRecordTypeId();
            acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
            acc.Description='Test';
            acc.BillingStreet = 'teststreet';
            acc.BillingCity = 'testcity';
            acc.BillingState = 'Michigan';
            acc.BillingPostalCode = '12121';  
            acc.ShippingCountry='United States';
            acc.ShippingStreet = 'shipstreet';
            acc.ShippingCity = 'FLINT';
            acc.ShippingState = 'Michigan';
            acc.ShippingStateCode='MI';
            acc.ShippingPostalCode ='48375';
            acc.GA_Platinum__c = false;
            acc.Federal_Tax_ID__c = '123456789';
            acc.GA_Union_Type__c = 'Local';
            acc.Union_Population__c = 'Yes';
            acc.Union_Code__c = '123';
            acc.Union_Category__c = 'Automobile';
            acc.Union_Acronym__c = 'abc';
            
            return acc;
        }
        catch(Exception e){
            return null;
        }
    }
    
    /**
@Description: ContRec() method 
@Name : ContRec
@Param : N/A   
@Return : Contact
@throws Exception : N/A;
*/  
    public static Contact cntactRec(Id accId)
    {
        try{
            Contact cont = new Contact();
            cont.FirstName = 'First';
            cont.LastName = 'last';
            cont.AccountId = accId;
            cont.Phone='1234567089';
            return cont;
        }
        catch(Exception e){
            return null;
        }
    }
    
    /**
@Description: OpptyRec() method 
@Name : OpptyRec
@Param : N/A   
@Return : Opportunity
@throws Exception : N/A;
*/  
    public static Opportunity optyRec(Id accId)
    {
        try{
            Opportunity opp=new Opportunity();
            opp.Name='Test Oppty';
            opp.AccountId = accId;
            opp.CloseDate=system.today()+10;
            opp.StageName='Created';
            opp.Description='Test Descp';       
            return opp;
        }
        catch(Exception e){
            return null;
        }
    }
    
    /**
@Description: CaseRec() method 
@Name : CaseRec
@Param : N/A   
@Return : Case
@throws Exception : N/A;
*/  
    public static Case CaseRec()
    {
        try{
            Case cas = new Case();
            cas.Subject = '112245';
            cas.GA_ASR_Notes__c = 'Asr notes';
            return cas;
        }
        catch(Exception e){
            return null;
        }
    }
    /*
@Description: handoverRec() method 
@Name : handoverRec
@Param : N/A   
@Return : GA_AccountHandOver__c
@throws Exception : N/A;
*/  
    public static GA_AccountHandOver__c handoverRec(Id accId)
    {
        try{
            GA_AccountHandOver__c accHandovr = new GA_AccountHandOver__c();
            accHandovr.Name = 'Test';
            accHandovr.GA_CompanyFullLegalName__c = accId;
            accHandovr.Carryover_Option__c = 'Standard';
            accHandovr.Carryover_Requested__c = 'Yes';
            accHandovr.GA_TransmittingFileFeedBW_TPA_BCBSM__c = 'Yes';
            accHandovr.EDDI_Set_Up__c =  'Yes';
            return accHandovr;
        }
        catch(Exception e){
            return null;
        }
    }
    /*
@Description: agencyRelationshipRec() method 
@Name : agencyRelationshipRec
@Param : N/A   
@Return : GA_AgencyRelationship__c
@throws Exception : N/A;
*/  
    public static GA_AgencyRelationship__c agencyRelationshipRec(Id accId)
    {
        try{
            GA_AgencyRelationship__c agencyRel = new GA_AgencyRelationship__c();
            agencyRel.Name = 'Test';
            agencyRel.GA_Agency__c = accId;
            return agencyRel;
        }
        catch(Exception e){
            return null;
        }
    }
    /*
@Description: accountTeamRec() method 
@Name : accountTeamRec
@Param : N/A   
@Return : AccountTeamMember
@throws Exception : N/A;
*/  
    public static AccountTeamMember accountTeamRec(Id accId)
    {
        try{
            AccountTeamMember accTeam = new AccountTeamMember();
            accTeam.TeamMemberRole = 'New Business Sales Consultant';
            accTeam.AccountId = accId;        
            return accTeam;
        }
        catch(Exception e){
            return null;
        }
    }
    /**
@Description: eventRec() method 
@Name : eventRec
@Param : N/A   
@Return : Event
@throws Exception : N/A;
*/  
    public static Event eventRec(Id hrId)
    {
        try{
            Event evt = new Event();
            evt.WhatId          =   hrId;
            evt.OwnerId         =   userinfo.getUserId();
            evt.Subject         =   'Test';
            evt.Type            =   'Meeting';
            evt.StartDateTime   =   system.today()+90;
            evt.EndDateTime     =   system.today()+90;
            evt.IsAllDayEvent   =   true;
            return evt;
        }
        catch(Exception e){
            return null;
        }
    }
  
    
    /**
@Description: UsrRec() method 
@Name : UsrRec
@Param : string roleName,string emailVal,string profileName
@Return : User
@throws Exception : N/A;
*/  
    public static User UsrRec(string roleName,string emailVal,string profileName)
    {
        try{
            string profId = [SELECT Id FROM Profile WHERE Name = :profileName Limit 1].Id;
            User usr = new User(
                ProfileId = profId,
                LastName = 'last',
                Email = emailVal,
                Username = emailVal + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
                //UserRoleId = r.Id
            );
            
            return usr;
        }
        catch(Exception e){
            return null;
        }
    }
    
    /**
@Description: setRole() method 
@Name : setRole
@Param : string rolenm
@Return : userRole
@throws Exception : N/A;
*/
    public static UserRole setRole(string rolenm,string devRolNm)
    {
        try{
            UserRole usrRol = new UserRole(DeveloperName = devRolNm, Name =rolenm);
            database.insert(usrRol); 
            return usrRol; 
        }
        catch(Exception e){
            return null;
        }
    }
    /**
@Description: triggercheck() method 
@Name : triggercheck
@Param : string triggernme
@Return : GA_OBJ_TriggerRunCheck__mdt
@throws Exception : N/A;
*/
    public static ActionPlan__c actionPlanRec(string actPlnName,string Descp)
    {
        try{
            ActionPlan__c actPln=new ActionPlan__c();
            actPln.name=actPlnName;
            actPln.Description__c=Descp;
            return actPln;
        }
        catch(Exception e){
            return null;
        }
    }
    /**
@Description: actionPlanTmpRec() method 
@Name : actionPlanTmpRec
@Param : string actPlnName,string Descp  
@Return : ActionPlanTemplate__c
@throws Exception : N/A;
*/ 
    public static ActionPlanTemplate__c actionPlanTmpRec(string actPlnName,string Descp)
    {
        try{
            ActionPlanTemplate__c actPlnTmp=new ActionPlanTemplate__c();
            actPlnTmp.name=actPlnName;
            actPlnTmp.Description__c=Descp;
            return actPlnTmp;
        }
        catch(Exception e){
            return null;
        }
    }
    /**
@Description: AgencyRelationshipRec() method 
@Name : AgencyRelationshipRec
@Param : id agncy,id accnt  
@Return : GA_AgencyRelationship__c
@throws Exception : N/A;
*/
    public static GA_AgencyRelationship__c agncyRelationshipRec(id agncy,id accnt)
    {
        try{
            GA_AgencyRelationship__c agncyRelshp=new GA_AgencyRelationship__c();
            agncyRelshp.GA_Account__c=accnt;
            agncyRelshp.GA_Agency__c=agncy;
            agncyRelshp.GA_EndDate__c=system.today()+10;
            agncyRelshp.GA_StartDate__c=system.today();
            return agncyRelshp;
        }
        catch(Exception e){
            return null;
        }
    }
    /**
@Description: TerritoryRec() method 
@Name : TerritoryRec
@Param : N/A  
@Return : GA_Territory__c
@throws Exception : N/A;
*/
    public static GA_Territory__c terrtryRec()
    {
        try{
            GA_Territory__c terytoryRec=new GA_Territory__c();
            terytoryRec.Name='Test Territory Name';
            terytoryRec.GA_TerritoryType__c='Account Manager';
            terytoryRec.GA_TerritoryCode__c='23';
            terytoryRec.GA_Sales_Rep_Effective_Date__c = System.today();
            return terytoryRec;
        }
        catch(Exception e){
            return null;
        }
    }
    /**
@Description: FactSheetRec() method 
@Name : FactSheetRec
@Param : Account custaccnt  
@Return : GA_Account_Fact_Sheet__c
@throws Exception : N/A;
*/
    public static   GA_Account_Fact_Sheet__c accFactSheetRec(Account custaccnt,Contact conNme)
    {
        try{
            GA_Account_Fact_Sheet__c fsRec=new GA_Account_Fact_Sheet__c();
            fsRec.Name = 'testfactsheet';
            fsRec.GA_Generate_Account_Factsheet__c = false;
            fsRec.GA_Logged_In_User__c = 'ttt@gmail.xyz';
            fsRec.GA_Account__c  = custaccnt.id;
            fsRec.GA_Contact_Name__c = conNme.Id;
            fsRec.GA_Contact_Title__c = 'Test';
            fsRec.GA_Contact_Role__c = 'TestRole';
            fsRec.GA_Contact_Phone__c = '1234569870';
            fsRec.GA_Contact_Email__c  = 'afs@gmail.xyz';
            fsRec.GA_AgentName__c= conNme.Id;
            fsRec.GA_AgentPhoneNumber__c= '9999999999';
            fsRec.GA_AgentEmail__c= 'afsheet@gmail.xyz';
            return fsRec;
        }
        catch(Exception e){
            return null;
        }
    }
    

    
    /**
@Description: grpSegmntRec() method 
@Name : grpSegmntRec
@Param : Account custaccnt  
@Return : GA_Group_Segment__c
@throws Exception : N/A;
*/
    public static   GA_Group_Segment__c grpSegmntRec(Account custaccnt)
    {
        try{
            GA_Group_Segment__c grpsmtRec=new GA_Group_Segment__c();
            grpsmtRec.Name = 'Test GrpSgmnt name';
            grpsmtRec.GA_Account__c = custaccnt.Id;
            //grpsmtRec.GA_External_ID__c = '123456';
            return grpsmtRec;
        }
        catch(Exception e){
            return null;
        }
    }
    
    /* @Name : PlnPkgRec()
@Param : GA_Group_Segment__c grpsgmnt  
@Return : GA_Plan_Package__c
@throws Exception : N/A;
*/
    public static   GA_Plan_Package__c planPkgRec(GA_Group_Segment__c grpsgmnt)
    {
        try{
            GA_Plan_Package__c plPkg=new GA_Plan_Package__c();
            plPkg.GA_Group_Segment__c=grpsgmnt.id;
            plPkg.GA_ACTIVE_IND__c = 'ACTIVE';
            plPkg.Name = 'Test Plan Package name';
            return plPkg;
        }
        catch(Exception e){
            return null;
        }
    }
    
    /* @Name : SoldPrdRec()
@Param : GA_Plan_Package__c plnPkg
@Return : asset
@throws Exception : N/A;
*/
    public static   asset soldPrdtRec(GA_Plan_Package__c plnPkg,account acc)
    {
        try{
            asset sldPrd=new asset();
            sldPrd.Name = 'Test SoldPrd name';
            sldPrd.AccountId=acc.id;
            sldPrd.GA_Plan_Package_Id__c=plnPkg.id;
            sldPrd.RecordTypeId=Schema.SObjectType.asset.getRecordTypeInfosByName().get('Dental Sold Products').getRecordTypeId();
            return sldPrd;
        }
        catch(Exception e){
            return null;
        }
    }
    
    /* @Name : enrollmntRec()
@Param : asset sldPrd
@Return : GA_Enrollment__c
@throws Exception : N/A;
*/
    public static   GA_Enrollment__c enrollmntRec(asset sldPrd,string extId)
    {
        try{
            GA_Enrollment__c erllmnt=new GA_Enrollment__c();
            erllmnt.Name = '201911';
            erllmnt.GA_Plan_Name__c=sldPrd.id;
            erllmnt.GA_Year__c='2019';
            erllmnt.GA_External_ID__c = extId;
            erllmnt.GA_Month_Name__c='November';
            erllmnt.GA_Numeric_Month__c='11';
            erllmnt.GA_Contract_Comp__c=10;
            erllmnt.GA_Contract_Tier1__c=10;
            erllmnt.GA_Contract_Tier2__c=10;
            erllmnt.GA_Contract_Tier3__c=10;
            return erllmnt;
        }
        catch(Exception e){
            return null;
        }
    }
    /* @Name : createTask()
@Param : string sub
@Return : task
@throws Exception : N/A;
*/
    public static task createTask(string sub)
    {
        try{
            task tsk=new task();
            tsk.Subject=sub;
            return tsk;
        }
        catch(Exception e){
            return null;
        }
    }
    /**
@Description: triggercheck() method 
@Name : triggercheck
@Param : string triggernme
@Return : GA_OBJ_TriggerRunCheck__mdt
@throws Exception : N/A;
*/
    public static GA_OBJ_TriggerRunCheck__mdt triggercheck(string triggernme)
    {
        try{
            GA_OBJ_TriggerRunCheck__mdt triggrrunchk =[SELECT Label,GA_TriggerTurnOn__c FROM GA_OBJ_TriggerRunCheck__mdt where label =:triggernme limit 1];
            return triggrrunchk;
        }
        catch(Exception e){
            return null;
        }
    }
    /* @Name : createWrkFlw()
@Param : Account accnt,Case cas,GA_WFT_workflow__c wrkFlwTmplt,User usr
@Return : GA_WF_Workflow__c
@throws Exception : N/A;
*/
    public static GA_WF_Workflow__c createWrkFlw(Account accnt,Case cas,GA_WFT_workflow__c wrkFlwTmplt,User usr)
    {
        try{
            GA_WF_Workflow__c wrkFlw=new GA_WF_Workflow__c();
            wrkFlw.Name = 'Test Workflow';
            wrkFlw.GA_Account__c = accnt.Id;
            wrkFlw.GA_Support__c = cas.Id;
            wrkFlw.GA_Workflow_Template__c = wrkFlwTmplt.Id;
            wrkFlw.OwnerId = usr.Id;
            wrkFlw.GA_Status__c = 'Open';
            wrkFlw.GA_Workflow_Owner__c = 'Test WF Owner';
            wrkFlw.GA_WorkflowOwner__c = usr.Id;
            wrkFlw.GA_Notes__c='Test Notes';
            wrkFlw.GA_Date_Opened__c = system.today();
            wrkFlw.GA_Date_Closed__c = system.today();
            wrkFlw.GA_Renewal_Date__c = system.today();
            return wrkFlw;
        }
        catch(Exception e){
            return null;
        }
    }
    /* @Name : wrkFlwStp()
@Param : GA_WF_Workflow__c wrkFlw
@Return : GA_WF_Step__c 
@throws Exception : N/A;
*/
    public static GA_WF_Step__c wrkFlwStp(GA_WF_Workflow__c wrkFlw)
    {
        try{
            GA_WF_Step__c wfStep = new GA_WF_Step__c();
            wfStep.Name = 'Test Workflow Step';
            wfStep.GA_WF_Workflow_ID__c = wrkFlw.Id;
            wfStep.GA_Status__c = 'Open';
            wfStep.GA_Start__c = datetime.newInstance(2018, 5, 15, 12, 30, 0);
            wfStep.GA_End_Time__c = datetime.newInstance(2018, 7, 15, 12, 30, 0);
            wfStep.GA_Notes__c = 'Test Notes';
            return wfStep;
        }
        catch(Exception e){
            return null;
        }
    }       
    /* @Name : wrkFlwTmplt()
@Param : N/A
@Return : GA_WFT_workflow__c    
@throws Exception : N/A;
*/
    public static GA_WFT_workflow__c  wrkFlwTmplt()
    {
        try{
            GA_WFT_workflow__c  wfTmplt = new GA_WFT_workflow__c ();
            wfTmplt.Name = 'Test Workflow Template';
            wfTmplt.GA_Carrier__c = 'BCBSM';
            wfTmplt.GA_Method__c = 'Automated';
            wfTmplt.GA_Process_Type__c = 'GWC';
            wfTmplt.GA_Process_Subtype__c ='Benefit Change';
            return wfTmplt;
        }
        catch(Exception e){
            return null;
        }
    }
    /* @Name : wrkFlwTmplt()
@Param : GA_WFT_workflowc __wfTmp
@Return : GA_WF_Group_Segment__c    
@throws Exception : N/A;
*/
    public static GA_WF_Group_Segment__c  wrkFlwGs(GA_Group_Segment__c gs,GA_WF_Step__c wfStp)
    {
        try{
            GA_WF_Group_Segment__c  wfGrpSgm = new GA_WF_Group_Segment__c ();
            wfGrpSgm.GA_Group_Segment_ID__c = gs.Id;
            wfGrpSgm.GA_Workflow_Next_Step__c = wfStp.Id;
            return wfGrpSgm;
        }
        catch(Exception e){
            return null;
        }
    }
    /* @Name : wrkTmpStp()
@Param : GA_WFT_workflowc __wfTmp
@Return : GA_WFT_Step__c 
@throws Exception : N/A;
*/
    public static GA_WFT_Step__c wrkTmpStp(GA_WFT_workflow__c wfTmp,GA_WFT_Inventory_Step__c wfInvStp)
    {
        try{
            GA_WFT_Step__c wfTmpStp = new GA_WFT_Step__c ();
            wfTmpStp.GA_WFT_Workflow_ID__c = wfTmp.Id;
            wfTmpStp.GA_Queue_Name__c = 'GA Project Support Queue';
            wfTmpStp.GA_Queue_Type__c = 'Assigned';
            wfTmpStp.GA_WFT_Inventory_Step_ID__c = wfInvStp.id;
            return wfTmpStp ;
        }
        catch(Exception e){
            return null;
        }
    }
    /* @Name : wfInventoryStp()
@Param : GA_WFT_workflowc __wfTmp
@Return : GA_WFT_Step__c 
@throws Exception : N/A;
*/
    public static GA_WFT_Inventory_Step__c wfInventoryStp()
    {
        try{
            GA_WFT_Inventory_Step__c wfInventoryStpe = new GA_WFT_Inventory_Step__c ();
            wfInventoryStpe.GA_Carrier__c = 'BCBSM';
            //  wfInventoryStpe.GA_Conditional_Assignment__c = 'GWC - for Assignment';
            wfInventoryStpe.GA_Department__c = 'Group Admin';
            wfInventoryStpe.GA_Default_Queue__c = 'GA Project Support Queue';
            wfInventoryStpe.GA_Role__c = 'GA Project Support';
            wfInventoryStpe.Name = 'Project Support - to Review';
            return wfInventoryStpe ;
        }
        catch(Exception e){
            return null;
        }
    }    
    
    /* @Name : wfAlwdNxtStp()
@Param : GA_WFT_Step__c wftStp
@Return : GA_WFT_Allowed_Next_Step__c 
@throws Exception : N/A;
*/
    public static GA_WFT_Allowed_Next_Step__c wfAlwdNxtStp (GA_WFT_Step__c wftStp)
    {
        try{
            GA_WFT_Allowed_Next_Step__c wfNxtStp = new GA_WFT_Allowed_Next_Step__c ();
            wfNxtStp.GA_WFT_Parent_Step_ID__c = wftStp.Id;
            wfNxtStp.GA_Allowed_Next_Step__c = wftStp.Id;
            wfNxtStp.GA_Conditional_Application_1__c = 'GWC - for Assignment';
            return wfNxtStp ;
        }
        catch(Exception e){
            return null;
        }
    }
    /* @Name : accBenfitRvw()
@Param :Account acc
@Return : GA_Account_Benefit_Review__c 
@throws Exception : N/A;
*/
    public static GA_Account_Benefit_Review__c accBenfitRvw (Account acc)
    {
        try{
            GA_Account_Benefit_Review__c benRvw = new GA_Account_Benefit_Review__c ();
            benRvw.GA_Account__c = acc.id;
            return benRvw ;
        }
        catch(Exception e){
            return null;
        }
    }   
    
    /* @Name : accBenfitRvw()
@Param :Account acc
@Return : GA_Account_Benefit_Review__c 
@throws Exception : N/A;
*/   
    public static  GA_WFT_Validation__c templateValidation (GA_WFT_workflow__c wfTmp)
    {
        try{
            GA_WFT_Validation__c tmpltValidation = new GA_WFT_Validation__c ();
            tmpltValidation.GA_WFT_Workflow_ID__c = wfTmp.id;
            tmpltValidation.GA_Field_Name__c = 'GA_Rate_Renewal_Date__c';
            tmpltValidation.GA_Object_Name__c = 'GA_Group_Segment_ID__r';
            tmpltValidation.GA_Validation_Type__c = 'IS NULL';
            tmpltValidation.GA_Validation_Value__c = '';
            tmpltValidation.GA_Validation_Message__c = 'Rate Renewal Date does not exist for group segment';
            return tmpltValidation ;
        }
        catch(Exception e){
            return null;
        }
    } 
    
    /* @Name : countyCode()
@Param :N/A
@Return : GA_County_Code__c 
@throws Exception : N/A;
*/   
    public static  GA_County_Code__c countyCode ()
    {
        try{
            GA_County_Code__c cntyCode = new GA_County_Code__c ();
            cntyCode.Name = 'TEST';
            cntyCode.GA_FIPS_County_Code__c = '001';
            cntyCode.GA_SMART_County_Code__c = '002';
            cntyCode.GA_External_ID__c = '0x000000005090300E';
            cntyCode.GA_Region_Id__c = '0x00009050065000013';
            return cntyCode ;
        }
        catch(Exception e){
            return null;
        }
    }
    
    /* @Name : dcSmallGrpHstry()
@Param :N/A
@Return : GA_DC_Small_Grp_History__c 
@throws Exception : N/A;
*/   
    public static  GA_DC_Small_Grp_History__c dcSmallGrpHstry(GA_Group_Segment__c grpSgmnt)
    {
        try{
            GA_DC_Small_Grp_History__c dcSmallGrp = new GA_DC_Small_Grp_History__c ();
            dcSmallGrp.GA_Group_Segment_Id__c =grpSgmnt.id;
            dcSmallGrp.GA_Suite_Start_Date__c = system.today()-10;
            dcSmallGrp.GA_Suite_End_Date__c =  system.today() +10;
            return dcSmallGrp ;
        }
        catch(Exception e){
            return null;
        }
    }
    /* @Name : grpAssociation()
@Param :N/A
@Return : GA_Group_Association__c 
@throws Exception : N/A;
*/   
    public static  GA_Group_Association__c grpAssociation(GA_Group_Segment__c grpSgmnt,Account acc)
    {
        try{
            GA_Group_Association__c grpAssoc = new GA_Group_Association__c ();
            grpAssoc.GA_Group_Segment__c = grpSgmnt.id;
            //grpAssoc.GA_Account__c = acc.id;
            grpAssoc.GA_Start_Date__c =  System.today() - 30;
            grpAssoc.GA_End_Date__c =  System.today() + 30;
            return grpAssoc ;
        }
        catch(Exception e){
            return null;
        }
    }
    
    /* @Name : thirdPartyBiller()
@Param :N/A
@Return : GA_Third_Party_Biller_History__c 
@throws Exception : N/A;
*/   
    public static  GA_Third_Party_Biller_History__c thirdPartyBiller(GA_Group_Segment__c grpSgmnt,Account acc)
    {
        try{
            GA_Third_Party_Biller_History__c tpb = new GA_Third_Party_Biller_History__c ();
            tpb.GA_Group_Segment_Id__c = grpSgmnt.id;
            tpb.GA_Third_Party_Biller_Account__c =  acc.id;
            tpb.GA_TPB_Start_Date__c = System.today()-10;
            tpb.GA_TPB_End_Date__c = System.today()+10;
            return tpb ;
        }
        catch(Exception e){
            return null;
        }
    }
    /* @Name : assocThrdPrtyBillr()
@Param :N/A
@Return : GA_Association_Third_Party_Biller__c 
@throws Exception : N/A;
*/   
    public static  GA_Association_Third_Party_Biller__c assocThrdPrtyBillr(Account acc)
    {
        try{
            GA_Association_Third_Party_Biller__c atpb = new GA_Association_Third_Party_Biller__c ();
            atpb.GA_Association_Account_Id__c = acc.id;
            atpb.GA_Third_Party_Biller_Account_Id__c =  acc.id;
            atpb.GA_Start_Date__c = System.today() -10;
            atpb.GA_End_Date__c = System.today() +10;
            return atpb ;
        }
        catch(Exception e){
            return null;
        }
    }
    /* @Name : AgentSoldContact()
@Param :N/A
@Return : GA_Agent_Sold_Contact__c 
@throws Exception : N/A;
*/   
    public static   GA_Agent_Sold_Contact__c agntSoldContact()
    {
        try{
            GA_Agent_Sold_Contact__c ascRec = new GA_Agent_Sold_Contact__c ();
            ascRec.Name = 'ASC Test';
            ascRec.GA_Phone__c ='1234567089';
            ascRec.GA_Email__c ='asctest@gmail.com;ascRecmailtest@gmail.com';
            return ascRec;
        }
        catch(Exception e){
            return null;
        }
    }
    
    /* @Name : AgentSoldEnrollemnt()
@Param :N/A
@Return : GA_Agent_Sold_Enrollment__c 
@throws Exception : N/A;
*/   
    public static   GA_Agent_Sold_Enrollment__c agentSoldEnrollemnt(GA_Agent_Sold_Contact__c ascRec)
    {
        try{
            GA_Agent_Sold_Enrollment__c aseRec = new GA_Agent_Sold_Enrollment__c ();
            aseRec.Name = 'Test';
            aseRec.GA_Decision_Maker__c=ascRec.id;
            aseRec.GA_Email__c='asetest@gmail.com;underwriter@gmail.com';
            return aseRec;
        }
        catch(Exception e){
            return null;
        }
    }  
    
    /* @Name : setManager()
@Param :N/A
@Return : USer 
@throws Exception : N/A;
*/   
    public static   User setManager(User rep,User manager)
    {
        try{
            rep.ManagerId = manager.Id;
            return rep;
        }
        catch(Exception e){
            return null;
        }
    }   
    
    /* @Name : Account_Plan__c()
@Param :N/A
@Return : Account_Plan__c 
@throws Exception : N/A;
*/   
    public static   Account_Plan__c createAssessment(Account acc)
    {
        try{
            Account_Plan__c assessment = New Account_Plan__c();
            assessment.Account__c = acc.id;
            assessment.GA_AccountAssessmentYear__c =String.valueOf((Integer) System.Today().year()) ;
            return assessment;
        }
        catch(Exception e){
            return null;
        }
    }
    /* @Name : GA_Aor__C()
@Param :N/A
@Return : GA_Aor__C 
@throws Exception : N/A;
*/   
    public static GA_Aor__C createAOR(Account acc,Contact cnt)
    {
        try{
            GA_Aor__C aorRec = New GA_Aor__C();
            aorRec.Name = 'TestAor';
            aorRec.GA_Account_Id__c = acc.id;
            aorRec.GA_Contact_Id__c =cnt.id ;
            return aorRec;
        }
        catch(Exception e){
            return null;
        }
    }    
      /* @Name : GA_AOR_Group_Segment__c()
@Param :N/A
@Return : GA_AOR_Group_Segment__c 
@throws Exception : N/A;
*/   
    public static GA_AOR_Group_Segment__c createAORGS(GA_Aor__C aorRec,GA_Group_Segment__c grpSgmnt)
    {
        try{
            GA_AOR_Group_Segment__c aorGsRec = New GA_AOR_Group_Segment__c();
            aorGsRec.Name='TestAorGs';
            aorGsRec.GA_AOR_Id__c = aorRec.id;
            aorGsRec.GA_Group_Segment_Id__c =grpSgmnt.id;
            return aorGsRec;
        }
        catch(Exception e){
            return null;
        }
    }     
    /* @Name : GA_CID_Adjustment__c()
@Param :N/A
@Return : GA_CID_Adjustment__c 
@throws Exception : N/A;
*/   
    public static   GA_CID_Adjustment__c cidAdjRecrd()
    {
        try{
            GA_CID_Adjustment__c cidAdjRec = new GA_CID_Adjustment__c ();
            return cidAdjRec;
        }
        catch(Exception e){
            return null;
        }
    } 
    
    /* @Name : GA_CID_Adjustment__c()
@Param :N/A
@Return : GA_CID_Adjustment__c 
@throws Exception : N/A;
*/   
    public static   GA_CID_Request_Additional_Info__c cidAddnInfo(User sentusr,User rcvduser,GA_CID_Adjustment__c cidAdjst)
    {
        try{
            GA_CID_Request_Additional_Info__c cidAddnInfoRec = new GA_CID_Request_Additional_Info__c ();
            
            cidAddnInfoRec.GA_Sent_To__c = rcvduser.id;
            cidAddnInfoRec.GA_Sent_From__c =sentusr.id;
            cidAddnInfoRec.GA_CID_Adjustment__c = cidAdjst.id;
            return cidAddnInfoRec;
        }
        catch(Exception e){
            return null;
        }
    }
     
}