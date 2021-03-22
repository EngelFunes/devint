/**
@Author : Prasant
@Name: GA_Group_Support_RqstSrvcCls
@CreatedDate: 20 - June 2018 
@Description: GA_Group_Support_RqstSrvcCls class is for prepopulation of fields.
@version : 1.0  
*/
public with sharing class GA_Group_Support_RqstSrvcCls {
    public static final string hyphenVal = '-';
    /**
@Description: prepopulateName() method 
@Name : prepopulateName
@Param : list<GA_Group_Support_Request__c> grpRlnshipLst,map<id,GA_Group_Support_Request__c> grpRlnshipOldMp  
@Return : void
@throws Exception : N/A;
*/    
    public static void prepopulateName(list<GA_Group_Support_Request__c> grpRlnshipLst,map<id,GA_Group_Support_Request__c> grpRlnshipOldMp)
    {
        
        for(GA_Group_Support_Request__c grpSgnt:grpRlnshipLst)
        {
            if(grpRlnshipOldMp !=null)
            {
                GA_Group_Support_Request__c grpSgmntOld=grpRlnshipOldMp.get(grpSgnt.id);
                if(grpSgmntOld.Name !=grpSgnt.Name)
                {
                    grpSgnt.Name=grpSgnt.GA_Group_Segment_Name__c+hyphenVal+grpSgnt.GA_Support_Number__c; 
                }
            }
            else  
                grpSgnt.Name=grpSgnt.GA_Group_Segment_Name__c+hyphenVal+grpSgnt.GA_Support_Number__c;
        }
    }
}