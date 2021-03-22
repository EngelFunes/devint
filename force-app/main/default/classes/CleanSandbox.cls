/*
 * you can dynamically run batches based on custom metadata records
 *  
 * new CleanSandbox().runApexClass();
 * 
 * this wil be run as a part of our sandbox refresh process. The metadata records in production will
 * dictate the behavior of this
 * 
 */


global class CleanSandbox implements SandboxPostCopy {
    
    string thisSandboxName;
    
    global void runApexClass(SandboxContext context) {
        
        if(context != null) {
            
            System.debug('Org ID: ' + context.organizationId());
            System.debug('Sandbox ID: ' + context.sandboxId());
            System.debug('Sandbox Name: ' + context.sandboxName());
            
            thisSandboxName	= context.sandboxName();
            
        } else {
            
            thisSandboxName = 'sandbox name';
        }
        
        List<Sandbox_Refresh_Settings__mdt> srs = [select query__c, 
                                                   entity__c,
                                                   Subject_Field__c, 
                                                   Replacement_Value__c, 
                                                   Send_to_email__c, 
                                                   Sent_from_email__c, 
                                                   Boolean__c,
                                                   DeveloperName
                                                   from Sandbox_Refresh_Settings__mdt
                                                   where Use_this_record__c = TRUE
                                                   limit 100];
        
        
        if ( !srs.isempty() || !test.isRunningTest() ){ 
            
            for (Sandbox_Refresh_Settings__mdt srsmdt : srs ) {
                
                string q		= srsmdt.query__c;
                string e 		= srsmdt.entity__c;
                string sf 		= srsmdt.Subject_Field__c;
                string rv 		= srsmdt.Replacement_Value__c;
                boolean b		= srsmdt.Boolean__c;
                string ste		= srsmdt.Send_to_email__c;
                string sfe		= srsmdt.Sent_from_email__c;
                string mdtRec	= srsmdt.DeveloperName;
                string sbn		= thisSandboxName;

                Id batchInstanceId = Database.executeBatch(new Batch_UpdateOneFieldOnAnyObject(q, e, sf, rv, b, ste, sfe, mdtrec, sbn) );
                
            }
            
        } else {
            system.debug('you must enter values in Sandbox_Refresh_Settings__mdt for this to work on sandbox refresh');
        }
    }
}