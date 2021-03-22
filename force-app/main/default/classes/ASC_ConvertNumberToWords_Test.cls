@isTest
public class ASC_ConvertNumberToWords_Test {
    
    private static testMethod void convertNumberToWord(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            Long val =  Long.valueOf('14');
            ASC_ConvertNumberToWords.english_number(val);
            Long val1 =  Long.valueOf('100');
            ASC_ConvertNumberToWords.english_number(val1);
            Long val2 = Long.valueOf('1145');
            ASC_ConvertNumberToWords.english_number(val2);
        }
    }
}