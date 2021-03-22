@isTest
public class CleanSandbox_Test {

    @isTest
    static void testPostCopy() {
        
        Test.startTest();
        string thisSandboxName;
        
        Test.testSandboxPostCopyScript(new CleanSandbox(), 
                                       UserInfo.getOrganizationId(),
                                       UserInfo.getOrganizationId(),
                                       'sandbox'
                                      );
        
        Test.stopTest();
        system.assertNotEquals(thisSandboxName, 'sandbox name');

    }
}