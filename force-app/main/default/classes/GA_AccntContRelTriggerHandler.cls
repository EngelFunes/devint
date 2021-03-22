/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_AccntContRelTriggerHandler
@CreatedDate: 19 - Apr 2018 
@Description: GA_AccntContRelTriggerHandler class is for creating/updating AccountContactRelationship records.
@version : 1.0  
********************************************************************************************************************************/
public with sharing class GA_AccntContRelTriggerHandler {
    
    public static final String ClsName  ='GA_AccntContRelTriggerHandler';
    public static final String methodNmebeforeinsert  ='beforeinsert';
    
    /*******************************************************************************************************************************
@Description		: 	beforeinsert() method 
@Name 				: 	beforeinsert
@Param 				: 	list<AccountContactRelation> acrList
@Return 			: 	void
@throws Exception 	: 	N/A;
********************************************************************************************************************************/ 
    public static void beforeinsert(list<AccountContactRelation> acrList)
    {
        try
        {
            if(!GA_IsActiveUpdateOnBeforeInsertionOfACRs.isExecuting ){
                GA_IsActiveUpdateOnBeforeInsertionOfACRs.isExecuting = true;
                GA_IsActiveUpdateOnBeforeInsertionOfACRs.updateIsactive(acrList);
            } 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmebeforeinsert);
            
        }
    }
}