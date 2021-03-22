/**
@Author : Raj Jena
@Name: ASC_Product_TriggerHandler
@CreatedDate: 27 - Feb 2020 
@Description: ASC_Product_TriggerHandler class is for Product object.
@version : 1.0  
*/
public with sharing class ASC_Product_TriggerHandler {
    public static final string CLSNAME  ='ASC_Product_TriggerHandler';
    public static final string METHODNME  ='beforeInsert';
    public static final string AUTOGENERATEPRODUCTCODE = System.Label.ASC_AutoGenerate_ProductCode;
    public static final string TRUEVAL  ='True';
    /*******************************************************************************************************************************
@Description        :   beforeInsert() method 
@Name               :   beforeInsert
@Param              :   list<Product2> prodList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void beforeInsert(list<Product2> prodList)
    {
        try{  
            if(AUTOGENERATEPRODUCTCODE.equalsIgnoreCase(TRUEVAL)){
                if(prodList.size()>0){
                ASC_Product_NamingConvention.updtProductCode(prodList);                
            } 
            }                       
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    }
}