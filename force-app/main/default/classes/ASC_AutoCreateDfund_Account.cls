/**************************************************************************************************************
    @Description        :  This class is used for to  auto create Dfund And Dfund Detail Request records create automatically when Quote is Approved and 
                           product is having pricing variance
    @Name               :   
    @Param              :  
    @Return             :   void
    @throws Exception   :   N/A;
 **************************************************************************************************************/
public class ASC_AutoCreateDfund_Account {
    
    
    //To check the Quote is approved and related lines has the Products with Dfund_Required
    
    
    public static void checkQuoteData(map<id,Quote> trigger_NewMap,map<id,Quote> trigger_OldMap){  
                
        set<id> quoteIds=new set<id>();
        Map<id,id> parentNewquoteIds = new Map<id,id>();
        
        for(Quote quoteRec: trigger_NewMap.values()){
                       
            if(quoteRec.Dfund_Request__c== null && quoteRec.Status=='Approved'
             && quoteRec.Status!=trigger_OldMap.get(quoteRec.id).Status){
                 System.debug('IF in');
                   //Checking if the parent id is exists, we are cloning the exisitng dfund records
                   if(quoteRec.ParentQuoteId__c == null){
                     quoteIds.add(quoteRec.id);  //added
                   }
                  // quoteIds.add(quoteRec.id);
                   else{ 
                       parentNewquoteIds.put(quoteRec.Id,quoteRec.ParentQuoteId__c);
                   }
               }
        }
        set<id> quoteIdsForDfundRecCreation=new set<id>();
       // system.debug('quoteIds==>'+quoteIds.size());
        if(quoteIds.size()>0){
            for(QuoteLineItem qlRec:[SELECT ID,QuoteId FROM QuoteLineItem WHERE QuoteId IN:quoteIds 
                                     AND Product2.ASC_Dfund_Required__c='Yes']){
                                         quoteIdsForDfundRecCreation.add(qlRec.QuoteId);
                                     }
        }
        system.debug('quoteIdsForDfundRecCreation...'+quoteIdsForDfundRecCreation);
        if(quoteIdsForDfundRecCreation.size()>0){
            System.debug('Create New Dfund ========================='+quoteIdsForDfundRecCreation.size());
           createDfundRequest(quoteIdsForDfundRecCreation,null);
        }
        //Cloning Dfund records
        if(parentNewquoteIds.size()>0){
            //System.debug('parentNewquoteIds >>>>>>>> '+parentNewquoteIds);
            System.debug('Clone Existing Dfund =========================');
            cloneDfunds(parentNewquoteIds);
        }
    }
    
    
    //Changed this method to create dfund when there is a procing variance
    // Added varianceqliproductId attribute having product id and quoteid
    @future
    public static void createDfundRequest(set<id> quoteIds, Map<id,id> varianceqliproductId){
        map<id,Dfund_Request__c> DfundRequestMap=new map<id,Dfund_Request__c>();
        list<Quote> QuoteToUpdate=new list<Quote>();
        Id DFRTypeId = Schema.SObjectType.Dfund_Request__c.getRecordTypeInfosByName().get('Dfund Request').getRecordTypeId();
        for(Quote quoteRec: [SELECT ID,AccountId,Account.CID__c,Account.GA_AgentName__c,ASC_Renewal_Year__c,
                             Renewal_Month__c,ASC_Benefit_LOB_Purchased__c,ASC_Carrier__c,Account.GA_Retention_Sales_Rep__c
                             FROM QUOTE WHERE ID IN:quoteIds ]){
                                 system.debug('quoteRecid==>'+quoteRec.ID);
                                 system.debug('quoteRecid agent namee==>'+quoteRec.Account.GA_AgentName__c);
                                 Dfund_Request__c df=new Dfund_Request__c(
                                     RecordTypeId=DFRTypeId,
                                     Account__c=quoteRec.AccountId,
                                     //CID__c=quoteRec.Account.CID__c,
                                     Servicing_Agent__c=quoteRec.Account.GA_AgentName__c,
                                     Renewal_Year__c=quoteRec.ASC_Renewal_Year__c,
                                     //Renewal_Month__c=quoteRec.Renewal_Month__c
                                     Benefit_LOB__c=quoteRec.ASC_Benefit_LOB_Purchased__c,
                                     Carrier__c=quoteRec.ASC_Carrier__c,
                                     Status__c='New',
                                     Auto_Generated__c= TRUE,
                                     OwnerId =quoteRec.Account.GA_Retention_Sales_Rep__c
                                 );
                                 DfundRequestMap.put(quoteRec.id,df);                                 
                                 QuoteToUpdate.add(quoteRec);
                             }
        system.debug('DfundRequestMap...'+DfundRequestMap.values());
        if(!DfundRequestMap.isEmpty()){
            database.insert (DfundRequestMap.values(),false);
            system.debug('DfundRequestMap===>'+DfundRequestMap.values());//added
        }
        for(Quote qRec:QuoteToUpdate){
            qRec.Dfund_Request__c=DfundRequestMap.get(qRec.id).id;
            system.debug('dfundrequest are==>'+DfundRequestMap.get(qRec.id));
        }
       // system.debug('DfundRequestMap...'+DfundRequestMap);
        if(!QuoteToUpdate.isEmpty() && varianceqliproductId == null){
            database.update(QuoteToUpdate,false);
            createDfundRequestDetails(quoteIds);
        }
        else if (!QuoteToUpdate.isEmpty() && varianceqliproductId != null){
            ID parentQuote = [Select ParentQuoteId__c from quote where ID IN :quoteIds Limit 1].ParentQuoteId__c;
            Quote q = [select id,Dfund_Request__c,Dfund_Request__r.Dfund_Reason__c,Dfund_Request__r.Busines_Justification__c,Dfund_Request__r.Quantity__c from quote where id = :parentQuote ];
            Dfund_Request__c dfund = DfundRequestMap.values();
            dfund.Dfund_Reason__c= q.Dfund_Request__r.Dfund_Reason__c;
            dfund.Busines_Justification__c = q.Dfund_Request__r.Busines_Justification__c;
            dfund.Quantity__c =q.Dfund_Request__r.Quantity__c;
            update dfund;
            database.update(QuoteToUpdate,false);
            cloneERSDfund(q.Dfund_Request__c,dfund.id);
            createselectedproductDfundRequestDetails(quoteIds,varianceqliproductId);
        }
        system.debug('QuoteToUpdate...'+QuoteToUpdate);
    }
    
    public static void createDfundRequestDetails(set<id> quoteIds){    	        
        map<id,Dfund_Request_Detail__c> DfundRequestDetailsMap=new map<id,Dfund_Request_Detail__c>();        
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = Schema.SObjectType.Dfund_Request_Detail__c.getRecordTypeInfosByName();
        
        //Add the Product family and Dfund Req Recordtype maping 
        map<string,string> productRecordTypeMap=new map<string,string>();
        productRecordTypeMap.put('Admin Fees', 'ASC Admin Dfund Info');
        productRecordTypeMap.put('Stop-Loss', 'ASC Stop-Loss Dfund Info');
        productRecordTypeMap.put('Shared Savings', 'ASC Shared Savings Dfund Info');
        productRecordTypeMap.put('Data Feeds', 'ASC Data Feeds Dfund Info');
        //productRecordTypeMap.put('', 'ASC General Dfund Info');               
        
        map<string,Fund__c> Fund_Map=new map<string,Fund__c>();
        for(Fund__c fun: [SELECT ID,Name,Activity_Type__c,Fund_Category__c FROM Fund__c]){
            Fund_Map.put(fun.Name, fun);
        }
        system.debug('Fund_Map...'+Fund_Map); 
 		for(Line_Item_Extension__c lieRec:[SELECT ID,Quote_Line_Item__r.QuoteId,Product__c,
                                 Product__r.Family,Quote_Line_Item__r.Quote.ASC_Line_of_Business__c,
                                 Quote_Line_Item__r.Quote.Dfund_Request__c,Pricing_Method__c,Quantity__c,
                                 Attachment_Point__c,Original_Price__c,UnitPrice__c,Estimated_Monthly_Admin_Fee__c,
                                 Carrier_Retention_Percentage__c,Original_Retention__c,
                                 Quote_Line_Item__r.ASC_Pricing_Variance__c
                                 FROM Line_Item_Extension__c WHERE Quote_Line_Item__r.QuoteId IN:quoteIds 
                                 AND Product__r.ASC_Dfund_Required__c='Yes'
                                 AND Quote_Line_Item__r.ASC_Pricing_Variance__c = true])
                            
                         
                         
        {
            system.debug('size===>'+lieRec.ID);
                  system.debug('size1===>'+lieRec.Product__r.Family);
                                     			 
			Dfund_Request_Detail__c dfd= new Dfund_Request_Detail__c(
                DRD_Fund__c=(Fund_Map.containsKey(lieRec.Product__r.Family)) ? 
                		Fund_Map.get(lieRec.Product__r.Family).Id: NULL,
                 Dfund_Type__c='Rate Adjustment',
                 Product__c=lieRec.Product__c,
                 ASC_Line_of_Business__c=lieRec.Quote_Line_Item__r.Quote.ASC_Line_of_Business__c,
                 Pricing_Method__c=lieRec.Pricing_Method__c,
                 Dfund_Request__c=lieRec.Quote_Line_Item__r.Quote.Dfund_Request__c,
                Estimated_Contracts__c=lieRec.Quantity__c,
                Stop_Loss_Attachment_Point__c=lieRec.Attachment_Point__c,
                Standard_Fee__c=lieRec.Original_Price__c,
                Requested_Fee__c=lieRec.UnitPrice__c,
                Flat_Amount__c=lieRec.Estimated_Monthly_Admin_Fee__c,
                Carrier_Retention_Percentage__c=lieRec.Carrier_Retention_Percentage__c,
                Original_Retention__c=lieRec.Original_Retention__c,
               
                 RecordTypeId=((lieRec.Product__r.Family!=NULL && 
							   productRecordTypeMap.containsKey(lieRec.Product__r.Family) && 
							   RecordTypeInfo.containsKey(productRecordTypeMap.get(lieRec.Product__r.Family)))?
							  RecordTypeInfo.get(productRecordTypeMap.get(lieRec.Product__r.Family)).getRecordTypeId() : 
                              RecordTypeInfo.get('ASC General Dfund Info').getRecordTypeId())
			  
			 );
			 DfundRequestDetailsMap.put(lieRec.id,dfd);			
		}
        system.debug('DfundRequestDetailsMap...'+DfundRequestDetailsMap);
        if(!DfundRequestDetailsMap.isEmpty()){
            database.insert(DfundRequestDetailsMap.values(),true);
           // system.debug('insert crossed'+DfundRequestDetailsMap.values().size());
        }        
    }
    public static void createselectedproductDfundRequestDetails(set<id> quoteIds, Map<id,id> varianceqliproductId){    	        
        map<id,Dfund_Request_Detail__c> DfundRequestDetailsMap=new map<id,Dfund_Request_Detail__c>();        
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = Schema.SObjectType.Dfund_Request_Detail__c.getRecordTypeInfosByName();
        
        //Add the Product family and Dfund Req Recordtype maping 
        map<string,string> productRecordTypeMap=new map<string,string>();
        productRecordTypeMap.put('Admin Fees', 'ASC Admin Dfund Info');
        productRecordTypeMap.put('Stop-Loss', 'ASC Stop-Loss Dfund Info');
        productRecordTypeMap.put('Shared Savings', 'ASC Shared Savings Dfund Info');
        productRecordTypeMap.put('Data Feeds', 'ASC Data Feeds Dfund Info');
        //productRecordTypeMap.put('', 'ASC General Dfund Info');               
        
        map<string,Fund__c> Fund_Map=new map<string,Fund__c>();
        for(Fund__c fun: [SELECT ID,Name,Activity_Type__c,Fund_Category__c FROM Fund__c]){
            Fund_Map.put(fun.Name, fun);
        }
        system.debug('Fund_Map...'+Fund_Map);
 		for(Line_Item_Extension__c lieRec:[SELECT ID,Quote_Line_Item__r.QuoteId,Product__c,
                                 Product__r.Family,Quote_Line_Item__r.Quote.ASC_Line_of_Business__c,
                                 Quote_Line_Item__r.Quote.Dfund_Request__c,Pricing_Method__c,Quantity__c,
                                 Attachment_Point__c,Original_Price__c,UnitPrice__c,Estimated_Monthly_Admin_Fee__c,
                                 Carrier_Retention_Percentage__c,Original_Retention__c
                                 FROM Line_Item_Extension__c WHERE Quote_Line_Item__r.QuoteId IN:quoteIds 
                                 AND Product__r.ASC_Dfund_Required__c='Yes' AND Product__c IN :varianceqliproductId.keyset()]){
                                     			 
			Dfund_Request_Detail__c dfd= new Dfund_Request_Detail__c(
			DRD_Fund__c=(Fund_Map.containsKey(lieRec.Product__r.Family)) ? 
                		Fund_Map.get(lieRec.Product__r.Family).Id: NULL,
                 Dfund_Type__c='Rate Adjustment',
                 Product__c=lieRec.Product__c,
                 ASC_Line_of_Business__c=lieRec.Quote_Line_Item__r.Quote.ASC_Line_of_Business__c,
                 Pricing_Method__c=lieRec.Pricing_Method__c,
                 Dfund_Request__c=lieRec.Quote_Line_Item__r.Quote.Dfund_Request__c,
                Estimated_Contracts__c=lieRec.Quantity__c,
                Stop_Loss_Attachment_Point__c=lieRec.Attachment_Point__c,
                Standard_Fee__c=lieRec.Original_Price__c,	
                Requested_Fee__c=lieRec.UnitPrice__c,
                Flat_Amount__c=lieRec.Estimated_Monthly_Admin_Fee__c,
                Carrier_Retention_Percentage__c=lieRec.Carrier_Retention_Percentage__c,
                Original_Retention__c=lieRec.Original_Retention__c,
               
                  RecordTypeId=((lieRec.Product__r.Family!=NULL && 
							   productRecordTypeMap.containsKey(lieRec.Product__r.Family) && 
							   RecordTypeInfo.containsKey(productRecordTypeMap.get(lieRec.Product__r.Family)))?
							  RecordTypeInfo.get(productRecordTypeMap.get(lieRec.Product__r.Family)).getRecordTypeId() : 
                              RecordTypeInfo.get('ASC General Dfund Info').getRecordTypeId())
			  
			 );
			 DfundRequestDetailsMap.put(lieRec.id,dfd);			
		}
        system.debug('DfundRequestDetailsMap...'+DfundRequestDetailsMap);
        if(!DfundRequestDetailsMap.isEmpty()){
            database.insert(DfundRequestDetailsMap.values(),true);
            
             
        }        
    }
  /**************************************************************************************************************
    @Description        :  cloneDfunds method for the clone DfundRequest if variences
    @Name               :  cloneDfunds() 
    @Param              :  
    @Return             :   void
    @throws Exception   :   N/A;
 **************************************************************************************************************/
    public static void cloneDfunds(Map<id,id> parentNewquoteIds){
        Map<String,id> oldQuotelineProductids=new Map<String,id>();
        Map<id,id> varianceqliproductId = new Map<id,id>();
        Set<id>  quoteIDs = new Set<id>();
        Set<id>  productVarianceQuoteIDs = new Set<id>();
        Map<id,id> quoteDfundIds = new Map<id,id>();
        List<Quote> QuoteToUpdate = new List<Quote>();
        Boolean varianceFlag = false;
        Boolean priceVarFlag = false;
        List<QuoteLineItem> newQuotelineList = new List<QuoteLineItem>();
        //fetching all products and qli where dfund required equals true
       for(QuoteLineItem qli: [ select id,Quoteid,Quote.ParentQuoteId__c,ASC_Variance_For_Approval__c,ASC_Pricing_Variance__c,Product2.ASC_Dfund_Required__c,
                                Product2Id,Product2.Name, Quote.Dfund_Request__c
                               from QuoteLineItem where Product2.ASC_Dfund_Required__c = 'Yes' /*and ASC_Variance_For_Approval__c = true ASC_Pricing_Variance__c= true */ and 
                               (/*Quoteid in :parentNewquoteIds.keyset() or */ Quoteid in:parentNewquoteIds.values())]){
          //if(parentNewquoteIds.containsKey(qli.Quoteid))
            //newQuotelineList.add(qli);
            //else 
            quoteDfundIds.put(qli.QuoteId, qli.Quote.Dfund_Request__c);
            oldQuotelineProductids.put(qli.QuoteId+'~'+qli.Product2Id,qli.Product2Id);    
        }
        System.debug(oldQuotelineProductids);
        List<QuoteLineItem> Qlitem = [ select id,Quoteid,Quote.ParentQuoteId__c,ASC_Variance_For_Approval__c,ASC_Pricing_Variance__c,Product2.ASC_Dfund_Required__c,
                                Product2Id,Product2.Name from QuoteLineItem where Product2.ASC_Dfund_Required__c = 'Yes'/* and ASC_Variance_For_Approval__c = true ASC_Pricing_Variance__c= true */and
                               (Quoteid in :parentNewquoteIds.keyset() /*or  Quoteid in:parentNewquoteIds.values()*/)];
       //Comparing the products with old and new quote line items
       System.debug('Qlitem.size() '+Qlitem.size()+' oldQuotelineProductids '+oldQuotelineProductids.size());
       // if(Qlitem.size()==oldQuotelineProductids.size()){
            for(QuoteLineItem eachQLI :Qlitem){
                System.debug('Qli '+eachQLI.Quote.ParentQuoteId__c+ ' PID '+eachQLI.Product2Id);
                if(!oldQuotelineProductids.containsKey(eachQLI.Quote.ParentQuoteId__c+'~'+eachQLI.Product2Id)){
                    System.debug('Product Variance Yes');
                    productVarianceQuoteIDs.add(eachQLI.QuoteId);
                    varianceFlag = true; priceVarFlag =false;
                    break;
                }else if(oldQuotelineProductids.containsKey(eachQLI.Quote.ParentQuoteId__c+'~'+eachQLI.Product2Id)
                        && eachQli.ASC_Pricing_Variance__c/*ASC_Variance_For_Approval__c*/ ){
                    varianceqliproductId.put(eachQLI.Product2Id,eachQLI.QuoteId);
                    priceVarFlag = true;
                }else  if(oldQuotelineProductids.containsKey(eachQLI.Quote.ParentQuoteId__c+'~'+eachQLI.Product2Id)
                        && !eachQli.ASC_Pricing_Variance__c)              
                quoteIDs.add(eachQLI.QuoteId);
            }
      /*  }else{ 
            productVarianceQuoteIDs.add(Qlitem[0].QuoteId);
            varianceFlag = true;
        }*/
         System.debug('quoteIDs '+quoteIDs);
        if(priceVarFlag && !varianceFlag){
          System.debug('Yes Price variance');
            createDfundRequest(new Set<id>(varianceqliproductId.values()),varianceqliproductId);
            system.debug('quoteids===>'+ new Set<id>(varianceqliproductId.values()));
            //createDfundRequestDetails(new Set<id>(varianceqliproductId.values()));//changed
        }    
        else if(!varianceFlag && !priceVarFlag){
            System.debug('No variance to clone');
            for(Quote q :[SELECT ID,AccountId,ParentQuoteId__c,ASC_Renewal_Year__c,Renewal_Month__c,ASC_Benefit_LOB_Purchased__c,ASC_Carrier__c,
                          Dfund_Request__c FROM quote WHERE ID in :quoteIDs]){
                 System.debug(quoteDfundIds);
                 if(quoteDfundIds.containsKey(q.ParentQuoteId__c))
                    q.Dfund_Request__c = quoteDfundIds.get(q.ParentQuoteId__c);
                 QuoteToUpdate.add(q);             
             }
        }
        else{
            System.debug('Please review the product and create dfund accordingly');
            createDfundRequest(productVarianceQuoteIDs,null);
            system.debug('productVarienceQuoteids==>' +productVarianceQuoteIDs);
             //	createDfundRequestDetails(productVarianceQuoteIDs);//chaged
        }
        if(QuoteToUpdate.size()>0){
            System.debug('QuoteToUpdate '+QuoteToUpdate);
            try{
                update QuoteToUpdate;
                
                Dfund_Request__c dfund = [select id, name,Status__c from Dfund_Request__c where id = :QuoteToUpdate[0].Dfund_Request__c limit 1]; 
                dfund.Status__c ='Canceled';
                update dfund;
                System.debug(dfund); 
                System.debug('Dfund update is Completed');
            }
            catch(Exception e){
                System.debug('Update Dfund Exception '+e);
            }
        }
     }
    
/**************************************************************************************************************
    @Description        :  cloneERSDfund method for the clone cloneERSDfund request details if variences
    @Name               :  cloneERSDfund() 
    @Param              :  
    @Return             :   void
    @throws Exception   :   N/A;
 **************************************************************************************************************/
    
    public static void cloneERSDfund(Id olddfundId, Id newDfundId){
      Id ERSTypeId = Schema.SObjectType.Dfund_Request_Detail__c.getRecordTypeInfosByName().get('ERS Dfund Info').getRecordTypeId();
      System.debug('ERS ID '+ERSTypeId);
      List<Dfund_Request_Detail__c> dfunddetaillist = new List<Dfund_Request_Detail__c>();
          for(Dfund_Request_Detail__c eachdetail : [select DRD_Fund__c,Dfund_Type__c,Product__c,
                 ASC_Line_of_Business__c,
                 Pricing_Method__c,
                 Dfund_Request__c,
                Estimated_Contracts__c ,
                Stop_Loss_Attachment_Point__c ,
                Standard_Fee__c,
                Requested_Fee__c ,
                Flat_Amount__c,
                Carrier_Retention_Percentage__c,RecordTypeId,
                Original_Retention__c from Dfund_Request_Detail__c where Dfund_Request__c = :olddfundId 
                 and RecordTypeId = :ERSTypeId]){
                  Dfund_Request_Detail__c dfunddetail = eachdetail.clone(false, false, false, false);
                     dfunddetail.id = null;
                     dfunddetail.Dfund_Request__c =newDfundId;
                   dfunddetaillist.add(dfunddetail);  
                 }
        if(dfunddetaillist.size()>0){
            try{
                System.Debug(dfunddetaillist);
                insert dfunddetaillist;
            }catch(Exception e){
                System.debug('Exception ERS Update '+e);
            }
        }
    }
 }