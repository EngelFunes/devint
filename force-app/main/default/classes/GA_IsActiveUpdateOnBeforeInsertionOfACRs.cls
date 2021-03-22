/*******************************************************************************************************************************
@Author             :   Dilip Junapala
@Name               :   GA_IsActiveUpdateOnBeforeInsertionOfACRs
@CreatedDate        :   19 - Apr 2018 
@Description        :   GA_IsActiveUpdateOnBeforeInsertionOfACRs is for updating Isactive as per mapped contacts active status.
@version            :   1.0  
********************************************************************************************************************************/
public without sharing class GA_IsActiveUpdateOnBeforeInsertionOfACRs {
    public static Boolean isExecuting = false;
    public static final String ErrMsg = 'Unable to update Isactive field :';
    public static final String ClsName  ='GA_IsActiveUpdateOnBeforeInsertionOfACRs';
    public static final String methodNme  ='updateIsactive';
    
    /*******************************************************************************************************************************
@Description        :   updateIsactive() method 
@Name               :   updateIsactive
@Param              :   list<AccountContactRelation> acrList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/
    public static void updateIsactive(list<AccountContactRelation> acrList)
    {
        try{	
            for(AccountContactRelation acr : acrList){
                acr.IsActive = acr.GA_Relationship_Status__c;
            }
        }
        catch (Exception e){
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            acrList[0].adderror(ErrMsg);
        }
    }
}