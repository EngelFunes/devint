/**************************************************************************************************************************
@Author : Sandeep
@Name: ASC_LIE_TriggerHandler_Test 
@CreatedDate: 05 May 2020
@Description: ASC_LIE_TriggerHandler_Test class is used to cover ASC_LIE_TriggerHandler and related Handler and Helper classes.
@version : 1.0  
****************************************************************************************************************************/
@isTest(seealldata = false)
public class ASC_LIE_TriggerHandler_Test {
    
    private static final string LIENAME  ='TEST LIE';
    private static final Integer QUANTITY = 20;
    private static final Double COUPONSAVINGS = 20;
    private static final Double COUPONSAVINGSDECIMAL = 20.50;
    private static final Double AWP1 = 20;
    private static final Double AWP1DECIMAL = 20.65;
    private static final Double AWP2 = 20;
    private static final Double AWP2DECIMAL = 20.75;
    
    /*******************************************************************************************************************************
@Description: ConvertNumberToWords_test1() method - preparing the test data
@Name : ConvertNumberToWords_test1
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    
    private static testMethod void ConvertNumberToWords_test1(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Integration User');
        database.insert(usr);
        system.runAs(usr){
            List<Line_Item_Extension__c> LieLst=new list<Line_Item_Extension__c>();
            Line_Item_Extension__c lie = new Line_Item_Extension__c();
            lie.name = LIENAME;
            lie.Quantity__c = QUANTITY;
            lie.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
            lie.AWP_1__c=AWP1;
            lie.AWP_2__c=AWP2;
            LieLst.add(Lie);
            
            Line_Item_Extension__c lie1 = new Line_Item_Extension__c();
            lie1.name = LIENAME;
            lie1.Quantity__c = QUANTITY;
            lie1.Percent_of_Coupon_Savings__c=COUPONSAVINGSDECIMAL;
            lie1.AWP_1__c=AWP1DECIMAL;
            lie1.AWP_2__c=AWP2DECIMAL;
            LieLst.add(Lie1);
            Database.insert(LieLst);
            
            lie.AWP_1__c=AWP1DECIMAL;
            lie.AWP_2__c=AWP2DECIMAL;
            Database.update(lie);          
            lie1.AWP_1__c=AWP1;
            lie1.AWP_2__c=AWP2;
            Database.update(lie1);     
            
            
        }
    }
    
}