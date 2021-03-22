/**
@Author : Surya Peddada.
@Name: ARV_AP92_RenewalListViews
@CreatedDate: 10-March-2020
@Description: ARV_AP92_RenewalListViews List views for contract.....
@version : 1.0 
*/
public without Sharing class ARV_AP92_RenewalListViews { 
    private static final String METADATA_QRY = 'SELECT MasterLabel, QualifiedApiName,'+
        'Month__c FROM ARV_Renewal_Contract_List_View__mdt order by MasterLabel asc';
    private static final String CONTRACT_QRY = system.label.ARV_CONTRACT_RENEWAL_QUERY;
    private static final String PROCEDURE_NAME = 'RenewalBatch_Generate';
    public string profileName;
    private static final String RENEWALWHERECLAUSE=' where id=:paramId1';
    private static final String PROFILE_QRY = 'SELECT Id, Name FROM Profile';
    private static final String CANCELED = 'Canceled';
    private static final String C_CANCELLED = 'Cancelled';
    private static final String WITHDRAW='Withdraw';
    private static final String PEND='Pend';
    private static final String READY='Ready';
    private static final String ERROR='Contract Error';
    private static final String ERRORMSG='Error - Pre-validation';
    private static final String N_NO='No';
    private static final String Y_YES='yes';
    private static final String RENEWAL='Renewal';
    private static final String RENEWALMSG='Renewal Packages Creation Failed.';
    private static final String FAILED='Failed';
    private static final String PENDING = 'Pending';
    private static final String PROFILE_QUERY='select id,name from Profile';
    private static final String PROFILE_WHRCLS=' where id=:paramId1';
    private static final String PLANS_QUERY = 'select Id,Name,vlocity_ins__ContractId__c,'+
        'vlocity_ins__Product2Id__r.Id,vlocity_ins__Product2Id__r.vlocity_ins__EndDate__c'+
        ',vlocity_ins__Product2Id__r.vlocity_ins__EffectiveDate__c from vlocity_ins__ContractLineItem__c';
    private static final String PLANS_WHERE = ' where vlocity_ins__ContractId__c in:idsList';
    private static final String EXCLUDE_CONTRACT_QUERY = 'Select Id,ARV_Excluded_from_Renewal__c,'+
        'AccountId,vlocity_ins__ExpiredContractId__c,'+
        'Account.Renewal_month__c,ARV_Requested_Effective_Date__c from Contract';
    private static final String EXCLUDE_CONTRACT_WHERE_QUERY = ' Where id in:idsList';
    private static final String CONTRACT_QRY_LIMIT = 'LIMIT 5 OFFSET 0';
    private static final String CONTRACT_LISTVIEWS_QUERY = 'SELECT MasterLabel, QualifiedApiName,Sort_Order__c,'+
        'Component_Name__c FROM ARV_Contract_List_View__mdt order by Sort_Order__c asc';
    private static final String TEXT_SG='SG';
    private static final String ACTIVED = 'Active';
    private static final String ACTIVATED='Activated';
    private static final String FUTURED = 'Future';
    private static final String RUNNING = 'Running';
    private static final String EMPTY_STRING = '';
    private static final String LIMIT_QRY=' limit 100';
    private static final String RENEWALBTQRY='select id,ARV_Renewal_Month__c,ARV_Completed_Date__c from  Renewal_Batch__c';
    private static final String RENBTCHWHERECLAUSE='  where id=:paramId1';
    private static final String LIMIT1=' limit 1';
    private static final String ACCQRY='select id, Renewal_month__c from account ';
    private static final String ACCWHERECLAUSE=' where id=:paramId5';
    private static final String BATCH_TITLE = 'SG Renewal_';
    private static final String COMPLETED = 'Completed';
    private static final String ID1= 'Id';
    private static final String MERGEDATA='mergeData';
    private static final String CONTRACTTYPE='ContractType';
    private static final String MULTIPLE ='Multiple';
    private static final String SINGLE='Single';
    private static final String APEXJOBID='ApexJobId';
    private static final String SUCCESS_IP = 'Success - IP';
    private static final String SUCCESS_INTEGRATION = 'Success - Integration';
    private static final String ERROR_PREVALIDATION = 'Error - Pre-validation';
    private static final String PRODUCT_ERROR = 'Product Error';
    private static final String SUCCESS_PREVALIDATION = 'Success - Pre-validation';
    private static final String NO_CROSS_WALKPRODUCT_ASSIGN = 'No Product Crosswalk assign';
    private static final String INVALID_PRODUCT_CROSSWALK = 'Invalid Product Crosswalk for '; 
    private static final String SGUNDERWRITER='Small Group Underwriter';
    private static final String SGUMANAGER='Small Group Underwriting Manager';
    private static final string ACCOUNTQUERY='Select id,ARV_BatchId__c from Account';
    private static final string ACCOUNTWHERE=' where Id in:paramId2';
    private static final string ILNUMBER='920';
    private static final string HYPHEN='-';
    private static final string COMMA=',';
    private static final String  SGEnrollment = 'Small Group Enrollment';
    private static final String  SGRenewal = 'Small Group Renewal';
    private static Set<Id> conUniqueID = new Set<Id>(); /*Added for Error List view */
    
    
    /**
@Description: listValues() method
@Name : listValues
@Param : NA
@Return : ListViewWrapper
@throws Exception : Aura Exception;
*/
    @AuraEnabled
    public static list<ListViewWrapper> listValues(){ 
        try{
            list<ListViewWrapper> oListViewWrapper = new list<ListViewWrapper>();
            List<ARV_Renewal_Contract_List_View__mdt> listViews =ARV_AP07_QueryDataHelper.getsObjects(METADATA_QRY,
                                                                                                      NULL,NULL,LIMIT_QRY);
            for(ARV_Renewal_Contract_List_View__mdt lv : listViews){
                ListViewWrapper oWrapper = new ListViewWrapper();
                oWrapper.label = lv.MasterLabel;
                oWrapper.developerName = lv.Month__c;
                oListViewWrapper.add(oWrapper);
            }
            return oListViewWrapper;    
        } catch( Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
@Description: listViews() method
@Name : listViews
@Param : NA
@Return : ListViewWrapper
@throws Exception : N/A;
*/
    @AuraEnabled
    public static list<ListViewWrapper> listViews(){ 
        try{
            list<ListViewWrapper> oListViewWrapper = new list<ListViewWrapper>();
            List<ARV_Contract_List_View__mdt> listViews =ARV_AP07_QueryDataHelper.getsObjects(CONTRACT_LISTVIEWS_QUERY,
                                                                                              NULL,NULL,LIMIT_QRY);
            for(ARV_Contract_List_View__mdt lv : listViews){ 
                ListViewWrapper oWrapper = new ListViewWrapper();
                oWrapper.label = lv.MasterLabel;
                oWrapper.developerName = lv.Component_Name__c;
                oListViewWrapper.add(oWrapper);
            }
            return oListViewWrapper;    
        } catch( Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
@Description: getListEligibleRecords() method
@Name : getListEligibleRecords
@Param : String MonthName
@Return : Contract
@throws Exception : N/A;
*/
    @AuraEnabled
    public static ContractWrapper getListEligibleRecords(String monthName,Integer rowsLimit,Integer rowsOffset){
        system.debug('rowsLimit'+ rowsLimit);
        List<Id> conids=New List<Id>();
        ContractWrapper conwrap= new ContractWrapper();
        Set<Id> AccountIDs = new Set<Id>();
        
        List<Contract> totallistCon = [select id,contractNumber, status, ARV_Contract_Type__c,AccountId,vlocity_ins__ExpiredContractId__c,
                                       Account.Renewal_Month__c,Account.Name, Account.Id,
                                       ARV_Requested_Renewal_Date_Month__c,Account.GA_Carrier_Code__c,ARV_CF_CNTRCT_CarrierCodes__c,
                                       Account.CID__c, ( select Id,Status__c,GA_Group_Name__c,
                                                        GA_Account_Status__c from Group_Segments__r )
                                       from contract
                                       WHERE ARV_Is_Generate_Renewal__c=false
                                       and Account.Account_Status__c = :ACTIVED
                                       and Account.ARV_Renewal_Account_Type__c=: TEXT_SG
                                       and ARV_Plans_Count__c > 0  
                                       and ARV_Renewal_Error__c=: EMPTY_STRING
                                       and ((ARV_Contract_Type__c Not In (:SGEnrollment, :SGRenewal) and status =: FUTURED) OR status =: ACTIVATED)
                                       and Account.Renewal_Month__c=: monthName 
                                       and ARV_Excluded_from_Renewal__c=false and vlocity_ins__FinalRatingGroupCensusId__r.Premium_Total__c != 0];
        
        
        List<contract>validlistViews= getMonthContract(totallistCon);
        for(Contract eachConId:validlistViews){
            conids.add(eachConId.Id);
        }
        system.debug('conids' + conids);
        conwrap.filtercontractIds=conids;
        conwrap.totalRecords=validlistViews.size();
        system.debug('validlistViews'+validlistViews.size());
        
        List<Contract> listviews=  [select id,contractNumber, status, ARV_Contract_Type__c,AccountId,vlocity_ins__ExpiredContractId__c,
                                    Account.Renewal_Month__c,Account.Name, Account.Id,
                                    ARV_Requested_Renewal_Date_Month__c,Account.GA_Carrier_Code__c,ARV_CF_CNTRCT_CarrierCodes__c,
                                    Account.CID__c, ( select Id,Status__c,GA_Group_Name__c,
                                                     GA_Account_Status__c from Group_Segments__r )
                                    from contract
                                    WHERE ARV_Is_Generate_Renewal__c=false
                                    and Account.Account_Status__c =: ACTIVED
                                    and Account.ARV_Renewal_Account_Type__c=: TEXT_SG
                                    and ARV_Plans_Count__c > 0 
                                    and ARV_Renewal_Error__c=: EMPTY_STRING
                                    and ((ARV_Contract_Type__c Not In (:SGEnrollment, :SGRenewal) and status =: FUTURED) OR status =: ACTIVATED)
                                    and Account.Renewal_Month__c=: monthName
                                    and ARV_Excluded_from_Renewal__c=false and vlocity_ins__FinalRatingGroupCensusId__r.Premium_Total__c != 0 order by contractNumber limit :rowsLimit];
        /* for(Contract cnt:listviews){
if(cnt.ARV_Contract_Type__c!=CONTRACTTYPE1 || cnt.ARV_Contract_Type__c!=CONTRACTTYPE2 && cnt.Status==FUTURED){
finallistcon.add(cnt);
}
else if(cnt.Status==ACTIVATED)
finallistcon.add(cnt);
}*/
        system.debug('listviews'+listviews.size());
        conwrap.totalcontractsList=listviews;
        conwrap.contractsList=getMonthContract(listviews);
        system.debug('contractsList'+conwrap.contractsList.size());
        //conwrap.totalRecords=validlistViews.size();
        
        return conwrap;
    }
    //To return additional records based on offset
    @AuraEnabled
    public static loadContractWrapper loadwrapContractRecords(String finalRecId,String monthName ,Integer rowsLimit){
        loadContractWrapper loadcontrwrap= new loadContractWrapper();
        if(finalRecId != null){
            string querymorerec='select id,contractNumber,AccountId,vlocity_ins__ExpiredContractId__c,'
                +'Account.Renewal_Month__c,Account.Name, '+
                +'Status,ARV_Requested_Renewal_Date_Month__c,Account.GA_Carrier_Code__c,ARV_CF_CNTRCT_CarrierCodes__c,'+
                +'Account.CID__c, ( select Id,Status__c,GA_Group_Name__c,GA_Account_Status__c from Group_Segments__r) from contract';
            querymorerec +=' WHERE ARV_Is_Generate_Renewal__c=false';
            querymorerec +=' and Account.Account_Status__c=\'' +ACTIVED+'\'';
            querymorerec +=' and Account.ARV_Renewal_Account_Type__c=\'' +TEXT_SG+'\'';
            querymorerec +=' and ((ARV_Contract_Type__c Not In (\'Small Group Enrollment\', \'Small Group Renewal\') and status =\'Future\') OR status =\'Activated\')';
            querymorerec +=' and ARV_Plans_Count__c>0';
            querymorerec +=' and ARV_Renewal_Error__c=\'' +EMPTY_STRING+'\'';
            querymorerec +=' and Account.Renewal_Month__c=\'' +monthName+'\'';
            querymorerec +=' and ARV_Excluded_from_Renewal__c=false and contractNumber>\''+finalRecId+'\'' ;
            querymorerec +=' and vlocity_ins__FinalRatingGroupCensusId__r.Premium_Total__c != 0';
            querymorerec +=' order by contractNumber limit '+rowsLimit;
            system.debug('querymorerec'+querymorerec);
            List<Contract>listviews =database.query(querymorerec);
            loadcontrwrap.totalcontractsList=listViews;
            loadcontrwrap.filtercontractsList=getMonthContract(listViews);
        }
        return loadcontrwrap;
        
    }
    
    /**CidSerachMethod**/
    
    @AuraEnabled
    public static List<Contract> getCidSearcContracts(string monthName,String cidId){
        List<String> cidlst=New List<String>();
        cidlst=cidId.split(',');
        set<String> cidset =New Set<String>(cidlst);
        
        
        try {
            List<Contract> listViews = [select id,contractNumber,AccountId,vlocity_ins__ExpiredContractId__c,
                                        Account.Renewal_Month__c,Account.Name, 
                                        Status,ARV_Requested_Renewal_Date_Month__c,Account.GA_Carrier_Code__c,ARV_CF_CNTRCT_CarrierCodes__c,
                                        Account.CID__c, ( select Id,Status__c,GA_Group_Name__c,
                                                         GA_Account_Status__c from Group_Segments__r ) 
                                        from contract 
                                        WHERE /*ARV_Renewal_Status__c=:EMPTY_STRING AND */
                                        Account.CID__c IN:cidset
                                        and ARV_Is_Generate_Renewal__c=false
                                        and Account.Account_Status__c=:ACTIVED
                                        and Account.ARV_Renewal_Account_Type__c=:TEXT_SG 
                                        and ((ARV_Contract_Type__c Not In (:SGEnrollment, :SGRenewal) and status =: FUTURED) OR status =: ACTIVATED)
                                        and ARV_Plans_Count__c>0
                                        and ARV_Renewal_Error__c=:EMPTY_STRING
                                        and Account.Renewal_Month__c=:monthName 
                                        and ARV_Excluded_from_Renewal__c=false and vlocity_ins__FinalRatingGroupCensusId__r.Premium_Total__c != 0
                                        order by contractNumber];
            return getMonthContract(listViews);
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
@Description: getListEligibleRecords() method
@Name : getListEligibleRecords
@Param : String MonthName
@Return : Contract
@throws Exception : N/A;
*/
    @AuraEnabled
    public static ContractWrapper getListSuccessRecords(String monthName,Integer rowsLimit,Integer rowsOffset){
        List<Id> conids=New List<Id>();
        ContractWrapper conwrap= new ContractWrapper();
        List<Contract> totallistCon=[select Id,contractNumber,ARV_Renewal_Status__c,ARV_CF_Total_Members_Count__c,ARV_CF_CNTRCT_Renewal_Premium__c,
                                     ARV_RatingArea__c,AccountId,Account.GA_Carrier_Code__c,ARV_CF_CNTRCT_CarrierCodes__c,Account.CID__c,Account.Renewal_Month__c,
                                     Account.Name, Status,Account.GA_Opportunity_Renewal_Date__c,Renewal_Batch__r.Name,
                                     vlocity_ins__ExpiredContractId__c,ARV_Requested_Effective_Date__c,( select Id,Status__c,
                                                                                                        GA_Group_Name__c,GA_Account__c,GA_DC_Small_Group__c from Group_Segments__r ) from contract 
                                     WHERE Account.Renewal_Month__c=:monthName and vlocity_ins__ExpiredContractId__c!=:EMPTY_STRING 
                                     and ARV_Renewal_Status__c=:READY and status!=:C_CANCELLED and recordtype.Name=:RENEWAL
                                     and ARV_CongaGroupTech__c=:Y_YES and ARV_CongaAgentTech__c=:Y_YES order by contractNumber];
        
        system.debug('totallistCon'+totallistCon.size());
        conwrap.totalRecords=totallistCon.size();
        conwrap.totalConstoUpdate=totallistCon;
        
        List<Contract> listviews=  [select Id,contractNumber,ARV_Renewal_Status__c,ARV_CF_Total_Members_Count__c,ARV_CF_CNTRCT_Renewal_Premium__c,
                                    ARV_RatingArea__c,AccountId,Account.GA_Carrier_Code__c,ARV_CF_CNTRCT_CarrierCodes__c,Account.CID__c,Account.Renewal_Month__c,
                                    Account.Name,Status,Account.GA_Opportunity_Renewal_Date__c,Renewal_Batch__r.Name,
                                    vlocity_ins__ExpiredContractId__c,ARV_Requested_Effective_Date__c,( select Id,Status__c,
                                                                                                       GA_Group_Name__c,GA_Account__c,GA_DC_Small_Group__c from Group_Segments1__r ) from contract 
                                    WHERE Account.Renewal_Month__c=:monthName and vlocity_ins__ExpiredContractId__c!=:EMPTY_STRING 
                                    and ARV_Renewal_Status__c=:READY and status!=:C_CANCELLED and recordtype.Name=:RENEWAL
                                    and ARV_CongaGroupTech__c=:Y_YES and ARV_CongaAgentTech__c=:Y_YES order by contractNumber limit :rowsLimit];
        system.debug('listviews'+listviews.size());
        conwrap.totalcontractsList=listViews;
        conwrap.contractsList=listViews;
        
        return conwrap;
    }
    //To return additional records based on offset
    @AuraEnabled
    public static loadContractWrapper loadwrapContractSuccessRecords(String finalRecId,String monthName ,Integer rowsLimit){
        loadContractWrapper loadcontrwrap= new loadContractWrapper();
        if(finalRecId !=null){
            string querymorerec='select Id,contractNumber,ARV_Renewal_Status__c,ARV_CF_Total_Members_Count__c,'+
                +'ARV_RatingArea__c,AccountId,Account.GA_Carrier_Code__c,ARV_CF_CNTRCT_CarrierCodes__c,Account.CID__c,Account.Renewal_Month__c,'+
                +'Account.Name, Status,Account.GA_Opportunity_Renewal_Date__c,Renewal_Batch__r.Name,ARV_CF_CNTRCT_Total_Change__c,ARV_CF_CNTRCT_Renewal_Premium__c,'+
                +'vlocity_ins__ExpiredContractId__c,ARV_Requested_Effective_Date__c,( select Id,Status__c,'+
                + 'GA_Group_Name__c,GA_Account__c,GA_DC_Small_Group__c from Group_Segments1__r ) from contract';
            
            querymorerec +=' Where Account.Renewal_Month__c=\'' +monthName+'\'';
            querymorerec +=' and ARV_CongaGroupTech__c =\'' +Y_YES+'\'';
            querymorerec +=' and ARV_CongaAgentTech__c =\'' +Y_YES+'\'';
            querymorerec +=' and recordtype.Name=\'' +RENEWAL+'\'';
            querymorerec +=' and Status!=\'' +C_CANCELLED+'\'';
            querymorerec +=' and ARV_Renewal_Status__c=\'' +READY+'\'';
            querymorerec +=' and vlocity_ins__ExpiredContractId__c!=\'' +EMPTY_STRING+'\'';
            querymorerec +=' and contractNumber >\''+finalRecId+'\'' ;
            querymorerec +=' order by contractNumber limit '+rowsLimit;
            system.debug('querymorerec'+querymorerec);
            List<Contract>listviews =database.query(querymorerec);
            loadcontrwrap.totalcontractsList=listViews;
            loadcontrwrap.filtercontractsList=listViews;
        }
        return loadcontrwrap;
        
    }
    
    /**CidSerachMethod**/
    
    @AuraEnabled
    public static List<Contract> getCidSearcSuccessContracts(string monthName,String cidId){
        List<String> cidlst=New List<String>();
        cidlst=cidId.split(',');
        set<String> cidset =New Set<String>(cidlst);
        
        
        try {
            List<Contract> listViews = [select Id,contractNumber,ARV_Renewal_Status__c,ARV_CF_Total_Members_Count__c,ARV_CF_CNTRCT_Renewal_Premium__c,
                                        ARV_RatingArea__c,AccountId,Account.GA_Carrier_Code__c,ARV_CF_CNTRCT_CarrierCodes__c,Account.CID__c,Account.Renewal_Month__c,
                                        Account.Name, Status,Account.GA_Opportunity_Renewal_Date__c,Renewal_Batch__r.Name,
                                        vlocity_ins__ExpiredContractId__c,ARV_Requested_Effective_Date__c,( select Id,Status__c,
                                                                                                           GA_Group_Name__c,GA_Account__c,GA_DC_Small_Group__c from Group_Segments1__r ) from contract 
                                        WHERE Account.Renewal_Month__c=:monthName
                                        and Account.CID__c IN:cidset
                                        and vlocity_ins__ExpiredContractId__c!=:EMPTY_STRING 
                                        and ARV_Renewal_Status__c=:READY and status!=:C_CANCELLED and recordtype.Name=:RENEWAL
                                        and ARV_CongaGroupTech__c=:Y_YES and ARV_CongaAgentTech__c=:Y_YES order by contractNumber];
            return listViews;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
@Description: getAdHocContracts() method
@Name : getAdHocContracts
@Param : String MonthName
@Return : Contract
@throws Exception : N/A;
*/
    @AuraEnabled
    public static List<Contract> getAdHocContracts(String searchKeyword,integer rowsLimit){
        List<Contract> listViews = new List<Contract>();
        try {
            if(searchKeyword.length()==6){
                string cid=searchKeyWord ;
                listViews = [select Id,contractNumber,ARV_Renewal_Status__c,ARV_Total_Member_Count__c,
                             ARV_RatingArea__c,AccountId,Account.GA_Carrier_Code__c,ARV_CF_CNTRCT_CarrierCodes__c,Account.CID__c,Account.Renewal_Month__c,
                             Account.Name,Status,Account.GA_Opportunity_Renewal_Date__c,
                             vlocity_ins__ExpiredContractId__c,ARV_Requested_Effective_Date__c,( select Id,Status__c,
                                                                                                GA_Group_Name__c,GA_Account__c,GA_DC_Small_Group__c from Group_Segments__r ) from contract 
                             WHERE Account.CID__c =:cid and (Status=:ACTIVATED) and Account.Account_Status__c=:ACTIVED
                             and Account.ARV_Renewal_Account_Type__c=:TEXT_SG order by contractNumber  ];
            }
            else{
                List<string> stringlist=new List<string>();
                stringlist=searchKeyword.split(COMMA);
                set<string> searchset=new set<string>(stringlist);
                listViews = [select Id,contractNumber,ARV_Renewal_Status__c,ARV_Total_Member_Count__c,
                             ARV_RatingArea__c,AccountId,Account.GA_Carrier_Code__c,ARV_CF_CNTRCT_CarrierCodes__c,Account.CID__c,Account.Renewal_Month__c,
                             Account.Name,Status,Account.GA_Opportunity_Renewal_Date__c,
                             vlocity_ins__ExpiredContractId__c,ARV_Requested_Effective_Date__c,( select Id,Status__c,
                                                                                                GA_Group_Name__c,GA_Account__c,GA_DC_Small_Group__c from Group_Segments__r ) from contract 
                             WHERE Account.CID__c IN :searchset and (Status=:ACTIVATED) and Account.Account_Status__c=:ACTIVED
                             and Account.ARV_Renewal_Account_Type__c=:TEXT_SG order by contractNumber limit :rowsLimit ];
            }
            return listViews;
            
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //Adding for Error contracts
    @AuraEnabled
    public static ContractWrapper getListErrorRecords(String monthName,Integer rowsLimit,Integer rowsOffset){
        List<Id> conids=New List<Id>();
        ContractWrapper conwrap= new ContractWrapper();
        List<Contract> renewalpack =[select id,vlocity_ins__ExpiredContractId__c from contract where Account.Renewal_Month__c=:monthName and recordtype.name=:RENEWAL and (ARV_CongaGroupTech__c=:N_NO or ARV_CongaAgentTech__c=:N_NO) and vlocity_ins__ExpiredContractId__r.ARV_Renewal_Error__c =:EMPTY_STRING and Status!=:C_CANCELLED];
        List<contract> batchList = new List<contract>();
        for(Contract cntfail : renewalpack)
        {
            contract batchlog = new contract();
            batchlog.id=cntfail.vlocity_ins__ExpiredContractId__c;
            batchlog.ARV_Renewal_Error__c=ERROR;
            batchlog.ARV_Renewal_Creation_Status__c=ERRORMSG;
            batchlog.ARV_Renewal_Error_Message__c=RENEWALMSG;
            batchList.add(batchlog);
        }
        //if(batchList.size()>0){database.update(batchList);}
        //if(renewalpack.size()>0){database.delete(renewalpack);}
        List<Contract> totallistCon=[select Id,contractNumber,ARV_Renewal_Status__c,ARV_Renewal_Error__c,ARV_Total_Member_Count__c,
                                     ARV_RatingArea__c,AccountId,Account.GA_Carrier_Code__c,Account.CID__c,Account.Renewal_Month__c,
                                     Account.Name, Status,Account.GA_Opportunity_Renewal_Date__c,
                                     vlocity_ins__ExpiredContractId__c,ARV_Requested_Effective_Date__c,
                                     Renewal_Batch__r.Name,ARV_CF_CNTRCT_CarrierCodes__c from contract 
                                     WHERE Account.Renewal_Month__c=:monthName and
                                     ARV_Renewal_Error__c !=:EMPTY_STRING  order by contractNumber];
        
        system.debug('Error totallistCon'+totallistCon.size());
        conwrap.totalRecords=totallistCon.size();
        for(Contract eachConId:totallistCon){
            conids.add(eachConId.Id);
        }
        conwrap.filtercontractIds=conids;
        //conwrap.totalRecords=validlistViews.size();
        
        List<Contract> listviews=  [select Id,contractNumber,ARV_Renewal_Status__c,ARV_Renewal_Error__c,ARV_Total_Member_Count__c,
                                    ARV_RatingArea__c,AccountId,Account.GA_Carrier_Code__c,Account.CID__c,Account.Renewal_Month__c,
                                    Account.Name, Status,Account.GA_Opportunity_Renewal_Date__c,
                                    vlocity_ins__ExpiredContractId__c,ARV_Requested_Effective_Date__c,
                                    Renewal_Batch__r.Name,ARV_CF_CNTRCT_CarrierCodes__c from contract 
                                    WHERE Account.Renewal_Month__c=:monthName and 
                                    ARV_Renewal_Error__c !=:EMPTY_STRING    order by contractNumber limit :rowsLimit];
        system.debug('Error listviews'+listviews.size());
        conwrap.totalcontractsList=listViews;
        conwrap.contractsList=listViews;
        
        return conwrap;
    }
    @AuraEnabled
    public static loadContractWrapper loadwrapContractErrorRecords(String finalRecId,String monthName ,Integer rowsLimit){
        loadContractWrapper loadcontrwrap= new loadContractWrapper();
        if(finalRecId !=null){
            string querymorerec='select Id,contractNumber,ARV_Renewal_Status__c,ARV_Total_Member_Count__c,'+
                +'ARV_RatingArea__c,AccountId,Account.GA_Carrier_Code__c,ARV_CF_CNTRCT_CarrierCodes__c,Account.CID__c,Account.Renewal_Month__c,'+
                +'Account.Name, Status,Account.GA_Opportunity_Renewal_Date__c,'+
                +'vlocity_ins__ExpiredContractId__c,ARV_Requested_Effective_Date__c,Renewal_Batch__r.Name from contract';
            
            querymorerec +=' Where Account.Renewal_Month__c=\'' +monthName+'\'';
            querymorerec +=' and ARV_Renewal_Error__c!=\'' +EMPTY_STRING+'\'';
            querymorerec +=' and contractNumber >\''+finalRecId+'\'' ;
            querymorerec +=' order by contractNumber limit '+rowsLimit;
            system.debug('querymorerec'+querymorerec);
            List<Contract>listviews =database.query(querymorerec);
            loadcontrwrap.totalcontractsList=listViews;
            loadcontrwrap.filtercontractsList=listViews;
        }
        return loadcontrwrap;
        
    }
    /**CidSerachMethod**/
    
    @AuraEnabled
    public static List<Contract> getCidSearchErrorContracts(string monthName,String cidId){
        List<String> cidlst=New List<String>();
        cidlst=cidId.split(',');
        set<String> cidset =New Set<String>(cidlst);
        
        
        try {
            List<Contract> listViews = [select Id,contractNumber,ARV_Renewal_Status__c,ARV_Renewal_Error__c,ARV_Total_Member_Count__c,
                                        ARV_RatingArea__c,AccountId,Account.GA_Carrier_Code__c,Account.CID__c,Account.Renewal_Month__c,
                                        Account.Name, Status,Account.GA_Opportunity_Renewal_Date__c,
                                        vlocity_ins__ExpiredContractId__c,ARV_Requested_Effective_Date__c,
                                        Renewal_Batch__r.Name,ARV_CF_CNTRCT_CarrierCodes__c from contract 
                                        WHERE Account.CID__c IN:cidset and Account.Renewal_Month__c=:monthName and 
                                        ARV_Renewal_Error__c!=:EMPTY_STRING order by contractNumber];
            system.debug('error cid listViews::'+listViews.size());
            return listViews;
            
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    //error contracts ends here
    /**
@Description: getZeroGroupSegmentsContracts() method
@Name : getZeroGroupSegmentsContracts
@Param : List<Contract> allContracts
@Return : Contract
@throws Exception : N/A;
*/
    @TestVisible
    private static List<Contract> getZeroGroupSegmentsContracts(List<Contract> allContracts) {
        List<Contract> finalContractList = new List<Contract>();
        for(Contract cnt:allContracts) {
            if(cnt.Group_Segments__r.size()>0 && isNoGroupSegementsPending(cnt.Group_Segments__r)) { 
                   finalContractList.add(cnt);
               }
        }
        return finalContractList;
    }
    /**
@Description: getMonthContract() method
@Name : getMonthContract
@Param : List<Contract> allContracts
@Return : Contract
@throws Exception : N/A;
*/
    
    private static List<Contract> getMonthContract(List<Contract> allContracts) {
        List<Contract> finalContractList = new List<Contract>();
        for(Contract cnt:allContracts) {
            if(cnt.Group_Segments__r.size()>0 && 
               isNoGroupSegementsPending(cnt.Group_Segments__r) /*&& 
isMonthValid(cnt.ARV_Requested_Renewal_Date_Month__c)*/) {
    finalContractList.add(cnt);
}
        }
        return finalContractList;
    }
    /**
@Description: isNoGroupSegementsPending() method
@Name : isNoGroupSegementsPending
@Param : List<GA_Group_Segment__c> contractGropSegements
@Return : Boolean
@throws Exception : N/A;
*/
    @TestVisible
    private static Boolean isNoGroupSegementsPending(List<GA_Group_Segment__c> contractGropSegements) {
        Integer count = 0;
        system.debug('contractGropSegements::'+contractGropSegements);
        for(GA_Group_Segment__c gs:contractGropSegements) {
            if(gs.Status__c==CANCELED || gs.Status__c==PENDING) {
                count++;
            }
        }
        system.debug('contractGropSegements:::'+contractGropSegements);
        system.debug('count::'+count);
        return count>0?false:true;
    }
    /**
@Description: isMonthValid() method
@Name : isMonthValid
@Param : Date renewalDate
@Return : Boolean
@throws Exception : N/A;///////
*/
@TestVisible private static Boolean isMonthValid(Date renewalDate) {
        if(renewalDate !=null){
            Date currentDate = Date.today();
            Integer renewalMonth = renewalDate.month();
            Integer renewalYear = renewalDate.year();
            if((renewalMonth>=currentDate.month() && renewalYear==currentDate.year()) || 
               (renewalMonth<currentDate.month() && renewalYear==currentDate.year()+1)) {
                   return true;
               } else {
                   return false;
               }
        }else{
            return false; 
        }
    }
    /**
@Description: initiateBatch() method
@Name : initiateBatch
@Param : List<Object> contractIds
@Return : Boolean
@throws Exception : N/A;
*/
    @AuraEnabled
    public static BatchIPOutputWrapper initiateBatch( List<Id> contractIds ) {
        try{
            BatchIPOutputWrapper batchIpOutput = new BatchIPOutputWrapper();
            String renewalMonth = Null;
            List<Object> inputList1 = contractIds;
            ARV_AP07_QueryDataHelper.idsList = (List<Id>)inputList1;
            List<Contract> listContracts =ARV_AP07_QueryDataHelper.getsObjects(EXCLUDE_CONTRACT_QUERY,
                                                                               EXCLUDE_CONTRACT_WHERE_QUERY,NULL,NULL);
            renewalMonth = listContracts[0].Account.Renewal_month__c;
            Renewal_Batch__c rbatch= createBatchRecord(renewalMonth,listContracts);
            batchIpOutput.batchId = rbatch.Id;
            //Error Validation
            //List<Contract> ipCheckContracts = validateRenewalProducts(listContracts,contractIds); 
            //if(ipCheckContracts.size()>0) {
            List<Object> inputList = new List<object>();
            List<Id> contId = new List<Id>();
            List<Id> accId = new List<Id>();
            //Map<Id,Contract> accContractMap = new Map<Id,Contract>();
            //List<Contract> contractStatusToCncld = new List<Contract>();
            map<String,Object> tempMap = new map<String,Object>();
            List<map<String,Object>> finalContractIds = new List<map<String,Object>>(); 
            //To enable validations, replace line 326 with --> for(Contract cont : ipCheckContracts){
            /*for(Contract cont : listContracts){   //finding the original contractids
accId.add(cont.AccountId);
if(cont.vlocity_ins__ExpiredContractId__c != null){
contId.add(cont.vlocity_ins__ExpiredContractId__c);
}
else{
contId.add(cont.id);
}
}*/ 
            //if(ipCheckContracts.size()>0) {            
            for(Contract cId:listContracts){
                tempMap = new Map<String,Object>();
                tempMap.put(ID1, cId.Id);
                finalContractIds.add(tempMap);
            } 
            //}
            if(finalContractIds.size()>0 && finalContractIds.size()<=5) {
                Map <String, Object> ipInput = new Map <String, Object> ();
                Map <String, Object> ipOutput = new Map <String, Object> ();
                Map <String, Object> ipOptions = new Map <String, Object> ();
                /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
                ipInput.put(MERGEDATA, finalContractIds);
                /* Invoke appropriate job based on single or multple contract ids */
                String jobName = Null;
                if (finalContractIds.size()>1){
                    jobName = MULTIPLE;//renewalBatchMultipleContracts';
                } else if (finalContractIds.size()==1){ 
                    jobName = SINGLE;//renewalBatchSingleContract';
                }
                else{}
                //ipInput.put('jobName',jobName);
                ipInput.put(CONTRACTTYPE,jobName);
                ipOutput = (Map <String, Object>) vlocity_ins.IntegrationProcedureService.runIntegrationService(PROCEDURE_NAME, 
                                                                                                                ipInput, ipOptions);
                String apexJobId = String.valueof(ipOutput.get(APEXJOBID));
                batchIpOutput.apexJobId = apexJobId;
                rbatch.ARV_Renewal_Batch_ID__c = apexJobId;
                database.update(rbatch);
                //system.debug(' after update rbatch name&&&'+rbatch.ARV_Initiation_Date_and_Time__c+'name&&&&'+rbatch.name);
            }
            if(finalContractIds.size()>5){
                String apexJobId= splitlisttoMultilist(finalContractIds);
                batchIpOutput.apexJobId = apexJobId;
                rbatch.ARV_Renewal_Batch_ID__c = apexJobId;
                database.update(rbatch);
            }
            //}
            return batchIpOutput;
        } catch(Exception e) {
            //system.debug('surya exceptin:::'+e.getLineNumber()+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }       
    }
    /**
@Description: validateRenewalProducts() method
@Name : validateRenewalProducts
@Param : List<Contract> renewalContracts,List<Id> renewalContractIds
@Return : List<Contract>
@throws Exception : N/A;
*/
    /*private static List<Contract> validateRenewalProducts( List<Contract> renewalContracts,List<Id> renewalContractIds ) {
Map<Id,List<vlocity_ins__ContractLineItem__c>> mapContractPlan = new Map<Id,List<vlocity_ins__ContractLineItem__c>>();
List<Contract> updateContracts = new List<Contract>();
List<Contract> validContracts = new List<Contract>();
ARV_AP07_QueryDataHelper.idsList = renewalContractIds;
List<vlocity_ins__ContractLineItem__c> contractPlans =ARV_AP07_QueryDataHelper.getsObjects(PLANS_QUERY,
PLANS_WHERE,NULL,NULL);
for(Id eachContractId:renewalContractIds) {
List<vlocity_ins__ContractLineItem__c> individualProducts = new List<vlocity_ins__ContractLineItem__c>();
for(vlocity_ins__ContractLineItem__c eachPlan:contractPlans ) {
if(eachPlan.vlocity_ins__ContractId__c==eachContractId) {
individualProducts.add(eachPlan);
}
}
if(individualProducts.size()>0) {
mapContractPlan.put(eachContractId,individualProducts);
}
}
//if(!mapContractPlan.isEmpty()) {
for(Contract eachContract:renewalContracts) {
List<vlocity_ins__ContractLineItem__c> finalPlans = new List<vlocity_ins__ContractLineItem__c>();
finalPlans = mapContractPlan.get(eachContract.Id);
if(finalPlans!=null && !finalPlans.isEmpty() && finalPlans.size()>0 ) {
Integer countValidDate = 0;
for(vlocity_ins__ContractLineItem__c fPlan:finalPlans ) {
if(eachContract.ARV_Requested_Effective_Date__c>=fPlan.vlocity_ins__Product2Id__r.vlocity_ins__EffectiveDate__c) {
countValidDate++;
eachContract.ARV_Renewal_Error_Message__c = INVALID_PRODUCT_CROSSWALK+fPlan.Name;
//system.debug('each fplan--'+fPlan.vlocity_ins__Product2Id__r.vlocity_ins__EffectiveDate__c);  
//system.debug('each Contract--'+eachContract);  
}
}
if(countValidDate>0) {
eachContract.ARV_Renewal_Creation_Status__c = ERROR_PREVALIDATION;
eachContract.ARV_Renewal_Error__c = PRODUCT_ERROR;
updateContracts.add(eachContract);
} else {
eachContract.ARV_Renewal_Creation_Status__c = SUCCESS_PREVALIDATION;
updateContracts.add(eachContract);
validContracts.add(eachContract);
}
} else {
eachContract.ARV_Renewal_Creation_Status__c = ERROR_PREVALIDATION;
eachContract.ARV_Renewal_Error__c = PRODUCT_ERROR;
eachContract.ARV_Renewal_Error_Message__c = NO_CROSS_WALKPRODUCT_ASSIGN;
updateContracts.add(eachContract);
}
} 
//}        
if(updateContracts.size()>0){database.update(updateContracts);}
//system.debug('plans data---'+mapContractPlan);
//system.debug('valid Contracts---'+validContracts);
return validContracts;
}*/
    /*
Method Name: createBatchRecord
Params: Strin,List<Contract>
Return type: Renewal_Batch__c
Description : This method is used to update the renewal batch record fields 
and RenewalBatch field in expired contracts.
*/    
    public static Renewal_Batch__c createBatchRecord(String renewalMonth, List<Contract> renewalContracts) { 
        Renewal_Batch__c rbatch = new Renewal_Batch__c();
        // rbatch.Name= BATCH_TITLE + System.now();
        String timenow= String.valueof(System.now());
        rbatch.ARV_Renewal_Month__c = renewalMonth;
        rbatch.ARV_Initiation_Date_and_Time__c= datetime.valueof(timenow);
        rbatch.Name= BATCH_TITLE+timenow;
        rbatch.Batch_Status__c=RUNNING;
        //system.debug('rbatch name&&&'+rbatch.ARV_Initiation_Date_and_Time__c+'name&&&&'+rbatch.name);
        database.insert(rbatch);
        //system.debug(' after insert rbatch name&&&'+rbatch.ARV_Initiation_Date_and_Time__c+'name&&&&'+rbatch.name);
        //insert rbatch;
        Set<Id> conids=new set<Id>();
        List<Contract> conList = renewalContracts;
        for(Contract renwealCon: conList) {
            conids.add(renwealCon.Id);
        }
        ARV_AP_BatchClassUpdateContracts shn = new ARV_AP_BatchClassUpdateContracts(conids,rbatch.Id,EMPTY_STRING); 
        database.executeBatch(shn);
        return rbatch;        
    }  
    /*
Method Name: getBatchRecord
Params: String batchId
Return type: Renewal_Batch__c
Description : This method is used to update the renewal batch record fields 
and RenewalBatch field in expired contracts.
*/    
    @AuraEnabled
    public static Renewal_Batch__c getBatchRecord(String batchId) { 
        
        try{
            Renewal_Batch__c batchData = [select Id,Name,ARV_Renewal_Batch_ID__c,Batch_Status__c,ARV_profileName__c,ARV_Initiation_Date_and_Time__c,
                                          ARV_Completed_Date__c,ARV_Renewal_Month__c,ARV_Renewal_Default_Delay_Days__c,IL_Auto_number__c
                                          from Renewal_Batch__c where Id=:batchId limit 1];
            if(!batchData.name.contains(ILNUMBER)){
                batchData.Name=batchData.Name+HYPHEN+batchData.IL_Auto_number__c;
            }
            batchData.ARV_profileName__c = ARV_AP92_RenewalListViews.getUserProfileName();
            if(!String.isBlank(batchData.ARV_Renewal_Batch_ID__c)) {
                AsyncApexJob aaj = [SELECT Id, Status,CompletedDate, NumberOfErrors
                                    FROM AsyncApexJob WHERE ID =:batchData.ARV_Renewal_Batch_ID__c limit 1];
                if(aaj!=null && COMPLETED.equalsIgnoreCase(aaj.Status)) {
                    batchData.Batch_Status__c = aaj.Status;
                    batchData.ARV_Completed_Date__c = aaj.CompletedDate;
                    //update batchData;
                }
            } else {
                batchData.Batch_Status__c = COMPLETED;
                batchData.ARV_Completed_Date__c = System.now();
            }
            database.update(batchData);
            return batchData; 
        } catch(Exception e) {
            //system.debug('surya exceptin:::'+e.getLineNumber()+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
@Description: exludeFromRenewals() method
@Name : exludeFromRenewals
@Param : List<Object> contractIds
@Return : Boolean
@throws Exception : N/A;
*/
    @AuraEnabled
    public static List<Contract> exludeFromRenewals( List<Id> contractIds ) {
        try{
            List<Contract> updateContracts = new List<Contract>();
            List<Object> inputList = contractIds;
            ARV_AP07_QueryDataHelper.idsList = (List<Id>)inputList;
            List<Contract> listContracts =ARV_AP07_QueryDataHelper.getsObjects(EXCLUDE_CONTRACT_QUERY,
                                                                               EXCLUDE_CONTRACT_WHERE_QUERY,NULL,NULL);
            for(Contract lc:listContracts) {
                lc.ARV_Excluded_from_Renewal__c = true;
                updateContracts.add(lc);
            }
            if(updateContracts.size()>0) {
                database.update(updateContracts); 
            }
            return updateContracts;
        } catch(Exception e) {
            //system.debug('exceptin:::'+e.getLineNumber()+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
@Description: updateRenewalStatus() method
@Name : updateRenewalStatus
@Param : List<Object> contractIds
@Return : Boolean
@throws Exception : N/A;
*/
    @AuraEnabled
    public static String updateRenewalStatus( List<Contract> contracts ) {
        try{
            String batchJobId=null;
            map<id,String> constatusToUpdate=new map<id,string>();
            List<Contract> updateContracts = contracts;
            for(Contract con:updateContracts){
                constatusToUpdate.put(con.Id,con.ARV_Renewal_Status__c);
            }
            if(updateContracts.size()>0) {
                ARV_AP_BatchClassUpdateRenStatuContracts renStatusUpdate= new ARV_AP_BatchClassUpdateRenStatuContracts(constatusToUpdate);
                batchJobId = database.executeBatch(renStatusUpdate,100);
            }
            return batchJobId;
        } catch(Exception e) {
            //system.debug('surya exceptin:::'+e.getLineNumber()+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**
@Description: getUserProfileName() method
@Name : getUserProfileName
@Param : N/A
@Return : Boolean
@throws Exception : N/A;
*/ 
    @AuraEnabled
    public static String getUserProfileName(){
        try{
            ARV_AP07_QueryDataHelper.paramId1=userinfo.getProfileId();
            list<Profile> profileDetails = ARV_AP07_QueryDataHelper.getsObjects(PROFILE_QRY,
                                                                                RENEWALWHERECLAUSE,NULL,LIMIT1);
            return profileDetails[0].Name;
        } catch(Exception e) {
            //system.debug('surya exceptin:::'+e.getLineNumber()+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
@Description: ListViewWrapper wrapper class
@Name : ListViewWrapper
*/
    public without Sharing class ListViewWrapper{
        @AuraEnabled public string label{get;set;} 
        @AuraEnabled public string developerName{get;set;} 
    } 
    /**
@Description: BatchIPOutputWrapper wrapper class
@Name : BatchIPOutputWrapper
*/
    public without Sharing class BatchIPOutputWrapper{
        @AuraEnabled public string batchId{get;set;} 
        @AuraEnabled public string apexJobId{get;set;} 
    }
    
    /**
@Description:Wrapper class to hold contract data And total records
@Name : ContractWrapper
*/
    public class ContractWrapper{
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<Contract> contractsList = new List<Contract>();
        @AuraEnabled
        public List<Contract> totalcontractsList = new List<Contract>();
        @AuraEnabled
        public List<Id> filtercontractIds = new List<Id>();
        @AuraEnabled
        public List<Contract> totalConstoUpdate = new List<Contract>();
    }
    public class loadContractWrapper{
        @AuraEnabled
        public List<Contract> filtercontractsList = new List<Contract>();
        @AuraEnabled
        public List<Contract> totalcontractsList = new List<Contract>();
    }
    public static string splitlisttoMultilist(List<map<String,Object>>finalContractIds){
        String apexJobId=null;
        List<map<String,Object>>Ids1=   New List<map<String,Object>>();
        List<map<String,Object>>Ids2=   New List<map<String,Object>>();
        List<map<String,Object>>Ids3=   New List<map<String,Object>>();
        List<map<String,Object>>Ids4=   New List<map<String,Object>>();
        List<map<String,Object>>Ids5=   New List<map<String,Object>>();
        
        if(finalContractIds.size()>0) {
            
            integer splitsize =(finalContractIds.size()/1);
            
            for(integer i=0;i<finalContractIds.size();i++){
                
                if(i<=splitsize-1){
                    ids1.add(finalContractIds[i]);
                    
                }
                
                else if(i>splitsize-1 && i<=2*splitsize-1 ){
                    ids2.add(finalContractIds[i]);
                    
                }
                else if(i>2*splitsize-1 && i<=3*splitsize-1){
                    ids3.add(finalContractIds[i]);
                    
                }
                else if(i>3*splitsize-1 && i<=4*splitsize-1){
                    ids4.add(finalContractIds[i]);
                    
                }
                else if(i>=4*splitsize-1){
                    ids5.add(finalContractIds[i]);
                    
                }
                
            }
            system.debug('finalContractId1'+ids1);
            system.debug('finalContractId2'+ids2);
            system.debug('finalContractId3'+ids3);
            system.debug('finalContractId4'+ids4);
            system.debug('finalContractId5'+ids5);
            if(Ids1.size()>0){
                apexJobId= runIpRenewalContracts(Ids1);
                system.debug('apexJobId1'+apexJobId);
            }
            if(Ids2.size()>0){
                apexJobId= runIpRenewalContracts(Ids2);
                system.debug('apexJobId2'+apexJobId);
            }
            if(Ids3.size()>0){
                apexJobId= runIpRenewalContracts(Ids3);
                system.debug('apexJobId3'+apexJobId);
            }
            if(Ids4.size()>0){
                apexJobId= runIpRenewalContracts(Ids4);
                system.debug('apexJobId4'+apexJobId);
            }
            if(Ids5.size()>0){
                apexJobId= runIpRenewalContracts(Ids5);
                system.debug('apexJobId5'+apexJobId);
            }
            
        }
        
        return apexJobId;
    }
    public static string runIpRenewalContracts(List<map<String,Object>>finalContractIds){
        Map <String, Object> ipInput = new Map <String, Object> ();
        Map <String, Object> ipOutput = new Map <String, Object> ();
        Map <String, Object> ipOptions = new Map <String, Object> ();
        /* Populating input map for an Integration Procedure. Follow whatever structure your VIP expects */
        ipInput.put(MERGEDATA, finalContractIds);
        /* Invoke appropriate job based on single or multple contract ids */
        String jobName = Null;
        if (finalContractIds.size()>1){
            jobName = MULTIPLE;//renewalBatchMultipleContracts';
        }else if (finalContractIds.size()==1){ 
            jobName = SINGLE;//renewalBatchSingleContract';
        }
        else{}
        //ipInput.put('jobName',jobName);
        ipInput.put(CONTRACTTYPE,jobName);
        
        System.debug(':: test:PROCEDURE_NAME ::' + PROCEDURE_NAME);
        System.debug(':: test:ipInput ::' + ipInput);
        System.debug(':: test:ipOptions ::' + ipOptions);
        
        ipOutput = (Map <String, Object>) vlocity_ins.IntegrationProcedureService.runIntegrationService(PROCEDURE_NAME, 
                                                                                                        ipInput, ipOptions);
        
        System.debug(':: test:ipOutput ::' + ipOutput);
        
        String apexJobId = String.valueof(ipOutput.get(APEXJOBID)); 
        return apexJobId;
    }
    /*@Description: it reutns the success contracts based on renewal batch Records 
@MethodName : getBatchSuccessContracts
*/ 
    @AuraEnabled
    public static ContractWrapper getBatchSuccessContracts(String batchId,Integer rowsLimit,Integer rowsOffset){
        List<Id> conids=New List<Id>();
        ContractWrapper conwrap= new ContractWrapper();
        List<Contract> totallistCon=[Select Id,ContractNumber,Account.Name,Account.CID__c,ARV_Renewal_Creation_Status__c,ARV_Renewal_Error__c,
                                     ARV_Renewal_Error_Message__c from Contract where renewal_batch__c=:batchId
                                     and ARV_Renewal_Error__c =:EMPTY_STRING
                                     and vlocity_ins__ExpiredContractId__c!=:EMPTY_STRING
                                     and Status!=:C_CANCELLED 
                                     and recordtype.Name=:RENEWAL
                                     and ARV_CongaGroupTech__c=:Y_YES
                                     and ARV_CongaAgentTech__c=:Y_YES
                                     limit 10000];
        
        conwrap.totalRecords=totallistCon.size();
        
        List<Contract> listviews=  [Select Id,ContractNumber,Account.Name,Account.CID__c,ARV_Renewal_Creation_Status__c,ARV_Renewal_Error__c,
                                    ARV_Renewal_Error_Message__c from Contract where renewal_batch__c=:batchId
                                    and ARV_Renewal_Error__c =:EMPTY_STRING
                                    and vlocity_ins__ExpiredContractId__c!=:EMPTY_STRING
                                    and Status!=:C_CANCELLED
                                    and recordtype.Name=:RENEWAL
                                    and ARV_CongaGroupTech__c=:Y_YES
                                    and ARV_CongaAgentTech__c=:Y_YES
                                    order by contractNumber limit :rowsLimit];
        conwrap.totalcontractsList=listViews;
        conwrap.contractsList=listViews;
        
        
        
        return conwrap;
    }
    //To return additional records based on offset
    @AuraEnabled
    public static loadContractWrapper loadwrapBatchSuccessContracts(String finalRecId,String batchId ,Integer rowsLimit){
        loadContractWrapper loadcontrwrap= new loadContractWrapper();
        if(finalRecId != null){
            string querymorerec='Select Id,ContractNumber,Account.Name,Account.CID__c,ARV_Renewal_Creation_Status__c,ARV_Renewal_Error__c'
                +' from contract';
            querymorerec +=' where renewal_batch__c=\'' +batchId+'\'';
            querymorerec +=' and ARV_CongaGroupTech__c =\'' +Y_YES+'\'';
            querymorerec +=' and ARV_CongaAgentTech__c =\'' +Y_YES+'\'';
            querymorerec +=' and recordtype.Name=\'' +RENEWAL+'\'';
            querymorerec +=' and ARV_Renewal_Error__c=\'' +EMPTY_STRING+'\'';
            querymorerec +=' and vlocity_ins__ExpiredContractId__c !=\'' +EMPTY_STRING+'\'';
            querymorerec +=' and Status !=\'' +C_CANCELLED+'\'';
            querymorerec +=' and contractNumber>\''+finalRecId+'\'' ;
            querymorerec +=' order by contractNumber limit '+rowsLimit;
            
            List<Contract>listviews =database.query(querymorerec);
            loadcontrwrap.totalcontractsList=listViews;
            loadcontrwrap.filtercontractsList=listViews;
            
            
        }
        return loadcontrwrap;
    }
    /*@Description: it returns the Error contracts based on renewal batch Run 
@MethodName : getBatchSuccessContracts
*/
    @AuraEnabled
    public static ContractWrapper getBatchErrorContracts(String batchId,Integer rowsLimit,Integer rowsOffset){
        List<Id> conids=New List<Id>();
        ContractWrapper conwrap= new ContractWrapper();
        List<Contract> renewalpack =[select id,vlocity_ins__ExpiredContractId__c from contract where renewal_batch__c=:batchId and recordtype.name=:RENEWAL and (ARV_CongaGroupTech__c=:N_NO or ARV_CongaAgentTech__c=:N_NO) and vlocity_ins__ExpiredContractId__r.ARV_Renewal_Error__c =:EMPTY_STRING and Status!=:C_CANCELLED];
        List<contract> batchList = new List<contract>();
        for(Contract cntfail : renewalpack)
        {
            contract batchlog = new contract();
            batchlog.id=cntfail.vlocity_ins__ExpiredContractId__c;
            batchlog.ARV_Renewal_Error__c=ERROR;
            batchlog.ARV_Renewal_Creation_Status__c=ERRORMSG;
            batchlog.ARV_Renewal_Error_Message__c=RENEWALMSG;
            batchList.add(batchlog);
        }
        //if(batchList.size()>0){database.update(batchList);}
        // if(renewalpack.size()>0){database.delete(renewalpack);}
        List<Contract> totallistCon=[Select Id,ContractNumber,Account.Name,Account.CID__c,ARV_Renewal_Creation_Status__c,ARV_Renewal_Error__c,
                                     ARV_Renewal_Error_Message__c from Contract where renewal_batch__c=:batchId and
                                     ARV_Tech_Renewal_Flag__c =:Y_YES 
                                     limit 10000];
        
        conwrap.totalRecords=totallistCon.size();
        
        List<Contract> listviews=  [Select Id,ContractNumber,Account.Name,Account.CID__c,ARV_Renewal_Creation_Status__c,ARV_Renewal_Error__c,
                                    ARV_Renewal_Error_Message__c from Contract where renewal_batch__c=:batchId and
                                    ARV_Tech_Renewal_Flag__c =:Y_YES 
                                    order by contractNumber limit :rowsLimit];
        
        //conwrap.totalcontractsList=listViews;
        //system.debug(listviews[0]);
        
        conwrap.totalcontractsList=listNotStartedContractScroll(batchID, listviews);                                       
        //conwrap.contractsList=listViews;
        conwrap.contractsList=conwrap.totalcontractsList;
        
        return conwrap;
    }
    //To return additional records based on offset
    @AuraEnabled
    public static loadContractWrapper loadwrapBatchErorContracts(String finalRecId,String batchId ,Integer rowsLimit){
        loadContractWrapper loadcontrwrap= new loadContractWrapper();
        if(finalRecId != null){
            string querymorerec='Select Id,ContractNumber,Account.Name,Account.CID__c,ARV_Renewal_Creation_Status__c,ARV_Renewal_Error__c,ARV_Renewal_Error_Message__c'
                +' from contract';
            querymorerec +=' where renewal_batch__c=\'' +batchId+'\'';
            querymorerec +=' and ARV_Tech_Renewal_Flag__c=\'' +Y_YES+'\'';
            querymorerec +=' and contractNumber>\''+finalRecId+'\'' ;
            querymorerec +=' order by contractNumber limit '+rowsLimit;
            
            
            List<Contract>listviews =database.query(querymorerec);
            //loadcontrwrap.totalcontractsList=listViews;
            //loadcontrwrap.filtercontractsList=listViews;
            
            //conwrap.totalcontractsList=listViews;
            //system.debug(listviews[0]);
            loadcontrwrap.totalcontractsList=listNotStartedContractScroll(batchID, listviews);                                       
            //conwrap.contractsList=listViews;
            loadcontrwrap.filtercontractsList=loadcontrwrap.totalcontractsList;   
            //loadcontrwrap.totalcontractsList=listViews;
            //loadcontrwrap.filtercontractsList=listViews;     
        }
        return loadcontrwrap;
    }
    /*Checks batchjob completion
* methodName:checkbatchStatus*/
    @AuraEnabled
    public static String checkbatchStatus(String batchjobId){
        string batchapStatus=null;
        AsyncApexJob aaj = [SELECT Id, Status,CompletedDate, NumberOfErrors
                            FROM AsyncApexJob WHERE ID =:batchjobId limit 1]; 
        batchapStatus= aaj.Status;
        return batchapStatus;
    }
    
    /*Added for showing not started items */
    @AuraEnabled
    public static List <Contract> listNotStartedContractScroll(String batchID, List<Contract> contractIDs){
        
        Set<Id> setIDs = new Set<Id>();
        List<Contract> listContractNA = new List<Contract>();
        
        Set<Id> constartIds = new Set<Id>(); //all contracts because the method does not pass in a full contract
        
        for(Contract con: contractIDs){ 
            constartIds.add(con.id);
            
        }
        
        List<ARV_Renewal_Batch_Log__c> listContract = [select id,Name,ARV_Contract_Id__c,ARV_Renewal_Step_Status__c, ARV_Status_Message__c,ARV_Renewal_Batch_Id__c 
                                                       from ARV_Renewal_Batch_Log__c
                                                       where ARV_Renewal_Batch_Id__c =:batchID ]; //Pop by PB on rBL
        
        for (ARV_Renewal_Batch_Log__c result : listContract){
            conUniqueID.add(result.ARV_Contract_Id__c);           
        }
        
        List<Contract> listConStarted = [Select Id,ContractNumber,Account.Name,Account.CID__c,ARV_Renewal_Creation_Status__c,ARV_Renewal_Error__c,Renewal_Batch__c,
                                         ARV_Renewal_Error_Message__c from Contract where id in :constartIds];
        Set<Id> conNotStarted = new Set<Id>();
        
        for(Contract listCons: listConStarted){
            if( listcons.ARV_Renewal_Error__c == null){
                listcons.ARV_Renewal_Error_Message__c = listCons.ContractNumber+' has Not Started';
                conNotStarted.add(listcons.id);
            }
            if(conUniqueID.contains(listcons.id) && listcons.ARV_Renewal_Error__c == null){
                string lastStep = '';
                string lastStepID = '';
                string lastStepMessage = '';
                string lastStepStatus = '';
                for (ARV_Renewal_Batch_Log__c result : listContract){
                    
                    if(result.ARV_Contract_Id__c == listCons.id && result.ARV_Renewal_Batch_Id__c == listCons.Renewal_Batch__c){
                        lastStep = result.Name;
                        lastStepID = result.Id;  
                        lastStepMessage = result.ARV_Renewal_Step_Status__c;  
                        lastStepStatus = result.ARV_Status_Message__c;  
                        listCons.ARV_Renewal_Error_Message__c = listCons.ContractNumber+' has Started '+lastStep +' '+lastStepID +' '+lastStepMessage +' '+lastStepStatus ;
                        
                    }       
                }
                
            }            
        }
        
        return listConStarted;
    }   
    @AuraEnabled
    public static void refreshLogs(String batchID){
        //String batchID = 'a9v3B0000000FIjQAM'; /*batch ID to be mentioned here*/
        Set<Id> conUniqueID = new Set<Id>();
        List<Contract> contractIDs = [Select Id,ContractNumber,Account.Name,Account.CID__c,ARV_Renewal_Creation_Status__c,ARV_Renewal_Error__c,
                                      ARV_Renewal_Error_Message__c from Contract where Renewal_Batch__c = :batchID];
        
        Set<Id> setIDs = new Set<Id>();
        List<Contract> listContractNA = new List<Contract>();
        
        system.debug('unique batch name: '+ batchID);
        
        
        Set<Id> constartIds = new Set<Id>();
        
        for(Contract con: contractIDs){
            constartIds.add(con.id);
            
        }
        
        List<ARV_Renewal_Batch_Log__c> listContract = [select id,Name,ARV_Contract_Id__c,ARV_Renewal_Step_Status__c, ARV_Status_Message__c
                                                       from ARV_Renewal_Batch_Log__c
                                                       where ARV_Contract_Id__r.Renewal_Batch__c =:batchID and ARV_Contract_Id__c IN :constartIds]; 
        
        for (ARV_Renewal_Batch_Log__c result : listContract){
            conUniqueID.add(result.ARV_Contract_Id__c);           
        }
        
        List<Contract> listConStarted = [Select Id,ContractNumber,Account.Name,Account.CID__c,ARV_Renewal_Creation_Status__c,ARV_Renewal_Error__c,
                                         ARV_Renewal_Error_Message__c from Contract where id in :constartIds];
        Set<Id> conNotStarted = new Set<Id>();
        for(Contract listCons: listConStarted){
            if( listcons.ARV_Renewal_Error__c == null){
                listcons.ARV_Renewal_Error_Message__c = listCons.ContractNumber+' has Not Started';
                
            }
            if(conUniqueID.contains(listcons.id) && listcons.ARV_Renewal_Error__c == null){
                string lastStep = '';
                string lastStepID = '';
                string lastStepMessage = '';
                string lastStepStatus = '';
                for (ARV_Renewal_Batch_Log__c result : listContract){
                    
                    if(result.ARV_Contract_Id__c == listCons.id){
                        lastStep = result.Name;
                        lastStepID = result.Id;  
                        lastStepMessage = result.ARV_Renewal_Step_Status__c;  
                        lastStepStatus = result.ARV_Status_Message__c;                           
                    }       
                }
                listCons.ARV_Renewal_Error_Message__c = listCons.ContractNumber+' has Started '+lastStep +' '+lastStepID +' '+lastStepMessage +' '+lastStepStatus ;
                
            }
            if( listcons.ARV_Renewal_Error__c == null){
                listcons.ARV_Renewal_Error_Message__c = listCons.ContractNumber+' has Not Started';
                conNotStarted.add(listcons.id);
            }
        }
        
        List<Id> listpendingCon = new List<Id>();
        listpendingCon.addAll(conNotStarted);
        initiateBatch(listpendingCon);
        
    }
}