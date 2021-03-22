/**************************************************************
Class Name   : ASC_GetGSPriceJson
Description  : Calculate the Pricing or Underwritten Products from Group Sepecific Pricing table.
**************************************************************/
global with sharing class ASC_GetGSPriceJson implements vlocity_ins.VlocityOpenInterface2{
    public static final string ASC_EffectiveStartDate = '.ASC_EffectiveStartDate';
    public static final string MTHDNAMEGETUS = 'getUnitpriceJSon';
    public static final string CLSNAME = 'ASC_GetGSPriceJson';
    public static final string ERRORMSG = 'Error';
    public static final string PRODCODE='ASC_0000005';
    public static final string ASC_EffectiveEndDate = '.ASC_EffectiveEndDate';
    //public static final string ASC_EffectiveEndDate = '.ASC_EffectiveEndDate';
    public static final string UNITVOLUME='ASC_UnitVolume';
    public static final string ESTIMATEDVOLUME='EstimatedVolume';
    public static final string SALESVOLUME='ASC_Sales_Volume';
    public static final string NEWSTATUS='New';
    public static final string COVERAGESPEC='Coverage Spec';
    public static final string ASCPRODUCT= 'ASC Product';
    public static final string NONBENEFIT= 'Non-Benefit';
    public static final string QUOTECHAR='0Q0';
    public static final string DOTCHAR='.';
    public static final string INVOICINGCONTRACTS='ASC_Invoicing_Contracts';
    
    public static final map<string,string> gsp = new map<string,string>();
    public static string QUOTEID;  
    public static final string CONTEXTID = 'ContextId';
    public static string Accname;
    public static string carrier;
    public static string effDate;
    public static string effDateFormat;
    public static string endDate;
    public static string subSegment;
    public static string AccCQ;
    public static string AccEQ;
    private static final String STRING_EMPTY = '';      
    /***************************************************************************************************  
Method name : invokeMethod
Param 1     : inputMap, outputMap and Options
Return Type : void
Description : To invoke the method called from Remote Action
****************************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) 
    {      
        try{
            if(MTHDNAMEGETUS.equalsIgnoreCase(methodName)){    
                getUnitpriceJSon(input, output);
            }
        }
        catch(exception e){          
            system.debug('line number@@ '+e.getLineNumber());
            system.debug('getMessage @@ '+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDNAMEGETUS);
            throw new AuraHandledException(ERRORMSG+ARV_AP41_StringLiteralUtils.COLONVAL+e.getMessage()); }
			
			try{
            if('getUnitVolume'.equalsIgnoreCase(methodName)){    
                getUnitVolume(input, output);
            }
        }
        catch(exception e){          
            system.debug('line number@@ '+e.getLineNumber());
            system.debug('getMessage @@ '+e.getMessage());
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDNAMEGETUS);
            throw new AuraHandledException(ERRORMSG+ARV_AP41_StringLiteralUtils.COLONVAL+e.getMessage()); }
        return true;
    }
    
    /***************************************************************************************************  
Method name : attrQLI
Param 1     : QuotelineitemId
Return Type : void
Description : Takes the values from Quoteline items.(Edit Quote Scenario)
****************************************************************************************************/
    public static void attrQLI(Id qtid){
        map<string,object> mp = new map<string,object>();
        String attrJson;
        //list<quotelineitem> qtl = [select id,ASC_Last_Price_Modified_Date__c,ASC_Product_Code__c,vlocity_ins__AttributeSelectedValues__c from quotelineitem where quoteid = :qtid];
        for(quotelineitem q : [select id,ASC_Last_Price_Modified_Date__c,ASC_Product_Code__c,quote.status,
                               vlocity_ins__AttributeSelectedValues__c,ASC_Group_Specific_Pricing_ID__r.ASC_Deleted__c from quotelineitem where 
                               quoteid = :qtid LIMIT 10000]){
                                   attrJson = q.vlocity_ins__AttributeSelectedValues__c;
                                   if(attrJson != null ){
                                       mp = (map<string,object>)json.deserializeuntyped(attrJson);
                                       for(string str : mp.keyset()){
                                           //if((str.containsIgnoreCase('sales') || str.containsIgnoreCase('covered')) 
                                           if((str.containsIgnoreCase('sales') || str.containsIgnoreCase('covered') || ((str.containsIgnoreCase('ASC_Mixed_Billed_Type') || str.containsIgnoreCase('ASC_Mixed_Billed_Fee')) && ('ASC_0000005'.equals(q.ASC_Product_Code__c) || 'ASC_0000370'.equals(q.ASC_Product_Code__c))) ) 
                                              && q.ASC_Last_Price_Modified_Date__c != NULL){
                                                  
                                                  //By pass invoicing contracts for renewal and edit quote
                                                  if(!UNITVOLUME.equals(str) && !SALESVOLUME.equals(str) &&!INVOICINGCONTRACTS.equals(str) && NEWSTATUS.equals(q.quote.status)){
                                                      
                                                      gsp.put(q.ASC_Product_Code__c+DOTCHAR+str,string.valueof(mp.get(str)));
                                                  }
                                                  else if(!UNITVOLUME.equals(str) && !NEWSTATUS.equals(q.quote.status) 
                                                          //Added only product codes
                                                          && !'ASC_0000415'.equals(q.ASC_Product_Code__c) && !'ASC_0000159'.equals(q.ASC_Product_Code__c) && !'ASC_0000010'.equals(q.ASC_Product_Code__c) && !'ASC_0000078'.equals(q.ASC_Product_Code__c)
                                                          && !'ASC_0000006'.equals(q.ASC_Product_Code__c) && !'ASC_0000005'.equals(q.ASC_Product_Code__c) && !'ASC_0000014'.equals(q.ASC_Product_Code__c) && !'ASC_0000370'.equals(q.ASC_Product_Code__c)
                                                          && !'ASC_0000439'.equals(q.ASC_Product_Code__c) && !'ASC_0000432'.equals(q.ASC_Product_Code__c) && !'ASC_0000431'.equals(q.ASC_Product_Code__c) && !'ASC_0000172'.equals(q.ASC_Product_Code__c)
                                                          && !'ASC_0000171'.equals(q.ASC_Product_Code__c) && !'ASC_0000434'.equals(q.ASC_Product_Code__c) && !'ASC_0000438'.equals(q.ASC_Product_Code__c) && !'ASC_0000433'.equals(q.ASC_Product_Code__c)
                                                          && !'ASC_0000170'.equals(q.ASC_Product_Code__c) && !'ASC_0000430'.equals(q.ASC_Product_Code__c) && !'ASC_0000429'.equals(q.ASC_Product_Code__c) && !'ASC_0000440'.equals(q.ASC_Product_Code__c)
                                                          && !'ASC_0000169'.equals(q.ASC_Product_Code__c) && !'ASC_0000441'.equals(q.ASC_Product_Code__c) && !'ASC_0000428'.equals(q.ASC_Product_Code__c) && !'ASC_0000427'.equals(q.ASC_Product_Code__c) 
                                                          && !'ASC_0000168'.equals(q.ASC_Product_Code__c) && !'ASC_0000437'.equals(q.ASC_Product_Code__c) && !'ASC_0000435'.equals(q.ASC_Product_Code__c) && !'ASC_0000436'.equals(q.ASC_Product_Code__c)
                                                          && !'ASC_0000167'.equals(q.ASC_Product_Code__c) && !'ASC_0000166'.equals(q.ASC_Product_Code__c) && !'ASC_0000164'.equals(q.ASC_Product_Code__c) && !'ASC_0000346'.equals(q.ASC_Product_Code__c)
                                                          && !'ASC_0000007'.equals(q.ASC_Product_Code__c)){
                                                              
                                                              gsp.put(q.ASC_Product_Code__c+DOTCHAR+str,string.valueof(mp.get(str)));                                                                                                                              
                                                          }
                                                  //Bhanu - Added conditions
                                                  else if(('ASC_0000007'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str) )
                                                          
                                                          || ('ASC_0000346'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str) && !'ASC_Lvl_Payment_Claims_Amt'.equals(str)  )
                                                          
                                                          || ('ASC_0000164'.equals(q.ASC_Product_Code__c) && !'ASC_RateCap'.equals(str)  )
                                                          
                                                          || ('ASC_0000166'.equals(q.ASC_Product_Code__c) && !'ASC_SecondYrRateCap'.equals(str) && !'ASC_ThrdYrRateCap'.equals(str)   && !'ASC_FourthYrRateCap'.equals(str)  )
                                                          
                                                          || ('ASC_0000167'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str)  ) 
                                                          
                                                          || ('ASC_0000436'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str)  ) 
                                                          
                                                          || ('ASC_0000435'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str)  ) 
                                                          
                                                          || ('ASC_0000437'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str)  ) 
                                                          
                                                          || ('ASC_0000168'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str))
                                                          
                                                          || ('ASC_0000427'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str))
                                                          
                                                          || ('ASC_0000428'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str))
                                                          
                                                          || ('ASC_0000441'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str))
                                                          
                                                          || ('ASC_0000169'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_CostSharePercent'.equals(str) && !'ASC_CostShareMaximum'.equals(str)  )
                                                          
                                                          || ( 'ASC_0000440'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_CostSharePercent'.equals(str) && !'ASC_CostShareMaximum'.equals(str)  )
                                                          
                                                          || ( 'ASC_0000429'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_CostSharePercent'.equals(str) && !'ASC_CostShareMaximum'.equals(str)  )
                                                          
                                                          || ( 'ASC_0000430'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_CostSharePercent'.equals(str) && !'ASC_CostShareMaximum'.equals(str)  )                                                                                                                                                                                                                                                                                     
                                                          
                                                          || ( 'ASC_0000170'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Deductible'.equals(str) && !'ASC_UnitPrice'.equals(str) ) 
                                                          
                                                          || ( 'ASC_0000433'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Deductible'.equals(str) && !'ASC_UnitPrice'.equals(str)) 
                                                          
                                                          || ( 'ASC_0000438'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Deductible'.equals(str) && !'ASC_UnitPrice'.equals(str)) 
                                                          
                                                          || ( 'ASC_0000434'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Deductible'.equals(str) && !'ASC_UnitPrice'.equals(str))                                       
                                                          || ( 'ASC_0000171'.equals(q.ASC_Product_Code__c) && !'ASC_CostShareMaximum'.equals(str) && !'ASC_CostSharePercent'.equals(str) )
                                                          || ( 'ASC_0000172'.equals(q.ASC_Product_Code__c) && !'ASC_Refund_Percent'.equals(str) && !'ASC_Total_SLPremium'.equals(str) )
                                                          || ( 'ASC_0000431'.equals(q.ASC_Product_Code__c) && !'ASC_Refund_Percent'.equals(str) && !'ASC_Total_SLPremium'.equals(str))                                              
                                                          || ( 'ASC_0000432'.equals(q.ASC_Product_Code__c) && !'ASC_Refund_Percent'.equals(str) && !'ASC_Total_SLPremium'.equals(str) )
                                                          || ( 'ASC_0000439'.equals(q.ASC_Product_Code__c) && !'ASC_Refund_Percent'.equals(str) && !'ASC_Total_SLPremium'.equals(str) )
                                                          || ( 'ASC_0000370'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_PercentOfClaim'.equals(str)  && !'ASC_AAC_PCNT'.equals(str) && !'ASC_Fee_Not_GT'.equals(str) && !'ASC_Fee_NOT_LT'.equals(str) && !'ASC_UW_AAC_Claims'.equals(str) && !'ASC_CRED_CLMS'.equals(str) && !'ASC_CRED_CLMS_Facility'.equals(str) )
                                                          
                                                          || ( 'ASC_0000014'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str) )
                                                          || ( 'ASC_0000005'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str)   && !'ASC_UnitPrice'.equals(str) && !'ASC_CRED_CLMS'.equals(str) && !'ASC_CRED_CLMS_Facility'.equals(str) )
                                                          
                                                          || ( 'ASC_0000004'.equals(q.ASC_Product_Code__c) && !'ASC_Hosp_Adv'.equals(str) && !'ASC_Adv_Dep'.equals(str) )
                                                          || ( 'ASC_0000006'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str) )
                                                          
                                                          || ( 'ASC_0000078'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str) )
                                                          || ( 'ASC_0000010'.equals(q.ASC_Product_Code__c) && !'ASC_Monthly_CapAmount'.equals(str) )
                                                          
                                                          || ( 'ASC_0000159'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str)  && !'ASC_PercentOfClaim'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Agg_Min_AttachmentPoint'.equals(str) && !'ASC_UW_Claims_Covered'.equals(str) && !'ASC_Org_LOB_Covered'.equals(str) )
                                                          || ( 'ASC_0000415'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str)  && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Deductible'.equals(str) && !'ASC_UW_Claims_Covered'.equals(str) && !'ASC_Org_LOB_Covered'.equals(str))
                                                         )  {   
                                                             
                                                             gsp.put(q.ASC_Product_Code__c+DOTCHAR+str,string.valueof(mp.get(str)));                                                             
                                                         }
                                              }                                                                                      
                                           else if(q.ASC_Last_Price_Modified_Date__c == NULL){
                                               
                                               if(!UNITVOLUME.equals(str) && !SALESVOLUME.equals(str) && !INVOICINGCONTRACTS.equals(str) && NEWSTATUS.equals(q.quote.status)){
                                                   
                                                   gsp.put(q.ASC_Product_Code__c+DOTCHAR+str,string.valueof(mp.get(str))); 
                                               }                                              
                                               else if(!UNITVOLUME.equals(str) && !NEWSTATUS.equals(q.quote.status) 
                                                       //Added only product codes
                                                       && !'ASC_0000415'.equals(q.ASC_Product_Code__c) && !'ASC_0000159'.equals(q.ASC_Product_Code__c) && !'ASC_0000010'.equals(q.ASC_Product_Code__c) && !'ASC_0000078'.equals(q.ASC_Product_Code__c)
                                                       && !'ASC_0000006'.equals(q.ASC_Product_Code__c) && !'ASC_0000005'.equals(q.ASC_Product_Code__c) && !'ASC_0000014'.equals(q.ASC_Product_Code__c) && !'ASC_0000370'.equals(q.ASC_Product_Code__c)
                                                       && !'ASC_0000439'.equals(q.ASC_Product_Code__c) && !'ASC_0000432'.equals(q.ASC_Product_Code__c) && !'ASC_0000431'.equals(q.ASC_Product_Code__c) && !'ASC_0000172'.equals(q.ASC_Product_Code__c)
                                                       && !'ASC_0000171'.equals(q.ASC_Product_Code__c) && !'ASC_0000434'.equals(q.ASC_Product_Code__c) && !'ASC_0000438'.equals(q.ASC_Product_Code__c) && !'ASC_0000433'.equals(q.ASC_Product_Code__c)
                                                       && !'ASC_0000170'.equals(q.ASC_Product_Code__c) && !'ASC_0000430'.equals(q.ASC_Product_Code__c) && !'ASC_0000429'.equals(q.ASC_Product_Code__c) && !'ASC_0000440'.equals(q.ASC_Product_Code__c)
                                                       && !'ASC_0000169'.equals(q.ASC_Product_Code__c) && !'ASC_0000441'.equals(q.ASC_Product_Code__c) && !'ASC_0000428'.equals(q.ASC_Product_Code__c) && !'ASC_0000427'.equals(q.ASC_Product_Code__c) 
                                                       && !'ASC_0000168'.equals(q.ASC_Product_Code__c) && !'ASC_0000437'.equals(q.ASC_Product_Code__c) && !'ASC_0000435'.equals(q.ASC_Product_Code__c) && !'ASC_0000436'.equals(q.ASC_Product_Code__c)
                                                       && !'ASC_0000167'.equals(q.ASC_Product_Code__c) && !'ASC_0000166'.equals(q.ASC_Product_Code__c) && !'ASC_0000164'.equals(q.ASC_Product_Code__c) && !'ASC_0000346'.equals(q.ASC_Product_Code__c)
                                                       && !'ASC_0000007'.equals(q.ASC_Product_Code__c)){
                                                           
                                                           gsp.put(q.ASC_Product_Code__c+DOTCHAR+str,string.valueof(mp.get(str)));                                                                                                                      
                                                       }
                                               //Bhanu - Added conditions
                                               else if(('ASC_0000007'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str) )
                                                       
                                                       || ('ASC_0000346'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str) && !'ASC_Lvl_Payment_Claims_Amt'.equals(str)  )
                                                       
                                                       || ('ASC_0000164'.equals(q.ASC_Product_Code__c) && !'ASC_RateCap'.equals(str)  )
                                                       
                                                       || ('ASC_0000166'.equals(q.ASC_Product_Code__c) && !'ASC_SecondYrRateCap'.equals(str) && !'ASC_ThrdYrRateCap'.equals(str)   && !'ASC_FourthYrRateCap'.equals(str)  )
                                                       
                                                       || ('ASC_0000167'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str)  ) 
                                                       
                                                       || ('ASC_0000436'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str)  ) 
                                                       
                                                       || ('ASC_0000435'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str)  ) 
                                                       
                                                       || ('ASC_0000437'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str)  ) 
                                                       
                                                       || ('ASC_0000168'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str))
                                                       
                                                       || ('ASC_0000427'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str))
                                                       
                                                       || ('ASC_0000428'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str))
                                                       
                                                       || ('ASC_0000441'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str))
                                                       
                                                       || ('ASC_0000169'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_CostSharePercent'.equals(str) && !'ASC_CostShareMaximum'.equals(str)  )
                                                       
                                                       || ( 'ASC_0000440'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_CostSharePercent'.equals(str) && !'ASC_CostShareMaximum'.equals(str)  )
                                                       
                                                       || ( 'ASC_0000429'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_CostSharePercent'.equals(str) && !'ASC_CostShareMaximum'.equals(str)  )
                                                       
                                                       || ( 'ASC_0000430'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_CostSharePercent'.equals(str) && !'ASC_CostShareMaximum'.equals(str)  )                                                                                                                                                                                                                                                                                     
                                                       
                                                       || ( 'ASC_0000170'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Deductible'.equals(str) && !'ASC_UnitPrice'.equals(str) ) 
                                                       
                                                       || ( 'ASC_0000433'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Deductible'.equals(str) && !'ASC_UnitPrice'.equals(str)) 
                                                       
                                                       || ( 'ASC_0000438'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Deductible'.equals(str) && !'ASC_UnitPrice'.equals(str)) 
                                                       
                                                       || ( 'ASC_0000434'.equals(q.ASC_Product_Code__c) && !'ASC_SL_Identifier'.equals(str) && !'ASC_SL_Identifier_Data'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Deductible'.equals(str) && !'ASC_UnitPrice'.equals(str))                                       
                                                       || ( 'ASC_0000171'.equals(q.ASC_Product_Code__c) && !'ASC_CostShareMaximum'.equals(str) && !'ASC_CostSharePercent'.equals(str) )
                                                       || ( 'ASC_0000172'.equals(q.ASC_Product_Code__c) && !'ASC_Refund_Percent'.equals(str) && !'ASC_Total_SLPremium'.equals(str) )
                                                       || ( 'ASC_0000431'.equals(q.ASC_Product_Code__c) && !'ASC_Refund_Percent'.equals(str) && !'ASC_Total_SLPremium'.equals(str))                                              
                                                       || ( 'ASC_0000432'.equals(q.ASC_Product_Code__c) && !'ASC_Refund_Percent'.equals(str) && !'ASC_Total_SLPremium'.equals(str) )
                                                       || ( 'ASC_0000439'.equals(q.ASC_Product_Code__c) && !'ASC_Refund_Percent'.equals(str) && !'ASC_Total_SLPremium'.equals(str) )
                                                       || ( 'ASC_0000370'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_PercentOfClaim'.equals(str)  && !'ASC_AAC_PCNT'.equals(str) && !'ASC_Fee_Not_GT'.equals(str) && !'ASC_Fee_NOT_LT'.equals(str) && !'ASC_UW_AAC_Claims'.equals(str) && !'ASC_CRED_CLMS'.equals(str) && !'ASC_CRED_CLMS_Facility'.equals(str) )
                                                       
                                                       || ( 'ASC_0000014'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str) )
                                                       || ( 'ASC_0000005'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str)   && !'ASC_UnitPrice'.equals(str) && !'ASC_CRED_CLMS'.equals(str) && !'ASC_CRED_CLMS_Facility'.equals(str) )
                                                       
                                                       || ( 'ASC_0000004'.equals(q.ASC_Product_Code__c) && !'ASC_Hosp_Adv'.equals(str) && !'ASC_Adv_Dep'.equals(str) )
                                                       || ( 'ASC_0000006'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str) )
                                                       
                                                       || ( 'ASC_0000078'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str) )
                                                       || ( 'ASC_0000010'.equals(q.ASC_Product_Code__c) && !'ASC_Monthly_CapAmount'.equals(str) )
                                                       
                                                       || ( 'ASC_0000159'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str)  && !'ASC_PercentOfClaim'.equals(str) && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Agg_Min_AttachmentPoint'.equals(str) && !'ASC_UW_Claims_Covered'.equals(str) && !'ASC_Org_LOB_Covered'.equals(str) )
                                                       || ( 'ASC_0000415'.equals(q.ASC_Product_Code__c) && !'ASC_UnitVolume'.equals(str) && !'ASC_UnitPrice'.equals(str)  && !'ASC_AttachmentPoint'.equals(str) && !'ASC_Deductible'.equals(str) && !'ASC_UW_Claims_Covered'.equals(str) && !'ASC_Org_LOB_Covered'.equals(str))
                                                      )                            
                                               {                                                   
                                                   gsp.put(q.ASC_Product_Code__c+DOTCHAR+str,string.valueof(mp.get(str)));                                                   
                                               }
                                           }
                                       }
                                   }
                                   if(q.ASC_Last_Price_Modified_Date__c != NULL)// && !q.ASC_Group_Specific_Pricing_ID__r.ASC_Deleted__c) //TD-1436 - Commented the condition to display Last Price Modified even the GSP is inactiated - Dinesh
                                   {
                                       gsp.put(q.ASC_Product_Code__c+'.ASC_Last_Price_Modified',string.valueof(q.ASC_Last_Price_Modified_Date__c));
                                   }                                   
                               }
    }  
    
    /***************************************************************************************************  
Method name : getUnitpriceJSon
Param 1     : inputMap, outputMap.
Return Type : void
Description : Calculate the Pricing from Group Specific Pricing table.
****************************************************************************************************/    
    public static void getUnitpriceJSon(Map<String, Object> input, Map<String, Object> output){
        map<string,object> nd1 = (Map<String,Object>)input.get('IdentifyingQuote');
        string carr = (String)nd1.get('Carrier');        
        QUOTEID = (String)input.get('ContextId');
        AccCQ = (String)input.get('AccIdd'); 
        AccEQ = (String)input.get('AccId');
        Accname = QUOTEID.startsWith('0Q0') ? AccEQ : AccCQ;
        //Accname = (String)input.get('AccIdd');        
        carrier = (String)nd1.get('Carrier');
        String cid = (String)nd1.get('CID');
        effDate = string.valueof(nd1.get('StartDate'));
        effDateFormat = string.valueof(nd1.get('StartDate1'));
        Date effDt= date.valueOf(effDate);
        endDate = (String)nd1.get('EndDate');
        system.debug('########StartDate'+effDate );
        system.debug('########endDate'+endDate);
        Date endDt = date.valueOf(endDate);
        Datetime myDT = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
        String myefDate = myDT.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
        Datetime myNDT = datetime.newInstance(endDt.year(), endDt.month(),endDt.day());
        String myeNDate = myNDT.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
        map<string,object> grpSegmnt = (Map<String,Object>)nd1.get('GetSubSegName-Block');
        subSegment = (String)grpSegmnt.get('GetAscSubSegement');
        String prdIdset = (String)input.get('productIdSet');
        prdIdset = prdIdset.replaceAll('Id:','');
        list<string> selprdIDs = prdIdset.split(',');
        set<Id> selPrdSet = new set<Id>();
        for(string ipr: selprdIDs){
            selPrdSet.add(id.valueOf(ipr));
        }
        
        set<string> covgSpecPrdcde = new set<string>();
        for(vlocity_ins__ProductChildItem__c pci : [select id,vlocity_ins__ChildProductId__c,ASC_Child_ProductCode__c from vlocity_ins__ProductChildItem__c where vlocity_ins__ParentProductId__c in :selPrdSet]){
            covgSpecPrdcde.add(pci.ASC_Child_ProductCode__c);
        }
        set<string> prntPrdctcode = new set<string>();
        for(product2 prdc:[select id,productcode from product2 where id in :selPrdSet]){
            prntPrdctcode.add(prdc.productcode);
        }
        
        for(product2 prd: [select id,productcode from product2 where productcode in:prntPrdctcode or productcode in:covgSpecPrdcde]){
            //gsp.put(prd.ProductCode+ASC_EffectiveEndDate,string.valueOf(myeNDate));
            // gsp.put(prd.ProductCode+ASC_EffectiveStartDate,string.valueOf(myefDate));
            gsp.put(prd.ProductCode+ASC_EffectiveStartDate, effDate);
            gsp.put(prd.ProductCode+ASC_EffectiveEndDate, endDate);        
        }
        
        Map<String,string> gspAttrMDMap = new Map<String,string>();
        for(ASC_GSPFieldMetadata__mdt mdt:[Select Id,Attribute_Name__c,Field_Name__c from ASC_GSPFieldMetadata__mdt]){            
            gspAttrMDMap.put(mdt.Attribute_Name__c,mdt.Field_Name__c);
        }
        /*
US-3112 -Added By Dinesh - updated the ASC_Deleted__c = false in the below query to not pull the pricing from the records that are marked as deleted.
*/
        for(ASC_Group_Specific_Pricing__c gs : [select ASC_Estimated_Monthly_Contracts__c,ASC_Unit_Price__c,
                                                ASC_Monthly_Cap_Amount__c, ASC_Hosp_Ad_Dep__c,ASC_K_Adv_Deposit__c, 
                                                ASC_Percent_of_Claims__c,AAC_PCNT__c,ASC_Unit_Price_Not_GT__c,
                                                ASC_Unit_Price_Not_LT__c,Aggregating_Deductible__c,
                                                ASC_Second_Year_Rate_Cap__c,ASC_Third_Year_Rate_Cap__c, 
                                                ASC_Fourth_Year_Rate_Cap__c,ASC_SL_Identifier__c,ASC_Rate_Cap__c,
                                                ASC_SL_Identifier_Data__c,ASC_Attachment_Point__c,
                                                ASC_Cost_Share_Maximum__c,ASC_Cost_Share_Percent__c,
                                                ASC_Refund_Percent__c,ASC_Total_Stop_Loss_Premium__c,ASC_CRED_CLMS__c,
                                                ASC_CRED_CLMS_Facility__c,ASC_Aggregate_Min_Attachment_Point__c,
                                                ASC_Product_Code__c,ASC_Platform__c,ASC_Level_Payment_Claims_Amount__c,ASC_AAC_Type_of_Claims__c,Claims_Covered__c,ASC_SL_LOB__c
                                                from ASC_Group_Specific_Pricing__c where ASC_Group__c =:Accname and
                                                (ASC_Effective_Date__c <= :effDt and ASC_Effective_End_Date__c>=:effDt)
                                                and ASC_Product_Code__c in :covgSpecPrdcde and ASC_Carrier__c =:carrier
                                                and ASC_Sub_Segment__c =: subSegment
                                                and ASC_Deleted__c = false 
                                                Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                                                    for(string atrcde : gspAttrMDMap.keyset()){
                                                        string gspVL=string.valueof(gs.get(gspAttrMDMap.get(atrcde)));
                                                        if(gspVL!=NULL){
                                                            gsp.put(gs.ASC_Product_Code__c+DOTCHAR+atrcde,gspVL);
                                                        }
                                                    }
                                                }
        
        
        
        if(covgSpecPrdcde.contains('ASC_0000143')){
            gsp.put('ASC_0000143.ASC_Carrier',carr);
        }
        
    
        
        QUOTEID = (String)input.get(CONTEXTID);      
        String estVol = STRING_EMPTY;     
        Object objestVol;
        Map<String,Object> getoffStep = (Map<String,Object>)input.get('ProductOfferingStep');
        if(getoffStep !=null && (Object)getoffStep.get('EstimatedVolume') !=null){
            objestVol = (Object)getoffStep.get('EstimatedVolume');
        }
        if(objestVol !=null){
            estVol = String.ValueOf(objestVol);
        }        
        List<Quote> qRec = new List<Quote>();
        
        if(!String.isBlank(QUOTEID) && QUOTEID !=null && QUOTEID.startsWith(QUOTECHAR)){
            qRec = [Select Id,status from Quote where Id =:QUOTEID Limit 1];
        }
        //Logic added for invoicing contracts population
        for(Product2 prod : [select id,vlocity_ins__AttributeDefaultValues__c,name,ProductCode from Product2 
                             where vlocity_ins__Type__c =: ASCPRODUCT 
                             AND vlocity_ins__LineOfBusiness__c =: NONBENEFIT 
                             AND RecordType.Name =: COVERAGESPEC
                             AND isActive = true
                             Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                                 if(prod.vlocity_ins__AttributeDefaultValues__c!=null
                                    && prod.vlocity_ins__AttributeDefaultValues__c.contains('"ASC_PricingType":"Default"')
                                    && prod.vlocity_ins__AttributeDefaultValues__c.contains('"ASC_PricingMethod":"PCPM"')
                                   ){                  
                                       if((!QUOTEID.startsWith(QUOTECHAR))
                                          || (QUOTEID.startsWith(QUOTECHAR) && !String.isBlank(QUOTEID) && NEWSTATUS.equals(qRec[0].Status))){
                                              gsp.put(prod.ProductCode+DOTCHAR+UNITVOLUME,estVol); 
                                              gsp.put(prod.ProductCode+DOTCHAR+SALESVOLUME,estVol);
                                              gsp.put(prod.ProductCode+DOTCHAR+INVOICINGCONTRACTS,estVol);
                                          }
                                       else{
                                           gsp.put(prod.ProductCode+DOTCHAR+UNITVOLUME,estVol);
                                       }
                                   }
                                 //Start:Harsha US#2184              
                                 
                                 if(prod.vlocity_ins__AttributeDefaultValues__c!=null            
                                    && prod.vlocity_ins__AttributeDefaultValues__c.contains('"ASC_PricingMethod":"PMPM"')
                                   ){
                                       
                                       if((!QUOTEID.startsWith(QUOTECHAR))
                                          || (QUOTEID.startsWith(QUOTECHAR) && !String.isBlank(QUOTEID) && NEWSTATUS.equals(qRec[0].Status))){
                                              gsp.put(prod.ProductCode+DOTCHAR+UNITVOLUME,estVol); 
                                              gsp.put(prod.ProductCode+DOTCHAR+INVOICINGCONTRACTS,estVol);
                                          }
                                       else{
                                           gsp.put(prod.ProductCode+DOTCHAR+UNITVOLUME,estVol);
                                       } 
                                   }
                                 //sync volume for Datafeeds products US#3645
                                 if(prod.vlocity_ins__AttributeDefaultValues__c!=null
                                    && prod.vlocity_ins__AttributeDefaultValues__c.contains('"ASC_PricingType":"Data Feeds"')
                                    && prod.vlocity_ins__AttributeDefaultValues__c.contains('"ASC_PricingMethod":"PCPM"')
                                   ){                  
                                       if((!QUOTEID.startsWith(QUOTECHAR))
                                          || (QUOTEID.startsWith(QUOTECHAR) && !String.isBlank(QUOTEID) && NEWSTATUS.equals(qRec[0].Status))){
                                              gsp.put(prod.ProductCode+DOTCHAR+INVOICINGCONTRACTS,estVol); 
                                              gsp.put(prod.ProductCode+DOTCHAR+UNITVOLUME,estVol);
                                              
                                          }
                                       else{
                                           gsp.put(prod.ProductCode+DOTCHAR+UNITVOLUME,estVol);
                                       }
                                   }
                                 
                                 //End:Harsha US#2184   
                             } 
    
        if(QUOTEID.startsWith(QUOTECHAR)){
            attrQLI(QUOTEID);
        }
        //test hsingh
        //gsp.put('ASC_0000143.ASC_Carrier', 'BCN');
        //end of test hsingh
        //gsp.put('ASC_0000143.ASC_Carrier', carr);
        output.put('userInputs',gsp);    
    }
	
	 /***************************************************************************************************  
Method name : getUnitVolume
Param 1     : inputMap, outputMap.
Return Type : void
Description : sync volume from Group Specific Pricing table.
****************************************************************************************************/    
    public static void getUnitVolume(Map<String, Object> input, Map<String, Object> output){
		
		map<string,object> nd1 = (Map<String,Object>)input.get('IdentifyingQuote');
        string carr = (String)nd1.get('Carrier');        
        QUOTEID = (String)input.get('ContextId');
        carrier = (String)nd1.get('Carrier'); //{
        String cid = (String)nd1.get('CID');
        effDate = string.valueof(nd1.get('StartDate'));
        effDateFormat = string.valueof(nd1.get('StartDate1'));
        Date effDt= date.valueOf(effDate);
        endDate = (String)nd1.get('EndDate');
        //system.debug('########StartDate'+effDate );
        //system.debug('########endDate'+endDate);
        Date endDt = date.valueOf(endDate);
        Datetime myDT = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
        String myefDate = myDT.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
        Datetime myNDT = datetime.newInstance(endDt.year(), endDt.month(),endDt.day());
        String myeNDate = myNDT.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
        map<string,object> grpSegmnt = (Map<String,Object>)nd1.get('GetSubSegName-Block');
        subSegment = (String)grpSegmnt.get('GetAscSubSegement');
		
		for(ASC_Group_Specific_Pricing__c gs : [select id, ASC_Estimated_Monthly_Contracts__c FROM ASC_Group_Specific_Pricing__c where ASC_Effective_Date__c <= :effDt and ASC_Effective_End_Date__c>=:effDt 
                                                 and ASC_Carrier__c =:carrier and ASC_CID__c=:cid
                                                and ASC_Sub_Segment__c =: subSegment
                                                and ASC_Deleted__c = false and ASC_Product_Code__c=:PRODCODE 
											    Limit 1]){
												
													
                                                    output.put(ESTIMATEDVOLUME,gs.ASC_Estimated_Monthly_Contracts__c);					
													
													
												}
		
		
		
	}
}