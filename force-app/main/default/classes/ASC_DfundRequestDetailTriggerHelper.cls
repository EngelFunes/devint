/************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_DfundRequestDetailTriggerHelper
@CreatedDate: 2-23-2020
@Description: ASC_DfundRequestDetailTriggerHelper is to handle Request from ASC_DfundRequestDetailTriggerHandler.
@User Story- #4514
@version : 1.0  
**********************************************************************************************************************************************/
public class ASC_DfundRequestDetailTriggerHelper {  
    
    public static final string CLASSNAME  ='ASC_DfundRequestDetailTriggerHelper';
    public static final string METHODNME  ='editStatusField';
    private static final String Status_Rejected = 'Rejected';
    private static final String Status_New = 'New';
    private static final String Status_Draft = 'Draft';
    private static final String DfunRequest = 'Dfund_Request__c';
    private static final String Status_Finance ='Finance Review';
    private static final String Status_Complete ='Completed';
    private static final String Status_Canceled ='Canceled';
    private static final String Status_Underwriting ='Underwriting Review';
    private static final String Status_Sales ='Sales_Review';
    public static final Id ASC_SHARED_RECTYPEID = 
        Schema.SObjectType.Dfund_Request_Detail__c.getRecordTypeInfosByName().get('ASC Shared Savings Dfund Info').getRecordTypeId();
    public static final string ERROR_MSG='This Dfund Request is related to an approved Quote please make ASC Dfund changes directly on the related Quote.';
    
    static Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Dfund_Request_Detail__c.fields.getMap();
    
    /**************************************************************************************************************
@Description        :  Status field updates on dfund request object to draft when any field is updated on dfund request detail object.
@Name               :   editStatusField
@Param              :   List<Dfund_Request_Detail__c> DfundMap, Map<Id, Dfund_Request_Detail__c> oldMap
@Return             :   void
@throws Exception   :   N/A;
**************************************************************************************************************/     
    public static void editStatusField(List<Dfund_Request_Detail__c> DfundMap, Map<Id, Dfund_Request_Detail__c> oldMap){
        
        
        List<Dfund_Request_Detail__c> lstUpdateDfund = new List<Dfund_Request_Detail__c>();
        
        Map<Id,Dfund_Request__c> listOfDfundrecordsToUpdate = new Map<Id,Dfund_Request__c>();
        Dfund_Request__c dfundReq = new Dfund_Request__c();
        
        try {
            for(Dfund_Request_Detail__c lstDfund : DfundMap){  
                if(lstDfund.DfundRequestStatus__c == Status_Rejected|| lstDfund.DfundRequestStatus__c == Status_New )
                    for (String fieldName: schemaFieldMap.keySet()) {               
                        if(lstDfund.get(fieldName) != oldMap.get(lstDfund.Id).get(fieldName) && lstDfund.get(DfunRequest) !=null){                  
                            dfundReq.Id = String.ValueOf(lstDfund.get(DfunRequest));
                            dfundReq.Status__c = Status_Draft;
                            listOfDfundrecordsToUpdate.put(dfundReq.Id,dfundReq);
                            
                        }
                    }          
            }
            if(listOfDfundrecordsToUpdate !=null && !listOfDfundrecordsToUpdate.isEmpty()){
                Update listOfDfundrecordsToUpdate.Values();
            }
            
            
            
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNME);}                  
    } 
    /**************************************************************************************************************
@Description        :  When quote is related to dfund request the related dfund request detail should not be edited for dfund status sales review,underwriting review,
Finance review,completed,Cancelled.
@Name               :   editField
@Param              :   List<Dfund_Request_Detail__c> DfundMap, Map<Id, Dfund_Request_Detail__c> oldMap
@Return             :   void
@throws Exception   :   N/A;
@US                 :4536
**************************************************************************************************************/  
    public static void editField(List<Dfund_Request_Detail__c> DfundLst,Map<Id, Dfund_Request_Detail__c> oldMap){
        
        List<Dfund_Request_Detail__c> lstUpdate=[select id,name,Dfund_Request__c,Current_Fee__c from Dfund_Request_Detail__c where Dfund_Request__c!=null And id in:DfundLst
                                                 Limit :UTIL_SLB.retrieveQueryLimitValue()];
        list<Dfund_Request__c> dfundReq = new list<Dfund_Request__c>();
        List<quote> qutLst=[select id,name,Dfund_Request__c from quote where Dfund_Request__c!=null
                            Limit :UTIL_SLB.retrieveQueryLimitValue()];
        for(Dfund_Request_Detail__c lstDfund : DfundLst){
            for(quote qutlstid :qutLst ){
                
                if(lstDfund.Dfund_Request__c==qutlstid.Dfund_Request__c && lstDfund.RecordTypeId != ASC_SHARED_RECTYPEID )
                {
                    
                    if(lstDfund.Current_Fee__c != oldMap.get(lstDfund.Id).Current_Fee__c || lstDfund.Pricing_Method__c !=oldMap.get(lstDfund.Id).Pricing_Method__c ||
                       lstDfund.Estimated_Contracts__c !=oldMap.get(lstDfund.Id).Estimated_Contracts__c || lstDfund.Standard_Fee__c !=oldMap.get(lstDfund.Id).Standard_Fee__c
                       || lstDfund.Requested_Fee__c!=oldMap.get(lstDfund.Id).Requested_Fee__c || lstDfund.Access_Fee__c!=oldMap.get(lstDfund.Id).Access_Fee__c
                       ||lstDfund.Flat_Amount__c!=oldMap.get(lstDfund.Id).Flat_Amount__c ||lstDfund.Minimum__c!=oldMap.get(lstDfund.Id).Minimum__c ||
                       lstDfund.Monthly_Cap_Amount__c!=oldMap.get(lstDfund.Id).Monthly_Cap_Amount__c ||lstDfund.Original_Minimum__c!=oldMap.get(lstDfund.Id).Original_Minimum__c 
                       || lstDfund.Original_Monthly_Cap_Amount__c!=oldMap.get(lstDfund.Id).Original_Monthly_Cap_Amount__c
                       ||lstDfund.Type_of_Credit__c!=oldMap.get(lstDfund.Id).Type_of_Credit__c || lstDfund.Product__c!=oldMap.get(lstDfund.Id).Product__c)
                    {
                        
                        lstDfund.adderror(ERROR_MSG);
                    }
                }
                
                if(lstDfund.Dfund_Request__c==qutlstid.Dfund_Request__c && lstDfund.RecordTypeId == ASC_SHARED_RECTYPEID)
                {
                    if(lstDfund.Carrier_Retention_Percentage__c != oldMap.get(lstDfund.Id).Carrier_Retention_Percentage__c || 
                       lstDfund.Original_Retention__c != oldMap.get(lstDfund.Id).Original_Retention__c ||lstDfund.Product__c!=oldMap.get(lstDfund.Id).Product__c)
                    {
                        lstDfund.adderror(ERROR_MSG);  
                    }
                }
                if(lstDfund.DfundRequestStatus__c == Status_Finance || lstDfund.DfundRequestStatus__c == Status_Complete || lstDfund.DfundRequestStatus__c == Status_Canceled
                   || lstDfund.DfundRequestStatus__c == Status_Underwriting || lstDfund.DfundRequestStatus__c == Status_Sales){
                       if(lstDfund.Dfund_Request__c==qutlstid.Dfund_Request__c && lstDfund.RecordTypeId == ASC_SHARED_RECTYPEID){
                           if(lstDfund.Flat_Amount__c!=oldMap.get(lstDfund.Id).Flat_Amount__c){
                               
                               
                               lstDfund.adderror(ERROR_MSG);
                           }
                       }
                   }
            }
            
        }
    }
}