/*****************************************************************************************
Class Name   : GA_AP_ShowValidationMessages
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to fetch the validation error of the step
******************************************************************************************/
public class GA_AP_ShowValidationMessages {
    public static final string hyphenVal='-';
    public static final string ErrorMsg='There is problem in fetching validations';
    public static final string selectQuery='Select id,Name,GA_WF_Workflow_ID__r.GA_Account__c,GA_WF_Workflow_ID__r.GA_Account__r.Name,GA_WF_Workflow_ID__r.GA_Support__c,'+
        'GA_WF_Workflow_ID__r.GA_Support__r.CaseNumber,GA_WF_Workflow_ID__r.GA_Support__r.GA_Corporate_Received_Date__c,GA_WF_Workflow_ID__r.GA_Support__r.GA_Quote_ID__c,'+
        'GA_WF_Workflow_ID__r.GA_Support__r.RecordTypeId,GA_WF_Workflow_ID__r.OwnerId,GA_WF_Workflow_ID__r.Owner.Name,GA_WF_Workflow_ID__r.GA_Date_Opened__c,'+
        'GA_WF_Workflow_ID__r.GA_Date_Closed__c,GA_WF_Workflow_ID__r.Name,GA_WF_Workflow_ID__r.GA_Notes__c,GA_Status__c,'+
        '(select id,GA_Group_Segment_ID__r.Name,GA_Group_Segment_ID__r.GA_Group_Effective_Date__c,GA_Group_Segment_ID__r.GA_Rate_Renewal_Date__c,'+
        'GA_Group_Segment_ID__r.GA_Mailing_Address_1__c,GA_Group_Segment_ID__r.GA_Mailing_City__c,GA_Group_Segment_ID__r.GA_Mailing_State__c,GA_Group_Segment_ID__r.GA_Mailing_Zip__c,GA_Group_Segment_ID__r.GA_Mailing_County_Id__c,'+
                'GA_Group_Segment_ID__r.GA_Physical_Address_1__c,GA_Group_Segment_ID__r.GA_Physical_City__c,GA_Group_Segment_ID__r.GA_Physical_State__c,GA_Group_Segment_ID__r.GA_Physical_Zip__c,GA_Group_Segment_ID__r.GA_Physical_County_Id__c,'+
        'GA_Group_Segment_ID__r.GA_Billing_Address_1__c,GA_Group_Segment_ID__r.GA_Billing_City__c,GA_Group_Segment_ID__r.GA_Billing_State__c,GA_Group_Segment_ID__r.GA_Billing_Zip__c,GA_Group_Segment_ID__r.GA_Billing_County_Id__c,'+
        'GA_Group_Segment_ID__r.GA_Servicing_Agent__c,GA_Group_Segment_ID__r.GA_Group_Factor_Cluster_Code__c,'+
        'GA_Group_Segment_ID__r.GA_Customer_Signed_Date__c,GA_Group_Segment_ID__r.GA_Rating_Type__c,GA_Group_Segment_ID__c from GA_WF_Group_Segments__r limit 100)'+ 
        'from GA_WF_Step__c where '; 
    public static final string supportReqTyp= 'Support - Request';
    public static final string supportWMReqTyp= 'Support - Support / West Michigan';
    public static final Id supportReqId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(supportReqTyp).getRecordTypeId();
    public static final Id supportWMReqId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(supportWMReqTyp).getRecordTypeId();
    public static final string whereClause=' id in';
    public static final string limitClause=' limit 1';
    public static final string selectWFrec = 'select Id,Name,GA_WF_Workflow_ID__c,GA_WF_Workflow_ID__r.GA_Workflow_Template__c from GA_WF_Step__c where';    
    public static final string selectGrpSgmntQuery='select id,GA_Group_Segment_ID__r.Name,GA_WF_Step_ID__c,GA_Group_Segment_ID__c,GA_Validation_Status__c  from GA_WF_Group_Segment__c where ';
    public static final string whereClause2 =' id = ';
    public static final string whrGrpSgmnt ='  GA_Group_Segment_ID__c in';
    public static final string whrWFStp  ='  and GA_WF_Step_ID__c=';
    public static final string limitStr  =' limit 1000 ';
    public static final String excepSepartr=': ';
    public static final  Set<Id> allGrpSgmntIds = New Set<Id>();
    public static final  Set<Id> failGrpSgmntIds = New  Set<Id>();
    public static final string stepNameRec  ='stepNameRec';
    public static final string wrktStepValidate  ='wrktStepValidate';
    public static final string wrktStepValidatePrepocessing  ='wrktStepValidatePrepocessing';
    public static final string wrktStepValidateGrpSgmnts  ='wrktStepValidateGrpSgmnts';
    public static final string fetchmessages  ='fetchmessages';
    public static final string errMsgShow  ='errMsgShow';
    public static final string ClsName  ='GA_AP_ShowValidationMessages';
    public static final string PreProcessing  = 'Pre-Processing';
    public static final string sprtr = '~';
    public static final string corpRecDateErr ='Corporate Recieved Date cannot be null';
    public static final string quoteIdErr ='Quote ID cannot be null';
    public static final string grpEffDateErr = 'Group Effective Date cannot be null';
    public static final string MailingStrtErr = 'Mailing Street Address 1 is a required field';
    public static final string MailingCityErr = 'Mailing City is a required field';
    public static final string MailingStatErr = 'Mailing State/Province is a required field';
    public static final string MailingZipErr = 'Mailing Zip is a required field';
    public static final string MailingCountyErr = 'Mailing County is a required field';
    public static final string PhysicalStrtErr = 'Physical Street Address 1 is a required field';
    public static final string PhysicalCityErr = 'Physical City is a required field';
    public static final string PhysicalStatErr = 'Physical State/Province is a required field';
    public static final string PhysicalZipErr = 'Physical Zip is a required field';
    public static final string PhysicalCountyErr = 'Physical County is a required field';
    public static final string BilingStrtErr = 'Billing Street Address 1 is a required field';
    public static final string BilingCityErr = 'Billing City is a required field';
    public static final string BilingStatErr = 'Billing State/Province is a required field';
    public static final string BilingZipErr = 'Billing Zip is a required field';
    public static final string BilingCountyErr = 'Billing County is a required field';
    public static final string custSignDateErr = 'Customer Signed Date cannot be null';
    public static final string rateRenewalDatErr ='Rate Renewal Date cannot be null';
    public static final string ratingTypErr ='Rating Type cannot be null';
    public static final string grpfctClustCodeErr = 'Future Cluster Code cannot be null';
    public static final string srvAgntErr = 'Servicing Agent cannot be null';
    public static final string fail = 'FAIL';
    public static final string pass = 'PASS';
    public static final string strStart = '500';
    public static final string strEnd ='001';
    /**
@Description: stepNameRec() method 
@Name : stepNameRec
@Param : String wfstpId
@Return : string
@throws Exception : AuraHandledException;
*/
    
    @AuraEnabled
    public static string  stepNameRec(String wfstpId)
    {
        try
        {
            GA_WF_Step__c wfstRec = GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(selectWFrec, 
                                    whereClause2+GA_Util08_FilterProcessHelper.FltrString(wfstpId) ,
                                    GA_Util03_WrkflwDataAccessHelper.BLANK, 
                                    limitClause).values();
                //[select Id,Name from GA_WF_Step__c where id =: wfstpId Limit 1];
            return wfstRec.Name;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, stepNameRec);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage());  
        }   
    }
    
    /**
@Description: wrktStepValidate() method 
@Name : wrktStepValidate
@Param : String wfstpId
@Return : list<errormessage> 
@throws Exception : AuraHandledException;
*/
    @AuraEnabled
    public static list<errormessage>  wrktStepValidate(String wfstpId)
    {
        try
        {
            
            List<String > validationMessages = New List<String > ();
            Boolean NoValidationFired = false;
            list<GA_WFT_Allowed_Next_Step__c> nxtSteps = New  list<GA_WFT_Allowed_Next_Step__c>();
            
            validationMessages.clear();
            
            GA_WF_Step__c wfstRec = GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(selectWFrec, 
                                    whereClause2+GA_Util08_FilterProcessHelper.FltrString(wfstpId) ,
                                    GA_Util03_WrkflwDataAccessHelper.BLANK, 
                                    limitClause).values();
                
                //[select Id,GA_WF_Workflow_ID__c,GA_WF_Workflow_ID__r.GA_Workflow_Template__c from GA_WF_Step__c where id =: wfstpId Limit 1];
            validationMessages = GA_AP_03_WkflwValidation.wfallwdSteps(wfstRec.GA_WF_Workflow_ID__r.GA_Workflow_Template__c,wfstRec.GA_WF_Workflow_ID__c,wfstpId);
            list<errormessage> errormessageLst=fetchmessages(validationMessages);
            return errormessageLst;
            
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, wrktStepValidate);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage());  
        }
    }
    /**
@Description: wrktStepValidatePrepocessing() method 
@Name : wrktStepValidatePrepocessing
@Param : String wfstpId
@Return : list<errormessage> 
@throws Exception : AuraHandledException;
*/
    @AuraEnabled
    public static list<errormessage> wrktStepValidatePrepocessing(String wfstpId)
    {
        try {
            
            
            set<id> wkflwStpIdSet=new set<id>();
            list<errormessage> errormessageLst;
            wkflwStpIdSet.add(wfstpId);
            string wkflwStepIdString=GA_Util08_FilterProcessHelper.idSet(wkflwStpIdSet);
            list<GA_WF_Step__c> wKflwStepRecLst=GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(selectQuery, 
                                                                                                        whereClause+wkflwStepIdString, 
                                                                                                        GA_Util03_WrkflwDataAccessHelper.BLANK, 
                                                                                                        limitClause).values();
            list<string> customMessge=new list<string>();
            GA_WF_Step__c wKflwStepRec=wKflwStepRecLst[0];
            
            
            if(wKflwStepRec.Name== PreProcessing)
            {
                list<GA_WF_Group_Segment__c> wKflwStepGrpRec=wKflwStepRecLst[0].GA_WF_Group_Segments__r;
              /**  if(wKflwStepRec.GA_WF_Workflow_ID__r.GA_Support__c !=null)
                {
                  /**  if(wKflwStepRec.GA_WF_Workflow_ID__r.GA_Support__r.GA_Corporate_Received_Date__c==null)
                    {
                        customMessge.add(wKflwStepRec.GA_WF_Workflow_ID__r.GA_Support__c+sprtr+wKflwStepRec.GA_WF_Workflow_ID__r.GA_Support__r.CaseNumber+sprtr+corpRecDateErr+sprtr+'GA_Corporate_Received_Date__c'+sprtr+'Date'+sprtr+'Case');
                        
                    }**/
                    
                    /*if(wKflwStepRec.GA_WF_Workflow_ID__r.GA_Support__r.GA_Quote_ID__c==null)
                    {
                        if(wKflwStepRec.GA_WF_Workflow_ID__r.GA_Support__r.recordtypeid ==  supportWMReqId){
                            customMessge.add(wKflwStepRec.GA_WF_Workflow_ID__r.GA_Support__c+sprtr+wKflwStepRec.GA_WF_Workflow_ID__r.GA_Support__r.CaseNumber+sprtr+quoteIdErr+sprtr+'GA_Quote_ID__c'+sprtr+'Text'+sprtr+'Case');
                        }
                    }
                }**/

                List<GA_WF_Group_Segment__c> updtWfGrpSgmtlst = New  List<GA_WF_Group_Segment__c>();
                for(GA_WF_Group_Segment__c wkflwGrpSgmnt:wKflwStepGrpRec)
                {
                   
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Group_Effective_Date__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+grpEffDateErr+sprtr+'GA_Group_Effective_Date__c'+sprtr+'Date'+sprtr+'GA_Group_Segment__c'+sprtr+'Group Effective Date');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    
                   if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Mailing_Address_1__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+MailingStrtErr+sprtr+'GA_Mailing_Address_1__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Mailing Street Address 1');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Mailing_City__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+MailingCityErr+sprtr+'GA_Mailing_City__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Mailing City');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Mailing_State__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+MailingStatErr+sprtr+'GA_Mailing_State__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Mailing State/Province');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Mailing_Zip__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+MailingZipErr+sprtr+'GA_Mailing_Zip__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Mailing Zip');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Mailing_County_Id__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+MailingCountyErr+sprtr+'GA_Mailing_County_Id__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Mailing County');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Physical_Address_1__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+PhysicalStrtErr+sprtr+'GA_Physical_Address_1__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Physical Street Address 1');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Physical_City__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+PhysicalCityErr+sprtr+'GA_Physical_City__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Physical City');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Physical_State__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+PhysicalStatErr+sprtr+'GA_Physical_State__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Physical State/Province');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Physical_Zip__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+PhysicalZipErr+sprtr+'GA_Physical_Zip__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Physical Zip');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Physical_County_Id__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+PhysicalCountyErr+sprtr+'GA_Physical_County_Id__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Physical County');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    
                                        if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Billing_Address_1__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+BilingStrtErr+sprtr+'GA_Billing_Address_1__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Billing Street Address 1');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Billing_City__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+BilingCityErr+sprtr+'GA_Billing_City__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Billing City');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Billing_State__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+BilingStatErr+sprtr+'GA_Billing_State__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Billing State/Province');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Billing_Zip__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+BilingZipErr+sprtr+'GA_Billing_Zip__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Billing Zip');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    }
                    if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Billing_County_Id__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+BilingCountyErr+sprtr+'GA_Billing_County_Id__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Billing County');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                        //return true;  
                    } 
                  /**  if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Customer_Signed_Date__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+custSignDateErr+sprtr+'GA_Customer_Signed_Date__c'+sprtr+'Date'+sprtr+'GA_Group_Segment__c');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);  
                    } **/
                    
                  /**  if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Rate_Renewal_Date__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+rateRenewalDatErr+sprtr+'GA_Rate_Renewal_Date__c'+sprtr+'Date'+sprtr+'GA_Group_Segment__c'+sprtr+'Rate Renewal Date');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                    } **/
                    /*if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Rating_Type__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+ratingTypErr+sprtr+'GA_Rating_Type__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c); 
                    }*/
                 /**   if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Group_Factor_Cluster_Code__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+grpfctClustCodeErr+sprtr+'GA_Group_Factor_Cluster_Code__c'+sprtr+'Text'+sprtr+'GA_Group_Segment__c'+sprtr+'Future Cluster Code');
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c); 
                    } **/
                    /*if(wkflwGrpSgmnt.GA_Group_Segment_ID__r.GA_Servicing_Agent__c==null)
                    {
                        customMessge.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c+sprtr+wkflwGrpSgmnt.GA_Group_Segment_ID__r.Name+sprtr+srvAgntErr);
                        failGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                    } */     
                    errormessageLst=fetchmessages(customMessge);
                    allGrpSgmntIds.add(wkflwGrpSgmnt.GA_Group_Segment_ID__c);
                    
                    
                    
                    
                    if(!allGrpSgmntIds.isEmpty() && !failGrpSgmntIds.isEmpty()){
                        allGrpSgmntIds.removeAll(failGrpSgmntIds);
                    }
                    

                    
                   
                } 
                if(!failGrpSgmntIds.isEmpty())   {
                    
                    string grpSgmntIdset=GA_Util08_FilterProcessHelper.idSet(failGrpSgmntIds);
                    List<GA_WF_Group_Segment__c> wfStpGrpSgmnts =GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(selectGrpSgmntQuery,
                                                                                                                    whrGrpSgmnt+GA_Util08_FilterProcessHelper.idSet(failGrpSgmntIds)+
                                                                                                                    whrWFStp+GA_Util08_FilterProcessHelper.FltrString(wfstpId),
                                                                                                                    GA_Util15_WFGSDataAccesHelper.BLANK,
                                                                                                                    limitStr).values();
                    /**   List<GA_WF_Group_Segment__c> wfStpGrpSgmnts = [Select Id,GA_WF_Step_ID__c,GA_Group_Segment_ID__c,GA_Validation_Status__c from   GA_WF_Group_Segment__c
where GA_Group_Segment_ID__c in:  failGrpSgmntIds and GA_WF_Step_ID__c=:wfstpId Limit 100]; **/
                    for(GA_WF_Group_Segment__c wfgs : wfStpGrpSgmnts){
                        wfgs.GA_Validation_Status__c = fail;
                        updtWfGrpSgmtlst.add(wfgs);
                    }
                } 
                
                IF(!allGrpSgmntIds.isEmpty()){
                    
                    
                    
                    List<   GA_WF_Group_Segment__c> wfStpGrpSgmnts =GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(selectGrpSgmntQuery,
                                                                                                                       whrGrpSgmnt+GA_Util08_FilterProcessHelper.idSet(allGrpSgmntIds)+
                                                                                                                       whrWFStp+GA_Util08_FilterProcessHelper.FltrString(wfstpId),
                                                                                                                       GA_Util15_WFGSDataAccesHelper.BLANK,
                                                                                                                       limitStr).values();
                    
                    
                    for(GA_WF_Group_Segment__c wfgs : wfStpGrpSgmnts){
                        wfgs.GA_Validation_Status__c = pass;
                        updtWfGrpSgmtlst.add(wfgs);
                    }
                }
                
                if(!updtWfGrpSgmtlst.isEmpty()){
                    
                    GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(updtWfGrpSgmtlst, GA_Util15_WFGSDataAccesHelper.UPDATE_OPERATION);
                }
                
            }
            else
            {
                errormessageLst=wrktStepValidate(wfstpId);
                
            }
            return errormessageLst;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, wrktStepValidatePrepocessing);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage());  
        }
        
    }
    /**
@Description: wrktStepValidateGrpSgmnts() method 
@Name : wrktStepValidateGrpSgmnts
@Param : String wfstpId
@Return : list<errormessage> 
@throws Exception : AuraHandledException;
*/    
    @AuraEnabled
    public static list<errormessage> wrktStepValidateGrpSgmnts(String wfgsId)
    {
        try {
            list<errormessage> errormessageLst;
            list<errormessage> grpSgmntErrLst = New  list<errormessage>();
            List<GA_WF_Group_Segment__c> wfgsLst = GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(selectGrpSgmntQuery,whereClause2+GA_Util08_FilterProcessHelper.FltrString(wfgsId),GA_Util15_WFGSDataAccesHelper.BLANK,limitClause).values();
            String grpSgmntName = wfgsLst[0].GA_Group_Segment_ID__r.Name;
            
            errormessageLst=wrktStepValidate( wfgsLst[0].GA_WF_Step_ID__c);
            
            for(errormessage err: errormessageLst){
                if(err.errRecName == grpSgmntName){
                    grpSgmntErrLst.add(err);
                }
            }
             return grpSgmntErrLst;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, wrktStepValidateGrpSgmnts);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage());  
        }
    }
    /**
@Description: fetchmessages() method 
@Name : fetchmessages
@Param : list<string> validationDtls
@Return : list<errormessage> 
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static list<errormessage> fetchmessages(list<string> validationDtls)
    {
        try
        {
            list<errormessage> errormessageLst=new list<errormessage>();
            
            for(String msg : validationDtls){
                List<String> msgVal =  msg.split(sprtr, 7);
                
                errormessage err=new errormessage(msgVal[0] ,msgVal[1],msgVal[2]);
                err.errfieldNme=msgVal[3];
                err.errfieldType=msgVal[4];
                err.errObjNme=msgVal[5];
                err.errFieldLbl=msgVal[6];
                errormessageLst.add(err);
            }
            

            return errormessageLst;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchmessages);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage());  
        }
    }
    /**
@Description: errMsgShow() method 
@Name : errMsgShow
@Param :id wflwStpId,List<id> lstGroupSegments
@Return : list<errormessage> 
@throws Exception : AuraHandledException;
*/  
    @AuraEnabled   
    public static list<errormessage> errMsgShow(id wflwStpId,List<id> lstGroupSegments)
    {
        try
        {
            list<errormessage> errormessageLst= GA_AP_ShowValidationMessages.wrktStepValidatePrepocessing(wflwStpId);
            list<errormessage> grpSgmntErrLst=new list<errormessage>();
            
            
            for(errormessage err:errormessageLst)
            {
                if(lstGroupSegments.contains(err.errRecId) || (err.errRecId.startsWith(strStart) || err.errRecId.startsWith(strEnd))){
                    grpSgmntErrLst.add(err);
                }
            }
            return grpSgmntErrLst;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, errMsgShow);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage());  
        }
    } 
    /**
@Description: errormessage wrapper classes
@throws Exception : AuraHandledException;
*/ 
    public class errormessage
    {
        @AuraEnabled
        public string errRecId ;
        @AuraEnabled
        public String errRecName;       
        @AuraEnabled
        public String errmessage; 
        @AuraEnabled
        public String errRecIdUrl; 
        @AuraEnabled
        public String errfieldNme; 
        @AuraEnabled
        public String errfieldType; 
        @AuraEnabled
        public String errObjNme; 
        @AuraEnabled
        public String errFieldLbl;         
        public errormessage(string errRecIdTmp,string errRecNameTmp,String errmessageTmp)
        {
            errRecId =errRecIdTmp;
            errRecIdUrl='/'+errRecIdTmp;
            errRecName = errRecNameTmp;
            errmessage=errmessageTmp;
            
        }
    }
    
    
}