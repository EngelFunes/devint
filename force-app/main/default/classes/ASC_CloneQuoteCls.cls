/**
@Author : Mida Komal
@Name: ASC_CloneQuoteCls
@CreatedDate: 15 - May 2020
@version : 1.0  


---Modified --
TD-1003 Added By Dinesh- Modified the if condition "if(eachRec.get('ASC_Line_Item_Extension__c') !=null && 'ASC_Line_Item_Extension__c'.equals(fieldApi))"
        and Also added the logic to populate the QLI_ID__c and Quote_Line_Item__c fields on the Line Item Extensions records- This is for Reporting
*/
public without sharing class ASC_CloneQuoteCls {  
    
    public static final String CLASSNAME ='ASC_CloneQuoteCls';
    public static final String FETCHQUOTE_METHODNAME ='fetchQuoteClone';
    public static final String CLONEANYSOBJECT_METHODNAME ='cloneAnySobjet';
    public static final String SYSTEMADMINISTRATOR ='System Administrator';
    public static final String ASC_QUOTING_SPECIALIST ='ASC_Quoting_Specialist';
    public static final String SELECT_STRING ='SELECT ';
    public static final String ID='Id';
    public static final String DRAFT = 'Draft';
    public static final String QUOTE_ID ='QuoteId';
    public static final String QUOTELINEITEM ='QuoteLineItem';   
    public static final String VLOCITY_INS_PARENTITEMID2 ='vlocity_ins__ParentItemId2__c';
    public static final String COPYFILELINKFROMPARENTQUOTE ='copyFileLinksFromParentQuote';
    public static final String CLONECHILDRECORDS ='cloneChildRecords';
    Public static final string oldQuoteId;//
    
    
    /**
    @Description: fetchQuoteClone() method for checking clone button access
    @Name : fetchQuoteClone
    @Param :null
    @Return : Boolean
    @throws Exception : AuraHandledException;
    */      
    @AuraEnabled
    public static boolean fetchQuoteClone(){
        try
        {   
            Boolean hasAccess = false;           
            String userId =  UserInfo.getUserId();
            User userDetails =[SELECT Id, Name, Email, Profile.Name FROM User where Id=:userId LIMIT 1 ];
            String profileName =userDetails.Profile.Name;   
           
            if(profileName != null && SYSTEMADMINISTRATOR.equals(profileName))
            {
                hasAccess = true;
            }
            else
            {
                List<PermissionSetAssignment> permSetUser = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :userId AND PermissionSet.Name = :ASC_QUOTING_SPECIALIST LIMIT 1];
                if(permSetUser != null && permSetUser.size()> 0)
                {
                    hasAccess = true;
                }
            }
            return hasAccess;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, FETCHQUOTE_METHODNAME);
           throw new AuraHandledException(System.Label.GA_AssignOwnerErr+': '+e.getMessage()); 
            
          
        }
    }
    
    
    /*
    @Description: cloneAnySobjet() method 
    @Name : cloneAnySobjet
    @Param : string currentId
    @Return : List<Quote>
    @throws Exception : ValidateException;
    */ 
    @AuraEnabled
    public static String cloneAnySobjet(String recordId){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        String objectAPIName = '';
        String keyPrefix = recordId.substring(0,3);       
        
        //Getting the object name dynamically
        for( Schema.SObjectType obj : schemaMap.Values() ){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix == keyPrefix){
                objectAPIName = obj.getDescribe().getName();
                break;
            }
        }
        
        Map<String, Schema.SObjectField> fields = schemaMap.get(objectAPIName).getDescribe().fields.getMap();
        Set<String> fieldMap = new Set<String>();
        String soqlQuery = SELECT_STRING; 
        for(Schema.SObjectField fieldRef : fields.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            if(fieldResult.isUpdateable()) {
                fieldMap.add(fieldResult.getname());
            }
        }
        fieldMap.add(ID);    
         for (String s :fieldMap ){            
            soqlQuery +=  + s+',';          
        }
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +objectAPIName +' WHERE ID = :recordId ' ;  
         
        system.debug('soqlQuery=====>' +soqlQuery);
        // Quering all the fields from SObject to clone
        SObject record = Database.query(soqlQuery); 
        system.debug('record=====>' +record);
        record.put(Schema.Quote.ParentQuoteId__c,recordId);//added 4103
        record.put(Schema.Quote.Dfund_Request__c,null);//added 4103
        record.put(Schema.Quote.Status, DRAFT);         
        SObject clondedParentRecordID= record.clone(false, true);
        try{
            insert clondedParentRecordID ;   
            // Cloning QuoteLineItem records if Parent Records contains Quote line items.
            cloneChildRecords(recordId, clondedParentRecordID.id, QUOTE_ID);
            //Cloning Document Langauge records.
            cloneDocumentLanguageRecords('ASC_Document_Language__c',recordId,clondedParentRecordID.id);
            // Copy File Links from parent Quote to Child Quote
            copyFileLinksFromParentQuote(recordId, clondedParentRecordID.id);          
            return clondedParentRecordID.id ;
            
        }catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, 'cloneAnySobjet');              
            if(clondedParentRecordID.id !=null)
             {
                   delete clondedParentRecordID;
             }
            if(e.getMessage().contains('The price book entry is inactive.'))
            {
                throw new AuraHandledException('Clone Quote Failed. The Associated QuoteLineItem contains an Inactive Product');
            }
            else
            {
                throw new AuraHandledException(e.getMessage());
            }             
        }              
    }    

    /**
    @Description: Cloning Quote Child records method 
    @Name : cloneChildRecords
    @Param :null
    @Return : void
    @throws Exception : AuraHandledException;
    */      
    public static void cloneChildRecords(string recordId, string clonedRecordId, string quoteId)
    {
    
        List<Line_Item_Extension__c> liextListToUpdate = new List<Line_Item_Extension__c>();
        Map<Id,Line_Item_Extension__c> liextListToUpdateMap = new Map<Id,Line_Item_Extension__c>();

        List<QuoteLineItem> qliListAllToInsert = new List<QuoteLineItem>();
        List<QuoteLineItem> childQliToBeInserted = new List<QuoteLineItem>();
        List<QuoteLineItem> qliToInsert = new List<QuoteLineItem>();
            
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fields = schemaMap.get(QUOTELINEITEM).getDescribe().fields.getMap();
        Set<String> fieldMap = new Set<String>();
        String soqlQuery = SELECT_STRING ; 
        for(Schema.SObjectField fieldRef : fields.values()) {
            Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
            if(fieldResult.isUpdateable()) {
                fieldMap.add(fieldResult.getname());
            }
        }
        fieldMap.add(ID);    
        fieldMap.add('PricebookEntryId');
        for (String s :fieldMap ){            
            soqlQuery +=  + s+',';          
        }
        
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM QuoteLineItem where PricebookEntry.IsActive= true and '+quoteId+' =: recordId' ;      
        List<QuoteLineItem> record = Database.query(soqlQuery);     
        List<QuoteLineItem> lstOfSObjectToBeInserted = new List<QuoteLineItem>();        
        Map<String,List<QuoteLineItem>> parentChildQLIMap = new Map<String,List<QuoteLineItem>> ();
        Map<String, String> rootProductMap = new Map<String, String>();
        Map<String,String> lineItemExtMap = new Map<String,String>();         //added

        Set<Id> lierecordIdSet = new Set<Id>();
        for (QuoteLineItem eachRec : record) {            
            QuoteLineItem qli = new QuoteLineItem();
            qli.put('QuoteId' ,clonedRecordId);
            for(String fieldApi : fieldMap)
            {   
                if(!fieldApi.equals(ID) && eachRec.get(fieldApi) !=null)
                {
                    if(eachRec.get('ASC_Line_Item_Extension__c') !=null && 'ASC_Line_Item_Extension__c'.equals(fieldApi)) //* Added By Dinesh -Start  TD-1003 - Modified the if condition from eachRec.get('ASC_Line_Item_Extension__c').equals('ASC_Line_Item_Extension__c')  */
                    {             
                       lierecordIdSet.add(String.valueOf(eachRec.get('ASC_Line_Item_Extension__c')));             
                    }
                    else
                    {
                        qli.put(fieldApi,eachRec.get(fieldApi));
                    }                    
                }               
            }
            
               
            if(eachRec.get(VLOCITY_INS_PARENTITEMID2) == null)
            {
                insert qli;
                rootProductMap.put(String.valueOf(eachRec.get('Id')),qli.Id);
            }
            else
            {
                if(parentChildQLIMap.get(String.valueOf(eachRec.get(VLOCITY_INS_PARENTITEMID2))) !=null)
                {
                    lstOfSObjectToBeInserted = parentChildQLIMap.get(String.valueOf(eachRec.get(VLOCITY_INS_PARENTITEMID2)));
                    lstOfSObjectToBeInserted.add(qli);
                    parentChildQLIMap.put(String.valueOf(eachRec.get(VLOCITY_INS_PARENTITEMID2)),lstOfSObjectToBeInserted);
                }
                else
                {
                    lstOfSObjectToBeInserted = new List<QuoteLineItem>();
                    lstOfSObjectToBeInserted.add(qli);
                    parentChildQLIMap.put(String.valueOf(eachRec.get(VLOCITY_INS_PARENTITEMID2)),lstOfSObjectToBeInserted);
                }               
            }                     
        }
        
        //Added By Dinesh - TD-1055 - Bulkification - lierecordIdSet to be sent to cloneLineItemExtensionRecords method to create multiple records at a time to avoid too many SOQL. 
        if(!lierecordIdSet.isEmpty()){
          lineItemExtMap = cloneLineItemExtensionRecords('Line_Item_Extension__c',lierecordIdSet);
        }
        
        try{
            QuoteLineItem qli = new QuoteLineItem();
            for(String fieldName : parentChildQLIMap.keySet()){
              {   
                    childQliToBeInserted = new List<QuoteLineItem>();                    
                    qliToInsert = new List<QuoteLineItem>();        
                    qliToInsert = parentChildQLIMap.get(fieldName);               
                    for(integer i=0;i<qliToInsert.size();i++){
                                            
                        qli = new QuoteLineItem();
                        qli = qliToInsert[i];
                        String parentQLIId = rootProductMap.get(qli.vlocity_ins__ParentItemId2__c);
                        qli.put(VLOCITY_INS_PARENTITEMID2,parentQLIId);
                        qli.put('vlocity_ins__ParentItemId__c',parentQLIId);               
                        childQliToBeInserted.add(qli);                        
                    }
                    if(!childQliToBeInserted.isEmpty()){
                      qliListAllToInsert.addAll(childQliToBeInserted);
                    }                    
              }                
            }
            
            if(!qliListAllToInsert.isEmpty()){
              insert qliListAllToInsert;            
            }     
            
            /* Added By Dinesh -Start  TD-1003 /TD-1055 - To update QLI_ID__c and Quote_Line_Item__c fields on the Line Item Extension */
            List<quotelineitem> qliListToUpdate = new List<quotelineitem>();
            Map<String,String> lieExtId = new Map<String,String>();
            if(!qliListAllToInsert.isEmpty()){
                for(quotelineitem qLIRec :[Select Id,ASC_Line_Item_Extension__c,Product2.Productcode from QuoteLineItem where Id IN:qliListAllToInsert 
                                        LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                  
                  quotelineitem qLIupdate = new quotelineitem();
                  qLIupdate.Id = qLIRec.Id;
                  qLIupdate.ASC_Line_Item_Extension__c = lineItemExtMap.ContainsKey(qLIRec.Product2.Productcode)?lineItemExtMap.get(qLIRec.Product2.Productcode):null;
                  qliListToUpdate.add(qLIupdate);
                  
                  if(qLIupdate.ASC_Line_Item_Extension__c != null){                  
                      Line_Item_Extension__c liextUpdt = new Line_Item_Extension__c();
                      liextUpdt.Id = qLIupdate.ASC_Line_Item_Extension__c;
                      liextUpdt.QLI_ID__c = qLIRec.Id;
                      liextUpdt.Quote_Line_Item__c = qLIRec.Id;
                      liextUpdt.ASC_Last_Updated_Date__c = null;
                      liextListToUpdate.add(liextUpdt);
                      liextListToUpdateMap.put(liextUpdt.Id,liextUpdt);                
                  }  
                }
            
             if(liextListToUpdateMap !=null){//!liextListToUpdate.isEmpty()){
               update liextListToUpdateMap.Values();
             }
             if(!qliListToUpdate.isEmpty()){
               update qliListToUpdate;
             }
            }
            /* Added By Dinesh -End */
            
        }catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, 'cloneChildRecords');           
        } 
    }
            
    /**
    @Description: Cloning Line Item Extension records method 
    @Name : cloneLineItemExtensionRecords
    @Param :null
    @Return : void
    @throws Exception : AuraHandledException;    
    */
    
    /*Added by Dinesh :TD-1055 - update the second parameter from String to Set<Id> for bulkification and updated the logic accordingly */
    public static Map<String,String> cloneLineItemExtensionRecords(String objectAPIName, Set<Id> recordId)
    {        
        Map<String,String> lieIdMap = new Map<String,String>();
        List<SObject> lstOfSObjectToBeInserted = new List<SObject>();
        if(!recordId.isEmpty()){
            SObject clondedChildRecordID;
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();               
            String soqlQuery = SELECT_STRING ; 
            for (String s :fieldMap ){           
                soqlQuery +=  + s+',';          
            }
            soqlQuery =  soqlQuery.removeEnd(',');
            soqlQuery += ' FROM ' +objectAPIName +' WHERE Id IN:recordId';        
        
            List<Line_Item_Extension__c> result = (List<Line_Item_Extension__c>)database.query(soqlQuery);
            
            for(Line_Item_Extension__c record:result){
                clondedChildRecordID = record.clone(false, true);            
                lstOfSObjectToBeInserted.add(clondedChildRecordID);          
            }        
        }       
        try{
            if(!lstOfSObjectToBeInserted.isEmpty()){
                insert lstOfSObjectToBeInserted ;  
                
                for(Line_Item_Extension__c lie:[Select Id,Product__r.Productcode from Line_Item_Extension__c 
                                                where Id IN:lstOfSObjectToBeInserted
                                                LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){
                   lieIdMap.put(lie.Product__r.Productcode,lie.Id);
                }                        
            }
        }catch(Exception e){            
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, 'CLONECHILDRECORDS');
        }
        return lieIdMap;
    }
        
    /**
    @Description: Cloning Document Lanuage records method 
    @Name : cloneDocumentLanguageRecords
    @Param :null
    @Return : void
    @throws Exception : AuraHandledException;
    */      
    public static void cloneDocumentLanguageRecords(String objectAPIName, string recordId,String clonedRecordId)
    {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();
        String soqlQuery = SELECT_STRING ; 
        for (String s :fieldMap ){           
            soqlQuery +=  + s+',';          
        }
        soqlQuery =  soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' +objectAPIName +' WHERE ASC_Quote__c =:  recordId' ;      
        
        List<ASC_Document_Language__c> record = Database.query(soqlQuery);     
        List<ASC_Document_Language__c> lstOfSObjectToBeInserted = new List<ASC_Document_Language__c>();  
        
        for (ASC_Document_Language__c eachRec : record) {
            eachRec.put('ASC_Quote__c',clonedRecordId);
            ASC_Document_Language__c clondedChildRecordID= eachRec.clone(false, true);            
            lstOfSObjectToBeInserted.add(clondedChildRecordID);
        }             
        
        try{
            insert lstOfSObjectToBeInserted ;  
                        
        }catch(Exception e){
            
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, 'CLONECHILDRECORDS');
        }
        
    }   

    /**
    @Description: copyFileLinksFromParentQuote records method 
    @Name : copyFileLinksFromParentQuote
    @Param :null
    @Return : void
    */   
    public static void copyFileLinksFromParentQuote(string recordId,String clonedRecordId)
    {
        try
        {
            List<ContentDocumentLink> contentDocLink = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId = :recordId and LinkedEntity.Type='Quote' LIMIT 100];
            if(contentDocLink != null && contentDocLink.size()>0)
            {   
                List<ContentDocumentLink> cdlInsertList = new List<ContentDocumentLink>();
                for(integer i=0;i<contentDocLink.size();i++)
                {
                    Id conDoc = contentDocLink[i].ContentDocumentId;                
                    //create ContentDocumentLink  record 
                    ContentDocumentLink conDocLink = New ContentDocumentLink();
                    conDocLink.LinkedEntityId = clonedRecordId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                    conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
                    conDocLink.shareType = 'V';
                    cdlInsertList.add(conDocLink);                
                }
                insert cdlInsertList;
            }
        }
        catch(Exception e){
           
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, COPYFILELINKFROMPARENTQUOTE);
        }        
    }
  
  }