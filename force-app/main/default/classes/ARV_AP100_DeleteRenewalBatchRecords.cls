/*****************************************************************************************
Class Name   : ARV_AP100_DeleteRenewalBatchRecords. 
Date Created : 19-June-2020
Created By   : IDC Offshore
Description  : This is the class for deleting Renewal batch log records...
******************************************************************************************/
public class ARV_AP100_DeleteRenewalBatchRecords {
    private static final string SUCCCOMPLETEDMESSAGE='Contract Renewal Completed';
    private static final string CLSNAME='ARV_AP100_DeleteRenewalBatchRecords';
    private static final string CLS_METHODNAME='deletelogRecords';
    private static final string FAILEDSTATUS='Failed';
    private static final string CONTRACTERROR='Contract Error';
    private static final string QUOTECHARS=Quote.sobjecttype.getDescribe().getKeyPrefix();
    private static final string CENSUSCHARS=vlocity_ins__GroupCensus__c.sobjecttype.getDescribe().getKeyPrefix();
    private static final string OPPCHARS=Opportunity.sobjecttype.getDescribe().getKeyPrefix();
    private static final string CONTCHARS=Contract.sobjecttype.getDescribe().getKeyPrefix();
    private static final string RBLQUERY='select id, ARV_Contract_Id__c, CreatedDate_ContractId_StepName__c, ARV_Error_Code__c,'+
        'ARV_Renewal_Record_Id__c,ARV_Renewal_Step_Status__c, ARV_Status_Message__c from ARV_Renewal_Batch_Log__c';
    private static final string RBLWHERE=' Where ARV_Contract_Id__c in:paramId2';
    private static final string RBLFAILWHERE=' Where ARV_Contract_Id__c in:products';
    private static final String LIMIT_QRY=' limit 100';
    private static final string ERRMESSAGE='Error - Pre-validation';
    private static String failMessage='';
    private static String failedMessage;
    //Private static String errorMessage;
    /********************************************************************************************
    Constructor Name   : ARV_AP100_DeleteRenewalBatchRecords.    
    Description  : This constructor is used to initiation of Variables.
    **************************************************************************/
    public ARV_AP100_DeleteRenewalBatchRecords (string failMessage ){
        failedMessage=failMessage;
        }
    
/*****************************************************************************************
Method Name   : deletelogRecords. 
Date Created : 30-DEC-2019
Created By   : IDC Offshore
Description  : This is the method delet Success logs of Renewal Batch Log Record.
**********************************************************************************************/   
    public static void deletelogRecords(List<ARV_Renewal_Batch_Log__c> rblList){
        try{
            List<contract> updatefailcon =New List<contract>();
            set<id> successRecid = new set<id>();
            set<id> failedId=new set<id>();
            map<id,ARV_Renewal_Batch_Log__c> rbmap=new map<id,ARV_Renewal_Batch_Log__c>();
            map<id,ARV_Renewal_Batch_Log__c> rbmap1=new map<id,ARV_Renewal_Batch_Log__c>();
            for(ARV_Renewal_Batch_Log__c rb:rblList){
                if(rb.ARV_Status_Message__c==SUCCCOMPLETEDMESSAGE){
                    rbmap.put(rb.ARV_Contract_Id__c,rb);
                }
            }
            for(ARV_Renewal_Batch_Log__c rb:rblList){
                if(rb.ARV_Renewal_Step_Status__c==FAILEDSTATUS){
                    failedMessage=rb.ARV_Status_Message__c;
                    rbmap1.put(rb.ARV_Contract_Id__c,rb);
                }
            }
            for(ARV_Renewal_Batch_Log__c rbl:rblList){
                if(rbmap.containskey(rbl.ARV_Contract_Id__c)){
                    successRecid.add(rbl.ARV_Contract_Id__c);
                }
            }
            for(ARV_Renewal_Batch_Log__c rbl:rblList){
                if(rbmap1.containskey(rbl.ARV_Contract_Id__c)){
                    failedId.add(rbl.ARV_Contract_Id__c);
                    Contract contrct =new Contract(id=rbl.ARV_Contract_Id__c,ARV_Renewal_Error__c=CONTRACTERROR,
                                                 ARV_Renewal_Error_Message__c = failedMessage,ARV_Renewal_Creation_Status__c=ERRMESSAGE);
                    updatefailcon.add(contrct);
                  }
            }
            if(updatefailcon.size()>0){
            database.update(updatefailcon);
            }
            ARV_AP07_QueryDataHelper.paramId2= successRecid;
            ARV_AP07_QueryDataHelper.products= failedId;
            List<ARV_Renewal_Batch_Log__c> succdelList=ARV_AP07_QueryDataHelper.getsObjects(RBLQUERY,
                                                                               RBLWHERE,NULL,LIMIT_QRY);
            if(succdelList!=null){
            database.delete(succdelList);
            }
            List<ARV_Renewal_Batch_Log__c> failedblogList=ARV_AP07_QueryDataHelper.getsObjects(RBLQUERY,
                                                                              RBLFAILWHERE,NULL,LIMIT_QRY);
            
			if(failedblogList.size()>0){
                deletefailedRelatedRecords(failedblogList);
            }
         }  
        catch(Exception e) {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, CLS_METHODNAME);
        }
    }
/*****************************************************************************************
Method Name   : deletefailedRelatedRecords. 
Date Created : 30-DEC-2019
Created By   : IDC Offshore
Description  : This is the method is called from deletelogRecords.
**********************************************************************************************/ 
private static void deletefailedRelatedRecords(List<ARV_Renewal_Batch_Log__c> failrblogList){
            set<id> rblogId=new set<id>();
            List<Quote> qlist=new List<Quote>();
            List<vlocity_ins__GroupCensus__c> cenlist=new List<vlocity_ins__GroupCensus__c>();
            List<Opportunity> opplist=new List<Opportunity>();
            List<Contract> colist=new List<Contract>();
                for(ARV_Renewal_Batch_Log__c rblog:failrblogList){
                if(rblog.ARV_Renewal_Record_Id__c!=null){
                    rblogId.add(rblog.ARV_Renewal_Record_Id__c);
                }
            }
            if(rblogId!=null){
                for(string rbid:rblogId){
                    if(rbid.startsWith(QUOTECHARS)){
                    Quote qte =New Quote(Id=rbid);
                     qlist.add(qte);
                    }
                    else if(rbid.startsWith(CENSUSCHARS)){
                    vlocity_ins__GroupCensus__c cns= new vlocity_ins__GroupCensus__c(Id=rbid);
                        cenlist.add(cns);
                    }
                    else if(rbid.startsWith(OPPCHARS)){
                    Opportunity opp = new Opportunity(Id=rbid);
                        opplist.add(opp);
                    }
                    else if(rbid.startsWith(CONTCHARS)){
                    Contract cont = new contract(Id=rbid);
                        colist.add(cont);
                    }
                    else{}
                }
                
            }
            if(colist.size()>0){database.delete(colist);}
            if(qlist.size()>0){database.delete(qlist);}
            if(cenlist.size()>0){database.delete(cenlist);}
            if(opplist.size()>0){database.delete(opplist);}
    }

}