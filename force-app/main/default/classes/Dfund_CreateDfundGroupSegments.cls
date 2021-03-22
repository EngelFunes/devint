/********************************************************************************************************************************************
@Author : Dinesh P
@Name: Dfund_CreateDfundGroupSegments
@CreatedDate:  05-Jan-2021
@Description: This class is used to Add the group Segments in the Dfund Group Segments object by using Allocate Group Segments button on Dfund Request Detail record.
@version : 1.0  
@US Number: US-4296
*******************************************************************************************************************************************/
public class Dfund_CreateDfundGroupSegments {
    private static final string CLSNAME = 'Dfund_CreateDfundGroupSegments';
    private static final string METHODNME_GETGSWRAPPER = 'fetchGSWrapper';
    private static final string METHODNME_UPDTGSRECORDS = 'updateGSrecords';
    public static Boolean isDfundGrpSegDeleted = false;
    private static final string ACTIVE = 'Active';
     private static final string ERRORMSG ='Please ensure all selected Group Segments have an Allocated Amount of at least 0.';
    private static final string ERRORMSG1 ='Please ensure the Total Adjustment Amount equals the sum of the selected Group Segment Allocated Amounts.';
    /********************************************************************************************************************
    @Description        :   This method is used to fetch the Group Segments from the Dfund Request - account record.
    @Name               :   fetchGSWrapper
    @Param              :   String rId
    @Return             :   List<gsListWrapper>
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/                        
    @AuraEnabled 
    public static List<gsListWrapper> fetchGSWrapper(String rId){     
        
        Dfund_Request_Detail__c dReqDetail = [Select id,Dfund_Request__r.Account__c,Total_Adjustment_Amount__c from Dfund_Request_Detail__c        
        where id =:rId LIMIT 1];            
                
        List<GA_Group_Segment__c> gsRecordsList = new List<GA_Group_Segment__c>();
        Set<Id> availGSIDSet = new Set<Id>();
        Map<Id,String> availGSIDMap = new Map<Id,String>();  
        decimal tempSum = 0.00;
        decimal remainingAmt = 0.00;
                 
        gsRecordsList = [SELECT Id,Name,Network__c,GA_Rating_Type__c from GA_Group_Segment__c 
        where GA_Account__c =: dReqDetail.Dfund_Request__r.Account__c 
        AND Status__c =: ACTIVE
        LIMIT :UTIL_SLB.retrieveQueryLimitValue()];   

        for(Dfund_Group_Segment__c gs:[Select Group_Segment__c,Allocated_Amount__c from Dfund_Group_Segment__c 
                                       where Dfund_Request_Detail__c =:rId]){
                                           
           availGSIDMap.put(gs.Group_Segment__c,String.ValueOf(gs.Allocated_Amount__c));
            tempSum += gs.Allocated_Amount__c;
        }    
        
        remainingAmt = dReqDetail.Total_Adjustment_Amount__c - tempSum;
            
        List<gsListWrapper> lstgsListWrapper = new List<gsListWrapper>();
        // query GS records and create 'GSListWrapper' class instance for each record. 
        for(GA_Group_Segment__c acc : gsRecordsList){
        
                  gsWrapRecord wrapRec = new gsWrapRecord();
                  wrapRec.name = acc.Name;
                  wrapRec.Id = acc.Id;
                  wrapRec.groupSegType = acc.Network__c;
                  wrapRec.ratingType = acc.GA_Rating_Type__c;
                                                     if(availGSIDMap.ContainsKey(acc.Id)){
                                     wrapRec.flatAmt = availGSIDMap.get(acc.Id);
                  wrapRec.isChecked = true;
                  }
                  else{
                  wrapRec.flatAmt = null;
                  wrapRec.isChecked = false;
                  }
                                                  
                  //by default checkbox should be false         
                  lstgsListWrapper.add(new gsListWrapper(false,acc,acc.Id,wrapRec,dReqDetail.Total_Adjustment_Amount__c,remainingAmt));
           } 
        //return the 'lstgsListWrapper' list 
        return lstgsListWrapper; 
    }

    /********************************************************************************************************************
    @Description        :   This wrapper class is used in fetchGSWrapper method to return data to the Allocate Group Segements Component
    @Name               :   gsListWrapper
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/                            
    public class gsListWrapper {
        @AuraEnabled public boolean isChecked {get;set;}
        @AuraEnabled public  GA_Group_Segment__c objAccount{get;set;}        
        @AuraEnabled public Id Id{get;set;}
        @AuraEnabled public  Decimal d{get;set;}        
        @AuraEnabled public gsWrapRecord wrapRec {get;set;}
        @AuraEnabled public Decimal totalAdjamount {get;set;}
        @AuraEnabled public Decimal remainingAmt {get;set;}
        
        public gsListWrapper(boolean isChecked, GA_Group_Segment__c objAccount,Id Id,gsWrapRecord wrapRec,Decimal totalAdjamount,Decimal remainingAmt){
            this.isChecked = isChecked;
            this.objAccount = objAccount;
            this.Id = Id;
            this.wrapRec = wrapRec;
            this.totalAdjamount = totalAdjamount;            
            this.remainingAmt = remainingAmt;
        }                
    }

   /********************************************************************************************************************
    @Description        :   This wrapper class is used in fetchGSWrapper method.
    @Name               :   gsWrapRecord
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/ 
       public class gsWrapRecord{  
       @AuraEnabled public String name {get; set;}  
       @AuraEnabled public Id Id {get; set;}  
       @AuraEnabled public String flatAmt {get; set;}   
       @AuraEnabled public Boolean isChecked {get; set;}   
       @AuraEnabled public String groupSegType {get; set;}   
       @AuraEnabled public String ratingType {get; set;}   
              
    }
    
    /*******************************************************************************************************************************
    @Description        :   This method is used to Create/Update Dfund Group Segments records
    @Name               :   updateGSrecords
    @Param              :   String selrecords,String rId
    @Return             :   ErrorWrapper
    @throws Exception   :   Aura Exception;    
    ********************************************************************************************************************************/                        
    @AuraEnabled
    public static ErrorWrapper updateGSrecords(String selrecords,String rId){
                      ErrorWrapper errWrap = new ErrorWrapper();
        String res = '';
        Map<String,Id> existingUniqueKeySet =new Map<String,Id>();
        List<Object> objList = new List<Object>();
        List<WrapperSelectedRecords> selrecList = new List<WrapperSelectedRecords>();
        selrecList = (List<WrapperSelectedRecords>)JSON.deserialize(selrecords, List<WrapperSelectedRecords>.class);
     
        Dfund_Request_Detail__c dReqDetail = [Select id,Name,Dfund_Request__r.Account__c,Total_Adjustment_Amount__c,DfundRequestStatus__c from Dfund_Request_Detail__c        
        where id =:rId LIMIT 1];
      
        decimal tempSum = 0.00;
        decimal remainingAmt = 0.00;
        
        try{
        
        Map<String, String> selrecMap = new Map<String, String>();
        
        if(!selrecList.isEmpty()){
          for(WrapperSelectedRecords result:selrecList){
            selrecMap.put(result.Id,result.flatAmt);
          }                
        }
        
        List<Dfund_Group_Segment__c> recordsToDelete = new List<Dfund_Group_Segment__c>();
        for(Dfund_Group_Segment__c gs:[Select Group_Segment__c,Allocated_Amount__c from Dfund_Group_Segment__c where Dfund_Request_Detail__c=:rId]){
           
           if(selrecMap.ContainsKey(gs.Group_Segment__c)){
            existingUniqueKeySet.put(gs.Group_Segment__c,gs.Id);
           }
           else{
            recordsToDelete.add(gs);
           }
        }    
        
        List<Dfund_Group_Segment__c> resultList = new List<Dfund_Group_Segment__c>();           
        List<Dfund_Group_Segment__c> errorList = new List<Dfund_Group_Segment__c>();                  
        
        for(WrapperSelectedRecords result:selrecList){
                                    
            Dfund_Group_Segment__c gs = new Dfund_Group_Segment__c();
                                      
            if(result.flatAmt !=null && !''.equals(String.ValueOf(result.flatAmt))){           
               gs = new Dfund_Group_Segment__c();
               gs.Id = existingUniqueKeySet.get(result.Id);
               gs.Name = dReqDetail.Name +'-'+ result.name;
               gs.Group_Segment__c = result.Id;           
               gs.Allocated_Amount__c = Decimal.ValueOf(result.flatAmt);          
               gs.Dfund_Request_Detail__c = rId;    
               tempSum += Decimal.ValueOf(result.flatAmt);                                                        
               resultList.add(gs);          
            }
            else if(result.flatAmt == null || ''.equals(String.ValueOf(result.flatAmt))){
               gs = new Dfund_Group_Segment__c();
               gs.Id = existingUniqueKeySet.get(result.Id); 
               errorList.add(gs);
            }                        
         }   
         
         remainingAmt = dReqDetail.Total_Adjustment_Amount__c - tempSum;                
            
            if(!'New'.equals(dReqDetail.DfundRequestStatus__c) && !'Draft'.equals(dReqDetail.DfundRequestStatus__c) && !'Rejected'.equals(dReqDetail.DfundRequestStatus__c)){
              errWrap.error = 'Group segment cannot be edited';
            }
            else{
                         
            if(!errorList.isEmpty()){             
              errWrap.error =ERRORMSG;
              errWrap.remainingAmt = remainingAmt;
              errWrap.rId = null;
            }                                
            else if(!resultList.isEmpty() && remainingAmt == 0){
              upsert resultList;
              errWrap.rId = rId;
            }
            else if(remainingAmt != 0){
              errWrap.error = ERRORMSG1;
              errWrap.remainingAmt = remainingAmt;
              errWrap.rId = null;
            }
                        
            if(!recordsToDelete.isEmpty() && remainingAmt == 0){
              isDfundGrpSegDeleted = true;
              Delete recordsToDelete;
              errWrap.rId = rId;              
              errWrap.error = null;
            }                
            
            //Delete all records
            if(resultList.isEmpty() && !recordsToDelete.isEmpty() && remainingAmt == dReqDetail.Total_Adjustment_Amount__c){
              isDfundGrpSegDeleted = true;
              Delete recordsToDelete;
              errWrap.rId = rId;    
            }
            } 
        }        
        catch(Exception ex) {
            GA_LogExceptionCls.LogExcp(ex, CLSNAME, METHODNME_UPDTGSRECORDS);
            throw new AuraHandledException(ex.getMessage());
        }
        return errWrap;        
    }
 
 
   /********************************************************************************************************************
    @Description        :   This wrapper class is used for preselection of the GS records avilable in the Dfund Group Segment object
    @Name               :   WrapperSelectedRecords
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/    
    public class WrapperSelectedRecords {
        
        @AuraEnabled public String flatAmt;
        @AuraEnabled public String Id;
        @AuraEnabled public Boolean isChecked;
        @AuraEnabled public String name;            
    }       
 /********************************************************************************************************************
    @Description        :   ErrorWrapper response to aura
    @Name               :   ErrorWrapper
    @throws Exception   :     
     Errors:   
    -Please ensure all selected Group Segments have an Allocated Amount of at least 0.
    -Please ensure the Total Adjustment Amount equals the sum of the selected Group Segment Allocated Amounts.
    ********************************************************************************************************************************/    
      public class ErrorWrapper {
        
        @AuraEnabled public Decimal remainingAmt;
        @AuraEnabled public String error;    
        @AuraEnabled public Id rId;    
    }       
}