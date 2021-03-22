public class ASC_SendForSignature {
    
    private static final String FIXEDADMINFEE_PRDCODE = 'ASC_0000005';
    private static final String VARADMINFEE_PRDCODE = 'ASC_0000370';
    private static final String SL_INS_PRDCODE = 'ASC_0000415'; 
    private static final String DELIVERY_METHOD = 'eSign';
    private static final String defaultEmailContentKey = 'Others_Receives a Copy';
    private static final String RECVCOPY = 'Receives a Copy';
    private static final String TOPMESSAGELINE = '<Sales Rep Name>, (<salesrep@bcbsm.com>) sent the following contract.';
	private static final String SIGNER = 'Signer';
    private static final String SIGNER1 = 'Signer 1';
	private static final String SIGNER2 = 'Signer 2';
	private static final String SIGNER3 = 'Signer 3';
    private static final String AGENT = 'Agent';
    private static final String VIEWER = 'Viewer';
	private static final String APPROVER='Approver';
    private static final String NA = 'N/A';
	private static final String GRPPRIMARY ='Group Primary';
    private static final String SEGOWNER ='Segment Owner';
	private static final String AGENTTPA='Agent/TPA';
    private static final String OTHERS='Others';
    private static final String VPADMIN='VP Admin';
   	private static final String TPA='TPA';
    private static final String COVERSHEET	='CoverSheet';
    private static final String BASEASC	='Base ASC';
    private static final String CONTRACTAMENDMNT ='Contract Amendment';
    private static final String SCHEDULEA ='Schedule A';
    private static final String SCHEDULEB ='Schedule B';
    private static final String STOPLOSSEXBHT ='Stop-Loss Exhibit';

    public static final string CLASSNAME  ='ASC_SendForSignature';
    public static final string METHODNAME  ='sendEnvelope';
 
@Future(callout=true) 
public static void sendEnvelope(Id mySourceId) {   
 
    try{
      ASC_Contractual_Document__c conids=[Select id,ASC_Contract__c from ASC_Contractual_Document__c where id=:mySourceId limit 1];  
    final Set<String> PRODUCTCODESETQLI = new Set<String>{FIXEDADMINFEE_PRDCODE,VARADMINFEE_PRDCODE,SL_INS_PRDCODE};
    String SLValue='NO SL'; //No SL - Stop Loss product is not part of the contract
    String activationType='Renewal';  
    Map<String,ASC_DocuSign_Notifications__mdt> notificationsMap = new Map<String,ASC_DocuSign_Notifications__mdt>();
        
    
    //this for loop is used to get ASC DocuSign Notification custom metadata records and store in a map object
    for(ASC_DocuSign_Notifications__mdt notifications:[SELECT Id, Action_Type__c, Activation_Type__c,Delivery_Type__c,Product_Included__c,
                                            Recipient_Type__c,Body__c,Subject__c            
                                            FROM ASC_DocuSign_Notifications__mdt
                                            WHERE DeveloperName !='Sales_Rep_Delivery_Notification' and  Delivery_Type__c =: DELIVERY_METHOD 
                                             ])
    {
            String key =   '';
            key=notifications.Recipient_Type__c;
            if(notifications.Action_Type__c!=NA)
            {
                key = key + '_' + notifications.Action_Type__c;
            }
            if(notifications.Activation_Type__c!=NA)
            {
                key = key + '_' + notifications.Activation_Type__c;
            }
            if(notifications.Product_Included__c!=NA)
            {
                key = key + '_' + notifications.Product_Included__c;
            }           
        
        notificationsMap.put(key,notifications);
        
    }
   
   //this for loop is used to get Stop Loss and Activation Type values 
  for(vlocity_ins__ContractLineItem__c cLI:[SELECT Id, vlocity_ins__ContractId__r.Name, ASC_Line_Item_Extension__r.Activation_Type__c,vlocity_ins__ProductCode__c
                                            FROM vlocity_ins__ContractLineItem__c
                                            WHERE   vlocity_ins__ContractId__c =: conids.ASC_Contract__c 
                                            AND vlocity_ins__Product2Id__r.productcode in: PRODUCTCODESETQLI ORDER BY vlocity_ins__ProductCode__c DESC ])
  {
        if(CLI.vlocity_ins__ProductCode__c==SL_INS_PRDCODE)
        {
            SLValue ='SL';
        }
                                                    
        if(CLI.vlocity_ins__ProductCode__c==FIXEDADMINFEE_PRDCODE || CLI.vlocity_ins__ProductCode__c==VARADMINFEE_PRDCODE)//because of order by desc, fixed admin activation type will be used if fixed admin exists.
        {
            activationType  = CLI.ASC_Line_Item_Extension__r.Activation_Type__c;
        }                                      
                  
}
// Create an empty envelope.
dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(new dfsle.Entity(conids.ASC_Contract__c));

    /* Apex Toolkit Method
     * global Recipient( final Id id, final String type, final Integer sequence, final Integer routingOrder, final Role role, final String name, 
     * final String email, final SigningGroup signingGroup, final String phone, final Authentication authentication, final String note,
     *  final EmailSettings emailSettings, final String hostName, final String hostEmail, final Boolean signNow, final Entity source, 
     * final Boolean readOnly, final Boolean required)
    */
    
    Map<String, String> recipientTypeMap = new Map<String, String>{SIGNER => dfsle.Recipient.TYPE_SIGNER, VIEWER => dfsle.Recipient.TYPE_CERTIFIED_DELIVERY, RECVCOPY => dfsle.Recipient.TYPE_CARBON_COPY, GRPPRIMARY => dfsle.Recipient.TYPE_SIGNER, APPROVER => dfsle.Recipient.TYPE_SIGNER};
    List<dfsle.Recipient> recipientList =  new List<dfsle.Recipient>();
    //Populate the list of recipients that are either approver or signers. 
    Integer Counter = 3;
    Integer roleCounter = 1;
    dfsle.Recipient approverDocuSignRecipient;    
    dfsle.Recipient vpSignerDocuSignRecipient;    
    dfsle.Recipient groupPrimaryDocuSignRecipient;        
    List<DocuSign_Participant__c> recipientListTemp = [SELECT Id, Name, Recipient_Email__c,Routing_Order__c,DocuSign_Action__c,RecordType.name, Contract__r.ASC_Contract_Package_Name__c,Contract__r.Sales_Rep_Name__c,Contract__r.Sales_Rep_Email__c FROM DocuSign_Participant__c where Contract__c=:conids.ASC_Contract__c AND Active__c=true AND DocuSign_Action__c IN ('Signer','Group Primary','Approver') order by Routing_Order__c];    
        for (DocuSign_Participant__c recipient : recipientListTemp) 
        {
            String strRole = '';
            if(recipient.DocuSign_Action__c==APPROVER)
            {
                strRole = SIGNER1;
                roleCounter = 1;
                dfsle.Recipient.Role role = new dfsle.Recipient.Role(strRole,roleCounter);
                dfsle.Recipient.EmailSettings emailSettings= getEmailContent(notificationsMap,recipient.recordtype.name,recipient.DocuSign_Action__c,activationType,SLValue, recipient.Contract__r.ASC_Contract_Package_Name__c,recipient.Contract__r.Sales_Rep_Name__c,recipient.Contract__r.Sales_Rep_Email__c); //new dfsle.Recipient.EmailSettings('en','English','Signature Email - ' + Counter,'Test Body ' + Counter); 
                
                approverDocuSignRecipient = new dfsle.Recipient(null, recipientTypeMap.get(recipient.DocuSign_Action__c), roleCounter, Integer.valueOf(recipient.Routing_Order__c), role, recipient.Name, recipient.Recipient_Email__c, null, null, null, null, emailSettings, null, null, null, new dfsle.Entity(recipient.Id), false, false);
            }
            else if(recipient.DocuSign_Action__c==GRPPRIMARY)
            {
                strRole = SIGNER3;
                roleCounter = 3;
                dfsle.Recipient.Role role = new dfsle.Recipient.Role(strRole,roleCounter);
                dfsle.Recipient.EmailSettings emailSettings= getEmailContent(notificationsMap,recipient.recordtype.name,recipient.DocuSign_Action__c,activationType,SLValue, recipient.Contract__r.ASC_Contract_Package_Name__c,recipient.Contract__r.Sales_Rep_Name__c,recipient.Contract__r.Sales_Rep_Email__c); //new dfsle.Recipient.EmailSettings('en','English','Signature Email - ' + Counter,'Test Body ' + Counter); 
                
                groupPrimaryDocuSignRecipient = new dfsle.Recipient(null, recipientTypeMap.get(recipient.DocuSign_Action__c), roleCounter, Integer.valueOf(recipient.Routing_Order__c), role, recipient.Name, recipient.Recipient_Email__c, null, null, null, null, emailSettings, null, null, null, new dfsle.Entity(recipient.Id), false, false);
                //groupPrimaryDocuSignRecipient = new dfsle.Recipient(null, recipientTypeMap.get(recipient.DocuSign_Action__c), roleCounter, Integer.valueOf(recipient.Routing_Order__c), role, recipient.Name, testEmail, null, null, null, null, emailSettings, null, null, null, new dfsle.Entity(recipient.Id), false, false);
            }
            else if(recipient.RecordType.name==SEGOWNER)
            {
                strRole = SIGNER2;
                roleCounter = 2;
                dfsle.Recipient.Role role = new dfsle.Recipient.Role(strRole,roleCounter);
                dfsle.Recipient.EmailSettings emailSettings= getEmailContent(notificationsMap,recipient.recordtype.name,recipient.DocuSign_Action__c,activationType,SLValue, recipient.Contract__r.ASC_Contract_Package_Name__c,recipient.Contract__r.Sales_Rep_Name__c,recipient.Contract__r.Sales_Rep_Email__c); //new dfsle.Recipient.EmailSettings('en','English','Signature Email - ' + Counter,'Test Body ' + Counter); 
                
                vpSignerDocuSignRecipient = new dfsle.Recipient(null, recipientTypeMap.get(recipient.DocuSign_Action__c), roleCounter, Integer.valueOf(recipient.Routing_Order__c), role, recipient.Name, recipient.Recipient_Email__c, null, null, null, null, emailSettings, null, null, null, new dfsle.Entity(recipient.Id), false, false);
                //vpSignerDocuSignRecipient = new dfsle.Recipient(null, recipientTypeMap.get(recipient.DocuSign_Action__c), roleCounter, Integer.valueOf(recipient.Routing_Order__c), role, recipient.Name, testEmail, null, null, null, null, emailSettings, null, null, null, new dfsle.Entity(recipient.Id), false, false);
            }
            }       
        if(vpSignerDocuSignRecipient!=null)
        {
            recipientList.add(vpSignerDocuSignRecipient);
        }
        if(groupPrimaryDocuSignRecipient!=null)
        {
            recipientList.add(groupPrimaryDocuSignRecipient);
        }
        
        for (DocuSign_Participant__c recipient : recipientListTemp) 
        {
            String strRole = '';            
            if(recipient.DocuSign_Action__c==SIGNER && recipient.RecordType.name!=SEGOWNER ) //Segment Owner is already added in previous loop
            {
                Counter = Counter+1;            
                roleCounter = Counter;
                strRole = SIGNER + Counter;
                dfsle.Recipient.Role role = new dfsle.Recipient.Role(strRole,roleCounter);
                dfsle.Recipient.EmailSettings emailSettings= getEmailContent(notificationsMap,recipient.recordtype.name,recipient.DocuSign_Action__c,activationType,SLValue, recipient.Contract__r.ASC_Contract_Package_Name__c,recipient.Contract__r.Sales_Rep_Name__c,recipient.Contract__r.Sales_Rep_Email__c); //new dfsle.Recipient.EmailSettings('en','English','Signature Email - ' + Counter,'Test Body ' + Counter); 
                dfsle.Recipient docuSignRecipient = new dfsle.Recipient(null, recipientTypeMap.get(recipient.DocuSign_Action__c), roleCounter, Integer.valueOf(recipient.Routing_Order__c), role, recipient.Name, recipient.Recipient_Email__c, null, null, null, null, emailSettings, null, null, null, new dfsle.Entity(recipient.Id), false, false);
                //dfsle.Recipient docuSignRecipient = new dfsle.Recipient(null, recipientTypeMap.get(recipient.DocuSign_Action__c), roleCounter, Integer.valueOf(recipient.Routing_Order__c), role, recipient.Name, testEmail, null, null, null, null, emailSettings, null, null, null, new dfsle.Entity(recipient.Id), false, false);
                recipientList.add(docuSignRecipient);
            }            
        }
        //approver is added as last recipient because anchor tag is generated accordingly in the Cover Letter Template
        if(approverDocuSignRecipient!=null)
        {
            recipientList.add(approverDocuSignRecipient);
        }
       
        //Populate the list of recipients that are either viewer or CCed. 
        for (DocuSign_Participant__c recipient : [SELECT Id, Name, Recipient_Email__c,Email__c,Routing_Order__c,DocuSign_Action__c,RecordType.name, Contract__r.ASC_Contract_Package_Name__c,Contract__r.Sales_Rep_Name__c,Contract__r.Sales_Rep_Email__c  FROM DocuSign_Participant__c where Contract__c=:conids.ASC_Contract__c AND Active__c=true AND DocuSign_Action__c NOT IN ('Signer','Group Primary','Approver') order by Routing_Order__c]) 
        {
            String strRole = '';
            Counter = Counter+1;   
            roleCounter = Counter;
            strRole = SIGNER + Counter;
            //dfsle.Recipient.Role role = null;
             dfsle.Recipient.Role role = new dfsle.Recipient.Role(strRole,roleCounter);
            dfsle.Recipient.EmailSettings emailSettings= getEmailContent(notificationsMap,recipient.recordtype.name,recipient.DocuSign_Action__c,activationType,SLValue, recipient.Contract__r.ASC_Contract_Package_Name__c,recipient.Contract__r.Sales_Rep_Name__c,recipient.Contract__r.Sales_Rep_Email__c); 
            
                
            dfsle.Recipient docuSignRecipient = new dfsle.Recipient(null, recipientTypeMap.get(recipient.DocuSign_Action__c), Counter, Integer.valueOf(recipient.Routing_Order__c), role, recipient.Name, recipient.Recipient_Email__c, null, null, null, null, emailSettings, null, null, null, new dfsle.Entity(recipient.Id), false, false);
            recipientList.add(docuSignRecipient);
        }
    myEnvelope = myEnvelope.withRecipients(recipientList);    
    
    
    // Get a contractual record that has all documents that need to be included in DocuSign Envelope
    ASC_Contractual_Document__c contractDocuments=[select id,name from ASC_Contractual_Document__c where 
                                                   ASC_Document_Type__c=: System.Label.ASC_DocuSign_Envelope_Document_Type                                                   
                                                   and ASC_Contract__c=:conids.ASC_Contract__c limit 1];
     


    List<dfsle.Document>  myDocument = dfsle.DocumentService.getLinkedDocuments(ContentVersion.getSObjectType(),new Set<Id>{contractDocuments.Id},false);
    List<dfsle.Document>  myDocumentSort = new List<dfsle.Document>();
    dfsle.Document coverSheetDoc;    
    dfsle.Document BaseContractDoc; 
    dfsle.Document AmendmentDoc;    
    dfsle.Document ScheduleADoc; 
    dfsle.Document ScheduleBDoc;    
    dfsle.Document StopLossExhibitDoc;    
	
    for (dfsle.Document doc : myDocument) {
        System.debug('Doc Name' + doc.name);
        if(doc.name.contains(COVERSHEET))   
        {
            
            coverSheetDoc = doc; //new dfsle.Document( null, doc.type, 1, doc.name, doc.extension, doc.size, doc.lastModified, doc.sourceId);
            
            
        }
        else if(doc.name.contains(BASEASC))   
        {
            
            BaseContractDoc = doc; //new dfsle.Document( null, doc.type, 1, doc.name, doc.extension, doc.size, doc.lastModified, doc.sourceId);
            
            
        }  else if(doc.name.contains(CONTRACTAMENDMNT))   
        {
            
            AmendmentDoc = doc; //new dfsle.Document( null, doc.type, 1, doc.name, doc.extension, doc.size, doc.lastModified, doc.sourceId);
            
            
        }    else if(doc.name.contains(SCHEDULEA))   
        {
            
            ScheduleADoc = doc; //new dfsle.Document( null, doc.type, 1, doc.name, doc.extension, doc.size, doc.lastModified, doc.sourceId);
            
            
        }    else if(doc.name.contains(SCHEDULEB))   
        {
            
            ScheduleBDoc = doc; //new dfsle.Document( null, doc.type, 1, doc.name, doc.extension, doc.size, doc.lastModified, doc.sourceId);
            
            
        }    else if(doc.name.contains(STOPLOSSEXBHT))   
        {
            
            StopLossExhibitDoc = doc; //new dfsle.Document( null, doc.type, 1, doc.name, doc.extension, doc.size, doc.lastModified, doc.sourceId);
            
            
        }        
            
            
              
        
    }      
     if(coverSheetDoc!=null)   
     {
        myDocumentSort.add(coverSheetDoc);
     }
     if(BaseContractDoc!=null)   
     {
         myDocumentSort.add(BaseContractDoc); 
     }        
     if(AmendmentDoc!=null)   
     {
         myDocumentSort.add(AmendmentDoc);
     }        
     if(ScheduleADoc!=null)   
     {
        myDocumentSort.add(ScheduleADoc); 
     } 
      if(ScheduleBDoc!=null)   
     {
        myDocumentSort.add(ScheduleBDoc); 
     }        
     if(StopLossExhibitDoc!=null)   
     {
        myDocumentSort.add(StopLossExhibitDoc);   
     }        
       
     
        
    // Add document to the Envelope

    myEnvelope = myEnvelope.withDocuments(myDocumentSort);
        
    // Send the envelope
    myEnvelope = dfsle.EnvelopeService.sendEnvelope(myEnvelope,true);
    }catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME);
            
        }   
    
}

    public static dfsle.Recipient.EmailSettings getEmailContent(Map<String,ASC_DocuSign_Notifications__mdt> notificationsMap,String RecipientType, String ActionType, String ActivationType, String ProductIncluded, String packageName,String SalesRepName,String SalesRepEmail)
    {
        String emailSubject = '';
        String emailBody = '';
        if(RecipientType==TPA || RecipientType==AGENT)
        {
            RecipientType =AGENTTPA;
        }       
        
        else if(ActionType==GRPPRIMARY)
        {
            ActionType = SIGNER;
        }
        String mapKey = RecipientType + '_' + ActionType + '_' + ActivationType + '_' + ProductIncluded;
        
        if(RecipientType==SEGOWNER || RecipientType==OTHERS ||RecipientType==VPADMIN) //For Segment Owner email notification content will not change for Activation Type and Stop Loss Product
        {
            mapKey = RecipientType + '_' + ActionType;
        }
        
        ASC_DocuSign_Notifications__mdt emailContent = notificationsMap.get(mapKey);
        
        if(emailContent==null)
        {            
           emailContent = notificationsMap.get(defaultEmailContentKey);
        }
        
        emailSubject = emailContent.Subject__c.replace('<Package Name>',packageName);
  //Truncate the email subject to 100 characters
        If(emailSubject.length()>99)
{
               emailSubject = emailSubject.substring(0,99);

}

        emailBody = TOPMESSAGELINE + '<br /> <br />' + emailContent.Body__c;

        emailBody = emailBody.replace('<Sales Rep Name>',SalesRepName).replace('<salesrep@bcbsm.com>',SalesRepEmail);
        dfsle.Recipient.EmailSettings emailSetting= new dfsle.Recipient.EmailSettings('en','English',emailSubject ,emailBody ); 
        return emailSetting;
    }

}