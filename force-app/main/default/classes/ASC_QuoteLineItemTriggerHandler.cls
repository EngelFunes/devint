/*******************************************************************************************************************************
@Author : Asc Team
@Name: ASC_QuoteLineItemTriggerHandler
@CreatedDate: 24 - Sep 2020 
@Description: ASC_QuoteLineItemTriggerHandlerclass is for QuotelineItem object.
@version : 1.0  
********************************************************************************************************************************/     
public with sharing class ASC_QuoteLineItemTriggerHandler{
public static final string CLSNAME  ='ASC_QuoteLineItemTriggerHandler';

public static final string METHODNMEBEFOREDELETE  ='beforeDelete';  

 public static final string QUOTE  ='Quote';    
/*******************************************************************************************************************************
@Description        :  beforeDelete() method 
@Name               :   beforeDelete
@Param              :   map<id,Quote> qliOldMap
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
public static void beforeDelete( list<QuoteLineItem> qliOld)
{
    try{  
        ASC_DeleteLineItemExt.deleteLineitemExt(qliOld);

      
    }
    catch(exception e){ GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEBEFOREDELETE  );}
    
}
}