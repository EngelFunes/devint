/*****************************************************************************************
Class Name   : ARV_AP05_TestDataCreation 
Date Created : 3-MAY-2019
Created By   : IDC Offshore.
Description  : This class is used to create the data for objects..
******************************************************************************************/
public without sharing class ARV_AP05_TestDataCreation {
	private static final string PROFILENAME='BCBSM Agent';
	public static final string NAME='TEST'; 
	public static final string PHONE='9876543211';

		/**
		@Description: accRec() method 
		@Name : AccRec
		@Param : N/A   
		@Return : Account
		@throws Exception : N/A;
		*/  
		public static Account accRec()
		{
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
			Account acc=new Account();
          
			acc.Name=NAME;
			acc.Phone=PHONE;
			acc.CID__c=randomInt+'12';
			acc.Federal_Tax_ID__c='123456789';
			acc.Requested_Effective_Date__c=system.today();
			acc.GA_CoverageCancellationDate__c=system.today();
			acc.Account_Status__c='Inactive';
			acc.BillingPostalCode='48005';
            acc.ARV_Renewal_Account_Type__c='SG';
            acc.Status__c='Active';
            acc.GA_Carrier_Code__c='dsfsdfs';
            //acc.Account_Status__c='Active';
            acc.Renewal_Month__c='January';
			return acc;
		}
		/**
		@Description: accRec() method 
		@Name : AccRec
		@Param : N/A   
		@Return : Account
		@throws Exception : N/A;
		*/  
		public static Account PortalAccRec(String name,String recordType)
		{
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
			Account acc=new Account();
			acc.Name=NAME;
			acc.Phone=PHONE;
			acc.CID__c=randomInt+'12';
			acc.Federal_Tax_ID__c='123456789';
            acc.Requested_Effective_Date__c=system.today();
			acc.GA_CoverageCancellationDate__c=system.today();
			acc.Account_Status__c='Active';
			acc.BillingPostalCode='48005';
			return acc;
		}
        /**
		@Name : PortalUserRecord
		@Param : Contact   
		@Return : User
		@Description: PortalUserRecord 
		@throws Exception : N/A;
		*/ 
		public static User PortalUserRecord(Contact c)
		{
			User testUser = new User();
			testUser.ProfileID = [Select Id From Profile Where Name=:PROFILENAME].id;
			testUser.EmailEncodingKey = 'ISO-8859-1';
			testUser.LanguageLocaleKey = 'en_US';
			testUser.TimeZoneSidKey = 'America/New_York';
			testUser.LocaleSidKey = 'en_US';
			testUser.FirstName = 'first';
			testUser.LastName = 'last';
			testUser.Username = 'testuser123@somewhere.com';   
			testUser.CommunityNickname = 'testUser123';
			testUser.Alias = 't1';
			testUser.Email = 'no@email.com';
			testUser.IsActive = true;
			testUser.ContactId = c.Id;
			return testUser;
		}

		/**
		@Name : AccRec1
		@Param : N/A   
		@Return : Account
 		@Description: accRec() method 
		@throws Exception : N/A;
		*/  
		public static Account accRec1(Id RecordId)
		{
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			Account acc=new Account();
			acc.Name=NAME;
			acc.Phone=PHONE;
			acc.CID__c=randomInt+'12';
			acc.Federal_Tax_ID__c='987456123';
			acc.Requested_Effective_Date__c=system.today();
			acc.GA_CoverageCancellationDate__c=system.today();
			acc.Account_Status__c='Inactive';
			acc.RecordTypeId=RecordId;
			acc.BillingCountry='United States';
			acc.Billingstreet='dewhgwef';
			acc.BillingCity='California';
			acc.ShippingCountry='United States';
			acc.Shippingstreet='dewhgwef';
			acc.ShippingCountryCode = 'US';
			acc.ShippingPostalCode = '456436';
			acc.ShippingStateCode = 'MI';
			acc.ShippingCity='California';
			return acc;
		}
		/**
		@Description: accRec() method 
		@Name : AccRec
		@Param : N/A   
		@Return : Account
		@throws Exception : N/A;
		*/  
		public static opportunity opportunityRec(Id AccountId,Id pricebookId)
		{
			opportunity opp=new opportunity();
			opp.Name=NAME;
			opp.AccountId=AccountId;
			opp.stageName='Created';
			opp.CloseDate=system.today();
			opp.pricebook2Id=pricebookId;
			return opp;
		}
		/******************************************************************************** 
		Method name : UsrRec
		Params     : NA
		Return Type :User
		Description :UsrRec() Method
		************************************************************************************/ 
		public static User UsrRec(string profileName)
		{

			string profId = [SELECT Id FROM Profile WHERE Name = :profileName limit 1].Id;
			string roleId = [select id,name,portaltype from userrole where portaltype !='Partner' limit 1].id;
            //string rol = profileName=='BCBSM Agent'?roleId:NULL;
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			User usr = new User(
				ProfileId = profId,
				LastName = 'last',
				Email = Name+randomInt+'@Sy.com',
				Username = Name+randomInt+'@Sy.com',
				CompanyName = 'TEST',
				Title = 'title',
				Alias = 'alias',
				TimeZoneSidKey = 'America/Los_Angeles',
				EmailEncodingKey = 'UTF-8',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US',
				EmployeeNumber='123'
				//UserRoleId = roleId
				);

			return usr;
		}
		/**************  
		Method name : productRec
		Params     : NA
		Return Type :Product
		Description :productRec() Method
		*************/  
		public static product2 productRec()
		{
			Product2 p= new product2(
			Name='Health Plan',vlocity_ins__Type__c='Medical',carrier_type__c='bcbs',
			Plan_Type__c='Hmo',
			Family='Simply Blue',
			productcode ='15560MIV000001',
			vlocity_ins__EffectiveDate__c=system.today(),
			Corporate_Form_String__c='289F,314F',Certificate_Rider_Unique_String__c='113J, 910F, 919F, 963F, 401G');
			return p;
		}
		/**************  
		Method name : productRec1
		Params     : NA
		Return Type :Product
		Description :productRec() Method
		*************/  
		public static product2 productRec1()
		{
			Product2 p= new product2(
			Name='Health Plan',vlocity_ins__Type__c='Medical',carrier_type__c='bcn',
			Plan_Type__c='Hmo',productcode='987654321',
			Family='BCN HMO',
			vlocity_ins__EffectiveDate__c=system.today(),
			Corporate_Form_String__c='289F,314F',Certificate_Rider_Unique_String__c='113J, 910F, 919F, 963F, 401G');
			return p;
		}

		/**************  
		Method name : productRec3
		Params     : NA
		Return Type :Product
		Description :productRec() Method
		*************/  
		public static product2 productRec3()
		{
			Product2 p2= new product2(
			Name='BCN HRA HMO℠ Gold $2000',vlocity_ins__Type__c='Medical',carrier_type__c='bcn',
			productcode='98185MI0150017',
			Family='BCN HRA');
			return p2;
		}

		/**************  
		Method name : createContractRec
		Params     : NA
		Return Type :Product
		Description :createContractRec() Method
		*************/  
		public static Contract createContractRec(Id accId)
		{
            //,ARV_SICCode__c=sicId
			Contract con= new Contract(
			AccountId=accId,Status='Draft',
             ARV_Requested_Renewal_Date_Month__c=system.today(),
			StartDate =system.today(),ContractTerm=4,ARV_CEO_Phone__c = PHONE,
            EndDate=system.today(),ARV_System_Check_1_Status__c='Test',ARV_Is_Mass_Updating__c=true,
            ARV_Offices_Branches_OtherLocations__c='Yes',ARV_Is_Common_Control__c='Yes',ARV_Excluded_from_Renewal__c=false,
            ARV_Total_FTE__c=8.5,ARV_TECH_Account_Merge__c='434343',ARV_Segmentation_Type__c='Hourly & Salary',
            ARV_TECH_SubmissionDate__c=system.today(),ARV_Requested_Effective_Date__c =system.today(),
            ARV_Mutual_Voter_Email__c='test@gmail.com',ARV_Mutual_Voter_Mailing_State__c='AK',
           ARV_CEO_Email__c='TEST@gmail.com',ARV_Mutual_Voter_Mailing_Zip__c='sds',
           ARV_CEO_First_Name__c='test',ARV_CEO_Last_Name__c='test',ARV_Renewal_Status__c='Released',
           ARV_Mutual_Voter_First_Name__c='test',ARV_Mutual_Voter_Last_Name__c='test',
            ARV_Mutual_Voter_Mailing_Address__c='test',ARV_Mutual_Voter_Mailing_City__c='test',
          ARV_Mutual_Voter_Mailing_County__c='Test',ARV_Principal_Admin_Email__c='test@gmail.com',
           ARV_Principal_Admin_First_Name__c='test',ARV_Principal_Admin_Last_Name__c='tEST',
           ARV_Tech_IsGroupSegmentActive__c =True);
			return con;
		}

		/**************  
		Method name : createContractRecCensus
		Params     : AccountId , CensusId
		Return Type :Contract
		Description :createContractRecCensus() Method
		*************/  
		public static Contract createContractRecCensus(Id accId, Id CenId)
		{
			Contract con= new Contract(
			AccountId=accId,Status='Draft',vlocity_ins__EnrollmentCensusId__c=CenId,
			StartDate =system.today(),ContractTerm=4);
			return con;
		} 
		/**************  
		Method name : productRec
		Params     : NA
		Return Type :Product
		Description :productRec() Method
		*************/  
		public static product2 productRec2()
		{
			Product2 p= new product2(
			Name='Health Plan',vlocity_ins__Type__c='Medical',carrier_type__c='bcn',
			Plan_Type__c='Hmo',productcode='987654321',
			Family='BCN HMO',
			PCP_Focus__c=true,
			vlocity_ins__EffectiveDate__c=system.today(),
			Corporate_Form_String__c='289F,314F',Certificate_Rider_Unique_String__c='113J, 910F, 919F, 963F, 401G');
			return p;
		}
        /**************  
		Method name : productRec
		Params     : NA
		Return Type :Product
		Description :productRec() Method
		*************/  
		public static product2 productDentalRec()
		{
			Product2 p= new product2(
			Name='Dental Plan',vlocity_ins__Type__c='Dental',carrier_type__c='bcbs',
			//Plan_Type__c='Hmo',
			productcode='987654321',
			//Family='BCN HMO',
			PCP_Focus__c=true,
			vlocity_ins__EffectiveDate__c=system.today(),
			Corporate_Form_String__c='289F,314F');
			return p;
		}
     /**************  
		Method name : productRec
		Params     : NA
		Return Type :Product
		Description :productRec() Method
		*************/  
		public static product2 productVisionRec()
		{
			Product2 p= new product2(
			Name='Vision Plan',vlocity_ins__Type__c='Vision',carrier_type__c='bcn',
			Plan_Type__c='Hmo',productcode='987654321',
			Family='BCN HMO',
			PCP_Focus__c=true,
			vlocity_ins__EffectiveDate__c=system.today(),
			Corporate_Form_String__c='289F,314F',Certificate_Rider_Unique_String__c='113J, 910F, 919F, 963F, 401G');
			return p;
		}
		/**************  
		Method name : planRec
		Params     : Id
		Return Type :plan
		Description :planRec() Method
		**************/ 
		public static vlocity_ins__ContractLineItem__c planRec(Id Prd, Id con)
		{
			vlocity_ins__ContractLineItem__c plan = new vlocity_ins__ContractLineItem__c();
			plan.vlocity_ins__Product2Id__c=Prd;
			plan.vlocity_ins__ContractId__c=con;
			return plan;
		} 

		/************** 
		Method name : documentRec
		Params     : NA
		Return Type :Document
		Description :documentRec() Method
		*************/  
		public static document documentRec(Id qlId,Id pId)
		{
			Id flrdid=[select Name from Folder where Name='BCBSM External Service Document' limit 1].Id;
			Document doc=new Document();
			doc.Body = Blob.valueOf('Some Text');
			doc.ContentType = 'application/pdf';
			doc.DeveloperName = 'my_document';
			doc.IsPublic = true;
			doc.Description=qlId;
			doc.Name='BCN65COMP';
			doc.folderid=flrdid; 
			doc.keywords=pId;
			return doc;
		}
		/**************  
		Method name : attachmentRec
		Params     : NA
		Return Type :attachment
		Description :attachmentRec() Method
		*************/  
		public static attachment attachmentRec(Id qlId,Id pId)
		{
			attachment doc=new attachment();
			doc.Body = Blob.valueOf('Some Text');
			doc.ContentType = 'application/pdf';
			doc.Description='bcncomp';
			doc.parentid=qlId;
			doc.Name='test';
			return doc;
		}
		/**************  
		Method name : attachmentRec
		Params     : quotelineitemId ,parentid
		Return Type :attachment
		Description :attachmentRec() Method
		*************/  
		public static attachment attachmentRec1(Id qlId,Id pId)
		{
			attachment doc=new attachment();
			doc.Body = Blob.valueOf('Some Text');
			doc.ContentType = 'application/pdf';
			doc.Description=qlId;
			doc.parentid=pId;
			doc.Name='test';
			return doc;
		}

		/**************  
		Method name : quoteLineItemRec
		Params     : quoteId,ProductId,Pricebookentryid
		Return Type :QuoteLineItem
		Description :quoteLineItemRec() Method
		*************/  
		public static QuoteLineItem quoteLineItemRec(Id quoteId,Id productId,Id preciD)
		{
			QuoteLineItem qli=new QuoteLineItem();
			qli.QuoteId=quoteId;
			qli.product2Id=productId;
			qli.UnitPrice = 1.0;
			qli.Quantity = 2;
			qli.pricebookentryid=preciD;
			return qli;
		}
		/**************  
		Method name : quote
		Params     : OppId,prbId
		Return Type :Quote
		Description :quoteRec() Method
		*************/  
		public static Quote quoteRec(Id OppId,Id prbId)
		{
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			Quote q=new Quote();
			q.Name='quote'+randomInt;
			q.opportunityId=OppId;
			q.pricebook2Id=prbId;
			return q;
		}
		/**************  
		Method name : priceBookRec
		Params     : NA
		Return Type :Quote
		Description :priceBookRec() Method
		*************/  
		public static pricebook2 priceBookRec()
		{
			pricebook2 pb=new pricebook2 ();
			pb.Name='standard';
			pb.IsActive=true;

			return pb;
		}
		/**************  
		Method name : priceBookEntryRec
		Params     : NA
		Return Type :Quote
		Description :priceBookEntryRec() Method
		*************/  
		public static pricebookentry priceBookEntryRec(Id proId,Id priceId)
		{
			pricebookEntry prc=new pricebookEntry ();
			prc.product2Id=proId;
			prc.Pricebook2Id=priceId;
			prc.UnitPrice =1;
			prc.UseStandardPrice=false;
			prc.isActive=true;
			return prc;
		}
		/*********************************************************************************************************  
		Method name : createCounties
		Params      : integer count
		Return Type : CountyList
		Description : it is used to create counties for Zipcodes
		***********************************************************************************************************/    

		public static List<GA_County_Code__c> createCounties(integer count)
		{
			List< GA_County_Code__c> countyList=new List< GA_County_Code__c>();
			for (integer i=0;i<count;i++){
				GA_County_Code__c countyrec= new GA_County_Code__c();
				countyrec.Name='County'+i;
				
				countyList.add(countyrec);    
			}
			return countyList;
		}

		/*********************************************************************************************************  
		Method name : createZiprec
		Params      : List< GA_County_Code__c> counties
		Return Type : ziplist
		Description : It is used to create Zip Records
		************************************************************************************************************/     
		public static List<Zipcode__c> createZiprec(List< GA_County_Code__c> counties)
		{
			List< Zipcode__c> ziplist=new List< Zipcode__c>();
			for (integer i=0;i<counties.size();i++){
				Zipcode__c ziprec= new Zipcode__c();
				ziprec.ZipCode__c = '1000'+i ;   
				ziprec.CountyName__c=counties[i].id;
				ziplist.add(ziprec);  
			}
			return ziplist;
		}

		/*************************************************************************************************  
		Method name : ContactRec
		Params      : Id AccId
		Return Type :Contact
		Description :ContactRec() Method
		************************************************************************************************/  
		public static contact contactRec(Id AccId)
		{
			contact c=new contact ();
			c.LastName='Mr';
			c.FirstName='Bob';
			c.AccountId=AccId;
            c.Phone=PHONE;
			return c;
		}   
		/*************************************************************************************************  
		Method name : ContactRec
		Params      : Id AccId
		Return Type :Contact
		Description :ContactRec() Method
		************************************************************************************************/  
		public static contact contactRec1(Id AccId,Id contrId)
		{
			contact c=new contact ();
			c.LastName='Mr';
			c.FirstName='Bob';
			c.AccountId=AccId;
			c.title='test';
			c.Email='bob@accenture.com';
			c.ARV_Tech_ContractId__c=contrId;
			return c;
		}   


		/**********************************************************************************************************  
		Method name : quote
		Params     : Id OppId,Id prbId,Id UserId
		Return Type :Quote
		Description :quoteRec1() Method
		***********************************************************************************************************/  
		public static Quote quoteRec1(Id OppId,Id prbId,Id UserId)
		{
			Quote q1=new Quote();
			q1.Name='quote';
			q1.opportunityId=OppId;
			q1.pricebook2Id=prbId;
			q1.Requested_Effective_Date__c=system.today(); 
			q1.Requested_Renewal_Date__c=system.today(); 
			q1.Renewal_Month__c='May';
			q1.Agent_Name__c=UserId;
			q1.ARV_CF_Tech_RatingArea__c = 'B';
			return q1;
		}
		/************
		Method name: Package
		Params: Id conId
		Return Type: Package
		Description: packageRec(Id conId) 
		**************/
		public static Package__c packageRec(Id conId)
		{
			Package__c pack = new Package__c();
            pack.Name='Package1';
			pack.ARV_Contract_Id__c= conId;
			return pack;
		}
    /************
		Method name: Package
		Params: Id conId
		Return Type: Package
		Description: packageRec(Id conId) 
		**************/
		public static Package__c packageRec1(Id conId,Id Mplan,Id Dplan,Id Vplan)
		{
			Package__c pack = new Package__c();
            pack.Name='Package1';
			pack.ARV_Contract_Id__c= conId;
            //pack.ARV_Medical_Plan__c=Mplan;
            //pack.ARV_Dental_Plan__c=Dplan;
            //pack.ARV_Vision_Plan__c=Vplan;
			return pack;
		}
		/************
		Method name: LocationPackage
		Params: Id conId
		Return Type: LocationPackage
		Description: LocationPackage (Id conId)
		**************/
		public static LocationPackage__c locpkgRec(Id conId){
			LocationPackage__c lp=  new LocationPackage__c();
			lp.ARV_ContractId__c= conId;
			lp.ARV_Admin_Address__c = 'test1';
			lp.ARV_Admin_First_Name__c = 'testFirstName';
			lp.ARV_Admin_Last_Name__c = 'testLastName';
			lp.ARV_Admin_Phone__c = PHONE;
			lp.ARV_Admin_County__c ='County1';
			lp.ARV_Admin_Email__c = 'test@gmail.com';
			lp.ARV_Admin_City__c ='testCity';
			lp.ARV_Admin_Zip_Code__c = '48005'; 
			lp.ARV_Admin_State__c = 'AL';
			lp.ARV_Admin_Job_Title__c = 'testJB';
			lp.ARV_Billing_Job_Title__c = 'testJB';
			lp.ARV_Billing_Address__c = 'test1';
			lp.ARV_Billing_City__c = 'testCity';
			lp.ARV_Billing_County__c = 'County1';
			lp.ARV_Billing_City_Other__c = 'testBCO';
			lp.ARV_Billing_Email__c = 'test@gmail.com';
			lp.ARV_Billing_First_Name__c = 'testFirstName';
			lp.ARV_Billing_Last_Name__c = 'testLastName';
			lp.ARV_Billing_Phone__c = PHONE;
			lp.ARV_Billing_State__c = 'AL';
			lp.ARV_Billing_Zip_Code__c = '48005';
			return lp;
		}

		/************
		Method name: Package Location Segment Reationship
		Params: Id packId, Id lockpckId
		Return Type: Package Location Segment Reationship
		Description: pkglocsgmrelRec (Id packId, Id lockpckId)
		**************/
		public static Contract  ContractForPartB(Id accId)
		{
			Contract contrct = new Contract();
			contrct.AccountId=accId;
			contrct.ARV_Mutual_Voter_First_Name__c='testFirstName';
			contrct.ARV_Mutual_Voter_Last_Name__c = 'testLastName';
			contrct.ARV_Mutual_Voter_Email__c = 'test@gmail.com';
			contrct.ARV_Mutual_Voter_Mailing_State__c = 'AL';
			contrct.ARV_Mutual_Voter_Mailing_Zip__c = '48005';
			contrct.ARV_Mutual_Voter_Mailing_County__c = 'County1';
			contrct.ARV_Mutual_Voter_Mailing_City__c = 'testCity';
			contrct.ARV_Mutual_Voter_Mailing_Address__c = 'test1';
			contrct.ARV_CEO_First_Name__c = 'testFirstName';
			contrct.ARV_CEO_Last_Name__c = 'testLastName';
			contrct.ARV_CEO_Email__c = 'test@gmail.com';
			contrct.ARV_CEO_Phone__c = PHONE;
			contrct.ARV_Principal_Admin_Email__c = 'test@gmail.com';
			contrct.ARV_Principal_Admin_First_Name__c = 'testFirstName';
			contrct.ARV_Principal_Admin_Last_Name__c = 'testLastName';
			return contrct ;
		}    
		/************
		Method name: Package Location Segment Reationship
		Params: Id packId, Id lockpckId
		Return Type: Package Location Segment Reationship
		Description: pkglocsgmrelRec (Id packId, Id lockpckId)
		**************/
		public static Package_Location_Segment_Rel__c  pkglocsgmrelRec(Id pck,Id locpkg)
		{
			Package_Location_Segment_Rel__c plsr = new Package_Location_Segment_Rel__c();

			plsr.Location_Segment__c=locpkg;
			plsr.Package__c=pck;

			return plsr;
		}
		/**************  
		Method name : quote
		Params     : Id OppId,Id prbId,Id UserId,Id Census
		Return Type :Quote
		Description :quoteRec2() Method
		*************/  
		public static Quote quoteRec2(Id OppId,Id prbId,Id UserId,Id CensusId)
		{
			Quote q2=new Quote();
			q2.Name='quote';
			q2.opportunityId=OppId;
			q2.pricebook2Id=prbId;
			q2.Requested_Effective_Date__c=system.today();
			q2.Agent_Name__c=UserId;
			q2.vlocity_ins__GroupCensusId__c=CensusId;
			q2.ARV_IsCensus2Check__c='No';
			q2.ARV_CF02_SelectedPlans__c='Medical;Dental;Vision';
			return q2;
		}  
		/**************  
		Method name : UsrRec
		Params      : string profileName,Id contactId
		Return Type :User
		Description :UsrRec1() Method
		*************/ 
		public static User UsrRec1(string profileName,Id contactId)
		{
			string profId = [SELECT Id FROM Profile WHERE Name = :profileName limit 1].Id;
			User usr1 = new User();
			usr1.ProfileId = profId;
			usr1.ContactId=contactId;
			usr1.LastName = 'last';
			usr1.Email = 'bcbsm@bcbsm.com';
			usr1.Username = 'bcbsm@bcbsm.com';
			usr1.CompanyName = 'TEST';
			usr1.Title = 'title';
			usr1.Alias = 'alias';
			usr1.TimeZoneSidKey = 'America/Los_Angeles';
			usr1.EmailEncodingKey = 'UTF-8';
			usr1.LanguageLocaleKey = 'en_US';
			usr1.LocaleSidKey = 'en_US';
			usr1.EmployeeNumber='123';
			return usr1;
		}


		/**************  
		Method name : quotedRateBreakout
		Params      : NA
		Return Type :QuotedPlanRateBreakout
		Description :quoteBreakoutRec1() Method
		*************/  
		public static vlocity_ins__QuoteLineItemRateBreakout__c quoteBreakoutRec1(Id quoteId,Id productId)
		{
			vlocity_ins__QuoteLineItemRateBreakout__c qlirb=new vlocity_ins__QuoteLineItemRateBreakout__c();
			qlirb.vlocity_ins__QuoteId__c=quoteId;
			qlirb.Product_Id__c=productId;
			qlirb.vlocity_ins__TotalPrice__c=1.0;
			//qlirb.vlocity_ins__CensusMemberId__c=censusId;
			return qlirb;
		}   
		/**************  
		Method name : groupCensus
		Params      : NA
		Return Type :census
		Description :groupCensus() Method
		*************/ 
		public static vlocity_ins__GroupCensus__c groupCensus(Id accId)
		{
			vlocity_ins__GroupCensus__c census=new vlocity_ins__GroupCensus__c();
			census.name='text';
			census.vlocity_ins__GroupId__c=accId;
			census.vlocity_ins__CensusStatus__c = 'active';
			return census;
		}
		/**************  
		Method name : groupCensus
		Params      : NA
		Return Type :census
		Description :groupCensus() Method
		*************/ 
		public static vlocity_ins__GroupCensusMember__c groupCensusMember(Id censusId)
		{
			vlocity_ins__GroupCensusMember__c censusMem=new vlocity_ins__GroupCensusMember__c();
			censusMem.Name='Census123456789147';
			censusMem.Status__c='Enrolling';
			censusMem.ARV_CDH_Member__c='HSA';
			censusMem.vlocity_ins__CensusId__c=censusId;
			censusMem.ARV_Is_Medical_Selected__c=false;
			censusMem.ARV_Is_Dental_Selected__c=true;
			censusMem.ARV_Is_Vision_Selected__c=false;
			return censusMem;
		}
		/**************  
		Method name : RateGridStaticData
		Params      : NA
		Return Type :ARV_CO02_RateGridStaticData__c
		Description :RateGridStaticData() Method
		*************/ 
		public static ARV_CO02_RateGridStaticData__c RateGridStaticData()
		{
			ARV_CO02_RateGridStaticData__c rateGrid=new ARV_CO02_RateGridStaticData__c();
			rateGrid.ARV_HIOSPlanId__c='15560MIV000001';
			rateGrid.ARV_RatingArea__c='B';
			rateGrid.ARV_EffectiveDate__c=Date.valueOf(System.today().year()+'-'+'04-01');
			rateGrid.productname__c='Census?';
			return rateGrid;
		}
    	/**************  
		Method name : RateGridStaticData
		Params      : NA
		Return Type :ARV_CO02_RateGridStaticData__c
		Description :RateGridStaticData() Method
		*************/ 
		public static ARV_CO02_RateGridStaticData__c RateGridStaticDataGS(String type)
		{
			ARV_CO02_RateGridStaticData__c rateGrid=new ARV_CO02_RateGridStaticData__c();
			rateGrid.ARV_HIOSPlanId__c='15560MIV000001';
			rateGrid.ARV_RatingArea__c='B';
			rateGrid.ARV_EffectiveDate__c=Date.valueOf(System.today().year()+'-'+'04-01');
			rateGrid.productname__c='Census?';
            rateGrid.planType__c=type;
			return rateGrid;
		}
		/**************  
		Method name : commonControlRec
		Params      : NA
		Return Type :GA_Common_Control__c
		Description :commonControlRec() Method
		*************/ 
		Public static GA_Common_Control__c commonControlRec(Id accId){
			GA_Common_Control__c comc=new GA_Common_Control__c();
			comc.GA_Federal_Tax_ID_Number__c='987456123';
			comc.GA_AccountId__c =accId;
			return comc;
		}
		/**************  
		Method name : effectiveDateCustomSetting
		Params      : NA
		Return Type :ARV_CS01_EffectiveDate__c
		Description :effectiveDateCustomSetting
		*************/ 
		/*public static ARV_CS01_EffectiveDate__c effectiveDateCustomSetting()
		{
		ARV_CS01_EffectiveDate__c cs01 =new ARV_CS01_EffectiveDate__c();
		cs01.Name='CS';
		cs01.Broker_Date_Span__c=90;
		cs01.RequestedDates__c='1';
		cs01.EffectiveDateStartYear__c=2019;
		cs01.Broker_Skip_Days__c=-30;
		return cs01 ;
		}*/

		/**************
		Method Name: getSicRecord		
		Params      : NA
		Return Type :GA_SIC_Code__c
		Description :GA_SIC_Code__c() Method
		**************/
		public static GA_SIC_Code__c getSicRecord()
		{
			GA_SIC_Code__c sicobj= new GA_SIC_Code__c();
			sicobj.GA_SIC_Code__c='8661';
			return sicobj;
		}
		/*********
		Method Name:createLocsegmentRecord
		Params      : ContractId, SICID
		Return Type :LocationPackage__c
		Description :to create LocationPackage__c() 
		*********/
		public static LocationPackage__c createLocsegmentRecord(Id conId,Id sicId)
		{
			LocationPackage__c ls= new LocationPackage__c();
			ls.ARV_ContractId__c=conId;
			ls.ARV_CC_SICCode__c=sicId;
			return ls;
		}
		/*********
		Method Name:createLocsegmentRecord
		Params      : NA
		Return Type :Document
		Description :to create Document() 
		*********/
		public static Document createDocumentRecord()
		{
			Document objDoc = new Document();
			objDoc.Body = Blob.valueOf('Text');
			objDoc.ContentType = 'application/pdf';
			objDoc.DeveloperName = 'test_document';
			objDoc.IsPublic = true;
			objDoc.Name = 'Test Document';
			return objDoc;
		}

		/*****************
		Method Name:attachmentRec
		Params      : DocusignId
		Return Type :Document
		Description :Creates Attachment record.
		************/
		public static Attachment attachmentRec(Id docsig){
			Attachment attach1= new Attachment();
			attach1.name='test  attach';
			attach1.Body= Blob.valueof('attachment body this is');
			attach1.ParentId=docsig;
			return attach1;
		}
		/*********
		Method Name:docusignstatusRec
		Params      : NA
		Return Type :dsfs__DocuSign_Status__c
		Description :to change the status of Docusign status.
		*********/
		public static dsfs__DocuSign_Status__c docusignstatusRec()
		{
			dsfs__DocuSign_Status__c docsig= new dsfs__DocuSign_Status__c();
			docsig.dsfs__Envelope_Status__c='Completed';
			return docsig;

		}
      /*********
		Method Name:groupSegmentRec
		Params      : AccountId,ContractId
		Return Type :GA_Group_Segment__c
		Description :to change the status of Docusign status.
		*********/
    public static GA_Group_Segment__c groupSegmentRec(Id accId,Id contId){
            GA_Group_Segment__c gseg=new GA_Group_Segment__c();
            gseg.GA_Account__c=accId;
            gseg.Status__c='Pending';
            gseg.GA_Group_Name__c='heurhfuekthhy';
            gseg.ARV_ContractID__c=contId;
            return gseg;
    }
     /*********
		Method Name:groupSegmentRec
		Params      : AccountId,ContractId
		Return Type :GA_Group_Segment__c
		Description :to change the status of Docusign status.
		*********/
    public static GA_Group_Segment__c groupSegmentRec1(Id accId,Id contId, Id plsrId){
            GA_Group_Segment__c gseg=new GA_Group_Segment__c();
            gseg.Name='GS-1012';
            gseg.GA_Account__c=accId;
            gseg.Status__c='Active';
            gseg.ARV_ContractID__c=contId;
            gseg.ARVPackage_Location_Segment_Relationship__c=plsrId;
            gseg.ARV_GS_Dental_Type__c='Voluntary';
            gseg.ARV_GS_Vision_Type__c='Voluntary';
            gseg.GA_Suite__c='SUITE A';
       return gseg;
    }
	/*********
		Method Name:groupSegmentRec
		Params      : AccountId,ContractId
		Return Type :GA_Group_Segment__c
		Description :to change the status of Docusign status.
		*********/
    public static GA_Group_Segment__c groupSegmentRec2(Id accId,Id contId){
            GA_Group_Segment__c gseg=new GA_Group_Segment__c();
            gseg.Name='GS-1012';
            gseg.GA_Account__c=accId;
            gseg.Status__c='Active'; 	
       		gseg.GA_Carrier__c='BCBSM';
            gseg.ARV_ContractID__c=contId;
            
       return gseg;
    }
    /*****************
		Method Name:contenntversinRec
		Params      : String Title
		Return Type :ContentVersion
		Description :Creates ContentVersion record.
		************/
		public static contentversion  contenntversinRec(String Title){
            ContentVersion cntvs=New ContentVersion();
                cntvs.Title = Title;
                cntvs.PathOnClient = Title +'.pdf';
                cntvs.VersionData = Blob.valueOf('Test Content');
                cntvs.IsMajorVersion = true;
            
        return cntvs;
            
        }
     /*****************
		Method Name:contentDocLink
		Params      : Id contentDocId,Id sobjectId
		Return Type :ContentDocumentLink
		Description :Creates ContentDocumentLink record.
		************/
		public static ContentDocumentLink contentDocLink( Id contentDocId,Id sobjectId){
            ContentDocumentLink cdl=New ContentDocumentLink();
                cdl.LinkedEntityId =SobjectId;
                cdl.ContentDocumentId = ContentDocId;
                cdl.shareType = 'V';  
        return cdl;
            
        }

    /*****************
		Method Name: managingagencyhistory
		Params      : Id accId,Id gsegId
		Return Type :ContentDocumentLink
		Description :Creates Managing agency history Record
		************/
		public static GA_Managing_Agency_History__c managingagencyhistory( Id accId,Id gsegId ){
           GA_Managing_Agency_History__c mah=New GA_Managing_Agency_History__c();
        mah.GA_Managing_Agency__c=accId;
        mah.GA_Group_Segment__c=gsegId;
        mah.GA_End_Date__c=system.today();
        mah.GA_Start_Date__c=system.today();
        mah.name='abc'; 
        return mah;
            
        }
    /*****************
		Method Name: GWC Transaction table
		Params      : Id 
		Description :Creates Managing agency history Record
		************/
		public static ARV_GWC_Transaction_Table__c gwcTransaction(Id accId){
           ARV_GWC_Transaction_Table__c gwc=New ARV_GWC_Transaction_Table__c();
            gwc.Account_ID__c = accId;
        	gwc.Status__c= 'In Progress';
        	gwc.RecordTypeId='0126w000000GrHX';
        	gwc.GWC_Batch_ID__c = 'G601013';
            
            return gwc;
        }
}