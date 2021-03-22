/**********************************************************
Class Name   : ASC_CreateRenewalUserInputs
Description  : Calculate the Pricing or Underwritten Products from Group Sepecific Pricing table in Renewals
**************************************************************/
Global with sharing class ASC_CreateRenewalUserInputs implements vlocity_ins.VlocityOpenInterface2{
    public static final map<string,object> gsp = new map<string,object>();
    public static string QUOTEID;
    public static final string CONTEXTID = 'ContextId';
    public static string ctrcID;
    public static string AccId;
    public static string CarrierType;
    public static string EffDates;
    public static string endDate;
    public static string SubSegment;
    public static string ContractID;
    public static string StartDate;
    public static string ContractYear;
    public static string RenewalYear;
    public static final map<string,list<id>> fnlstPrdId = new map<string,list<id>>();
    public static final string ASC_EffectiveStartDate = '.ASC_EffectiveStartDate';
    public static final string ASC_EffectiveEndDate = '.ASC_EffectiveEndDate';
    
    /***************************************************************************************************  
Method name : invokeMethod
Param 1     : inputMap, outputMap and Options
Return Type : void
Description : To invoke the method called from Remote Action
****************************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) 
    {      
        try{
            if (methodName == 'getUserInputJSon') 
            {
                getUserInputJSon(input, output, options);
            }
            if (methodName == 'retainPriorYearInformation') 
            {
                retainPriorYearInformation(input, output, options);
            }  
            /*  if (methodName == 'DeleteHealthCareLateCharge') 
{
DeleteHealthCareLateCharge(input, output, options);
} */
        } 
        catch(exception e){
            //system.debug('line number@@ '+e.getLineNumber());
            //system.debug('getMessage @@ '+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, 'ASC_CreateRenewalUserInputs', 'getUserInputJSon');
            throw new AuraHandledException('ERRORMSG'+ARV_AP41_StringLiteralUtils.COLONVAL+e.getMessage()); }
        
        return true;
    }
    /***************************************************************************************************  
Method name : retainPriorYearInformation
Param 1     : inputMap, outputMap,options
Return Type : void    POC_CreateRenewalUserInputs.getUnitpriceJSon
Description : Retaining the Contract Information into the Renewalyear
****************************************************************************************************/    
    
    public static void retainPriorYearInformation(Map<String, Object> input, Map<String, Object> outputs,Map<String,Object> options){
        ContractID = (String)input.get(CONTEXTID );
        ctrcID = string.valueOf(options.get('ctrctId'));
        QUOTEID = string.valueOf(options.get('quoteId'));
        RenewalYear= string.valueOf(options.get('RenewalYear'));
        system.debug('@@@@@@@@@@StartDate'+RenewalYear);
        //Date dtef = date.valueOf(RenewalYear);
        list<QuoteLineItem> rQli = [select id,ASC_Product_Code__c,Product2.Name,Quote.ASC_Renewal_Year__c,Product2Id,
                                    ASC_Line_Item_Extension__c,ASC_Effective_Start_Date__c,ASC_Effective_End_Date__c from
                                    QuoteLineItem where
                                    QuoteID = :QUOTEID AND Product2.ASC_Annual_Product__c=False ];     
        
        id prdcId;       
        list<QuoteLineItem> UpdateRQLI=new list<QuoteLineItem>();
        list<Line_Item_Extension__c> LIExtension_UpdateList=new list<Line_Item_Extension__c>();
        for(QuoteLineItem qli: rQli){           
            prdcId = qli.Product2Id;
            list<vlocity_ins__ContractLineItem__c> cli = [select id, name, ASC_Effective_Start_Date__c, ASC_Effective_End_Date__c from vlocity_ins__ContractLineItem__c where vlocity_ins__ContractId__c= :ctrcID 
                                                          AND vlocity_ins__Product2Id__c = : prdcId];
            qli.ASC_Effective_Start_Date__c =   cli[0].ASC_Effective_Start_Date__c;
            qli.ASC_Effective_End_Date__c     = cli[0].ASC_Effective_End_Date__c;
            //Propagate the Start & End dates from Quote line to Line Ext 
            Line_Item_Extension__c LIExtension_NewRec= new Line_Item_Extension__c(id=qli.ASC_Line_Item_Extension__c);
            LIExtension_NewRec.Effective_Start_Date__c=qli.ASC_Effective_Start_Date__c;
            LIExtension_NewRec.Effective_End_Date__c=qli.ASC_Effective_End_Date__c;
            LIExtension_UpdateList.add(LIExtension_NewRec);
            
        }       
        if(rQli.size()>0) database.update(rQli,false);
        if(LIExtension_UpdateList.size()>0) database.update(LIExtension_UpdateList,false);
        
            
    //map to capture the Quote line items based on the root parent.map<RootProduct, list of ReleatedQuoteLines>
    map<id, list<QuoteLineItem>> QuoteLineItem_Map=new map<id, list<QuoteLineItem>>();
    for(QuoteLineItem ql: [select id,ASC_Product_Code__c,Product2.Name,Quote.ASC_Renewal_Year__c,Product2Id,vlocity_ins__ParentItemId2__c,
                                    ASC_Line_Item_Extension__c,ASC_Effective_Start_Date__c,ASC_Effective_End_Date__c
                                    from 
                                    QuoteLineItem where 
                                    QuoteID = :QUOTEID
                                    AND Product2.ASC_Annual_Product__c=False]){
        if(!QuoteLineItem_Map.containsKey(ql.vlocity_ins__ParentItemId2__c)){
            QuoteLineItem_Map.put(ql.vlocity_ins__ParentItemId2__c, new list<QuoteLineItem>());
        }
        QuoteLineItem_Map.get(ql.vlocity_ins__ParentItemId2__c).add(ql);
    }
    
    list<QuoteLineItem> deleteQuoteLineItem= new list<QuoteLineItem>();   
    for(id rootID:QuoteLineItem_Map.keySet()){
        boolean retainQuoteLineItem=false; //boolean flag to identify whether Quote line items are to be deleted or retained
        for(QuoteLineItem qlist:QuoteLineItem_Map.get(rootID)){
            IF(qlist.ASC_Effective_End_Date__c.year() >= Integer.valueof(RenewalYear)){
                retainQuoteLineItem=true;
            }          
        }
        if(!retainQuoteLineItem) deleteQuoteLineItem.addAll(QuoteLineItem_Map.get(rootID));
    }
          
        list<QuoteLineItem> delqlis = [select id,ASC_Product_Code__c,Product2.Name,Quote.ASC_Renewal_Year__c,Product2Id,
                                       ASC_Line_Item_Extension__c,ASC_Effective_Start_Date__c,ASC_Effective_End_Date__c,vlocity_ins__ParentItemId2__c from 
                                       QuoteLineItem where 
                                       QuoteID = :QUOTEID AND (((ASC_Line_Item_Extension__r.Provider_Contract_Interest__c = 12 AND ASC_Product_Code__c ='ASC_0000324') OR
                                                                (ASC_Line_Item_Extension__r.Late_Charge__c = 2 AND ASC_Product_Code__c ='ASC_0000323')) OR Id IN:deleteQuoteLineItem)] ;  
        system.debug('@@@@@@@@@@@DelteData@@@@@@@@'+delqlis);        
        
        Set<Id> parentQLIidSet = new Set<Id>();
        for(QuoteLineItem qli:delqlis){
           parentQLIidSet.add(qli.vlocity_ins__ParentItemId2__c);
        }
                                       
        if(!delqlis.isEmpty()){
            Delete delqlis;
        }
        
        //child QLI's
        Set<String> parentQLIPRODSet = new Set<String>();
        for(QuoteLineItem qli:[Select Id,vlocity_ins__ParentItemId2__r.ASC_Product_Code__c from QuoteLineItem 
                               where QuoteID = :QUOTEID 
                               AND Id NOT IN:delqlis
                               AND vlocity_ins__ParentItemId2__c != null]){
           parentQLIPRODSet.add(qli.vlocity_ins__ParentItemId2__r.ASC_Product_Code__c+'_'+qli.vlocity_ins__ParentItemId2__c);        
        }
        
         //parent QLI's
        List<QuoteLineItem> parentQLIdeleteList = new List<QuoteLineItem>();
        for(QuoteLineItem qli:[Select Id,ASC_Product_Code__c from QuoteLineItem 
                               where Id IN:parentQLIidSet 
                               AND vlocity_ins__ParentItemId2__c = null]){
            if(!parentQLIPRODSet.Contains(qli.ASC_Product_Code__c+'_'+qli.Id)){                   
              parentQLIdeleteList.add(qli);
            }
        }

        if(!parentQLIdeleteList.isEmpty()){
          Delete parentQLIdeleteList;
        }
        
        
        
        
        
        
       /* list<QuoteLineItem> delroot=new list<QuoteLineItem>();
        list<QuoteLineItem> delrootqlis =  [select id,ASC_Product_Code__c,Product2.Name,Quote.ASC_Renewal_Year__c,Product2Id,
                                            vlocity_ins__ParentItemId2__c,vlocity_ins__ParentItemId2__r.ASC_Product_Code__c,ASC_Line_Item_Extension__c,ASC_Effective_Start_Date__c,ASC_Effective_End_Date__c
                                    from QuoteLineItem where QuoteID = :QUOTEID];
        for(QuoteLineItem qlist:delrootqlis){
            IF(qlist.vlocity_ins__ParentItemId2__r.ASC_Product_Code__c!='ASC_0000011' || qlist.vlocity_ins__ParentItemId2__r.ASC_Product_Code__c!='ASC_0000226'){
                if(qlist.ASC_Product_Code__c=='ASC_0000011' || qlist.ASC_Product_Code__c=='ASC_0000226'){
                      delroot.add(qlist);                  
                    
                }
            }
        }
        if(delroot.size()!=null){
            
            delete delroot;
        } */
                
    }
    
    
       /***************************************************************************************************  
    Method name : getUnitpriceJSon
    Param 1     : inputMap, outputMap.
    Return Type : void    POC_CreateRenewalUserInputs.getUnitpriceJSon
    Description : Calculate the Pricing from Group Specific Pricing table.
    ****************************************************************************************************/    
    public static void getUserInputJSon(Map<String, Object> input, Map<String, Object> output, Map<String,Object> options){
        
        ctrcID = string.valueOf(options.get('ctrctId'));
        AccId = string.valueOf(options.get('AccId'));
        CarrierType = string.valueOf(options.get('CarrierType'));
        EffDates = string.valueOf(options.get('EffDate'));
        Date dtef = date.valueOf(EffDates);
        SubSegment = string.valueOf(options.get('SubSegment'));
        list<vlocity_ins__ContractLineItem__c> plns = [select id,vlocity_ins__Product2Id__c,vlocity_ins__ProductCode__c,
                                                       vlocity_ins__AttributeSelectedValues__c,
                                                       ASC_Line_Item_Extension__c from 
                                                       vlocity_ins__ContractLineItem__c where 
                                                       vlocity_ins__ContractId__c = :ctrcID];
        set<id> selPrdcts = new set<id>();
        for(vlocity_ins__ContractLineItem__c pln : plns){
            selPrdcts.add(pln.vlocity_ins__Product2Id__c);
        }
        String PrdIDS = '';
        String PrdSelIDs = '';
        set<id> selRootPrdcts = new set<id>();
        for(product2 prd : [select id, name, productcode,vlocity_ins__RecordTypeName__c from 
                            product2 where id in :selPrdcts and vlocity_ins__RecordTypeName__c = 'Product']){
                                selRootPrdcts.add(prd.Id);
                                PrdIDS += 'Id:'+prd.Id+',';
                            }
        PrdSelIDs = PrdIDS.removeEnd(','); 
        If(PrdSelIDs!=NULL){
            output.put('selPrdctIds',PrdSelIDs);
        }
        
        //To get Coverage Spec Prdct Code
        set<string> covgSpecPrdcde = new set<string>();
        for(vlocity_ins__ProductChildItem__c pci : [select id,vlocity_ins__ChildProductId__c,ASC_Child_ProductCode__c 
                                                    from vlocity_ins__ProductChildItem__c where 
                                                    vlocity_ins__ParentProductId__c in :selRootPrdcts]){
                                                        covgSpecPrdcde.add(pci.ASC_Child_ProductCode__c);
                                                    }
        
        
        //Get the Prdcts that are to be fetch from CLI
      //  list<ASC_RetainPricingFrmCntrctPrdcts__mdt> rtnPrdcts = [select id,ProductCode__c from ASC_RetainPricingFrmCntrctPrdcts__mdt];
        
        list<ASC_Group_Specific_Pricing__c> gspVa = [select ASC_Estimated_Monthly_Contracts__c,ASC_Unit_Price__c,
                                                     ASC_Monthly_Cap_Amount__c, ASC_Hosp_Ad_Dep__c,ASC_K_Adv_Deposit__c, 
                                                     ASC_Percent_of_Claims__c,AAC_PCNT__c,ASC_Unit_Price_Not_GT__c,
                                                     ASC_Unit_Price_Not_LT__c,Aggregating_Deductible__c,ASC_AAC_Type_of_Claims__c,
                                                     ASC_Second_Year_Rate_Cap__c,ASC_Third_Year_Rate_Cap__c, 
                                                     ASC_Fourth_Year_Rate_Cap__c,ASC_SL_Identifier__c,ASC_Rate_Cap__c,
                                                     ASC_SL_Identifier_Data__c,ASC_Attachment_Point__c,ASC_CRED_CLMS__c,
                                                     ASC_Cost_Share_Maximum__c,ASC_Cost_Share_Percent__c,
                                                     ASC_Refund_Percent__c,ASC_Total_Stop_Loss_Premium__c,
                                                     ASC_CRED_CLMS_Facility__c,ASC_Aggregate_Min_Attachment_Point__c,
                                                     ASC_Product_Code__c,ASC_Platform__c,ASC_Level_Payment_Claims_Amount__c,
                                                     Claims_Covered__c,ASC_SL_LOB__c from ASC_Group_Specific_Pricing__c where
                                                     ASC_Group__c =:AccId and
                                                     (ASC_Effective_Date__c <= :dtef and ASC_Effective_End_Date__c>=:dtef) and
                                                     ASC_Product_Code__c in :covgSpecPrdcde 
                                                     and ASC_Carrier__c =:CarrierType
                                                     and ASC_Sub_Segment__c =: SubSegment];
        
        Map<String,string> gspAttrMDMap = new Map<String,string>();
        for(ASC_GSPFieldMetadata__mdt mdt:[Select Id,Attribute_Name__c,Field_Name__c from ASC_GSPFieldMetadata__mdt]){            
            gspAttrMDMap.put(mdt.Attribute_Name__c,mdt.Field_Name__c);
        }
        
        for(ASC_Group_Specific_Pricing__c gs : gspVa){
            for(string atrcde : gspAttrMDMap.keyset()){
                string gspVL = string.valueof(gs.get(gspAttrMDMap.get(atrcde)));
                if(gspVL!=NULL){gsp.put(gs.ASC_Product_Code__c+'.'+atrcde,gspVL);}
            }
        }        
        attrCli(plns);                       
        output.put('userInputs',gsp);
    }
   
    public static void attrCli(list<vlocity_ins__ContractLineItem__c> plans){

        String fldtype;
        String lProdcode;
        String lProdName = '';
        set<Id> lieIds = new set<Id>();
        map<string,object> mp = new map<string,object>();
        set<string> rtnPrdcodes = new set<string>();
        String attrJson;
        Map<String,ASC_Line_Item_Extensions__mdt> mdataMap = new Map<String,ASC_Line_Item_Extensions__mdt>();
        
        for(ASC_Line_Item_Extensions__mdt lItem:[Select Id,ASC_Input_Field_Name__c,
                                                 ASC_Input_JsonField__c,
                                                 ASC_Field_Type__c,
                                                 ASC_Non_Retain_Product_Data__c
                                                 from ASC_Line_Item_Extensions__mdt 
                                                 
                                                 LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){            
            mdataMap.put(lItem.ASC_Input_JsonField__c,lItem);
        }
        
        for(Product2 prd: [select id, Productcode, Recordtype.name, ASC_Retain_PY_Price__c, 
                           ASC_Annual_Product__c, Name from Product2 
                           where ASC_Retain_PY_Price__c = true 
                           AND Recordtype.name = 'Coverage Spec'
                           AND IsActive = true
                           LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){                               
            rtnPrdcodes.add(prd.Productcode);
        }
                
        for(vlocity_ins__ContractLineItem__c pln:plans){
            if(pln.ASC_Line_Item_Extension__c != NULL){
                lieIDs.add(pln.ASC_Line_Item_Extension__c);
            }
        }        
                  
        if(!lieIDs.isEmpty()){
            for(Line_Item_Extension__c lie:[select id,name,Account__c,                                      
                                            Feed_Direction__c,Original_SL_Identifier_Data__c,Product__r.Name,Product__r.productcode,Claims_Covered__c,SL_Identifier__c,Rx_Option__c,
                                            Self_Billed_Notes__c,DataFeed_Type__c,Tier__c,Lead_Time__c,TPDP_Agency__c,Opt_In_Indicator__c,Miscellaneous_Rationale__c,Line_of_Business__c,
                                            Vendor__c,Band__c,Original_SL_Identifier__c, Self_Billed_Fees__c,Platform__c,Type__c,Activation_Type__c,SL_Identifier_Data__c,
                                            Unit_Price_Not_LT__c, Original_Total_SL_Premium__c,Quantity__c,Original_Refund_Percent__c,Original_Volume__c,Original_Fee_Amount__c,Original_Third_Year_Rate_Cap__c,
                                            CRED_CLMS__c,Agency_Pass_Thru_Fee__c,Original_Cost_Share_Maximum__c,Cost_Share_Maximum__c,CRED_CLMS_Facility__c,Original_Hospital_Advance__c,
                                            Original_Late_Payment_Charge__c,Level_Payment_Claims_Amount__c,Original_Rate_Cap__c,Monthly_Cap_Amount__c,Invoicing_Contracts__c,Second_Year_Rate_Cap__c,
                                            Third_Year_Rate_Cap__c,Advance_Days__c,Original_Advance_Deposit__c,Aggregate_Min_Attachment_Point__c,Original_Fee_Not_LT_PCPM__c,Original_Cost_Share_Percent__c,
                                            Original_Attachment_Point__c,Fee_Amount__c,AWP_1__c,Total_Stop_Loss_Premium__c,Provider_Contract_Interest__c,AWP_2__c,K_Adv_Deposit__c,Deductible__c,Original_of_Care_Mgmt_Engagement__c,Original_Member_Satisfaction__c,Member_Satisfaction__c,
                                            Original_Second_Year_Rate_Cap__c,Original_Minimum__c,Percent_of_Claims__c,Late_Charge__c,Admin_Credit__c,Attachment_Point__c,Original_Price__c,Original_Overall_Managed_Rate__c,Overall_Managed_Rate__c,of_Care_Mgmt_Engagement__c,
                                            Minimum__c,Original_Fourth_Year_Rate_Cap__c,Fourth_Year_Rate_Cap__c,UnitPrice__c,Refund_Percent__c,Original_Deductible__c,Carrier_Retention_Percentage__c,
                                            Rate_Cap__c,Unit_Price_Not_GT__c,Hosp_Ad_Dep__c,Original_Fee_Not_GT_PCPM__c,Original_AAC_PCNT__c,Cost_Share_Percent__c,AAC_PCNT__c,Original_Level_Payment_Claims_Amount__c,
                                            Original_Percent_of_Claims__c,Percent_of_Coupon_Savings__c,Original_Provider_Contract_Interest__c,Original_Monthly_Cap_Amount__c,Original_Min_Aggregate_Attachment_Point__c,
                                            Original_Retention__c,AAC_Type_of_Claims__c,Original_AAC_Type_of_Claims__c,Implementation_Fee__c,Effective_End_Date__c,Effective_Start_Date__c,Coverage_Elected__c,
                                            Benchmark_Pricing__c,Mixed_Billed_Fee__c,Mixed_Billed_Type__c,Original_Mixed_Billed_Type__c,Original_Mixed_Billed_Fee__c,Comments__c,Hospital_Facility__c,Original_Claims_Covered__c,Original_SL_Line_of_Business__c,Product__r.ASC_Annual_Product__c from Line_Item_Extension__c where Id IN:lieIDs                                        
                                            LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                                                
                                            for(string mdt : mdataMap.keyset()){
                                              if(rtnPrdcodes.Contains(lie.Product__r.productcode) 
                                                && !'ASC_Sales_Volume'.equals(mdt) && !'ASC_UnitVolume'.equals(mdt)){
                                                                                                 
                                                    lProdcode = lie.Product__r.productcode;
                                                    String lieVal = String.valueof(lie.get(mdataMap.get(mdt).ASC_Input_Field_Name__c));                                                    

                                                    if(lieVal!=NULL){
                                                    gsp.put(lProdcode+'.'+mdt,lieVal);
                                                       if(lie.Product__r.ASC_Annual_Product__c == false){//updating the data format for multi year products to remove 00:00:00 in the end
                                                            String effStartDate =  String.valueOf(lie.get(mdataMap.get('ASC_EffectiveStartDate').ASC_Input_Field_Name__c)).removeEnd(' 00:00:00');
                                                            String effEndDate =  String.valueOf(lie.get(mdataMap.get('ASC_EffectiveEndDate').ASC_Input_Field_Name__c)).removeEnd(' 00:00:00');                                                        
                                                            gsp.put(lProdcode+'.'+'ASC_EffectiveStartDate',effStartDate);
                                                            gsp.put(lProdcode+'.'+'ASC_EffectiveEndDate',effEndDate);
                                                        }
                                                    }                    
                                                }
                                                else{
                                                  
                                                    lProdcode = lie.Product__r.productcode;
                                                    if(mdataMap.get(mdt).ASC_Non_Retain_Product_Data__c){
                                                    String lieVal = String.valueof(lie.get(mdataMap.get(mdt).ASC_Input_Field_Name__c));
                                                    if(lieVal!=NULL){
                                                    gsp.put(lProdcode+'.'+mdt,lieVal);
                                                    }                   
                                                    }                                                                                 
                                                }     
                                                if('ASC_Activation_Type'.equals(mdt)){
                                                    gsp.put(lProdcode+'.'+mdt,'Renewal');
                                                }                                           
                                            }                                                                                                                                                               
            }
        }
    }   
}