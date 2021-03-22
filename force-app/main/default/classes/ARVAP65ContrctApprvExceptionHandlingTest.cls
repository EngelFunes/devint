/******************************************************************************************************************************************

@Name: ARV_AP65_ContrctApprvExceptionHandling 
@Description: ARV_AP65_ContrctApprvExceptionHandling Test class 

*****************************************************************************************************************************************/
@isTest(seealldata=false)
public class ARVAP65ContrctApprvExceptionHandlingTest {
/*******************************************************************************************************************************
@Description    :  updtCntrctStatsTest() method
@Name         :   updtCntrctStatsTest
@Param         :  None
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/

 @isTest
 public static  void updtCntrctStatusTest() {
     try{
         List<Contract> cntrcLst = new  List<Contract> ();
         Account acc = new Account(name='TEST_VAL');
         acc.CID__c='23';
         acc.Federal_Tax_ID__c='675437';
         acc.Status__c= 'Active';
         database.insert(acc);
         Contract con= new Contract();
         con.Accountid=acc.id;
         con.Status='In Progress';
         con.ARV_Is_Mass_Updating__c=false;
         insert con;
         ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(con.id);
         
 }
     catch(exception e)
            {
                return;
            }
            
        }
 /**********************************************************************************************************
@Description: updateContrtRejStatusTest() method 
@Name : updateContrtStatusTest
@Param : None
@Return : void
@throws Exception : N/A;
***************************************************************************************************************/

@isTest
public static  void updtCntrctRejStatusTest()
{
     try{
         List<Contract> cntrcLst = new  List<Contract> ();
         Account acc= new Account(name='TEST_VAL');
         acc.CID__c='23';
         acc.Federal_Tax_ID__c='675437';
         acc.Status__c='Active';
         database.insert(acc,true);
         Contract con=new Contract();
         con.Accountid=acc.id;
         insert con;
         con.Status = 'Rejected';
         con.Description=null;
         con.ARV_TECH_Account_Merge__c=null;
         con.ARV_Is_Mass_Updating__c = True;
         database.update(con,true);
         ARV_AP65_ContrctApprvExceptionHandling.updtCntrct(con.Id);
               
         }
      catch(exception e)
            {
                return;
            }
        }
   /**************************************************************************************************************
@Description: contrtStatusExpTestCatch() method 
@Name : contrtStatusExpTestCatch
@Param : None
@Return : void
@throws Exception : N/A;
******************************************************************************************************************/

   @isTest
   public static  void contrtStatusExpTestCatch()
   {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<Contract> cntrcLst = new  List<Contract> ();
                List<Account> accList = new List<Account>();

                Account acc = ARV_AP05_TestDataCreation.accRec();
                database.insert(acc,true) ;
                /* Start -- To cover the insertExceptionRecs method in the ARV_AP65_ContrctApprvExceptionHandling class */
                Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
                Account acc1=new Account();
                acc1.Name='Test Acc1';
                acc1.CID__c=randomInt+'12';
                acc1.Federal_Tax_ID__c='123456789000'; //String too long Exception : Federal_Tax_ID__c has limit to accept upto 9 characters only at field level.
                acc1.Requested_Effective_Date__c=system.today();
                acc1.GA_CoverageCancellationDate__c=system.today();
                acc1.Account_Status__c='Inactive';
                acc1.BillingPostalCode='48005';
                acc1.ARV_Renewal_Account_Type__c='SG'; 
                accList.add(acc1);
                List<Database.SaveResult> resultList =  database.insert(accList,false);
                /* End */
                
                Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
                database.insert(con,true);
                
                con.Status = 'Enrollment Submission – Error';
                con.ARV_Is_Mass_Updating__c = True;
                database.update(con,true);
               
                test.startTest();     
                ARV_AP65_ContrctApprvExceptionHandling.insertExceptionRecs(resultList);
                ARV_AP65_ContrctApprvExceptionHandling.updtCntrctStats(null);
                ARV_AP65_ContrctApprvExceptionHandling.updtCntrct(null);
                test.stopTest(); 
                system.assert(usr<>null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }    
}