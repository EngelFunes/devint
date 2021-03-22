@isTest
public class auditTrailLog_Test {
    
    static testmethod void test() {
        
        Test.startTest();
        
        auditTrailLog atl = new auditTrailLog();
        String sch = '00 00 1 30 JUL ? 2099';
        String jobID = system.schedule('audit log job', sch, atl);
        
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2099-07-30 01:00:00', String.valueOf(ct.NextFireTime));
        
        Integer invocations = Limits.getEmailInvocations();

        system.assertEquals(0, invocations, 'An email should be sent');
		

        Test.stopTest();
        
    }
}