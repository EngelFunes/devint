/*****************************************************************************************
Class Name   : ARV_AP_GWCFedralTaxIdController 
Date Created : 31-dec-2020
Created By   : IDC Offshore
Description  :This is the class for FedralTaxIdValidation .
******************************************************************************************/
    global without sharing class ARV_AP_GWCFedralTaxIdController  implements vlocity_ins.VlocityOpenInterface2{
        
    private static final string CLSNAME  ='ARV_AP_GWCFedralTaxIdController';
    private static final string METHODNAME  ='invokeMethod';   
    private static final String ERRORMSG='Unable to fetch Fedral Tax Id'; 
    private static final string METHODNAME1='commonControlfedralTaxVal';
    private static final string TAXID='TaxId';
    private static final string ACCOUNTQUERY=System.label.ARV_CL34_ACCOUNTQUERY;
    private static final string ACCOUNTWHERE=' where Federal_Tax_ID__c =:paramName and '+ 
        '(RecordType.DeveloperName=:paramName1 or '+
        'RecordType.DeveloperName=:paramName2 or '+
        'RecordType.DeveloperName=:paramName3 or '+
        'RecordType.DeveloperName=:paramName5)';
     private static boolean  msgCustomerType=false;
    private static boolean  msgProspectType=false;
    private static boolean  msgProspectType1=false;
     
    private static boolean approvalProcessUW=false;
    private static final string CUSTOMERTYPE='customerType'; 
   
    private static final string PROSPECTTYPE='prospectType';
    private static final string PROSPECTTYPE1='prospectType1';
    private static final string APPROVALPROCESS='approvalProcessUW';
    private static id  finalaccId;
    private static id  commAccId;
    private static final string ACCOUNTID='mergeaccountId' ;  
    private static final string COMACCOUNTID='commAccountId';
    private static  boolean msgProspectContract=false;
    private static  boolean msgUnqualifiedProspect=false;
    private static final string CONTRACTID='ContractId';
    private static final string CONTRACTQUERY=System.label.ARV_CL46_CONTRACTQUERY;
    private static final string CONTRACTWHERE=' Where Accountid = :paramId1 and '+
        '(status=:paramName1 or status =:paramName2)';
    private static final string ACTIVATED='Activated';
    private static final string INPROGRESS='In Progress';
    private static final string PROSPECTCONTRACT='prospectContract';
    private static final string UNQUALIFIEDPROSPECT='unqualifiedProspect';
    private static final string GSQUERY='Select GA_Account__c,ARV_ContractID__c,Status__c from  GA_Group_Segment__c';
    private static final string GSWHERE=' Where  GA_Account__c =:paramId1 and ARV_ContractID__c!=null  '+
        ' and (Status__c=:paramName or  Status__c=:paramName1)';
    private static final string ACTIVE='Active';
    private static final string PENDING='Pending';
    private static final string GSWHERE1=' Where  GA_Account__c =:paramId1 and ARV_ContractID__c!=null  '+
        ' and Status__c=:paramName1';
    private static  boolean msgProspectGroupSegmentStatus=false;
    private static  boolean msgProspectGroupSegmentCount=false;
    private static final string PROSPECTGROUPSEGMENTSTATUS='prospectGroupSegmentStatus';
    private static final string PROSPECTGROUPSEGMENTCOUNT='prospectGroupSegmentCount';
    private static final string CURRENTACCID='accId';
    private static final string ACCOUNTWHERE2=' where id =:paramId1';
        private static final string COMMONCONTROL='select GA_Federal_Tax_ID_Number__c,GA_AccountId__c from  GA_Common_Control__c';
    private static final string COMMONCONTROLWhERE=' where GA_Federal_Tax_ID_Number__c=:paramName';
     private static final string COMMONCONTROLACCOUNT='commoncontrolAccount';
         private static boolean COMMONCONTROLVAR=false;
        private static string ISDUPLICATECOMMCONTROL='isduplicatecommcontrol';
     
    /**************  
Method name : invokeMethod
Params     : map
Return Type : null
Description :invokeMethod() method 
*************/
    global Object invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output,
                               Map<String,Object> options) 
    {     
        try{
            if(methodName ==METHODNAME1)
            {
                commonControlfedralTaxVal(input, output,options);
            }
        }catch(exception e){  
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME);
            system.debug('line number@@ '+e.getLineNumber());
            system.debug('getMessage @@ '+e.getMessage());
            throw new AuraHandledException(e.getMessage()); }
        return true;
    }
    
    /**************  
Method name : commonControlfedralTaxVal
Params     : map
Return Type : null
Description :commonControlfedralTaxVal() method 
*************/
    global static void commonControlfedralTaxVal(Map<String, Object> input, Map<String, Object> output,
                                                 Map<String,Object> options)
    {
        String fedralTaxId = (String)input.get(TAXID);
        string accId1=(String)input.get(CURRENTACCID);
        Account acc=[select id,name,Federal_Tax_ID__c from account where id=:accId1]; string Currentfed=acc.Federal_Tax_ID__c;
        Boolean isverified=false;if(Currentfed==fedralTaxId){isverified=true;}
        accountTaxVal(fedralTaxId,accId1);
        commonControlTaxVal(fedralTaxId);
        output.put(CUSTOMERTYPE,msgCustomerType);
        output.put(PROSPECTTYPE,msgProspectType);
        output.put(PROSPECTTYPE1,msgProspectType1);
        output.put(APPROVALPROCESS,approvalProcessUW);
        output.put(ACCOUNTID,finalaccId);
        output.put(COMACCOUNTID,commAccId);
        output.put(PROSPECTCONTRACT,msgProspectContract);   
        output.put(UNQUALIFIEDPROSPECT,msgUnqualifiedProspect);
        output.put(ProspectGroupSegmentStatus,msgProspectGroupSegmentStatus);
        output.put(PROSPECTGROUPSEGMENTCOUNT,msgProspectGroupSegmentCount);
        output.put(COMMONCONTROLACCOUNT,COMMONCONTROLVAR);
        output.put(ISDUPLICATECOMMCONTROL,isverified);
    }
    /**************  
Method name : commonControlTaxVal
Params     : string
Return Type : null
Description :commonControlfedralTaxVal() method 
*************/
    private static void accountTaxVal(string fedralTaxId,Id accId){
        ARV_AP07_QueryDataHelper.paramId1=accId;
        List<account> acclist1 =ARV_AP07_QueryDataHelper.getsObjects(ACCOUNTQUERY,ACCOUNTWHERE2,NULL,NULL);
        system.debug('acclist:'+acclist1[0].id);
        Date reqEffDate=acclist1[0].Requested_Effective_Date__c;
        Integer monthDiff=0;
        ARV_AP07_QueryDataHelper.paramName= fedralTaxId;
        ARV_AP07_QueryDataHelper.paramName1= ARV_AP41_StringLiteralUtils.ACCOUNTCUSTOMER;
        ARV_AP07_QueryDataHelper.paramName3= ARV_AP41_StringLiteralUtils.ACCOUNTPROSPECT;
        ARV_AP07_QueryDataHelper.paramName5=ARV_AP41_StringLiteralUtils.UNQUALIFIEDPROSPECT;
        List<account> acclist =ARV_AP07_QueryDataHelper.getsObjects(ACCOUNTQUERY,ACCOUNTWHERE,NULL,NULL);
        for(Account acc:acclist){
         System.debug('RecordType'+acc.RecordType.DeveloperName);
         System.debug('accountname1:'+acc.id);
            System.debug('accountname2:'+accid);
            if(acc.RecordType.DeveloperName == ARV_AP41_StringLiteralUtils.ACCOUNTCUSTOMER && acc.id!=accId){
                System.debug('accountname:'+acc.id);
                msgCustomerType=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
            }         
            else if(acc.RecordType.DeveloperName==ARV_AP41_StringLiteralUtils.ACCOUNTPROSPECT && acc.id!=accId){
                 System.debug('accountname1:'+acc.id);
                Date reqEffective=reqEffDate;
                Date coverageCancll=acc.GA_CoverageCancellationDate__c;
                if(reqEffective!=null && coverageCancll!=null){
                     System.debug('accountname2:'+acc.id);
                    System.debug('RaviEffec:'+reqEffective);
                    System.debug('RaviCancell:'+coverageCancll);
                    monthDiff =coverageCancll.monthsBetween(reqEffective);
                    System.debug('Ravidiff'+monthDiff);
                    if(monthDiff<=12){
                        msgProspectType=ARV_AP41_StringLiteralUtils.TRUE_VALUE;approvalProcessUW=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                        finalaccId=acc.Id; commAccId=acc.Id;
                         System.debug('accountname3:'+acc.id);
                    }else if(monthDiff>12){
                        msgProspectType1=ARV_AP41_StringLiteralUtils.TRUE_VALUE; finalaccId=acc.Id; commAccId=acc.Id;
                    }else{}
                }else if(coverageCancll!=null){
                    Integer finalVal= validateContarctStatus(acc.Id);
                    if(finalVal>=1){ msgProspectContract=ARV_AP41_StringLiteralUtils.TRUE_VALUE; }
                }else if(coverageCancll==null){
                    Integer finalGSStatusCount=validateGroupSegmentStatus(acc.Id);
                    if(finalGSStatusCount>=1){ msgProspectGroupSegmentStatus=ARV_AP41_StringLiteralUtils.TRUE_VALUE;}
                    integer finalGSCount=validateGroupSegmentCount(acc.Id);
                    if(finalGSCount==0 && finalGSStatusCount==0){
                        finalaccId=acc.Id; commAccId=acc.Id;
                        msgProspectGroupSegmentCount=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
                    }
                }else{}
            }else if(acc.RecordType.DeveloperName==ARV_AP41_StringLiteralUtils.UNQUALIFIEDPROSPECT){
                Integer finalVal= validateContarctStatus(acc.Id);
                if(finalVal>=1){msgUnqualifiedProspect=ARV_AP41_StringLiteralUtils.TRUE_VALUE;}
            }else{}
        }
        if(msgCustomerType ||msgProspectContract|| msgUnqualifiedProspect){
            msgProspectGroupSegmentCount=ARV_AP41_StringLiteralUtils.FALSE_VALUE;msgProspectGroupSegmentStatus=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
            msgProspectType1=ARV_AP41_StringLiteralUtils.FALSE_VALUE; msgProspectType=ARV_AP41_StringLiteralUtils.FALSE_VALUE;
        }
    }
    
    /**************  
Method name : validateContarctStatus
Params     : string
Return Type : null
Description :validateContarctStatus() method 
*************/
    private static integer validateContarctStatus(Id accId){
        ARV_AP07_QueryDataHelper.paramId1=accId ;
        ARV_AP07_QueryDataHelper.paramName1=ACTIVATED ;
        ARV_AP07_QueryDataHelper.paramName2=INPROGRESS;
        list<contract> contractList=ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQUERY,
                                                                         CONTRACTWHERE,NULL,NULL);
        integer finalCount=contractList.size();
        return finalCount;
    }
    /**************  
Method name : validateGroupSegmentStatus
Params     : string
Return Type : null
Description :validateGroupSegmentStatus() method 
*************/
    private static integer validateGroupSegmentStatus(Id accId){
        ARV_AP07_QueryDataHelper.paramId1=accId ;
        ARV_AP07_QueryDataHelper.paramName=ACTIVE ;
        ARV_AP07_QueryDataHelper.paramName1=PENDING;
        list<GA_Group_Segment__c> gsList=ARV_AP07_QueryDataHelper.getsObjects(GSQUERY,GSWHERE,null,NULL);
        integer finalCount=gsList.size();
        return finalCount;
    }
    /**************  
Method name : validateGroupSegmentCount
Params     : string
Return Type : null
Description :validateGroupSegmentCount() method 
*************/
    private static integer validateGroupSegmentCount(Id accId){
        ARV_AP07_QueryDataHelper.paramId1=accId ;
        ARV_AP07_QueryDataHelper.paramName1=PENDING;
         list<GA_Group_Segment__c> gsList=ARV_AP07_QueryDataHelper.getsObjects(GSQUERY,GSWHERE1,null,NULL);
        integer finalCount=gsList.size();
        return finalCount;
    }
    private static void commonControlTaxVal(string fedralTaxId){
        ARV_AP07_QueryDataHelper.paramName= fedralTaxId;
        List<GA_Common_Control__c> commonControlList =ARV_AP07_QueryDataHelper.getsObjects(COMMONCONTROL,COMMONCONTROLWhERE,NULL,NULL);
        if(!commonControlList.isEmpty()){
            COMMONCONTROLVAR=ARV_AP41_StringLiteralUtils.TRUE_VALUE;
        }
    
    }
   
}