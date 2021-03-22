/**
@Author : Mida
@Name: ASC_PricingValidation
@CreatedDate: 04 - April 2020 
@Description: This class is to used for Validation - Duplicate check - To prevent record creation/updation
@version : 1.0  
@US Number: US-3044
*/
public without sharing class ASC_PricingValidation {

public static final string CLASSNAME  ='ASC_PricingValidation';
public static final string METHODNME  ='checkForDuplicateGSP';
public static final string METHODUPDATELASTGSP  ='UpdateLastGSP';
private static final String ERROR_MSG = 'Pricing Data already exists.';
private static final String UNDERSCORE = '_';


/********************************************************************************************************************
@Description        :   This method is used to Update the Qli Field when GroupSpecificPricing Record is Inactive , 
                        
@Name               :   UpdateLastGSP
@Param              :   list<ASC_Group_Specific_Pricing__c> gspList
@Return             :   void
@throws Exception   :   N/A;    
********************************************************************************************************************************/         
public static void UpdateLastGSP(list<ASC_Group_Specific_Pricing__c> gspList){
List<QuoteLineItem > updateQliList = new List<QuoteLineItem >();

// Collecting ASC_Group_Specific_Pricing__c records and QuoteLineItem records
List<ASC_Group_Specific_Pricing__c>ascGspList =  [SELECT Id,ASC_Deleted__c,LastModifiedDate, (SELECT Id,ASC_Last_Price_Modified_Date__c FROM Quote_Line_Items_del__r) FROM ASC_Group_Specific_Pricing__c WHERE Id IN: gspList];   

if(ascGspList.size()>0 && !ascGspList.isEmpty()){
for(ASC_Group_Specific_Pricing__c gsp : ascGspList){

if(gsp.ASC_Deleted__c){
   
     if(gsp.Quote_Line_Items_del__r.size()>0){
     
        for(QuoteLineItem ql: gsp.Quote_Line_Items_del__r){
                     ql.ASC_Last_Price_Modified_Date__c = gsp.LastModifiedDate;
                     updateQliList.add(ql);
               }
     
     }   
   }
}

// Updating QuoteLineItem
update updateQliList;
}

}



/********************************************************************************************************************
@Description        :   This method is used to check for duplicate check on combition of fields , 
                        if there is match exist on record , it will prevent to create a new records updating the existing records
@Name               :   checkForDuplicateGSP
@Param              :   list<ASC_Group_Specific_Pricing__c> gspList,map<id,ASC_Group_Specific_Pricing__c> gspoldMap
@Return             :   void
@throws Exception   :   N/A;    
********************************************************************************************************************************/         
public static void checkForDuplicateGSP(list<ASC_Group_Specific_Pricing__c> gspList,
                                      map<id,ASC_Group_Specific_Pricing__c> gspoldMap){ 
    
set<String> acc =new set<String>();
set<String> prd=new set<String>();
set<String> carr=new set<String>();
set<String> lob=new set<String>();
set<Date> startDate=new set<Date>();
set<Date> endDate=new set<Date>();
set<String> subSeg=new set<String>();
set<String> grpIdSet =new set<String>();
set<String> existingUniqueKeySet =new set<String>();
try{
    if(!gspList.isEmpty()){
        for(ASC_Group_Specific_Pricing__c gsp:gspList){
            acc.add(gsp.ASC_Group__c);
            prd.add(gsp.ASC_Product__c);
            carr.add(gsp.ASC_Carrier__c);
            lob.add(gsp.ASC_LOB__c);
            startDate.add(gsp.ASC_Effective_Date__c);
            endDate.add(gsp.ASC_Effective_End_Date__c);
            subSeg.add(gsp.ASC_Sub_Segment__c );    
            grpIdSet.add(gsp.Id);
                         
        }                
        /*
        US-3112 -Added By Dinesh - updated the ASC_Deleted__c = false in the below query ignore the deleted flag in duplicate check
       */
        for(ASC_Group_Specific_Pricing__c dupRec:[select Id,ASC_Group__c,ASC_Carrier__c,ASC_Effective_Date__c,
                       ASC_Effective_End_Date__c,ASC_LOB__c,ASC_Product__c,ASC_Sub_Segment__c from ASC_Group_Specific_Pricing__c 
                       Where ASC_Group__c IN:acc AND ASC_Carrier__c IN:carr and ASC_Effective_Date__c IN:startdate 
                       and ASC_Effective_End_Date__c IN:endDate and ASC_LOB__c IN:lob and ASC_Product__c IN:prd 
                       and ASC_Sub_Segment__c IN:subSeg 
                       and Id Not IN:grpIdSet
                       and ASC_Deleted__c = false 
                       Limit :UTIL_SLB.retrieveQueryLimitValue()]){
        existingUniqueKeySet.add(dupRec.ASC_Group__c+UNDERSCORE+dupRec.ASC_Product__c+UNDERSCORE+dupRec.ASC_Carrier__c+UNDERSCORE+
                                  dupRec.ASC_LOB__c+UNDERSCORE+dupRec.ASC_Effective_Date__c+UNDERSCORE+dupRec.ASC_Effective_End_Date__c+
                                  UNDERSCORE+dupRec.ASC_Sub_Segment__c);           
        }    
        if(!existingUniqueKeySet.isEmpty()){                                                                                                                                           
            for(ASC_Group_Specific_Pricing__c gsp:gspList){    
                String uniqueKey = gsp.ASC_Group__c+UNDERSCORE+gsp.ASC_Product__c+UNDERSCORE+gsp.ASC_Carrier__c+UNDERSCORE+gsp.ASC_LOB__c+
                                   UNDERSCORE+gsp.ASC_Effective_Date__c+UNDERSCORE+gsp.ASC_Effective_End_Date__c+UNDERSCORE+gsp.ASC_Sub_Segment__c;      
             if(gspoldMap == null || (gspoldMap !=null && (gsp.ASC_Group__c != gspoldMap.get(gsp.Id).ASC_Group__c ||
               gsp.ASC_Product__c != gspoldMap.get(gsp.Id).ASC_Product__c  || gsp.ASC_Effective_End_Date__c
               !=gspoldMap.get(gsp.Id).ASC_Effective_End_Date__c || gsp.ASC_Sub_Segment__c != gspoldMap.get(gsp.Id).ASC_Sub_Segment__c ||
               gsp.ASC_Carrier__c != gspoldMap.get(gsp.Id).ASC_Carrier__c || gsp.ASC_Effective_Date__c 
               != gspoldMap.get(gsp.Id).ASC_Effective_Date__c || gsp.ASC_LOB__c != gspoldMap.get(gsp.Id).ASC_LOB__c ))){  

                if(existingUniqueKeySet.Contains(uniqueKey)){
                        gsp.addError(ERROR_MSG); 
                }                    
             }                                                               
            }
        }
    }
  }
  catch(exception e){
    GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNME);
  }            
}    
}