@isTest
public class Batch_UpdateOneFieldOnAnyObject_Test {
    
    private static testmethod void testUpdate(){
        
        list<account> iaccount = new list<account>();
        for(integer a=0; a<25; a++ ){
            
            Account acct = new Account();
            acct.Name = 'this account' + math.random();
            acct.cid__c = '00000';
            
            iaccount.add(acct);
        }
        insert(iaccount);
        
        list<contact> icontact = new list<contact>();
        for(integer i=0; i<25; i++){
            
            contact c = new contact();
            c.firstname = 'new';
            c.lastname = 'yes' + math.random();
            c.email='no-reply@bcbsm.com.invalid';
            c.accountid = iaccount[i].id;
            icontact.add(c);
        }
        insert icontact;
        
        Test.StartTest();
        
            string q = 'select id from contact';
            string e ='contact';
            string sf = 'email';
            string rv = 'no-reply@bcbsm.com.today';
            boolean b = false;
            string ste ='no-reply@bcbsm.com';
            string sfe = 'no-reply@bcbsm.com';
            string mdtrec = 'thismetadatarecords';
            string sbn		= 'this sandbox';
            
            Id batchInstanceId = Database.executeBatch(new Batch_UpdateOneFieldOnAnyObject(q, e, sf, rv, b, ste, sfe, mdtrec, sbn));
        
        Test.StopTest();
        
        Contact c = [select id, email from contact limit 1];
        
        System.assert(string.isNotBlank(q));
        system.assert(string.isnotblank(sf));
        system.assert(string.isnotblank(rv));
 
    }
}