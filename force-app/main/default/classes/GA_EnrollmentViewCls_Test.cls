/**
@Author : Prasant S
@Name: GA_EnrollmentViewCls_Test 
@CreatedDate: 01 - Feb 2018 
@Description: GA_EnrollmentViewCls_Test Test class 
@version : 1.0  
*/
@isTest
public class GA_EnrollmentViewCls_Test {
    /**
@Description: GA_EnrollmentView() method 
@Name : GA_EnrollmentView
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void GA_EnrollmentView()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestEnrlmnt','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(grpSgmntRec);
                GA_Plan_Package__c plnPkgeRec=GA_OBJ_TD01_TestDataCreation.planPkgRec(grpSgmntRec);
                database.insert(plnPkgeRec);
                Asset astRec=GA_OBJ_TD01_TestDataCreation.soldPrdtRec(plnPkgeRec,acc);
                database.insert(astRec);
                list<GA_Enrollment__c> enrollmntLst=new list<GA_Enrollment__c>();
                GA_Enrollment__c enrollmntRec=GA_OBJ_TD01_TestDataCreation.enrollmntRec(astRec,'1234');
                enrollmntLst.add(enrollmntRec);
                GA_Enrollment__c enrollmntRec1=GA_OBJ_TD01_TestDataCreation.enrollmntRec(astRec,'12345');
                enrollmntLst.add(enrollmntRec1);
                database.insert(enrollmntLst);
                test.startTest();
                GA_EnrollmentViewCls.fetchenrollmntRec(grpSgmntRec.id, 5);
                GA_EnrollmentViewCls.fetchcolvals();
                GA_EnrollmentViewCls.fetchGrpNme(grpSgmntRec.Id);
                test.stopTest();
                //system.assert(enrollmntLst.size()>0);
            }
            catch(exception e)
            {
                //system.assert(e !=null);
            }
        }
    }
}