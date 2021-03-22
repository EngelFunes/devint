/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AORSrvcDateRangeChk 
@CreatedDate: 26 - September 2019 
@Description: GA_AORSrvcDateRangeChk class for AOR clone/update.
@version : 1.0  
********************************************************************************************************************************/

public class GA_AORSrvcDateRangeChk {
    
    public static final String CLSNAM  = 'GA_AORSrvcDateRangeChk';
    public static final String METHODNAME  = 'checkServiceDateRange' ;
    public static Boolean isExecuting = false;
    public static final String SRVCENDDT  ='GA_Service_End_Date__c';
    public static final String SRVCSTARTDT  ='GA_Service_Start_Date__c';
    public static final String AORDATEERRLABEL = system.label.GA_AORSrvDateChkError;
    
    /*******************************************************************************************************************************
@Description    :  checkServiceDateRange 
@Name         :   checkServiceDateRange
@Param         :  list<GA_AOR__c> aorLst,map<Id,GA_AOR__c> aorOldMap
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void checkServiceDateRange(list<GA_AOR__c> aorLst,map<Id,GA_AOR__c> aorOldMap){
        try{
             for(GA_AOR__c aor : aorLst){               
                if(aorOldMap<> null){
                    if((aor.GA_Service_End_Date__c <> aorOldMap.get(aor.id).get(SRVCENDDT))||(aor.GA_Service_Start_Date__c <> aorOldMap.get(aor.id).get(SRVCSTARTDT)))
                    {
                        String accountId=aor.GA_Account_Id__c;
                        if(accountId != null && aor.GA_Service_End_Date__c !=null)
                        {
                            Set<Id> grpSegmentIds = getGSAssociatedwithAOR(aor.Id);
                            if(grpSegmentIds != null && grpSegmentIds.size()>0)
                            {
                            boolean isOverlap = queryAORAssociatedWithAccount(accountId, aor.GA_Service_End_Date__c,aor.Id,aor.GA_Service_Start_Date__c,grpSegmentIds);
                            if(isOverlap)                                
                            {
                                aor.addError(AORDATEERRLABEL);
                            }
                            else
                            {
                                //Update Processed flag in AOR associated AORGS Records
                                GA_AORGS_RestrictDuplicateAORGS.restrictDuplicateRule = true; 
                                String aorId= aor.Id;
                                List<GA_AOR_Group_Segment__c> aorGsLst=  [Select id,name,GA_Is_EndDateProcessed__c,GA_Is_StartDateProcessed__c from GA_AOR_Group_Segment__c where GA_AOR_Id__c =:aorId];
                                List<GA_AOR_Group_Segment__c> aorGsLstToUpdate = new List<GA_AOR_Group_Segment__c>();
                                if(aorGsLst.size() > 0){ 
                                    for(GA_AOR_Group_Segment__c aorGs :aorGsLst){         
                                        aorGs.GA_Is_StartDateProcessed__c=false; 
                                        aorGsLstToUpdate.add(aorGs);
                                    } 
                                    database.update(aorGsLstToUpdate,false);
                                }    
                            }
                           }                                                      
                        }
                    }
                }
                 else
                 {
                      String accountId=aor.GA_Account_Id__c;
                        if(accountId != null && aor.GA_Service_End_Date__c !=null)
                        {
                            Set<Id> grpSegmentIds = getGSAssociatedwithAOR(aor.Id);
                            if(grpSegmentIds != null && grpSegmentIds.size()>0)
                            {
                            boolean isOverlap = queryAORAssociatedWithAccount(accountId, aor.GA_Service_End_Date__c,aor.Id,aor.GA_Service_Start_Date__c,grpSegmentIds);
                            if(isOverlap)                                
                            {
                                aor.addError(AORDATEERRLABEL);
                            }
                            }                           
                        }
                 }
            }        
        }
        catch(Exception excpDtls){
            GA_LogExceptionCls.LogExcp(excpDtls, CLSNAM, METHODNAME);
        }        
    }
    /*******************************************************************************************************************************
@Description    :  queryAORAssociatedWithAccount 
@Name         :   queryAORAssociatedWithAccount
@Param         :  String accountId,Date newsrvEndDate,String aorId,Date newsrvStartDate
@Return       :   boolean isOverlap
@throws Exception   :   N/A;
********************************************************************************************************************************/     
 
     public static boolean queryAORAssociatedWithAccount(String accountId,Date newsrvEndDate,String aorId,Date newsrvStartDate,Set<Id> grpSegmentIds)
     {
         boolean isOverlap = false;
         list<GA_AOR__c> aorLst = [Select Id,Name,GA_Service_End_Date__c,GA_Service_Start_Date__c from GA_AOR__c where GA_Account_Id__c =:accountId limit 5000];
         if(aorLst != null && aorLst.size()>0)
         {
              for(GA_AOR__c eachAOR : aorLst)
              {
                  Date aorStartDate = eachAOR.GA_Service_Start_Date__c;
                  Date aorEndDate = eachAOR.GA_Service_End_Date__c;
                  if(eachAOR.Id != aorId)
                  {
                      if(newsrvStartDate <= aorEndDate && newsrvEndDate >= aorStartDate)
                      {
                          Set<Id> existingGrpSegmentIds = getGSAssociatedwithAOR(eachAOR.Id);                     
                          boolean gsExists = checkIfSameGSRecordExists(grpSegmentIds,existingGrpSegmentIds);
                          system.debug('existingGrpSegmentIds '+existingGrpSegmentIds);
                          system.debug('newgrpSegmentIds '+grpSegmentIds);
                          system.debug('gsExists '+gsExists);
                          if(gsExists)
                          {
                              isOverlap = true;
                          }                          
                      }                      
                  }
              }
         } 
         return isOverlap;
     }
    
    
      public static Set<Id> getGSAssociatedwithAOR(String aorId)
      {
          Set<Id> grpSegmentIds = New Set<Id>();
          list<GA_AOR_Group_Segment__c> aorGsLst = [Select Id,GA_Group_Segment_Id__c,GA_AOR_Id__c from GA_AOR_Group_Segment__c where GA_AOR_Id__c =:aorId limit 5000];
          if(aorGsLst != null && aorGsLst.size()>0)
          {
              for(GA_AOR_Group_Segment__c eachAORGs : aorGsLst)
              {
                  String gsId= eachAORGs.GA_Group_Segment_Id__c;
                  grpSegmentIds.add(gsId);
              }
          }
          return grpSegmentIds;
      }
    
     public static boolean checkIfSameGSRecordExists( Set<Id> newGrpSegmentIds,Set<Id> oldGrpSegmentIds)
     {
         boolean gsExists = false;
         for(Id gsId : newGrpSegmentIds){
             if(oldGrpSegmentIds!=null && oldGrpSegmentIds.contains(gsId) ){
                 gsExists = true;                 
             }
         }
         return gsExists;
     }
}