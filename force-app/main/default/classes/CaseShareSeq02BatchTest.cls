@isTest
        Private class CaseShareSeq02BatchTest {
            
            private static testmethod void TestCaseShareSeq02Batch() {
                
                user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
                database.insert(usr);
                system.runAs(usr){
                        case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                        database.insert(cas);

                       List<CaseShare> caseShareobj = [Select Caseid,UserOrGroupId from CaseShare];
                        CaseShareSeq02Batch cshare = new CaseShareSeq02Batch(caseShareobj);
                        Test.startTest();
                        ID CaseShareSeq02Batchid = Database.executeBatch(cshare);
                        Test.stopTest();
                   }
                }   
            }