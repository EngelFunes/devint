/**
@Author : Bhanu
@Name: ASC_GSPUpdateQLILastPriceDate
@CreatedDate:  05-29-2020 
@Description: ASC_GSPUpdateQLILastPriceDate class is used to update LastPriceDate in QLI.
@version : 1.0  

--Modified--
@US Number: US-3263 Req#3575 - Adding two new fields MINIMUM AGG ATTACH POINT and AGG SPEC DED AMOUNT to update Last Price Modified Date on QLI Object - 06/30/2020
@US#3665 and Req#3819 - removed the Monthly Cap Amount condition from the HOSP_ADV_DEP_PRDCODE.
*/
public without sharing class ASC_GSPUpdateQLILastPriceDate {

    private static final string CLASSNAME ='ASC_GSPUpdateQLILastPriceDate';
    private static final string METHODNAME ='updateLastPriceDate';
    private static final String UNDERSCORE = '_';    
    public static boolean isExecuting = false;
    private static final String FIXEDADMINFEE_PRDCODE = 'ASC_0000005';
    private static final String VARADMINFEE_PRDCODE = 'ASC_0000370';
    private static final String ADV_MON_CAP_AMT_PRDCODE = 'ASC_0000010';
    private static final String SPECIFIC_SL_INS_PRDCODE = 'ASC_0000415';
    private static final String AGG_SL_INS_PRDCODE = 'ASC_0000159'; 
    private static final String FINANCECHARGE_PRDCODE = 'ASC_0000006';
    private static final String HOSP_ADV_DEP_PRDCODE = 'ASC_0000004';
    private static final String TPA_STOP_LOSS_VENDORFEE_PRDCODE = 'ASC_0000078';
    private static final String ADDITIONAL_ADMIN_COMP_PRDCODE = 'ASC_0000014';
    private static final String LEVELPAYMENT_PRDCODE = 'ASC_0000346';
    private static final String EXPERIENCEREF_PRDCODE = 'ASC_0000172';
    private static final String COSTSHARING_PRDCODE = 'ASC_0000171';
    private static final String MULTATTACHPOINT_PRDCODE = 'ASC_0000170';
    private static final String LASERSHARING_PRDCODE = 'ASC_0000169';
    private static final String LASER_PRDCODE = 'ASC_0000168';
    private static final String EXCLUSIONS_PRDCODE = 'ASC_0000167';
    private static final String MULTIYEARRATECAP_PRDCODE = 'ASC_0000166';
    private static final String SECONDYEAR_PRDCODE = 'ASC_0000164';
    private static final String MEDICAREFEE_PRDCODE = 'ASC_0000007';

    /**********************************************************************************************************************************
    @Description        :   This method is used to update QLI Last Price Modified Date field when GSP record is created/updated
    @Name               :   updateLastPriceDate
    @Param              :   List<ASC_Group_Specific_Pricing__c> gspList,Map<Id,ASC_Group_Specific_Pricing__c> oldMap
    @Return             :   void
    @throws Exception   :   N/A    
    ***********************************************************************************************************************************/           
    public static void updateLastPriceDate(List<ASC_Group_Specific_Pricing__c> gspList,Map<Id,ASC_Group_Specific_Pricing__c> oldMap) {
      
      try{      
        List<QuoteLineItem> qliListUpdate = new List<QuoteLineItem> ();
        Map<String,ASC_Group_Specific_Pricing__c> existingUniqueKeySet = new Map<String,ASC_Group_Specific_Pricing__c>();
        set<String> cid = new set<String>();
        set<String> carr = new set<String>();
        set<Date> startDate = new set<Date>();
        set<Date> endDate = new set<Date>();
        set<String> sugSegment = new set<String>();
        set<String> prdCode = new set<String>();
        Set<String> productCodeSet = new Set<String>{
         'ASC_0000005','ASC_0000010','ASC_0000370','ASC_0000415','ASC_0000159','ASC_0000006','ASC_0000004','ASC_0000078',
         'ASC_0000014','ASC_0000007','ASC_0000164','ASC_0000166','ASC_0000167',
         'ASC_0000168','ASC_0000169','ASC_0000170','ASC_0000171','ASC_0000172','ASC_0000346'
        };
    
        if(!gspList.isEmpty()){
         for(ASC_Group_Specific_Pricing__c gspRec : gspList){
             cid.add(gspRec.ASC_CID__c);
             carr.add(gspRec.ASC_Carrier__c);
             startDate.add(gspRec.ASC_Effective_Date__c);
             endDate.add(gspRec.ASC_Effective_End_Date__c);
             prdCode.addAll(productCodeSet);                 
             sugSegment.add(gspRec.ASC_Sub_Segment__c);
         }
                            
        for(ASC_Group_Specific_Pricing__c gspNew:gspList){                             
            ASC_Group_Specific_Pricing__c gspOld = new ASC_Group_Specific_Pricing__c();
            if(oldMap !=null){
              gspOld = oldMap.get(gspNew.Id);
            }
            if(VARADMINFEE_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
               (
                (gspOld == null && (gspNew.ASC_Percent_of_Claims__c !=null || gspNew.ASC_Unit_Price_Not_GT__c !=null 
                || gspNew.ASC_Estimated_Monthly_Contracts__c !=null )) 
                ||
                (gspOld.ASC_Percent_of_Claims__c!=gspNew.ASC_Percent_of_Claims__c
                || gspOld.ASC_Unit_Price_Not_GT__c!= gspNew.ASC_Unit_Price_Not_GT__c 
                || gspOld.ASC_Estimated_Monthly_Contracts__c != gspNew.ASC_Estimated_Monthly_Contracts__c
                )
                )
              ){                    
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+VARADMINFEE_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);                                                                
            }            
            if(FIXEDADMINFEE_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
              (
                (gspOld == null && (gspNew.ASC_Estimated_Monthly_Contracts__c !=null || gspNew.ASC_Unit_Price__c !=null 
                || gspNew.ASC_MONTHLY_CAP_AMOUNT__c !=null )) 
                ||
                (gspOld.ASC_Estimated_Monthly_Contracts__c!=gspNew.ASC_Estimated_Monthly_Contracts__c
                 || gspOld.ASC_Unit_Price__c!= gspNew.ASC_Unit_Price__c 
                 || gspOld.ASC_MONTHLY_CAP_AMOUNT__c != gspNew.ASC_MONTHLY_CAP_AMOUNT__c
                )
              )
             ){
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+FIXEDADMINFEE_PRDCODE;      
                existingUniqueKeySet.put(keySt,gspNew); 
            }
            // Added by Sujatha for adding Monthly Cap Amount to Last Price Modified logic for Adv Monthly Cap Amy Product
            if(ADV_MON_CAP_AMT_PRDCODE.equals(gspNew.ASC_Product_Code__c) &&
              (
                (gspOld == null && (gspNew.ASC_MONTHLY_CAP_AMOUNT__c !=null )) 
                ||
                (gspOld.ASC_MONTHLY_CAP_AMOUNT__c != gspNew.ASC_MONTHLY_CAP_AMOUNT__c
                )
              )
             ){
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+ADV_MON_CAP_AMT_PRDCODE;      
                existingUniqueKeySet.put(keySt,gspNew); 
            }
            if(SPECIFIC_SL_INS_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
              ( 
               (gspOld == null && (gspNew.ASC_Estimated_Monthly_Contracts__c !=null || gspNew.ASC_ATTACHMENT_POINT__c !=null
               || gspNew.ASC_Unit_Price__c !=null || gspNew.Aggregating_Deductible__c !=null)) 
               ||
               (gspOld.ASC_Estimated_Monthly_Contracts__c!=gspNew.ASC_Estimated_Monthly_Contracts__c
               || gspOld.ASC_ATTACHMENT_POINT__c!= gspNew.ASC_ATTACHMENT_POINT__c 
               || gspOld.ASC_Unit_Price__c != gspNew.ASC_Unit_Price__c 
               || gspOld.Aggregating_Deductible__c != gspNew.Aggregating_Deductible__c
               )
              )
             ){               
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+SPECIFIC_SL_INS_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }
            /*US-3263 Req#3575 - Added the field MINIMUM AGG ATTACH POINT - ASC_Aggregate_Min_Attachment_Point__c in the criteria to update Last Price Modified Date on QLI Object*/            
            if(AGG_SL_INS_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
              (
               (gspOld == null && (gspNew.ASC_Estimated_Monthly_Contracts__c !=null || gspNew.ASC_ATTACHMENT_POINT__c !=null
               || gspNew.ASC_Unit_Price__c !=null || gspNew.ASC_Percent_of_Claims__c !=null 
               || gspNew.ASC_Aggregate_Min_Attachment_Point__c !=null)) 
               ||
               (gspOld.ASC_Estimated_Monthly_Contracts__c!=gspNew.ASC_Estimated_Monthly_Contracts__c
               || gspOld.ASC_ATTACHMENT_POINT__c!= gspNew.ASC_ATTACHMENT_POINT__c || gspOld.ASC_Unit_Price__c != gspNew.ASC_Unit_Price__c 
               || gspOld.ASC_Percent_of_Claims__c != gspNew.ASC_Percent_of_Claims__c
               || gspOld.ASC_Aggregate_Min_Attachment_Point__c != gspNew.ASC_Aggregate_Min_Attachment_Point__c
               )
              )
             ){
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+AGG_SL_INS_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }
            if(FINANCECHARGE_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
              (
               (gspOld == null && (gspNew.ASC_Estimated_Monthly_Contracts__c !=null || gspNew.ASC_Unit_Price__c !=null)) ||
               (gspOld.ASC_Estimated_Monthly_Contracts__c != gspNew.ASC_Estimated_Monthly_Contracts__c
               || gspOld.ASC_Unit_Price__c != gspNew.ASC_Unit_Price__c )
              )
             ){
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+FINANCECHARGE_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }    
            if(HOSP_ADV_DEP_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
              (
               (gspOld == null && (gspNew.ASC_HOSP_AD_DEP__c !=null || gspNew.ASC_K_ADV_DEPOSIT__c !=null ))
               ||
               (gspOld.ASC_HOSP_AD_DEP__c!=gspNew.ASC_HOSP_AD_DEP__c
               || gspOld.ASC_K_ADV_DEPOSIT__c!= gspNew.ASC_K_ADV_DEPOSIT__c 
               )
              )
              ){              
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+HOSP_ADV_DEP_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }            
            if(TPA_STOP_LOSS_VENDORFEE_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
             (
              (gspOld == null && (gspNew.ASC_Estimated_Monthly_Contracts__c !=null || gspNew.ASC_Unit_Price__c !=null)) ||
              (gspOld.ASC_Estimated_Monthly_Contracts__c!=gspNew.ASC_Estimated_Monthly_Contracts__c
               || gspOld.ASC_Unit_Price__c!= gspNew.ASC_Unit_Price__c 
              )
             )
             ){               
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+TPA_STOP_LOSS_VENDORFEE_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }    
            if(ADDITIONAL_ADMIN_COMP_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
             (
              (gspOld == null && (gspNew.ASC_Estimated_Monthly_Contracts__c !=null || gspNew.ASC_Unit_Price__c !=null)) ||
              (gspOld.ASC_Estimated_Monthly_Contracts__c!=gspNew.ASC_Estimated_Monthly_Contracts__c
              || gspOld.ASC_Unit_Price__c!= gspNew.ASC_Unit_Price__c 
              )
             )
            ){
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+ADDITIONAL_ADMIN_COMP_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }       
            if(MEDICAREFEE_PRDCODE.equals(gspNew.ASC_Product_Code__c) &&
             (
              (gspOld == null && (gspNew.ASC_Estimated_Monthly_Contracts__c !=null || gspNew.ASC_Unit_Price__c !=null)) || 
              (gspOld.ASC_Estimated_Monthly_Contracts__c!=gspNew.ASC_Estimated_Monthly_Contracts__c
              || gspOld.ASC_Unit_Price__c!= gspNew.ASC_Unit_Price__c 
              )
             )
             ){                
                 String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                                UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+MEDICAREFEE_PRDCODE;     
                 existingUniqueKeySet.put(keySt,gspNew);     
            }
            if(SECONDYEAR_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
             (
              (gspOld == null && gspNew.ASC_Rate_Cap__c !=null) || 
              (gspOld.ASC_Rate_Cap__c!=gspNew.ASC_Rate_Cap__c)
             )
            ){
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+SECONDYEAR_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew); 
    
            }    
            if(MULTIYEARRATECAP_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
             (
              (gspOld == null && (gspNew.ASC_Second_Year_Rate_Cap__c !=null || gspNew.ASC_Third_Year_Rate_Cap__c !=null
              || gspNew.ASC_Fourth_Year_Rate_Cap__c !=null)) 
              || 
              (gspOld.ASC_Second_Year_Rate_Cap__c!=gspNew.ASC_Second_Year_Rate_Cap__c 
              || gspOld.ASC_Third_Year_Rate_Cap__c!= gspNew.ASC_Third_Year_Rate_Cap__c || gspOld.ASC_Fourth_Year_Rate_Cap__c != 
              gspNew.ASC_Fourth_Year_Rate_Cap__c
              )
             )
            ){              
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+MULTIYEARRATECAP_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }    
            if(EXCLUSIONS_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
             (
              (gspOld == null && (gspNew.ASC_SL_Identifier_Data__c !=null || gspNew.ASC_SL_Identifier__c !=null)) || 
              (gspOld.ASC_SL_Identifier__c != gspNew.ASC_SL_Identifier__c 
              || gspNew.ASC_SL_Identifier_Data__c !=gspNew.ASC_SL_Identifier_Data__c )
             )
            ){              
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+EXCLUSIONS_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }    
            if(LASER_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
             (
              (gspOld == null && (gspNew.ASC_SL_Identifier__c !=null || gspNew.ASC_SL_Identifier_Data__c !=null 
              || gspNew.ASC_Attachment_Point__c !=null)) 
              || 
              (gspOld.ASC_SL_Identifier__c !=gspNew.ASC_SL_Identifier__c 
               || gspOld.ASC_SL_Identifier_Data__c != gspNew.ASC_SL_Identifier_Data__c 
               || gspOld.ASC_Attachment_Point__c != gspNew.ASC_Attachment_Point__c
              )
             )
            ){
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+LASER_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }   
            if(LASERSHARING_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
             (
              (gspOld == null && (gspNew.ASC_SL_Identifier__c !=null || gspNew.ASC_SL_Identifier_Data__c !=null 
              || gspNew.ASC_Attachment_Point__c !=null || gspNew.ASC_Cost_Share_Maximum__c !=null 
              || gspNew.ASC_Cost_Share_Percent__c !=null)) 
              || 
              (gspOld.ASC_SL_Identifier__c !=gspNew.ASC_SL_Identifier__c 
              || gspOld.ASC_SL_Identifier_Data__c != gspNew.ASC_SL_Identifier_Data__c || gspOld.ASC_Attachment_Point__c 
              != gspNew.ASC_Attachment_Point__c || gspOld.ASC_Cost_Share_Maximum__c != gspNew.ASC_Cost_Share_Maximum__c 
              || gspOld.ASC_Cost_Share_Percent__c != gspNew.ASC_Cost_Share_Percent__c
              )
             )
            ){
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+LASERSHARING_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew); 
    
            }           
            if(MULTATTACHPOINT_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
             (
              (gspOld == null && (gspNew.ASC_SL_Identifier__c !=null || gspNew.ASC_SL_Identifier_Data__c !=null 
              || gspNew.ASC_Attachment_Point__c !=null || gspNew.Aggregating_Deductible__c !=null 
              || gspNew.ASC_Cost_Share_Percent__c !=null || gspNew.ASC_Unit_Price__c !=null)) 
              || 
              (gspOld.ASC_SL_Identifier__c !=gspNew.ASC_SL_Identifier__c 
              || gspOld.ASC_SL_Identifier_Data__c != gspNew.ASC_SL_Identifier_Data__c || gspOld.ASC_Attachment_Point__c 
              != gspNew.ASC_Attachment_Point__c || gspOld.Aggregating_Deductible__c != gspNew.Aggregating_Deductible__c 
              || gspOld.ASC_Cost_Share_Percent__c != gspNew.ASC_Cost_Share_Percent__c  
              || gspOld.ASC_Unit_Price__c != gspNew.ASC_Unit_Price__c   
              )
             )
            ){              
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+MULTATTACHPOINT_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }           
            if(COSTSHARING_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
             (
              (gspOld == null && (gspNew.ASC_Cost_Share_Maximum__c !=null || gspNew.ASC_Cost_Share_Percent__c !=null)) || 
              (gspOld.ASC_Cost_Share_Maximum__c !=gspNew.ASC_Cost_Share_Maximum__c 
              || gspOld.ASC_Cost_Share_Percent__c != gspNew.ASC_Cost_Share_Percent__c
              )
             )
            ){
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+COSTSHARING_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }   
            if(EXPERIENCEREF_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
             (
              (gspOld == null && (gspNew.ASC_Total_Stop_Loss_Premium__c !=null || gspNew.ASC_Refund_Percent__c !=null)) || 
              (gspOld.ASC_Total_Stop_Loss_Premium__c 
              !=gspNew.ASC_Total_Stop_Loss_Premium__c || gspOld.ASC_Refund_Percent__c != gspNew.ASC_Refund_Percent__c 
              )
             )
            ){
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+EXPERIENCEREF_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew); 
    
            }      
            if(LEVELPAYMENT_PRDCODE.equals(gspNew.ASC_Product_Code__c) && 
             (
              (gspOld == null && (gspNew.ASC_Level_Payment_Claims_Amount__c !=null 
              || gspNew.ASC_Estimated_Monthly_Contracts__c !=null || gspNew.ASC_Unit_Price__c !=null))
              || 
              (gspOld.ASC_Level_Payment_Claims_Amount__c 
              !=gspNew.ASC_Level_Payment_Claims_Amount__c || gspOld.ASC_Estimated_Monthly_Contracts__c 
              != gspNew.ASC_Estimated_Monthly_Contracts__c || gspOld.ASC_Unit_Price__c != gspNew.ASC_Unit_Price__c
              )
             )
            ){
                String keySt = gspNew.ASC_CID__c+UNDERSCORE+gspNew.ASC_Carrier__c+
                               UNDERSCORE+gspNew.ASC_Sub_Segment__c+UNDERSCORE+LEVELPAYMENT_PRDCODE;     
                existingUniqueKeySet.put(keySt,gspNew);     
            }   
        }
        }           
        for(QuoteLineItem uniqRec:[select Id,Quote.ASC_CID__c,Quote.ASC_Carrier__c,ASC_Effective_Start_Date__c,
                                                  ASC_Effective_End_Date__c,ASC_Product_Code__c,
                                                  Quote.ASC_Sub_Segment__c from QuoteLineItem 
                                                  Where Quote.ASC_CID__c IN:cid
                                                  AND Quote.ASC_Carrier__c IN:carr
                                                  AND ASC_Product_Code__c IN:prdCode
                                                  //AND Quote.ASC_Sub_Segment__c IN:sugSegment
                                                  AND Quote.ASC_CID__c !=null
                                                  AND Quote.ASC_Carrier__c !=null
                                                  AND ASC_Effective_Start_Date__c !=null
                                                  AND ASC_Effective_End_Date__c !=null                                                  
                                                  Limit :UTIL_SLB.retrieveQueryLimitValue()]){
              String keySt1 = uniqRec.Quote.ASC_CID__c+UNDERSCORE+uniqRec.Quote.ASC_Carrier__c+UNDERSCORE+
                              uniqRec.Quote.ASC_Sub_Segment__c+UNDERSCORE+uniqRec.ASC_Product_Code__c;
              if(existingUniqueKeySet.ContainsKey(keySt1) 
                 && uniqRec.ASC_Effective_Start_Date__c <= existingUniqueKeySet.get(keySt1).ASC_Effective_End_Date__c
                 && uniqRec.ASC_Effective_Start_Date__c >= existingUniqueKeySet.get(keySt1).ASC_Effective_Date__c){ 
                 uniqRec.ASC_Last_Price_Modified_Date__c = existingUniqueKeySet.get(keySt1).LastModifiedDate;
                 qliListUpdate.add(uniqRec);
              }
        }        
        
        if(!qliListUpdate.isEmpty()){
          Database.update(qliListUpdate,false);        
        }        
      } 
      catch(exception e){ GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME);
      }                  
   }
}