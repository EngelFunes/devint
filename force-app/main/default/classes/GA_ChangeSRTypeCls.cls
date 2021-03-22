/**
@Author : IDC offshore
@Name: GA_ChangeSRTypeCls
@CreatedDate: 10 - June 2019 
@Description: GA_ChangeSRTypeCls class is to change type from Support request
@version : 1.0  
*/
public class GA_ChangeSRTypeCls {
    
    private static string clsName='GA_ChangeSRTypeCls'; 
    private static string fetchServiceRequestPicklistValuesMthd='fetchServiceRequestPicklistValues';
    private static string updateCategoryBasedonSRTypeMthd='updateCategoryBasedonSRType';
    public static final string caseObject = 'Case';
    public static final string DepFldName = 'GA_SupportRequest_Type__c';
    public static final string CntlrFldName = 'GA_WorkOrderCategory__c';
    
      @AuraEnabled
    public static boolean fetchChangrSRTypeAccess(){
        try
        {
            Boolean hasAccess = GA_Trigger_Functionality_By_Pass__c.getInstance().GA_Change_SR_Type__c;
            String userId =  UserInfo.getUserId();
            if(hasAccess == true)
            {
                User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
                String userRoleName =userDetails.UserRole.Name; 
                if(userRoleName == null || userRoleName.equals('Support Representative') || userRoleName.equals('West Michigan Support Representative'))
                {
                     hasAccess = false;
                }                 
            }
            return hasAccess;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, 'GA_CloneGrpSegmentCls', 'fetchGroupSegmentClone');
            throw new AuraHandledException(System.Label.GA_AssignOwnerErr+': '+e.getMessage()); 
        }
    }
    
    @AuraEnabled
    public static List<String> fetchServiceRequestPicklistValues()
    {
        try{
            
            Map<Object,List<String>> pickValMap=GA_GetDependentPickListValues.getDependentPicklistValues(Case.GA_SupportRequest_Type__c);
            List<String> srTypes= pickValMap.get('Support Request');  
            /*Integer j = 0;
            while (j < srTypes.size())
            {
                if(srTypes.get(j).equals('Crosswalk')||srTypes.get(j).equals('Data Pages')||srTypes.get(j).equals('Documents')||srTypes.get(j).equals('Follow-Up')
                   ||srTypes.get(j).equals('HCR Activity')||srTypes.get(j).equals('NASCO')||srTypes.get(j).equals('NASCO BaaG')||srTypes.get(j).equals('New Business') ||srTypes.get(j).equals('Rate Renewal Cert'))
                {
                    srTypes.remove(j);
                }else
                {
                    j++;
                }
            }  */
          
            return srTypes;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, fetchServiceRequestPicklistValuesMthd);
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    
    
     @AuraEnabled
    public static void updateCategoryBasedonSRType(String srtype,String caseId)
    {
        try{
            Map<String, String> SRTypeCategoryMap = getCategoryFromSRType();
            String category = SRTypeCategoryMap.get(srtype);
            if(category == null || category.equals(''))
            {
                category='Support Request';
            }
            
            String srCategory = [select GA_WorkOrderCategory__c from case where id=:caseId limit 1].GA_WorkOrderCategory__c;
            Case caseRecord = new Case();
            caseRecord.Id = caseId;
            caseRecord.GA_SupportRequest_Type__c = srtype;
            if(srCategory.equals('Support Request'))
            {
                caseRecord.GA_WorkOrderCategory__c = 'Support Request';
            }
            else
            {
                caseRecord.GA_WorkOrderCategory__c = category;
            }            
            caseRecord.GA_Is_Mass_Updating__c = true;
            system.debug('Case Record Value '+category+srtype);
            Database.update(caseRecord);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, updateCategoryBasedonSRTypeMthd);
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    
    public static  Map<String, String> getCategoryFromSRType()
    {
        Map<String, String> SRTypeCategoryMap = new Map<String, String>();
        Map<Object,List<String>> pickValMap=GA_GetDependentPickListValues.getDependentPicklistValues(Case.GA_SupportRequest_Type__c);
        for(Object category: pickValMap.keyset()){
            //system.debug('category '+category);
            if(!category.equals('Support Request'))
            {
                List<String> srTypeset= pickValMap.get(category);
                for(String eachSRType: srTypeset){                    
                SRTypeCategoryMap.put(eachSRType,String.valueOf(category));                                  
                } 
            }            
        }       
        system.debug('SRTypeCategoryMap '+SRTypeCategoryMap); 
        return SRTypeCategoryMap;
    }
}