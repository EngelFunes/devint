/**
@Author : IDC Offshore
@Name: GA_ACC_AP_UpdtAssmntOwnrMgrChnge_Test
@CreatedDate: 20 Nov 2018
@Description: GA_ACC_AP_UpdtAssmntOwnrMgrChnge_Test class is for GA_ACC_AP_UpdtAssmntOwnrMgrChnge class.
@version : 1.0  
*/ 
@isTest
public class GA_ACC_AP_UpdtAssmntOwnrMgrChnge_Test {
   /**
@Description: updateAccOwner() method 
@Name : updateAccOwner
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void updateAccOwner()
    {
        List<User> usrLst = New List<User>();
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSmall','testSmallGrppmail@bcbsm.com','Small Group Underwriter');
        user usrManager = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSmallManager','testSmallGrpManagerpmail@bcbsm.com','Executive');
        usr = GA_OBJ_TD01_TestDataCreation.setManager(usr,usrManager);
        user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRetention','testsalesrepmail@bcbsm.com','Retention Sales');
        user usr1Manager = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRetentionManager','testSalesrepMgrpmail@bcbsm.com','Executive');
        usr1 = GA_OBJ_TD01_TestDataCreation.setManager(usr1,usr1Manager);
        
        usrLst.add(usr);
        usrLst.add(usrManager);
        usrLst.add(usr1);
        usrLst.add(usr1Manager);
        database.insert(usrLst);
        
        Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc.OwnerId =usr.id; 
        insert  acc;
        
         Account_Plan__c assessment = GA_OBJ_TD01_TestDataCreation.createAssessment(acc);
        insert assessment;
        
        acc.OwnerId = usr1.id;
        update acc;
        
        List<Account> accLst = New List<Account>();
        accLst.add(acc);
        
        system.runAs(usr)
        {
           GA_ACC_AP_UpdtAssmntOwnrMgrChnge.updtownrMgrEml(accLst);
        }
    }
    
        /**
@Description: errBlck() method 
@Name : errBlck
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void errBlck()
    {
        
       
        List<Account> accLst = new  List<Account>();
        accLst =null;
        GA_ACC_AP_UpdtAssmntOwnrMgrChnge.updtownrMgrEml(accLst);
      
    }
    
    
}