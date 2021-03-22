/*****************************************************************************************
Class Name   : GA_AP_ASEPRecordMatchCls
Date Created : 01/10/2017
Created By   : IDC Offshore
Description  : 1. This is the class for ASEP Record matching and creation
******************************************************************************************/
public without sharing class GA_AP_ASEPRecordMatchCls {
    public static final String mnthYrFrmt = 'MMMM, YYYY';
    public static final String hypnVal = ' - ';
    public static final String apprvdVal='Approved';
    public static final String pndgUnctVal='Pending - UnControllable';
    public static final String RejUnctVal='Rejected - UnControllable';
    public static final String dcsnmkr='Decision Maker ~ACCOUNT: ';
    public static final String mutlvtr='Mutual Voter~ACCOUNT: ';
    public static final String ceo='CEO~ACCOUNT: ';
    public static final String PrincplAdmin='Principal Admin~ACCOUNT: ';
    public static final String billngCnt='Billing Contact~Group Segment: ';
    public static final String adminCnt='Administrative Contact~Group Segment: ';
    public static final String tildeOp='~';
    public static final String commaOp=',';
    public static final String emptyStrng='';
    public static final String quryCnt='select id,Name,LastName,FirstName,Email,Active__c from contact where (accountId=\'';
    public static final String quryCnt1='\') and(';
    public static final String quryCnt2=' or ';
    public static final String quryCnt3=')';
    public static final String opnSqrbrkt='[';
    public static final String clsSqrbrkt=']';
    public static final String dblqute='\"';
    public static final String newRecLbl='New Record';
    public static final String accPrspct='Account - Prospect';
    public static final String accCtmr='Account - Customer';
    public static final String accInactive='Account - Inactive';  
    public static final String agntsldEnrlmnt='%Agent Sold Enrollment - New Business%';
    public static final String asepApvd='Approved';
    public static final String slctLbl='select ';
    public static final String enrlmntqry=' from GA_Agent_Sold_Enrollment__c where id =:AsepRecId';
    public static final String asgqryEnd=' from GA_Agent_Sold_Group__c where id in:asgLstId';
    public static final String opnLbl='Open';
    public static final String ascqry=' from GA_Agent_Sold_Contact__c where id in:AscCntIdLst';
    public static final String cntRecType='Contact';
    public static final String ClsName='GA_AP_ASEPRecordMatchCls';
    public static final String methodasepRnly='fetchASEPReadonlyInfo';
    public static final String methodupstASCCnt='updateASContacts';
    public static final String methodnewaccPrcss='newAccountASEPPrcss';
    public static final String methodfetAccinfo='fetchAccInfo';
    public static final String methodfetCntinfo='fetchCntInfo';
    public static final String methodfetchExtngCnt='fetchExtngCnt';
    public static final String billngCityAPI='GA_Billing_City_Id__c';
    public static final String mailingCityAPI='GA_Mailing_City_Id__c';
    public static final String phisicalCityAPI='GA_Physical_City_Id__c';
    public static final String SysOfRecVal='Salesforce';
    public static final String sysRecSmrt='SMART';
    public static final String AccSTsVal='Active';
    public static final String mngingAGncyCde=',GA_Managing_Agency_Code__c ';
    public static final String mngingAGncyCdeCmp='GA_Managing_Agency_Code__c';
    public static final String SmlGrpVal='Small Group';
    public static final String TotlEmpField='GA_Total_Employees__c';
    public static final string TotalEligble = 'GA_Total_Eligible__c';
    public static final String ColnVal=':';
    public static final String asepBCBSMmsg = 'Ready for Blue Connect/MACESS';
    public static boolean asepGrpSeg = false;
    public static Boolean duplicateChecker=false;
    
    private static list<GA_Agent_Sold_Enrollment__c> fetchasepInfo(string ASEPId)
    {
        list<GA_Agent_Sold_Enrollment__c> asepRec=[select id,GA_ASEP_Processed__c,OwnerId,GA_Account_Id__c,GA_Federal_Tax_ID__c,GA_Account_Name__c,GA_Principal_Admin__c,GA_Principal_Admin__r.Name,
                                                   GA_Decision_Maker__c,GA_Decision_Maker__r.Name,GA_Carrier__c,GA_ASEP_Status__c,
                                                   GA_CEO__c,GA_CEO__r.Name,GA_Mutual_Voter__c,GA_Mutual_Voter_Contact_ID__c,
                                                   GA_Principal_Admin_Contact_ID__c,GA_Mutual_Voter__r.Name,GA_CID__c,GA_CEO_Contact_ID__c,GA_Decision_Maker_Contact_ID__c,
                                                   (select id,Name,GA_Group_Number__c,GA_Benefit_Effective_Date__c,  GA_Corporate_Received_Date__c,GA_Billing_Contact_Id__c,
                                                    GA_Billing_Contact_Id__r.Name,GA_Administrative_Contact_Id__c,GA_Matched_Admin_Contact_ID__c,GA_Matched_Billing_Contact_ID__c,
                                                    GA_Administrative_Contact_Id__r.Name,GA_Managing_Agency_Code__c from Agent_Sold_Groups__r) 
                                                   from GA_Agent_Sold_Enrollment__c where id=:ASEPId and GA_ASEP_Status__c!=:apprvdVal and GA_ASEP_Status__c!=:pndgUnctVal and GA_ASEP_Status__c!=:RejUnctVal];  
        return asepRec;
    }
    private static list<GA_Agent_Sold_Enrollment__c> fetchasepInfoApprved(string ASEPId)
    {
        list<GA_Agent_Sold_Enrollment__c> asepRec=[select id,GA_ASEP_Processed__c,OwnerId,GA_Account_Id__c,GA_Federal_Tax_ID__c,GA_Account_Name__c,GA_Principal_Admin__c,GA_Principal_Admin__r.Name,
                                                   GA_Decision_Maker__c,GA_Decision_Maker__r.Name,GA_Carrier__c,GA_ASEP_Status__c,
                                                   GA_CEO__c,GA_CEO__r.Name,GA_Mutual_Voter__c,GA_Mutual_Voter_Contact_ID__c,
                                                   GA_Principal_Admin_Contact_ID__c,GA_Mutual_Voter__r.Name,GA_CID__c,GA_CEO_Contact_ID__c,GA_Decision_Maker_Contact_ID__c,
                                                   (select id,Name,GA_Group_Number__c,GA_Benefit_Effective_Date__c,GA_Billing_Contact_Id__c,
                                                    GA_Billing_Contact_Id__r.Name,GA_Administrative_Contact_Id__c,GA_Matched_Admin_Contact_ID__c,GA_Matched_Billing_Contact_ID__c,
                                                    GA_Administrative_Contact_Id__r.Name,GA_Managing_Agency_Code__c from Agent_Sold_Groups__r) from GA_Agent_Sold_Enrollment__c where id=:ASEPId and GA_ASEP_Status__c=:apprvdVal];  
        return asepRec;
    }
    @AuraEnabled
    public static AsepReadoNlywrp fetchASEPReadonlyInfo(string ASEPId)
    {
        try
        {
            list<GA_Agent_Sold_Enrollment__c> asepRecLst=fetchasepInfoApprved(ASEPId);
            if(asepRecLst.size()>0)
            {
                GA_Agent_Sold_Enrollment__c asepRec=asepRecLst[0];
                map<id,list<string>> asContactids=new map<Id,list<string>>();
                list<string> aseprole=new list<string>();
                if(asepRec.GA_Decision_Maker__c !=null)
                {
                    if(asContactids.get(asepRec.GA_Decision_Maker_Contact_ID__c)!=null)
                    {
                        aseprole=asContactids.get(asepRec.GA_Decision_Maker_Contact_ID__c);
                    }
                    else
                        aseprole=new list<string>();  
                    aseprole.add(dcsnmkr+asepRec.GA_Account_Name__c);
                    asContactids.put(asepRec.GA_Decision_Maker_Contact_ID__c,aseprole);  
                }
                
                if(asepRec.GA_Mutual_Voter__c !=null)
                {
                    if(asContactids.get(asepRec.GA_Mutual_Voter_Contact_ID__c)!=null)
                    {
                        aseprole=asContactids.get(asepRec.GA_Mutual_Voter_Contact_ID__c);
                    }
                    else
                        aseprole=new list<string>();  
                    aseprole.add(mutlvtr+asepRec.GA_Account_Name__c);
                    asContactids.put(asepRec.GA_Mutual_Voter_Contact_ID__c,aseprole);  
                }
                
                if(asepRec.GA_CEO__c !=null)
                {       
                    if(asContactids.get(asepRec.GA_CEO_Contact_ID__c)!=null)
                    {
                        aseprole=asContactids.get(asepRec.GA_CEO_Contact_ID__c);
                    }
                    else
                        aseprole=new list<string>();  
                    aseprole.add(ceo+asepRec.GA_Account_Name__c);
                    asContactids.put(asepRec.GA_CEO_Contact_ID__c,aseprole); 
                }
                if(asepRec.GA_Principal_Admin__c !=null)
                {       
                    if(asContactids.get(asepRec.GA_Principal_Admin_Contact_ID__c)!=null)
                    {
                        aseprole=asContactids.get(asepRec.GA_Principal_Admin_Contact_ID__c);
                    }
                    else
                        aseprole=new list<string>();  
                    aseprole.add(PrincplAdmin+asepRec.GA_Account_Name__c);
                    asContactids.put(asepRec.GA_Principal_Admin_Contact_ID__c,aseprole); 
                }
                list<GA_Agent_Sold_Group__c> asgLst=new list<GA_Agent_Sold_Group__c>();
                for(GA_Agent_Sold_Group__c asg:asepRec.Agent_Sold_Groups__r)
                {
                    if(asg.GA_Billing_Contact_Id__c !=null)
                    {
                        if(asContactids.get(asg.GA_Matched_Billing_Contact_ID__c)!=null)
                        {
                            aseprole=asContactids.get(asg.GA_Matched_Billing_Contact_ID__c);
                        }
                        else
                            aseprole=new list<string>();  
                        aseprole.add(billngCnt+asg.GA_Group_Number__c);
                        asContactids.put(asg.GA_Matched_Billing_Contact_ID__c,aseprole);
                    }
                    
                    if(asg.GA_Administrative_Contact_Id__c !=null)
                    {
                        if(asContactids.get(asg.GA_Matched_Admin_Contact_ID__c)!=null)
                        {
                            aseprole=asContactids.get(asg.GA_Matched_Admin_Contact_ID__c);
                        }
                        else
                            aseprole=new list<string>();  
                        aseprole.add(adminCnt+asg.GA_Group_Number__c);
                        asContactids.put(asg.GA_Matched_Admin_Contact_ID__c,aseprole);
                    }
                    asgLst.add(asg);
                }
                list<contact> cntLst=[select id,FirstName,LastName,Email from contact where id in :asContactids.keySet()];
                list<ExtCntWrapCls> extCntLst=new list<ExtCntWrapCls>();
                for(contact cnt:cntLst)
                {
                    ExtCntWrapCls extCnt=new ExtCntWrapCls();
                    extCnt.CntRec=cnt;   
                    set<string> fetchRlsSet=new set<string>();
                    list<string> fetchRls=new list<string>();
                    for(string rols:asContactids.get(cnt.Id))
                    {
                        fetchRlsSet.add(rols.split(tildeOp)[0]);
                        
                    }
                    fetchRls.addAll(fetchRlsSet);
                    extCnt.CntRle=string.join(fetchRls,commaOp);
                    extCntLst.add(extCnt);
                }
                account accRec=[select id,CID__c,Federal_Tax_ID__c,Name from account where id=:asepRec.GA_Account_Id__c];
                AsepReadoNlywrp asepRednly=new AsepReadoNlywrp();
                asepRednly.cntRecWIthrle=extCntLst;
                asepRednly.asgLst=asgLst;
                asepRednly.acc=accRec;
                return asepRednly;
            }
            return null;   
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodasepRnly); throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static AsepAccWrap fetchAccInfo(string ASEPId)
    {
        try
        {
            
            list<GA_Trigger_Functionality_By_Pass__c> aasepApprovebypss = [select id,GA_ASEP_Approve__c,SetupOwner.Name from GA_Trigger_Functionality_By_Pass__c where SetupOwnerId=:userInfo.getProfileId() limit 1];
            if(aasepApprovebypss.size()>0 && aasepApprovebypss[0].GA_ASEP_Approve__c)
            {
                
                string fedralTxId;
                AsepAccWrap AsepAccWrapRec=new AsepAccWrap();
                list<GA_Agent_Sold_Enrollment__c> asepRecLst=fetchasepInfo(ASEPId);
                if(asepRecLst.size()>0)
                {
                    GA_Agent_Sold_Enrollment__c asepRec=asepRecLst[0];
                    
                    fedralTxId=asepRec.GA_Federal_Tax_ID__c;
                    list<account> accLst=new list<account> ();
                    list<GA_Agent_Sold_Group__c> asgLst=new list<GA_Agent_Sold_Group__c>();
                    
                    if(fedralTxId !=emptyStrng)
                    {
                        accLst=[select id,Name,Federal_Tax_ID__c,CID__c,RecordType.Name,OwnerId,GA_System_of_Record__c from account where 
                                Federal_Tax_ID__c =:fedralTxId and 
                                (RecordType.Name = :accCtmr or RecordType.Name = :accPrspct or RecordType.Name = :accInactive) limit 20];
                    }
                    map<id,list<string>> asContactids=preprCntInfo( ASEPId, asepRec);
                    list<GA_Agent_Sold_Contact__c> asCntLst=[select id,Name,GA_First_Name__c,GA_Last_Name__c,GA_Email__c from GA_Agent_Sold_Contact__c where id in:asContactids.keyset()];
                    list<newCntWrapCls> cntWrapRecLst=new list<newCntWrapCls> ();
                    for(GA_Agent_Sold_Contact__c agcnt:asCntLst)
                    {
                        newCntWrapCls cntWrapRec=new  newCntWrapCls();
                        cntWrapRec.agntSldCnt=agcnt;
                        list<string> fetchRls=new list<string>();
                        set<string> fetchRlsSet=new set<string>();
                        list<string> fetchObj=new list<string>();
                        for(string rols:asContactids.get(agcnt.Id))
                        {
                            fetchRlsSet.add(rols.split(tildeOp)[0]);
                            fetchObj.add(rols.split(tildeOp)[1]);
                        }
                        fetchRls.addAll(fetchRlsSet);
                        cntWrapRec.CntRle=string.join(fetchRls,commaOp);
                        cntWrapRec.ObjInfo=string.join(fetchObj,commaOp);
                        cntWrapRecLst.add(cntWrapRec);
                    }
                    list<AccWrap> accwrpRecs=new list<AccWrap>();
                    for(account acc:accLst)
                    {
                        AccWrap accwrpRec=new AccWrap();
                        
                        if(acc.GA_System_of_Record__c==sysRecSmrt || (acc.RecordType.Name !=accCtmr && acc.RecordType.Name !=accPrspct ))
                        {
                            accwrpRec.disbleSlct=true;
                        }
                        else
                        {
                            accwrpRec.disbleSlct=false;
                        }
                        
                        if(acc.RecordType.Name ==accInactive)
                        {
                            accwrpRec.disbleSlct=false;
                        }
                        
                        accwrpRec.accRec=acc;
                        accwrpRecs.add(accwrpRec);
                    }
                    AsepAccWrapRec.accRecs=accwrpRecs;
                    AsepAccWrapRec.AsepRec=asepRec;
                    AsepAccWrapRec.AsgRecs=asepRec.Agent_Sold_Groups__r;
                    AsepAccWrapRec.newCntWrapRecs=cntWrapRecLst;
                    return AsepAccWrapRec;
                }
                else
                {
                    return null; 
                }
            }
            
            else{
                
                
                AsepAccWrap AsepAccWrapRec=new AsepAccWrap();
                AsepAccWrapRec.accessMsg = true ;
                return AsepAccWrapRec;
            }
            
            
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodasepRnly);
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    private static map<id,list<string>> preprCntInfo(string ASEPId,GA_Agent_Sold_Enrollment__c asepRec)
    {
        list<GA_Agent_Sold_Group__c> asgLst=new list<GA_Agent_Sold_Group__c>();
        map<id,list<string>> asContactids=new map<Id,list<string>>();
        list<string> aseprole=new list<string>();
        if(asepRec.GA_Decision_Maker__c !=null)
        {
            if(asContactids.get(asepRec.GA_Decision_Maker__c)!=null)
            {
                aseprole=asContactids.get(asepRec.GA_Decision_Maker__c);
            }
            else
                aseprole=new list<string>();  
            aseprole.add(dcsnmkr+asepRec.GA_Account_Name__c);
            asContactids.put(asepRec.GA_Decision_Maker__c,aseprole);  
        }
        
        if(asepRec.GA_Mutual_Voter__c !=null)
        {
            if(asContactids.get(asepRec.GA_Mutual_Voter__c)!=null)
            {
                aseprole=asContactids.get(asepRec.GA_Mutual_Voter__c);
            }
            else
                aseprole=new list<string>();  
            aseprole.add(mutlvtr+asepRec.GA_Account_Name__c);
            asContactids.put(asepRec.GA_Mutual_Voter__c,aseprole);  
        }
        
        if(asepRec.GA_CEO__c !=null)
        {       
            if(asContactids.get(asepRec.GA_CEO__c)!=null)
            {
                aseprole=asContactids.get(asepRec.GA_CEO__c);
            }
            else
                aseprole=new list<string>();  
            aseprole.add(ceo+asepRec.GA_Account_Name__c);
            asContactids.put(asepRec.GA_CEO__c,aseprole); 
        }
        if(asepRec.GA_Principal_Admin__c !=null)
        {       
            if(asContactids.get(asepRec.GA_Principal_Admin__c)!=null)
            {
                aseprole=asContactids.get(asepRec.GA_Principal_Admin__c);
            }
            else
                aseprole=new list<string>();  
            aseprole.add(PrincplAdmin+asepRec.GA_Account_Name__c);
            asContactids.put(asepRec.GA_Principal_Admin__c,aseprole); 
        }
        if(asepRec.Agent_Sold_Groups__r.size()>0){
            asgLst=asepRec.Agent_Sold_Groups__r;
            for(GA_Agent_Sold_Group__c asg:asgLst)
            {
                if(asg.GA_Billing_Contact_Id__c !=null)
                {
                    if(asContactids.get(asg.GA_Billing_Contact_Id__c)!=null)
                    {
                        aseprole=asContactids.get(asg.GA_Billing_Contact_Id__c);
                    }
                    else
                        aseprole=new list<string>();  
                    if(asg.GA_Group_Number__c !=null)
                        aseprole.add(billngCnt+asg.GA_Group_Number__c);
                    else
                        aseprole.add(billngCnt.replace(ColnVal,emptyStrng));
                    asContactids.put(asg.GA_Billing_Contact_Id__c,aseprole);
                }
                
                if(asg.GA_Administrative_Contact_Id__c !=null)
                {
                    if(asContactids.get(asg.GA_Administrative_Contact_Id__c)!=null)
                    {
                        aseprole=asContactids.get(asg.GA_Administrative_Contact_Id__c);
                    }
                    else
                        aseprole=new list<string>();  
                    if(asg.GA_Group_Number__c !=null)
                        aseprole.add(adminCnt+asg.GA_Group_Number__c);
                    else
                        aseprole.add(adminCnt.replace(ColnVal,emptyStrng));
                    asContactids.put(asg.GA_Administrative_Contact_Id__c,aseprole);
                }
                
            }
        }
        return asContactids;
        
    }
    @AuraEnabled
    public static AsepAccWrap fetchCntInfo(string ASEPId,string accId,string accRcType)
    {
        try
        {
            AsepAccWrap AsepAccWrapRec=new AsepAccWrap();
            set<string> asCntFildVal=new set<string>();
            list<GA_Agent_Sold_Enrollment__c> asepRecLst=fetchasepInfo(ASEPId);
            if(asepRecLst.size()>0)
            {
                GA_Agent_Sold_Enrollment__c asepRec=asepRecLst[0];
                
                map<id,list<string>> asContactids=preprCntInfo( ASEPId, asepRec);
                list<GA_Agent_Sold_Contact__c> asCntLst=[select id,Name,GA_First_Name__c,GA_Last_Name__c,GA_Email__c from GA_Agent_Sold_Contact__c where id in:asContactids.keyset()];
                list<GA_ASEP_Duplicate_Check__mdt> dpChkMetadtaLst=[select GA_ASEP_Contact_API_Name_Field__c,GA_Contact_Field_API_Name__c from GA_ASEP_Duplicate_Check__mdt];
                map<string,set<string>> fieldValMap=new map<string,set<string>>();
                map<string,string> dupMapFieldAPI=new map<string,string>();
                for(GA_ASEP_Duplicate_Check__mdt dpchkMdt:dpChkMetadtaLst)
                {
                    dupMapFieldAPI.put(dpchkMdt.GA_ASEP_Contact_API_Name_Field__c,dpchkMdt.GA_Contact_Field_API_Name__c);
                }
                list<CntASCntWrap> cntAsCntRecLst=new list<CntASCntWrap>();
                if(asCntLst.size()>0)
                {
                    for(GA_Agent_Sold_Contact__c asCnt:asCntLst)
                    {
                        for(GA_ASEP_Duplicate_Check__mdt dpchkMdt:dpChkMetadtaLst)
                        {
                            if(fieldValMap.get(dpchkMdt.GA_ASEP_Contact_API_Name_Field__c) !=null)
                            {
                                asCntFildVal=fieldValMap.get(dpchkMdt.GA_ASEP_Contact_API_Name_Field__c);
                            }
                            else
                            {
                                asCntFildVal=new set<string>(); 
                            }
                            
                            if(!String.isBlank(string.valueof(asCnt.get(dpchkMdt.GA_ASEP_Contact_API_Name_Field__c)))){
                                asCntFildVal.add(String.escapeSingleQuotes(string.valueof(asCnt.get(dpchkMdt.GA_ASEP_Contact_API_Name_Field__c))));
                                fieldValMap.put(dpchkMdt.GA_ASEP_Contact_API_Name_Field__c,asCntFildVal);
                            }else {
                                asCntFildVal.add(string.valueof(asCnt.get(dpchkMdt.GA_ASEP_Contact_API_Name_Field__c)));
                                fieldValMap.put(dpchkMdt.GA_ASEP_Contact_API_Name_Field__c,asCntFildVal);
                            }
                        }
                        //asCntNme.add(asCnt.Name);
                    }
                    string cntQueryStrng=quryCnt+accId+quryCnt1;
                    integer i=0;
                    for(string fieldAPI:fieldValMap.keySet())
                    {
                        cntQueryStrng= cntQueryStrng+' '+dupMapFieldAPI.get(fieldAPI)+' in'+GA_Util08_FilterProcessHelper.strSet(fieldValMap.get(fieldAPI));
                        if(i<fieldValMap.keySet().size()-1)
                            cntQueryStrng=cntQueryStrng+quryCnt2;
                        if(i==fieldValMap.keySet().size()-1)
                        {
                            cntQueryStrng=cntQueryStrng+quryCnt3;   
                        }
                        i++;
                    }
                    
                    list<contact> cntLst=database.query(cntQueryStrng);
                    
                    for(GA_Agent_Sold_Contact__c asCnt:asCntLst)
                    {
                        CntASCntWrap cntAsCntRec=new CntASCntWrap();
                        list<string> cntAsepRls=asContactids.get(asCnt.id);
                        list<cntMtchCntWrap> cntLstTmp=new list<cntMtchCntWrap>();
                        boolean exctMtch;
                        for(contact cnt:cntLst)
                        {
                            integer cntCnt=1;
                            exctMtch=false;
                            cntMtchCntWrap cntMtchWrpRec=new cntMtchCntWrap();
                            //boolean chkDpk=false;
                            integer cntMtch=0;
                            for(GA_ASEP_Duplicate_Check__mdt dpchkMdt:dpChkMetadtaLst)
                            {
                                if(string.valueof(asCnt.get(dpchkMdt.GA_ASEP_Contact_API_Name_Field__c))
                                   ==string.valueof(cnt.get(dpchkMdt.GA_Contact_Field_API_Name__c)))
                                {
                                    //chkDpk=true; 
                                    cntMtch++;
                                    //break;
                                }
                                
                            }
                            if(cntMtch==dpChkMetadtaLst.size())
                            {
                                cntLstTmp=new list<cntMtchCntWrap>();
                                cntMtchWrpRec.cntctMtch=cnt;
                                cntMtchWrpRec.countMtch=cntMtch;  
                                cntMtchWrpRec.slctCnt=true;
                                cntLstTmp.add(cntMtchWrpRec);
                                cntLstTmp.sort();
                                cntAsCntRec.Ascnt=asCnt;
                                cntAsCntRec.cntLst=cntLstTmp;   
                                exctMtch=true;
                                break;
                            }
                            else if(cntMtch==dpChkMetadtaLst.size()-1)
                            {
                                cntMtchWrpRec.cntctMtch=cnt;
                                cntMtchWrpRec.countMtch=cntMtch;  
                                cntMtchWrpRec.slctCnt=false;
                                cntLstTmp.add(cntMtchWrpRec);
                                cntLstTmp.sort();
                                cntAsCntRec.Ascnt=asCnt;
                                cntAsCntRec.cntLst=cntLstTmp;
                                exctMtch=false;
                            }
                            /* else
{
cntAsCntRec.Ascnt=asCnt;
cntAsCntRec.cntLst=cntLstTmp;
}*/ 
                            cntCnt++;
                        }
                        list<string> fetchRls=new list<string>();
                        set<string> fetchRlsSet=new set<string>();
                        for(string rols:cntAsepRls)
                        {
                            fetchRlsSet.add(rols.split('~')[0]);
                        }
                        fetchRls.addAll(fetchRlsSet);
                        cntAsCntRec.ASEPRole=string.join(fetchRls,',');
                        cntAsCntRec.isExactMtch=exctMtch;
                        if(cntLstTmp.size()>0)
                            cntAsCntRecLst.add(cntAsCntRec);
                    }     
                }
                
                
                
                
                
                AsepAccWrapRec.CntRecs=cntAsCntRecLst;
                return AsepAccWrapRec;
            }
            else
            {
                return null;
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodasepRnly); throw new AuraHandledException(e.getMessage());
        }
        
        
    }
    
    @AuraEnabled
    public static list<ExtCntWrapCls> fetchExtngCnt(string asCntMap,string asgCntLstJSON)
    {
        try
        {
            List<newCntWrapCls> asgCntLst = (List<newCntWrapCls>)JSON.deserialize(asgCntLstJSON, List<newCntWrapCls>.class);
            
            list<ExtCntWrapCls> ExtCntWrapClsLst=new list<ExtCntWrapCls>();
            
            if(asCntMap !='[]')
            {
                list<string> ASCCntLst=asCntMap.replace(opnSqrbrkt,emptyStrng).replace(clsSqrbrkt,emptyStrng).split(commaOp);
                map<string,string> ASCCntMapVal=new map<string,string>();
                
                for(string ASCCnt:ASCCntLst)
                {
                    ASCCntMapVal.put(ASCCnt.split(tildeOp)[0].replace(dblqute,emptyStrng),ASCCnt.split(tildeOp)[1].replace(dblqute,emptyStrng));
                } 
                set<id> cntSetId=new set<id>();
                map<id,list<string>> cntRleMap=new map<id,list<string>>();
                map<id,list<string>> ascntRleMap=new map<id,list<string>>();
                list<string> cntRleLst=new list<string>();
                list<string> cntRleLstCnslted=new list<string>();
                for(newCntWrapCls cntAsc:asgCntLst)
                {
                    if(cntRleMap.get(cntAsc.agntSldCnt.Id) !=null)
                    {
                        cntRleLst=cntRleMap.get(cntAsc.agntSldCnt.Id);
                    }
                    else
                    {
                        cntRleLst=new list<string>();
                    }
                    cntRleLst.add(cntAsc.CntRle);
                    ascntRleMap.put(cntAsc.agntSldCnt.Id,cntRleLst);
                }
                for(string ASCCntMapTmp:ASCCntMapVal.keyset())
                {
                    if(ASCCntMapVal.get(ASCCntMapTmp) !=newRecLbl)
                    {
                        cntSetId.add(ASCCntMapVal.get(ASCCntMapTmp));
                        if(cntRleMap.get(ASCCntMapVal.get(ASCCntMapTmp)) !=null)
                        {
                            cntRleLstCnslted=cntRleMap.get(ASCCntMapVal.get(ASCCntMapTmp));
                        }
                        else
                        {
                            cntRleLstCnslted=new list<string>();
                        }
                        cntRleLstCnslted.addAll(ascntRleMap.get(ASCCntMapTmp));
                        cntRleMap.put(ASCCntMapVal.get(ASCCntMapTmp),cntRleLstCnslted);
                    }
                }
                list<contact> cntLst=[select id,FirstName,LastName,Email from contact where id in:cntSetId];
                
                for(contact cnt:cntLst)
                {
                    ExtCntWrapCls extcnt=new ExtCntWrapCls();
                    extcnt.CntRec=cnt;
                    set<string> fetchRlsSet=new set<string>();
                    for(string rls:cntRleMap.get(cnt.Id))
                    {
                        fetchRlsSet.add(rls);
                    }
                    
                    list<string> fetchRls=new list<string>();
                    fetchRls.addAll(fetchRlsSet);
                    extcnt.CntRle=string.join(fetchRls,commaOp);
                    ExtCntWrapClsLst.add(extcnt);
                }
                
            }
            return ExtCntWrapClsLst; 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodasepRnly);
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static string updateASContacts(string asCntMap,account accRec,
                                          GA_Agent_Sold_Enrollment__c AsepRec,list<GA_Agent_Sold_Group__c> AsgRecs,string asgCntLstJSON)
    {
        try
        {
            List<newCntWrapCls> asgCntLst = (List<newCntWrapCls>)JSON.deserialize(asgCntLstJSON, List<newCntWrapCls>.class);
            list<string> ASCCntLst=asCntMap.replace(opnSqrbrkt,emptyStrng).replace(clsSqrbrkt,emptyStrng).split(commaOp);
            map<string,string> ASCCntMapVal=new map<string,string>();
            Date corporateRecvdDt;
            for(string ASCCnt:ASCCntLst)
            {
                ASCCntMapVal.put(ASCCnt.split(tildeOp)[0].replace(dblqute,emptyStrng),ASCCnt.split(tildeOp)[1].replace(dblqute,emptyStrng));
            }
            list<GA_Agent_Sold_Contact__c> agnSLdCntLsttoUpdte=new list<GA_Agent_Sold_Contact__c>();
            list<id> agnSLdCntNewRecId=new list<id>();
            set<id> matchedCntIds=new set<id>();
            for(string ASCCntMapTmp:ASCCntMapVal.keyset())
            {
                if(ASCCntMapVal.get(ASCCntMapTmp) !=newRecLbl)
                {
                    
                    GA_Agent_Sold_Contact__c agSldCnt=new GA_Agent_Sold_Contact__c();
                    agSldCnt.Id=ASCCntMapTmp;
                    agSldCnt.GA_Matched_Contact__c=ASCCntMapVal.get(ASCCntMapTmp); 
                    agnSLdCntLsttoUpdte.add(agSldCnt);
                    matchedCntIds.add(ASCCntMapVal.get(ASCCntMapTmp));
                } 
            }
            for(newCntWrapCls cntAsc:asgCntLst)
            {
                if(!ASCCntMapVal.keyset().contains(cntAsc.agntSldCnt.Id))
                {
                    agnSLdCntNewRecId.add(cntAsc.agntSldCnt.Id); 
                }
            }
            map<string,string> newCntASCNtMap=createNewContact(agnSLdCntNewRecId,accRec);
            for(string newCntASCnt:newCntASCNtMap.keySet())
            {
                
                GA_Agent_Sold_Contact__c agSldCnt=new GA_Agent_Sold_Contact__c();
                agSldCnt.Id=newCntASCnt;
                agSldCnt.GA_Matched_Contact__c=newCntASCNtMap.get(newCntASCnt); 
                agnSLdCntLsttoUpdte.add(agSldCnt);
            }
            if(agnSLdCntLsttoUpdte.size()>0)
            {
                database.update(agnSLdCntLsttoUpdte);
            }
            list<id> asgrpId=new list<id>();
            if(AsgRecs.size()>0){
                
                for(GA_Agent_Sold_Group__c asg:AsgRecs)
                {
                    asgrpId.add(asg.Id);
                    if( asg.GA_Corporate_Received_Date__c != null)
                        corporateRecvdDt =asg.GA_Corporate_Received_Date__c ;
                }
            }
            list<GA_Group_Segment__c> grpLst=new list<GA_Group_Segment__c>();
            if(asgrpId.size()>0)
            {
                set<id> asgIdset=new set<id>();
                asgIdset.addAll(asgrpId);
                updateAsgCities(asgIdset);
                grpLst= createGrpSGmnts(asgrpId,accRec); 
                updteASGrps(grpLst);
            }
            
            //if(accRec.RecordType.Name =='Account - Prospect')
            if(accRec.RecordType.Name ==accPrspct || accRec.RecordType.Name ==accInactive)
            {
                list<account> accLstUpte=creteAccRecs(AsepRec.Id,accRec);   
                
                accRec=accLstUpte[0];
            }
            
            linkAccCntacts(AsepRec.id,accRec);
            if(matchedCntIds.size()>0)
            {
                chngeInactivToActvCnt(matchedCntIds);
            }
            list<string> slectedGrp=new list<string>();
            for(GA_Group_Segment__c grp:grpLst)
            {
                slectedGrp.add(grp.Id);
            }
            
            list<GA_WFT_workflow__c> wfTeplt=[select id,GA_Carrier__c,
                                              GA_Method__c,GA_Process_Subtype__c,
                                              GA_Process_Type__c from GA_WFT_workflow__c where GA_Carrier__c=:AsepRec.GA_Carrier__c and Name like :agntsldEnrlmnt limit 1];
            if(wfTeplt.size()>0 && grpLst.size()>0)
                createNewwrkflow(accRec.Id, wfTeplt[0], string.join(slectedGrp, commaOp),AsepRec.id,grpLst[0].GA_Benefit_Effective_Date__c,corporateRecvdDt);
            updateASEPRecPrcss(AsepRec,accRec);
            return accRec.Id;  
        }
        catch(exception e)
        {
            if(e.getMessage().contains('INVALID_EMAIL_ADDRESS')){
                throw new AuraHandledException(system.label.invalid_contact_email);
            }else if(e.getMessage().contains('Invalid id:')){
                throw new AuraHandledException(system.label.Agent_missing);
            }else if(e.getMessage().contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY')){
                String s = e.getMessage().substringAfter('Assertion Failed:');
                s = s.substringBefore(')')+'). Please select existing contacts in previous screen';
                throw new AuraHandledException(s);
            }
            GA_LogExceptionCls.LogExcp(e, ClsName, methodasepRnly); throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static void updateAsgCities(set<id> asgrpId)
    {
        list<GA_Agent_Sold_Group__c> asgLst=[select id,GA_Billing_City__c,GA_Mailing_City__c,GA_Physical_City__c  from GA_Agent_Sold_Group__c where id in:asgrpId];
        set<string> cityVals=new set<string>();
        map<id,map<string,list<string>>> asgCityMap=new map<id,map<string,list<string>>>();
        map<string,list<string>> cityFielAPIMap=new map<string,list<string>>();
        list<string> fieldAPIs=new list<string>();
        for(GA_Agent_Sold_Group__c asg:asgLst)
        {
            cityFielAPIMap=new map<string,list<string>>();
            fieldAPIs=new list<string>();
            if(asg.GA_Billing_City__c !=null)
            {
                fieldAPIs.add(billngCityAPI);
                cityFielAPIMap.put(asg.GA_Billing_City__c.toUpperCase(),fieldAPIs);
                cityVals.add(asg.GA_Billing_City__c.toUpperCase());
            }
            
            if(asg.GA_Mailing_City__c !=null)
            {
                
                if(cityFielAPIMap.get(asg.GA_Mailing_City__c.toUpperCase()) !=null)
                {
                    fieldAPIs= cityFielAPIMap.get(asg.GA_Mailing_City__c.toUpperCase());
                }
                else
                    fieldAPIs=new list<string>();   
                fieldAPIs.add(mailingCityAPI);
                cityFielAPIMap.put(asg.GA_Mailing_City__c.toUpperCase(),fieldAPIs);
                cityVals.add(asg.GA_Mailing_City__c.toUpperCase()); 
            }
            
            if(asg.GA_Physical_City__c !=null)
            {
                if(cityFielAPIMap.get(asg.GA_Physical_City__c.toUpperCase()) !=null)
                {
                    fieldAPIs= cityFielAPIMap.get(asg.GA_Physical_City__c.toUpperCase());
                }
                else
                    fieldAPIs=new list<string>();   
                fieldAPIs.add(phisicalCityAPI);
                cityFielAPIMap.put(asg.GA_Physical_City__c.toUpperCase(),fieldAPIs); 
                cityVals.add(asg.GA_Physical_City__c.toUpperCase());  
            }
            asgCityMap.put(asg.Id,cityFielAPIMap);
        }
        list<GA_City_Code__c> cityLst=[select id,Name from GA_City_Code__c where name in:cityVals];
        map<string,GA_City_Code__c> cityNamMap=new map<string,GA_City_Code__c>();
        set<string> cityValsNew=new set<string>();
        set<string> cityValsExist=new set<string>();
        for(GA_City_Code__c cityRec:cityLst)
        {
            cityNamMap.put(cityRec.Name,cityRec);
            cityValsExist.add(cityRec.Name);
        }
        for(string cityValTmp:cityVals)
        {
            if(!cityValsExist.contains(cityValTmp))
            {
                cityValsNew.add(cityValTmp);
            }
        }
        list<GA_City_Code__c> newCityRecs=new list<GA_City_Code__c>();
        for(string citvalNewtmp:cityValsNew)
        {
            GA_City_Code__c newcty=new GA_City_Code__c();
            newcty.Name=citvalNewtmp;
            newCityRecs.add(newcty);
        }
        if(newCityRecs.size()>0)
            database.insert(newCityRecs);
        for(GA_City_Code__c cityRec:newCityRecs)
        {
            cityNamMap.put(cityRec.Name,cityRec);          
        }
        list<GA_Agent_Sold_Group__c> asgToUpdate=new list<GA_Agent_Sold_Group__c>();
        for(GA_Agent_Sold_Group__c asg:asgLst)
        {
            boolean uptasg=false;
            map<string,list<string>> cityfildnmmapTmp=asgCityMap.get(asg.Id);
            for(string citynme:cityfildnmmapTmp.keyset())
            {
                GA_City_Code__c citycde=cityNamMap.get(citynme);
                for(string fldapi:cityfildnmmapTmp.get(citynme))
                {
                    uptasg=true;
                    asg.put(fldapi,citycde.Id);
                }
                
            }
            if(uptasg)
                asgToUpdate.add(asg);
        }
        if(asgToUpdate.size()>0)
            database.update(asgToUpdate);
    }
    private static void chngeInactivToActvCnt(set<id> matchedCntIds)
    {
        list<contact> cntLst=[select id,Active__c from contact where id in :matchedCntIds and Active__c=false];
        list<contact> cntToUpdte=new list<contact>();
        for(contact cnt:cntLst)
        {
            cnt.Active__c=true;
            cntToUpdte.add(cnt);
        }
        database.update(cntToUpdte);
    }
    
    /** D1812
@Description: customException class 
@Name : Exception
@Param : None
@Return : 
@throws Exception : N/A;
*/ 
    public with sharing class customException extends Exception {}
    // End D1812
    
    @AuraEnabled
    public static string newAccountASEPPrcss(GA_Agent_Sold_Enrollment__c AsepRec,Account accRec,list<GA_Agent_Sold_Group__c> AsgRecs)
    {
        try
        {
            list<GA_Agent_Sold_Group__c> asgLst=new list<GA_Agent_Sold_Group__c>();
            list<id> asgrpId=new list<id>();
            set<id> asContactids=new set<Id>();
            Date corporateRecvdDt ;
            if(asepRec.GA_Decision_Maker__c !=null)
                asContactids.add(asepRec.GA_Decision_Maker__c);
            if(asepRec.GA_Mutual_Voter__c !=null)
                asContactids.add(asepRec.GA_Mutual_Voter__c);
            if(asepRec.GA_CEO__c !=null)
                asContactids.add(asepRec.GA_CEO__c);
            if(asepRec.GA_Principal_Admin__c !=null)
            {       
                asContactids.add(asepRec.GA_Principal_Admin__c); 
            }        
            for(GA_Agent_Sold_Group__c asg:AsgRecs)
            {
                if(asg.GA_Billing_Contact_Id__c !=null)
                    asContactids.add(asg.GA_Billing_Contact_Id__c);
                if(asg.GA_Administrative_Contact_Id__c !=null)
                    asContactids.add(asg.GA_Administrative_Contact_Id__c);
                if(asg.GA_Corporate_Received_Date__c != null)
                    corporateRecvdDt = asg.GA_Corporate_Received_Date__c ;
                asgrpId.add(asg.Id);
            }
            
            list<Account> accLst=new list<Account>();
            
            
            if(accRec ==null)
            { // Added Start D1812
                Integer count= [SELECT COUNT() FROM Account WHERE Federal_Tax_ID__c =: AsepRec.GA_Federal_Tax_ID__c AND Name =: AsepRec.GA_Account_Name__c AND (RecordType.Name = 'Account - Prospect' OR RecordType.Name = 'Account - Customer' OR RecordType.Name = 'Account - Inactive')];
                System.debug('GA_AP_ASEPRecordMatchCls Count D1812: '+count);
                if(count > 0){ 
                    throw new customException('You are trying to create a duplicate record. We recommend you use an existing Account instead');
                }
                else{ // End of D1812
                    accLst=creteAccRecs(AsepRec.Id,null);
                    database.insert(accLst); 
                }  
            }
            else
            {
                if(accRec.RecordType.Name ==accPrspct || accRec.RecordType.Name ==accInactive)
                {
                    accLst=creteAccRecs(AsepRec.Id,accRec);       
                    database.update(accLst);
                }
                else
                {
                    accLst.add(accRec);
                }
                
            }
            
            
            list<id> asCntIdlst=new list<id>();
            asCntIdlst.addAll(asContactids);
            list<GA_Agent_Sold_Contact__c> agnSLdCntLsttoUpdte = new list<GA_Agent_Sold_Contact__c>();
            map<string,string> newCntASCNtMap=createNewContact(asCntIdlst,accLst[0]);
            for(string newCntASCnt:newCntASCNtMap.keySet())
            {
                GA_Agent_Sold_Contact__c agSldCnt=new GA_Agent_Sold_Contact__c();
                agSldCnt.Id=newCntASCnt;
                agSldCnt.GA_Matched_Contact__c=newCntASCNtMap.get(newCntASCnt); 
                agnSLdCntLsttoUpdte.add(agSldCnt);
            }
            if(agnSLdCntLsttoUpdte.size()>0)
            {
                database.update(agnSLdCntLsttoUpdte);
            }
            list<GA_Group_Segment__c> grpLst=new list<GA_Group_Segment__c> ();
            if(asgrpId.size()>0)
            {
                set<id> asgIdset=new set<id>();
                asgIdset.addAll(asgrpId);
                updateAsgCities(asgIdset);
                grpLst= createGrpSGmnts(asgrpId,accLst[0]);   
                updteASGrps(grpLst);
            }                          
            // if(accLst[0].RecordTypeId ==Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId())
            linkAccCntacts(AsepRec.Id,accLst[0]);
            list<string> slectedGrp=new list<string>();
            for(GA_Group_Segment__c grp:grpLst)
            {
                slectedGrp.add(grp.Id);
            }
            
            list<GA_WFT_workflow__c> wfTeplt=[select id,GA_Carrier__c, GA_Method__c,GA_Process_Subtype__c, GA_Process_Type__c from GA_WFT_workflow__c where GA_Carrier__c=:AsepRec.GA_Carrier__c and Name like :agntsldEnrlmnt limit 1];
            if(wfTeplt.size()>0 && grpLst.size()>0)
                createNewwrkflow(accLst[0].Id, wfTeplt[0], string.join(slectedGrp, commaOp),AsepRec.id,grpLst[0].GA_Benefit_Effective_Date__c,corporateRecvdDt);
            updateASEPRecPrcss(AsepRec,accLst[0]);
            return accLst[0].Id; 
        }
        catch(exception e)
        {
            if(e.getMessage().contains('INVALID_EMAIL_ADDRESS')){
                throw new AuraHandledException(system.label.invalid_contact_email);
            }else if(e.getMessage().contains('Invalid id:')){
                throw new AuraHandledException(system.label.Agent_missing);
            }else if(e.getMessage().contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY')){
                String s = e.getMessage().substringAfter('Assertion Failed:');
                s = s.substringBefore(')')+'). Please select existing contacts in previous screen';
                throw new AuraHandledException(s);
            }
            GA_LogExceptionCls.LogExcp(e, ClsName, methodasepRnly); throw new AuraHandledException(e.getMessage());
        }
        
    }
    /* @AuraEnabled
public static boolean changeBackASEPStatus(id asepId,string asepStatus)
{
GA_Agent_Sold_Enrollment__c AsepRec =new GA_Agent_Sold_Enrollment__c();
AsepRec.Id=asepId;
AsepRec.GA_ASEP_Status__c=asepStatus;
database.update(AsepRec);
return true;
}*/
    private static void updateASEPRecPrcss(GA_Agent_Sold_Enrollment__c AsepRec,account accRec)
    {
        AsepRec.GA_ASEP_Processed__c=true;
        AsepRec.GA_Account_Id__c=accRec.Id;
        AsepRec.GA_ASEP_Status__c=asepApvd;
        AsepRec.GA_IM_STATUS__c = asepBCBSMmsg;
        database.update(AsepRec);
    }
    private static void linkAccCntacts(id AsepRecId,account accRec)
    {
        list<GA_Agent_Sold_Enrollment__c> AsepLst=new list<GA_Agent_Sold_Enrollment__c>();
        list<GA_AsepAcctConfig__mdt> AsepAccntMapLst =[SELECT Label,GA_Acct_Api_Name__c,GA_ASEP_Api_Name__c FROM GA_AsepAcctConfig__mdt limit 100];
        string AsepAccntQry=slctLbl;
        integer i=0;
        for(GA_AsepAcctConfig__mdt AsepAccntMap:AsepAccntMapLst)
        {
            AsepAccntQry=AsepAccntQry+AsepAccntMap.GA_ASEP_Api_Name__c;
            if(i<AsepAccntMapLst.size()-1)
            {
                AsepAccntQry=AsepAccntQry+commaOp;
            }
            i++;
        }
        AsepAccntQry=AsepAccntQry+enrlmntqry;
        AsepLst=database.query(AsepAccntQry);
        list<GA_AsepAcctConfig__mdt> AsepAccntMapLstUptdfLds =[SELECT Label,GA_Acct_Api_Name__c,GA_ASEP_Api_Name__c FROM GA_AsepAcctConfig__mdt where GA_Update_Fields__c=true limit 100];
        for(GA_AsepAcctConfig__mdt AsepAccntMap:AsepAccntMapLstUptdfLds)
        {
            accRec.GA_Is_Mass_Updating__c=true;
            if(AsepLst[0].get(AsepAccntMap.GA_ASEP_Api_Name__c) !=null)
                accRec.put(AsepAccntMap.GA_Acct_Api_Name__c,AsepLst[0].get(AsepAccntMap.GA_ASEP_Api_Name__c));
            
        }
        database.update(accRec);
    }
    
    private static list<account> creteAccRecs(id AsepRecId,account accRecVal)
    {
        list<GA_Agent_Sold_Enrollment__c> AsepLst=new list<GA_Agent_Sold_Enrollment__c>();
        list<GA_AsepAcctConfig__mdt> AsepAccntMapLst =[SELECT Label,GA_Acct_Api_Name__c,GA_ASEP_Api_Name__c FROM GA_AsepAcctConfig__mdt where GA_Update_Fields__c=false limit 100];
        string AsepAccntQry=slctLbl;
        integer i=0;
        for(GA_AsepAcctConfig__mdt AsepAccntMap:AsepAccntMapLst) {
            AsepAccntQry=AsepAccntQry+AsepAccntMap.GA_ASEP_Api_Name__c;
            if(i<AsepAccntMapLst.size()-1)
            {
                AsepAccntQry=AsepAccntQry+commaOp;
            }
            i++;
        }
        AsepAccntQry=AsepAccntQry+enrlmntqry;
        AsepLst=database.query(AsepAccntQry);
        
        list<Account> AccLst=new list<Account>();
        for(SObject AsepRecTmp : AsepLst){  
            Account accRec=new Account();
            if(accRecVal !=null)
            {
                accRec.Id=  accRecVal.Id;
            }
            
            //  04282019/1527  : Removed Account Status updation to Active
            // accRec.Account_Status__c=AccSTsVal;
            // accRec.GA_System_of_Record__c=SysOfRecVal;
            accRec.Type_of_Employer__c=SmlGrpVal;
            accRec.GA_Is_Mass_Updating__c=true;
            accRec.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(accPrspct).getRecordTypeId();
            accRec.Account_Status__c='Inactive';
            
            for(GA_AsepAcctConfig__mdt AsepAccntMap:AsepAccntMapLst){
                if(AsepLst[0].get(AsepAccntMap.GA_ASEP_Api_Name__c) !=null)
                {
                    
                    if( ( AsepAccntMap.GA_ASEP_Api_Name__c==TotlEmpField || AsepAccntMap.GA_ASEP_Api_Name__c==TotalEligble ) && AsepRecTmp.get(AsepAccntMap.GA_ASEP_Api_Name__c) !=null)
                        accRec.put(AsepAccntMap.GA_Acct_Api_Name__c,integer.valueOf(AsepRecTmp.get(AsepAccntMap.GA_ASEP_Api_Name__c))); 
                    else
                    {
                        accRec.put(AsepAccntMap.GA_Acct_Api_Name__c,AsepRecTmp.get(AsepAccntMap.GA_ASEP_Api_Name__c));  
                    }
                }
                
            }
            
            AccLst.add(accRec);
        }
        
        return AccLst;
    }
    private static void updteASGrps(list<GA_Group_Segment__c> grpLst)
    {
        list<GA_Agent_Sold_Group__c> asgLst=new list<GA_Agent_Sold_Group__c>();
        GA_Agent_Sold_Group__c asgTmp=new GA_Agent_Sold_Group__c();
        for(GA_Group_Segment__c grp:grpLst)
        {
            asgTmp=new GA_Agent_Sold_Group__c();
            asgTmp.id=grp.GA_Agent_Sold_Group__c;
            asgTmp.GA_Group_Id__c=grp.Id;
            asgLst.add(asgTmp);
        }
        database.update(asgLst);
    }
    private static list<GA_Group_Segment__c> createGrpSGmnts(list<id> asgLstId,account accRec)
    { 
        list<GA_Agent_Sold_Group__c> asgLst=new list<GA_Agent_Sold_Group__c>();
        list<GA_ASG2GS_Config__mdt> AsgMapLst =[SELECT Label,GA_ASGrp_API_Name__c,GA_Grp_Seg_API_Name__c FROM GA_ASG2GS_Config__mdt limit 100];
        string AsgQry=slctLbl+' GA_Agent_Id__c,';
        integer i=0;
        set<string> asgFiledAPIs=new set<string>();
        for(GA_ASG2GS_Config__mdt AsgMap:AsgMapLst)
        {
            asgFiledAPIs.add(AsgMap.GA_ASGrp_API_Name__c);
        }
        for(string asgFilds:asgFiledAPIs)
        {
            AsgQry=AsgQry+asgFilds;
            if(i<asgFiledAPIs.size()-1)
            {
                AsgQry=AsgQry+commaOp;
            }
            i++;
        }
        AsgQry=AsgQry+mngingAGncyCde+asgqryEnd;
        asgLst=database.query(AsgQry);
        String aorAgntId =  '';
        set<string> mangingAgncyCde=new set<string>();
        for(GA_Agent_Sold_Group__c asg:asgLst)
        {
            if(asg.GA_Managing_Agency_Code__c !=null)
            {
                mangingAgncyCde.add(asg.GA_Managing_Agency_Code__c);
            }
            if(asg.GA_Agent_Id__c != null){
                aorAgntId = asg.GA_Agent_Id__c;
            }
        }
        
        
        list<account> accAgnctLst=[select id,GA_Agency_Code__c from account where GA_Agency_Code__c in :mangingAgncyCde limit 100];
        map<string,list<id>> agncyCodeAcc=new map<string,list<id>>();
        list<id> accAgncyIds=new list<id>();
        for(account acc:accAgnctLst) {
            if(agncyCodeAcc.get(acc.GA_Agency_Code__c) !=null)
            {
                accAgncyIds=agncyCodeAcc.get(acc.GA_Agency_Code__c);
            }
            else
                accAgncyIds=new list<id>();
            accAgncyIds.add(acc.Id);
            agncyCodeAcc.put(acc.GA_Agency_Code__c,accAgncyIds);
        }
        
        list<GA_Group_Segment__c> GrpLst=new list<GA_Group_Segment__c>();
        for(SObject AsgTmp : asgLst)
        {  
            GA_Group_Segment__c grpRec=new GA_Group_Segment__c();
            grpRec.GA_Account__c=accRec.id;
            grpRec.GA_SourceASG__c=true;
            grpRec.GA_Agent_Sold_Group__c=AsgTmp.Id;
            if(AsgTmp.get(mngingAGncyCdeCmp) !=null && agncyCodeAcc.get(string.valueof(AsgTmp.get(mngingAGncyCdeCmp))) !=null  && agncyCodeAcc.get(string.valueof(AsgTmp.get(mngingAGncyCdeCmp))).size()==1)
                grpRec.GA_Managing_Agency__c=agncyCodeAcc.get(string.valueof(AsgTmp.get(mngingAGncyCdeCmp)))[0];
            for(GA_ASG2GS_Config__mdt AsgMap:AsgMapLst)
            {
                if(AsgTmp.get(AsgMap.GA_ASGrp_API_Name__c) !=null)
                    grpRec.put(AsgMap.GA_Grp_Seg_API_Name__c,AsgTmp.get(AsgMap.GA_ASGrp_API_Name__c));
                
            }
            
            GrpLst.add(grpRec);
        }
        
        
        if(GrpLst.size()>0)
        {
            asepGrpSeg = true;
            database.insert(GrpLst);
        }
        
        list<GA_Group_Association__c> grpAsstintoCrte=new list<GA_Group_Association__c>();
        list<GA_DC_Small_Grp_History__c> dcsmallGrpLst=new list<GA_DC_Small_Grp_History__c>();
        GA_DC_Small_Grp_History__c dcsmlgrpTmp=new GA_DC_Small_Grp_History__c();
        list<GA_Managing_Agency_History__c> mngnAgncyHstryLst = new list<GA_Managing_Agency_History__c>();
        GA_Managing_Agency_History__c mghRecTmp = new GA_Managing_Agency_History__c();
        
        
        
        for(GA_Group_Segment__c grp:GrpLst)
        {
            //removed Association creation to resolve D-1541
            //if(grp.GA_ASEP_Association_ID__c !=null)
            //{
            //    GA_Group_Association__c grpAsstn=new GA_Group_Association__c();
            //    grpAsstn.GA_Account__c=grp.GA_ASEP_Association_ID__c;
            //    grpAsstn.GA_Group_Segment__c=grp.Id;
            //    grpAsstn.GA_Start_Date__c=system.today();
            //    grpAsstn.GA_End_Date__c=date.newinstance(2099, 12, 31);
            //    grpAsstintoCrte.add(grpAsstn);  
            // }
            if(grp.GA_Suite__c !=null && grp.GA_Suite_Start_Date__c !=null)
            {
                dcsmlgrpTmp=new GA_DC_Small_Grp_History__c();
                dcsmlgrpTmp.GA_Suite__c=grp.GA_Suite__c;
                dcsmlgrpTmp.GA_Group_Segment_Id__c=grp.Id;
                dcsmlgrpTmp.GA_Suite_Start_Date__c=date.valueof(grp.GA_Suite_Start_Date__c);
                dcsmlgrpTmp.GA_Suite_End_Date__c=date.newinstance(2099, 12, 31);
                dcsmallGrpLst.add(dcsmlgrpTmp);  
            }
            if(grp.GA_Managing_Agency__c !=null)
            {
                mghRecTmp = new GA_Managing_Agency_History__c();
                mghRecTmp.GA_Start_Date__c=system.today();
                mghRecTmp.GA_End_Date__c=date.newinstance(2099, 12, 31);
                // US 3339 Start
                if(grp.GA_Group_Effective_Date__c != null){
                    mghRecTmp.MA_Override_Start_Date__c= grp.GA_Group_Effective_Date__c; //system.today(); 
                }
                mghRecTmp.MA_Override_End_Date__c=date.newinstance(2099, 12, 31);
                // US 3339 End
                mghRecTmp.GA_Managing_Agency__c=grp.GA_Managing_Agency__c;
                mghRecTmp.GA_Group_Segment__c=grp.id;
                mngnAgncyHstryLst.add(mghRecTmp);
            }
        }
        
        if(GrpLst.size() > 0){
            createNewAOR( accRec, aorAgntId, GrpLst);
        }
        
        if(grpAsstintoCrte.size()>0)
            database.insert(grpAsstintoCrte);
        if(dcsmallGrpLst.size()>0)
            database.insert(dcsmallGrpLst);
        if(mngnAgncyHstryLst.size()>0)
            database.insert(mngnAgncyHstryLst);
        list<GA_Group_Segment__c> grpSgmntToUpdte=new list<GA_Group_Segment__c>();
        for(GA_Group_Association__c grpAssc:grpAsstintoCrte)
        {
            GA_Group_Segment__c grp=new GA_Group_Segment__c();
            grp.Id=grpAssc.GA_Group_Segment__c;
            grp.GA_Group_Association_id__c=grpAssc.Id;
            grpSgmntToUpdte.add(grp);
        }
        database.update(grpSgmntToUpdte);
        return GrpLst;
    }
    
    private static void createNewwrkflow(string accountId,GA_WFT_workflow__c wfTmplt,string selectedGrpIds,string asepRecId,Date BenefitEffDt,Date corporateRecvdDt)
    {
        
        GA_WF_Workflow__c wfRec=new GA_WF_Workflow__c(Name = wfTmplt.GA_Process_Type__c + hypnVal +Datetime.now().format(mnthYrFrmt),
                                                      GA_Account__c = accountId,  
                                                      GA_ASEP__c=asepRecId,
                                                      Sub_Type__c = wfTmplt.GA_Process_Subtype__c,
                                                      GA_Type__c = wfTmplt.GA_Process_Type__c,
                                                      GA_Carrier__c = wfTmplt.GA_Carrier__c,
                                                      GA_Method__c = wfTmplt.GA_Method__c,
                                                      GA_Workflow_Template__c = wfTmplt.Id,
                                                      GA_Status__c = opnLbl,
                                                      GA_External_Initiated__c=true,
                                                      GA_Selected_Group_Segments__c=selectedGrpIds,
                                                      GA_Benefit_Effective_Date__c=BenefitEffDt,
                                                      GA_Corporate_Received_Date__c=corporateRecvdDt,
                                                      GA_Date_Opened__c=system.today());
        database.insert(wfRec);
        list<GA_WF_Group_Segment__c> wfPrcssRecs=[select id from GA_WF_Group_Segment__c where GA_Workflow_ID__c =:wfRec.Id and GA_WF_Step_ID__c !=null];
        GA_WF_Group_Segment__c wfprcssTmp;
        list<GA_WF_Group_Segment__c> wfPrcssRecsUpdtOwnr=new list<GA_WF_Group_Segment__c>();
        for(GA_WF_Group_Segment__c wfprcss:wfPrcssRecs)
        {
            wfprcssTmp=new GA_WF_Group_Segment__c();
            wfprcssTmp.Id=wfprcss.Id;
            wfprcssTmp.ownerId=userInfo.getUserId();
            wfPrcssRecsUpdtOwnr.add(wfprcssTmp);
        }
        if(wfPrcssRecsUpdtOwnr.size()>0)
        {
            database.update(wfPrcssRecsUpdtOwnr);
        }
    }
    private static map<string,string> createNewContact(list<id> AscCntIdLst,account accRec)
    {
        list<GA_Agent_Sold_Contact__c> AscCntLst=new list<GA_Agent_Sold_Contact__c>();
        list<GA_ASC2CntConfig__mdt> ASCCntMapLst =[SELECT Label,GA_Act_Contact__c,GA_ASG_Api__c FROM GA_ASC2CntConfig__mdt limit 100];
        string ASCntQry=slctLbl;
        integer i=0;
        for(GA_ASC2CntConfig__mdt ASCCntMap:ASCCntMapLst)
        {
            ASCntQry=ASCntQry+ASCCntMap.GA_ASG_Api__c;
            if(i<ASCCntMapLst.size()-1)
            {
                ASCntQry=ASCntQry+commaOp;
            }
            i++;
        }
        ASCntQry=ASCntQry+ascqry;
        AscCntLst=database.query(ASCntQry);
        //Set<String> cntCmb = new Set<String>();
        //list<Contact> CntCrtLst=new list<Contact>();
        Map<String,Contact> cntCmbMap = New Map<String,Contact>();
        Map<String,Contact> dupCntCmbMap = New Map<String,Contact>();
        String cnctCmbStr = '';
        for(SObject AscCnt : AscCntLst)
        {  
            Contact cntRec=new Contact();
            cntRec.AccountId=accRec.Id;
            cntRec.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get(cntRecType).getRecordTypeId();
            for(GA_ASC2CntConfig__mdt ASCCntMap:ASCCntMapLst)
            {
                cntRec.put(ASCCntMap.GA_Act_Contact__c,AscCnt.get(ASCCntMap.GA_ASG_Api__c));
            }
            Contact existingContact = New Contact();
            String mapKey = '';
            Boolean cmbExists = false;
            //system.debug(cntCmbMap);
            if(!cntCmbMap.isEmpty()){
                for(String Key : cntCmbMap.keyset()){
                    String cntCmb = cntRec.FirstName+'~'+cntRec.LastName;
                    //system.debug(Key.containsIgnorecase(cntCmb));
                    if(Key.containsIgnorecase(cntCmb) ){
                        if( ((cntRec.Email <> null) && (cntCmbMap.get(Key).Email <> null ) && (cntRec.Email == cntCmbMap.get(Key).Email ) )
                           ||  (cntRec.Email == null)
                           || (cntCmbMap.get(Key).Email == null ) )  {
                               existingContact=cntCmbMap.get(Key);
                               mapKey = mapKey;
                               cmbExists = true;
                               break;
                           }
                        
                    }
                }
            }
            cnctCmbStr = (cntRec.FirstName+'~'+cntRec.LastName+'~'+cntRec.Email).toLowerCase();
            if( !cmbExists){         
                cntCmbMap.put(cnctCmbStr,cntRec);
                //CntCrtLst.add(cntRec);
            }
            else{
                Contact cntTitle = ( cmbExists  ? existingContact : cntCmbMap.get(cnctCmbStr) ) ;
                if(cntRec.Title <> null && cntTitle.Title <> null && !cntTitle.Title.contains(cntRec.Title)){
                    cntTitle.Title = cntTitle.Title + ',' + cntRec.Title ;
                }
                if(cntRec.Email <> null){
                    cntTitle.Email = cntRec.Email ;
                }
                //  dupCntCmbMap.put(cnctCmbStr+'^'+AscCnt.id,cntTitle);
                if(cmbExists && cntCmbMap.containsKey(mapKey))
                {
                    cntCmbMap.remove(mapKey); 
                    
                    cntCmbMap.put(cnctCmbStr,cntTitle);
                }
                dupCntCmbMap.put(AscCnt.id,cntTitle);
                
            }       
        }
        
        //system.debug(cntCmbMap);
        //system.debug(dupCntCmbMap);
        
        if(cntCmbMap.size()>0)
        {
            duplicateChecker=True;
            database.insert(cntCmbMap.values());
        } 
        map<string,string> cntAsCntMap=new map<string,string>();
        for(contact Cnt:cntCmbMap.values())
        {
            cntAsCntMap.put(Cnt.GA_ASContact_ID__C,Cnt.Id);
        }
        
        for(String dupCntCmb : dupCntCmbMap.keySet())
        {
            //  if(cntCmbMap.containsKey(dupCntCmb.substringbefore('^'))){
            cntAsCntMap.put(dupCntCmb,dupCntCmbMap.get(dupCntCmb).id);
            //  }
        }
        return cntAsCntMap;
    }
    
    //Added on 6/17/2019 for AOR new record creation
    public static void createNewAOR(account accRec,String aorAgntId,List<GA_Group_Segment__c> GrpLst){
        
        list<GA_AOR__c> accAORLst = new list<GA_AOR__c>();
        GA_AOR__c aorRec = New GA_AOR__c();
        GA_AOR_Group_Segment__c newAorGs = New GA_AOR_Group_Segment__c();
        List<GA_AOR_Group_Segment__c> newAorGsLst = New  List<GA_AOR_Group_Segment__c>();
        
        accAORLst = [Select id,GA_Contact_Id__c from GA_AOR__c where  GA_Account_Id__c =: accRec.id 
                     and GA_Service_End_Date__c >= Today Limit 1];
        //GA_Contact_Id__c =: aorAgntId  and
        if(accAORLst.size() > 0){
            for(GA_AOR__c currAor : accAORLst){
               if(accAORLst[0].GA_Contact_Id__c == aorAgntId ) 
                for(GA_Group_Segment__c gs: GrpLst ){
                    newAorGs = New GA_AOR_Group_Segment__c();
                    newAorGs.GA_AOR_Id__c = accAORLst[0].id;
                    newAorGs.GA_Group_Segment_Id__c = gs.id; 
                    newAorGs.GA_Is_Mass_Updating__c = true;
                    newAorGsLst.add(newAorGs);
                }
            else{
                aorRec.GA_Account_Id__c=accRec.Id;
                aorRec.GA_Contact_Id__c=aorAgntId;
                aorRec.GA_Commission_Start_Date__c=(GrpLst[0].GA_Benefit_Effective_Date__c <> null ? GrpLst[0].GA_Benefit_Effective_Date__c : system.today() );
                aorRec.GA_Service_Start_Date__c= null;
                aorRec.GA_Service_End_Date__c= null;
                aorRec.GA_IsProcessedEmail__c=false;
                aorRec.GA_Is_Mass_Updating__c =  true;
                GA_updateAORGSSvcCls.stopSrvEndtLogic = true;
                Database.insert(aorRec,false); 
                
                /** 
                aorRec.GA_Service_Start_Date__c= null;
                aorRec.GA_Service_End_Date__c= null;
                Database.update(aorRec,false);   **/ 
                
                for(GA_Group_Segment__c gs: GrpLst ){
                    newAorGs = New GA_AOR_Group_Segment__c();
                    newAorGs.GA_AOR_Id__c = aorRec.id;
                    newAorGs.GA_Group_Segment_Id__c = gs.id; 
                    newAorGs.GA_Is_Mass_Updating__c = true;
                    newAorGsLst.add(newAorGs);
                }
                
            }  
            }
            
           
        }
        else{
            
            aorRec.GA_Account_Id__c=accRec.Id;
            aorRec.GA_Contact_Id__c=aorAgntId;
            aorRec.GA_Commission_Start_Date__c=(GrpLst[0].GA_Benefit_Effective_Date__c <> null ? GrpLst[0].GA_Benefit_Effective_Date__c : system.today() );
            aorRec.GA_Service_Start_Date__c=(GrpLst[0].GA_Benefit_Effective_Date__c <> null ? GrpLst[0].GA_Benefit_Effective_Date__c : system.today() );
            aorRec.GA_IsProcessedEmail__c=false;
            aorRec.GA_Is_Mass_Updating__c =  true;
            GA_updateAORGSSvcCls.stopSrvEndtLogic = true;
            Database.insert(aorRec,false);
            
            for(GA_Group_Segment__c gs: GrpLst ){
                newAorGs = New GA_AOR_Group_Segment__c();
                newAorGs.GA_AOR_Id__c = aorRec.id;
                newAorGs.GA_Group_Segment_Id__c = gs.id;  
                newAorGs.GA_Is_Mass_updating__c = true;
                newAorGsLst.add(newAorGs);
            }
        }
        
        if(newAorGsLst.size() > 0){
            Database.insert(newAorGsLst,false);
        }
        
    }
    
    //Added on 6/17/2019 for AOR new record creation
    /*public static void chkexistingAORrecs(List<GA_AOR__c> aorList){
set<string> setAccId = new set<string>();
Set<Id> asepIds = New  Set<Id>();
list<GA_AOR__c> aorRecsList = new list<GA_AOR__c>();
for(GA_AOR__c aor : aorList){
setAccId.add(aor.GA_Account_Id__c);
}
map<Id, Account> mapAccount = new map<Id, Account>([select id,(select id,GA_Account_Id__c from AOR__r) 
from Account where Id IN: setAccId]);
for(GA_Agent_Sold_Enrollment__c asep : [select id,GA_Account_Id__c from GA_Agent_Sold_Enrollment__c where GA_Account_Id__c IN :setAccId])
{
for(GA_Agent_Sold_Group__c asg :[select id,GA_Agent_Id__c,GA_Benefit_Effective_Date__c,GA_Managing_Agent_Sale_Enroll_Id__c 
from GA_Agent_Sold_Group__c where GA_Managing_Agent_Sale_Enroll_Id__c IN:asepIds]){
for(GA_AOR__c aor : [select id,GA_Contact_Id__c,GA_Account_Id__c,
GA_Commission_Start_Date__c,GA_Service_Start_Date__c,
GA_IsProcessedEmail__c from GA_AOR__c where GA_Account_Id__c IN:setAccId]){
if(mapAccount.containsKey(aor.GA_Account_Id__c)){
if(mapAccount.get(aor.GA_Account_Id__c).AOR__r.size()==0){
GA_AOR__c aorRecs = new GA_AOR__c();
aorRecs.GA_Account_Id__c=asep.GA_Account_Id__c;
aorRecs.GA_Contact_Id__c=asg.GA_Agent_Id__c;
aorRecs.GA_Commission_Start_Date__c=asg.GA_Benefit_Effective_Date__c;
aorRecs.GA_Service_Start_Date__c=null;
aorRecs.GA_IsProcessedEmail__c=false;
//aorRecsList.add(aorRecs); 
}
}
}
}
}
//database.insert(aorRecsList);
} */
    
    public class AccWrap{
        @AuraEnabled
        public boolean disbleSlct;
        @AuraEnabled
        public account accRec;
        
    }
    public class AsepAccWrap{
        @AuraEnabled
        public list<AccWrap> accRecs;
        @AuraEnabled
        public GA_Agent_Sold_Enrollment__c AsepRec;
        @AuraEnabled
        public list<GA_Agent_Sold_Group__c> AsgRecs;
        @AuraEnabled 
        public list<CntASCntWrap> CntRecs;
        @AuraEnabled
        public list<newCntWrapCls> newCntWrapRecs;
        @AuraEnabled
        public Boolean accessMsg;
    }
    public class CntASCntWrap {
        @AuraEnabled 
        public list<cntMtchCntWrap> cntLst;
        @AuraEnabled 
        public GA_Agent_Sold_Contact__c Ascnt;
        @AuraEnabled 
        public string ASEPRole;
        @AuraEnabled
        public boolean isExactMtch;
        
    }
    public class newCntWrapCls
    {
        
        @AuraEnabled
        public GA_Agent_Sold_Contact__c agntSldCnt;
        @AuraEnabled
        public string CntRle;
        @AuraEnabled
        public string ObjInfo;
        
    }
    public class cntMtchCntWrap implements Comparable
    {
        @AuraEnabled 
        public boolean slctCnt;
        @AuraEnabled 
        public contact cntctMtch;
        @AuraEnabled 
        public integer  countMtch;
        
        public Integer compareTo(Object compareTo) {
            cntMtchCntWrap compareToEmp = (cntMtchCntWrap)compareTo;
            if (countMtch == compareToEmp.countMtch) return 0;
            if (countMtch > compareToEmp.countMtch) return 1;
            return -1;
        }
    }
    public class ExtCntWrapCls
    {
        @AuraEnabled
        public Contact CntRec;
        @AuraEnabled
        public string CntRle;      
        
    }
    public class AsepReadoNlywrp
    {
        @AuraEnabled
        public Account acc;
        @AuraEnabled
        public list<ExtCntWrapCls> cntRecWIthrle;
        @AuraEnabled
        public list<GA_Agent_Sold_Group__c> asgLst;
    }
}