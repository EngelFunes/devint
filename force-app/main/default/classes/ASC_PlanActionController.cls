public class ASC_PlanActionController {
    
    @AuraEnabled
    public static Contract getContract(ID contID) {

            Contract result = new Contract();
            
            Boolean hasAccess = hasAccessToCreate();   
            if(hasAccess){         
              result = [SELECT ID, Name ,EndDate,StartDate,AccountId FROM Contract WHERE ID = :contID];
            }
            else{
              result = null;
            }        
            return result;
    }
    @AuraEnabled
     public static Boolean hasAccessToCreate(){                
        Boolean hasAccess = false;
        String userId =  UserInfo.getUserId();        
        User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId];
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
       
        List<PermissionSetAssignment> PSetAssignment=[SELECT Id, PermissionSetId, PermissionSet.Name,AssigneeId 
                            FROM PermissionSetAssignment WHERE AssigneeId =: userId AND PermissionSet.Name='ASC_Quoting_Specialist'];
        if(!PSetAssignment.isEmpty() || 'System Administrator'.equals(profileName))//userDetails.Profile.Name.equals('System Administrator'))
        {
            hasAccess = true;           
        }
        else
        {
            hasAccess = false;
           
        }
        system.debug('$$$$$$$$'+hasAccess);
        return hasAccess;
     }
}