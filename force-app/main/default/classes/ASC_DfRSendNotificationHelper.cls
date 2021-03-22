/*****************************************************************************************************************************************************
@Author : Sreenu Ravilla
@Name: ASC_DfRSendNotificationHelper
@CreatedDate:  17-March-2021 
@Description: ASC_DfRSendNotificationHelper is used to send  Email notifications for product owners when Dfund request status complted.

@US Number: US-4096

*/
public class ASC_DfRSendNotificationHelper {
    private static final String EAMILNAME = 'noreply@bcbsm.com';
    private static final string EMAILTEMP='ASC_DfundApprovalToPoCompleted';
    
    /* This method will be used to filter the records*/
    public static void sendNotificationToProductOwner(set<Id> dfCompletedIdSet){
        //This map will be used to avoid additonal query to hold key as product recod and related quote line items
        Map<Id,List<QuoteLineItem>> productQuoteLineItemMap = new  Map<Id,List<QuoteLineItem>>();
        Map<Id,Id> productOwnerDfundRequestMap = new  Map<Id,Id>();//Map to hold product owner and related dfund request id's
        List<product2> productsList = new  List<product2>();//To hold queries product records
        //This list to hold the dfund request detail updatated records 
        List<Dfund_Request_Detail__c> dfunRequestDetailList = new List<Dfund_Request_Detail__c>();
        //Query the quote line items and iterate and prapare map
        for(QuoteLineItem qli:getQuoteLineItems(dfCompletedIdSet)){
            if(qli.Product2Id !=null){
                if(productQuoteLineItemMap.containsKey(qli.Product2Id)){// if product contains then it will add quote line item to list
                    productQuoteLineItemMap.get(qli.Product2Id).add(qli);
                }else{
                    productQuoteLineItemMap.put(qli.Product2Id, new List<QuoteLineItem>{qli});// if product not there then it will create new isntance and add the element 
                }
            }
        }
        if(productQuoteLineItemMap.size()>0){
            //Query products if the based on product id's
            productsList = getProducts(productQuoteLineItemMap.keySet());
            if(productsList.size()>0){
                for(product2 pr : productsList){//Iterate queries products
                    if(productQuoteLineItemMap.get(pr.id)!=null){
                        //Iterate quoteline items
                        for(QuoteLineItem qli:productQuoteLineItemMap.get(pr.id)){
                           // if(qli.Dfund_Request_Detail__c!=null){     
                                if(pr.ASC_Product_Owner__c!=null){  
                                    //Prepare map which will be used to send email
                                    productOwnerDfundRequestMap.put(pr.ASC_Product_Owner__c,qli.Quote.dfund_request__c);
                                    //Updating the dfundrequest detail records to checkbox field to true so that the only vlaid dfund request will added to the vf email template 
                                   // dfunRequestDetailList.add(new Dfund_Request_Detail__c(id=qli.Dfund_Request_Detail__c,Dfund_Include_Completed_Notification__c=true));
                                }
                           // }
                        }                    
                    }
                }
                if(dfunRequestDetailList!=null){
                    try{
                        // Update records and call email method
                        //update dfunRequestDetailList;
                        emailNotificationOnDfundRequestCompleted(productOwnerDfundRequestMap);
                    }catch(DmlException dm){
                          System.debug('Exception '+dm.getMessage());
                    }
                }          
            }
        }
    }
    
    
     //This method will send email using single email to the product owners
    public static void emailNotificationOnDfundRequestCompleted(Map<Id,Id> productOwnerDfundRequestMap){
        //Declaring the list to hold single email messages
        List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>(); 
        String OrgWideEmailAddress;  
        //Setting organization wide address
        try{
            OrgWideEmailAddress = getOrgWideAddress();
        }catch (QueryException e){
            System.debug('Exception '+e.getMessage());
        }        
        /**Creating email template*/
        EmailTemplate emailTemplate = getEmailTemplate();
        for(Id poId:productOwnerDfundRequestMap.keySet()){
            //initiating singleemailmessage instance
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            //Setting the recepient as product owner
            emailToSend.setTargetObjectId(poId);
            //Setting the visualforce email template
            emailToSend.setTemplateId(emailTemplate.id);
            //Setting the orgwide address that we got from above line
            emailToSend.setOrgWideEmailAddressId(OrgWideEmailAddress);
            //Setting the what id which will be consumed by visualforce email template to show dfund request details records
            emailToSend.setWhatId(productOwnerDfundRequestMap.get(poId));
            emailToSend.setBccSender(false);
            emailToSend.setUseSignature(false);
            emailToSend.setSaveAsActivity(false);
            //Adding the single email message instance to list
            listmail.add(emailToSend);
        }       
        if(!listmail.isEmpty() && listmail != null){
            try{   
                Messaging.sendEmail(listmail);    //Sending email finally               
            } catch (Exception e){
                System.debug('Exception@@@@ '+e.getMessage());
            }
        } 
    }
    //Query the orgwide addtrees based in email and this method can be reused in different classes
    public static EmailTemplate getEmailTemplate(){
        return [select Id, Body,Subject, HtmlValue from EmailTemplate where DeveloperName =:EMAILTEMP];
    }
    //Query the orgwide addtrees based in email and this method can be reused in different classes
    public static String getOrgWideAddress(){
        return [SELECT DisplayName,Id FROM OrgWideEmailAddress WHERE DisplayName =:EAMILNAME LIMIT 1].Id;
    }
    //Query tge product records based on products associated with quotelineitems 
    private static List<product2> getProducts(set<Id> productIdSet){
        return [SELECT Id,ASC_Product_Owner__c,ASC_Product_Owner__r.email,ASC_Product_Owner__r.isactive from product2 where id in : productIdSet and ASC_Product_Owner__r.isactive =true];
    }
    //Query quotelineitems based on completed dfund request id's and pricing variance is true
    private static List<QuoteLineItem> getQuoteLineItems(set<Id> dfCompletedIdSet){
      //Commneted this code as this query considering the quote line items under dfund rquest detail
        /*  return [SELECT Id, Dfund_Request_Detail__c,Dfund_Request_Detail__r.Name,Dfund_Request_Detail__r.Dfund_Request__c,
                Dfund_Request_Detail__r.Product__c,ASC_Pricing_Variance__c FROM QuoteLineItem
                where Dfund_Request_Detail__c!=null and Dfund_Request_Detail__r.Dfund_Request__c in : dfCompletedIdSet and ASC_Pricing_Variance__c =true];*/
        
        return [SELECT Id, Dfund_Request_Detail__c,Dfund_Request_Detail__r.Name,Dfund_Request_Detail__r.Dfund_Request__c,
                Product2Id ,ASC_Pricing_Variance__c,Quote.dfund_request__c FROM QuoteLineItem
                where Quote.dfund_request__c!=null and Quote.dfund_request__c in : dfCompletedIdSet and ASC_Pricing_Variance__c =true];
    }
}