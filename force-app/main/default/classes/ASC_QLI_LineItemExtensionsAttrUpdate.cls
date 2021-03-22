/**********************************************************************************************************************************************
@Author : Dinesh/Harsha
@Name: ASC_QLI_LineItemExtensionsAttrUpdate
@CreatedDate:  15-May-2020 
@Description: ASC_QLI_LineItemExtensionsAttrUpdate class is used update the data from the Attributed Selected Values.
@version : 1.0  
@US Number: US-2922

---Modified --
@US3193 Added By Dinesh- update the LIE RecordType when quote is created/updated - 06/24/2020
@US2184 Added logic to populate invoicing price when pricing method is not PMPM- Harsha - 07/01/2020
@US2203 Added logic to update FLAT/BLENDED values in ASC_Invoice_Exceptions__c field on quote - Dinesh - 08/22/2020
****************************************************************************************************************************************************/
global without sharing class ASC_QLI_LineItemExtensionsAttrUpdate implements vlocity_ins.VlocityOpenInterface2 {

    private static final String DATETIME_TYPE = 'DateTime';
    private static final String DATE_TYPE = 'Date';
    private static final String CHECKBOX_TYPE = 'CheckBox';
    private static final String OTHER_TYPE = 'Other';
    private static final String TEXT_TYPE = 'Text';
    private static final String LOOKUP_TYPE = 'Lookup';
    private static final String QUOTEID = 'quoteId';
    private static final String UPDTQLI_LIE = 'updtQLILineItemExtension';
    private static final String ASCPRODUCT = 'ASC Product';
    private static final String NONBENEFIT = 'Non-Benefit';
    private static final string CLASSNAME  ='ASC_QLI_LineItemExtensionsAttrUpdate';
    private static final string METHODNME  ='updtQLILineItemExtension';
    private static final string STR_EMPTY = '';
    private static final string PRICINGMETHOD='ASC_PricingMethod';
    private static final string SALESVOLUME='ASC_Sales_Volume';
    private static final string INVOICINGCONTRACTS='ASC_Invoicing_Contracts';
    private static final string PMPM='PMPM';
    private static final string LIE_DEFAULT_RECTYPE_ADMINFEES = 'LIE_Admin_Fees_Products';
    private static final Integer NUM_ZERO = 0;
    private static final String STR_ZERO = '0';
    public static Boolean isLIERecTypeUpdated = false;
    public static Boolean isquoteUpdated = false;
    private static final String UNDERSCORE = '_';    
    public static String FLAT = 'Flat';
    public static String BLENDED = 'Blended';
    public static String MIXEDBILLEDFLAT = 'Mixed Billed - Flat';
    public static String MIXEDBILLEDBLENDED = 'Mixed Billed - Blended';
    public static String ASC_INVOICE_EXCEPTIONS = 'ASC_Invoice_Exceptions__c';
    public static String ASC_MIXED_BILLED_TYPE = 'ASC_Mixed_Billed_Type';
    private static final string SEMI_COLON = ';';
    private static final string NA = 'N/A';
    private static final string QUOTNAME = 'Name';
    private static final string ASCQUOTE = 'ASCQuote';
    private static final string HYPSYM = '-';
    private static final String FIXEDADMINFEE_PRDCODE = 'ASC_0000005';
    private static final String VARADMINFEE_PRDCODE = 'ASC_0000370';
    private static final String CONTRACTID = 'contractId';
    private static final String PRDCODENPPNP = 'ASC_0000143';
    private static final String ASCSALESRETENTION = 'ASC_Sales_Retention';
    private static final String NEWSTATUS = 'New';
    private static final String EFFECTIVESTARTDATE = 'ASC_EffectiveStartDate';
    private static final String EFFECTIVEENDDATE = 'ASC_EffectiveEndDate';
    private static final String PRICINGTYPE ='ASC_PricingType';
    private static final String DATAFEEDS ='Data Feeds';
    private static final string VALUE_YES = 'Yes';

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
            if(UPDTQLI_LIE.equals(methodName)){
                return updtQLILineItemExtension(input,output,options);                                 
            }
        }
        catch(exception e){   
          GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNME);
                   }        
        return true;
    } 
    /********************************************************************************************************************
    @Description        :   This method is used to update the Attributed Selected Values information in both the QLI and Line Extension records
    @Name               :   updtQLILineItemExtension
    @Param              :   Map<String, Object> input, Map<String, Object> output
    @Return             :   Boolean
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/           
     global static Boolean updtQLILineItemExtension(Map<String, Object> input,
                                                  Map<String, Object> output,Map<String,Object> options){     
        String quoteId = (String)input.get(QUOTEID);
        List<Quote> qtList = new List<Quote>();
            Map<String,String> prdIdMap = new Map<String,String>();       
        for(Product2 prdRec:[Select Id,Name,ProductCode from Product2 WHERE vlocity_ins__LineOfBusiness__c =:NONBENEFIT 
                             AND vlocity_ins__SubType__c =:ASCPRODUCT
                             AND vlocity_ins__Type__c =:ASCPRODUCT
                             Limit :UTIL_SLB.retrieveQueryLimitValue()]){
            prdIdMap.put(prdRec.ProductCode,prdRec.Id);
        }
        String attrJson = STR_EMPTY;
        Map<String,Object> recordAttributes = new Map<String,Object>();
        Map<String,ASC_Line_Item_Extensions__mdt> lineExtMap = new Map<String,ASC_Line_Item_Extensions__mdt>();
        Map<String,ASC_QLI_Attributes_Update__mdt> qLImdtMap = new Map<String,ASC_QLI_Attributes_Update__mdt>();

        List<Line_Item_Extension__c> lItemExtList = new List<Line_Item_Extension__c>();
        Line_Item_Extension__c lItemExt = new Line_Item_Extension__c();
              List<Quote> quot = [Select Id,ASC_Invoice_Exceptions__c,ASC_CID__c,ASC_Carrier__c,QuoteNumber
                            from Quote where Id =:quoteId LIMIT 1];
                            
        for(ASC_Line_Item_Extensions__mdt lItem:[Select Id,ASC_Input_Field_Name__c,ASC_Input_JsonField__c,
                                                    ASC_Field_Type__c from ASC_Line_Item_Extensions__mdt
                                                    Limit :UTIL_SLB.retrieveQueryLimitValue()]){            
            lineExtMap.put(lItem.ASC_Input_JsonField__c,lItem);
        }  
        for(ASC_QLI_Attributes_Update__mdt qLI:[Select Id,ASC_Input_Field_Name__c,ASC_Input_JsonField__c,
                                                    ASC_Field_Type__c from ASC_QLI_Attributes_Update__mdt
                                                    Limit :UTIL_SLB.retrieveQueryLimitValue()]){            
            qLImdtMap.put(qLI.ASC_Input_JsonField__c,qLI);
        }   

        List<quotelineitem> qLIList = [Select Id,ASC_Percent_of_Claims__c,Product2.Id,Product2.Name,Product2.ASC_LIE_RecordType__c,
                                       ASC_AAC_PCNT__c,ASC_Account__c,vlocity_ins__AttributeSelectedValues__c,
                                       ASC_Line_Item_Extension__c,ASC_Effective_Start_Date__c,
                                       ASC_Effective_End_Date__c,
                                       quote.vlocity_ins__EffectiveDate__c,
                                       quote.vlocity_ins__EndDate__c,                                       
                                       quote.Status,Product2.ASC_Annual_Product__c,
                                       quote.ASC_Invoice_Exceptions__c from QuoteLineItem where quoteId =:quoteId 
                                       Limit :UTIL_SLB.retrieveQueryLimitValue()]; 
                                                                              
        String ctrcID = string.valueOf(options.get(CONTRACTID));
        Map<String,Object> recordAttributesplan = new Map<String,Object>();
        list<vlocity_ins__ContractLineItem__c> plns = [select id,vlocity_ins__Product2Id__c,vlocity_ins__ProductCode__c,
                                                       vlocity_ins__AttributeSelectedValues__c,
                                                       ASC_Line_Item_Extension__c from 
                                                       vlocity_ins__ContractLineItem__c where 
                                                       vlocity_ins__Product2Id__r.ProductCode =:PRDCODENPPNP
                                                                                                         AND vlocity_ins__ContractId__c = :ctrcID LIMIT 1];

        String attrJsonplan;      
        Integer salesRetention;                                         
        if(!plns.isEmpty()){
            for(vlocity_ins__ContractLineItem__c plan : plns){
                if(plan.vlocity_ins__AttributeSelectedValues__c !=null){
                attrJsonplan = plan.vlocity_ins__AttributeSelectedValues__c; 
                recordAttributesplan = (Map<String,Object>)json.deserializeuntyped(attrJsonplan);                
                for(String recordAttribute : recordAttributesplan.keyset()){                                                          
                      if(ASCSALESRETENTION.equals(recordAttribute)){                      
                       salesRetention = Integer.valueof(recordAttributesplan.get(ASCSALESRETENTION));                       
                      }
                }  
            }
            break;
            }
        }
                
        if(!qLIList.isEmpty()){
            for(quotelineitem qLI : qLIList){
                if(qLI.vlocity_ins__AttributeSelectedValues__c !=null){
                attrJson = qLI.vlocity_ins__AttributeSelectedValues__c; 

                    recordAttributes = (Map<String,Object>)json.deserializeuntyped(attrJson);        
                    if(qLI.Product2.ASC_Annual_Product__c && NEWSTATUS.equals(qLI.quote.Status)){
                    recordAttributes.put(EFFECTIVESTARTDATE,String.ValueOf(qLI.quote.vlocity_ins__EffectiveDate__c));
                    recordAttributes.put(EFFECTIVEENDDATE,String.ValueOf(qLI.quote.vlocity_ins__EndDate__c));
                    qLI.vlocity_ins__AttributeSelectedValues__c = JSON.serialize(recordAttributes);
                    }    
                                 
                    lItemExt = new Line_Item_Extension__c();
                    lItemExt.Id = qLI.ASC_Line_Item_Extension__c;
                    lItemExt.Name = qLI.Product2.Name;
                    lItemExt.Product__c = qLI.Product2.Id;
                    lItemExt.QLI_ID__c = qLI.Id; 
                    lItemExt.Quote_Line_Item__c = qLI.Id;
                    lItemExt.Account__c = qLI.ASC_Account__c;                    
                    /* US3193 Added By Dinesh -Start update the LIE RecordType when quote is created/updated*/                        
                    lItemExt.RecordTypeId = String.isNotBlank(qLI.Product2.ASC_LIE_RecordType__c) ?
                                            Schema.SObjectType.Line_Item_Extension__c.getRecordTypeInfosByDeveloperName().
                                            get(qLI.Product2.ASC_LIE_RecordType__c).getRecordTypeId():
                                            Schema.SObjectType.Line_Item_Extension__c.getRecordTypeInfosByDeveloperName().
                                            get(LIE_DEFAULT_RECTYPE_ADMINFEES).getRecordTypeId();                                                        
                    /* US3193 - End */
                    for(String recordAttribute : recordAttributes.keyset()){                                                          
                    
                            //QLI metadata updates
                            if(qLImdtMap.ContainsKey(recordAttribute) &&
                               recordAttributes.get(recordAttribute) !=null &&
                               DATETIME_TYPE.equals(qLImdtMap.get(recordAttribute).ASC_Field_Type__c) 
                              ){ 
                                 String strdt = String.valueOf(recordAttributes.get(recordAttribute));
                                 DateTime finaldtTimeList = DateTime.valueOf(strdt);
                                 qLI.put(qLImdtMap.get(recordAttribute).ASC_Input_Field_Name__c,finaldtTimeList);
                            }
                            if(qLImdtMap.ContainsKey(recordAttribute) &&
                               recordAttributes.get(recordAttribute) !=null &&
                               DATE_TYPE.equals(qLImdtMap.get(recordAttribute).ASC_Field_Type__c) 
                              ){ 
                                 String strdt = String.valueOf(recordAttributes.get(recordAttribute));                                    
                                 Date finalDtList = Date.valueOf(strdt);                               
                                 qLI.put(qLImdtMap.get(recordAttribute).ASC_Input_Field_Name__c,finalDtList);
                            }                       
                            if(qLImdtMap.ContainsKey(recordAttribute) &&
                               recordAttributes.get(recordAttribute) !=null &&
                               TEXT_TYPE.equals(qLImdtMap.get(recordAttribute).ASC_Field_Type__c) 
                              ){                
                                 String finalStr = String.ValueOf(recordAttributes.get(recordAttribute));                                                                                                                                                                                                            
                                 qLI.put(qLImdtMap.get(recordAttribute).ASC_Input_Field_Name__c,finalStr);                                  
                            }
                            if(qLImdtMap.ContainsKey(recordAttribute) &&
                               recordAttributes.get(recordAttribute) !=null &&
                               LOOKUP_TYPE.equals(qLImdtMap.get(recordAttribute).ASC_Field_Type__c) &&
                               (recordAttributes.get(recordAttribute) != NUM_ZERO
                                && recordAttributes.get(recordAttribute) != STR_ZERO
                               )
                              ){           
                                 String finalStr = String.ValueOf(recordAttributes.get(recordAttribute));
                                 Id finalIdList = Id.ValueOf(finalStr);                                                                                                                                                                                                                                               
                                 qLI.put(qLImdtMap.get(recordAttribute).ASC_Input_Field_Name__c,finalIdList);                                  
                            }
                            if(qLImdtMap.ContainsKey(recordAttribute) &&
                               recordAttributes.get(recordAttribute) !=null &&
                               OTHER_TYPE.equals(qLImdtMap.get(recordAttribute).ASC_Field_Type__c)
                              ){                                                                                                                         
                                 String finalStr = String.ValueOf(recordAttributes.get(recordAttribute));                              
                                 Decimal finalDecList = Decimal.ValueOf(finalStr);                                                                                                                                                                                                                     
                                 qLI.put(qLImdtMap.get(recordAttribute).ASC_Input_Field_Name__c,finalDecList);
                       
                            } 
                            if(qLImdtMap.ContainsKey(recordAttribute) &&
                               recordAttributes.get(recordAttribute) !=null &&
                               CHECKBOX_TYPE.equals(qLImdtMap.get(recordAttribute).ASC_Field_Type__c) 
                              ){
                                Boolean finalboolList = Boolean.ValueOf(recordAttributes.get(recordAttribute));                              
                                qLI.put(qLImdtMap.get(recordAttribute).ASC_Input_Field_Name__c,finalboolList);
                            }                           
                            
                            //LineItem Extension metadata updates                                                                                 
                            if(lineExtMap.ContainsKey(recordAttribute) &&
                               recordAttributes.get(recordAttribute) !=null &&
                               DATETIME_TYPE.equals(lineExtMap.get(recordAttribute).ASC_Field_Type__c) 
                              ){ 
                                 String strdt = String.valueOf(recordAttributes.get(recordAttribute));
                                 DateTime finaldtTimeList = DateTime.valueOf(strdt);
                                 lItemExt.put(lineExtMap.get(recordAttribute).ASC_Input_Field_Name__c,finaldtTimeList);
                            }
                            if(lineExtMap.ContainsKey(recordAttribute) &&
                               recordAttributes.get(recordAttribute) !=null &&
                               DATE_TYPE.equals(lineExtMap.get(recordAttribute).ASC_Field_Type__c) 
                              ){ 
                                String strdt = String.valueOf(recordAttributes.get(recordAttribute));                                    
                                Date finalDtList = Date.valueOf(strdt);                                
                                lItemExt.put(lineExtMap.get(recordAttribute).ASC_Input_Field_Name__c,finalDtList);
                            }                               
                            if(lineExtMap.ContainsKey(recordAttribute) &&
                               recordAttributes.get(recordAttribute) !=null &&
                               TEXT_TYPE.equals(lineExtMap.get(recordAttribute).ASC_Field_Type__c)                               
                              ){   
                                String finalStr = String.ValueOf(recordAttributes.get(recordAttribute));    
                                if(!ASC_MIXED_BILLED_TYPE.equals(recordAttribute)){  //Added By Dinesh - 2203  - if condition                                                                                                                                                                      
                                  lItemExt.put(lineExtMap.get(recordAttribute).ASC_Input_Field_Name__c,finalStr);
                                }
                                if(ASC_MIXED_BILLED_TYPE.equals(recordAttribute) 
                                  && recordAttributes.get(ASC_MIXED_BILLED_TYPE) !=null ){  //Added By Dinesh - 2203  - if condition       
                                  String mixedBillType = String.ValueOf(recordAttributes.get(ASC_MIXED_BILLED_TYPE));                                                                                                                                                               
                                  lItemExt.put(lineExtMap.get(ASC_MIXED_BILLED_TYPE).ASC_Input_Field_Name__c,mixedBillType);
                                }
                            }                                                           
                            if(lineExtMap.ContainsKey(recordAttribute) &&
                               recordAttributes.get(recordAttribute) !=null &&
                               OTHER_TYPE.equals(lineExtMap.get(recordAttribute).ASC_Field_Type__c)
                              ){
                              
                              if(NEWSTATUS.equals(qLI.quote.Status) && salesRetention !=null){
                              
                                recordAttributes.put(ASCSALESRETENTION,salesRetention);
                                qLI.vlocity_ins__AttributeSelectedValues__c = JSON.serialize(recordAttributes);
                              
                                String finalStr = String.ValueOf(recordAttributes.get(recordAttribute));                              
                                Decimal finalDecList = Decimal.ValueOf(finalStr);                                                                                                                                                                                                                         
                                //Added logic to populate invoicing price when pricing method is not PMPM(US#2184): Harsha
                                lItemExt.put(lineExtMap.get(recordAttribute).ASC_Input_Field_Name__c,finalDecList);                                
                                if(!PMPM.equals(recordAttributes.get(PRICINGMETHOD)) && recordAttributes.get(SALESVOLUME) !=null){
                                 String finalStrUnitVol = String.ValueOf(recordAttributes.get(SALESVOLUME));                              
                                 Decimal unitVol = Decimal.ValueOf(finalStrUnitVol);                                                                                                                                                                                                                     
                                 lItemExt.put(lineExtMap.get(INVOICINGCONTRACTS).ASC_Input_Field_Name__c,unitVol);
                                }    
                                //End Logic:Harsha
                               }
                               else{
                                String finalStr = String.ValueOf(recordAttributes.get(recordAttribute));                              
                                Decimal finalDecList = Decimal.ValueOf(finalStr);                                                                                                                                                                                                                         
                                //Added logic to populate invoicing price when pricing method is not PMPM(US#2184): Harsha
                                lItemExt.put(lineExtMap.get(recordAttribute).ASC_Input_Field_Name__c,finalDecList);      
                                   //Added Bypass logic for datafeeds products Defect#1131                    
                                if(!PMPM.equals(recordAttributes.get(PRICINGMETHOD)) && recordAttributes.get(SALESVOLUME) !=null  && (recordAttributes.get(PRICINGTYPE)!=DATAFEEDS ) && (recordAttributes.get(INVOICINGCONTRACTS))==null){
                                 String finalStrUnitVol = String.ValueOf(recordAttributes.get(SALESVOLUME));                              
                                 Decimal unitVol = Decimal.ValueOf(finalStrUnitVol);                                                                                                                                                                                                                     
                                 lItemExt.put(lineExtMap.get(INVOICINGCONTRACTS).ASC_Input_Field_Name__c,unitVol);
                                }
                                }
                               //End Logic:Harsha
                            }
                            if(lineExtMap.ContainsKey(recordAttribute) &&
                               recordAttributes.get(recordAttribute) !=null &&
                               CHECKBOX_TYPE.equals(lineExtMap.get(recordAttribute).ASC_Field_Type__c) 
                              ){
                                Boolean finalboolList = Boolean.ValueOf(recordAttributes.get(recordAttribute));                              
                                lItemExt.put(lineExtMap.get(recordAttribute).ASC_Input_Field_Name__c,finalboolList);
                            }                                         
                    }                        
                    lItemExtList.add(lItemExt);                                        
               }
             }       
         }
         
         if(!lItemExtList.isEmpty()){
           isLIERecTypeUpdated = true;
           Upsert lItemExtList;
         }
                  
         Set<String> mixedBillTypeSet = new Set<String>();
         Map<String,Line_Item_Extension__c> lItemExtIDMap = new  Map<String,Line_Item_Extension__c>();      
         Map<String,Boolean> varianceUpdtMap = new Map<String,Boolean>();
         
         List<Line_Item_Extension__c> lieList = new List<Line_Item_Extension__c>();
         if(!lItemExtList.isEmpty()){
             for(Line_Item_Extension__c  li : [Select Id,Quote_Line_Item__c,Product__r.ProductCode,Mixed_Billed_Type__c,  
                                               Product_Approval__c,
                                               Product__r.ASC_Pilot_Activation__c,                                                                                                                                                                                          
                                               UnitPrice__c,Original_Price__c,
                                               Quantity__c,Original_Volume__c,                                                                                              
                                               ProductCode__c,LOU_Signed__c,                                                                                             
                                               Feed_Direction__c,Original_SL_Identifier_Data__c,Product__r.Name,Claims_Covered__c,SL_Identifier__c,Rx_Option__c,
                                               Self_Billed_Notes__c,DataFeed_Type__c,Tier__c,Lead_Time__c,TPDP_Agency__c,Opt_In_Indicator__c,Miscellaneous_Rationale__c,Line_of_Business__c,
                                               Vendor__c,Band__c,Original_SL_Identifier__c, Self_Billed_Fees__c,Platform__c,Type__c,Activation_Type__c,SL_Identifier_Data__c,
                                               Unit_Price_Not_LT__c, Original_Total_SL_Premium__c,Original_Refund_Percent__c,Original_Fee_Amount__c,Original_Third_Year_Rate_Cap__c,
                                               CRED_CLMS__c,Agency_Pass_Thru_Fee__c,Original_Cost_Share_Maximum__c,Cost_Share_Maximum__c,CRED_CLMS_Facility__c,Original_Hospital_Advance__c,
                                               Original_Late_Payment_Charge__c,Level_Payment_Claims_Amount__c,Original_Rate_Cap__c,Monthly_Cap_Amount__c,Invoicing_Contracts__c,Second_Year_Rate_Cap__c,
                                               Third_Year_Rate_Cap__c,Advance_Days__c,Original_Advance_Deposit__c,Aggregate_Min_Attachment_Point__c,Original_Fee_Not_LT_PCPM__c,Original_Cost_Share_Percent__c,
                                               Original_Attachment_Point__c,Fee_Amount__c,AWP_1__c,Total_Stop_Loss_Premium__c,Provider_Contract_Interest__c,AWP_2__c,K_Adv_Deposit__c,Deductible__c,Original_of_Care_Mgmt_Engagement__c,Original_Member_Satisfaction__c,Member_Satisfaction__c,
                                               Original_Second_Year_Rate_Cap__c,Original_Minimum__c,Percent_of_Claims__c,Late_Charge__c,Admin_Credit__c,Attachment_Point__c,Original_Overall_Managed_Rate__c,Overall_Managed_Rate__c,of_Care_Mgmt_Engagement__c,
                                               Minimum__c,Original_Fourth_Year_Rate_Cap__c,Fourth_Year_Rate_Cap__c,Refund_Percent__c,Original_Deductible__c,Carrier_Retention_Percentage__c,
                                               Rate_Cap__c,Unit_Price_Not_GT__c,Hosp_Ad_Dep__c,Original_Fee_Not_GT_PCPM__c,Original_AAC_PCNT__c,Cost_Share_Percent__c,AAC_PCNT__c,Original_Level_Payment_Claims_Amount__c,
                                               Original_Percent_of_Claims__c,Percent_of_Coupon_Savings__c,Original_Provider_Contract_Interest__c,Original_Monthly_Cap_Amount__c,Original_Min_Aggregate_Attachment_Point__c,
                                               Original_Retention__c,AAC_Type_of_Claims__c,Original_AAC_Type_of_Claims__c,Implementation_Fee__c,Effective_End_Date__c,Effective_Start_Date__c,Coverage_Elected__c,
                                               Benchmark_Pricing__c,Mixed_Billed_Fee__c,Original_Mixed_Billed_Type__c,Original_Mixed_Billed_Fee__c,Comments__c,Hospital_Facility__c,Original_Claims_Covered__c,Original_SL_Line_of_Business__c,
                                               Create_Lead_Time_Approval_Task__c
                                                                                                          
                                               from Line_Item_Extension__c where ID IN:lItemExtList
                                               Limit :UTIL_SLB.retrieveQueryLimitValue()]) {
                    lItemExtIDMap.put(li.Quote_Line_Item__c,li);

                    /*D-1697 - Added By Dinesh - Start - Mixed Bill Type update on Invoice Exceptions */                    
                    if(FLAT.equals(li.Mixed_Billed_Type__c) && (FIXEDADMINFEE_PRDCODE.equals(li.Product__r.ProductCode) || VARADMINFEE_PRDCODE.equals(li.Product__r.ProductCode))){
                       mixedBillTypeSet.add(MIXEDBILLEDFLAT);
                    }
                    if(BLENDED.equals(li.Mixed_Billed_Type__c) && (FIXEDADMINFEE_PRDCODE.equals(li.Product__r.ProductCode) || VARADMINFEE_PRDCODE.equals(li.Product__r.ProductCode))){
                       mixedBillTypeSet.add(MIXEDBILLEDBLENDED);
                    }
                    /*D-1697 - Added By Dinesh - End*/
                                                                               
                    lieList.add(li);
             }         
         }
         
         Map<String,boolean> resultMap = ASC_ProductTeamApproval.getApprovalNeeded(lieList);
         
         /*D-1697 - Added By Dinesh - Start - Mixed Bill Type update on Invoice Exceptions */ 
         List<String> invoiceExcepList = new List<String>();
         if(String.isNotBlank(quot[0].ASC_Invoice_Exceptions__c)){
            invoiceExcepList = quot[0].ASC_Invoice_Exceptions__c.split(SEMI_COLON);   
         }                                              
         if(invoiceExcepList.Contains(MIXEDBILLEDBLENDED) && !mixedBillTypeSet.Contains(MIXEDBILLEDBLENDED)){
         invoiceExcepList.remove(invoiceExcepList.indexOf(MIXEDBILLEDBLENDED));                                         
         }
         if(invoiceExcepList.Contains(MIXEDBILLEDFLAT) && !mixedBillTypeSet.Contains(MIXEDBILLEDFLAT)){
         invoiceExcepList.remove(invoiceExcepList.indexOf(MIXEDBILLEDFLAT));
         }              
         if(!mixedBillTypeSet.isEmpty()){                     
             for(String billType: mixedBillTypeSet){      
                if(!invoiceExcepList.Contains(billType)){                           
                  invoiceExcepList.add(billType);
                }
             }             
         }
         String invEx  = String.join(invoiceExcepList,';');
         if(String.isNotBlank(invEx)){
         quot[0].put(ASC_INVOICE_EXCEPTIONS,invEx);
         }
         /*D-1697 - Added By Dinesh - End */
                           
         if(!qLIList.isEmpty() && lItemExtIDMap !=null){
            for(quotelineitem qLI : qLIList){            
              if(lItemExtIDMap.ContainsKey(qLI.Id)
                   && lItemExtIDMap.get(qLI.Id) !=null               
              ){
                System.debug('*****'+qLI.Id); 
                qLI.ASC_Line_Item_Extension__c = lItemExtIDMap.get(qLI.Id).Id;
                qLI.ASC_Last_Price_Modified_Date__c = null;
                
                if(resultMap !=null && resultMap.ContainsKey(qLI.Id) && resultMap.get(qLI.Id)){
                qLI.ASC_Pricing_Variance__c = resultMap.get(qLI.Id);                
                }
                if(VALUE_YES.equals(lItemExtIDMap.get(qLI.Id).Product__r.ASC_Pilot_Activation__c) 
                   && resultMap !=null 
                   && resultMap.ContainsKey(qLI.Id) && resultMap.get(qLI.Id)){
                qLI.ASC_Variance_For_Approval__c = true;
                }
                else if(VALUE_YES.equals(lItemExtIDMap.get(qLI.Id).Product__r.ASC_Pilot_Activation__c) 
                   && lItemExtIDMap.get(qLI.Id).Product_Approval__c){
                qLI.ASC_Variance_For_Approval__c = true;
                }
                else if(VALUE_YES.equals(lItemExtIDMap.get(qLI.Id).Product__r.ASC_Pilot_Activation__c)
                   && lItemExtIDMap.get(qLI.Id).Create_Lead_Time_Approval_Task__c){
                qLI.ASC_Variance_For_Approval__c = true;
                }                
               }            
            }
         }   
         if(quot[0] !=null){/*Added By Dinesh -US 2203-*/
           quot[0].put(QUOTNAME,ASCQUOTE+HYPSYM+ quot[0].ASC_CID__c +HYPSYM+ quot[0].ASC_Carrier__c +HYPSYM +quot[0].QuoteNumber); //TD-1249 - Added By Dinesh - Update Quote Name ,WF Rule - 'ASC_QUOTE_WF_01_QuotenamngConvntion' has been deactivated to avoid recursion
           quot[0].ByPass_QuoteName_Updt__c = true;
           Update quot[0];
         }         
         if(!qLIList.isEmpty()){
           Update qLIList;
         } 
         Update quot;
         return true;                  
   }        
}