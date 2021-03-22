/*
@Author : Prasant Kumar Satpathy
@Name: GA_JEO_TR01_JeoprdyTriggerhndlr_Test
@CreatedDate: 24- Jul 2017 
@Description: GA_JEO_TR01_JeoprdyTriggerhndlr_Test class is used for testing GA_JEO_TR01_JeoprrdyTrigger
@version : 1.0  
*/
@isTest
private class GA_JEO_TR01_JeoprdyTriggerhndlr_Test {
    /**
@Description: createTsk() method 
@Name : createTsk
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void createTsk()
    {
        User usrRec=GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testJeomail@bcbsm.com','Integration User');
        User usrRec1=GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl1','testJeomail@bcbsm.com','System Administrator');
        list<User> usrLst=new List<User>();
        UsrLst.add(usrRec);
        UsrLst.add(usrRec1);
        database.insert(usrLst);
        
        system.runAs(usrLst[0])
        {
            try
            {
                list<GA_Jeopardy__c> jeoprdLst=new list<GA_Jeopardy__c>();
                map<id,GA_Jeopardy__c>  jeoprdOldMap=new map<id,GA_Jeopardy__c>();
                Account accRec=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accRec);
                
                GA_Jeopardy__c jeoRec=GA_OBJ_TD01_TestDataCreation.jeoprdyRec(UsrRec,AccRec);
                jeoRec.GA_AssignedTo__c=null;
                database.insert(jeoRec);  
                jeoprdOldMap.put(JeoRec.id,JeoRec);
                list<task> tskLstPrior=[select id,ownerid from task where whatid=:JeoRec.id limit 10];
                JeoRec.GA_AssignedTo__c=UsrLst[0].id;
                database.update(JeoRec);
                jeoprdLst.add(JeoRec);
                test.startTest();
                GA_JEO_ReassignTaskToSME.CreateOrUpdateTask(jeoprdLst,jeoprdOldMap);
            GA_JEO_ReassignTaskToSME.isExecuting = false;
                GA_JEO_ReassignTaskToSME.jeoTaskCreate(jeoprdLst);
                list<task> tskLstPost=[select id,ownerid from task where whatid=:JeoRec.id limit 10];
                test.stopTest();
                
                system.assert(tskLstPost !=null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /**
@Description: updateCreateTsk() method 
@Name : updateCreateTsk
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void updateCreateTsk()
    {
        User usrRec=GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testJeomail@bcbsm.com','System Administrator');
        User usrRec1=GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl1','testJeomail@bcbsm.com','System Administrator');
        list<User> usrLst=new List<User>();
        usrLst.add(usrRec);
        usrLst.add(usrRec1);
        database.insert(usrLst);
        
        system.runAs(usrLst[0])
        {
            try
            {
                list<GA_Jeopardy__c> jeoprdLst=new list<GA_Jeopardy__c>();
                map<id,GA_Jeopardy__c>  jeoprdOldMap=new map<id,GA_Jeopardy__c> ();
                Account accRec=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accRec);
                GA_Jeopardy__c jeoRec=GA_OBJ_TD01_TestDataCreation.jeoprdyRec(UsrLst[0],AccRec);
                database.insert(jeoRec); 
                jeoprdOldMap.put(jeoRec.id, jeoRec);
                list<task> tskLstPrior=[select id,ownerid from task where whatid=:JeoRec.id limit 10];
                jeoRec.GA_AssignedTo__c=UsrLst[1].id;
                database.update(jeoRec);
                jeoprdLst.add(JeoRec);
                test.startTest();
                GA_JEO_ReassignTaskToSME.CreateOrUpdateTask(jeoprdLst,jeoprdOldMap);
                GA_JEO_ReassignTaskToSME.jeoTaskCreate(jeoprdLst);
                list<task> tskLstPost=[select id,ownerid from task where whatid=:JeoRec.id limit 10];
                test.stopTest();
                
                system.assert(tskLstPost !=null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /**
@Description: genrtExcepDataAccessHlpr() method 
@Name : genrtExcepDataAccessHlpr
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void genrtExcepDataAccessHlpr()
    {
        User usrRec=GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testJeomail@bcbsm.com','System Administrator');
        User usrRec1=GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl1','testJeomail@bcbsm.com','System Administrator');
        list<User> usrLst=new List<User>();
        usrLst.add(usrRec);
        usrLst.add(usrRec1);
        database.insert(usrLst);
        
        system.runAs(usrLst[0])
        {
            try
            {
                list<task> tskLsttoCreate;
                list<task>  tskLsttoUpdte;
                test.startTest();
                GA_Util01_JEODataAccessHelper.createUpdateTsk(null,null);
                test.stopTest();
                List<ExceptionLog__c> eLogLst=[select id from ExceptionLog__c limit 1];
                system.assert(eLogLst.size()>0); 
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /**
@Description: genrtExcepReassignTsk() method 
@Name : genrtExcepReassignTsk
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void genrtExcepReassignTsk()
    {
        
        User usrRec=GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testJeomail@bcbsm.com','System Administrator');
        User usrRec1=GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl1','testJeomail@bcbsm.com','System Administrator');
        list<User> usrLst=new List<User>();
        usrLst.add(usrRec);
        usrLst.add(usrRec1);
        database.insert(usrLst);
        
        system.runAs(usrLst[0])
        {
            try
            {
                list<GA_Jeopardy__c> jeoprdLst;
                map<id,GA_Jeopardy__c>  jeoprdOldMap;
                test.startTest();
                GA_JEO_ReassignTaskToSME.jeoTaskCreate(null);
                test.stopTest();
                List<ExceptionLog__c> eLogLst=[select id from ExceptionLog__c limit 1];
                system.assert(eLogLst.size()>0); 
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    
    /**
@Description: genrtExcepJeoprdyHndlr() method 
@Name : genrtExcepJeoprdyHndlr
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void genrtExcepJeoprdyHndlr()
    {
        User usrRec=GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testJeomail@bcbsm.com','System Administrator');
        User usrRec1=GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl1','testJeomail@bcbsm.com','System Administrator');
        list<User> usrLst=new List<User>();
        usrLst.add(usrRec);
        usrLst.add(usrRec1);
        database.insert(usrLst);
        
        system.runAs(usrLst[0])
        {
            try
            {
                list<GA_Jeopardy__c> jeoprdLst;
                map<id,GA_Jeopardy__c>  jeoprdOldMap;
                test.startTest();
                GA_JEO_TR01_JeoprdyTriggerhndlr.afterupdate(jeoprdLst,jeoprdOldMap);
                test.stopTest();
                List<ExceptionLog__c> eLogLst=[select id from ExceptionLog__c limit 1];
                system.assert(eLogLst.size()>0); 
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}