/**
@Author : IDC offshore
@Name: ARV_AP58_ApproveContract
@CreatedDate: 18 - Sep 2018 
@Description: ARV_AP58_ApproveContract class is to approve contracts
@version : 1.0  
*/
public without sharing class ARV_AP58_ApproveContract
{    
    public static final string CLSNAME = 'ARV_AP58_ApproveContract';
    public static final string CREATEORMERGEACNTMETHDNME = 'createOrMergeAccount';
    public static final string CMNCNTRLCREATEMETHDNME = 'commonControlCreate';
    public static final string ACCTPRSPCTRECORDTYPE=Schema.SObjectType.Account.getRecordTypeInfosByName().
        get('Account - Prospect').getRecordTypeId();
    public static final string ACCTINACTVRECORDTYPE=Schema.SObjectType.Account.getRecordTypeInfosByName().
        get('Account - Inactive').getRecordTypeId();
    public static final string ACCTUNQULFDPRSPCTRECORDTYPE=Schema.SObjectType.Account.getRecordTypeInfosByName().
        get('Unqualified Prospect (Agent)').getRecordTypeId();
    public static final String SLCTLBL='select ';
    public static final String ACCQRY=' from Account where id in ';
    public static final String CMMA=',';
    public static final String EMPTYSTRNG='';
    public static final String CNTCLOOKUPFIELDQUERY='GA_CEO__r.AccountId,'+
        'GA_Decision_Maker__r.AccountId, GA_Principal_Admin__r.AccountId';
    public static final String CNTMATCH = 'From Contact where AccountId in ';
    public static final String OPPRQRY = 'id,AccountId ';
    public static final String CNTCQRY = 'id,AccountId,Name,FirstName,LastName,Email,'+
        'MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,'+
        'GA_Mailing_County_id__c,OtherStreet,OtherCity,OtherState,OtherPostalCode,'+
        'OtherCountry,GA_Physical_County__c,ARV_Is_Mass_Updating__c,ARV_TECH_ContactFullValue__c ';
    public static final String OPPRMATCH = 'from Opportunity where AccountId in ';
    public static final String LCNPKGQRY = 'id,ARV_AccountId__c,ARV_ContractId__c ';
    public static final String LCNPKGMATCH1 = 'from LocationPackage__c where ARV_AccountId__c in ';
    public static final String LCNPKGMATCH2 = ' AND ARV_ContractId__c in ';
    public static final String ACNTTMMBRQRY = 'Id,UserId,TeamMemberRole,AccountId ';
    public static final String ACNTTMMBRMTH = 'from AccountTeamMember WHERE AccountId in ';
    public static final String LMT = ' LIMIT 100';
    public static final String ACNTCNTRLNQRY1 = 'Id,AccountId,ContactId,Contact.AccountId ';
    public static final String ACNTCNTRLNQRY = 'id,AccountId,ContactId ';
    public static final String ACNTCNTRLNMATCH = 'from AccountContactRelation WHERE AccountId in ';
    public static final String ACNTCNTRLNLMT = ' LIMIT 2000';
    public static final String LCNSEGQRY = 'Id, Name, ARV_CC_Fed_Tax_ID__c, ARV_AccountId__c ';
    public static final String LCNMATCHQRY1 = 'FROM LocationPackage__c WHERE (ARV_ContractId__c in ';
    public static final String LCNMATCHQRY2 = ' AND ARV_IsCommonControll__c=TRUE) ';
    public static final String INSRT = 'insert';
    public static final String UPDAT = 'update';
    public static final String DELTE = 'delete';
    public static final String BCBSM = 'BCBS';
    public static final String SUBJECT = 'New BCBSM Group Offering CDH Products';
    public static final String SENDEMAILCDHMTHDNME = 'sendEmailCDH';
    /**
@Description: createOrMergeAccount() method 
@Name : createOrMergeAccount
@Param : unqualifiedProspectId,matchprospectId,contractId
@Return : Account
@throws Exception : N/A;
*/  
    public static Account createOrMergeAccount(String unqualifiedProspectId, String matchprospectId,string contractId,string censusId){
        system.debug('censusId::'+censusId);
        map<string,List<contact>>  contactUQmap= new map<string,List<contact>>();
        map<string,List<contact>>  contactAddMap= new map<string,List<contact>>();
        set<string>  uqStrSet = new set<string>();
        set<string>  contStrSet = new set<string>();
        try
        {
            String accntQry=SLCTLBL;
            String prpUnqulProsptQry = EMPTYSTRNG;
            String prpMtchProspQry = EMPTYSTRNG;
            list<Account> accLst=new list<Account>();
            list<Account> accMatchLst=new list<Account>();
            Account updtAcc = new Account();
            List<Account> accList = new List<Account>();
            for(Schema.FieldSetMember fieldDls : SObjectType.Account.FieldSets.ARV_FS01_UnqualifiedProspectMerge.getFields()) {
                accntQry = accntQry+fieldDls.getFieldPath();
                accntQry=accntQry+CMMA;  
            }
            accntQry=accntQry+CntcLookUpFieldQuery+CMMA;
            if(String.isEmpty(matchprospectId)){  
                updtAcc = new Account(id = unqualifiedProspectId,RecordTypeId=ACCTPRSPCTRECORDTYPE,GA_Is_Mass_Updating__c=true);
                accList.add(updtAcc);
                if(accList.size()>0){
                    List<Database.SaveResult> saveacntList1 = ARV_AP08_DMLHelper.insertSObjects(accList,UPDAT,true);
                    ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(saveacntList1);
                    
                }
                GA_AP_InvokeCIDOnDml.callBCBSMCIDServ(updtAcc.Id);
            }
            else{   
           /* //3020 merge 
           String tempOriginal='';
Account oldacc=[select id,GA_Original_Enrollment_Date__c from account where id=:matchprospectId limit 1];
if(oldacc.GA_Original_Enrollment_Date__c!=null || oldacc.GA_Original_Enrollment_Date__c==null)
tempOriginal= String.valueof(oldacc.GA_Original_Enrollment_Date__c);
oldacc.GA_Original_Enrollment_Date__c=date.valueof(tempOriginal);
update oldacc;
//3020 merge ends here*/        
                Set<Id> unaccSet = new Set<Id>();
                unaccSet.add(unqualifiedProspectId);
                prpUnqulProsptQry =  accntQry.removeEnd(CMMA);
                
                String acnwhere = ACCQRY + GA_Util08_FilterProcessHelper.idSet(unaccSet);
                accLst = ARV_AP07_QueryDataHelper.getsObjects(prpUnqulProsptQry,acnwhere,EMPTYSTRNG,ACNTCNTRLNLMT);
                Set<Id> matchaccSet = new Set<Id>();
                matchaccSet.add(matchprospectId);
                prpMtchProspQry =  accntQry.removeEnd(CMMA);
                String acntwhere = ACCQRY + GA_Util08_FilterProcessHelper.idSet(matchaccSet);
                accMatchLst = ARV_AP07_QueryDataHelper.getsObjects(prpMtchProspQry,acntwhere,EMPTYSTRNG,ACNTCNTRLNLMT);
                Account unqualifiedAcc = accLst[0];
                //Account tempAcc=[select id, GA_Original_Enrollment_Date__c from account where id=:unqualifiedAcc.id]; //for US3020
                //Date temporiginal=tempAcc.GA_Original_Enrollment_Date__c; //for US 3020
                Account matchedAcc = accMatchLst[0];
                List<Contact> updtCntcLst = new List<Contact> ();
                List<Contact> updtMtchedCntcLst = new List<Contact> ();
                List<Contact> deltDuplictCntcLst = new List<Contact> ();
                Set<Id> contSet = new Set<Id>();
                contSet.add(unqualifiedAcc.Id);
                String contqry = SLCTLBL + CNTCQRY;
                String contmach = CNTMATCH + GA_Util08_FilterProcessHelper.idSet(contSet);
                List<Contact> conList = ARV_AP07_QueryDataHelper.getsObjects(contqry,contmach,EMPTYSTRNG,LMT);
                
                //prepare a set with conactFull names
                for(contact cont:conList){
                    uqStrSet.add(cont.ARV_TECH_ContactFullValue__c);                    
                }
                
                //Query contacts under prospcect Accpount using the above set
                List<Contact> matchedContctLst = [select AccountId,Name,FirstName,LastName,Email,MailingStreet,MailingCity,
                                                  MailingState,MailingPostalCode,MailingCountry,GA_Mailing_County_id__c,
                                                  OtherStreet,OtherCity,OtherState,OtherPostalCode,OtherCountry,ARV_TECH_ContactFullValue__c,
                                                  GA_Physical_County__c,ARV_Is_Mass_Updating__c from Contact 
                                                  where ARV_TECH_ContactFullValue__c in: uqStrSet and AccountId=:matchprospectId LIMIT 100];
                //prepare a map where key is contactFullname and value is list of contacts with same values
                if(matchedContctLst.size()>0){
                    for(contact contR:matchedContctLst){
                        if(!contactUQmap.containsKey(contR.ARV_TECH_ContactFullValue__c)){
                            contactUQmap.put(contR.ARV_TECH_ContactFullValue__c,new list<contact>{contR});
                        }
                        else{
                            contactUQmap.get(contR.ARV_TECH_ContactFullValue__c).add(contR);
                        }
                        
                    }                           
                }
                
                for (Contact cntcRcd : conList)
                {
                    // if((cntcRcd.FirstName != null) && (cntcRcd.LastName != null) && (cntcRcd.Email !=null) && (matchprospectId !=null)){
                    /*matchedContctLst = [select id,AccountId,Name,FirstName,LastName,Email,MailingStreet,MailingCity,
MailingState,MailingPostalCode,MailingCountry,GA_Mailing_County_id__c,
OtherStreet,OtherCity,OtherState,OtherPostalCode,OtherCountry,
GA_Physical_County__c,ARV_Is_Mass_Updating__c from Contact 
where FirstName=:cntcRcd.FirstName and LastName=:cntcRcd.LastName 
and Email=:cntcRcd.Email and AccountId=:matchprospectId LIMIT 100];
}*/
                    if(contactUQmap.get(cntcRcd.ARV_TECH_ContactFullValue__c)!=null)
                    {
                        for (Contact mtchedCntcRcd : contactUQmap.get(cntcRcd.ARV_TECH_ContactFullValue__c))
                        {
                            mtchedCntcRcd.MailingStreet = cntcRcd.MailingStreet;
                            mtchedCntcRcd.MailingCity = cntcRcd.MailingCity;
                            mtchedCntcRcd.MailingState = cntcRcd.MailingState;
                            mtchedCntcRcd.MailingPostalCode = cntcRcd.MailingPostalCode;
                            mtchedCntcRcd.MailingCountry = cntcRcd.MailingCountry;
                            mtchedCntcRcd.GA_Mailing_County_id__c = cntcRcd.GA_Mailing_County_id__c;
                            mtchedCntcRcd.OtherStreet = cntcRcd.OtherStreet;
                            mtchedCntcRcd.OtherCity = cntcRcd.OtherCity;
                            mtchedCntcRcd.OtherState = cntcRcd.OtherState;
                            mtchedCntcRcd.OtherPostalCode = cntcRcd.OtherPostalCode;
                            mtchedCntcRcd.OtherCountry = cntcRcd.OtherCountry;
                            mtchedCntcRcd.GA_Physical_County__c = cntcRcd.GA_Physical_County__c;
                            mtchedCntcRcd.ARV_Is_Mass_Updating__c = True;
                            updtMtchedCntcLst.add(mtchedCntcRcd);
                        }
                        deltDuplictCntcLst.add(cntcRcd);
                    }
                    else{
                        cntcRcd.AccountId=matchprospectId;
                        cntcRcd.ARV_Is_Mass_Updating__c=True;
                        //cntcRcd.Account.GA_Original_Enrollment_Date__c=temporiginal; //for US3020
                        updtCntcLst.add(cntcRcd);
                    }
                    
                }
                if(updtCntcLst.size()>0){
                    List<Database.SaveResult> savecntList = ARV_AP08_DMLHelper.insertSObjects(updtCntcLst,UPDAT,true);
                    ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(savecntList);
                }
                if(updtMtchedCntcLst.size()>0){
                    List<Database.SaveResult> saveMtchedCntList = ARV_AP08_DMLHelper.insertSObjects(updtMtchedCntcLst,UPDAT,true);
                    ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(saveMtchedCntList);
                }
                set<id> actCntFieldIds = new set<id>();
                if(unqualifiedAcc.GA_CEO__c != null && unqualifiedAcc.GA_CEO__r.AccountId==unqualifiedAcc.Id){
                    actCntFieldIds.add(unqualifiedAcc.GA_CEO__c);
                }
                if(unqualifiedAcc.GA_Decision_Maker__c  != null && unqualifiedAcc.GA_Decision_Maker__r.AccountId==unqualifiedAcc.Id){
                    actCntFieldIds.add(unqualifiedAcc.GA_Decision_Maker__c);
                }
                if(unqualifiedAcc.GA_Principal_Admin__c != null && unqualifiedAcc.GA_Principal_Admin__r.AccountId==unqualifiedAcc.Id){
                    actCntFieldIds.add(unqualifiedAcc.GA_Principal_Admin__c);
                }
                List<Account> saveUnqPsAccLst = new List<Account>();
                List<Contact> actnContctFieldsLst = new  List<Contact> ();
                if((actCntFieldIds.size()>0) && (deltDuplictCntcLst.size()>0)){
                    actnContctFieldsLst = [select ARV_TECH_ContactFullValue__c,AccountId,Name,FirstName,LastName,
                                           Email from Contact where id in:actCntFieldIds and id in:deltDuplictCntcLst Limit 100];
                    for(contact contr:actnContctFieldsLst){
                        contStrSet.add(contr.ARV_TECH_ContactFullValue__c);
                    }
                }
                List<Contact> prsActnContctFieldsLst = new List<Contact> ();
                if(actnContctFieldsLst.size()>0){
                    
                    //prepare a map where key is contactFullname and value is list of contacts with same values
                    for(contact conts:[select AccountId,Name,FirstName,LastName,Email,ARV_TECH_ContactFullValue__c from Contact 
                                       where ARV_TECH_ContactFullValue__c in: contStrSet and AccountId=:matchprospectId LIMIT 100]){
                                           if(!contactAddMap.containsKey(conts.ARV_TECH_ContactFullValue__c)){
                                               contactAddMap.put(conts.ARV_TECH_ContactFullValue__c,new list<contact>{conts});
                                           }
                                           else{
                                               contactAddMap.get(conts.ARV_TECH_ContactFullValue__c).add(conts);
                                           }
                                       }
                    for(Contact actnCnt: actnContctFieldsLst){
                        if(contactAddMap.get(actnCnt.ARV_TECH_ContactFullValue__c)!= null){
                            /*prsActnContctFieldsLst = [select id,AccountId,Name,FirstName,LastName,Email from Contact 
where FirstName=:actnCnt.FirstName and LastName=:actnCnt.LastName 
and Email=:actnCnt.Email and AccountId=:matchprospectId LIMIT 100];  */
                            prsActnContctFieldsLst = contactAddMap.get(actnCnt.ARV_TECH_ContactFullValue__c);
                            if(unqualifiedAcc.GA_CEO__c == actnCnt.id){
                                unqualifiedAcc.GA_CEO__c = prsActnContctFieldsLst[0].id;
                            }
                            if(unqualifiedAcc.GA_Decision_Maker__c == actnCnt.id){
                                unqualifiedAcc.GA_Decision_Maker__c = prsActnContctFieldsLst[0].id;
                            }
                            if(unqualifiedAcc.GA_Principal_Admin__c == actnCnt.id){
                                unqualifiedAcc.GA_Principal_Admin__c = prsActnContctFieldsLst[0].id;
                            }
                            unqualifiedAcc.GA_Is_Mass_Updating__c = True;
                            saveUnqPsAccLst.add(unqualifiedAcc);                            
                        }
                    }
                    if(saveUnqPsAccLst.size()>0){
                        List<Database.SaveResult> saveUnqPsList = ARV_AP08_DMLHelper.insertSObjects(saveUnqPsAccLst,UPDAT,true);
                        ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(saveUnqPsList);
                    }
                } 
                updtAcc = new Account(id = matchprospectId, GA_Is_Mass_Updating__c = True);
                for(Schema.FieldSetMember fieldDls : SObjectType.Account.FieldSets.ARV_FS01_UnqualifiedProspectMerge.getFields())
                {
                    updtAcc.put(fieldDls.getFieldPath(),unqualifiedAcc.get(fieldDls.getFieldPath()));
                    
                }
                accList.add(updtAcc);
                
                List<Database.SaveResult> saveacntList2 = ARV_AP08_DMLHelper.insertSObjects(accList,UPDAT,true);
                ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(saveacntList2);
                string updtCensus=ARV_CloneCensus.cloneGroupCensusRecord(censusId,updtAcc.Id);
                system.debug('updatecensus::'+updtCensus);
                Contract updtContrct = New Contract(Id = contractId,AccountId = updtAcc.Id,vlocity_ins__EnrollmentCensusId__c=updtCensus,ARV_Is_Mass_Updating__c = True);
                List<Contract> cntrtLst = new List<Contract>();
                cntrtLst.add(updtContrct);
                List<Database.SaveResult> savecontrctList = ARV_AP08_DMLHelper.insertSObjects(cntrtLst,UPDAT,true);
                ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(savecontrctList);
                List<Opportunity> updtOpptnyLst = new List<Opportunity>();
                Set<Id> opprSet = new Set<Id>();
                opprSet.add(unqualifiedAcc.Id);
                String oprqry = SLCTLBL + OPPRQRY;
                String oprmach = OPPRMATCH + GA_Util08_FilterProcessHelper.idSet(opprSet);
                List<Opportunity> opList = ARV_AP07_QueryDataHelper.getsObjects(oprqry,oprmach,EMPTYSTRNG,LMT);
                for (Opportunity OpptnyRcd : opList)
                {
                    OpptnyRcd.AccountID = updtAcc.Id;
                    updtOpptnyLst.add(OpptnyRcd);
                }
                if(updtOpptnyLst.size()>0){
                    List<Database.SaveResult> saveoprtyList = ARV_AP08_DMLHelper.insertSObjects(updtOpptnyLst,UPDAT,true);
                    ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(saveoprtyList);
                }
                List<LocationPackage__c> updtLctnSgmtLst = new List<LocationPackage__c> ();
                Set<Id> lcnpkgSet1 = new Set<Id>();
                lcnpkgSet1.add(unqualifiedAcc.Id);
                Set<Id> lcnpkgSet2 = new Set<Id>();
                lcnpkgSet2.add(contractId);
                String lcnpkg = SLCTLBL + LCNPKGQRY;
                String lcnpkgmach1 = LCNPKGMATCH1 + GA_Util08_FilterProcessHelper.idSet(lcnpkgSet1);
                String lcnpkgmach2 = lcnpkgmach1 + LCNPKGMATCH2 + GA_Util08_FilterProcessHelper.idSet(lcnpkgSet2);
                List<LocationPackage__c> lcnpkgLst = ARV_AP07_QueryDataHelper.getsObjects(lcnpkg,lcnpkgmach2,EMPTYSTRNG,LMT);
                for (LocationPackage__c LctnSgmtRcd : lcnpkgLst)
                {
                    LctnSgmtRcd.ARV_AccountId__c = updtAcc.Id;
                    updtLctnSgmtLst.add(LctnSgmtRcd);
                }
                if(updtLctnSgmtLst.size()>0){
                    List<Database.SaveResult> saveLctnSgmtList = ARV_AP08_DMLHelper.insertSObjects(updtLctnSgmtLst,UPDAT,true);
                    ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(saveLctnSgmtList);
                }
                List<AccountTeamMember> updtAccntTmMbrLst = new List<AccountTeamMember> ();
                Set<Id> acttmmbrSet = new Set<Id>();
                acttmmbrSet.add(unqualifiedAcc.Id);
                String acnttmmbr = SLCTLBL + ACNTTMMBRQRY;
                String acnttmmbrmatch = ACNTTMMBRMTH + GA_Util08_FilterProcessHelper.idSet(acttmmbrSet);
                List<AccountTeamMember> acttmmbrLst = ARV_AP07_QueryDataHelper.getsObjects(acnttmmbr,acnttmmbrmatch,EMPTYSTRNG,LMT);
                AccountTeamMember accntTmMbr  = new AccountTeamMember();
                for (AccountTeamMember teamMbr : acttmmbrLst)
                {
                    accntTmMbr = new AccountTeamMember(AccountId=updtAcc.Id,UserId=teamMbr.UserId,
                                                       TeamMemberRole=teamMbr.TeamMemberRole);
                    updtAccntTmMbrLst.add(accntTmMbr);
                }
                if(updtAccntTmMbrLst.size()>0){
                    List<Database.SaveResult> saveAccntTmMbrList = ARV_AP08_DMLHelper.insertSObjects(updtAccntTmMbrLst,INSRT,true);
                    ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(saveAccntTmMbrList);
                }
                set<id> cntcIds=new set<id>();
                Set<Id> acntcntrlSet1= new Set<Id>();
                acntcntrlSet1.add(unqualifiedAcc.Id);
                String atctrlnqry1 = SLCTLBL + ACNTCNTRLNQRY1;
                String actcntrlnwhere1 = ACNTCNTRLNMATCH + GA_Util08_FilterProcessHelper.idSet(acntcntrlSet1);
                List<AccountContactRelation> actcntrlLst1=ARV_AP07_QueryDataHelper.getsObjects(atctrlnqry1,actcntrlnwhere1,EMPTYSTRNG,LMT);
                for (AccountContactRelation cntcRltn : actcntrlLst1)
                {
                    if(cntcRltn.Contact.AccountId!=updtAcc.Id){
                        cntcIds.add(cntcRltn.ContactId);
                    }
                }
                if(unqualifiedAcc.GA_CEO__c != null && unqualifiedAcc.GA_CEO__r.AccountId!=updtAcc.Id){
                    cntcIds.add(unqualifiedAcc.GA_CEO__c);
                }
                if(unqualifiedAcc.GA_Decision_Maker__c != null && unqualifiedAcc.GA_Decision_Maker__r.AccountId!=updtAcc.Id){
                    cntcIds.add(unqualifiedAcc.GA_Decision_Maker__c);
                }
                if(unqualifiedAcc.GA_Principal_Admin__c != null && unqualifiedAcc.GA_Principal_Admin__r.AccountId!=updtAcc.Id){
                    cntcIds.add(unqualifiedAcc.GA_Principal_Admin__c);
                }
                Set<Id> acntcntrlSet = new Set<Id>();
                acntcntrlSet.add(updtAcc.Id);
                String atctrlnqry = SLCTLBL + ACNTCNTRLNQRY;
                String atctrlnwr = ACNTCNTRLNMATCH + GA_Util08_FilterProcessHelper.idSet(acntcntrlSet);
                List<AccountContactRelation> actcntrLst=ARV_AP07_QueryDataHelper.getsObjects(atctrlnqry,atctrlnwr,EMPTYSTRNG,ACNTCNTRLNLMT);
                for(AccountContactRelation existngaccCntRl : actcntrLst){
                    if(cntcIds.contains(existngaccCntRl.contactId))
                    {
                        cntcIds.remove(existngaccCntRl.contactId);
                    }
                }
                List<AccountContactRelation> newAccCntRlntLst = new List<AccountContactRelation> ();
                AccountContactRelation acntCntcRltn = new AccountContactRelation();
                if(cntcIds.size()>0)
                {
                    for(Id cntctId:cntcIds)
                    {       
                        acntCntcRltn = new AccountContactRelation();
                        acntCntcRltn.AccountId=updtAcc.Id;
                        acntCntcRltn.ContactId=cntctId;
                        newAccCntRlntLst.add(acntCntcRltn);   
                    }
                }
                if(newAccCntRlntLst.size()>0)
                {
                    List<Database.SaveResult> saveAccCntRlntList = ARV_AP08_DMLHelper.insertSObjects(newAccCntRlntLst,INSRT,true);
                    ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(saveAccCntRlntList);
                }
                if(deltDuplictCntcLst.size()>0){
                    List<Database.SaveResult> dlteDuplictCntList = ARV_AP08_DMLHelper.insertSObjects(deltDuplictCntcLst,DELTE,true);
                    ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(dlteDuplictCntList);
                }
                Account unqualifiedacnt = new Account();
                unqualifiedacnt.Id = unqualifiedProspectId;
                List<Account> unqualifiedAct = new List<Account>();
                unqualifiedAct.add(unqualifiedacnt);
                if(unqualifiedAct.size()>0){
                    List<Database.SaveResult> saveunqalifyList = ARV_AP08_DMLHelper.insertSObjects(unqualifiedAct,DELTE,true);
                    ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(saveunqalifyList);
                }
                
            }
            
            return updtAcc;
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CREATEORMERGEACNTMETHDNME,contractId);
            throw new DMLException(e.getMessage());
        }
    }
    /*
@Description: commonControlCreate() method 
@Name : commonControlCreate
@Param : Id 
@Return : void
@throws Exception : N/A
*/      
    public static void commonControlCreate(Id cid)
    {
        try
        {
            Set<id> lcnLst = new Set<Id>();
            lcnLst.add(cid);
            String lcnWhereId = LCNMATCHQRY1 + GA_Util08_FilterProcessHelper.idSet(lcnLst) + LCNMATCHQRY2;
            String selctstrng = SLCTLBL + LCNSEGQRY;
            List<LocationPackage__c> lcpkgLst= ARV_AP07_QueryDataHelper.getsObjects(selctstrng,lcnWhereId,EMPTYSTRNG,LMT);
            List<GA_Common_Control__c> cmnctrlLst = new List<GA_Common_Control__c>();
            GA_Common_Control__c newcmnctrl = new GA_Common_Control__c();
            if(lcpkgLst.size()>0)
            {
                for(LocationPackage__c l:lcpkgLst)
                {
                    newcmnctrl = new GA_Common_Control__c(Name=l.Name,GA_Federal_Tax_ID_Number__c=l.ARV_CC_Fed_Tax_ID__c,
                                                          GA_AccountId__c=l.ARV_AccountId__c,ARV_CC_LocationSegment__c=l.Id);
                    cmnctrlLst.add(newcmnctrl);
                }
            }
            if(cmnctrlLst.size()>0 && cmnctrlLst != NULL)
            {
                //List<Database.SaveResult> savecmnctrlList = ARV_AP08_DMLHelper.insertSObjects(cmnctrlLst,INSRT,true);
                //ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(savecmnctrlList);
                database.insert(cmnctrlLst);
            }
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, CMNCNTRLCREATEMETHDNME, cid);
            ARV_AP59_CreateGroupSegmentRecords.errorOccured = true;
        }
    }
    
    
/* @Description: sendEmailCDH() method 
@Name : Sendemail()
@Param : Id 
@Return : void
@throws Exception : N/A
*/      
    public static void sendEmailCDH(string conId)
    {
        system.debug('Contract::'+conId);
        List<Package__c> Pkges = new List<Package__c>();
        
        Pkges = [select Id,ARV_CDH_Package_Combination__c,ARV_Medical_Plan__c,
                                  ARV_Medical_Plan__r.Carrier_Type__c,ARV_Contract_Id__c,ARV_Contract_Id__r.ContractNumber FROM Package__c
                                  WHERE ARV_Contract_Id__c =:conId];
        system.debug('Pkges::'+Pkges);
        string ConNumber = Pkges[0].ARV_Contract_Id__r.ContractNumber;
        boolean flag = false;
        for(Package__c Pkg:Pkges) {
                 

              if(Pkg.ARV_CDH_Package_Combination__c != EMPTYSTRNG && Pkg.ARV_Medical_Plan__r.Carrier_Type__c == BCBSM){
               flag = true;
               break;
            }
                
        }
         //system.debug('Flag!!!!'+flag);
            if(flag == true){
                try{
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String emailBody = EMPTYSTRNG;
                List<string> toAddresses = system.label.ARV_CL58_EmailCDH.split(CMMA) ;
                                
                //system.debug('how many emails!!!!'+toAddresses);
                mail.setToAddresses(toAddresses);
                mail.setSubject(SUBJECT);
                emailBody += '<html>Hello,<br><br/><p> A new business BCBSM group is being processed via OneSource and it includes CDH products. Please refer to the following new business contract number for reference:&nbsp;<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+conId+'"> '+ConNumber+'</a></p></html>';

                mail.setHTMLBody(emailBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                //system.debug('email!!!!');
                }
                catch(exception e)
            {
            //ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(contractId);    
            GA_LogExceptionCls.LogExcpContract(e, CLSNAME, SENDEMAILCDHMTHDNME, conId);
            //return ERRMSG;
            
            } 

            }
    }
    
    public static void sendEmailAddCDH(string conId, String newSPAcc, String oldSPAcc)
    {    
        List<Package__c> Pkges = [select Id,ARV_CDH_Package_Combination__c,ARV_Medical_Plan__c, ARV_GWC_Package_Change_Attributes__c,
                                  ARV_Medical_Plan__r.Carrier_Type__c,ARV_Contract_Id__c,ARV_Contract_Id__r.ContractNumber FROM Package__c
                                  WHERE ARV_Contract_Id__c =:conId];
        
        string ConNumber = Pkges[0].ARV_Contract_Id__r.ContractNumber;
        boolean flag = false;
        for(Package__c Pkg:Pkges) {
           if(pkg.ARV_GWC_Package_Change_Attributes__c!=null){
              Map<String, Object> obj = (Map<String, Object>) JSON.deserializeUntyped(pkg.ARV_GWC_Package_Change_Attributes__c);   
                 string newCDH=(string)obj.get('New CDH Package Combination:');
                 string oldCDH=(string)obj.get('Old CDH Package Combination:');   
               System.debug('how many packages ++');
               if( (newCDH!=null && (newCDH != oldCDH)) || (!newSPAcc.equals(oldSPAcc))){
                   flag = true;
                       break;
               }
           }
          
        }
         //system.debug('Flag!!!!'+flag);
        if(flag == true){
            try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String emailBody = EMPTYSTRNG;
            List<string> toAddresses = system.label.ARV_CL58_sendEmailAddCDH.split(CMMA) ;
                               
            //system.debug('how many emails!!!!'+toAddresses);
            mail.setToAddresses(toAddresses);
            mail.setSubject('Existing BCBSM Group Offering CDH Products');
            emailBody += '<html>Hello,<br><br/><p> An existing BCBSM group is being processed via OneSource and it includes CDH products. Please refer to the following contract number for reference:&nbsp;<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+conId+'"> '+ConNumber+'</a></p></html>';

 

            mail.setHTMLBody(emailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            //system.debug('email!!!!');
            }
            catch(exception e)
            {
                //ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(contractId);    
                GA_LogExceptionCls.LogExcpContract(e, CLSNAME, SENDEMAILCDHMTHDNME, conId);
                //return ERRMSG;
            } 
        }
    }
}