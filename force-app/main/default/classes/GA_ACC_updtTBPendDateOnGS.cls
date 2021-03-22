/*******************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_ACC_updtTBPendDateOnGS 
@CreatedDate: 30 - May 2019 
@Description: GA_ACC_updtTBPendDateOnGS class is for updating Third Party Biller History records on Group Segment.
@version : 1.0  
********************************************************************************************************************************/
public class GA_ACC_updtTBPendDateOnGS {
    public static boolean isExecuting = false;
    public static final String clsName='GA_ACC_updtTBPendDateOnGS';
    public static final String mthdupdtLinkedTPBEndDate='updtLinkedTPBEndDate';
    public static final string assocRecType = 'Account - Association';
    public static final  Id assocRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(assocRecType).getRecordTypeId();
    /*******************************************************************************************************************************
@Description  :   updtLinkedTPBEndDate 
@Name         :   updtLinkedTPBEndDate
@Param        :   list<Account> accLst,Map<Id,Account> accOldMap
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/   
    public static void updtLinkedTPBEndDate(list<Account> accLst,Map<Id,Account> accOldMap){
        try{
            Set<Id> accIds = New  Set<Id>();
            Set<Id> gsIds = New  Set<Id>();
            //Capturing Ids of records
            for(Account acc : accLst){
                
                if((acc.GA_Third_Party_Biller_Account_Id__c != accOldMap.get(acc.Id).GA_Third_Party_Biller_Account_Id__c) &&
                    (acc.GA_Third_Party_Biller_Account_Id__c == null ) ) {
                        accIds.add(acc.id);
                        if(accIds.size()>0)
                        {
                            for(GA_Group_Segment__c grpSgmnt : [select id,name,GA_Association_Id__c,GA_Third_Party_Biller_History__c from GA_Group_Segment__c where GA_Association_Id__c IN :accIds])
                            {
                                if(grpSgmnt.GA_Third_Party_Biller_History__c!=null && grpSgmnt.GA_Association_Id__c!=null)
                                {
                                    gsIds.add(grpSgmnt.GA_Third_Party_Biller_History__c);   
                                }
                            }
                        }
                    } 
            }
            system.debug('accIds-->'+accIds);
            system.debug('gsIds-->'+gsIds);
            //Updating the Third Party Biller History records.
            if(!gsIds.isEmpty()){
                List<GA_Third_Party_Biller_History__c> lstTPBH = [select id,GA_TPB_End_Date__c from GA_Third_Party_Biller_History__c where Id IN :gsIds limit 5000 ];
                
                for (GA_Third_Party_Biller_History__c tpbh :lstTPBH)
                {
                    tpbh.GA_TPB_End_Date__c=System.today();
                }
                database.update(lstTPBH);
            }
        
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, mthdupdtLinkedTPBEndDate);
        } 
    }
}