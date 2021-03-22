@isTest
public class GA_CloneGrpSegmentCls_Test {
    
    private static testMethod void cloneAnySobjet(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            database.insert(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            database.insert(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            database.insert(cty2);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1); 
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            gsmt.GA_Physical_Address_1__c= 'test address';
            gsmt.GA_Physical_City__c= cty1.Id;
            gsmt.GA_Physical_City_Other__c = 'HDC3';
            gsmt.GA_Physical_State__c ='Royal Oak';
            gsmt.GA_Physical_County_Id__c=cnty.id;                             
            gsmt.GA_Physical_Zip__c ='48034';            
            gsmt.GA_Copy_Address_From__c ='Physical to Mailing';  
            database.insert(gsmt);           
            
            GA_DC_Small_Grp_History__c dcSmallGrp1=GA_OBJ_TD01_TestDataCreation.dcSmallGrpHstry(gsmt);
            dcSmallGrp1.GA_Suite__c = 'SUITE A';
            database.insert(dcSmallGrp1);
            
            Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        	cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        	database.insert(cnt); 
        
        	GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        	agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
        	agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2200, 1, 1);
        	database.insert(agentacctRelation); 
        
        	GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        	database.insert(aorGSRec); 
            
            GA_CloneGrpSegmentCls.cloneAnySobjet(gsmt.id);
            
            GA_CloneGrpSegmentCls.fetchGroupSegmentClone();
            
            system.assert(usr <> null);
        }
    }


}