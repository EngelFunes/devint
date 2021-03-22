/************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_ProductDocMapping_TriggerHandler
@CreatedDate: 29 - April 2020
@Description: ASC_ProductDocMapping_TriggerHandler class is for ASC_ProductDocMapping_Trigger
@version : 1.0  
**********************************************************************************************************************************************/
public with sharing class ASC_ProductDocMapping_TriggerHandler {
    public static final string CLSNAME  ='ASC_Product_TriggerHandler';
    public static final string METHODNME  ='beforeInsert';
    public static final string METHODNME1  ='beforeUpdate';
    
    /*******************************************************************************************************************************
@Description        :   beforeInsert() method
@Name               :   beforeInsert
@Param              :   list<Product_Document_Mapping__c> pdmList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void beforeInsert(list<Product_Document_Mapping__c> pdmList)
    {
      try
      {   
        ASC_PDM_DuplicateCheck.checkPDMRecdDuplict(pdmList,null);
      }
       catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);}
        
    }
    
    /*******************************************************************************************************************************
@Description        :   beforeUpdate() method
@Name               :   beforeUpdate
@Param              :   list<Product_Document_Mapping__c> pdmList, map<id,Product_Document_Mapping__c> pdmOldMap
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void beforeUpdate(list<Product_Document_Mapping__c> pdmList, map<id,Product_Document_Mapping__c> pdmOldMap)
    {
       try{       
        ASC_PDM_DuplicateCheck.checkPDMRecdDuplict(pdmList,pdmOldMap);
       }
       catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1);}
    }
}