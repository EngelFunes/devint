/*******************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_AORGS_RestrictDuplicateAORGS 
@CreatedDate: 29 - May 2019 
@Description: GA_AORGS_RestrictDuplicateAORGS class is for restricting duplicate AOR Group Segment records.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_AORGS_RestrictDuplicateAORGS {
    public Static final string CLSNAME  = 'GA_AORGS_RestrictDuplicateAORGS';
    public Static final string MTDRESTRICTDUPLCTAAORGSCRTN  = 'restrictDuplctAORGSCrtn';
    public static final string ERRORMSG='AOR Group Segment relationship already exists';
    public statiC final String FLDNM ='GA_Group_Segment_Id__c';
    public static  Boolean restrictDuplicateRule = false;
    public static final string AORGSQUERY ='Select id,GA_AOR_Id__c,GA_Group_Segment_Id__c from GA_AOR_Group_Segment__c  ';
    public static final string AORGSWHERE4= ' and GA_Is_StartDateProcessed__c = true  ';
    public static final string AORGSWHERE3=' and GA_Cancel_Flag__c = false ';
    public static final string AORGSWHERE2=' and GA_Is_EndDateProcessed__c = false ';
    public static final string AORGSWHERE1=' where GA_Group_Segment_Id__c in ';
    public static final string AORGSLIMIT=' Limit 1000';
    
    /*******************************************************************************************************************************
@Description  :  restrictDuplctAORGSCrtn 
@Name         :   restrictDuplctAORGSCrtn
@Param        :   list<GA_AOR_Group_Segment__c> aorGSLst
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 
    Public static void restrictDuplctAORGSCrtn(list<GA_AOR_Group_Segment__c> aorGSLst,Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap)  
    {
        try
        {
            Map<Id,String> aorGSMap =  New Map<Id,String>();
            Map<Id,String> existingAorGSMap =  New Map<Id,String>();
            Set<Id> gsIds = New Set<Id>();
            Set<Id> gsexistingIds = New Set<Id>();
            Map<Id,GA_AOR_Group_Segment__c>  aorGSValMap = New Map<Id,GA_AOR_Group_Segment__c>();
            
            for(GA_AOR_Group_Segment__c aorGS : aorGSLst)
            {
                if( ((aorGSoldmap == null ) || (aorGSoldmap <> null && ( aorGSoldmap.get(aorGS.id).get(FLDNM ) <>  aorGS.GA_Group_Segment_Id__c))) 
                   && aorGS.GA_Service_Start_Date__c <> null )
                {
                    String aorGSId =  aorGS.GA_Group_Segment_Id__c ;
                    if(!String.isEmpty(aorGSId)){
                        gsIds.add(aorGS.GA_Group_Segment_Id__c);
                    
                    }
                }
            }
            
            String gsIdSet  = GA_Util08_FilterProcessHelper.idSet(gsIds);
            if(gsIdSet <> null && gsIdSet.length()> 0 && !restrictDuplicateRule){
                aorGSValMap = GA_Util24_AORGSDataAccesHelper.fetchAORGSMap(AORGSQUERY, AORGSWHERE1+gsIdSet+AORGSWHERE2+AORGSWHERE3+AORGSWHERE4, AORGSLIMIT);
                for(GA_AOR_Group_Segment__c existingAORgs : aorGSValMap.values() )
                {
                    existingAorGSMap.put(existingAORgs.GA_Group_Segment_Id__c,existingAORgs.GA_AOR_Id__c);
                    
                }
            }
            if(!existingAorGSMap.isEmpty()){
                GA_AORGS_RestrictDuplicateAORGS.restrictDuplicateRule = true;
                for(Id gsId : existingAorGSMap.keyset()){
                    if(gsIds.contains(gsId)){
                        gsexistingIds.add(gsId);
                    }
                }
                
                for(GA_AOR_Group_Segment__c aorGS : aorGSLst)
                {
                    if(gsexistingIds.contains(aorGS.GA_Group_Segment_Id__c)){
                        aorGS.addError(ERRORMSG);
                        
                    }
                }  
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTDRESTRICTDUPLCTAAORGSCRTN);
        }
    }
}