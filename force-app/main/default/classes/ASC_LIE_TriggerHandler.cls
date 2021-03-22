/***************************************************************************************************************
@Author : Offshore
@Name: ASC_LIE_TriggerHandler
@CreatedDate: 15 - May - 2020 
@Description: 
@version : 1.0  
---Modified --
@US3193 Added By Dinesh- update the LIE RecordType when LIE record is created - 07/14/2020
***************************************************************************************************************/
public with sharing class ASC_LIE_TriggerHandler {
    public static final string CLSNAME  ='ASC_LIE_TriggerHandler';
    public static final string METHODNMEBEFOREUPDATE  ='beforeUpdate'; 
    private static final string METHODNMEBEFOREINSERT  ='beforeInsert';
    
    /**************************************************************************************************************
    @Description: 
    @Name : beforeinsert
    @Param : list<Line_Item_Extension__c> LIEList
    @Return : void
    @throws Exception : N/A;
    **************************************************************************************************************/         
    public static void beforeInsert(list<Line_Item_Extension__c> LIEList)
    {      
        try{
            List<String> productIds =new List<String>();
            for(Line_Item_Extension__c  eachLIE : LIEList){
                if(eachLIE.Product__c !=null)
                {
                    productIds.add(String.valueOf(eachLIE.Product__c));
                }
            }
            Map<ID,Product2> productDetailsMap = new Map<ID,Product2>();
            productDetailsMap = new Map<ID,Product2>([Select Id,Name from Product2 
                                                      where Id IN:productIds]);
            for(Line_Item_Extension__c  eachLIE : LIEList){
                if(eachLIE.Name == null && eachLIE.Product__c !=null)
                {
                    Product2 prdRec = productDetailsMap.get(eachLIE.Product__c);eachLIE.Name=prdRec.Name;
                }
            }
            ConvertNumberToWords(LIEList);
            /*US3193 Added By Dinesh- update the LIE RecordType when LIE record is created - 07/14/2020 */
            if(!ASC_QLI_LineItemExtensionsAttrUpdate.isLIERecTypeUpdated){
                ASC_LIE_TriggerHelper.updateLIERecType(LIEList);            
            }
        }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEBEFOREINSERT);}
    }
    /**************************************************************************************************************
    @Description: 
    @Name : beforeupdate
    @Param : list<Line_Item_Extension__c> LIEList
    @Return : void
    @throws Exception : N/A;
    **************************************************************************************************************/     
    public static void beforeUpdate(list<Line_Item_Extension__c> LIEList)
    {
        try{
            ConvertNumberToWords(LIEList); 
             }
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEBEFOREUPDATE);}    
    }
  
    /*************************************************************************************************************
    @Description: To convert number to word format
    @Name : ConvertNumberToWords
    @Param : list<Line_Item_Extension__c> LIEList
    @Return : void
    @throws Exception : N/A;
    *************************************************************************************************************/         
    public static void ConvertNumberToWords(list<Line_Item_Extension__c> LIEList)
    {
        try{ 
            for(Line_Item_Extension__c  eachLIE : LIEList){
                if(eachLIE.Percent_of_Coupon_Savings__c != null)
                {
                    if(eachLIE.Percent_of_Coupon_Savings__c.ToPlainString().substringAfter('.').equals('00'))
                    {
                        String numberToWord = ASC_ConvertNumberToWords.english_number(Long.valueOf(eachLIE.Percent_of_Coupon_Savings__c.toPlainString()));
                        eachLIE.Percent_of_Coupon_Savings_words__c = numberToWord.toLowerCase()+' percent ('+ eachLIE.Percent_of_Coupon_Savings__c.ToPlainString() + '%)';
                    }
                    else
                    {
                        eachLIE.Percent_of_Coupon_Savings_words__c  = eachLIE.Percent_of_Coupon_Savings__c.ToPlainString();
                    }
                }
                if(eachLIE.AWP_1__c!= null)
                {
                    if(eachLIE.AWP_1__c.ToPlainString().substringAfter('.').equals('00'))
                    {
                        String numberToWord = ASC_ConvertNumberToWords.english_number(Long.valueOf(eachLIE.AWP_1__c .toPlainString()));
                        eachLIE.AWP_1_IN_Words__c = numberToWord.toLowerCase()+ ' ( '+ eachLIE.AWP_1__c.intValue() +' )' ;  
                    }
                    else
                    {
                        eachLIE.AWP_1_IN_Words__c = eachLIE.AWP_1__c.ToPlainString();
                    }
                }
                if(eachLIE.AWP_2__c!= null)
                {
                    if(eachLIE.AWP_2__c.ToPlainString().substringAfter('.').equals('00'))
                    {
                        String numberToWord = ASC_ConvertNumberToWords.english_number(Long.valueOf(eachLIE.AWP_2__c .toPlainString()));
                        eachLIE.AWP_2_IN_Words__c = numberToWord.toLowerCase()+ ' ( '+ eachLIE.AWP_2__c.intValue() +' )' ;  
                    }
                    else
                    {
                        eachLIE.AWP_2_IN_Words__c = eachLIE.AWP_2__c.ToPlainString();
                    }
                }
            }
        }         
        catch(exception e){GA_LogExceptionCls.LogExcp(e, 'ASC_LIE_TriggerHandler', 'ConvertNumberToWords');}        
    }
    /*This for the line item extension compre the unit price and original price*/
    public static void pricingVarience(list<Line_Item_Extension__c> lineItems){
        list<Id> quotelineIds =new list<Id>();
        for(Line_Item_Extension__c lie:lineItems){
            System.debug(lie.UnitPrice__c +' '+lie.Original_Price__c);
            if(lie.UnitPrice__c != lie.Original_Price__c || lie.Activation_Lead_Time_Approval__c== true || lie.Tier__c=='No' /*|| lie.Product__r.ASC_Approval_Required__c == true*/){
                System.debug('Entry '+lie.Quote_Line_Item__r.QuoteId);
                quotelineIds.add(lie.QLI_ID__c);
            }
        }
        System.debug(quotelineIds);
        if(quotelineIds.size()>0)
        {
            List<Quotelineitem> qliList = new List<Quotelineitem>();
            Set<id> quoteIds = new Set<Id>();
            List<Quotelineitem> lstquote = [SELECT Id,QuoteId FROM QuotelineItem WHERE Id IN:quotelineIds];
            for(Quotelineitem qli :lstquote){
                Quotelineitem newQli= new Quotelineitem(id=qli.id, ASC_Variance_For_Approval__c = True);
                qliList.add(newQli);
            }
            if(qliList.size()>0){
                update qliList;
                System.debug(qliList);
            }
        }
    } 
}