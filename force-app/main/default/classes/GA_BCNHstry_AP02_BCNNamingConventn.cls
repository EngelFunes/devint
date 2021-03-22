/**
@Author : IDC Offshore
@Name: GA_BCNHstry_AP02_BCNNamingConventn
@CreatedDate: 8 - June 2018 
@Description: GA_BCNHstry_AP02_BCNNamingConventn class is for BCN history Naming Convention
@version : 1.0  
*/ 
public without sharing  class GA_BCNHstry_AP02_BCNNamingConventn {
    public static final string CLSNAME  ='GA_BCNHstry_AP02_BCNNamingConventn';
    public static final string METHODNME  ='updateBCNHistoryRecordName';   
    public static final string CURRENTYEAR  = '/01/'+System.Today().year();
    public static final string NEXTYEAR = '/01/'+(System.Today().year()+1);
    public static final string MNTHSTR ='_0';
    public static final string UNDRSCR ='_';
  /**
@Description: updateBCNHistoryRecordName() method 
@Name : updateBCNHistoryRecordName
@Param : list<GA_Plan_Year_Exception_History__c> planHistoryList 
@Return : void
@throws Exception : N/A;
*/      
    public static void updateBCNHistoryRecordName(list<GA_Plan_Year_Exception_History__c> planHistoryList)
    {
        try
        {   
            Set<id> grpSegmIds = new Set<id>();
            
            for(GA_Plan_Year_Exception_History__c eachBcnHistRec:planHistoryList){
                if(eachBcnHistRec <> null){
                      grpSegmIds.add(eachBcnHistRec.GA_Group_Segment__c);
                }              
            }   
            
            Map<ID,String> codeMap = new Map<ID,String>();
            Map<ID,GA_Group_Segment__c> salesNameMap = new Map<ID,GA_Group_Segment__c>();            
            if(!grpSegmIds.isEmpty()){
                salesNameMap = new Map<ID,GA_Group_Segment__c>([Select Id, Name from GA_Group_Segment__c 
                                                                where Id in :grpSegmIds Limit 200]);
                for(GA_Group_Segment__c sno: salesNameMap.values()){
                    codeMap.put(sno.Id,sno.name);
                }              
            }
            
            list<GA_Plan_Year_Exception_History__c> bcnHisListToUpt=new list<GA_Plan_Year_Exception_History__c>();    
            date currentDate = Date.today();
            for(GA_Plan_Year_Exception_History__c eachBcnHistRec:planHistoryList)
            {
                if(eachBcnHistRec.GA_Plan_Year_Month__c !=null || eachBcnHistRec.GA_Plan_Year_Month__c !=null)
                {
                    Integer currentMonth =  currentDate.month();
                    Integer bcnPlanYearMonth = Integer.valueOf(eachBcnHistRec.GA_Plan_Year_Month__c);
                    String groupSegmentName = codeMap.get(eachBcnHistRec.GA_Group_Segment__c);
                    if(bcnPlanYearMonth>=currentMonth)
                    {   
                        String bcnPlanYrMonth = String.valueOf(bcnPlanYearMonth);
                        if(bcnPlanYearMonth.format().length()==1)
                        {
                            eachBcnHistRec.Name=groupSegmentName+MNTHSTR+bcnPlanYrMonth+CURRENTYEAR;
                        }
                        else
                        {
                            eachBcnHistRec.Name=groupSegmentName+UNDRSCR+bcnPlanYrMonth+CURRENTYEAR;
                        }                    
                        
                    }
                     if(bcnPlanYearMonth<currentMonth)
                    {
                        String bcnPlanYrMonth = String.valueOf(bcnPlanYearMonth);
                        if(bcnPlanYearMonth.format().length()==1)
                        {
                            eachBcnHistRec.Name=groupSegmentName+MNTHSTR+bcnPlanYrMonth+NEXTYEAR;
                        }
                        else
                        {
                            eachBcnHistRec.Name=groupSegmentName+UNDRSCR+bcnPlanYrMonth+NEXTYEAR;
                        } 
                    }
                    
                    bcnHisListToUpt.add(eachBcnHistRec);
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    } 
}