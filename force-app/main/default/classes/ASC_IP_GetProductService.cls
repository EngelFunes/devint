/**
@Author : Dinesh/Harsha
@Name: ASC_IP_GetProductService
@CreatedDate:  03-24-2020 
@Description: ASC_IP_GetProductService class is able to get the information from the method 'getRatedProduct' from the vlocity interface and send the updated response back to the templates for create/update quotes.
@version : 1.0  

---Modified --
@US-3253(R3) - Sequencing Products on Product Selection Screen , Added the condition on setProductSelectiondata method.
TD-1020 Added By Dinesh - Included the parent product code to avoid duplicate selection when same coverage spec was included under more than one parent product
*/
global without sharing class ASC_IP_GetProductService implements vlocity_ins.VlocityOpenInterface2 {

    private static final string CLASSNAME  ='ASC_IP_GetProductService';
    private static final String PRODUCT_CODE = 'ProductCode';
    private static final String CHILD_PRODUCTS = 'childProducts';
    private static final String RECORDS = 'records';
    private static final String SETPRODUCTOFFERINGS = 'setProductOfferings';
    private static final String SETPRODUCTSELECTIONDATA = 'setProductSelectiondata';
    private static final String GETISSELECTEDPRODUCTS = 'getIsSelectedProductsdata';
    private static final String GETMERGESELECTEDPRODUCTS = 'getMergeSelectedProducts';
    private static final String PRODCONFIGURATIONRESPONSE = 'prodConfigResponse';
    private static final String DELETEUNSELECTEDPLANS = 'deleteUnselectedPlans';    
    private static final String ROOT_NODE = 'root';
    private static final String QUOTE_DETAIL1 = 'QuoteDetail1';
    private static final String ISSELECTED = 'isSelected';
    private static final String FIRSTSET = 'firstSet';
    private static final String SECONDSET = 'secondSet';
    private static final String MERGEPRODUCTS = 'mergedProducts';
    private static final String FINALRECORDS = 'finalrecords';
    private static final String UNSELECTEDPLANS = 'unSelectedPlans';
    private static final String DESELECTEDCHILDPLANS = 'deSelectedChildPlans';
    private static final String RECORDSMERGESET = 'records123'; 
    private static final String RECORDS12 = 'records12'; 
    private static final String QUOTID = 'ContextId'; 
    private static final string ASC_PRODTYPE  ='ASC Product';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final string RECTYPENAME  ='Product';
    private static final string STR_EMPTY  = '';
    private static final string STR_COMMA = ',';
    private static final string STR_ID = 'Id:';
    private static final string STRID = 'Id';
    private static final String CONFIGUREPRODUCT1 = 'ConfigureProduct1';
    private static final String CONFIGUREPRODUCT2 = 'ConfigureProduct2';
    private static final String CONFIGUREPRODUCT3 = 'ConfigureProduct3';
    private static final String CONFIGUREPRODUCT4 = 'ConfigureProduct4';
    private static final String CONFIGUREPRODUCT5 = 'ConfigureProduct5';
    private static final String CONFIGUREPRODUCT6 = 'ConfigureProduct6';
    private static final String CONFIGUREPRODUCT7 = 'ConfigureProduct7';
    private static final String CONFIGUREPRODUCT8 = 'ConfigureProduct8';
    private static final String CONFIGUREPRODUCT9 = 'ConfigureProduct9';
    private static final String CONFIGUREPRODUCT10 = 'ConfigureProduct10';
    private static final String CONFIGUREPRODUCT11 = 'ConfigureProduct11';
    private static final String CONFIGUREPRODUCT12 = 'ConfigureProduct12';
    private static final String CONFIGUREPRODUCT13 = 'ConfigureProduct13';
    private static final String CONFIGUREPRODUCT14 = 'ConfigureProduct14';
    private static final String CONFIGUREPRODUCT15 = 'ConfigureProduct15';
    private static final String CONFIGUREPRODUCT16 = 'ConfigureProduct16';
    private static final String CONFIGUREPRODUCT17 = 'ConfigureProduct17';
    private static final String CONFIGUREPRODUCT18 = 'ConfigureProduct18';
    private static final String CONFIGUREPRODUCT19 = 'ConfigureProduct19';
    private static final String CONFIGUREPRODUCT20 = 'ConfigureProduct20';
    private static final String CONFIGUREPRODUCT21 = 'ConfigureProduct21';
    private static final String CONFIGUREPRODUCT22 = 'ConfigureProduct22';
    private static final String CONFIGUREPRODUCT23 = 'ConfigureProduct23';
    private static final String CONFIGUREPRODUCT24 = 'ConfigureProduct24';
    private static final String CONFIGUREPRODUCT25 = 'ConfigureProduct25';
    private static final String CONFIGUREPRODUCT26 = 'ConfigureProduct26';
    private static final String CONFIGUREPRODUCT27 = 'ConfigureProduct27';
    private static final String CONFIGUREPRODUCT28 = 'ConfigureProduct28';
    private static final String CONFIGUREPRODUCT29 = 'ConfigureProduct29';
    private static final String CONFIGUREPRODUCT30 = 'ConfigureProduct30';  
    private static final String CONFIGURESELECTEDPRODUCT1 = 'ConfigureSelectedProduct1';
    private static final String CONFIGURESELECTEDPRODUCT2 = 'ConfigureSelectedProduct2';
    private static final String CONFIGURESELECTEDPRODUCT3 = 'ConfigureSelectedProduct3';
    private static final String CONFIGURESELECTEDPRODUCT4 = 'ConfigureSelectedProduct4';
    private static final String CONFIGURESELECTEDPRODUCT5 = 'ConfigureSelectedProduct5';
    private static final String CONFIGURESELECTEDPRODUCT6 = 'ConfigureSelectedProduct6';
    private static final String CONFIGURESELECTEDPRODUCT7 = 'ConfigureSelectedProduct7';
    private static final String CONFIGURESELECTEDPRODUCT8 = 'ConfigureSelectedProduct8';
    private static final String CONFIGURESELECTEDPRODUCT9 = 'ConfigureSelectedProduct9';
    private static final String CONFIGURESELECTEDPRODUCT10 = 'ConfigureSelectedProduct10';
    private static final String CONFIGURESELECTEDPRODUCT11 = 'ConfigureSelectedProduct11';
    private static final String CONFIGURESELECTEDPRODUCT12 = 'ConfigureSelectedProduct12';
    private static final String CONFIGURESELECTEDPRODUCT13 = 'ConfigureSelectedProduct13';
    private static final String CONFIGURESELECTEDPRODUCT14 = 'ConfigureSelectedProduct14';
    private static final String CONFIGURESELECTEDPRODUCT15 = 'ConfigureSelectedProduct15';
    private static final String CONFIGURESELECTEDPRODUCT16 = 'ConfigureSelectedProduct16';
    private static final String CONFIGURESELECTEDPRODUCT17 = 'ConfigureSelectedProduct17';
    private static final String CONFIGURESELECTEDPRODUCT18 = 'ConfigureSelectedProduct18';
    private static final String CONFIGURESELECTEDPRODUCT19 = 'ConfigureSelectedProduct19';
    private static final String CONFIGURESELECTEDPRODUCT20 = 'ConfigureSelectedProduct20';
    private static final String CONFIGURESELECTEDPRODUCT21 = 'ConfigureSelectedProduct21';
    private static final String CONFIGURESELECTEDPRODUCT22 = 'ConfigureSelectedProduct22';
    private static final String CONFIGURESELECTEDPRODUCT23 = 'ConfigureSelectedProduct23';
    private static final String CONFIGURESELECTEDPRODUCT24 = 'ConfigureSelectedProduct24';
    private static final String CONFIGURESELECTEDPRODUCT25 = 'ConfigureSelectedProduct25';
    private static final String CONFIGURESELECTEDPRODUCT26 = 'ConfigureSelectedProduct26';
    private static final String CONFIGURESELECTEDPRODUCT27 = 'ConfigureSelectedProduct27';
    private static final String CONFIGURESELECTEDPRODUCT28 = 'ConfigureSelectedProduct28';
    private static final String CONFIGURESELECTEDPRODUCT29 = 'ConfigureSelectedProduct29';
    private static final String CONFIGURESELECTEDPRODUCT30 = 'ConfigureSelectedProduct30';
    private static final String SETFLAG1 = 'setflag1';
    private static final String SETFLAG2 = 'setflag2';
    private static final String SETFLAG3 = 'setflag3';
    private static final String SETFLAG4 = 'setflag4';
    private static final String SETFLAG5 = 'setflag5';
    private static final String SETFLAG6 = 'setflag6';
    private static final String SETFLAG7 = 'setflag7';
    private static final String SETFLAG8 = 'setflag8';
    private static final String SETFLAG9 = 'setflag9';
    private static final String SETFLAG10 = 'setflag10';
    private static final String SETFLAG11 = 'setflag11';
    private static final String SETFLAG12 = 'setflag12';
    private static final String SETFLAG13 = 'setflag13';                                            
    private static final String SETFLAG14 = 'setflag14';
    private static final String SETFLAG15 = 'setflag15';
    private static final String SETFLAG16 = 'setflag16';    
    private static final String SETFLAG17 = 'setflag17';
    private static final String SETFLAG18 = 'setflag18';
    private static final String SETFLAG19 = 'setflag19';
    private static final String SETFLAG20 = 'setflag20';
    private static final String SETFLAG21 = 'setflag21';
    private static final String SETFLAG22 = 'setflag22';
    private static final String SETFLAG23 = 'setflag23';
    private static final String SETFLAG24 = 'setflag24';
    private static final String SETFLAG25 = 'setflag25';    
    private static final String SETFLAG26 = 'setflag26';
    private static final String SETFLAG27 = 'setflag27';
    private static final String SETFLAG28 = 'setflag28';
    private static final String SETFLAG29 = 'setflag29';
    private static final String SETFLAG30 = 'setflag30';
    private static final String PRODIDSET = 'productIdSet'; 
    private static final String ERROR_OUT = 'error';
    private static final string CONTXID = 'ContextId';

    public static final Set<String> productCodeUpdatedSet = new Set<String>();    
    public static final String ERROR_MSG_PRODUCTSSELECTION =  'Please select at least one product from Product Offering or Product Selection step before proceeding further.';
    public static final String RECTYPE_COVERAGESPEC = 'Coverage Spec';
    private static final Set<String> FAMILYVALSET = new Set<String>{
         'Medical','Vision','Dental','Specialty','Medicare Advantage','Drugs','BCN Medical','Hearing','MM','Medicare Supplement','CDH','Data Feeds','Admin Fees','Shared Savings','Stop-Loss','Misc Fees and Credits','Rx Add-On Services & Programs','Terms Conditions and Disclosures','Buy Ups'
       ,'Carve-Outs','Processing Options' }; 
    private static final String UNDERSCORE = '_';
    public static string effDate;
    public static string endDate;

    /********************************************************************************************************************
    @Description        :   This method is used to invoke the methods which are available to this context.                            
    @Name               :   invokeMethod
    @Param              :   String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options
    @Return             :   Object
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/
    global Object invokeMethod(String methodName, Map<String,Object> input, 
                               Map<String,Object> output, Map<String,Object> options) 
    {           
        try{
            if(PRODCONFIGURATIONRESPONSE.equals(methodName)){
                return prodConfigResponse(input,output);
            } 
        }
        catch(exception e){   
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, PRODCONFIGURATIONRESPONSE);
        }        
        try{
            if(DELETEUNSELECTEDPLANS.equals(methodName)){
                return deleteUnselectedPlans(input,output);     
            }
        }
        catch(exception e){   
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, DELETEUNSELECTEDPLANS);
        }
        try{
            if(SETPRODUCTSELECTIONDATA.equals(methodName)){
                return setProductSelectiondata(input,output);     
            }
        }
        catch(exception e){   
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, SETPRODUCTSELECTIONDATA);
        }
        try{
            if(GETISSELECTEDPRODUCTS.equals(methodName)){
                return getIsSelectedProductsdata(input,output);     
            }
        }
        catch(exception e){   
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, GETISSELECTEDPRODUCTS);
        }
        try{
            if(GETMERGESELECTEDPRODUCTS.equals(methodName)){
                return getMergeSelectedProducts(input,output);     
            }  
        }      
        catch(exception e){   
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, GETMERGESELECTEDPRODUCTS);
        }
        try{
            if('updateDatesForQLI'.equals(methodName)){
                return updateDatesForQLI(input,output);     
            }  
        }      
        catch(exception e){   
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, 'updateDatesForQLI');
        }
        
        return true;
    }
        
    /********************************************************************************************************************
    @Description        :   This method is used to set the data in the Product Selection page for create quote
    @Name               :   setProductSelectiondata
    @Param              :   Map<String, Object> input, Map<String, Object> output
    @Return             :   Boolean
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/        
    global static Boolean setProductSelectiondata(Map<String, Object> input, 
                                                  Map<String, Object> output)
    {        
        List<Product2> prdresultList = [Select Id,Name,Productcode from Product2 
                                         where Family IN:FAMILYVALSET 
                                         and RecordType.Name =: RECTYPENAME
                                         and vlocity_ins__LineOfBusiness__c =: PRD_LOB
                                         and vlocity_ins__SubType__c =: ASC_PRODTYPE
                                         and vlocity_ins__Type__c =: ASC_PRODTYPE
                                         and IsActive = true Order by ASC_Product_Sequence__c ASC 
                                         Limit :UTIL_SLB.retrieveQueryLimitValue()];
        if(!prdresultList.isEmpty()){
          output.put(RECORDS,prdresultList);
        }
        return true;
    }
    /********************************************************************************************************************
    @Description        :   This method is used to pass the selected Products ID's to the getRatedProduct method to fetch the data -  Create Quote/Edit Quote
    @Name               :   getIsSelectedProductsdata
    @Param              :   Map<String, Object> input, Map<String, Object> output
    @Return             :   Boolean
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/        
    global static Boolean getIsSelectedProductsdata(Map<String, Object> input,
                                                    Map<String, Object> output)
    {           
      
        List<Object> mergeProductsList = new List<Object>();  
        Map<String,Object> recordAttributes = new Map<String,Object>();                        
        String prdStr = STR_EMPTY;  
        String prdStrSet = STR_EMPTY;    
        
        if(input.get(FIRSTSET) !=null){
          List<Object> getProductOfferings = (List<Object>)input.get(FIRSTSET);
          mergeProductsList.addAll(getProductOfferings);
        }
        if(input.get(SECONDSET)!=null){
          List<Object> getProductSelection  = (List<Object>)input.get(SECONDSET); 
          mergeProductsList.addAll(getProductSelection);
        }     
            
        if(!mergeProductsList.isEmpty()){    
            for(Object recordItem :mergeProductsList){
              recordAttributes = (Map<String,Object>)recordItem; 
              if(recordAttributes.get(ISSELECTED) == true){           
                    prdStr += STR_ID+recordAttributes.get(STRID)+STR_COMMA;
                    prdStrSet = prdStr.removeEnd(STR_COMMA);
              }       
             }             
         }
        if(!String.isBlank(prdStrSet)){
          output.put(PRODIDSET,prdStrSet);       
        }        
        else{
          output.put(ERROR_OUT,ERROR_MSG_PRODUCTSSELECTION);
        }         
        return true;        
    }
    /********************************************************************************************************************
    @Description        :   This method is used to merge the selected Products in the back and forth product configuration screens.
    @Name               :   getMergeSelectedProducts
    @Param              :   Map<String, Object> input, Map<String, Object> output
    @Return             :   Boolean
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/        
    global static Boolean getMergeSelectedProducts(Map<String, Object> input,
                                                   Map<String, Object> output)
    {  
        Set<String> productCodeSet = new Set<String>();         
        List<Object> mergeSetAll = new  List<Object>();
        List<Object> mergeFinalList = new  List<Object>();
        List<Object> addAllSelectedProducts = new List<Object>();
        Map<String,Object> recordAttributes = new Map<String,Object>();
        List<Map<String,Object>> prdMapIsSelected = new List<Map<String,Object>>();
        List<Map<String,Object>> prdMapIsSelectedUpdated = new List<Map<String,Object>>();
        List<Map<String,Object>> childPrdMapIsSelected = new List<Map<String,Object>>();
        Map<String,Object> childProdMap = new Map<String,Object>();
        List<Object> childProduct = new List<Object>();        
        Set<String> prdSetIsSelected = new Set<String>();   
        String qtID = STR_EMPTY;
        if(input.get(CONTXID) !=null){
          qtID = (string)input.get(CONTXID);
        }
        list<quotelineitem> qLIList = [select Product2id,Product2.ProductCode,
                                       vlocity_ins__ParentItemId2__c,vlocity_ins__ParentItemId2__r.ASC_Product_Code__c
                                       from quotelineitem
                                       where quoteid = :qtID
                                       AND Product2.RecordType.Name =:RECTYPE_COVERAGESPEC
                                       Limit :UTIL_SLB.retrieveQueryLimitValue()];
        if(!qLIList.isEmpty()){
            for(quotelineitem qtli : qLIList){
                prdSetIsSelected.add(qtli.vlocity_ins__ParentItemId2__r.ASC_Product_Code__c+UNDERSCORE+qtli.Product2.ProductCode);//TD-1020 Added By Dinesh - updated to include parentcode in Set
            }                   
        }
                        
        if(input.get(CONFIGUREPRODUCT1) !=null){
            Map<String,Object> rootConfigPrd1 = (Map<String,Object>) input.get(CONFIGUREPRODUCT1);   
            List<Object> configSelectedPrd1 = (List<Object>) rootConfigPrd1.get(CONFIGURESELECTEDPRODUCT1);
            if(!configSelectedPrd1.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd1);
            }
        }   
        if(input.get(CONFIGUREPRODUCT2) !=null){    
            Map<String,Object> rootConfigPrd2 = (Map<String,Object>) input.get(CONFIGUREPRODUCT2);   
            List<Object> configSelectedPrd2 = (List<Object>) rootConfigPrd2.get(CONFIGURESELECTEDPRODUCT2);
            if(!configSelectedPrd2.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd2);
            }
        }
        if(input.get(CONFIGUREPRODUCT3) !=null){  
            Map<String,Object> rootConfigPrd3 = (Map<String,Object>) input.get(CONFIGUREPRODUCT3);   
            List<Object> configSelectedPrd3 = (List<Object>) rootConfigPrd3.get(CONFIGURESELECTEDPRODUCT3);        
            if(!configSelectedPrd3.isEmpty()){            
               addAllSelectedProducts.addAll(configSelectedPrd3);
            }
        }
        if(input.get(CONFIGUREPRODUCT4) !=null){  
            Map<String,Object> rootConfigPrd4 = (Map<String,Object>) input.get(CONFIGUREPRODUCT4);   
            List<Object> configSelectedPrd4 = (List<Object>) rootConfigPrd4.get(CONFIGURESELECTEDPRODUCT4);
            if(!configSelectedPrd4.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd4);
            }
        }
        if(input.get(CONFIGUREPRODUCT5) !=null){  
            Map<String,Object> rootConfigPrd5 = (Map<String,Object>) input.get(CONFIGUREPRODUCT5);   
            List<Object> configSelectedPrd5 = (List<Object>) rootConfigPrd5.get(CONFIGURESELECTEDPRODUCT5);
            if(!configSelectedPrd5.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd5);
            }
        }
         if(input.get(CONFIGUREPRODUCT6) !=null){  
            Map<String,Object> rootConfigPrd6 = (Map<String,Object>) input.get(CONFIGUREPRODUCT6);   
            List<Object> configSelectedPrd6 = (List<Object>) rootConfigPrd6.get(CONFIGURESELECTEDPRODUCT6);
            if(!configSelectedPrd6.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd6);
            }
        }
        if(input.get(CONFIGUREPRODUCT7) !=null){          
            Map<String,Object> rootConfigPrd7 = (Map<String,Object>) input.get(CONFIGUREPRODUCT7);   
            List<Object> configSelectedPrd7 = (List<Object>) rootConfigPrd7.get(CONFIGURESELECTEDPRODUCT7);
            if(!configSelectedPrd7.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd7);
            }
        }
        if(input.get(CONFIGUREPRODUCT8) !=null){      
            Map<String,Object> rootConfigPrd8 = (Map<String,Object>) input.get(CONFIGUREPRODUCT8);   
            List<Object> configSelectedPrd8 = (List<Object>) rootConfigPrd8.get(CONFIGURESELECTEDPRODUCT8);
            if(!configSelectedPrd8.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd8);
            }
        }
        if(input.get(CONFIGUREPRODUCT9) !=null){      
            Map<String,Object> rootConfigPrd9 = (Map<String,Object>) input.get(CONFIGUREPRODUCT9);   
            List<Object> configSelectedPrd9 = (List<Object>) rootConfigPrd9.get(CONFIGURESELECTEDPRODUCT9);
            if(!configSelectedPrd9.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd9);
            }
        }
        if(input.get(CONFIGUREPRODUCT10) !=null){      
            Map<String,Object> rootConfigPrd10 = (Map<String,Object>) input.get(CONFIGUREPRODUCT10);   
            List<Object> configSelectedPrd10 = (List<Object>) rootConfigPrd10.get(CONFIGURESELECTEDPRODUCT10);
            if(!configSelectedPrd10.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd10);
             }
        }
        if(input.get(CONFIGUREPRODUCT11) !=null){      
            Map<String,Object> rootConfigPrd11 = (Map<String,Object>) input.get(CONFIGUREPRODUCT11);   
            List<Object> configSelectedPrd11 = (List<Object>) rootConfigPrd11.get(CONFIGURESELECTEDPRODUCT11);
            if(!configSelectedPrd11.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd11);
            }
        }
        if(input.get(CONFIGUREPRODUCT12) !=null){      
            Map<String,Object> rootConfigPrd12 = (Map<String,Object>) input.get(CONFIGUREPRODUCT12);   
            List<Object> configSelectedPrd12 = (List<Object>) rootConfigPrd12.get(CONFIGURESELECTEDPRODUCT12);
            if(!configSelectedPrd12.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd12);
            }
        }
        if(input.get(CONFIGUREPRODUCT13) !=null){      
            Map<String,Object> rootConfigPrd13 = (Map<String,Object>) input.get(CONFIGUREPRODUCT13);   
            List<Object> configSelectedPrd13 = (List<Object>) rootConfigPrd13.get(CONFIGURESELECTEDPRODUCT13);
            if(!configSelectedPrd13.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd13);
            }
        }
        if(input.get(CONFIGUREPRODUCT14) !=null){          
            Map<String,Object> rootConfigPrd14 = (Map<String,Object>) input.get(CONFIGUREPRODUCT14);   
            List<Object> configSelectedPrd14 = (List<Object>) rootConfigPrd14.get(CONFIGURESELECTEDPRODUCT14);
            if(!configSelectedPrd14.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd14);
            }
        }
        if(input.get(CONFIGUREPRODUCT15) !=null){      
            Map<String,Object> rootConfigPrd15 = (Map<String,Object>) input.get(CONFIGUREPRODUCT15);   
            List<Object> configSelectedPrd15 = (List<Object>) rootConfigPrd15.get(CONFIGURESELECTEDPRODUCT15);
            if(!configSelectedPrd15.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd15);
            }
        }
        if(input.get(CONFIGUREPRODUCT16) !=null){      
            Map<String,Object> rootConfigPrd16 = (Map<String,Object>) input.get(CONFIGUREPRODUCT16);   
            List<Object> configSelectedPrd16 = (List<Object>) rootConfigPrd16.get(CONFIGURESELECTEDPRODUCT16);
            if(!configSelectedPrd16.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd16);
            }
        }
        if(input.get(CONFIGUREPRODUCT17) !=null){      
            Map<String,Object> rootConfigPrd17 = (Map<String,Object>) input.get(CONFIGUREPRODUCT17);   
            List<Object> configSelectedPrd17 = (List<Object>) rootConfigPrd17.get(CONFIGURESELECTEDPRODUCT17);
            if(!configSelectedPrd17.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd17);
            }
        }
        if(input.get(CONFIGUREPRODUCT18) !=null){      
            Map<String,Object> rootConfigPrd18 = (Map<String,Object>) input.get(CONFIGUREPRODUCT18);   
            List<Object> configSelectedPrd18 = (List<Object>) rootConfigPrd18.get(CONFIGURESELECTEDPRODUCT18);
            if(!configSelectedPrd18.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd18);
            }
        }
        if(input.get(CONFIGUREPRODUCT19) !=null){      
            Map<String,Object> rootConfigPrd19 = (Map<String,Object>) input.get(CONFIGUREPRODUCT19);   
            List<Object> configSelectedPrd19 = (List<Object>) rootConfigPrd19.get(CONFIGURESELECTEDPRODUCT19);
            if(!configSelectedPrd19.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd19);
            }
        }
        if(input.get(CONFIGUREPRODUCT20) !=null){      
            Map<String,Object> rootConfigPrd20 = (Map<String,Object>) input.get(CONFIGUREPRODUCT20);   
            List<Object> configSelectedPrd20 = (List<Object>) rootConfigPrd20.get(CONFIGURESELECTEDPRODUCT20);
            if(!configSelectedPrd20.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd20);
            }
        }
        if(input.get(CONFIGUREPRODUCT21) !=null){      
            Map<String,Object> rootConfigPrd21 = (Map<String,Object>) input.get(CONFIGUREPRODUCT21);   
            List<Object> configSelectedPrd21 = (List<Object>) rootConfigPrd21.get(CONFIGURESELECTEDPRODUCT21);
            if(!configSelectedPrd21.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd21);
            }
        }
        if(input.get(CONFIGUREPRODUCT22) !=null){      
            Map<String,Object> rootConfigPrd22 = (Map<String,Object>) input.get(CONFIGUREPRODUCT22);   
            List<Object> configSelectedPrd22 = (List<Object>) rootConfigPrd22.get(CONFIGURESELECTEDPRODUCT22);
            if(!configSelectedPrd22.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd22);
            }
        }
        if(input.get(CONFIGUREPRODUCT23) !=null){      
            Map<String,Object> rootConfigPrd23 = (Map<String,Object>) input.get(CONFIGUREPRODUCT23);   
            List<Object> configSelectedPrd23 = (List<Object>) rootConfigPrd23.get(CONFIGURESELECTEDPRODUCT23);
            if(!configSelectedPrd23.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd23);
            }
        }
        if(input.get(CONFIGUREPRODUCT24) !=null){      
            Map<String,Object> rootConfigPrd24 = (Map<String,Object>) input.get(CONFIGUREPRODUCT24);   
            List<Object> configSelectedPrd24 = (List<Object>) rootConfigPrd24.get(CONFIGURESELECTEDPRODUCT24);
            if(!configSelectedPrd24.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd24);
            }
        }
        if(input.get(CONFIGUREPRODUCT25) !=null){      
            Map<String,Object> rootConfigPrd25 = (Map<String,Object>) input.get(CONFIGUREPRODUCT25);   
            List<Object> configSelectedPrd25 = (List<Object>) rootConfigPrd25.get(CONFIGURESELECTEDPRODUCT25);
            if(!configSelectedPrd25.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd25);
            }
        }
        if(input.get(CONFIGUREPRODUCT26) !=null){      
            Map<String,Object> rootConfigPrd26 = (Map<String,Object>) input.get(CONFIGUREPRODUCT26);   
            List<Object> configSelectedPrd26 = (List<Object>) rootConfigPrd26.get(CONFIGURESELECTEDPRODUCT26);
            if(!configSelectedPrd26.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd26);
            }
        }
        if(input.get(CONFIGUREPRODUCT27) !=null){      
            Map<String,Object> rootConfigPrd27 = (Map<String,Object>) input.get(CONFIGUREPRODUCT27);   
            List<Object> configSelectedPrd27 = (List<Object>) rootConfigPrd27.get(CONFIGURESELECTEDPRODUCT27);
            if(!configSelectedPrd27.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd27);
            }
        }
        if(input.get(CONFIGUREPRODUCT28) !=null){      
            Map<String,Object> rootConfigPrd28 = (Map<String,Object>) input.get(CONFIGUREPRODUCT28);   
            List<Object> configSelectedPrd28 = (List<Object>) rootConfigPrd28.get(CONFIGURESELECTEDPRODUCT28);
            if(!configSelectedPrd28.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd28);
            }
        }
        if(input.get(CONFIGUREPRODUCT29) !=null){  
            Map<String,Object> rootConfigPrd29 = (Map<String,Object>) input.get(CONFIGUREPRODUCT29);   
            List<Object> configSelectedPrd29 = (List<Object>) rootConfigPrd29.get(CONFIGURESELECTEDPRODUCT29);
            if(!configSelectedPrd29.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd29);
            }
        }
        if(input.get(CONFIGUREPRODUCT30) !=null){      
            Map<String,Object> rootConfigPrd30 = (Map<String,Object>) input.get(CONFIGUREPRODUCT30);   
            List<Object> configSelectedPrd30 = (List<Object>) rootConfigPrd30.get(CONFIGURESELECTEDPRODUCT30);
            if(!configSelectedPrd30.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd30);
            }
        }
                              
        if(!addAllSelectedProducts.isEmpty()){               
            for(Object recordItem :addAllSelectedProducts){
              recordAttributes = (Map<String,Object>)recordItem;               
                String prodList =  String.valueof(recordAttributes.get(PRODUCT_CODE));                     
                productCodeSet.add(prodList);                                          
              }                                      
        }

        if(input.get(RECORDS12) !=null){
          List<Object> getRatedProduct = (List<Object>)input.get(RECORDS12);
          String parentPrdCode = '';
            if(!getRatedProduct.isEmpty()){               
                for(Object recordItem :getRatedProduct){
                  recordAttributes = (Map<String,Object>)recordItem; 
                  String prodList =  String.valueof(recordAttributes.get(PRODUCT_CODE)); 
                      productCodeUpdatedSet.add(prodList);                                                                                         
                      if(!productCodeSet.Contains(String.ValueOf(recordAttributes.get(PRODUCT_CODE)))){                                              
                        prdMapIsSelected.add((Map<String,Object>)recordAttributes);
                      }
                }
                if(!prdSetIsSelected.isEmpty() && !prdMapIsSelected.isEmpty()){
                    for(Object childrecordItem:prdMapIsSelected){
                        childPrdMapIsSelected = new List<Map<String,Object>>();
                        recordAttributes = (Map<String,Object>)childrecordItem;
                        parentPrdCode =  String.valueof(recordAttributes.get(PRODUCT_CODE)); //TD-1020 Added By Dinesh - Added the parentcode
                        childProdMap = (Map<String,Object>)recordAttributes.get(CHILD_PRODUCTS);                   
                        childProduct = (List<Object>)childProdMap.get(RECORDS);                    
                        for(Object tempChild:childProduct){
                            recordAttributes = (Map<String,Object>)tempChild;
                             if(recordAttributes.get(PRODUCT_CODE) != null){
                                //if(prdSetIsSelected.Contains(String.valueof(recordAttributes.get(PRODUCT_CODE)))){
                                if(prdSetIsSelected.Contains(parentPrdCode+UNDERSCORE+String.valueof(recordAttributes.get(PRODUCT_CODE)))){ //TD-1020 Added By Dinesh - updated the if condition to include parentcode check
                                  recordAttributes.put(ISSELECTED,true);
                                }
                                childPrdMapIsSelected.add((Map<String,Object>)recordAttributes);                                
                                childProdMap.put(RECORDS,childPrdMapIsSelected);                                                                               
                            }
                        }
                    }
                }
            }    
        }                
        if(!addAllSelectedProducts.isEmpty()){               
            for(Object recordItem :addAllSelectedProducts){
              recordAttributes = (Map<String,Object>)recordItem;               
              if(productCodeUpdatedSet.Contains(String.ValueOf(recordAttributes.get(PRODUCT_CODE)))){                               
                prdMapIsSelectedUpdated.add((Map<String,Object>)recordAttributes);
              }                          
            }  
        } 
        if(!prdMapIsSelectedUpdated.isEmpty()){
           mergeFinalList.addAll(prdMapIsSelectedUpdated);
        }
        if(!prdMapIsSelected.isEmpty()){
           mergeFinalList.addAll(prdMapIsSelected);
        }                         
        if(mergeFinalList.isEmpty()){
          output.put(ERROR_OUT,ERROR_MSG_PRODUCTSSELECTION);        
        }
        else if(!mergeFinalList.isEmpty()){
          output.put(SETFLAG1,true);
          output.put(SETFLAG2,true);
          output.put(SETFLAG3,true);
          output.put(SETFLAG4,true);
          output.put(SETFLAG5,true);
          output.put(SETFLAG6,true);
          output.put(SETFLAG7,true);
          output.put(SETFLAG8,true);
          output.put(SETFLAG9,true);
          output.put(SETFLAG10,true);
          output.put(SETFLAG11,true);
          output.put(SETFLAG12,true);
          output.put(SETFLAG13,true);
          output.put(SETFLAG14,true);
          output.put(SETFLAG15,true);
          output.put(SETFLAG16,true);
          output.put(SETFLAG17,true);
          output.put(SETFLAG18,true);
          output.put(SETFLAG19,true);
          output.put(SETFLAG20,true);
          output.put(SETFLAG21,true);
          output.put(SETFLAG22,true);
          output.put(SETFLAG23,true);
          output.put(SETFLAG24,true);
          output.put(SETFLAG25,true);
          output.put(SETFLAG26,true);
          output.put(SETFLAG27,true);
          output.put(SETFLAG28,true);          
          output.put(SETFLAG29,true);          
          output.put(SETFLAG30,true);          
          
          output.put(RECORDSMERGESET,mergeFinalList);                    
        }              
        else{
        }
        return true; 
    }   
           
    /********************************************************************************************************************
    @Description        :   This method is used to merge the products selected in the Products Offering and Product Selection screens and send the
                            response back to the output.
    @Name               :   getSelectedProducts
    @Param              :   Map<String, Object> input, Map<String, Object> output
    @Return             :   Boolean
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/  
    global static Boolean prodConfigResponse(Map<String, Object> input,
                                             Map<String, Object> output)
    {
            
        List<Object> addAllSelectedProducts = new List<Object>();
        Map<String,Object> recordAttributes = new Map<String,Object>();
        List<Map<String,Object>> prdMapIsSelected = new List<Map<String,Object>>();
        Set<String> productCodeselSet = new Set<String>(); 
        Set<String> productCodeSet = new Set<String>();    
        List<Map<String,Object>> childPrdMapIsSelected = new List<Map<String,Object>>();
        Map<String,Object> childProdMap = new Map<String,Object>();
        List<Object> childProduct = new List<Object>();     
            
        if(input.get(CONFIGUREPRODUCT1) !=null){
            Map<String,Object> rootConfigPrd1 = (Map<String,Object>) input.get(CONFIGUREPRODUCT1);   
            List<Object> configSelectedPrd1 = (List<Object>) rootConfigPrd1.get(CONFIGURESELECTEDPRODUCT1);
            if(!configSelectedPrd1.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd1);
            }
        }   
        if(input.get(CONFIGUREPRODUCT2) !=null){    
            Map<String,Object> rootConfigPrd2 = (Map<String,Object>) input.get(CONFIGUREPRODUCT2);   
            List<Object> configSelectedPrd2 = (List<Object>) rootConfigPrd2.get(CONFIGURESELECTEDPRODUCT2);
            if(!configSelectedPrd2.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd2);
            }
        }
        if(input.get(CONFIGUREPRODUCT3) !=null){  
            Map<String,Object> rootConfigPrd3 = (Map<String,Object>) input.get(CONFIGUREPRODUCT3);   
            List<Object> configSelectedPrd3 = (List<Object>) rootConfigPrd3.get(CONFIGURESELECTEDPRODUCT3);        
            if(!configSelectedPrd3.isEmpty()){            
               addAllSelectedProducts.addAll(configSelectedPrd3);
            }
        }
        if(input.get(CONFIGUREPRODUCT4) !=null){  
            Map<String,Object> rootConfigPrd4 = (Map<String,Object>) input.get(CONFIGUREPRODUCT4);   
            List<Object> configSelectedPrd4 = (List<Object>) rootConfigPrd4.get(CONFIGURESELECTEDPRODUCT4);
            if(!configSelectedPrd4.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd4);
            }
        }
        if(input.get(CONFIGUREPRODUCT5) !=null){  
            Map<String,Object> rootConfigPrd5 = (Map<String,Object>) input.get(CONFIGUREPRODUCT5);   
            List<Object> configSelectedPrd5 = (List<Object>) rootConfigPrd5.get(CONFIGURESELECTEDPRODUCT5);
            if(!configSelectedPrd5.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd5);
            }
        }
        if(input.get(CONFIGUREPRODUCT6) !=null){  
            Map<String,Object> rootConfigPrd6 = (Map<String,Object>) input.get(CONFIGUREPRODUCT6);   
            List<Object> configSelectedPrd6 = (List<Object>) rootConfigPrd6.get(CONFIGURESELECTEDPRODUCT6);
            if(!configSelectedPrd6.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd6);
            }
        }
        if(input.get(CONFIGUREPRODUCT7) !=null){          
            Map<String,Object> rootConfigPrd7 = (Map<String,Object>) input.get(CONFIGUREPRODUCT7);   
            List<Object> configSelectedPrd7 = (List<Object>) rootConfigPrd7.get(CONFIGURESELECTEDPRODUCT7);
            if(!configSelectedPrd7.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd7);
            }
        }
        if(input.get(CONFIGUREPRODUCT8) !=null){      
            Map<String,Object> rootConfigPrd8 = (Map<String,Object>) input.get(CONFIGUREPRODUCT8);   
            List<Object> configSelectedPrd8 = (List<Object>) rootConfigPrd8.get(CONFIGURESELECTEDPRODUCT8);
            if(!configSelectedPrd8.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd8);
            }
        }
        if(input.get(CONFIGUREPRODUCT9) !=null){      
            Map<String,Object> rootConfigPrd9 = (Map<String,Object>) input.get(CONFIGUREPRODUCT9);   
            List<Object> configSelectedPrd9 = (List<Object>) rootConfigPrd9.get(CONFIGURESELECTEDPRODUCT9);
            if(!configSelectedPrd9.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd9);
            }
        }
        if(input.get(CONFIGUREPRODUCT10) !=null){      
            Map<String,Object> rootConfigPrd10 = (Map<String,Object>) input.get(CONFIGUREPRODUCT10);   
            List<Object> configSelectedPrd10 = (List<Object>) rootConfigPrd10.get(CONFIGURESELECTEDPRODUCT10);
            if(!configSelectedPrd10.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd10);
             }
        }
        if(input.get(CONFIGUREPRODUCT11) !=null){      
            Map<String,Object> rootConfigPrd11 = (Map<String,Object>) input.get(CONFIGUREPRODUCT11);   
            List<Object> configSelectedPrd11 = (List<Object>) rootConfigPrd11.get(CONFIGURESELECTEDPRODUCT11);
            if(!configSelectedPrd11.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd11);
            }
        }
        if(input.get(CONFIGUREPRODUCT12) !=null){      
            Map<String,Object> rootConfigPrd12 = (Map<String,Object>) input.get(CONFIGUREPRODUCT12);   
            List<Object> configSelectedPrd12 = (List<Object>) rootConfigPrd12.get(CONFIGURESELECTEDPRODUCT12);
            if(!configSelectedPrd12.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd12);
            }
        }
        if(input.get(CONFIGUREPRODUCT13) !=null){      
            Map<String,Object> rootConfigPrd13 = (Map<String,Object>) input.get(CONFIGUREPRODUCT13);   
            List<Object> configSelectedPrd13 = (List<Object>) rootConfigPrd13.get(CONFIGURESELECTEDPRODUCT13);
            if(!configSelectedPrd13.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd13);
            }
        }
        if(input.get(CONFIGUREPRODUCT14) !=null){          
            Map<String,Object> rootConfigPrd14 = (Map<String,Object>) input.get(CONFIGUREPRODUCT14);   
            List<Object> configSelectedPrd14 = (List<Object>) rootConfigPrd14.get(CONFIGURESELECTEDPRODUCT14);
            if(!configSelectedPrd14.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd14);
            }
        }
        if(input.get(CONFIGUREPRODUCT15) !=null){      
            Map<String,Object> rootConfigPrd15 = (Map<String,Object>) input.get(CONFIGUREPRODUCT15);   
            List<Object> configSelectedPrd15 = (List<Object>) rootConfigPrd15.get(CONFIGURESELECTEDPRODUCT15);
            if(!configSelectedPrd15.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd15);
            }
        }
        if(input.get(CONFIGUREPRODUCT16) !=null){      
            Map<String,Object> rootConfigPrd16 = (Map<String,Object>) input.get(CONFIGUREPRODUCT16);   
            List<Object> configSelectedPrd16 = (List<Object>) rootConfigPrd16.get(CONFIGURESELECTEDPRODUCT16);
            if(!configSelectedPrd16.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd16);
            }
        }
        if(input.get(CONFIGUREPRODUCT17) !=null){      
            Map<String,Object> rootConfigPrd17 = (Map<String,Object>) input.get(CONFIGUREPRODUCT17);   
            List<Object> configSelectedPrd17 = (List<Object>) rootConfigPrd17.get(CONFIGURESELECTEDPRODUCT17);
            if(!configSelectedPrd17.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd17);
            }
        }
        if(input.get(CONFIGUREPRODUCT18) !=null){      
            Map<String,Object> rootConfigPrd18 = (Map<String,Object>) input.get(CONFIGUREPRODUCT18);   
            List<Object> configSelectedPrd18 = (List<Object>) rootConfigPrd18.get(CONFIGURESELECTEDPRODUCT18);
            if(!configSelectedPrd18.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd18);
            }
        }
        if(input.get(CONFIGUREPRODUCT19) !=null){      
            Map<String,Object> rootConfigPrd19 = (Map<String,Object>) input.get(CONFIGUREPRODUCT19);   
            List<Object> configSelectedPrd19 = (List<Object>) rootConfigPrd19.get(CONFIGURESELECTEDPRODUCT19);
            if(!configSelectedPrd19.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd19);
            }
        }
        if(input.get(CONFIGUREPRODUCT20) !=null){      
            Map<String,Object> rootConfigPrd20 = (Map<String,Object>) input.get(CONFIGUREPRODUCT20);   
            List<Object> configSelectedPrd20 = (List<Object>) rootConfigPrd20.get(CONFIGURESELECTEDPRODUCT20);
            if(!configSelectedPrd20.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd20);
            }
        }
        if(input.get(CONFIGUREPRODUCT21) !=null){      
            Map<String,Object> rootConfigPrd21 = (Map<String,Object>) input.get(CONFIGUREPRODUCT21);   
            List<Object> configSelectedPrd21 = (List<Object>) rootConfigPrd21.get(CONFIGURESELECTEDPRODUCT21);
            if(!configSelectedPrd21.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd21);
            }
        }
        if(input.get(CONFIGUREPRODUCT22) !=null){      
            Map<String,Object> rootConfigPrd22 = (Map<String,Object>) input.get(CONFIGUREPRODUCT22);   
            List<Object> configSelectedPrd22 = (List<Object>) rootConfigPrd22.get(CONFIGURESELECTEDPRODUCT22);
            if(!configSelectedPrd22.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd22);
            }
        }
        if(input.get(CONFIGUREPRODUCT23) !=null){      
            Map<String,Object> rootConfigPrd23 = (Map<String,Object>) input.get(CONFIGUREPRODUCT23);   
            List<Object> configSelectedPrd23 = (List<Object>) rootConfigPrd23.get(CONFIGURESELECTEDPRODUCT23);
            if(!configSelectedPrd23.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd23);
            }
        }
        if(input.get(CONFIGUREPRODUCT24) !=null){      
            Map<String,Object> rootConfigPrd24 = (Map<String,Object>) input.get(CONFIGUREPRODUCT24);   
            List<Object> configSelectedPrd24 = (List<Object>) rootConfigPrd24.get(CONFIGURESELECTEDPRODUCT24);
            if(!configSelectedPrd24.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd24);
            }
        }
        if(input.get(CONFIGUREPRODUCT25) !=null){      
            Map<String,Object> rootConfigPrd25 = (Map<String,Object>) input.get(CONFIGUREPRODUCT25);   
            List<Object> configSelectedPrd25 = (List<Object>) rootConfigPrd25.get(CONFIGURESELECTEDPRODUCT25);
            if(!configSelectedPrd25.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd25);
            }
        }
        if(input.get(CONFIGUREPRODUCT26) !=null){      
            Map<String,Object> rootConfigPrd26 = (Map<String,Object>) input.get(CONFIGUREPRODUCT26);   
            List<Object> configSelectedPrd26 = (List<Object>) rootConfigPrd26.get(CONFIGURESELECTEDPRODUCT26);
            if(!configSelectedPrd26.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd26);
            }
        }
        if(input.get(CONFIGUREPRODUCT27) !=null){      
            Map<String,Object> rootConfigPrd27 = (Map<String,Object>) input.get(CONFIGUREPRODUCT27);   
            List<Object> configSelectedPrd27 = (List<Object>) rootConfigPrd27.get(CONFIGURESELECTEDPRODUCT27);
            if(!configSelectedPrd27.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd27);
            }
        }
        if(input.get(CONFIGUREPRODUCT28) !=null){      
            Map<String,Object> rootConfigPrd28 = (Map<String,Object>) input.get(CONFIGUREPRODUCT28);   
            List<Object> configSelectedPrd28 = (List<Object>) rootConfigPrd28.get(CONFIGURESELECTEDPRODUCT28);
            if(!configSelectedPrd28.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd28);
            }
        }
        if(input.get(CONFIGUREPRODUCT29) !=null){  
            Map<String,Object> rootConfigPrd29 = (Map<String,Object>) input.get(CONFIGUREPRODUCT29);   
            List<Object> configSelectedPrd29 = (List<Object>) rootConfigPrd29.get(CONFIGURESELECTEDPRODUCT29);
            if(!configSelectedPrd29.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd29);
            }
        }
        if(input.get(CONFIGUREPRODUCT30) !=null){      
            Map<String,Object> rootConfigPrd30 = (Map<String,Object>) input.get(CONFIGUREPRODUCT30);   
            List<Object> configSelectedPrd30 = (List<Object>) rootConfigPrd30.get(CONFIGURESELECTEDPRODUCT30);
            if(!configSelectedPrd30.isEmpty()){
               addAllSelectedProducts.addAll(configSelectedPrd30);
            }
        }       

       
        if(input.get(RECORDS12) !=null){
            List<Object> selectedRecords = (List<Object>)input.get(RECORDS12);            
            if(!selectedRecords.isEmpty()){               
                for(Object recordItem :selectedRecords){
                  recordAttributes = (Map<String,Object>)recordItem;                            
                  String prodList =  String.valueof(recordAttributes.get(PRODUCT_CODE));                    
                  productCodeSet.add(prodList);                          
                }  
            }             
        }  

        if(!addAllSelectedProducts.isEmpty()){               
            for(Object recordItem :addAllSelectedProducts){
              recordAttributes = (Map<String,Object>)recordItem;   
               if(!productCodeselSet.Contains(String.ValueOf(recordAttributes.get(PRODUCT_CODE))) 
                  && productCodeSet.Contains(String.ValueOf(recordAttributes.get(PRODUCT_CODE)))){                
                  prdMapIsSelected.add((Map<String,Object>)recordAttributes);
                  String prodselList =  String.valueof(recordAttributes.get(PRODUCT_CODE));
                  
                  System.debug('*****************************'+recordAttributes.get(PRODUCT_CODE));

                  productCodeselSet.add(prodselList);                
               }             
            }   
            if(!prdMapIsSelected.isEmpty()){
                for(Object childrecordItem:prdMapIsSelected){
                    childPrdMapIsSelected = new List<Map<String,Object>>();
                    recordAttributes = (Map<String,Object>)childrecordItem;
                    childProdMap = (Map<String,Object>)recordAttributes.get(CHILD_PRODUCTS);                   
                    childProduct = (List<Object>)childProdMap.get(RECORDS);                    
                    for(Object tempChild:childProduct){
                        recordAttributes = (Map<String,Object>)tempChild;
                         if(recordAttributes.get(ISSELECTED) == true && recordAttributes.get(PRODUCT_CODE) != null){
                            
                            System.debug('*****************************'+recordAttributes.get(PRODUCT_CODE));
                                  
                            childPrdMapIsSelected.add((Map<String,Object>)recordAttributes);                                
                            childProdMap.put(RECORDS,childPrdMapIsSelected);                                                                               
                        }
                    }
                }
            }                                   
        }  
        if(!prdMapIsSelected.isEmpty()){
           output.put(FINALRECORDS,prdMapIsSelected);        
        }          
        return true; 
    }
    
    /********************************************************************************************************************
    @Description        :   This method is used to delete the quote line items records for the unselected products in Product Offerings and Product Selected screens.
    @Name               :   deleteUnselectedPlans
    @Param              :   Map<String, Object> input, Map<String, Object> output
    @Return             :   Boolean
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/  
    global static Boolean deleteUnselectedPlans(Map<String, Object> input,
                                                Map<String, Object> output)
    {  
            List<String> prdId =new List<String>();
            Set<Id> qLIDSet = new Set<Id>();
            List<Object> delQLIItemsList = new List<Object>();

            String quoteId = (string)input.get(QUOTID);
            
            if(input.get(UNSELECTEDPLANS) !=null){
               List<Object> unSelectedPlans = (List<Object>)input.get(UNSELECTEDPLANS);//2&3rd screens 
               delQLIItemsList.addAll(unSelectedPlans);
            }
            if(input.get(DESELECTEDCHILDPLANS) !=null){
               List<Object> deSelectedChildPlans = (List<Object>)input.get(DESELECTEDCHILDPLANS);//From 4th screen
               delQLIItemsList.addAll(deSelectedChildPlans);
            }           
            if(!delQLIItemsList.isEmpty()){         
                for(Object Obj:delQLIItemsList){
                    prdId.add(String.valueOf(Obj));
                }
                
                Set<String> prdCodeSet = new Set<String>();
                                
                for(QuoteLineItem qLIItem: [Select Id,vlocity_ins__ParentItemId2__r.ASC_Product_Code__c,
                                            Product2.ProductCode from QuoteLineItem 
                                            WHERE Product2Id IN:prdId
                                            AND QuoteId =:quoteId 
                                            LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                  prdCodeSet.add(qLIItem.vlocity_ins__ParentItemId2__r.ASC_Product_Code__c+UNDERSCORE+qLIItem.Product2.ProductCode);
                  qLIDSet.add(qLIItem.Id);
                  System.debug('***************qLIDSet'+qLIDSet);
                  System.debug('***************prdId'+prdId);
                }            
                
                /* Set<Id> childPrdQLI = new Set<Id>();
                for(vlocity_ins__ProductChildItem__c childPrd : [select id,Name,vlocity_ins__ChildProductId__c,vlocity_ins__ParentProductId__c,
                                                     vlocity_ins__ParentProductId__r.productcode,vlocity_ins__ChildProductId__r.productcode,
                                                     vlocity_ins__ChildProductId__r.Name,vlocity_ins__ParentProductId__r.Name ,vlocity_ins__ChildProductId__r.Id
                                                     from vlocity_ins__ProductChildItem__c
                                                     where vlocity_ins__ParentProductId__c =:prdId]){
                  childPrdQLI.add(childPrd.vlocity_ins__ChildProductId__c);                                 
                }   */                                  
                                                                                                          
                List<QuoteLineItem> qLIItemList = [Select Id,vlocity_ins__ParentItemId__c,vlocity_ins__ParentItemId2__c from QuoteLineItem WHERE 
                                                   (vlocity_ins__ParentItemId__c IN:qLIDSet 
                                                   OR vlocity_ins__ParentItemId2__c IN:qLIDSet)
                                                   OR ID IN:qLIDSet 
                                                   Limit :UTIL_SLB.retrieveQueryLimitValue()]; 
                                                   
                for(QuoteLineItem qli:qLIItemList){
                  System.debug('***************vlocity_ins__ParentItemId__c'+qli.vlocity_ins__ParentItemId__c);
                  System.debug('***************vlocity_ins__ParentItemId2__c'+qli.vlocity_ins__ParentItemId2__c);
                }                                                                                                                     
                
                if(!qLIItemList.isEmpty()){
                   Database.delete(qLIItemList,false);
                }
            }           
            return true;
    }
    
    global static Boolean updateDatesForQLI(Map<String, Object> input,
                                        Map<String, Object> output){
                                        
     map<string,object> nd1 = (Map<String,Object>)input.get('IdentifyingQuote');
     effDate = string.valueof(nd1.get('StartDate'));
     Date effDt= date.valueOf(effDate);
     endDate = (String)nd1.get('EndDate');
     Date endDt = date.valueOf(endDate);
    
     String quoteId = (string)input.get(QUOTID);
    
     List<QuoteLineItem> qliList = [Select Id,ASC_Effective_Start_Date__c,ASC_Effective_End_Date__c from QuoteLineItem WHERE ASC_Effective_End_Date__c = null 
                                    AND ASC_Effective_Start_Date__c = null
                                    AND QuoteId =:quoteId];
                                    
     if(!qliList.isEmpty()){
       for(QuoteLineItem qli:qliList){
         qli.ASC_Effective_Start_Date__c = Date.valueOf(effDate);
         qli.ASC_Effective_End_Date__c = Date.valueOf(endDate);
       }   
       Update qliList;
     }
     return true;
    }                                      
}