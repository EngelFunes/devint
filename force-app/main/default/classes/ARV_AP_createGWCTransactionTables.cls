/*****************************************************************************************
Class Name   : ARV_AP_createGWCTransactionTables
Date Created : 20/10/2020
Created By   : IDC Offshore
Description  : This is the class for GWC Transaction Table creation
******************************************************************************************/
global without sharing class ARV_AP_createGWCTransactionTables implements vlocity_ins.VlocityOpenInterface2 {
    private static final string STARTINGARRAY='[';
    private static final string ENDINGARRAY=']'; 
    global static integer countGS = 0;
    global static integer countfinal;
    private static String batchId;
    private static String READYFORINTEGRATION='Ready for Integration';
    private static String GWCTRANSLIST1='gwcTransactionsList1';
    private static string CONTEXTID='ContextId';    
    private static string MAINTENANCECHANGE='MaintenanceChange';
    private static string MAINTENANCE='Maintenance Change';
    private static string CONTACTINFO='ContactInfo';
    private static string ACCINFO='AccountInfo';
    private static String SICCODEBLK='TypeAhead_SICCode-Acc-Block';
    private static String PHYADDACC='PhysicalAddress-Acc';
    private static String ACCCNTS='AccountContacts';
    private static string ADDCOMCONTROL='Add_Common_Control';
    private static string GWCDEETS='GWCDetails';
    private static string RATINGAREA='RatingArea';
    private static string MAT1OUTPUT='mat1output';
    private static string GRPSEGUPD='GroupSegmentUpdate';
    private static string ADDCC='Add Common Control';
    private static string CMPNYWASCHGD='f_CompanyName_WasChanged';
    private static string  BUSINESSDBACHGD='f_DoingBusinessAsDBA_WasChanged';
    private static string FEDTAXCHGD='f_FederalTaxID_WasChanged';
    private static string SICWASCHGD='f_SICCode_WasChanged';
    private static string SPONPLANWASCHGD='f_SponsoredPlanAcronym_WasChanged';
    private static string PHYADDWASCHGD='f_PhysicalAddress_WasChanged';
    private static string MAILADDWASCHGD='f_MailingAddress_WasChanged';
    private static string CEOWASCHGD='f_CEO_WasChanged';
    private static string PRNCIADMINWASCHGD='f_PrincipalAdmin_WasChanged';
    private static string MUTUALVOTERWASCHGD='f_MutualVoter_WasChanged';
    private static string TYPSICCODEACC='TypeAhead_SICCode-Acc';
    private static String ACCUPD='AccountUpdate';
    private static String  FNAMECHGD='f_FirstName_WasChanged'; 
    private static String LNAMECHGD='f_LastName_WasChanged';
    private static String PHNCHGD='f_Phone_WasChanged';
    private static String  EMAILCHGD='f_Email_WasChanged';
    private static String MAILSTRTCHGD='f_MailingStreet_WasChanged';
    private static String MAILCITYCHGD='f_MailingCity_WasChanged';
    private static String  MAILSTATECODECHGD='f_MailingStateCode_WasChanged';
    private static String  MAILPOSTCODECHGD='f_MailingPostalCode_WasChanged';
    private static String CONTACTORGCONCAT='f_ContactOriginalConcat';
    private static String CONTACTUPDCONCAT='f_ContactUpdatedConcat';
    private static string TRUEVALUE='true';
    private static string CONTACTS='Contacts';
    private static string FEDRTAXID3='FederalTaxID3';
    private static string COMMONCONTROL='Common Control';
    private static string FEDERALTAXID='Federal Tax ID';
    private static string SEGMENTNAME='Segment_Name';
    private static string COMPANYNAME='CompanyName';
    private static string COMPANYNAMEORG='CompanyName_Original';
    private static string DOINGBUSINESSAS='Doing Business As';
    private static string DBA_ORIGINAL='DoingBusinessAsDBA_Original';
    private static string DBA_DBA='DoingBusinessAsDBA';
    private static string DBA_ACCOUNT ='Doing Business As (DBA) - Account';
    private static string FEDRALTAXID_ORG='FederalTaxID_Original';
    private static string FEDTAXID='FederalTaxID';
    private static string FEDTAXIDACC='Federal Tax ID (Account)';
    private static string SICCODE='SIC Code';
    private static string SICCODE_ORG='SICCodeName_Original';
    private static string  SPONSORPLANACR='Sponsor Plan Acronym';
    private static string SPONPLNACR_ORG='SponsoredPlanAcronym_Original';
    Private static string  SPONPLNACR='SponsoredPlanAcronym';
    private static string CEO_ORG='CEOName_Original';
    private static string CEO_UPD='CEOName_Updated';
    private static string PRINCIADMNAME_ORG='PrincipalAdminName_Original';
    private static string PRINCIADMNAME_UPD='PrincipalAdminName_Updated';
    private static string MUTUALVOTER_ORG='MutualVoterName_Original';
    private static string MUTUALVOTER_UPD='MutualVoterName_Updated';
    private static String PHYSICALADDR='Physical Address';
    private static string MAILINGADDR='Mailing Address';
    private static string MAILADDR_ORG='MailingAddress_Original';
    private static string MAILADDR_CONCAT='f_MailingAddress_Concat';
    private static string MAILADDRACC='MailingAddress-Acc';
    private static string PHYADDR_ORG='PhysicalAddress_Original';
    private static string RATINGAREACHANGE='Rating Area Change';
    private static string PHYADDRCONCAT='f_PhysicalAddress_Concat';
    private static string SEGMENTNAMEGWC ='SegmentName';
	private static string FEDTAXIDGWC = 'FederalTaxID';
    
    /*****************************************************************************************
Method Name   : invokeMethod
Created By   : IDC Offshore
Description  : This is the invokeMethod
******************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options)
    {
        Boolean success = true;
        try
        {
            if (methodName == 'createGWCTransactionTable') {
                createGWCTransactionTable(input,output,options);
                
                system.debug('Entered to Invoke Method US3886');
            }
            else if (methodName == 'MaintenanceChangeRecords') {
                MaintenanceChangeRecords(input,output,options);
            }
        }
        catch(Exception e){
            system.debug('Error at::'+e.getLineNumber());
            throw new AuraHandledException(e.getMessage()+e.getlinenumber());
        }
        return success;
    }
    /******************************************************************************************
Method Name   : createGWCTransactionTable
Created By   : IDC Offshore
Description  : This is the method for GWC Transaction Table creation
******************************************************************************************/
    public static void createGWCTransactionTable(Map<String,Object> input, Map<String,Object> output,Map<String,Object> options)
    {
        map<id, id> pckGrpID = new map<Id,Id>();
        try
        {
            String contractId= String.valueof(input.get('contractId'));
            System.debug('contractId US3886'+contractId);
            Id AccountId = [Select Id, AccountId FROM Contract WHERE id=:contractId].AccountId;
            String acntCID = 'G'+ String.valueOf([Select id, CID__c FROM Account WHERE id=:AccountId].CID__c);
            System.debug('AccountId US3886'+AccountId);
            List<ARV_GWC_Transaction_Table__c> gwcTransactionsList = new List<ARV_GWC_Transaction_Table__c>();
            List<Package__c> packagesList = [Select id,Original_Package_Id__c,ARV_GWC_Benefit_Package_Type__c
                                             FROM Package__c WHERE ARV_Contract_Id__c =:contractId ];
            //System.debug('packagesList::'+packagesList);
            //pckGrpID.put(packagesListSelect id, ARV_Package__c FROM GA_Group_Segment__c WHERE ARV_Package__c=:packagesList);
            System.debug('packagesList US3886'+packagesList);
            //Id gwcRecordTypeID = [Select Id From RecordType where sobjecttype = 'ARV_GWC_Transaction_Table__c'and name in ('Group Wide Changes')].Id;
            //System.debug('gwcRecordTypeID US3886'+gwcRecordTypeID);
            Id gwcTTRcrdTypId = Schema.SObjectType.ARV_GWC_Transaction_Table__c.getRecordTypeInfosByName().get('Group Wide Changes').getRecordTypeId();
            
            
            for(Package__c pkg: packagesList)
            {
                //pckGrpID.put(pkg.id,[Select id, ARV_Package__c FROM GA_Group_Segment__c WHERE ARV_Package__c=:pkg.id LIMIT 1].id);
                ARV_GWC_Transaction_Table__c gwcTrans = new ARV_GWC_Transaction_Table__c();
                gwcTrans.Account_ID__c = AccountId;
                gwcTrans.Contract__c = contractId;
                gwcTrans.CreatedDate__c=system.today();
                gwcTrans.GWC_Batch_ID__c = acntCID;
                gwcTrans.Integration_Status__c=ARV_AP41_StringLiteralUtils.REDYFORINTGRTN;
                gwcTrans.Status__c = ARV_AP41_StringLiteralUtils.SUBMITTED;
                gwcTrans.Old_Package_ID__c = [Select id, Original_Package_Id__c 
                                              FROM Package__c WHERE id=:pkg.id].Original_Package_Id__c;
                //System.debug('gwcTrans.Old_Package_ID__c US3886'+gwcTrans.Old_Package_ID__c);
                gwcTrans.New_Package_ID__c = [Select id FROM Package__c WHERE id=:pkg.id].Id;
                //System.debug('gwcTrans.New_Package_ID__c US3886'+gwcTrans.New_Package_ID__c);
                gwcTrans.RecordTypeId = gwcTTRcrdTypId;
                
                system.debug('Entered to createGWCTransactionTable Method US3886');
                if(pkg.ARV_GWC_Benefit_Package_Type__c==ARV_AP41_StringLiteralUtils.MODIFYPACKAGE){
                    gwcTrans.Type__c = ARV_AP41_StringLiteralUtils.MODIFYPACKAGE;
                }
                else if(pkg.ARV_GWC_Benefit_Package_Type__c==ARV_AP41_StringLiteralUtils.ADDLOCATION){
                    gwcTrans.Type__c = ARV_AP41_StringLiteralUtils.ADDLOCATION;
                }
                else if(pkg.ARV_GWC_Benefit_Package_Type__c== ARV_AP41_StringLiteralUtils.ADDPACKAGE){
                    gwcTrans.Type__c = ARV_AP41_StringLiteralUtils.ADDPACKAGE;
                }
                else if(pkg.ARV_GWC_Benefit_Package_Type__c==ARV_AP41_StringLiteralUtils.EXBNPKGNC){
                    gwcTrans.Type__c = ARV_AP41_StringLiteralUtils.EXBNPKGNC;
                }
                else if(pkg.ARV_GWC_Benefit_Package_Type__c==ARV_AP41_StringLiteralUtils.RATINGAREAUPD||pkg.ARV_GWC_Benefit_Package_Type__c==ARV_AP41_StringLiteralUtils.RATARMODBENPKG){
                    gwcTrans.Type__c = ARV_AP41_StringLiteralUtils.RATINGAREA;
                }
                gwcTransactionsList.add(gwcTrans);
                
            }
            
            //logic for common control records
			Map<String,Object> strObjectMap = new Map<String,Object>();
            
			Map<String, Object> GWCStrObj = (map<String, Object>)input.get('Productselection');
			String addCC = String.valueOf(GWCStrObj.get('AddCCSegment'));
			
			String strJsonCC = JSON.serialize(GWCStrObj.get('CommonControlSegment'));
			strJsonCC=strJsonCC.startsWith(STARTINGARRAY)? strJsonCC :STARTINGARRAY+strJsonCC;
			strJsonCC=strJsonCC.endsWith(ENDINGARRAY)? strJsonCC :strJsonCC+ENDINGARRAY;
				
			List<Object> commonControllst = (List<Object>)JSON.deserializeUntyped(strJsonCC);
			
			if(addCC.equals('Yes')){
                
                system.debug('add cc is yes+++');
				//map<String, Object> CCInfoMap = (map<String, Object>)GWCStrObj.get('CommonControlSegment');
								
				if(commonControllst!=null){
                    system.debug('inside commonControllst'+commonControllst);
                    for(Object common:commonControllst){
                        ARV_GWC_Transaction_Table__c gwcTransSeg = new ARV_GWC_Transaction_Table__c();
						ARV_GWC_Transaction_Table__c gwcTransFedTax = new ARV_GWC_Transaction_Table__c();
                        strObjectMap = (map<String, Object>)common;
                        system.debug('cc object map'+strObjectMap);
                        if(String.valueOf(strObjectMap.get(FEDTAXIDGWC))!=null){
                            
                            gwcTransFedTax.Account_ID__c=AccountId;
                            gwcTransFedTax.GWC_Batch_ID__c=acntCID;
                            gwcTransFedTax.Contract__c = contractId;
                            gwcTransFedTax.Type__c=COMMONCONTROL;
                            gwcTransFedTax.Status__c=ARV_AP41_StringLiteralUtils.UNDERREVIEW;
                            gwcTransFedTax.Field_Name__c = FEDERALTAXID;
                            gwcTransFedTax.ARV_Maintenance_Change_Approval_Criteria__c=COMMONCONTROL;
                            gwcTransFedTax.New_Value__c=String.valueOf(strObjectMap.get(FEDTAXIDGWC));
							gwcTransFedTax.ARV_Tech_Federal_Tax_ID__c=String.valueOf(strObjectMap.get(FEDTAXIDGWC)); 
                            gwcTransFedTax.RecordTypeId = gwcTTRcrdTypId;
                            gwcTransFedTax.Is_common_control__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            
							if(String.valueOf(strObjectMap.get(SEGMENTNAMEGWC))!=null){
								gwcTransFedTax.ARV_Tech_Segment_Name__c = String.valueOf(strObjectMap.get(SEGMENTNAMEGWC));
							}
							
                            gwcTransFedTax.CreatedDate__c=system.today();
                            gwcTransactionsList.add(gwcTransFedTax);
                        }
						
                        if(String.valueOf(strObjectMap.get(SEGMENTNAMEGWC))!=null){
                            gwcTransSeg.Account_ID__c=AccountId;
                            gwcTransSeg.GWC_Batch_ID__c=acntCID;
                            gwcTransSeg.Contract__c = contractId;
                            gwcTransSeg.Type__c=COMMONCONTROL;
                            gwcTransSeg.Status__c=ARV_AP41_StringLiteralUtils.UNDERREVIEW;
                            gwcTransSeg.Field_Name__c = SEGMENTNAME;
                            gwcTransSeg.ARV_Maintenance_Change_Approval_Criteria__c=COMMONCONTROL;
                            gwcTransSeg.New_Value__c=String.valueOf(strObjectMap.get(SEGMENTNAMEGWC));
							gwcTransSeg.ARV_Tech_Segment_Name__c=String.valueOf(strObjectMap.get(SEGMENTNAMEGWC)); 
                            gwcTransSeg.RecordTypeId = gwcTTRcrdTypId;
                            gwcTransSeg.Is_common_control__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            
							if(String.valueOf(strObjectMap.get(FEDTAXIDGWC))!=null){
								gwcTransSeg.ARV_Tech_Federal_Tax_ID__c = String.valueOf(strObjectMap.get(FEDTAXIDGWC));
							}
							
                            gwcTransSeg.CreatedDate__c=system.today();
                            gwcTransactionsList.add(gwcTransSeg);
                        }
                    }
                }
			}
            
            if(gwcTransactionsList != null && !gwcTransactionsList.isEmpty()){
                database.insert(gwcTransactionsList);
            }
            output.put(GWCTRANSLIST1, true);
            System.debug('gwcTransactionsList US3886'+gwcTransactionsList);
        }
        Catch(Exception e){
            // throw new AuraHandledException(e.getMessage()+e.getlinenumber());
            GA_LogExceptionCls.LogExcp(e, 'ARV_AP_createGWCTransactionTables', 'createGWCTransactionTable');
        }
        
    }
    /*****************************************************************************************
Method Name   : MaintenanceChangeREcords
Created By   : IDC Offshore
Description  : This is the method for GWC Transaction Table creation
******************************************************************************************/
    public static void MaintenanceChangeRecords(Map<String,object> input,Map<String,object> output,Map<String,object> options){
        try{
            system.debug('inside the loop');
            Id mntnceRecordTypeID = Schema.SObjectType.ARV_GWC_Transaction_Table__c.getRecordTypeInfosByName().get(MAINTENANCE).getRecordTypeId();
            List<ARV_GWC_Transaction_Table__c> mntnceTransactionsList = new List<ARV_GWC_Transaction_Table__c>();
            String accountStrngId= String.valueOf(input.get(CONTEXTID));//since the context ID is Account here
            String cidAcnt = [Select id, CID__c from Account where id=:accountStrngId].CID__c;
            String batchAcntCID = updateBatchId();
            system.debug('batchidCID'+batchAcntCID);
            map<String, Object> strObjctMap = new map<String, Object>();
            List<ARV_GWC_Transaction_Table__c> gwcTransactionsList = new List<ARV_GWC_Transaction_Table__c>();
            map<String, Object> mainteanceStrObj = (map<String, Object>)input.get (MAINTENANCECHANGE);
            string strJson = JSON.serialize(mainteanceStrObj.get(CONTACTINFO));
            system.debug('strJson@@'+strJson);
            strJson=strJson.startsWith(STARTINGARRAY)? strJson :STARTINGARRAY+strJson;
            strJson=strJson.endsWith(ENDINGARRAY)? strJson :strJson+ENDINGARRAY;
            system.debug('strJson@@'+strJson);
            List<Object> contactinfoNode = (List<Object>)JSON.deserializeUntyped(strJson);
            system.debug('strJson@@'+strJson);
            map<String, Object> accountInfoMap = (map<String, Object>)mainteanceStrObj.get(ACCINFO);
            map<String,object> spablckMap= (map<String, Object>)accountInfoMap.get('TypeAhead_SponsoredPlanAcronym-Block');
            system.debug('spablckMap:: '+spablckMap);
            system.debug('strJson@@'+strJson);
            map<String, Object> TypeAheadSICMap = (map<String,Object>)accountInfoMap.get(SICCODEBLK);
            map<String, Object> physicaladdr = (map<String, Object>)accountInfoMap.get(PHYADDACC);
            map<String, Object> AccCon = (map<String, Object>)accountInfoMap.get(ACCCNTS);
            //map<String, Object> commonControlMap = (map<String, Object>)mainteanceStrObj.get('Add_Common_Control');
            string strJson1 = JSON.serialize(mainteanceStrObj.get(ADDCOMCONTROL));
            system.debug('strJson@@'+strJson1);
            strJson1=strJson1.startsWith(STARTINGARRAY)? strJson1 :STARTINGARRAY+strJson1;
            strJson1=strJson1.endsWith(ENDINGARRAY)? strJson1 :strJson1+ENDINGARRAY;
            system.debug('strJson@@'+strJson1);
            //String RatingArea=String.valueOf(input.get('RatingAreaChanged'));
            /*map<String, Object> gwcdetailsMap = (map<String, Object>)input.get(GWCDEETS);
            system.debug('GWCdetails'+gwcdetailsMap);*/
            String RatingArea1=String.valueOf(input.get(RATINGAREA));
            String Mat1Output1=String.valueOf(input.get(MAT1OUTPUT));
            system.debug('rating'+RatingArea);
            system.debug('Mat1Output'+Mat1Output);
            
            //List<object> commonControllst=(List<Object>)mainteanceStrObj.get('Add_Common_Control');
            List<Object> commonControllst = (List<Object>)JSON.deserializeUntyped(strJson1);
            
            system.debug('-SV-----'+commonControllst);
            // system.debug('commonControlMap'+commonControlMap);
            System.debug('physicaladdr@@'+physicaladdr);
            map<string,Object> strObjectMap;
            
            //manage Account here
            String accountUpdate = String.valueOf(mainteanceStrObj.get(ACCUPD));
            system.debug('sv--'+accountUpdate);
            String gsUpdate = String.valueOf(mainteanceStrObj.get(GRPSEGUPD));
            String accinfoChngd= String.valueOf(accountInfoMap.get(CMPNYWASCHGD));
            system.debug('accinfoChngd@@::'+accinfoChngd);
            String dbaChngd= String.valueOf(accountInfoMap.get(BUSINESSDBACHGD));
            String fedtaxchngd= String.valueOf(accountInfoMap.get(FEDTAXCHGD));
            String sicChngd= String.valueOf(accountInfoMap.get(SICWASCHGD));
            String spaChngd= String.valueOf(accountInfoMap.get(SPONPLANWASCHGD));
            String physAddChgd= String.valueOf(accountInfoMap.get(PHYADDWASCHGD));
            String mailAddChngd= String.valueOf(accountInfoMap.get(MAILADDWASCHGD));
            String ceochange= String.valueOf(AccCon.get(CEOWASCHGD));
            String prinadmin= String.valueOf(AccCon.get(PRNCIADMINWASCHGD));
            String mutualvoter= String.valueOf(AccCon.get(MUTUALVOTERWASCHGD));
            String typeahead = String.valueOf(TypeAheadSICMap.get(TYPSICCODEACC));
            System.debug('TypeAheadSICMap@@ '+TypeAheadSICMap);
            System.debug('fedtaxchngd::'+fedtaxchngd);
            System.debug('dbaChngd::'+dbaChngd);
            System.debug('accinfoChngd::'+accinfoChngd);
            system.debug('-SV-----'+accountUpdate);
            if(accountUpdate.contains(ADDCC)){
                system.debug('-SV-----'+accountUpdate);
                
                system.debug('CCList'+commonControllst);
                if(commonControllst!=null){
                    for(Object common:commonControllst){
                        strObjectMap = (map<String, Object>)common;
                        if(String.valueOf(strObjectMap.get(FEDRTAXID3))!=null){
                            ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                            mntnceTrans.Account_ID__c=accountStrngId;
                            mntnceTrans.GWC_Batch_ID__c=batchAcntCID;
                            mntnceTrans.Type__c=COMMONCONTROL;
                            mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.UNDERREVIEW;
                            mntnceTrans.Field_Name__c = FEDERALTAXID;
                            mntnceTrans.ARV_Maintenance_Change_Approval_Criteria__c=COMMONCONTROL;
                            mntnceTrans.New_Value__c=String.valueOf(strObjectMap.get(FEDRTAXID3));
							mntnceTrans.ARV_Tech_Federal_Tax_ID__c=String.valueOf(strObjectMap.get(FEDRTAXID3)); 
                            mntnceTrans.RecordTypeId = mntnceRecordTypeID;
                            mntnceTrans.Is_common_control__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                            
							if(String.valueOf(strObjectMap.get(SEGMENTNAME))!=null){
								mntnceTrans.ARV_Tech_Segment_Name__c = String.valueOf(strObjectMap.get(SEGMENTNAME));
							}
							
                            mntnceTrans.CreatedDate__c=system.today();
                            countGS++;
                            system.debug('CommonControlDebugExecuted');
                            insert mntnceTrans;
                            system.debug('CommonControlDebug'+mntnceTrans);
                        }
                        if(String.valueOf(strObjectMap.get(SEGMENTNAME))!=null){
                            ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                            mntnceTrans.Account_ID__c=accountStrngId;
                            mntnceTrans.GWC_Batch_ID__c=batchAcntCID;
                            mntnceTrans.Type__c=COMMONCONTROL;
                            mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.UNDERREVIEW;
                            mntnceTrans.Field_Name__c = SEGMENTNAME;
                            mntnceTrans.ARV_Maintenance_Change_Approval_Criteria__c=COMMONCONTROL;
                            mntnceTrans.New_Value__c=String.valueOf(strObjectMap.get(SEGMENTNAME));
                            mntnceTrans.RecordTypeId = mntnceRecordTypeID;
                            mntnceTrans.Is_common_control__c=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
							
							if(String.valueOf(strObjectMap.get(FEDRTAXID3))!=null){
								mntnceTrans.ARV_Tech_Federal_Tax_ID__c=String.valueOf(strObjectMap.get(FEDRTAXID3));
							}
                            
                            mntnceTrans.CreatedDate__c=system.today();
                            countGS++;
                            
                            insert mntnceTrans;
                        }
                    }
                }
                
            }
            
            if(accountUpdate!=null){
                if(accinfoChngd==TRUEVALUE)
                {
                    ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                    mntnceTrans.Field_Name__c =COMPANYNAME;
                    mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.INPROGRESS;
                    mntnceTrans.Old_Value__c = String.valueOf(accountInfoMap.get(COMPANYNAMEORG));
                    mntnceTrans.New_Value__c = String.valueOf(accountInfoMap.get(COMPANYNAME));
                    mntnceTrans.Account_ID__c  =accountStrngId;
                    mntnceTrans.Type__c = COMPANYNAME;
                    mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
                    mntnceTrans.RecordTypeId = mntnceRecordTypeID;
                    mntnceTrans.CreatedDate__c=system.today();
                    countGS++;
                    insert mntnceTrans; 
                }
            }
            /*
* "Company Name;Doing Business As;Federal Tax ID;SIC Code;Sponsor Plan Acronym;Contacts;Physical Address;Mailing Address",
*/           if(dbaChngd!=null){
    if(dbaChngd==TRUEVALUE)
    {
        ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
        mntnceTrans.Field_Name__c = DOINGBUSINESSAS;
        mntnceTrans.Old_Value__c = String.valueOf(accountInfoMap.get(DBA_ORIGINAL));
        mntnceTrans.New_Value__c = String.valueOf(accountInfoMap.get(DBA_DBA));
        mntnceTrans.Account_ID__c  =accountStrngId;
        mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.INPROGRESS;
        mntnceTrans.CreatedDate__c=system.today();
        mntnceTrans.Type__c = DBA_ACCOUNT;
        mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
        mntnceTrans.RecordTypeId = mntnceRecordTypeID;
        countGS++;
        insert mntnceTrans;
    }
}
            if(fedtaxchngd!=null){
                if(fedtaxchngd==TRUEVALUE)
                {
                    ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                    mntnceTrans.Field_Name__c = FEDERALTAXID;
                    mntnceTrans.Old_Value__c = String.valueOf(accountInfoMap.get(FEDRALTAXID_ORG));
                    mntnceTrans.New_Value__c = String.valueOf(accountInfoMap.get(FEDTAXID));
                    mntnceTrans.Account_ID__c  =accountStrngId;
                    mntnceTrans.Type__c = FEDTAXIDACC;
                    mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.INPROGRESS;
                    mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
                    mntnceTrans.RecordTypeId = mntnceRecordTypeID;
                    mntnceTrans.CreatedDate__c=system.today();
                    countGS++;
                    insert mntnceTrans;
                }
            }
            if(sicChngd!=null){
                if(sicChngd=='true')
                {
                    ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                    mntnceTrans.Field_Name__c = SICCODE;
                    mntnceTrans.Old_Value__c = String.valueOf(accountInfoMap.get(SICCODE_ORG));
                    mntnceTrans.New_Value__c = String.valueOf(TypeAheadSICMap.get(TYPSICCODEACC));
                    mntnceTrans.Account_ID__c  =accountStrngId;
                    mntnceTrans.Type__c = SICCODE;
                    mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.INPROGRESS;
                    mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
                    mntnceTrans.RecordTypeId = mntnceRecordTypeID;
                    mntnceTrans.CreatedDate__c=system.today();
                    countGS++;
                    insert mntnceTrans;
                }
            }
            if(spaChngd!=null){
                if(spaChngd==TRUEVALUE)
                {
                    ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                    mntnceTrans.Field_Name__c = SPONSORPLANACR;
                    mntnceTrans.Old_Value__c = String.valueOf(accountInfoMap.get(SPONPLNACR_ORG));
                    mntnceTrans.New_Value__c = String.valueOf(spablckMap.get('TypeAhead_SponsoredPlanAcronym'));
                    mntnceTrans.Account_ID__c  =accountStrngId;
                    mntnceTrans.Type__c = SPONSORPLANACR;
                    mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.INPROGRESS;
                    mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
                    mntnceTrans.RecordTypeId = mntnceRecordTypeID;
                    mntnceTrans.CreatedDate__c=system.today();
                    countGS++;
                    insert mntnceTrans;
                }
            }
            if(ceochange!=null){
                if(ceochange==TRUEVALUE)
                {
                    ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                    mntnceTrans.Field_Name__c = CONTACTS;
                    mntnceTrans.Old_Value__c = String.valueOf(AccCon.get(CEO_ORG));
                    mntnceTrans.New_Value__c = String.valueOf(AccCon.get(CEO_UPD));
                    mntnceTrans.Account_ID__c  =accountStrngId;
                    mntnceTrans.Type__c = CONTACTS;
                    mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.INPROGRESS;
                    mntnceTrans.CreatedDate__c=system.today();
                    mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
                    mntnceTrans.RecordTypeId = mntnceRecordTypeID;
                    countGS++;
                    insert mntnceTrans;  
                }
            }
            if(prinadmin!=null){
                if(prinadmin==TRUEVALUE)
                {
                    ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                    mntnceTrans.Field_Name__c = CONTACTS;
                    mntnceTrans.Old_Value__c = String.valueOf(AccCon.get(PRINCIADMNAME_ORG));
                    mntnceTrans.New_Value__c = String.valueOf(AccCon.get(PRINCIADMNAME_UPD));
                    mntnceTrans.Account_ID__c  =accountStrngId;
                    mntnceTrans.Type__c = CONTACTS;
                    mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.INPROGRESS;
                    mntnceTrans.CreatedDate__c=system.today();
                    mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
                    mntnceTrans.RecordTypeId = mntnceRecordTypeID;
                    countGS++;
                    insert mntnceTrans;   
                }
            }
            if(mutualvoter!=null){
                if(mutualvoter==TRUEVALUE)
                {
                    ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                    mntnceTrans.Field_Name__c = CONTACTS;
                    mntnceTrans.Old_Value__c = String.valueOf(AccCon.get(MUTUALVOTER_ORG));
                    mntnceTrans.New_Value__c = String.valueOf(AccCon.get(MUTUALVOTER_UPD));
                    mntnceTrans.Account_ID__c  =accountStrngId;
                    mntnceTrans.Type__c = CONTACTS;
                    mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.INPROGRESS;
                    mntnceTrans.CreatedDate__c=system.today();
                    mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
                    mntnceTrans.RecordTypeId = mntnceRecordTypeID;
                    countGS++;
                    insert mntnceTrans;   
                }
            }
            if(physAddChgd!=null){
                if(physAddChgd==TRUEVALUE)
                    
                {
                    ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                    mntnceTrans.Field_Name__c = 'Physical Address';
                    mntnceTrans.Old_Value__c = String.valueOf(physicaladdr.get(PHYADDR_ORG));
                    mntnceTrans.New_Value__c = String.valueOf(physicaladdr.get(PHYADDRCONCAT));
                    mntnceTrans.Account_ID__c  =accountStrngId;
                    // mntnceTrans.RatingAreaFlag__c=boolean.valueof(RatingArea);
                    if(RatingArea1!=Mat1Output1){
                        mntnceTrans.RatingAreaFlag__c=true;
                        Boolean flag=mntnceTrans.RatingAreaFlag__c;
                        system.debug('flag'+flag);
                    }
                    if(mntnceTrans.RatingAreaFlag__c==true){
                        mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.UNDERREVIEW; 
                        mntnceTrans.ARV_Maintenance_Change_Approval_Criteria__c =RATINGAREACHANGE;
                    }
                    else
                    {
                        mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.INPROGRESS;
                    }
                    mntnceTrans.Type__c = 'Physical Address';
                    mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
                    mntnceTrans.CreatedDate__c=system.today();
                    mntnceTrans.RecordTypeId = mntnceRecordTypeID; 
                    countGS++;
                    insert mntnceTrans;
                    
                }
            }
            if(mailAddChngd!=null){
                if(mailAddChngd==TRUEVALUE)
                {
                    Map<String,object> mailmap= (Map<String,object>)accountInfoMap.get(MAILADDRACC);
                    ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                    mntnceTrans.Field_Name__c = MAILINGADDR;
                    mntnceTrans.Old_Value__c = String.valueOf(mailmap.get(MAILADDR_ORG));
                    mntnceTrans.New_Value__c = String.valueOf(mailmap.get(MAILADDR_CONCAT));
                    mntnceTrans.Account_ID__c  =accountStrngId;
                    mntnceTrans.Type__c = MAILINGADDR;
                    mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
                    mntnceTrans.CreatedDate__c=system.today();
                    mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.INPROGRESS;
                    mntnceTrans.RecordTypeId = mntnceRecordTypeID;
                    countGS++;
                    insert mntnceTrans;
                    
                }
            }
            
            if(contactinfoNode!=null){
                System.debug('@@ inside loop '+ contactinfoNode);
                for(object con :contactinfoNode)
                {
                    strObjectMap = (map<String, Object>)con;
                    System.debug('strObjectMap@@ '+ strObjectMap);
                    if(String.valueOf(strObjectMap.get(FNAMECHGD))==TRUEVALUE|| 
                       String.valueOf(strObjectMap.get(LNAMECHGD))==TRUEVALUE||
                       String.valueOf(strObjectMap.get(PHNCHGD))==TRUEVALUE||
                       String.valueOf(strObjectMap.get(EMAILCHGD))==TRUEVALUE ||
                       String.valueOf(strObjectMap.get(MAILSTRTCHGD))==TRUEVALUE ||
                       String.valueOf(strObjectMap.get(MAILCITYCHGD))==TRUEVALUE ||
                       String.valueOf(strObjectMap.get(MAILSTATECODECHGD))==TRUEVALUE ||
                       String.valueOf(strObjectMap.get(MAILPOSTCODECHGD))==TRUEVALUE 
                      ){
                          ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                          mntnceTrans.Field_Name__c = CONTACTS;
                          mntnceTrans.Old_Value__c = String.valueOf(strObjectMap.get(CONTACTORGCONCAT));
                          mntnceTrans.New_Value__c = String.valueOf(strObjectMap.get(CONTACTUPDCONCAT));
                          system.debug('f_ContactOriginalConcat@'+String.valueOf(strObjectMap.get('f_ContactOriginalConcat')));
                          system.debug('f_ContactUpdatedConcat@'+String.valueOf(strObjectMap.get('f_ContactUpdatedConcat')));
                          mntnceTrans.Account_ID__c  =accountStrngId;
                          mntnceTrans.Type__c = CONTACTS;
                          mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
                          mntnceTrans.CreatedDate__c=system.today();
                          mntnceTrans.Status__c=ARV_AP41_StringLiteralUtils.INPROGRESS;
                          mntnceTrans.RecordTypeId = mntnceRecordTypeID;
                          countGS++;
                          insert mntnceTrans;
                      }
                    system.debug('CountGS'+countGS);
                    //ARV_AP15_CallOutUtils.countAcc = countGS;
                    //system.debug('countAccount'+ARV_AP15_CallOutUtils.countAcc);
                    //updateCustomSettingsMainCounter(countGS);
                    system.debug('GWCtime'+system.now());
                }
            }
            system.debug('UniquBTID'+batchAcntCID);
            output.put('UniqueBatchID',batchAcntCID);
        }
        Catch(Exception e){
            //throw new AuraHandledException(e.getMessage()+e.getlinenumber());
            GA_LogExceptionCls.LogExcp(e, 'ARV_AP_createGWCTransactionTables', 'MaintenanceChangeRecords');
            system.debug('line number@@ US3886 '+e.getLineNumber());
            system.debug('getMessage @@ US3886 '+e.getMessage());
            
            
        }
    }  
    /*public static void updateCustomSettingsMainCounter(Integer count){
ARV_Maintenance_Count__c obj = new ARV_Maintenance_Count__c();
obj.ARV_Transaction_Counter__c = count;
insert obj;
system.debug('in maintenance update cs');

}*/
    public static string updateBatchId(){
        batchId = 'M' + Math.round((Math.random() * (90000) + 10000));
        system.debug('batchID'+batchId);
        return batchId;
    }
}