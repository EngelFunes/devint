/*******************************************************************************************************************************
@Author : IDC offshore
@Name: ASC_Product_NamingConvention_Test
@CreatedDate:3/6/2020 
@Description: ASC Product Naming Convention
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_Product_NamingConvention_Test {
/*******************************************************************************************************************************
@Description: ASC_ProductNameConvTest1() method 
@Name : ASC_ProductNameConvTest1
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
private static testmethod void test_ASC_ProductNameConvTest1(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                
                List<Product2> prdList = new List<Product2>();
                Product2 prd = new Product2();
                prd.vlocity_ins__Type__c = 'ASC Product';
                prd.Name ='TEST Product1';
                Database.insert (prd, false);
                prd.ProductCode='ASC_0000012';
                Database.update (prd, false);             
                Product2 prd2 = new Product2();
                prd2.vlocity_ins__Type__c = 'ASC Product';
                prd2.Name ='TEST Product1';
                Database.insert (prd2);
                prd.ProductCode='ASC_0000112';
                Database.update (prd);
                Product2 prd3 = new Product2();
                prd3.vlocity_ins__Type__c = 'ASC Product';
                prd3.Name ='TEST Product1';
                Database.insert (prd3, false);
                prd.ProductCode='ASC_0001112';
                Database.update (prd, false);
                Product2 prd4 = new Product2();
                prd4.vlocity_ins__Type__c = 'ASC Product';
                prd4.Name ='TEST Product1';
                Database.insert (prd4, false);               
                prd.ProductCode='ASC_0011112';
                Database.update (prd, false);
                Product2 prd5 = new Product2();
                prd5.vlocity_ins__Type__c = 'ASC Product';
                prd5.Name ='TEST Product1';
                Database.insert (prd5, false);             
                prd.ProductCode='ASC_0111112';
                Database.update (prd, false);
                Product2 prd6 = new Product2();
                prd6.vlocity_ins__Type__c = 'ASC Product';
                prd6.Name ='TEST Product1';               
                Database.insert (prd6, false);       
                prd.ProductCode='ASC_1111112';
                Database.update (prd, false);              
                Product2 prd7 = new Product2();
                prd7.vlocity_ins__Type__c = 'ASC Product';
                prd7.Name ='TEST Product1';         
                Database.insert (prd7, false);             
                prdList.add(prd2);
                prdList.add(prd3);
                prdList.add(prd4);
                prdList.add(prd5);
                prdList.add(prd6);
                prdList.add(prd7);    
                Test.startTest();
                ASC_Product_NamingConvention.updtProductCode(prdList);
               Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
/*******************************************************************************************************************************
@Description: ASC_ProductNameConvTest2() method 
@Name : ASC_ProductNameConvTest2
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
private static testmethod void test_ASC_ProductNameConvTest2(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Test.startTest();                          
                ASC_Product_NamingConvention.updtProductCode(null);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
/*******************************************************************************************************************************
@Description: ASC_ProductNameConvTest3() method 
@Name : ASC_ProductNameConvTest3
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
private static testmethod void test_ASC_ProductNameConvTest3(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                
                List<Product2> prdList = new List<Product2>();
                Product2 prd = new Product2();
                prd.vlocity_ins__Type__c = 'ASC Product';
                prd.Name ='TEST Product1';
                Database.insert (prd, false);          
                prd.ProductCode='ASC_0111112';
                Database.update (prd, false);
                Product2 prd6 = new Product2();
                prd6.vlocity_ins__Type__c = 'ASC Product';
                prd6.Name ='TEST Product1';              
                Database.insert (prd6, false);
                prd.ProductCode='ASC_1111112';
                Database.update (prd,false);  
                Product2 prd7 = new Product2();
                prd7.vlocity_ins__Type__c = 'ASC Product';
                prd7.Name ='TEST Product1';                
                Database.insert (prd7, false);                                         
                prdList.add(prd6);
                prdList.add(prd7);  
                Test.startTest();
                ASC_Product_NamingConvention.updtProductCode(prdList);              
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
}