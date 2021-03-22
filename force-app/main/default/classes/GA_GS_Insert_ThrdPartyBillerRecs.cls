/*******************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_GS_Insert_ThrdPartyBillerRecs 
@CreatedDate: 30 - May 2019 
@Description: GA_GS_Insert_ThrdPartyBillerRecs class is for inserting Third Party Biller History records on Group Segment.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_GS_Insert_ThrdPartyBillerRecs{
    Public static boolean isExecuting=false;
    Public static boolean isInvoked=false;
    Public static boolean isInvoking=false;
    public static final String CLSNAME='GA_GS_Insert_ThrdPartyBillerRecs';
    public static final String MTHDINSERTTHRDPARTYRECS='insertThrdPartyRecs';
    public static final String MTHDUPDTLINKEDTPBENDDATE='updtLinkedTPBEndDate';
    public static final String MTHDUPDTTPBDATE='updtTPBdate';
    public static Set<Id> setOldAccIds = new Set<Id>();
    public static    Set<Id> setAccIds = new Set<Id>();
    /*******************************************************************************************************************************
@Description  :   insertThrdPartyRecs 
@Name         :   insertThrdPartyRecs
@Param        :   list<GA_Group_Segment__c> gsLst,Map<Id,GA_Group_Segment__c> OldMap
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 
    public static void insertThrdPartyRecs(list<GA_Group_Segment__c> gsLst,Map<Id,GA_Group_Segment__c> OldMap){
        try{
            Set<ID> gsIds = new Set<ID>();
            Set<ID> gsaIds = new Set<ID>();
            Set<ID> tpbhIds = new Set<ID>();
            Set<ID> grpAssocIds = new Set<ID>();
            List<GA_Third_Party_Biller_History__c> lstTPBH = new List<GA_Third_Party_Biller_History__c>();
            GA_Third_Party_Biller_History__c tpbh = New GA_Third_Party_Biller_History__c();
            
            //Capturing Ids of records for Large Group GS records
            for(GA_Group_Segment__c gs : gsLst){
                gsIds.add(gs.Id);
                if(gsIds.size()>0)
                {
                    if((OldMap.get(gs.Id).GA_Association_Id__c != gs.GA_Association_Id__c) && (gs.GA_Association_Id__c != null)
                       && (gs.GA_Group_Association_id__c <> null))
                    {
                        gsaIds.add(gs.GA_Association_Id__c);
                        grpAssocIds.add(gs.GA_Group_Association_id__c);
                    }
                }
                
                if((OldMap.get(gs.Id).GA_Association_Id__c != gs.GA_Association_Id__c )
                   && gs.GA_Association_Id__c <> null && gs.GA_Group_Association_id__c <> null ){
                       setAccIds.add(gs.GA_Association_Id__c);
                       setOldAccIds.add(OldMap.get(gs.Id).GA_Association_Id__c);
                   }
            }
            
            Map<Id,GA_Group_Association__c>  grpAssociationMap = New  Map<Id,GA_Group_Association__c>([select id,GA_Start_Date__c,
                                                                                                       GA_Account__c,GA_Group_Segment__c from GA_Group_Association__c 
                                                                                                       where Id IN :grpAssocIds and GA_Account__c != null limit 5000]);
            Map<Id,Account> assocAccMap = New   Map<Id,Account>( [select id,name,GA_Third_Party_Biller_Account_Id__c from Account 
                                                                  where GA_Third_Party_Biller_Account_Id__c!=null AND Id IN :gsaIds limit 5000]);
            
            //Creating Third Party Biller History records.
            for( Id grpAssocID : grpAssociationMap.keyset()){
                if( assocAccMap.containsKey( grpAssociationMap.get(grpAssocID).GA_Account__c)){
                    tpbh = new GA_Third_Party_Biller_History__c();
                    tpbh.GA_Group_Segment_Id__c =  grpAssociationMap.get(grpAssocID).GA_Group_Segment__c;
                    tpbh.GA_Third_Party_Biller_Account__c=assocAccMap.get(grpAssociationMap.get(grpAssocID).GA_Account__c).GA_Third_Party_Biller_Account_Id__c;
                    tpbh.GA_TPB_Start_Date__c =  grpAssociationMap.get(grpAssocID).GA_Start_Date__c;
                    lstTPBH.add(tpbh); 
                }
                
            }
            
            if(!lstTPBH.isEmpty())
            {
                GA_TPBH_AP02_RestrictTPBHCreation.isExecuting = true;
                database.insert(lstTPBH);
            }
        }
        
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDINSERTTHRDPARTYRECS);
        }
    }
    /*******************************************************************************************************************************
@Description    :  updtLinkedTPBEndDate 
@Name         :   updtLinkedTPBEndDate
@Param         :   N/A
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/     
    public static void updtLinkedTPBEndDate(list<GA_Group_Segment__c> gsLst,Map<Id,GA_Group_Segment__c> OldMap){
        try{
            Set<ID> gsIds = new Set<ID>();
            Set<ID> gsaIds = new Set<ID>();
            Set<ID> grpAssocAccIds = new Set<ID>();
            Map<Id, Date> gsTpbMap = new Map<Id, Date>();
            for(GA_Group_Segment__c gs : gsLst){
                //Capturing Ids of records
                if((OldMap.get(gs.Id).GA_Association_Id__c != gs.GA_Association_Id__c))
                {
                    grpAssocAccIds.add(OldMap.get(gs.Id).GA_Association_Id__c);
                }
            }
            Map<Id,Account> accMap = new Map<Id,Account>();
            
            for(Account accObj : [SELECT GA_Third_Party_Biller_Account_Id__c FROM Account WHERE Id IN:grpAssocAccIds limit 5000]){
                accMap.put(accObj.Id,accObj);
            }
            for(GA_Group_Segment__c objGS : gsLst){
                for(Account acc:accMap.values()){
                    if(String.isNotBlank(acc.GA_Third_Party_Biller_Account_Id__c)){
                        if(objGS.GA_Association_Id__c == null && objGS.GA_Third_Party_Biller_History__c <> null && 
                           OldMap.get(objGS.Id).GA_Association_Id__c == acc.Id){
                               gsIds.add(objGS.GA_Third_Party_Biller_History__c);
                           }
                    }
                }
                if(OldMap.get(objGS.Id).GA_Group_Association_id__c != null){
                    gsaIds.add(OldMap.get(objGS.Id).GA_Group_Association_id__c);
                }                
            }
            for(GA_Group_Association__c grpAssoc : [SELECT GA_End_Date__c FROM GA_Group_Association__c
                                                    WHERE Id IN:gsaIds limit 5000]){
                                                        gsTpbMap.put(grpAssoc.Id,grpAssoc.GA_End_Date__c);
                                                    }  
            
            //Update operation on TPB History records
            if(!gsIds.isEmpty()){
                List<GA_Third_Party_Biller_History__c> lstTPBH = [select id,GA_TPB_End_Date__c from GA_Third_Party_Biller_History__c
                                                                  where Id IN :gsIds limit 5000 ];
                for(GA_Group_Association__c grpAssoc : [SELECT GA_End_Date__c FROM GA_Group_Association__c
                                                        WHERE Id IN:gsaIds limit 5000])
                {
                    for(GA_Third_Party_Biller_History__c tpbh : lstTPBH)
                    {
                        tpbh.GA_TPB_End_Date__c=gsTpbMap.get(grpAssoc.Id);
                    }
                }
                database.update(lstTPBH);
            }
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDUPDTLINKEDTPBENDDATE);
        } 
    }
    /*******************************************************************************************************************************
@Description  :   updtTPBdate 
@Name         :   updtTPBdate
@Param        :   list<GA_Group_Segment__c> gsLst,Map<Id,GA_Group_Segment__c> OldMap
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/     
    public static void updtTPBdate(list<GA_Group_Segment__c> gsLst,Map<Id,GA_Group_Segment__c> OldMap){
        try{
            Set<Id> setAccIds = new Set<Id>();
          //  Set<Id> setOldAccIds = new Set<Id>();
            Set<Id> setThirdPartyBillerIds = new Set<Id>();
            Set<ID> gsaIds = new Set<ID>();
            Map<String, Date> gsTpbMap = new Map<String, Date>();
            
            for(GA_Group_Segment__c obj : gsLst){
                if((OldMap.get(obj.Id).GA_Association_Id__c != obj.GA_Association_Id__c )
                   && obj.GA_Association_Id__c <> null && obj.GA_Group_Association_id__c <> null ){
                       setAccIds.add(obj.GA_Association_Id__c);
                       setOldAccIds.add(OldMap.get(obj.Id).GA_Association_Id__c);
                   }
            }
            
            Map<Id,Account> newValues = new Map<Id,Account>();
            Map<Id,Account> oldValues = new Map<Id,Account>();
            if(!setAccIds.isEmpty()){
                for(Account obj : [SELECT GA_Third_Party_Biller_Account_Id__c FROM Account WHERE Id IN:setAccIds limit 5000]){
                    newValues.put(obj.Id,obj);
                }  
            }
            
            if(!setOldAccIds.isEmpty()){
                for(Account obj : [SELECT GA_Third_Party_Biller_Account_Id__c FROM Account WHERE Id IN:setOldAccIds limit 5000]){
                    oldValues.put(obj.Id,obj);
                }   
            }
            
            if(newValues <> null && oldValues <> null){
                for(GA_Group_Segment__c objGS : gsLst){
                    for(Account objAcc : newValues.values()){
                        if(objGS.GA_Association_Id__c == objAcc.Id){
                            if(String.isBlank(objAcc.GA_Third_Party_Biller_Account_Id__c) &&  OldMap.get(objGS.Id).GA_Association_Id__c != null && 
                               String.isNotBlank(oldValues.get(OldMap.get(objGS.Id).GA_Association_Id__c).GA_Third_Party_Biller_Account_Id__c)){
                                   setThirdPartyBillerIds.add(objGS.GA_Third_Party_Biller_History__c);
                               }
                        }
                        
                        if(OldMap.get(objGS.Id).GA_Group_Association_id__c != null && String.isBlank(objAcc.GA_Third_Party_Biller_Account_Id__c)){
                            gsaIds.add(objGS.GA_Group_Association_id__c);
                        }                
                    }
                }
                
            }
            
            if(!gsaIds.isEmpty()){
                for(GA_Group_Association__c grpAssoc : [SELECT GA_Start_Date__c,GA_Group_Segment__c FROM GA_Group_Association__c
                                                        WHERE Id IN:gsaIds limit 5000]){
                                                            gsTpbMap.put(grpAssoc.Id+'~'+grpAssoc.GA_Group_Segment__c,grpAssoc.GA_Start_Date__c-1);
                                                        } 
            }
            
            
            List<GA_Third_Party_Biller_History__c> lstTPBH = new List<GA_Third_Party_Biller_History__c>();
            Map<Id,GA_Third_Party_Biller_History__c> tpbMapLst = New Map<Id,GA_Third_Party_Biller_History__c>();
            if(!setThirdPartyBillerIds.isEmpty()){
                
                List<GA_Third_Party_Biller_History__c> tpbList =  [SELECT GA_TPB_End_Date__c,GA_Group_Segment_Id__c FROM GA_Third_Party_Biller_History__c 
                                                                   WHERE Id IN:setThirdPartyBillerIds limit 5000];
                
                if(gsTpbMap <> null){
                    for(String grpAssocId : gsTpbMap.keyset())
                    {
                        for(GA_Third_Party_Biller_History__c obj : tpbList){
                            if(gsTpbMap.containsKey(grpAssocId.substringBefore('~') +'~'+obj.GA_Group_Segment_Id__c)){
                              obj.GA_TPB_End_Date__c = gsTpbMap.get(grpAssocId.substringBefore('~')+'~'+obj.GA_Group_Segment_Id__c);
                               tpbMapLst.put(obj.id,obj);
                                }
                        }
                    }
                    
                    if(tpbMapLst <> null){
                        database.update(tpbMapLst.values());
                    }
                    
                }
                
            }
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDUPDTTPBDATE);
        }
    }    
}