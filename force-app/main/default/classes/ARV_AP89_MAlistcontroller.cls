/**
@Name: ARV_AP89_MAlistcontroller
@CreatedDate: 10-March-2020
@Description: ARV_AP89_MAlistcontroller List views for DC & Non DC contracts....
@version : 1.0 
*/
public with sharing class ARV_AP89_MAlistcontroller {
    private static final String METADATA_QRY = 'SELECT MasterLabel, QualifiedApiName,'+
        'Month__c FROM ARV_Renewal_Contract_List_View__mdt order by MasterLabel asc';
    private static final String CONTRACT_QRY = system.label.ARV_CONTRACT_RENEWAL_QUERY;
    
    private static final String PROCEDURE_NAME = 'Renewal_GenerateRenewal'; 
    private static final String CANCELED = 'Canceled';
    private static final String PENDING = 'Pending';
    private static final String EXCLUDE_CONTRACT_QUERY = 'Select Id,ARV_Excluded_from_Renewal__c from Contract';
    private static final String EXCLUDE_CONTRACT_WHERE_QUERY = ' Where id in:idsList';
    private static final String CONTRACT_QRY_LIMIT = 'LIMIT 5 OFFSET 0';
    private static final String CONTRACT_LISTVIEWS_QUERY = 'SELECT MasterLabel, QualifiedApiName,Sort_Order__c,'+
        'Component_Name__c FROM ARV_MA_Contract_ListView__mdt order by Sort_Order__c asc';
    private static final String AGENTCONTRACT_LISTVIEWS_QUERY = 'SELECT MasterLabel, QualifiedApiName,Sort_Order__c,'+
        'Component_Name__c FROM ARV_Agent_Contract_ListView__mdt order by Sort_Order__c asc';
    //ARV_Agent_Contract_ListView
    private static final String TEXT_SG='SG';
    private static final String ACTIVE = 'Active';
    private static final String ACTIVATED='Activated';
    private static final String NONE = '';
    private static final String READY = 'Ready';
    private static final String PEND = 'Pend';
    private static final String WITHDRAW = 'Withdraw';
    private static final String RELEASED = 'Released';
    private static final String COMPLETED = 'Completed';
    private static final String RENEWAL ='renewal';
    private static final String LIMIT_QRY=' limit 100';
    /**
@Description: listValues() method
@Name : listValues
@Param : NA
@Return : ListViewWrapper
@throws Exception : N/A;
*/
    @AuraEnabled
    public static list<ListViewWrapper> listValues(){ 
        try{
            list<ListViewWrapper> oListViewWrapper = new list<ListViewWrapper>();
            List<ARV_Renewal_Contract_List_View__mdt> listViews =ARV_AP07_QueryDataHelper.getsObjects(METADATA_QRY,
                                                                                                      NULL,NULL,LIMIT_QRY);
            ListViewWrapper oWrapper = new ListViewWrapper();
            for(ARV_Renewal_Contract_List_View__mdt lv : listViews){
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
            List<ARV_MA_Contract_ListView__mdt> listViews =ARV_AP07_QueryDataHelper.getsObjects(CONTRACT_LISTVIEWS_QUERY,
                                                                                                NULL,NULL,LIMIT_QRY);
            for(ARV_MA_Contract_ListView__mdt lv : listViews){ 
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
@Description: listViews() method
@Name : listViews
@Param : NA
@Return : ListViewWrapper
@throws Exception : N/A;
*/
    @AuraEnabled
    public static list<ListViewWrapper> agentListViews(){ 
        try{
            list<ListViewWrapper> oListViewWrapper = new list<ListViewWrapper>();
            List<ARV_Agent_Contract_ListView__mdt> listViews =ARV_AP07_QueryDataHelper.getsObjects(AGENTCONTRACT_LISTVIEWS_QUERY,
                                                                                                NULL,NULL,LIMIT_QRY);
            for(ARV_Agent_Contract_ListView__mdt lv : listViews){ 
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
@Description: getMADCRenewalContracts() method
@Name : getMADCRenewalContracts
@Return : Contract
@throws Exception : N/A;
*/
   @AuraEnabled
    public static List<Contract> getMADCRenewalContracts(Integer rowsLimit,Integer rowsOffset){
        List<Account> listViews=new List<Account>();
        set<Id> renewedAccId=new set<id>();
        
        try {
            List<Contract> renewconlist=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                       Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                       Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c
                                       from contract 
                                       WHERE  recordtype.name=:RENEWAL and Account.ARV_Renewal_Account_Type__c=:TEXT_SG 
                                       and ARV_Excluded_from_Renewal__c=false and Account.Account_Status__c=:ACTIVE 
                                       and (ARV_Renewal_Status__c=:READY or ARV_Renewal_Status__c=:RELEASED or ARV_Renewal_Status__c=:COMPLETED)];
            system.debug('renewconlist::'+renewconlist.size());
            for(contract con:renewconlist){
                renewedAccId.add(con.AccountId);
            }
            List<Account> acclist =[select id,(select id,GA_DC_Small_Group__c,Status__c from Group_Segments__r where Status__c=:ACTIVE) from Account where Account_Status__c=:ACTIVE and ARV_Renewal_Account_Type__c=:TEXT_SG and recordtype.name=:'Account - Customer' and id IN:renewedAccId limit :rowsLimit offset :rowsOffset];
            system.debug('acclist::'+acclist.size());
            listViews =macontracts(acclist); 
            set<id> accid=new set<id>();
            for(Account acc:listViews){
                accid.add(acc.id);
            }
            List<contract> dcListview=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                       Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                       Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c
                                       from contract 
                                       WHERE AccountId IN:accid and recordtype.name=:RENEWAL and Account.ARV_Renewal_Account_Type__c=:TEXT_SG 
                                       and ARV_Excluded_from_Renewal__c=false and Account.Account_Status__c=:ACTIVE 
                                       and (ARV_Renewal_Status__c=:READY or ARV_Renewal_Status__c=:RELEASED or ARV_Renewal_Status__c=:COMPLETED) 
                                       order by contractNumber limit:rowsLimit];
            system.debug('dcListview::'+dcListview.size());
            return dcListview;
            
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
/**
@Description: getMANONDCRenewalContracts() method
@Name : getMANONDCRenewalContracts
@Return : Contract
@throws Exception : N/A;
*/
    @AuraEnabled
    public static List<Contract> getMANONDCRenewalContracts(Integer rowsLimit,Integer rowsOffset){
        
        List<Account> listViews=new List<Account>();
        set<id> renewAccId=new set<id>();
        try {
            List<Contract> renewconlist=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                         Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                         Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c
                                         from contract 
                                         WHERE recordtype.name=:RENEWAL and Account.ARV_Renewal_Account_Type__c=:TEXT_SG
                                         and ARV_Excluded_from_Renewal__c=false and Account.Account_Status__c=:ACTIVE 
                                         and ( ARV_Renewal_Status__c=:RELEASED or ARV_Renewal_Status__c=:COMPLETED)];
            system.debug('renewconlist::'+renewconlist.size());
            for(contract con:renewconlist){
                renewAccId.add(con.AccountId);
            }
            List<Account> acclist =[select id,name,(select id,GA_DC_Small_Group__c,Status__c from Group_Segments__r where Status__c=:ACTIVE) from Account where id IN:renewAccId and Account_Status__c=:ACTIVE and ARV_Renewal_Account_Type__c=:TEXT_SG and recordtype.name=:'Account - Customer' limit :rowsLimit offset :rowsOffset];
            listViews =maNoncontracts(acclist);
            set<id> accid=new set<id>();
            for(Account acc:listViews){
                accid.add(acc.id);
            }
            List<Contract> nonDCconlist=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                         Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                         Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c
                                         from contract 
                                         WHERE AccountId IN:accid and recordtype.name=:RENEWAL and Account.ARV_Renewal_Account_Type__c=:TEXT_SG
                                         and ARV_Excluded_from_Renewal__c=false and Account.Account_Status__c=:ACTIVE 
                                         and ( ARV_Renewal_Status__c=:RELEASED or ARV_Renewal_Status__c=:COMPLETED) 
                                         order by contractNumber ];
            return nonDCconlist;
            
        } catch(Exception e) {
            //system.debug('Error::'+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
     /**
@Description: getAgentDCRenewalContracts() method
@Name : getMADCRenewalContracts
@Return : Contract
@throws Exception : N/A;
*/
    @AuraEnabled
    public static ContractWrapper getAgentDCRenewalContracts(Integer rowsLimit,Integer rowsOffset){
        ContractWrapper conwrap= new ContractWrapper();
        List<Id> conids=New List<Id>();
        //List<Account> listViews=new List<Account>();
        set<Id> renewedAccId=new set<id>();
		 //List<contract> listViews=new List<contract>();
		 set<id> conSet=new set<id>();
        set<id> conEnrollset=new set<id>();
        set<string> statusSet=new set<string>{'Cancelled','Enrollment Submission – Error','In Progress','Draft','Rejected','Expired','Underwriting - Under Review','Under Review'};
        try {
            List<Contract> renewconlist=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,recordtype.name,
                                       Account.Renewal_Month__c,Account.Name, Status,
                                       (select id,GA_DC_Small_Group__c,GA_Suite__c from Group_Segments__r where GA_Suite__c!=null)
                                       from contract where Account.ARV_Renewal_Account_Type__c='SG' 
                                       and Status NOT IN:statusSet and ARV_Excluded_from_Renewal__c=false ];
            system.debug('renewconlist::'+renewconlist.size());
			   /* for(contract cont:renewconlist){
                if(cont.ARV_Renewal_Status__c==COMPLETED && cont.recordtype.name==RENEWAl){
                    conSet.add(cont.id);
                }
                else if(cont.recordtype.name=='Enrollment'){
                    conEnrollset.add(cont.id);
                }
                else{}
            }
            system.debug('conSet::'+conSet.size());
            system.debug('conSet::'+conSet);
            system.debug('conEnrollset::'+conEnrollset.size());*/
            
            List<id> totalCont=new List<id>(conSet);
            totalCont.addAll(conEnrollset);
            //system.debug('totalCont::'+totalCont.size());
            /*List<contract> conlisvtview=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                       Account.Renewal_Month__c,Account.Name, Status,
                                      (select id,GA_DC_Small_Group__c from Group_Segments__r)
                                       from contract where id IN:totalCont and Status NOT IN:statusSet];
            system.debug('conlisvtview::'+conlisvtview.size());*/
			List<id> contDCset=new List<id>();
			List<contract> dcListview=agentDCContracts(renewconlist);
            system.debug('dcListview:::'+dcListview);
			for(contract cont:dcListview){
			contDCset.add(cont.id);
			}
			List<contract> conlisvtview1=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                       Account.Renewal_Month__c,Account.Name,Status,
                                       Account.GA_Opportunity_Renewal_Date__c
                                       from contract where id IN:contDCset and Status NOT IN:statusSet limit:rowsLimit ];
            /*List<contract> conlisvtview2=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                       Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                       Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c,(select id,GA_DC_Small_Group__c from Group_Segments__r)
                                       from contract where id IN:contDCset limit 2];*/
            conwrap.filtercontractIds=contDCset;
            conwrap.totalcontractsList=conlisvtview1;
            conwrap.contractsList=conlisvtview1;
            conwrap.totalRecords=dcListview.size();
            return conwrap;
            
        } catch(Exception e) {
            system.debug('Error at:'+e.getLineNumber()+' '+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
     @AuraEnabled
    public static loadContractWrapper loadwrapAgentContractRecords(String finalRecId,List<id> conId,Integer rowsLimit){
        loadContractWrapper loadcontrwrap= new loadContractWrapper();
        system.debug('Final Record::'+finalRecId);
        system.debug('conId:'+conId);
        try {
          
            
           
        system.debug('conId::'+conId.size());
        if(finalRecId !=null){
     
      List<Contract>listviews =[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                       Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                       Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c
                                       from contract 
                                       WHERE  Id IN:conId and contractnumber >: finalRecId 
                                       order by contractNumber limit:rowsLimit];//database.query(querymorerec);*/
        system.debug('listviews::'+listviews);
        loadcontrwrap.totalcontractsList=listViews;
        loadcontrwrap.filtercontractsList=listViews;
        }
            return loadcontrwrap;
        }
        
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
          
    }
    /**
@Description: getMADCRenewalContracts() method
@Name : getMADCRenewalContracts
@Return : Contract
@throws Exception : N/A;
*/
    @AuraEnabled
    public static ContractWrapper getAgentNonDCRenewalContracts(Integer rowsLimit,Integer rowsOffset){
        ContractWrapper conwrap= new ContractWrapper();
        List<Id> conids=New List<Id>();
        List<Account> listViews=new List<Account>();
        set<Id> renewedAccId=new set<id>();
        
        try {
            List<Contract> renewconlist=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                       Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                       Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c
                                       from contract 
                                       WHERE  recordtype.name=:RENEWAL and Account.ARV_Renewal_Account_Type__c=:TEXT_SG 
                                       and ARV_Excluded_from_Renewal__c=false and Account.Account_Status__c=:ACTIVE 
                                       and (ARV_Renewal_Status__c=:READY or ARV_Renewal_Status__c=:RELEASED or ARV_Renewal_Status__c=:COMPLETED)];
            system.debug('renewconlist::'+renewconlist.size());
            
            for(contract con:renewconlist){
                renewedAccId.add(con.AccountId);
                conids.add(con.Id);
            }
            system.debug('Limit::'+rowsLimit);
            system.debug('ACCID::'+renewedAccId.size());
            List<Account> acclist =[select id,(select id,GA_DC_Small_Group__c,Status__c from Group_Segments__r where Status__c=:ACTIVE) from Account where id IN:renewedAccId and Account_Status__c=:ACTIVE and ARV_Renewal_Account_Type__c=:TEXT_SG and recordtype.name=:'Account - Customer' limit 1000];
            system.debug('acclist::'+acclist.size());
            listViews =maNoncontracts(acclist); 
            system.debug('List view size::'+listViews.size());
            List<id> accid=new List<id>();
            for(Account acc:listViews){
                accid.add(acc.id);
            }
            conwrap.filtercontractIds=conids;
            conwrap.filterAccountIds=accid;
            system.debug('Filter ACC ID::'+conwrap.filterAccountIds);
            List<contract> nondcListview=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                       Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                       Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c
                                       from contract 
                                       WHERE AccountId IN:accid and recordtype.name=:RENEWAL and Account.ARV_Renewal_Account_Type__c=:TEXT_SG 
                                       and ARV_Excluded_from_Renewal__c=false and Account.Account_Status__c=:ACTIVE 
                                       and (ARV_Renewal_Status__c=:RELEASED or ARV_Renewal_Status__c=:COMPLETED) 
                                       order by contractNumber limit:rowsLimit];
            system.debug('nondcListview::'+nondcListview.size());
            List<contract> dcConListview=[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                       Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                       Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c
                                       from contract 
                                       WHERE AccountId IN:accid and recordtype.name=:RENEWAL and Account.ARV_Renewal_Account_Type__c=:TEXT_SG 
                                       and ARV_Excluded_from_Renewal__c=false and Account.Account_Status__c=:ACTIVE 
                                       and (ARV_Renewal_Status__c=:RELEASED or ARV_Renewal_Status__c=:COMPLETED) 
                                       order by contractNumber limit 10];
            system.debug('dcListview::'+dcConListview.size());
            conwrap.totalcontractsList=dcConListview;
            conwrap.contractsList=dcConListview;
            conwrap.totalRecords=nondcListview.size();
            return conwrap;
            
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
     @AuraEnabled
    public static loadContractWrapper loadwrapAgentNonDCRenewalRecords(String finalRecId,List<id> accId,Integer rowsLimit){
        loadContractWrapper loadcontrwrap= new loadContractWrapper();
        system.debug('Final Record::'+finalRecId);
        system.debug('Accid:'+accId);
        try {
         
            if(finalRecId !=null){
          
          List<Contract>listviews =[select Id,AccountId,ContractNumber,ARV_Renewal_Status__c,
                                           Account.Renewal_Month__c,Account.Name, Account.GA_Renewal_Year__c,Status,
                                           Account.GA_Opportunity_Renewal_Date__c,ARV_Requested_Effective_Date__c
                                           from contract 
                                           WHERE  AccountId IN:accid and contractnumber >: finalRecId and recordtype.name=:RENEWAL and Account.ARV_Renewal_Account_Type__c=:TEXT_SG 
                                           and ARV_Excluded_from_Renewal__c=false and Account.Account_Status__c=:ACTIVE 
                                           and (ARV_Renewal_Status__c=:RELEASED or ARV_Renewal_Status__c=:COMPLETED) 
                                           order by contractNumber limit:rowsLimit];
                system.debug('List view in Load::'+listViews);
            loadcontrwrap.totalcontractsList=listViews;
            loadcontrwrap.filtercontractsList=listViews;
            }
                return loadcontrwrap;
        }
        
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
          
    }
    /*********************************************
@Description: ListViewWrapper wrapper class
@Name : ListViewWrapper
*********************************************/
    public without Sharing class ListViewWrapper{
        @AuraEnabled public string label{get;set;} 
        @AuraEnabled public string developerName{get;set;} 
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
        public List<Id> filterAccountIds = new List<Id>();
         @AuraEnabled
        public List<Contract> totalConstoUpdate = new List<Contract>();
    }
     public class loadContractWrapper{
        @AuraEnabled
        public List<Contract> filtercontractsList = new List<Contract>();
        @AuraEnabled
        public List<Contract> totalcontractsList = new List<Contract>();
    }
    /**********************************************
@Description: macontracts() method
@Name : macontracts
@Return : Contract
@throws Exception : N/A;
***********************************************/
    private static List<Account> macontracts(List<Account> aclist){
        system.debug('Acclist::'+aclist);
        List<Account> dclist=new List<Account>();
        List<Account> nonDclist=new List<Account>();
        List<GA_Group_segment__C> gslist=new List<GA_Group_segment__C>();
        boolean flag=false;
        for(account acc:aclist){
            if(acc.Group_Segments__r.size()>0 && isNoGroupSegementsDC(acc.Group_Segments__r)){
                dclist.add(acc);
            }
        } 
        return dclist;
    }
     /**********************************************
@Description: macontracts() method
@Name : macontracts
@Return : Contract
@throws Exception : N/A;
***********************************************/
    private static List<Contract> agentDCContracts(List<Contract> conlist){
       // system.debug('Con list in method::'+conlist.size());
        List<Contract> agentDCList=new List<Contract>();
        
        List<GA_Group_segment__C> gslist=new List<GA_Group_segment__C>();
        boolean flag=false;
        for(Contract con:conlist){
          // system.debug('segment1::'+isNoGroupSegementsDC(con.Group_Segments__r));
            if(con.Group_Segments__r.size()>0 && isNoGroupSegementsDC(con.Group_Segments__r)){
                //system.debug('segment::'+con.Group_Segments__r);
                agentDCList.add(con);
            }
        } 
        system.debug('agentDCList::'+agentDCList.size());
        return agentDCList;
    }
    private static Boolean isNoGroupSegementsDC(List<GA_Group_Segment__c> groupSegements) {
        Integer count = 0;
        //system.debug('GS::'+groupSegements);
        for(GA_Group_Segment__c gs:groupSegements) {
            if(gs.GA_DC_Small_Group__c==false) {
                count++;
            }
        }
        
        return count>0?false:true;
    }
    private static List<Account> maNoncontracts(List<Account> aclist){
        //system.debug('aclist::'+aclist.size());
        List<Account> nonDclist=new List<Account>();
        for(account acnt:aclist){
            //system.debug('GS::'+isNoGroupSegementsNonDC(acnt.Group_Segments__r));
            if(acnt.Group_Segments__r.size()>0 && isNoGroupSegementsNonDC(acnt.Group_Segments__r)){
                nonDclist.add(acnt);
            }
        } 
        system.debug('nonDCList:'+nonDclist.size());
        return nonDclist;
    }
    private static Boolean isNoGroupSegementsNonDC(List<GA_Group_Segment__c> groupSegements) {
        //system.debug('Executing');
        Integer count = 0;
        for(GA_Group_Segment__c gs:groupSegements) {
            if(gs.GA_DC_Small_Group__c==false) {
                count++;
            }
        }
        //system.debug('Count::'+count);
        return count>0?true:false;
    }
}