/*****************************************************************************************
Class Name   : ARV_AP38_FedralTaxIdController 
Date Created : 7-july-2019
Created By   : IDC Offshore
Description  :This is the class for FedralTaxIdValidation .
******************************************************************************************/
    global without sharing class ARV_AP38_FedralTaxIdController  implements vlocity_ins.VlocityOpenInterface2{
    private static final string CLSNAME  ='ARV_AP38_FedralTaxIdController';
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
    private static boolean  msgInativeType=false; 
    private static boolean approvalProcessUW=false;
    private static final string CUSTOMERTYPE='customerType'; 
    private static final string INACTIVETYPE='inactiveType';
    private static final string PROSPECTTYPE='prospectType';
    private static final string PROSPECTTYPE1='prospectType1';
    private static id  finalaccId;
    private static id  commAccId;
    private static final string ACCOUNTID='mergeaccountId' ;  
    private static final string COMACCOUNTID='commAccountId';
    private static final string APPROVALPROCESS='approvalProcessUW';
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
            throw new AuraHandledException(ERRORMSG+ARV_AP41_StringLiteralUtils.COLONVAL+e.getMessage()); }
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
        accountTaxVal(fedralTaxId,accId1);
        output.put(CUSTOMERTYPE,msgCustomerType);
        output.put(INACTIVETYPE,msgInativeType);
        output.put(PROSPECTTYPE,msgProspectType);
        output.put(PROSPECTTYPE1,msgProspectType1);
        output.put(ACCOUNTID,finalaccId);
        output.put(COMACCOUNTID,commAccId);
        output.put(APPROVALPROCESS,approvalProcessUW);
        output.put(PROSPECTCONTRACT,msgProspectContract);   
        output.put(UNQUALIFIEDPROSPECT,msgUnqualifiedProspect);
        output.put(ProspectGroupSegmentStatus,msgProspectGroupSegmentStatus);
        output.put(PROSPECTGROUPSEGMENTCOUNT,msgProspectGroupSegmentCount);
      
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
        Date reqEffDate=acclist1[0].Requested_Effective_Date__c;
        Integer monthDiff=0;
        ARV_AP07_QueryDataHelper.paramName= fedralTaxId;
        ARV_AP07_QueryDataHelper.paramName1= ARV_AP41_StringLiteralUtils.ACCOUNTCUSTOMER;
        ARV_AP07_QueryDataHelper.paramName2= ARV_AP41_StringLiteralUtils.ACCOUNTINACTIVE;
        ARV_AP07_QueryDataHelper.paramName3= ARV_AP41_StringLiteralUtils.ACCOUNTPROSPECT;
        ARV_AP07_QueryDataHelper.paramName5=ARV_AP41_StringLiteralUtils.UNQUALIFIEDPROSPECT;
        List<account> acclist =ARV_AP07_QueryDataHelper.getsObjects(ACCOUNTQUERY,ACCOUNTWHERE,NULL,NULL);
        for(Account acc:acclist){
            if(acc.RecordType.DeveloperName == ARV_AP41_StringLiteralUtils.ACCOUNTCUSTOMER){
                msgCustomerType=true;
            } else if(acc.RecordType.DeveloperName==ARV_AP41_StringLiteralUtils.ACCOUNTINACTIVE){
                msgInativeType=true;
            }
            else if(acc.RecordType.DeveloperName==ARV_AP41_StringLiteralUtils.ACCOUNTPROSPECT){
                Date reqEffective=reqEffDate;
                Date coverageCancll=acc.GA_CoverageCancellationDate__c;
                if(reqEffective!=null && coverageCancll!=null ){
                    monthDiff =coverageCancll.monthsBetween(reqEffective);
                    if(monthDiff<12){
                        msgProspectType=true;approvalProcessUW=true;
                        finalaccId=acc.Id; commAccId=acc.Id;
                    }else if(monthDiff>=12){
                        msgProspectType1=true; finalaccId=acc.Id; commAccId=acc.Id;
                    }else{}
                }else if(coverageCancll!=null){
                    Integer finalVal= validateContarctStatus(acc.Id);
                    if(finalVal>=1){ msgProspectContract=true; }
                }else if(coverageCancll==null){
                    Integer finalGSStatusCount=validateGroupSegmentStatus(acc.Id);
                    if(finalGSStatusCount>=1){ msgProspectGroupSegmentStatus=true;}
                    integer finalGSCount=validateGroupSegmentCount(acc.Id);
                    if(finalGSCount==0 && finalGSStatusCount==0){
                        finalaccId=acc.Id; commAccId=acc.Id;
                        msgProspectGroupSegmentCount=true;
                    }
                }else{}
            }else if(acc.RecordType.DeveloperName==ARV_AP41_StringLiteralUtils.UNQUALIFIEDPROSPECT){
                Integer finalVal= validateContarctStatus(acc.Id);
                if(finalVal>=1){msgUnqualifiedProspect=true;}
            }else{}
        }
        if(msgCustomerType ||msgInativeType||msgProspectContract|| msgUnqualifiedProspect){
            msgProspectGroupSegmentCount=false;msgProspectGroupSegmentStatus=false;
            msgProspectType1=false; msgProspectType=false;
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
    
   
}