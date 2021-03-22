/**
@Author : IDC Offshore
@Name: GA_GroupSegmentSrvcCls
@CreatedDate: 1 - Jan 2019
@Description: GA_GroupSegmentSrvcCls class is for Group Segment object.
@version : 1.0  
*/
public without sharing  class GA_GroupSegmentSrvcCls {
    public static final string ACTIVESTATUS='Active';
    public static final string PENDINGSTATUS='Pending';
    public static final string BCBSM='BCBSM';
    public static final string BCN='BCN';
    public static  Boolean isExecuting =  false;
    public static string cmpltOnlyMTVFld=system.label.GA_CompleteOnlyMTVFields;
    public static string cmpltOnlyFacetsFld=system.label.GA_CompleteOnlyFacetsFields;
    public static string cmpltAllFacetsFld=system.label.GA_CompleteAllFacetsFields;
    public static string grpInfoErrMsg=system.label.GA_GS_Group_Info_Error;    
    public static final string CLSNAME='GA_GroupSegmentSrvcCls';
    public static final string METDUPDATESORUCEGRP='updateSoruceGrp';
    public static final string METDUPDATESORUCEGRPCLONE='updateSoruceGrpClone';
    public static final string CLONEVAL='_Clone';
    public static final string NULLSTRNG='';
    public static final string NONEVAL='--None--';
    public static final string UNDERSCR='_';
    
    /*******************************************************************************************************************************
@Description        :   updateSoruceGrp() method 
@Name               :   updateSoruceGrp
@Param              :   list<GA_Group_Segment__c> GrpLst
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void updateSoruceGrp(list<GA_Group_Segment__c> GrpLst)
    { 
        try
        {   
            if(GrpLst.size()==1 && !(GA_AP_ASEPRecordMatchCls.asepGrpSeg) && !(ARV_AP59_CreateGroupSegmentRecords.contrctGrpSeg))
            {
                GA_Trigger_Functionality_By_Pass__c bypssErr=GA_Trigger_Functionality_By_Pass__c.getInstance();
                if(bypssErr.GA_GS_GroupInfoValidation__c)
                {
                    GA_Group_Segment__c grp = GrpLst[0];
                    if(grp.Status__c!=null && grp.Status__c!=ACTIVESTATUS){
                       grp.Status__c=PENDINGSTATUS; 
                    }
                    String previousRecordId = grp.GA_Prevs_RecordID__c;
                    if(grp.GA_Prevs_RecordID__c !=null)
                    {
                        if(previousRecordId.contains(CLONEVAL))
                        {
                            grp.GA_Previous_Group_Segment_No__c=previousRecordId.removeEnd(CLONEVAL); 
                        }
                        else
                        {
                            grp.GA_Previous_Group_Segment_No__c=previousRecordId;
                        }                   
                        
                        grp.GA_External_ID__c = NULLSTRNG;
                        grp.GA_In_Progress_Type__c=null;
                        grp.GA_In_Progress__c=false;
                        grp.GA_Is_Processed__c=false;
                        grp.GA_Prior_CID__c=null;
                        grp.GA_SourceASG__c=false;
                        //grp.GA_Prevs_RecordID__c = previousRecordId+CLONEVAL;
                        
                    }
                    
                    if(grp.GA_Carrier__c==BCBSM)
                    {
                        if((grp.GA_Facets_Class_ID__c!=null)||(grp.GA_Facets_Group_ID__c!=null)||(grp.GA_Facets_Sub_Group_Number__c!=null))
                        {
                            grp.addError(cmpltOnlyMTVFld);
                        }
                    }
                    
                    if(grp.GA_Carrier__c==BCN)
                    {
                        if((grp.GA_MTV_Group__c!=null)||(grp.GA_MTV_Group_Division__c!=null))
                        {
                            grp.addError(cmpltOnlyFacetsFld);
                        }
                        if(grp.GA_Prevs_RecordID__c == null){
                            if((grp.GA_Facets_Class_ID__c==null)||(grp.GA_Facets_Group_ID__c==null)||(grp.GA_Facets_Sub_Group_Number__c==null))
                            {
                                grp.addError(cmpltAllFacetsFld);
                            } }
                    }
                    
                    
                    if((((grp.GA_Facets_Class_ID__c!=null) && (grp.GA_Facets_Group_ID__c!=null) &&(grp.GA_Facets_Sub_Group_Number__c!=null)) ||((grp.GA_MTV_Group__c!=null)&&(grp.GA_MTV_Group_Division__c!=null))) && (grp.GA_Carrier__c != null || grp.GA_Carrier__c !=NONEVAL)) 
                    {  
                        String facetCombination = grp.GA_Facets_Group_ID__c+UNDERSCR+grp.GA_Facets_Sub_Group_Number__c+UNDERSCR+grp.GA_Facets_Class_ID__c;
                        String mtvCombination =  grp.GA_MTV_Group__c+UNDERSCR+grp.GA_MTV_Group_Division__c;
                        List<GA_Group_Segment__c> grpExistsLst = [Select Id from GA_Group_Segment__c where GA_External_ID__c =: facetCombination  or GA_External_ID__c =: mtvCombination Limit 5000 ];
                        if(grpExistsLst.size() > 0 && !grpExistsLst.isEmpty()){
                            grp.addError(grpInfoErrMsg);
                        }
                    }                    
                }
                else{
                    
                    for(GA_Group_Segment__c grp:GrpLst)
                    {  
                        if(grp.Status__c!=null && grp.Status__c!=ACTIVESTATUS){
                       	grp.Status__c=PENDINGSTATUS; 
                   		}
                        String previousRecordId = grp.GA_Prevs_RecordID__c;
                        if(grp.GA_Prevs_RecordID__c !=null)
                        {   if(previousRecordId.contains(CLONEVAL))
                        {
                            grp.GA_Previous_Group_Segment_No__c=previousRecordId.removeEnd(CLONEVAL); 
                        }
                         else
                         {
                             grp.GA_Previous_Group_Segment_No__c=previousRecordId;
                         }                          
                         grp.GA_External_ID__c = NULLSTRNG;
                         grp.GA_In_Progress_Type__c=null;
                         grp.GA_In_Progress__c=False;
                         grp.GA_Is_Processed__c=False;
                         grp.GA_Prior_CID__c=null;
                         grp.GA_SourceASG__c=False;
                         //grp.GA_Prevs_RecordID__c = previousRecordId+CLONEVAL;
                         //grp.GA_IsFirstUpdate__c=False;
                         //grp.GA_Segment__c = grp.GA_Segment__c;
                        }
                    }
                    
                }
            }   
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METDUPDATESORUCEGRP); 
        }
    }    
    /*******************************************************************************************************************************
@Description        :   updateSoruceGrpClone() method 
@Name               :   updateSoruceGrpClone
@Param              :   list<GA_Group_Segment__c> GrpLst
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updateSoruceGrpClone(list<GA_Group_Segment__c> GrpLst)
    { 
        try
        {   
            if(GrpLst.size()==1 && !(GA_AP_ASEPRecordMatchCls.asepGrpSeg) && !(ARV_AP59_CreateGroupSegmentRecords.contrctGrpSeg))
            {
                GA_Trigger_Functionality_By_Pass__c bypssErr=GA_Trigger_Functionality_By_Pass__c.getInstance();
                if(bypssErr.GA_GS_GroupInfoValidation__c)
                {
                    GA_Group_Segment__c grp = GrpLst[0];
                    String previousRecordId = grp.GA_Prevs_RecordID__c;
                    if( !String.isEmpty(previousRecordId)){
                        if((previousRecordId.contains(CLONEVAL)) && (grp.GA_Previous_Group_Segment_No__c !=null) )
                            //if((GA_GroupSegmentTriggerHandler.isCloneFirstEdit == True) && (grp.GA_Previous_Group_Segment_No__c !=null))
                        {
                            previousRecordId=previousRecordId.removeEnd(CLONEVAL);
                            grp.GA_Prevs_RecordID__c=previousRecordId;
                            
                            
                            if(grp.GA_Carrier__c==BCBSM)
                            {
                                if((grp.GA_Facets_Class_ID__c!=null)||(grp.GA_Facets_Group_ID__c!=null)||(grp.GA_Facets_Sub_Group_Number__c!=null))
                                {
                                    grp.addError(cmpltOnlyMTVFld);
                                }
                            }
                            
                            if(grp.GA_Carrier__c==BCN)
                            {
                                if((grp.GA_MTV_Group__c!=null)||(grp.GA_MTV_Group_Division__c!=null))
                                {
                                    grp.addError(cmpltOnlyFacetsFld);
                                }                     
                                if((grp.GA_Facets_Class_ID__c==null)||(grp.GA_Facets_Group_ID__c==null)||(grp.GA_Facets_Sub_Group_Number__c==null))
                                {
                                    grp.addError(cmpltAllFacetsFld);
                                } 
                            }                   
                            
                            if((((grp.GA_Facets_Class_ID__c!=null) && (grp.GA_Facets_Group_ID__c!=null) &&(grp.GA_Facets_Sub_Group_Number__c!=null)) ||((grp.GA_MTV_Group__c!=null)&&(grp.GA_MTV_Group_Division__c!=null))) && (grp.GA_Carrier__c != null || grp.GA_Carrier__c !=NONEVAL)) 
                            {  
                                String facetCombination = grp.GA_Facets_Group_ID__c+UNDERSCR+grp.GA_Facets_Sub_Group_Number__c+UNDERSCR+grp.GA_Facets_Class_ID__c;
                                String mtvCombination =  grp.GA_MTV_Group__c+UNDERSCR+grp.GA_MTV_Group_Division__c;
                                String currentRecordId = grp.Id;
                                List<GA_Group_Segment__c> grpExistsLst = [Select Id from GA_Group_Segment__c where (GA_External_ID__c =: facetCombination  or GA_External_ID__c =: mtvCombination) AND Id != :currentRecordId Limit 200];
                                if(grpExistsLst.size() > 0 && !grpExistsLst.isEmpty()){
                                    grp.addError(grpInfoErrMsg);
                                }
                            }
                        }     
                    }
                    
                    
                }
                
            }   
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METDUPDATESORUCEGRPCLONE); 
        }
    } 
    /*******************************************************************************************************************************
@Description        :   updateGSNameOnChildRecs() method 
@Name               :   updateGSNameOnChildRecs
@Param              :   list<GA_Group_Segment__c> GrpLst
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void updateGSNameOnChildRecs(list<GA_Group_Segment__c> GrpLst,Map<Id,GA_Group_Segment__c> gSOldMap)
    { 
        try
        {  
            Map<Id,String> gsNmMap = New Map<Id,String>();
            List<GA_AOR_Group_Segment__c> aorUpdtGsLst = New List<GA_AOR_Group_Segment__c>();
            for(GA_Group_Segment__c grp : GrpLst){
                if((gsoldMap.get(grp.Id).Name <> grp.Name) ) {
                    gsNmMap.put(grp.Id,grp.Name);
                }
            }
            
            
            GA_AOR_Group_Segment__c newAORGs = New GA_AOR_Group_Segment__c();
            for(GA_AOR_Group_Segment__c aorGS :  [Select id,name,GA_Agent_Contact_Name__c,CreatedDate,GA_Group_Segment_Id__c
                                                  from GA_AOR_Group_Segment__c where GA_Group_Segment_Id__c in: gsNmMap.keyset() Limit 2000]) {
                                                      newAORGs =  New GA_AOR_Group_Segment__c();
                                                      newAORGs.id = aorGS.id;
                                                      newAORGs.GA_Is_Mass_updating__c = True;
                                                      aorUpdtGsLst.add(newAORGs);
                                                  }
            
            Database.update(aorUpdtGsLst);
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METDUPDATESORUCEGRP); 
        }
    }    
}