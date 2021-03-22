/*******************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_Opp_QuoteStartDate 
@CreatedDate: 05-Feb 2020 
@Description: ASC_Opp_QuoteStartDate class is for creating and updating the Contract Quoting Date on Opportunity whenever Account ASC Lead time and Renewal month is changed.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class ASC_Opp_QuoteStartDate {
    private static Map<String, Integer> monthsMap = new Map<String, Integer>{'January'=>1,'February' =>2,'March'=>3,'April' =>4,
        'May'=>5,'June' =>6,'July'=>7,'August' =>8,
        'September'=>9,'October' =>10,'November' =>11,
        'December' =>12};
    public static final string CLSNAME  ='ASC_Opp_QuoteStartDate';
    public static final string METHODRENEWALCYCLESTARTDATE  ='renewalCycleStartDate'; 
    public static final string METHODOPPRENEWALCYCLESTARTDATE ='oppRenewalCycleStartDate'; 
    public static final integer STR_DAYONE=01;
    public static final Id OPPRENEWALRECORDTYPEID = 
    Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity - Renewals').getRecordTypeId();
    
    public static final Integer QUOTINGDAYS = Integer.valueOf(System.Label.ASC_Quoting_Days);
    public static final String NOT_APPLICABLE = 'NA';
    
/*******************************************************************************************************************************
@Description  :   RenewalCycleStartDate 
@Name         :   RenewalCycleStartDate
@Param        :   list<Account> accList, map<id,Account> accoldMap
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/                                                                                     
    public static void renewalCycleStartDate(list<Account> accList, map<id,Account> accoldMap){
    try{
            Set<id> accIds = new Set<id>();
            if(accList !=null){
                for(Account acc : accList){
                    if(accoldMap !=null){
                        if ((acc.ASC_Contract_Renewal_Month__c != accoldMap.get(acc.id).ASC_Contract_Renewal_Month__c) ||
                            (acc.Contract_Lead_Time__c != accoldMap.get(acc.id).Contract_Lead_Time__c)){
                                accIds.add(acc.Id);
                            }
                    }
                }
                List<Opportunity> updtOppList = new List<Opportunity>();
                Map<ID,List<Opportunity>> oppDetailMap = new Map<ID,List<Opportunity>>();
                if(!accIds.isEmpty()){
                    For(Account acc :[SELECT id,(SELECT id,Name FROM Opportunities where 
                                                 RecordTypeId = :OPPRENEWALRECORDTYPEID Limit: UTIL_SLB.retrieveQueryLimitValue())
                                                 FROM Account where ID in :accIds Limit: UTIL_SLB.retrieveQueryLimitValue()]){
                                                 oppDetailMap.put(acc.Id,acc.Opportunities);
                                      }
                }
                date currentDate = Date.today();
                Integer currentMonth = currentDate.month();
                Integer ascLeadTime = 0;
                Integer ascRenewalMonth = 0;
                Date oppRenewalCycleStartDate;
                for(Account acc : accList){
                    if(acc.Contract_Lead_Time__c !=null)
                    {
                        ascLeadTime = Integer.valueOf(acc.Contract_Lead_Time__c);
                    }
                    if(acc.ASC_Contract_Renewal_Month__c != null && !NOT_APPLICABLE.equals(acc.ASC_Contract_Renewal_Month__c)
                    && String.isNotBlank(acc.ASC_Contract_Renewal_Month__c))                    
                    {
                        ascRenewalMonth = convertMonthTextToNumber(acc.ASC_Contract_Renewal_Month__c);
                        if(ascRenewalMonth > currentMonth){ 
                            oppRenewalCycleStartDate = date.newInstance(currentDate.year(), ascRenewalMonth, STR_DAYONE);
                        } else {
                            oppRenewalCycleStartDate = date.newInstance(currentDate.year()+STR_DAYONE, ascRenewalMonth, STR_DAYONE);
                        }
                        oppRenewalCycleStartDate = oppRenewalCycleStartDate.addDays(-(ascLeadTime+quotingDays));     
                    }                    
                    if(oppDetailMap.get(acc.Id) != null){
                        List<Opportunity> opplst = oppDetailMap.get(acc.Id); 
                        for(Opportunity opp: opplst){
                            if(acc.ASC_Contract_Renewal_Month__c != null && !NOT_APPLICABLE.equals(acc.ASC_Contract_Renewal_Month__c)
                            && String.isNotBlank(acc.ASC_Contract_Renewal_Month__c))
                            {
                                opp.ASC_Contract_Quoting_Date__c = oppRenewalCycleStartDate;                                   
                            }else
                            {
                                opp.ASC_Contract_Quoting_Date__c = null;
                            }
                            updtOppList.add(opp); 
                        }
                    }
                }
                if(updtOppList!=null&&updtOppList.size()>0){
                    database.update(updtOppList);
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODRENEWALCYCLESTARTDATE);
        }
    }
    
/*******************************************************************************************************************************
@Description  :   oppRenewalCycleStartDate 
@Name         :   oppRenewalCycleStartDate
@Param        :   list<Opportunity> oppList
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/                                                                                 
    public static void oppRenewalCycleStartDate(list<Opportunity> oppList){
        try{
            Set<id> accIds = new Set<id>();
            List<Account> acclist = new List<Account>();
            if (oppList != null){
                for(Opportunity opp : oppList){
                    if(opp.RecordTypeID == oppRenewalRecordTypeId){
                        accIds.add(opp.accountID);
                    }
                }
            }
            if (accIds != null){
                accList = new List<Account>([select Id,Contract_Lead_Time__c,ASC_Contract_Renewal_Month__c 
                                             from account 
                                             where Id in :accIds Limit: UTIL_SLB.retrieveQueryLimitValue()]);
            }
            date currentDate = Date.today();
            Integer currentMonth = currentDate.month();
            List<Opportunity> insrtOppList = new List<Opportunity>();
            Integer ascLeadTime = 0;
            Integer ascRenewalMonth = 0;
            Date oppRenewalCycleStartDate = null;
            if(accList != null){
                for(Account acc: acclist){
                    if(acc.Contract_Lead_Time__c !=null)
                    {
                        ascLeadTime = Integer.valueOf(acc.Contract_Lead_Time__c);
                    }
                    if(acc.ASC_Contract_Renewal_Month__c != null && !NOT_APPLICABLE.equals(acc.ASC_Contract_Renewal_Month__c)
                    && String.isNotBlank(acc.ASC_Contract_Renewal_Month__c))
                    {
                        ascRenewalMonth = convertMonthTextToNumber(acc.ASC_Contract_Renewal_Month__c);
                        if(ascRenewalMonth > currentMonth){ 
                            oppRenewalCycleStartDate = date.newInstance(currentDate.year(), ascRenewalMonth, STR_DAYONE);
                        } else {
                            oppRenewalCycleStartDate = date.newInstance(currentDate.year()+STR_DAYONE,ascRenewalMonth, STR_DAYONE);
                        }
                        oppRenewalCycleStartDate = oppRenewalCycleStartDate.addDays(-(ascLeadTime+QUOTINGDAYS));
                    }  
                    for(Opportunity opp : oppList){
                        if(opp.AccountId == acc.ID){
                         if(acc.ASC_Contract_Renewal_Month__c != null && !NOT_APPLICABLE.equals(acc.ASC_Contract_Renewal_Month__c)
                         && String.isNotBlank(acc.ASC_Contract_Renewal_Month__c))
                         {
                              opp.ASC_Contract_Quoting_Date__c =oppRenewalCycleStartDate;
                         }}                       
                    }
                }
            }
            
            system.debug('oppList-----trigger----'+oppList);
        }     
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODOPPRENEWALCYCLESTARTDATE);
        }
    }
/*******************************************************************************************************************************
@Description  :   This method is used to provide individual month result into number i.e.,if it is January then 1 will return etc..
@Name         :   convertMonthTextToNumber
@Param        :   String
@Return       :   Integer
@throws Exception   :   N/A;
*******************************************************************************************************************************/                                                                                 
    private static Integer convertMonthTextToNumber(String month){
           return monthsMap.get( month );
    }
}