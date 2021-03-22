/*************************************************************
Class Name   : ARV_AP19_EffectiveDatePreparation
Date Created : 17-May-2019
Created By   : IDC Offshore
Description  : This class reutrns EffectiveDates on GroupProfiles page in Small Group Quoting.
*********************************************************************************************/
global with Sharing class ARV_AP19_EffectiveDatePreparation implements vlocity_ins.VlocityOpenInterface{
    private static final string QUOTECHARS=Quote.sobjecttype.getDescribe().getKeyPrefix();
    private static final string ACCOUNTCHARS=Account.sobjecttype.getDescribe().getKeyPrefix();
    private static final String DATEFORMAT = 'MMM d yyyy';
    private static final String NAME_CONSTANT = 'name';
    private static  String VALUE_CONSTANT = 'value';
    private static final String OPTIONS_CONSTANT = 'options';
    private static final String GETREQUESTCOVERAGEBROKERDATES ='getRequestCoverageBrokerDates'; 
    private static final String CLSNAME='ARV_AP14_EffectiveDatePreparation';
    private static final String METHODNAME='getRequestCoverageBrokerDates';
    private static final String GETREQUESTCOVERAGEBROKERDATESGWC ='getRequestCoverageBrokerDatesGwc';
    private static final String GETREQUESTCOVERAGEBROKERDATESALTQUOTE ='getRequestCoverageBrokerDatesAltQuote';
    private static final String ERRORMSG='Requested date not populating';
    private static final String EXCEPSEPRATR=':';
    private static final String METADATA_QRY = 'SELECT Id,MasterLabel, Available_for_Agent__c,End_Date__c,Start_Date__c FROM Requested_Eff_Date__mdt';
    private static final String METADATA_WHERE = ' where MasterLabel =\'Agent Effective Dates\' AND Available_for_Agent__c=true';
    private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME2='BCBSM Both';
    private static final string PROFILENAME1='Managing Agent Community User';
    private static final string LABELNAME='Agent Effective Dates';
    private static  string QUOTEID;
    private static final string CONTEXTID='ContextId';
    
    /********************************************************************************************
    Constructor Name   : ARV_AP19_EffectiveDatePreparation.    
    Description  : This constructor is used to initiation of Variables.
    **************************************************************************/
    global ARV_AP19_EffectiveDatePreparation(){
        VALUE_CONSTANT = 'value';
    }
    
    /************************************************************************************
Method Name : invokeMethod
Description : This method is created to display broker (External User) effective dates for quote and enroll
************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, 
                                Map<String,Object> outMap, Map<String,Object> options){
                                    boolean result = true;
                                    System.debug('InputMap'+inputMap);
                                    System.debug('Options'+options);
                                    System.debug('MethodName'+methodName);
                                    
                                    try{
                                        if (methodName == GETREQUESTCOVERAGEBROKERDATES) 
                                        {
                                            getRequestCoverageBrokerDates(outMap); 
                                        }
                                        
                                        /*if(methodName.equalsIgnoreCase(GETREQUESTCOVERAGEBROKERDATES)){
getRequestCoverageBrokerDates(outMap);                
} */
                                       else if(methodName == GETREQUESTCOVERAGEBROKERDATESGWC)
                                        {
                                             getRequestCoverageBrokerDatesGwc(inputMap,outMap,options); 
                                        }
                                        
                                    }
                                    catch(Exception e){ result = false;} return result;
                                }
    
    /************************************************************************************
Method Name : getRequestCoverageBrokerDates(ARV_CS01_EffectiveDate__c)
Description : This method is created to display broker (External User) effective dates for quote and enroll
************************************************************************************/
    void  getRequestCoverageBrokerDates(Map<String,object> outMap){        
        //date mydate = system.today().addDays(17);
        date mydate = system.today();
        List<Map<String, String>> quoteRequestCoverageEffectiveDates = new List<Map<String,String>>(); 
        quoteRequestCoverageEffectiveDates=coverageBrokerDates(mydate);
        outMap.put(OPTIONS_CONSTANT, quoteRequestCoverageEffectiveDates);
    }
    
    /*****************This logic displays Coverage effective dates for brokers****************/
    public List<Map<String, String>> coverageBrokerDates(date mydate){
        List<Map<String, String>> requestCoverageEffectiveDates = new List<Map<String,String>>();
        try{
            Id profileId=userinfo.getProfileId();
            String myProflieName=[Select Id,Name from Profile where Id=:profileId LIMIT 1].Name;
            Map<String, String> tempMap = new Map<String, String>();    
            integer con =mydate.day()>15?2:1;
            integer con1 =1;
            if(myProflieName == PROFILENAME || myProflieName == PROFILENAME1){
                List<Requested_Eff_Date__mdt> rqefdate=ARV_AP07_QueryDataHelper.getsObjects(METADATA_QRY,METADATA_WHERE,NULL,NULL);        
                Date ratedate=  rqefdate[0].End_Date__c;
                Date ratedate1=  rqefdate[0].Start_Date__c;
                integer diffmon=math.abs(ratedate.monthsBetween(mydate));
                integer diffmon1=math.abs(ratedate.monthsBetween(ratedate1));
                if(ratedate > mydate){
                    for (integer i=con;i<=diffmon;i++){
                        datetime nexmonth =mydate.addmonths(i).toStartOfMonth();
                        String formatted = nexmonth.formatGMT(DATEFORMAT);
                        tempMap = new Map<String, String>();
                        tempMap.put(NAME_CONSTANT, formatted);
                        tempMap.put(VALUE_CONSTANT, formatted);                
                        requestCoverageEffectiveDates.add(tempMap); 
                    }
                }
                else if(ratedate < mydate){
                    for (integer i=con1;i<=diffmon1;i++){
                        datetime premonth =ratedate1.addmonths(i).toStartOfMonth();
                        String formatted = premonth.formatGMT(DATEFORMAT);
                        tempMap = new Map<String, String>();
                        tempMap.put(NAME_CONSTANT, formatted);
                        tempMap.put(VALUE_CONSTANT, formatted);                
                        requestCoverageEffectiveDates.add(tempMap);
                        system.debug('tempMap elseif'+requestCoverageEffectiveDates);
                    }
                } else{}
            }
            else if(myProflieName <> PROFILENAME || myProflieName <> PROFILENAME1){
                for (integer i=con;i<12+con;i++){
                    datetime nexmonth =mydate.addmonths(i).toStartOfMonth();
                    String formatted = nexmonth.formatGMT(DATEFORMAT);
                    tempMap = new Map<String, String>();
                    tempMap.put(NAME_CONSTANT, formatted);
                    tempMap.put(VALUE_CONSTANT, formatted);                
                    requestCoverageEffectiveDates.add(tempMap); 
                    system.debug('tempMap'+requestCoverageEffectiveDates);
                }
            } else{}
        }
        catch(Exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME);
                           throw new AuraHandledException(e.getMessage());}
        return requestCoverageEffectiveDates;
    }
        /************************************************************************************
Method Name : fetchUser
Description : This method for getting user Information to pass to Aura ARV_LTNG_Internal_User_Actions_Container
************************************************************************************/ 
    @AuraEnabled(cacheable=true)
    public static User fetchUser(){
       User usr = [select id,Name,Profile.Name from User where id =: userInfo.getUserId()];
        return usr;
    }
        
    /************************************************************************************
Method Name : getcustomMetadataId used in ARV_LTNG_41_Requested_Effective_Date_Button
Description : This method for getting quarter start and end dates from metadata
************************************************************************************/ 
    /**
@Description: getcustomMetadataId() method
@Name : get quarter start and end dates
@Param : N/A
@Return : String
@throws Exception : N/A;
*/ 
    @AuraEnabled(cacheable=true)
    public static String getcustomMetadataId() {
        try{
            String metadat = [SELECT Id,MasterLabel, Available_for_Agent__c,End_Date__c,Start_Date__c
                              FROM Requested_Eff_Date__mdt where MasterLabel=: LABELNAME AND Available_for_Agent__c =true LIMIT 1].ID;
            return metadat;
        }catch(Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
        
        
    }
    
    /************************************************************************************
Method Name : getRequestCoverageBrokerDatesGwc 
Description : used in Omniscript to get requested effective date
************************************************************************************/ 
 public  void getRequestCoverageBrokerDatesGwc(Map<String,object> inputMap,Map<String,object> outMap,Map<String,object> options){  
       
         QUOTEID=String.valueof(inputMap.get(CONTEXTID));
     system.debug('CONTEXTID::'+QUOTEID);
       String urlVal = URL.getCurrentRequestUrl().toExternalForm();
        date mydate = system.today();
        List<Map<String, String>> quoteRequestCoverageEffectiveDates = new List<Map<String,String>>(); 
        quoteRequestCoverageEffectiveDates=coverageBrokerDatesGwc(mydate);
        outMap.put(OPTIONS_CONSTANT, quoteRequestCoverageEffectiveDates);
      system.debug('outMap::'+outMap);
      system.debug('quoteRequestCoverageEffectiveDates::'+quoteRequestCoverageEffectiveDates);
    }
    
    /*****************This logic displays Coverage effective dates for brokers****************/
    public List<Map<String, String>> coverageBrokerDatesGwc(date mydate){
        List<Map<String, String>> requestCoverageEffectiveDatesgwc = new List<Map<String,String>>();
        try{
            Id profileId=userinfo.getProfileId();
            String myProflieName=[Select Id,Name from Profile where Id=:profileId LIMIT 1].Name;
            Map<String, String> tempMap = new Map<String, String>();    
            integer con =mydate.day()>15?2:1;
            integer con1 =1;
         if(myProflieName == PROFILENAME || myProflieName == PROFILENAME1 || myProflieName == PROFILENAME2 ){
                System.debug('Profiles'+PROFILENAME+', pf2'+PROFILENAME1);
                List<Requested_Eff_Date__mdt> rqefdate=ARV_AP07_QueryDataHelper.getsObjects(METADATA_QRY,METADATA_WHERE,NULL,NULL);
            String ACCID;
             if(QUOTEID.contains(QUOTECHARS)){
             ACCID =String.valueof([select id,accountId from Quote where id=:QUOTEID ][0].AccountId);
             }
             else if(QUOTEID.contains(ACCOUNTCHARS)){
                 ACCID =QUOTEID;
             }
            System.debug('ACCID'+ACCID); 
                Date ratedate=  rqefdate[0].End_Date__c;
                Date ratedate1=  rqefdate[0].Start_Date__c;
                System.debug('ratedate1 Line-->170'+ratedate1);
                integer diffmon=math.abs(ratedate.monthsBetween(mydate));
                integer diffmon1=math.abs(ratedate.monthsBetween(ratedate1));
                    for (integer i=0;i<=diffmon1;i++){
                        date nexmonth1 = ratedate1;
                        datetime nexmonth =ratedate1.addmonths(i).toStartOfMonth();
                        String formatted = nexmonth.formatGMT(DATEFORMAT);
                        tempMap = new Map<String, String>();
                        tempMap.put(NAME_CONSTANT, formatted);
                        tempMap.put(VALUE_CONSTANT, formatted);                
                        requestCoverageEffectiveDatesgwc.add(tempMap); 
                        
                    }
            }
           else if(myProflieName <> PROFILENAME || myProflieName <> PROFILENAME1 ||  myProflieName <> PROFILENAME2){
                for (integer i=con;i<12+con;i++){
                    datetime nexmonth =mydate.addmonths(i).toStartOfMonth();
                    String formatted = nexmonth.formatGMT(DATEFORMAT);
                    tempMap = new Map<String, String>();
                    tempMap.put(NAME_CONSTANT, formatted);
                    tempMap.put(VALUE_CONSTANT, formatted);                
                    requestCoverageEffectiveDatesgwc.add(tempMap); 
                    system.debug('tempMap'+requestCoverageEffectiveDatesgwc);
                }
            } else{}
        }
        catch(Exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME);
                           throw new AuraHandledException(e.getMessage());}
        return requestCoverageEffectiveDatesgwc;
    }
    
}