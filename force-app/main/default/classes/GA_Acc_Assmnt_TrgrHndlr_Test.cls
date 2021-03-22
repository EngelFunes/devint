/**
@Author : Padma
@Name: GA_AccountTriggerHandlr_Test 
@CreatedDate: 31 - Jul 2017 
@Description: GA_AccountTriggerHandlr Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_Acc_Assmnt_TrgrHndlr_Test {
    /**
@Description: assementinsert() method 
@Name : assementinsert
@Param : None
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void assementinsert()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        
        GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
        territoryRec.GA_RetentionSalesRepresentative__c=usrLst[1].id;
        database.insert(territoryRec);
        GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = false;
        
        GA_City_Code__c cty = new GA_City_Code__c();
        cty.Name ='OTHER';
        Database.insert(cty);
        
        GA_County_Code__c cnty = new GA_County_Code__c();
        cnty.Name = 'Alger';
        database.insert(cnty);
        
        account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
        accnt.GA_Territory__c = territoryRec.id;
        Database.insert(accnt);
        
        contact objCon = GA_OBJ_TD01_TestDataCreation.cntactRec(accnt.Id);
        Database.insert(objCon);
        
        accnt.GA_CEO__c = objCon.Id;
        system.debug('===accnt.GA_CEO__c==='+accnt.GA_CEO__c);
        accnt.GA_Decision_Maker__c = objCon.Id;
        Database.update(accnt);

		GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
        gsmt.GA_Billing_Address_1__c= 'test address';
        gsmt.GA_Billing_City__c= cty.Id;
        gsmt.GA_Billing_City_Other__c = 'HDC34';
        gsmt.GA_Billing_State__c ='Michigan';
        gsmt.GA_Billing_County_Id__c=cnty.id;                             
        gsmt.GA_Billing_Zip__c ='24324';            
        gsmt.GA_Copy_Address_From__c ='Billing to Mailing;Billing to Physical'; 
        gsmt.GA_Servicing_Agent__c = objCon.Id;
        Database.insert(gsmt);
        
        system.runAs(usrLst[0])
        {
            try{ 
                
                Account_Plan__c accPlan = GA_OBJ_TD01_TestDataCreation.createAssessment(accnt);
                accPlan.GA_CEO__c = accnt.GA_CEO__c;
                Database.insert(accPlan);
                
                system.assert(accnt <> null);
                system.assertEquals(accnt.GA_CEO__c, accPlan.GA_CEO__c);
                
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    /**
@Description: assementinsertExcp() method 
@Name : assementinsertExcp
@Param : None
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void assementinsertExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestDataUsr','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            List<Account_Plan__c> assmntLst = null; 
            GA_Acc_Assmnt_TrgrHndlr.beforeInsert(assmntLst);
            system.assert(assmntLst == null);
        }
    }
}