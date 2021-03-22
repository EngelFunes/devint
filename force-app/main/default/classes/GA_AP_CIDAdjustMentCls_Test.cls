/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AP_CIDAdjustMentCls_Test
@CreatedDate: 20 - Feb 2019 
@Description: GA_AP_CIDAdjustMentCls_Test class is for GA_AP_CIDAdjustMentCls.
@version : 1.0  
********************************************************************************************************************************/
@isTest
private class GA_AP_CIDAdjustMentCls_Test {
/*******************************************************************************************************************************
@Description: CIDAdjustMentRecTest() method 
@Name : CIDAdjustMentRecTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
   private static testmethod void CIDAdjustMentRecTest(){
    user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount1);
                
                Account testAccount2= GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount2);
                
                GA_Group_Segment__c gs=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount1);  
                gs.Status__c='Active';
                gs.GA_In_Progress__c=True;
                database.insert(gs);
                
                gs.Status__c='Pending';
                database.update(gs);
                
                List<GA_Group_Segment__c> Gslst = new List<GA_Group_Segment__c>();
                Gslst.add(gs);
                
                GA_CID_Adjustment__c CIdRec=GA_OBJ_TD01_TestDataCreation.cidAdjRecrd();
                CIdRec.GA_Source_Account__c  = testAccount1.Id;
                CIdRec.GA_Target_Account__c  = testAccount2.Id;
                database.insert(CIdRec);
                
                Test.startTest();
             	GA_AP_CIDAdjustMentCls.fetchCIDAdjCreate();  
                GA_AP_CIDAdjustMentCls.fetchSourceAcntInfo(testAccount1.Id);
                GA_AP_CIDAdjustMentCls.fetchTrgtAcntInfo(testAccount2.Id);
                GA_AP_CIDAdjustMentCls.creteCIDAdjustmntRecs(testAccount1,testAccount2,Gslst,true,true,true,CIdRec.Id);
                GA_AP_CIDAdjustMentCls.submitCIDAjustment(CIdRec.Id);
                GA_AP_CIDAdjustMentCls.fectCIDInfo(CIdRec.Id);
                Test.stopTest();
  
                system.debug('CIDOwner' +CIdRec.OwnerId);
                system.debug('CIDOwnerType' +CIdRec.Owner.Type);
            }
             catch(exception e)
            {
                return;
            }
        }
    }
/*******************************************************************************************************************************
@Description: CIDAdjAssnmtOwnrUsr() method 
@Name : CIDAdjAssnmtOwnrUsr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
   private static testmethod void CIDAdjustMentRecCatch(){
    user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','Medicare Advantage Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                Test.startTest();
             	GA_AP_CIDAdjustMentCls.fetchCIDAdjCreate();  
                GA_AP_CIDAdjustMentCls.fetchSourceAcntInfo(null);
                GA_AP_CIDAdjustMentCls.fetchTrgtAcntInfo(null);
                GA_AP_CIDAdjustMentCls.creteCIDAdjustmntRecs(null,null,null,null,null,null,null);
                GA_AP_CIDAdjustMentCls.submitCIDAjustment(null);
                GA_AP_CIDAdjustMentCls.fectCIDInfo(null);
                Test.stopTest();
  
            }
             catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: CIDAdjustMentRecMos() method 
@Name : CIDAdjustMentRecMos
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
   private static testmethod void CIDAdjustMentRecMos(){
    user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount1);
                
                Account testAccount2= GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount2);
                
                GA_Group_Segment__c gs=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount1);  
                gs.Status__c='Pending';
                gs.Network__c='MOS';
                database.insert(gs);
                
                gs.Status__c='Active';
                gs.GA_MTV_Group__c = 'Test';
                database.update(gs);
                
                system.debug('gs Status'+gs.Status__c);
                
                
                List<GA_Group_Segment__c> Gslst = new List<GA_Group_Segment__c>();
                Gslst.add(gs);
 
                GA_CID_Adjustment__c CIdRec=GA_OBJ_TD01_TestDataCreation.cidAdjRecrd();
                CIdRec.GA_Source_Account__c  = testAccount1.Id;
                CIdRec.GA_Target_Account__c  = testAccount2.Id;
                database.insert(CIdRec);
                
                GA_Process_Group_Segment__c PrGS = new GA_Process_Group_Segment__c();
                PrGS.GA_CID_Adjustment__c=CIdRec.Id;
                PrGS.GA_Group_Segment__c=gs.Id;
                database.insert(PrGS);
                
                Test.startTest();
             	GA_AP_CIDAdjustMentCls.fetchCIDAdjCreate();  
                GA_AP_CIDAdjustMentCls.fetchSourceAcntInfo(testAccount1.Id);
                GA_AP_CIDAdjustMentCls.fetchTrgtAcntInfo(testAccount2.Id);
                GA_AP_CIDAdjustMentCls.creteCIDAdjustmntRecs(testAccount1,testAccount2,Gslst,true,true,true,CIdRec.Id);
                GA_AP_CIDAdjustMentCls.submitCIDAjustment(CIdRec.Id);
                GA_AP_CIDAdjustMentCls.fectCIDInfo(CIdRec.Id);
                Test.stopTest();
  
            }
             catch(exception e)
            {
                return;
            }
        }
    }
}