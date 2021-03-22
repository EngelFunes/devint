/*
@Author : IDC offshore
@Name: GA_BCNHstry_AP02_BCNNamingConventn_Test 
@CreatedDate: 8/21/2019
@Description: GA_BCNHstry_AP02_BCNNamingConventn_Test Test class
@version : 1.0  
*/
@isTest(seeAllData=false)
private class GA_BCNHstry_AP02_BCNNamingConventn_Test {
    
    /*******************************************************************************************************************************
@Description: updateBCNName() method 
@Name : updateBCNName
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void updateBCNName(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc1);
                
                GA_City_Code__c cty1 = new GA_City_Code__c();
                cty1.Name ='OTHER';
                database.insert(cty1);
                
                GA_County_Code__c cnty = new GA_County_Code__c();
                cnty.Name = 'Alger';
                database.insert(cnty);
                
                GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
                gsmt.Name = '00003_002';
                gsmt.GA_Account__c = acc1.id;
                gsmt.GA_Physical_Address_1__c= 'test address';
                gsmt.GA_Physical_City__c= cty1.Id;
                gsmt.GA_Physical_City_Other__c = 'HDC3';
                gsmt.GA_Physical_State__c ='telangana';
                gsmt.GA_Physical_County_Id__c=cnty.id;                             
                gsmt.GA_Physical_Zip__c ='243243';            
                gsmt.GA_Copy_Address_From__c ='Physical to Mailing';  
                database.insert(gsmt);
                
                GA_Plan_Year_Exception_History__c planexcpt = new GA_Plan_Year_Exception_History__c();
                planexcpt.GA_Group_Segment__c=gsmt.id;
                planexcpt.GA_Plan_Year_Month__c='01';
                planexcpt.GA_Start_Date__c=system.today();
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.endDateExecuting  = true;
                database.insert(planexcpt);
                
                GA_BCNHstry_TriggerHandlr.isExecuting = false;
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.endDateExecuting  = false;
                
                planexcpt.GA_Plan_Year_Month__c='02';
                database.update(planexcpt);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: updatBCN_batch() method 
@Name : updatBCN_batch
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void updatBCN_batch(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc1);
                
                GA_City_Code__c cty1 = new GA_City_Code__c();
                cty1.Name ='OTHER';
                database.insert(cty1);
                
                GA_County_Code__c cnty = new GA_County_Code__c();
                cnty.Name = 'Alger';
                database.insert(cnty);
                
                GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
                gsmt.Name = '00003_002';
                gsmt.GA_Account__c = acc1.id;
                gsmt.GA_Physical_Address_1__c= 'test address';
                gsmt.GA_Physical_City__c= cty1.Id;
                gsmt.GA_Physical_City_Other__c = 'HDC3';
                gsmt.GA_Physical_State__c ='telangana';
                gsmt.GA_Physical_County_Id__c=cnty.id;                             
                gsmt.GA_Physical_Zip__c ='243243';            
                gsmt.GA_Copy_Address_From__c ='Physical to Mailing';  
                database.insert(gsmt);
                
                List<GA_Plan_Year_Exception_History__c> planExcptLst = New  List<GA_Plan_Year_Exception_History__c>();
                GA_Plan_Year_Exception_History__c planexcpt = new GA_Plan_Year_Exception_History__c();
                for(integer i=0 ; i< 101 ; i++){
                    planexcpt = new GA_Plan_Year_Exception_History__c();
                    planexcpt.GA_Group_Segment__c=gsmt.id;
                    planexcpt.GA_Plan_Year_Month__c='01';
                    planexcpt.GA_Start_Date__c=system.today();
                    planExcptLst.add(planexcpt);    
                }
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.endDateExecuting  = true;
                database.insert(planExcptLst);
                
                GA_BCNHstry_TriggerHandlr.isExecuting = false;
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.endDateExecuting  = false;
                
                planexcpt.GA_Plan_Year_Month__c='02';
                database.update(planexcpt);
                
                GA_BCNHstry_TriggerHandlr.isExecuting = true;
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.endDateExecuting  = false;
                List<GA_Plan_Year_Exception_History__c> bcnLst = New List<GA_Plan_Year_Exception_History__c>();
                bcnLst.add(planexcpt);
                GA_BCNHstry_TriggerHandlr.afterInsert(bcnLst);
                
                List<GA_Plan_Year_Exception_History__c> updtplanExcptLst = New  List<GA_Plan_Year_Exception_History__c>();
                for(GA_Plan_Year_Exception_History__c plYrExcp : planExcptLst){
                    planexcpt = new GA_Plan_Year_Exception_History__c();
                    planexcpt.id=plYrExcp.id;
                    planexcpt.GA_Plan_Year_Month__c='03';
                    planexcpt.GA_Start_Date__c=system.today()+ 1;
                    updtplanExcptLst.add(planexcpt);
                }
                
                GA_BCNHstry_TriggerHandlr.isExecuting = true;
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.endDateExecuting  = false;
                
                GA_BCNHstry_TriggerHandlr.afterInsert(updtplanExcptLst);
                
                GA_BCNHstry_TriggerHandlr.isExecuting = true;
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.endDateExecuting  = false;
                GA_BCNHstry_TriggerHandlr.afterUpdate(updtplanExcptLst,null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: updateBCNNameFuture() method 
@Name : updateBCNNameFuture
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void updateBCNNameFuture(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc1);
                
                GA_City_Code__c cty1 = new GA_City_Code__c();
                cty1.Name ='OTHER';
                database.insert(cty1);
                
                GA_County_Code__c cnty = new GA_County_Code__c();
                cnty.Name = 'Alger';
                database.insert(cnty);
                
                GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
                gsmt.Name = '00003_002';
                gsmt.GA_Account__c = acc1.id;
                gsmt.GA_Physical_Address_1__c= 'test address';
                gsmt.GA_Physical_City__c= cty1.Id;
                gsmt.GA_Physical_City_Other__c = 'HDC3';
                gsmt.GA_Physical_State__c ='telangana';
                gsmt.GA_Physical_County_Id__c=cnty.id;                             
                gsmt.GA_Physical_Zip__c ='243243';            
                gsmt.GA_Copy_Address_From__c ='Physical to Mailing';  
                database.insert(gsmt);
                
                GA_Plan_Year_Exception_History__c planexcpt = new GA_Plan_Year_Exception_History__c();
                planexcpt.GA_Group_Segment__c=gsmt.id;
                planexcpt.GA_Plan_Year_Month__c='10';
                planexcpt.GA_Start_Date__c=system.today();
                database.insert(planexcpt);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}