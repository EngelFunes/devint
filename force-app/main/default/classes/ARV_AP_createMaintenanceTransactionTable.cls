global without sharing class ARV_AP_createMaintenanceTransactionTable implements vlocity_ins.VlocityOpenInterface {
private static final string STARTINGARRAY='[';
private static final string ENDINGARRAY=']'; 
private static String batchId;
public static final string UNIQUEBATCHID='UniqueBatchID';

global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options)
    {
        Boolean success = true;
        try
        {
            if (methodName == 'MaintenanceChangeGSRecords') {
                MaintenanceChangeGSRecords(input,output,options);
                system.debug('Entered to Invoke Method US3886');
            }
        }
        catch(Exception e){
            system.debug('Error at::'+e.getLineNumber());
            throw new AuraHandledException(e.getMessage()+e.getlinenumber());
        }
        return success;
    }

    public static void MaintenanceChangeGSRecords(Map<String,object> input,Map<String,object> output,Map<String,object> options){
        try{
        system.debug('inside the gs loop');
            Id mainRecordTypeID = Schema.SObjectType.ARV_GWC_Transaction_Table__c.getRecordTypeInfosByName().get('Maintenance Change').getRecordTypeId();
            List<ARV_GWC_Transaction_Table__c> mntnceTransactionsList = new List<ARV_GWC_Transaction_Table__c>();
            String accountStrngId= String.valueOf(input.get('ContextId'));//since the context ID is Account here
            String cidAcnt = [Select id, CID__c from Account where id=:accountStrngId].CID__c;
            //String batchAcntCID = 'M'+ cidAcnt;
            String batchAcntCID = (String)options.get(UNIQUEBATCHID);
            map<String, Object> strObjctMap = new map<String, Object>();
            //manage GS here
            List<ARV_GWC_Transaction_Table__c> gsmaintainance= new List<ARV_GWC_Transaction_Table__c>();
            List<GA_Group_Segment__c> gslist1=new List<GA_Group_Segment__c>();
            gslist1=[select id,ARV_ContractID__c,ARV_Package__c from GA_Group_Segment__c where GA_Account__c=:accountStrngId];
            system.debug('****gslist1****'+gslist1);
            Map<String, Object> mainteanceStrObj = (Map<String, Object>)input.get('MaintenanceChange');
            String gsUpdate = String.valueOf(mainteanceStrObj.get('GroupSegmentUpdate'));
            List<object> gsInfoMap=(List<Object>)mainteanceStrObj.get('GroupSegmentDetails');
            system.debug('***gsInfoMap***'+gsInfoMap);
            system.debug('****mainteanceStrObj***'+mainteanceStrObj);
            map<String, Object> selgsblck = (map<String, Object>)mainteanceStrObj.get('SelectionFormulasBlock-GS');
            map<string,Object> strObjectMap;
            string strJson = JSON.serialize(mainteanceStrObj.get('ContactInfo'));
            system.debug('strJson@@'+strJson);
            strJson=strJson.startsWith(STARTINGARRAY)? strJson :STARTINGARRAY+strJson;
            strJson=strJson.endsWith(ENDINGARRAY)? strJson :strJson+ENDINGARRAY;
            system.debug('strJson@@'+strJson);
            List<Object> contactinfoNode = (List<Object>)JSON.deserializeUntyped(strJson);
            system.debug('strJson@@'+strJson);

            if(String.valueOf(selgsblck.get('f_GroupSegmentUpdate_DBA'))=='true'){
                if(gsUpdate.contains('Doing Business As')){
                if(gsInfoMap!=null){
                    for(Object gs:gsInfoMap){
                        strObjectMap = (map<String, Object>)gs;
                            if(String.valueOf(strObjectMap.get('updatedDBA'))=='true'){
                            ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                            mntnceTrans.Account_ID__c=accountStrngId;
                            mntnceTrans.GWC_Batch_ID__c=batchAcntCID;
                            mntnceTrans.Type__c='Doing Business As (DBA) - Group Segment';
                            mntnceTrans.Status__c='In Progress';
                            mntnceTrans.Field_Name__c = 'Doing Business As';
                            mntnceTrans.Old_Value__c=String.valueOf(strObjectMap.get('DoingBusinessAsDBA_Original'));
                            mntnceTrans.New_Value__c=String.valueOf(strObjectMap.get('DoingBusinessAsDBA'));
                            mntnceTrans.RecordTypeId = mainRecordTypeID;
                            mntnceTrans.Group_Name__c=String.valueOf(strObjectMap.get('Id'));
                            mntnceTrans.CreatedDate__c=system.today();
                            gsmaintainance.add(mntnceTrans);
                            }
                    }
                    }
                }
                
            }
            if(String.valueOf(selgsblck.get('f_GroupSegmentUpdate_FederalTaxID'))=='true'){
                if(gsUpdate.contains('Federal Tax ID')){
                if(gsInfoMap!=null){
                    for(Object gs:gsInfoMap){
                    strObjectMap = (map<String, Object>)gs;
                        if(String.valueOf(strObjectMap.get('updatedFedTaxId'))=='true'){
                        ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                        mntnceTrans.Account_ID__c=accountStrngId;
                        mntnceTrans.GWC_Batch_ID__c=batchAcntCID;
                        mntnceTrans.Type__c='Federal Tax ID (Group Segment)';
                        mntnceTrans.Status__c='In Progress';
                        mntnceTrans.Field_Name__c = 'Federal Tax ID';
                        mntnceTrans.Old_Value__c=String.valueOf(strObjectMap.get('FederalTaxID_Original'));
                        mntnceTrans.New_Value__c=String.valueOf(strObjectMap.get('FederalTaxID')); 
                        mntnceTrans.RecordTypeId = mainRecordTypeID;
                        mntnceTrans.Group_Name__c=String.valueOf(strObjectMap.get('Id'));
                        mntnceTrans.CreatedDate__c=system.today();
                        gsmaintainance.add(mntnceTrans);
                        }
                    }
                    }
                }
            }
            if(String.valueOf(selgsblck.get('f_GroupSegmentUpdate_SICCode'))=='true'){
                if(gsUpdate.contains('SIC Code')){
                    if(gsInfoMap!=null){
                    for(Object gs:gsInfoMap){
                    strObjectMap = (map<String, Object>)gs;
                        if(String.valueOf(strObjectMap.get('updatedSICCode'))=='true'){
                        Map<String, Object> siccode= (Map<String, Object>) strObjectMap.get('SICCode');
                        ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                        mntnceTrans.Account_ID__c=accountStrngId;
                        mntnceTrans.GWC_Batch_ID__c=batchAcntCID;
                        mntnceTrans.Type__c='SIC Code';
                        mntnceTrans.Status__c='In Progress';
                        mntnceTrans.Field_Name__c = 'SIC Code';
                        mntnceTrans.New_Value__c=String.valueOf(siccode.get('Name')); 
                        mntnceTrans.RecordTypeId = mainRecordTypeID;
                        mntnceTrans.Group_Name__c=String.valueOf(strObjectMap.get('Id'));
                        mntnceTrans.CreatedDate__c=system.today();
                        mntnceTrans.Old_Value__c=String.valueOf(siccode.get('Name_Original'));                        
                        gsmaintainance.add(mntnceTrans);
                        }   
                    }
                    }
                }
            }
            if(String.valueOf(selgsblck.get('f_GroupSegmentUpdate_NewHireRehire'))=='true'){
                if(gsUpdate.contains('New Hire/Rehire')){
                if(gsInfoMap!=null){
                    for(Object gs:gsInfoMap){
                    strObjectMap = (map<String, Object>)gs;
                        if(String.valueOf(strObjectMap.get('updatedNewHire'))=='true'){
                        Map<String, Object> newhireorig = (Map<String, Object>) strObjectMap.get('NewHireRehire');
                        ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                        mntnceTrans.Account_ID__c=accountStrngId;
                        mntnceTrans.GWC_Batch_ID__c=batchAcntCID;
                        mntnceTrans.Type__c='New Hire/Rehire';
                        mntnceTrans.Status__c='In Progress';
                        mntnceTrans.Field_Name__c = 'New Hire/Rehire';
                        mntnceTrans.CreatedDate__c=system.today();
                        mntnceTrans.RecordTypeId = mainRecordTypeID;
                        mntnceTrans.Group_Name__c=String.valueOf(strObjectMap.get('Id'));
                        String BCNNewHireOriginal=String.valueOf(newhireorig.get('BCN_NewHireCode_Original'));
                        String BCNReHireOriginal=String.valueOf(newhireorig.get('BCN_RehireCode_Original'));
                        String BCBSMNewHireOriginal=String.valueOf(newhireorig.get('BCBSM_NewHireOptionId_Original'));
                        String BCBSMReHireOriginal=String.valueOf(newhireorig.get('BCBSM_RehireOptionId_Original'));
                        String oldvalue=(BCNNewHireOriginal!=null?BCNNewHireOriginal: '')+(BCNReHireOriginal!=null?BCNReHireOriginal: '')+
                                        (BCBSMNewHireOriginal!=null?BCBSMNewHireOriginal: '')+(BCBSMReHireOriginal!=null?BCBSMReHireOriginal: '');
                        mntnceTrans.Old_Value__c=oldvalue;
                        String BCNNewHire=String.valueOf(newhireorig.get('BCN_NewHireCode'));
                        String BCNReHire=String.valueOf(newhireorig.get('BCN_RehireCode'));
                        String BCBSMNewHire=String.valueOf(newhireorig.get('BCBSM_NewHireOptionId'));
                        String BCBSMReHire=String.valueOf(newhireorig.get('BCBSM_RehireOptionId'));
                        String newvalue=(BCNNewHire!=null?BCNNewHire: '')+(BCNReHire!=null?BCNReHire: '')+
                                        (BCBSMNewHire!=null?BCBSMNewHire: '')+(BCBSMReHire!=null?BCBSMReHire: '');
                        mntnceTrans.Old_Value__c=oldvalue;
                        mntnceTrans.New_Value__c=newvalue;
                        gsmaintainance.add(mntnceTrans);
                        }   
                    }
                    }
                }
            }
            if(String.valueOf(selgsblck.get('f_GroupSegmentUpdate_Contacts'))=='true'){
                if(gsUpdate.contains('Contacts')){
                    if(gsInfoMap!=null){
                    for(Object gs:gsInfoMap){
                    strObjectMap = (map<String, Object>)gs;
                        Map<String,Object> admincon=(Map<String,Object>) strObjectMap.get('AdminContact');
                        system.debug('**admincon**'+admincon);
                        string oldvalue=String.valueOf(admincon.get('ContactName'));
                        string newvalue=String.valueOf(admincon.get('ContactName_Updated'));
                        system.debug('oldvalue'+oldvalue);
                        system.debug('newvalue'+newvalue);
                        if(oldvalue!=newvalue){
                        //if(String.valueOf(strObjectMap.get('updatedAdminContact'))=='true'){
                             system.debug('entering contacts2');
                        ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                        mntnceTrans.Account_ID__c=accountStrngId;
                        mntnceTrans.GWC_Batch_ID__c=batchAcntCID;
                        mntnceTrans.Type__c='Contacts';
                        mntnceTrans.Status__c='In Progress';
                        mntnceTrans.Field_Name__c = 'Contacts';
                        mntnceTrans.CreatedDate__c=system.today();
                        mntnceTrans.RecordTypeId = mainRecordTypeID;
                        mntnceTrans.Group_Name__c=String.valueOf(strObjectMap.get('Id'));
                        mntnceTrans.New_Value__c=String.valueOf(admincon.get('ContactName_Updated'));
                        mntnceTrans.Old_Value__c=String.valueOf(admincon.get('ContactName'));
                        gsmaintainance.add(mntnceTrans);
                        }
                        
                        
                        if(String.valueOf(strObjectMap.get('updatedBillingContact'))=='true'){
                             system.debug('entering contacts1');
                        Map<String,Object> billingcon=(Map<String,Object>) strObjectMap.get('BillingContact');
                        string oldvalue1=String.valueOf(billingcon.get('ContactName'));
                        string newvalue1=String.valueOf(billingcon.get('ContactName_Updated'));
                        if(oldvalue1!=newvalue1){    
                        ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                        mntnceTrans.Account_ID__c=accountStrngId;
                        mntnceTrans.GWC_Batch_ID__c=batchAcntCID;
                        mntnceTrans.Type__c='Contacts';
                        mntnceTrans.Status__c='In Progress';
                        mntnceTrans.Field_Name__c = 'Contacts';
                        mntnceTrans.CreatedDate__c=system.today();
                        mntnceTrans.RecordTypeId = mainRecordTypeID;
                        mntnceTrans.Group_Name__c=String.valueOf(strObjectMap.get('Id'));
                        mntnceTrans.New_Value__c=newvalue1;
                        mntnceTrans.Old_Value__c=oldvalue1;
                        gsmaintainance.add(mntnceTrans);
                        }
                    }
                    }
                    }
                }
            }
            if(String.valueOf(selgsblck.get('f_GroupSegmentUpdate_PhysicalAddress'))=='true'){
                if(gsUpdate.contains('Physical Address')){
                    if(gsInfoMap!=null){
                    for(Object gs:gsInfoMap){
                    strObjectMap = (map<String, Object>)gs;
                        if(String.valueOf(strObjectMap.get('updatedPhysicalAddress'))=='true'){
                        Map<String, Object> physAddr = (Map<String, Object>) strObjectMap.get('PhysicalAddress');
                        String RatingAreaUpdated=String.valueOf(physAddr.get('RatingAreaUpdated'));
                        String RatingAreaOriginal=String.valueOf(physAddr.get('RatingAreaOriginal'));
                        ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                        mntnceTrans.Account_ID__c=accountStrngId;
                        mntnceTrans.GWC_Batch_ID__c=batchAcntCID;
                        mntnceTrans.CreatedDate__c=system.today();
                        mntnceTrans.Type__c='Physical Address';
                       if(RatingAreaUpdated!=RatingAreaOriginal){
                        mntnceTrans.RatingAreaFlag__c=true;
                        Boolean flag=mntnceTrans.RatingAreaFlag__c;
                        system.debug('flag'+flag);
                        }
                        if(mntnceTrans.RatingAreaFlag__c==true){
                         mntnceTrans.Status__c='Under Review'; 
                         mntnceTrans.ARV_Maintenance_Change_Approval_Criteria__c ='Rating Area Change';
                       }
                       else
                       {
                        mntnceTrans.Status__c='In Progress';
                       }
                        mntnceTrans.Field_Name__c = 'Physical Address';
                        mntnceTrans.RecordTypeId = mainRecordTypeID;
                        mntnceTrans.Group_Name__c=String.valueOf(strObjectMap.get('Id'));
                        mntnceTrans.Old_Value__c=String.valueOf(physAddr.get('Street_Original'))+String.valueOf(physAddr.get('City_Original'))+String.valueOf(physAddr.get('State_Original'))+String.valueOf(physAddr.get('ZipCode_Original'))+
                                                 String.valueOf(physAddr.get('County_Original'));
                        mntnceTrans.New_Value__c=String.valueOf(physAddr.get('Street'))+String.valueOf(physAddr.get('City'))+String.valueOf(physAddr.get('State'))+String.valueOf(physAddr.get('ZipCode'))+
                                                 String.valueOf(physAddr.get('County'));
                        gsmaintainance.add(mntnceTrans);
                        }   
                    }
                    }
                }
            }
            if(String.valueOf(selgsblck.get('f_GroupSegmentUpdate_MailingAddress'))=='true'){
                if(gsUpdate.contains('Mailing Address')){
                    if(gsInfoMap!=null){
                    for(Object gs:gsInfoMap){
                    strObjectMap = (map<String, Object>)gs;
                        if(String.valueOf(strObjectMap.get('updatedMailingAddress'))=='true'){
                        Map<String, Object> mailingaddr = (Map<String, Object>) strObjectMap.get('MailingAddress');
                        ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                        mntnceTrans.Account_ID__c=accountStrngId;
                        mntnceTrans.GWC_Batch_ID__c=batchAcntCID;
                        mntnceTrans.Type__c='Mailing Address';
                        mntnceTrans.RecordTypeId = mainRecordTypeID;
                        mntnceTrans.Status__c='In Progress';
                        mntnceTrans.Field_Name__c = 'Mailing Address';
                        mntnceTrans.CreatedDate__c=system.today();
                        mntnceTrans.Group_Name__c=String.valueOf(strObjectMap.get('Id'));
                        mntnceTrans.Old_Value__c=String.valueOf(mailingaddr.get('Street_Original'))+String.valueOf(mailingaddr.get('City_Original'))+String.valueOf(mailingaddr.get('State_Original'))+String.valueOf(mailingaddr.get('ZipCode_Original'))+String.valueOf(mailingaddr.get('County_Original'));
						mntnceTrans.New_Value__c=String.valueOf(mailingaddr.get('Street'))+String.valueOf(mailingaddr.get('City'))+String.valueOf(mailingaddr.get('State'))+String.valueOf(mailingaddr.get('ZipCode'))+String.valueOf(mailingaddr.get('County'));
                        gsmaintainance.add(mntnceTrans);
                        }   
                    }
                    }
                }
            }
            if(String.valueOf(selgsblck.get('f_GroupSegmentUpdate_BillingAddress'))=='true'){
                if(gsUpdate.contains('Billing Address')){
                    if(gsInfoMap!=null){
                    for(Object gs:gsInfoMap){
                    strObjectMap = (map<String, Object>)gs;
                        if(String.valueOf(strObjectMap.get('updatedBillingAddress'))=='true'){
                        Map<String, Object> billingaddr = (Map<String, Object>) strObjectMap.get('BillingAddress');
                        ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                        mntnceTrans.Account_ID__c=accountStrngId;
                        mntnceTrans.GWC_Batch_ID__c=batchAcntCID;
                        mntnceTrans.Type__c='Billing Address';
                        mntnceTrans.RecordTypeId = mainRecordTypeID;
                        mntnceTrans.Status__c='In Progress';
                        mntnceTrans.Field_Name__c = 'Billing Address';
                        mntnceTrans.CreatedDate__c=system.today();
                        mntnceTrans.Group_Name__c=String.valueOf(strObjectMap.get('Id'));
                        mntnceTrans.Old_Value__c=String.valueOf(billingaddr.get('Street_Original'))+
                                                 String.valueOf(billingaddr.get('City_Original'))+
                                                 String.valueOf(billingaddr.get('State_Original'))+
                                                 String.valueOf(billingaddr.get('ZipCode_Original'))+
                                                 String.valueOf(billingaddr.get('County_Original'));
                        mntnceTrans.New_Value__c=String.valueOf(billingaddr.get('Street'))+
                                                 String.valueOf(billingaddr.get('City'))+
                                                 String.valueOf(billingaddr.get('State'))+
                                                 String.valueOf(billingaddr.get('ZipCode'))+
                                                 String.valueOf(billingaddr.get('County'));
                        gsmaintainance.add(mntnceTrans);
                        }   
                    }
                    }
                }
            }
            if(contactinfoNode!=null){
            System.debug('@@ inside loop '+ contactinfoNode);
            for(object con :contactinfoNode)
            {
            strObjectMap = (map<String, Object>)con;
                System.debug('strObjectMap@@ '+ strObjectMap);
            if(String.valueOf(strObjectMap.get('f_FirstName_WasChanged'))=='true' || 
               String.valueOf(strObjectMap.get('f_LastName_WasChanged'))=='true' ||
               String.valueOf(strObjectMap.get('f_Phone_WasChanged'))=='true' ||
               String.valueOf(strObjectMap.get('f_Email_WasChanged'))=='true' ||
               String.valueOf(strObjectMap.get('f_MailingStreet_WasChanged'))=='true' ||
               String.valueOf(strObjectMap.get('f_MailingCity_WasChanged'))=='true' ||
               String.valueOf(strObjectMap.get('f_MailingStateCode_WasChanged'))=='true' ||
               String.valueOf(strObjectMap.get('f_MailingPostalCode_WasChanged'))=='true' 
               ){
                   system.debug('entering contacts');
            ARV_GWC_Transaction_Table__c mntnceTrans = new ARV_GWC_Transaction_Table__c();
                mntnceTrans.Field_Name__c = 'Contacts';
                mntnceTrans.Old_Value__c = String.valueOf(strObjectMap.get('f_ContactOriginalConcat'));
                mntnceTrans.New_Value__c = String.valueOf(strObjectMap.get('f_ContactUpdatedConcat'));
                system.debug('f_ContactOriginalConcat@'+String.valueOf(strObjectMap.get('f_ContactOriginalConcat')));
                system.debug('f_ContactUpdatedConcat@'+String.valueOf(strObjectMap.get('f_ContactUpdatedConcat')));
                mntnceTrans.Account_ID__c  =accountStrngId;
                mntnceTrans.Type__c = 'Contacts';
                mntnceTrans.GWC_Batch_ID__c = batchAcntCID;
                mntnceTrans.CreatedDate__c=system.today();
                mntnceTrans.Status__c='In Progress';
                mntnceTrans.RecordTypeId = mainRecordTypeID;
                mntnceTransactionsList.add(mntnceTrans);
            }
            }
            }
            insert gsmaintainance;
            //updateGSCounter(countGSRecords);
           /*     if(gsmaintainance.size()>0){
                    output.put('gsmaintainance','true');
                        }
                else{
                    output.put('gsmaintainance','false');
             }*/
        }
        Catch(Exception e){
            //throw new AuraHandledException(e.getMessage()+e.getlinenumber());
             GA_LogExceptionCls.LogExcp(e, 'ARV_AP_createMaintenanceTransactionTable', 'MaintenanceChangeGSRecords');
            system.debug('line number@@ US3886 '+e.getLineNumber());
            system.debug('getMessage @@ US3886 '+e.getMessage());

            
        }
          
 }  
 

  public static void updateBatchId(Map<String,String> output){
       batchId = 'M' + Math.round((Math.random() * (90000) + 10000));
       output.put('batchID',batchId);
    }
}