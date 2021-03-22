/*********************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_GS_UpdateRatingType
@CreatedDate: 01 - 11
@Description: GA_GS_UpdateRatingType class is for Group Segment clustor code 
@version : 1.0  
**********************************************************************************************************************************************/
public with sharing class GA_GS_UpdateRatingType {
    
    public static final String ClsName  ='GA_GS_UpdateRatingType';
    public static final String methodNme  ='updtRtngType';
    public static final String accTypIBU  ='IBU';
    public static final String rtngTypIB  ='IB';
    public static final String sysOfRec  ='SMART';
    public static final String noRntgTyp  =System.Label.GA_RatingType_No_Rating_Type;
    public static final String noClstrCod  =System.Label.GA_RatingType_No_Cluster_Code;
    public static final String seeSysAdm  =System.Label.GA_RatingType_See_System_Admin;
    public static boolean isExecuting = false;
 /**
@Description: updtRtngType() method
@Name : updtRtngType
@Param : list<GA_Group_Segment__c> gsLst,map<id,GA_Group_Segment__c> gsoldMap
@Return : void
@throws Exception : N/A;
*/        
    public static void updtRtngType(list<GA_Group_Segment__c> gsLst,map<id,GA_Group_Segment__c> gsoldMap){
        try{
            list<GA_Group_Segment__c> grpSgmntLst = new list<GA_Group_Segment__c>();
            boolean isChange=false;
            GA_Group_Segment__c grpSgmntOld;
            for(GA_Group_Segment__c gs :gsLst){
                system.debug('gs.GA_Current_Cluster_Code__c...'+gs.GA_Current_Cluster_Code__c);
                system.debug('gs.GA_Rating_Type__c...'+gs.GA_Rating_Type__c);
                if(gsoldMap!=null){
                    //gs.GA_Is_Mass_Updating__c = true;
                    grpSgmntOld=gsoldMap.get(gs.Id);
                    if(gs.GA_Current_Cluster_Code__c != grpSgmntOld.GA_Current_Cluster_Code__c
                       || gs.GA_Account_Type__c != grpSgmntOld.GA_Account_Type__c
                       || gs.GA_Rating_Method__c != grpSgmntOld.GA_Rating_Method__c
                       || gs.GA_Smart_Rating_Type__c != grpSgmntOld.GA_Smart_Rating_Type__c ){
                           isChange=true;
                       }
                    else
                    {
                        isChange=true; 
                    }
                }
                else {
                    isChange=true;
                }
                if(isChange){
                    system.debug('gs.GA_Current_Cluster_Code__c==>'+gs.GA_Current_Cluster_Code__c);
                system.debug('gs.GA_Rating_Type__c==>'+gs.GA_Rating_Type__c);
                    if(gs.GA_Account_Type__c==accTypIBU){
                        gs.GA_Rating_Type__c=rtngTypIB;
                    }else if(gs.GA_System_of_Record__c == sysOfRec && gs.GA_Smart_Rating_Type__c !=null){
                        gs.GA_Rating_Type__c = gs.GA_Smart_Rating_Type__c;
                    }else if(gs.GA_System_of_Record__c == sysOfRec && gs.GA_Smart_Rating_Type__c ==null){
                        gs.GA_Rating_Type__c =noRntgTyp;
                    }else if(gs.GA_Current_Cluster_Code__c == null){
                        gs.GA_Rating_Type__c=noClstrCod;
                    }else{
                        List<GA_GS_Rating_Type_Config__mdt> ratngType = [select GA_Rating_Type__c,GA_Rating_Method__c,GA_Start_Cluster_Code__c, 
                                                                         GA_End_Cluster_Code__c,GA_Sort_Order__c
                                                                         from GA_GS_Rating_Type_Config__mdt where 
                                                                         //GA_Start_Cluster_Code__c<=:gs.GA_Cluster_Code_Formula__c AND 
                                                                         //GA_End_Cluster_Code__c>=:gs.GA_Cluster_Code_Formula__c 
                                                                         GA_Start_Cluster_Code__c<=:gs.GA_Current_Cluster_Code__c AND 
                                                                         GA_End_Cluster_Code__c>=:gs.GA_Current_Cluster_Code__c 
                                                                         ORDER BY GA_Sort_Order__c DESC Limit 50];
                        if(ratngType.size()>0){
                            for(GA_GS_Rating_Type_Config__mdt rtngtp:ratngType){
                                if(rtngtp.GA_Rating_Method__c == null){
                                    gs.GA_Rating_Type__c=rtngtp.GA_Rating_Type__c;
                                    system.debug('ratingType-->'+gs.GA_Rating_Type__c);
                                }
                                else if(rtngtp.GA_Rating_Method__c == gs.GA_Rating_Method__c){
                                    gs.GA_Rating_Type__c=rtngtp.GA_Rating_Type__c;
                                }
                            }
                        }
                        else{
                            gs.GA_Rating_Type__c = seeSysAdm;
                        }
                    }
                }
                grpSgmntLst.add(gs);
            }
            //Database.update(grpSgmntLst);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
        }
    }
}