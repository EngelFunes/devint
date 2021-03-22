/**************************************************************************************************************************
@Author : Dinesh
@Name: ASC_LIE_TriggerHelper_Test 
@CreatedDate: 16 July 2020
@Description: ASC_LIE_TriggerHelper_Test class is used to cover ASC_LIE_TriggerHelper class.
@version : 1.0  
****************************************************************************************************************************/
@isTest(seealldata = false)
public class ASC_LIE_TriggerHelper_Test {
    
    private static final string LIENAME  ='TEST LIE';
    private static final Integer QUANTITY = 20;
    private static final Double COUPONSAVINGS = 20;
    private static final Double COUPONSAVINGSDECIMAL = 20.50;
    private static final Double AWP1 = 20;
    private static final Double AWP1DECIMAL = 20.65;
    private static final Double AWP2 = 20;
    private static final Double AWP2DECIMAL = 20.75;
    private static final String LIENAMEPRD = 'Data Feeds 1';
    private static final string PRD_NAME = 'Data Feeds 1';
    private static final string PRD_CODE = 'ASC_0000081';
    private static final string PRD_FAMILY = 'Data Feeds';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final string TYPE  ='ASC Product';
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'Integration User';

    /*******************************************************************************************************************************
    @Description: initData() method - preparing the test data
    @Name : initData
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    @TestSetup static void initData() {

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
            
            Product2 prod= new product2(
            Name = PRD_NAME,
            productcode = PRD_CODE,
            Family = PRD_FAMILY,
            vlocity_ins__LineOfBusiness__c = PRD_LOB,
            vlocity_ins__SubType__c = TYPE,
            vlocity_ins__Type__c = TYPE,
            vlocity_ins__EffectiveDate__c = system.today()
            );
            Database.insert(prod,false);

            Line_Item_Extension__c lie2 = new Line_Item_Extension__c();
            lie2.name = LIENAMEPRD;
            lie2.Product__c = prod.Id;
            lie2.Quantity__c = QUANTITY;
            lie2.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
            lie2.AWP_1__c=AWP1;
            lie2.AWP_2__c=AWP2;
            Database.insert(lie2,false);
    }
    
    /*******************************************************************************************************************************
    @Description: updateLIERecType_method is used to pass the Line Item Extension records to the updateLIERecType method with Product is not null
    @Name : updateLIERecType_method
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/        
    public static testMethod void updateLIERecType_method1(){
      try{
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runAs(usr){
            List<Line_Item_Extension__c> litemExtList = [Select Id,Name from Line_Item_Extension__c 
                                                         where Product__c !=null
                                                         Limit :UTIL_SLB.retrieveQueryLimitValue()];
            ASC_LIE_TriggerHelper.updateLIERecType(litemExtList);
        }
      }
      catch(exception e)
      {
        system.assert(e <> null);
        return;
      }
    }
            
    /*******************************************************************************************************************************
    @Description: updateLIERecType_method is used to pass the Line Item Extension records to the updateLIERecType method
    @Name : updateLIERecType_method
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/        
    public static testMethod void updateLIERecType_method2(){
      try{
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runAs(usr){
            List<Line_Item_Extension__c> litemExtList = [Select Id,Name from Line_Item_Extension__c
                                                         Limit :UTIL_SLB.retrieveQueryLimitValue()];
            ASC_LIE_TriggerHelper.updateLIERecType(litemExtList);
        }
      }
      catch(exception e)
      {
        system.assert(e <> null);
        return;
      }      
    }    
}