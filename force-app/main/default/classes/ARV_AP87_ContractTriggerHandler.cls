/*****************************************************************************************
Class Name   : ARV_AP87_ContractTriggerHandler 
Date Created : 27-March-2020
Created By   : IDC Offshore
Description  :This is the class for Update contract Records .
******************************************************************************************/
Public without sharing class ARV_AP87_ContractTriggerHandler {
    private static final String  CONTRACTQUERY ='select id,ARV_Renewal_Status__c,vlocity_ins__ExpiredContractId__c,'+
        'ARV_Requested_Effective_Date__c,EndDate,ARV_Contract_Type__c,startDate,status,AccountId from Contract ';
    private static final String  CONTRACTWHERE= ' where id in:paramId2 ';
	private static final Date EffDateRen=NULL;
    private static final String  CONTRACTWHERE2 = ' where  ARV_Renewal_Status__c =\'Released\' and id in:paramId2 ';
    Private static final string GROUPSEGMENTQUERY='Select id,Status__c,ARV_ContractID__c,'
        +'ARVPackage_Location_Segment_Relationship__c,ARV_Pending_ContractId__c,ARV_Package__c,'+
        'ARV_GS_Dental_Type__c,ARV_GS_Vision_Type__c,ARV_Pending_PackageId__c from GA_Group_Segment__c';
    Private static final string GROUPSEGMENTWHERE=' Where  Status__c=\'Active\' and ARV_ContractID__c =:paramId2';
    private static final string AUTOMATEDENROLLMENT='Automated Enrollment Setup - Complete'; 
    private static final string MANUALENROLLMENT='Manual Enrollment Setup - Complete';
    private static final string ACTIVATED='Activated';
    private static final string CANCELLED='Cancelled';
    private static final string COMPLETED='Completed';
    private static  date RENEWALDT=null;
    private static final string FUTURE='Future';
    private static final String  CONTRACTWHERE1 =' where  ARV_Renewal_Status__c =\'Completed\' AND' 
        +' Status =\'Activated\' and Id IN : paramId2 ';
    private static final String  GROUPSEGMENTWHERE1 =' where ARV_Pending_ContractId__c IN : paramId2 '
        +'AND ARV_Pending_PackageId__c != null';
    private static final String  ENROLLMENTCENSUSID ='enrollmentCensusId';
    private static final String  CONTRACTID1='contractId';
    private static final String ENROLLMENTSYSCENSUS ='Enrollment_systemCensus';
    private static final String SYSTEMCENSUSID='systemCensusId';
    private static final String  CONTRACTWHERE3= ' where Status =\'Future\' AND'+
                     ' id in:paramId2 ';
      private static final String  SMALLGWC='Small Group GWC';
   private static final String GWCSUBMITTED ='GWC Submitted';
   private static final String APPROVEDVALID ='Approved – Validate Data/Setup Group Segments';
   private static final string  HEALTHEQUITY='Health Equity';    
     private static final string HSABLANK='HSA Bank';
      private static  Boolean isFirst=true;
      private static final String  AUTOMATEDGWCSETUP= 'Automated GWC Setup - Complete'; 
    private static final String  MANUALGWCSETUP= 'Manual GWC Setup – Complete'; 
    private static final String PROCESSINGGWC = 'Processing GWC';
    public static Boolean flagDocGen = true;
    public static Boolean isEmailSent= true;
    public static Id ENROLLMENT= Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
    public static Id RENEWAL= Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
    public static Id GWC= Schema.SObjectType.Contract.getRecordTypeInfosByName().get('GWC').getRecordTypeId();
    
    public static final String UNDERREVIEW = 'Under Review';
    public static final String APPROVAL = 'Approval Process - Approved';
    public static Id gwcTTRcrdTypId = Schema.SObjectType.ARV_GWC_Transaction_Table__c.getRecordTypeInfosByName().get('Group Wide Changes').getRecordTypeId();
    /**************  
Method name : updateStatusToCancelled
Params     : list
Return Type : null
Description :updateStatusToCancelled() method to update status to cancelled on renewal contracts
*************/    
    public static void updateStatusToCancelled(list<Contract> contractList,map<id,Contract> contOldMap){
        Set<Id> accId = new Set<Id>();
        Set<Id> contId = new Set<Id>();
      //  Map<Id,Contract> accContractMap = new Map<Id,Contract>();
        List<Contract> contractStatusToCncld = new List<Contract>();
        for(contract con: contractList){
            if(con.vlocity_ins__ExpiredContractId__c!=null && con.ARV_Renewal_Status__c == COMPLETED &&
               contOldMap.get(con.id).ARV_Renewal_Status__c != con.ARV_Renewal_Status__c){
                   accId.add(con.AccountId);
                   contId.add(con.id);
               }            
        }
        if(!accId.isEmpty()){
            for(Contract con: [select id,AccountId,Status from Contract 
                               where AccountId IN: accId and vlocity_ins__ExpiredContractId__c != null 
                               order by CreatedDate desc LIMIT 5000]){
                if(!contId.contains(con.id)  && con.Status!=CANCELLED){
                    //accContractMap.put(con.AccountId,con);
                    con.Status = CANCELLED;
                    contractStatusToCncld.add(con);
                }            
            }
        }
        if(!contractStatusToCncld.isEmpty()){
            database.update(contractStatusToCncld);
        }        
    }
    /**************  
Method name : afterupdate
Params     : list
Return Type : null
Description :afterupdate() method for update renewal contract related contract end date.
*************/
    public static void afterupdate(list<Contract> contractList, map<id,Contract> contOldMap)
    {
        try{
            set<id> oldContractIds=new set<id>();
            set<id> contractIds=new set<id>();
              set<id> oldContractIds1=new set<id>();
            set<id> gwcContracts=new set<id>();
            Map<id,String> gwcContractsMap = new Map<id,String>();
            updateStatusToCancelled(contractList,contOldMap);
            for(contract cont:contractList){
                if(cont.ARV_Contract_Type__c==SMALLGWC && (cont.Status==GWCSUBMITTED ||cont.Status==APPROVEDVALID)&&
                   (cont.ARV_Spending_Account_Manager__c==HSABLANK || cont.ARV_Spending_Account_Manager__c==HEALTHEQUITY)&&
                   (contOldMap.get(cont.id).Status != cont.Status)&&isFirst){
                    gwcContracts.add(cont.Id);
                    gwcContractsMap.put(cont.Id,cont.ARV_Spending_Account_Manager__c);
                 }
                if(cont.ARV_Renewal_Status__c!=null && cont.vlocity_ins__ExpiredContractId__c!=null){
                    contractIds.add(cont.Id);
                   // updateGpRenewalContract(contractIds);
                }else if(cont.ARV_Renewal_Status__c==null && cont.vlocity_ins__ExpiredContractId__c==null &&
                         cont.StartDate>system.Today() &&(cont.status==AUTOMATEDENROLLMENT|| cont.status==MANUALENROLLMENT)){
                             oldContractIds.add(cont.Id);
                           //  updateContractStaustoFuture(oldContractIds);
                         }
                else if(cont.ARV_Renewal_Status__c==null && cont.vlocity_ins__ExpiredContractId__c==null &&
                         cont.StartDate<=system.Today() &&(cont.status==FUTURE)){
                             oldContractIds1.add(cont.Id);
                         }else{}
            }
            if(!oldContractIds.isEmpty()){
                updateContractStaustoFuture(oldContractIds);
            }
            if(!oldContractIds1.isEmpty()){
                 updateContractStatus(oldContractIds1);
            }
            //added for 3653
            if(!gwcContracts.isEmpty() && isFirst){
                isFirst=false;
                System.debug('number of contracts:++'+gwcContracts.size());
                for(Id cnt:gwcContracts){
           //      ARV_AP58_ApproveContract.sendEmailAddCDH(cnt, gwcContractsMap.get(cnt), contOldMap.get(cnt).ARV_Spending_Account_Manager__c); 
                }
            }
			
            Map<Id,Date> updateDate=new Map<Id,Date>();
			Set<Id> accId = new Set<Id>();
			Set<Id> contId = new Set<Id>();
            if(!contractIds.isEmpty()){
                ARV_AP07_QueryDataHelper.paramId2=contractIds;
                List<Contract> contractList2=ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,CONTRACTWHERE2,NULL,NULL);
                for(contract cont:contractList2){
                    updateDate.put(cont.vlocity_ins__ExpiredContractId__c, cont.ARV_Requested_Effective_Date__c);
                }
                list<contract> contractLists=new list<contract>();
                ARV_AP07_QueryDataHelper.paramId2=updateDate.keySet();
                List<contract> contractList1=ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,CONTRACTWHERE,NULL,NULL);
                for(contract contLis:contractList1){
                    if(contLis.ARV_Contract_Type__c == 'Small Group GWC'){
                    	if(contLis.ARV_Requested_Effective_Date__c<updateDate.get(contLis.Id)){
                        contLis.EndDate=updateDate.get(contLis.Id)-1;
                    contractLists.add(contLis); 
                    	} else if(contLis.ARV_Requested_Effective_Date__c==updateDate.get(contLis.Id)){
                      contLis.status='Cancelled';
                      RENEWALDT=updateDate.get(contLis.Id)-1;
                      contractLists.add(contLis); 
                      accId.add(contLis.AccountId);
                    }  
                	}
                }     
                list<Contract> cntlist=[select id,enddate from contract where Accountid in :accId and recordtype.name='Enrollment' limit 1] ;
                if(cntlist.size()>0){
                  cntlist[0].enddate= RENEWALDT;
                   database.update(cntlist);
                }
                if(contractLists.size()>0){
                    database.update(contractLists);
                }
                updateGpRenewalContract(contractIds);
            }
             			
            
            //for(Contract contractListMail : contractList){
           // if(contractListMail.ARV_Contract_Type__c=='Small Group GWC' && contractListMail.status=='Approved – Validate Data/Setup Group Segments'){
             //  ARV_AP_ContractEmailHandler.aprGWCEmail(contractListMail) ; 
               //sendEmail =true; call function from a separate class for mail sending
           // }
       // }
        } catch(Exception e) { 
            system.debug('Error at Line:'+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**************  
Method name : updateContractStatus
Params     : set<id>
Return Type : null
Description :updateContractStatus() method for update contract status based on group segments status..
*************/
    public static void updateContractStaustoFuture(set<id> oldContractIds){
        ARV_AP07_QueryDataHelper.paramId2=oldContractIds;
        List<Contract> contractList2=ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,CONTRACTWHERE,NULL,NULL);
        List<Contract> updateContractList=new list<Contract>(); 
        contract cnt=null;
        for(contract cont:contractList2){
            cnt=new contract();
            cnt.id=cont.id;
            cnt.status=FUTURE;            
            updateContractList.add(cnt);
        }
        if(updateContractList.size()>0){
            database.update(updateContractList);
        }
    }
    
    public static void aprGWCEmail(String Accountname,String accountcid){
       
                try{
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String emailBody = '';
                string toAddresses = '';
                 String  SUBJECT   ='Potential Need to Reprocess Renewal';         
                system.debug('how many emails!!!!'+toAddresses);
                mail.setToAddresses(new String[]{''});
                mail.setSubject(SUBJECT);
                emailBody += '<html>Hello,<br><br/><p> Due to processing of a change prior to the effective date of the renewal contract, the current renewal may need to be reprocessed if there were any benefit, rating area, or group structure changes.'+Accountname+' '+accountcid+':&nbsp;</p></html>';

                mail.setHTMLBody(emailBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                system.debug('email!!!!');
                }
        catch(Exception e)  {}
 }

    /**************  
Method name : updateContractStatus
Params     : set<id>
Return Type : null
//Description :updateContractStatus() method for update contract status based on group segments status..
*************/
    public static void updateContractStatus(set<id> oldContractIds){
        map<id,integer> gsMap=new map<id,integer>();
        ARV_AP07_QueryDataHelper.paramId2=oldContractIds;
        list<GA_Group_Segment__c> gsList=ARV_AP07_QueryDataHelper.getsObjects(GROUPSEGMENTQUERY,GROUPSEGMENTWHERE,NULL,NULL);     
        if(gsList.size()>0){
            for(GA_Group_Segment__c gsl:gsList){
                gsMap.put(gsl.ARV_ContractID__c,gsList.Size());
            }
        }
        list<Contract> updatedContracts=new List<Contract>();
        contract cnt=null;
        for(Id cont:gsMap.keyset()){
            cnt=new contract();
            cnt.id=cont;
            cnt.status=ACTIVATED;            
            updatedContracts.add(cnt);
        }
        if(updatedContracts.size()>0){
            database.update(updatedContracts);
            //ARV_AP88_GroupSegmentPackageCreation.groupSegmentPckRec(updatedContracts);
        }
    }
     /**************  
Method name : updateContractStatus
Params     : set<id>
Return Type : null
Description :updateContractStatus() method for update contract status based on group segments status..
*************/
      public static void updateContractStatusAfterGS(set<id> ContractIds){
         ARV_AP07_QueryDataHelper.paramId2=ContractIds;
         List<Contract> contractList2=ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,CONTRACTWHERE3,NULL,NULL);
         List<Contract> updatedContracts=new List<Contract>();
          contract cnt=null;
          if(contractList2.size()>0){
           for(Contract cont:contractList2){
               if(cont.startdate<=system.today()){
                   cnt=new contract();
                   cnt.id=cont.id;
                   cnt.status=ACTIVATED;            
                   updatedContracts.add(cnt);
               }
           }
        }
        if(updatedContracts.size()>0){
            database.update(updatedContracts);
        }            
      }
    /**************  
Method name : updateGpRenewalContract
Params     : set<id>
Return Type : null
Description :updateGpRenewalContract() method for update Renewal contract status based on group segments status..
*************/ 
    Public static void updateGpRenewalContract(Set<ID> conIds){
        ARV_AP07_QueryDataHelper.paramId2=conIds;
        List<Contract> renContracts =  ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,CONTRACTWHERE1,NULL,NULL);
        Set<Id> conIdwithcheck = new Set<ID>();
        for(contract con : renContracts){
            conIdwithcheck.add(con.id);
        }
        ARV_AP07_QueryDataHelper.paramId2 = conIdwithcheck;
        List<GA_Group_Segment__c> newGpList = ARV_AP07_QueryDataHelper.getsObjects(GROUPSEGMENTQUERY,GROUPSEGMENTWHERE1,NULL,NULL);
        List<GA_Group_Segment__c> nullGpList = new List<GA_Group_Segment__c>();
        if(newGpList.size()>0){
            for(GA_Group_Segment__c gp : newGpList){
                gp.ARV_ContractId__c = gp.ARV_Pending_ContractId__c;
                gp.ARV_Pending_ContractId__c = null;
                gp.ARV_Package__c = gp.ARV_Pending_PackageId__c;
                gp.ARV_Pending_PackageId__c= null;
                nullGpList.add(gp);
            }
        }
        database.update(nullGpList);
        if(nullGpList.size() >0){
            ARV_AP88_GroupSegmentPackageCreation.createContractPackageHistory(nullGpList);       
        }        
    }
    
    
/**************  
Method name : getContractStatusBCNSheet
Params     :  list contract<>, map<id>
Return Type : null
Description : this method will call ARV_AP_GWC_BR_Doc class to generate BNR sheet
*************/    
        public static void getContractStatusBCNSheet(List<Contract> contractList, Map<Id, Contract> conMap){
    
    try{
	 // Set<Id> conIds = new Set<Id>();
        
           for (Contract con: contractList) {
        Contract oldCon = conMap.get(con.ID);
        if(con.status != oldCon.status && (con.status == MANUALGWCSETUP ||  con.status == AUTOMATEDGWCSETUP) ) {
          ID jobID =System.enqueueJob(new ARV_AP_GWC_BR_Doc(con.id));
          system.debug('conList Job Id '+ jobID);
            //ARV_AP87_ContractTriggerHandler.flagDocGen = false;
        }
    }
             } catch(Exception e) { 
            system.debug('Error at Line:'+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
/**************  
Method name : updateCensusMembers
Params     :  Id
Return Type : null
Description : this method will update census Member records from Contract trigger
*************/
  public static void updateCensusMembers(String recordType,String censusId,String systemCensusId) {
      
        try {
			List <vlocity_ins__GroupCensusMember__c> updatedCensusMember = new List <vlocity_ins__GroupCensusMember__c>();
			List <vlocity_ins__GroupCensusMember__c> censusMem = new List <vlocity_ins__GroupCensusMember__c>();
			censusMem = [select id,Name,ARV_External_Id__c,BNF_PKG_PLAN_PID__c,ARV_Person_Id__c from vlocity_ins__GroupCensusMember__c where vlocity_ins__CensusId__c =: censusId];
			List <vlocity_ins__GroupCensusMember__c> systemCensusMem = new List <vlocity_ins__GroupCensusMember__c>();
			systemCensusMem = [select id,Name,ARV_External_Id__c,BNF_PKG_PLAN_PID__c,ARV_Person_Id__c from vlocity_ins__GroupCensusMember__c where vlocity_ins__CensusId__c =: systemCensusID];
            if(censusMem!= null && !censusMem.isEmpty() && systemCensusMem!= null && !systemCensusMem.isEmpty()){
                if(recordType == ENROLLMENT){
                    Map <String,vlocity_ins__GroupCensusMember__c> censusIdentifier = new Map<String,vlocity_ins__GroupCensusMember__c>();
                    for(vlocity_ins__GroupCensusMember__c c : censusMem){
                        censusIdentifier.put(c.Name,c);
                    }
                    for(vlocity_ins__GroupCensusMember__c c : systemCensusMem){
                        c.ARV_External_Id__c = censusIdentifier.get(c.Name).ARV_External_Id__c;
                        c.BNF_PKG_PLAN_PID__c =  censusIdentifier.get(c.Name).BNF_PKG_PLAN_PID__c;
                        c.ARV_Person_Id__c =  censusIdentifier.get(c.Name).ARV_Person_Id__c;
                        updatedCensusMember.add(c);
                    }
                        
                }
                else if (recordType == RENEWAL){
                    for(vlocity_ins__GroupCensusMember__c cenMem : censusMem){
                        cenMem.ARV_External_Id__c = '';
                        cenMem.BNF_PKG_PLAN_PID__c = '';
                        updatedCensusMember.add(cenMem);
                    }
                    for(vlocity_ins__GroupCensusMember__c cenMem : systemCensusMem){
                        cenMem.ARV_External_Id__c = '';
                        cenMem.BNF_PKG_PLAN_PID__c = '';
                        updatedCensusMember.add(cenMem);
                    }
                }
                database.update(updatedCensusMember);
            }
        }       
		catch (Exception e) {
            system.debug('Error at Line:' + e.getLineNumber());
            system.debug('Error Message:' + e.getMessage());
        }
    }
    
/**************  
Method name : updateGWCRecords
Params     :  Id
Return Type : null
Description : this method will update the status of the Common Control GWC records
*************/  
    public static void updatedGWCRecords(List<Contract> newConts){
        List<Id> conIds = new List<Id>();
        
        for(Contract con: newConts){
            if(con.ARV_Contract_Type__c==SMALLGWC){
                if(con.ARV_Enrollment_StatusFormula__c.equals(PROCESSINGGWC)){
                	conIds.add(con.Id);
            	}
            }
        }
        
        if(conIds != null && !conIds.isEmpty()){
            List<ARV_GWC_Transaction_Table__c> gwcTTList = new List<ARV_GWC_Transaction_Table__c>();
            List<ARV_GWC_Transaction_Table__c> updatedGWC = new List<ARV_GWC_Transaction_Table__c>();
        	gwcTTList = [select Id, Status__c, Is_common_control__c from ARV_GWC_Transaction_Table__c where Is_common_control__c = true AND Status__c =:UNDERREVIEW AND RecordTypeID =: gwcTTRcrdTypId AND Contract__c IN: conIds ];
            
            if(gwcTTList != null && !gwcTTList.isEmpty()){
                for(ARV_GWC_Transaction_Table__c gwc: gwcTTList){
                    gwc.Status__c = APPROVAL;
                    updatedGWC.add(gwc);
                }
            }
            
            if(updatedGWC != null && !updatedGWC.isEmpty()){
                Database.update(updatedGWC);
            }
        }
    }
 
}