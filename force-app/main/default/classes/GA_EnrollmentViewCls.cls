/**
@Author : Prasant Kumar Satpathy
@Name: GA_EnrollmentViewCls
@CreatedDate: 15 - Jan 2018
@Description: GA_EnrollmentViewCls class is rollup enrollment info into Group segment related list
@version : 1.0  
*/
public without sharing class GA_EnrollmentViewCls {
    public static final string hyphenVal='-';
    public static final string ErrorMsg='Unable to fetch Enrollment Information';
    /**
@Description: fetchcolvals() method 
@Name : fetchcolvals
@Param : NA
@Return : List<ColvalCls>
@throws Exception : NA;
*/ 
    @AuraEnabled
    public static list<ColvalCls> fetchcolvals()
    {
        try
        {
            list<ColvalCls> colValLst=new list<ColvalCls>();
            ColvalCls clval;
            for(Enrollment_Column_List__mdt enrollmntCol:([SELECT Label,GA_Column_Name__c,GA_Data_Type__c,GA_Sortable__c,GA_Column_Number__c  FROM Enrollment_Column_List__mdt order by GA_Column_Number__c asc limit 20]))
            {
                clval=new ColvalCls(enrollmntCol.Label,enrollmntCol.GA_Column_Name__c,enrollmntCol.GA_Data_Type__c,enrollmntCol.GA_Sortable__c);
                colValLst.add(clval);
            }
            
            return colValLst;  
        }
        catch(exception e)
        {
            throw new AuraHandledException(ErrorMsg);  
        }
    }
    
    /**
@Description: fetchenrollmntRec() method 
@Name : fetchenrollmntRec
@Param : id grpSmtId,integer LimitRec
@Return : List<accEnrollWrapCls>
@throws Exception : NA;
*/
    @AuraEnabled
    public static list<accEnrollWrapCls>  fetchenrollmntRec(id grpSmtId,integer LimitRec)
    {
        try
        {
            date daternge=system.today().addmonths(-14);
            string accName;      
            list<GA_Plan_Package__c> plnPckgLst=[select id,GA_Group_Segment__r.name from GA_Plan_Package__c where GA_Group_Segment__c=:grpSmtId limit 100];
            set<id> plnpckgIds=new set<id>();
            map<id,GA_Enrollment__c> enrolmentMap=new map<id,GA_Enrollment__c>();
            list<accEnrollWrapCls> accEnrolwrapLstRet=new list<accEnrollWrapCls>();
            if(plnPckgLst.size()>0)
            {
                accName=plnPckgLst[0].GA_Group_Segment__r.name;
                for(GA_Plan_Package__c plnPkg:plnPckgLst)
                {
                    
                    plnpckgIds.add(plnPkg.id);
                }
                list<asset> astLst=[select id,recordtype.name,GA_Plan_Package_id__r.GA_ACTIVE_IND__c from asset where GA_Plan_Package_Id__c in:plnpckgIds Order by GA_Plan_Package_id__r.GA_ACTIVE_IND__c limit 100];
                list<id> astIds=new list<id>();
                map<string,list<id>> recSoldprdmp=new map<string,list<id>>();
                list<id> soldprdIds;
                for(asset ast:astLst)
                {
                    if(recSoldprdmp.get(ast.recordtype.name) !=null)
                    {
                        soldprdIds=recSoldprdmp.get(ast.recordtype.name);
                    }
                    else
                        soldprdIds=new list<id>();
                    soldprdIds.add(ast.id);
                    recSoldprdmp.put(ast.recordtype.name,soldprdIds);
                    astIds.add(ast.id);
                }
                map<id,list<id>> sldEnrlmntMap=new map<id,list<id>>();
                list<id> enrolmntId;
                enrolmentMap=new map<id,GA_Enrollment__c>([select Id,Name,GA_Record_Url__c,GA_Plan_Name__c,
                                                           GA_Plan_Name__r.name,GA_Plan_Name__r.GA_Product_Family__c,
                                                           GA_Contract_Comp__c,GA_Contract_Exp_Comp__c,GA_Mbr_Comp__c,GA_Mbr_Exp_Comp__c,
                                                           GA_Contract_Tier3__c,GA_Contract_Exp_Tier3__c,GA_Mbr_Tier3__c,GA_Mbr_Exp_Tier3__c,
                                                           GA_Contract_Tier1__c,GA_Contract_Exp_Tier1__c,GA_Mbr_Tier1__c,GA_Mbr_Exp_Tier1__c,
                                                           GA_Contract_Tier2__c,GA_Contract_Exp_Tier2__c,GA_Mbr_Tier2__c,GA_Mbr_Exp_Tier2__c
                                                           from GA_Enrollment__c 
                                                           where GA_Plan_Name__c in:astIds and GA_Enrollment_Date__c >:daternge Order by Name desc limit 1000]);
                
                integer cnt;
                list<accEnrollWrapCls> accEnrolwrapLst=new list<accEnrollWrapCls>();
                {
                    accEnrollWrapCls accEnrollWrapClsObj;
                    map<string,accEnrollWrapCls> accEnrollWrapClsObjMap=new map<string,accEnrollWrapCls>();
                    cnt=0;
                    for(GA_Enrollment__c enrolmnt:enrolmentMap.values())
                    {
                        
                        if(accEnrollWrapClsObjMap.get(enrolmnt.name+hyphenVal+enrolmnt.GA_Plan_Name__r.name+hyphenVal+enrolmnt.GA_Plan_Name__r.GA_Product_Family__c) !=null)
                        {
                            accEnrollWrapClsObj=accEnrollWrapClsObjMap.get(enrolmnt.name+hyphenVal+enrolmnt.GA_Plan_Name__r.name+hyphenVal+enrolmnt.GA_Plan_Name__r.GA_Product_Family__c);
                            if(accEnrollWrapClsObj.OnePerson_Cntrcts !=null)
                                accEnrollWrapClsObj.OnePerson_Cntrcts=accEnrollWrapClsObj.OnePerson_Cntrcts+integer.valueof(((enrolmnt.GA_Contract_Tier1__c == null) ? 0 : enrolmnt.GA_Contract_Tier1__c));
                            if(accEnrollWrapClsObj.Family_Cntrcts !=null)
                                accEnrollWrapClsObj.Family_Cntrcts=accEnrollWrapClsObj.Family_Cntrcts+integer.valueof(((enrolmnt.GA_Contract_Tier3__c == null) ? 0 : enrolmnt.GA_Contract_Tier3__c));
                            if(accEnrollWrapClsObj.TwoPerson_Cntrcts !=null)
                                accEnrollWrapClsObj.TwoPerson_Cntrcts=accEnrollWrapClsObj.TwoPerson_Cntrcts+integer.valueof(((enrolmnt.GA_Contract_Tier2__c == null) ? 0 : enrolmnt.GA_Contract_Tier2__c));
                            if(accEnrollWrapClsObj.Comp_Cntrcts !=null)                        
                                accEnrollWrapClsObj.Comp_Cntrcts=accEnrollWrapClsObj.Comp_Cntrcts+integer.valueof(((enrolmnt.GA_Contract_Comp__c == null) ? 0 : enrolmnt.GA_Contract_Comp__c)); 
                        }
                        else
                        {
                            accEnrollWrapClsObj=new accEnrollWrapCls(enrolmnt.name,cnt,enrolmnt.GA_Plan_Name__r.GA_Product_Family__c,accName,enrolmnt.GA_Plan_Name__r.name);
                            
                            accEnrollWrapClsObj.OnePerson_Cntrcts=integer.valueof(enrolmnt.GA_Contract_Tier1__c);
                            accEnrollWrapClsObj.Family_Cntrcts=integer.valueof(enrolmnt.GA_Contract_Tier3__c);
                            accEnrollWrapClsObj.TwoPerson_Cntrcts=integer.valueof(enrolmnt.GA_Contract_Tier2__c);
                            accEnrollWrapClsObj.Comp_Cntrcts=integer.valueof(enrolmnt.GA_Contract_Comp__c); 
                        }
                        accEnrollWrapClsObj.count=accEnrollWrapClsObj.count+1; 
                        
                        accEnrollWrapClsObjMap.put(enrolmnt.name+hyphenVal+enrolmnt.GA_Plan_Name__r.name+hyphenVal+enrolmnt.GA_Plan_Name__r.GA_Product_Family__c,accEnrollWrapClsObj);
                        
                    }
                    accEnrolwrapLst.addAll(accEnrollWrapClsObjMap.values());
                    
                }
                integer i=0;
                for(accEnrollWrapCls accEnroll:accEnrolwrapLst)
                {
                    if(i<LimitRec)
                        accEnrolwrapLstRet.add(accEnroll);
                    i++;
                }
                
            }
            return accEnrolwrapLstRet;
        }
        catch(exception e)
        {
            throw new AuraHandledException(ErrorMsg);
        }
        
    }
    @AuraEnabled
     public static string  fetchGrpNme(id grpSmtId)
     {
         string grpName=[select name from ga_group_segment__c where id=:grpSmtId limit 1].name;
         return grpName;
     }
    
    /**
@Author : Prasant Kumar Satpathy
@Name: accEnrollWrapCls
@CreatedDate: 15 - Jan 2018
@Description: accEnrollWrapCls wrapper class is rollup enrollment info into Group segment related list
@version : 1.0  
*/
    public without sharing class accEnrollWrapCls
    {
        @AuraEnabled
        public string enrolmntName;
        @AuraEnabled
        public integer Count;
        @AuraEnabled
        public string RecName;
        @AuraEnabled
        public string accName;
        @AuraEnabled
        public string prdName;
        @AuraEnabled
        public integer OnePerson_Cntrcts;
        @AuraEnabled
        public integer Family_Cntrcts;
        @AuraEnabled
        public integer TwoPerson_Cntrcts;
        @AuraEnabled
        public integer Comp_Cntrcts;
        
        /*Constructor*/
        public accEnrollWrapCls(string enrolmntNameTmp,integer CountTmp,string RecNameTmp,string accNameTmp,string prdNameTmp)
        {
            enrolmntName=enrolmntNameTmp;
            Count=CountTmp;
            RecName=RecNameTmp;
            accName=accNameTmp;
            prdName=prdNameTmp; 
        }
    }
    
    /**
@Author : Prasant Kumar Satpathy
@Name: ColvalCls
@CreatedDate: 15 - Jan 2018
@Description: ColvalCls wrapper class is rollup enrollment info into Group segment related list
@version : 1.0  
*/
    public with sharing class ColvalCls
    {
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string fieldName;
        @AuraEnabled
        public boolean sortable;
        @AuraEnabled
        public string type;
        /*Constructor*/
        public ColvalCls(string labelTmp,string fieldNameTmp,string typeTmp,boolean sortableTmp)
        {
            label=labelTmp;
            fieldName=fieldNameTmp;
            sortable=sortableTmp;
            type=typeTmp;
        }
    }
}