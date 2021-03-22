/*
* generic batachable apex class whose initial intent was just to clean contact.email addresses in sandboxes so that emails don't fire to actual 
* contacts when email delivirability is turned on, for testing purposes
* 
* can be invoked by executing an anonymous apex block and running this code:
* 
*
*	string q = 'select id from contact';
*  	string e ='contact';
* 	string sf = 'email';
*	string rv = 'lfranciosi@bcbsm.com.today';
*	string ste ='lfranciosi@bcbsm.com';
*	string sfe = 'lfranciosi@bcbsm.com';
*   string mdtrec = 'who cares';
*	string sbn	= 'sandbox name';
*  	Id batchInstanceId = Database.executeBatch(new Batch_UpdateOneFieldOnAnyObject(q,e,sf,rv,ste,sfe,mdtrec, sbn));
* 
*   you could have this execute any query with other arguments e.g.
* 		'select id from account where lastmodifieddate = today'
*
* 	by implementing this through the SandboxPostRefresh interface we can dynamically run batches based on custom metadata recrods
*	new CleanSandbox().runApexClass(null);
*
*/

global class Batch_UpdateOneFieldOnAnyObject implements Database.Batchable<sObject> {
    
    String query;
    String entity;
    String subjectfield;
    String replacementvalue;
    String sentFromEmail;
    String sendToEmail;
    String srsMtdDevName;
    boolean boo;
    string sandboxName;
    
    
    global Batch_UpdateOneFieldOnAnyObject (string q, string e, string sf, string rv, boolean b, string ste, string sfe, string mdtRec, string sbn) {
        
        boo = b;
        query = q;
        entity = e;
        subjectfield = sf;
        replacementvalue = rv;
        sendToEmail = ste;
        sentFromEmail = sfe;
        srsMtdDevName = mdtRec;
        sandboxName = sbn;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        for(Sobject s : scope){ 
            
            if (boo) {
                
                s.put(subjectfield, boolean.valueof(replacementvalue));
                
            } else
                
                s.put(subjectfield,replacementvalue); 
            
        } update scope;
    }
    
    global void finish(Database.BatchableContext BC) {
        
        list <user> thisSandbox = [select username from user where profile.name = 'system administrator' limit 1];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {sendToEmail};
            
        mail.setToAddresses( toAddresses);
        
        mail.setReplyTo(sentFromEmail);
        mail.setSenderDisplayName('Post Sandbox Refresh Batch Processing');
        mail.setSubject( srsMtdDevName +' '+'Post Sandbox copy sandbox Batch Process Completed');
        
        if ( sandboxName == 'sandbox name' ) {	
            
        	mail.setPlainTextBody('Batch Process has completed for job: ' + srsMtdDevName + ' ' + 'in this org:'+' '+ thisSandbox );
            
        } else {
            
			mail.setPlainTextBody('Batch Process has completed for job: ' + srsMtdDevName + ' ' + 'in this org:'+' '+ sandboxName );
            system.debug('i hit the second if condition');
            
        }
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
}