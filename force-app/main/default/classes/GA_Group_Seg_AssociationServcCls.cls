/*****************************************************************************************************************************************
@Author : Dilip
@Name: GA_Group_Seg_AssociationServcCls
@CreatedDate: 09 - Sep 2018 
@Description: GA_Group_Seg_AssociationServcCls class is for prepopulation of fields.
@version : 1.0  
*****************************************************************************************************************************************/
public class GA_Group_Seg_AssociationServcCls {
    public static final string hyphenVal = ' - ';
    /******************************************************************************************************************************************
@Description: prepopulateName() method 
@Name : prepopulateName
@Param : list<GA_Group_Association__c> gsALst,map<id,GA_Group_Association__c> gsALstOldMp  
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/    
    public static void prepopulateName(list<GA_Group_Association__c> gsALst,map<id,GA_Group_Association__c> gsALstOldMp)
    {
        for(GA_Group_Association__c grpAssc:gsALst)
        {
            if(gsALstOldMp !=null)
            {
                GA_Group_Association__c grpAsscOld=gsALstOldMp.get(grpAssc.id);
                if((grpAsscOld.GA_Account__c !=grpAssc.GA_Account__c) || 
                   (grpAsscOld.GA_Group_Segment__c !=grpAssc.GA_Group_Segment__c)||
                   (grpAsscOld.Name !=grpAssc.Name))
                {
                    grpAssc.Name=grpAssc.GA_Account_Name__c+hyphenVal+grpAssc.GA_Group_Segment_Name__c;
                    
                }
                if(grpAsscOld.GA_End_Date__c !=grpAssc.GA_End_Date__c)
                {
                    grpAssc.GA_End_Date_Frmt__c=string.valueof(grpAssc.GA_End_Date__c);
                    
                }
                if(grpAsscOld.GA_Start_Date__c !=grpAssc.GA_Start_Date__c)
                {
                    grpAssc.GA_Start_Date_Frmt__c=string.valueof(grpAssc.GA_Start_Date__c);
                }
            }
            else  
            {
                grpAssc.Name=grpAssc.GA_Account_Name__c+hyphenVal+grpAssc.GA_Group_Segment_Name__c;  
                grpAssc.GA_End_Date_Frmt__c=string.valueof(grpAssc.GA_End_Date__c);
                grpAssc.GA_Start_Date_Frmt__c=string.valueof(grpAssc.GA_Start_Date__c);
            }
                
        }
    }
}