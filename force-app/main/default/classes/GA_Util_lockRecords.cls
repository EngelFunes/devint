/**
@Author : Padmahaarika Jayana
@Name: GA_Util_lockRecords
@CreatedDate: 23-Oct-2017
@Description: GA_Util_lockRecords editing only on customer and prospect accounts
@version : 1.0 
*/
public with sharing class GA_Util_lockRecords{
    public static boolean isExecuting = false;
    public static final String ClsName  ='GA_Util_lockRecords';
    public static final String methodNmeInsrtLockRec  ='onInsertlockRecords';
    public static final String methodNmeUpdateLockRec  ='onUpdatelockorUnlockRecords';
    public static final String methodNmelockRecords  ='lockRecords';
    public static final String methodNmeunlockRecords  ='unlockRecords';
    public static final String lockRecErrMsg = 'Failed to peform action :';
    Public static final String SysOfRec = 'SMART';
    public static final String CustomerRecType = 'Account - Customer';
    public static final String ProspectRecType = 'Account - Prospect';
    public static final  Id CustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(CustomerRecType).getRecordTypeId();
    public static final  Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ProspectRecType).getRecordTypeId();
    public static final String LISTOBJ1 = 'List<';
    public static final String ListOBJ2 = '>';
    
    /**
@Description: onInsertlockRecords() method
@Name : onInsertlockRecords
@Param : List<SObject> records, String fieldName
@Return : void
@throws Exception : N/A;
*/
    public static void onInsertlockRecords(List<SObject> records, String fieldName )
    {
        try{
            List<SObject> recListFltr = New List<SObject>();
            String objectName = fetchObjectName(records);
            GA_Lock_Unlock_Setting__mdt LockChk =[SELECT Label,Field_Value__c FROM GA_Lock_Unlock_Setting__mdt where label =:objectName limit 1];
            
            for(SObject a : records)
            {    
                if(((String)a.get(fieldName) == LockChk.Field_Value__c ))
                {
                    recListFltr.add(a);
                }   
            }
            lockRecords(recListFltr,objectName);
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeInsrtLockRec);
            records[0].adderror(lockRecErrMsg);
        }
    }
    /**
@Description: lockRecords() method
@Name : lockRecords
@Param : List<SObject> recordsToLock,string objectName
@Return : void
@throws Exception : N/A;
*/    
    public static void lockRecords(List<SObject> recordsToLock,string objectName){
        try
        {
            String listType = LISTOBJ1+objectName+LISTOBJ2;
            List<SObject> LockRecords = (List<SObject>)Type.forName(listType).newInstance();
            LockRecords.addAll(recordsToLock);
            list<Approval.LockResult> lrList = Approval.lock(LockRecords, false);  
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmelockRecords);
        }
        
        
    }
    /**
@Description: fetchObjectName() method
@Name : fetchObjectName
@Param : List<Sobject> objList
@Return : void
@throws Exception : N/A;
*/  
    private static String fetchObjectName(List<Sobject> objList){
        
        Schema.SObjectType sObjectType = objList.getSObjectType();
        Schema.DescribeSObjectResult sObjectRes = sObjectType.getDescribe();
        String objectName = sObjectRes.getName(); 
        
        return objectName;
    }
    
    /**
@Description: onUpdatelockorUnlockRecords() method
@Name : onUpdatelockorUnlockRecords
@Param : List<SObject> records,map<id,SObject>  recOldMap, String fieldName
@Return : void
@throws Exception : N/A;
*/     
    public static void onUpdatelockorUnlockRecords(List<SObject> records,map<id,SObject>  recOldMap, String fieldName)
    {
        try{
            List<Sobject> lockrecListFltr = New List<Sobject>();
            List<Sobject> unlockrecListFltr = New List<Sobject>();
            
            String objectName = fetchObjectName(records);
            GA_Lock_Unlock_Setting__mdt LockChk =[SELECT Label,Field_Value__c FROM GA_Lock_Unlock_Setting__mdt where label =:objectName limit 1];
            
            for(SObject a : records)
            {    
                string oldStatus = (String)recOldMap.get(a.id).get(fieldName);
                String newSttaus = (String)a.get(fieldName);
                
                if((newSttaus != oldStatus) && (newSttaus == LockChk.Field_Value__c ))
                {
                    lockrecListFltr.add(a);
                } 
                
                
            }
            
            for(SObject a : records)
            {   
                string oldStatus = (String)recOldMap.get(a.id).get(fieldName);
                String newSttaus = (String)a.get(fieldName);
                
                if((newSttaus != oldStatus) && (newSttaus != LockChk.Field_Value__c ))
                {
                    unlockrecListFltr.add(a);
                } 
                
                
            }
            lockRecords(lockrecListFltr,objectName);
            unlockRecords(unlockrecListFltr,objectName);  
            
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeUpdateLockRec);
            records[0].adderror(lockRecErrMsg);
        }
    }
    
    /**
@Description: unlockRecords() method
@Name : unlockRecords
@Param :List<Sobject> recordsToUnlock,string objectName
@Return : void
@throws Exception : N/A;
*/  
    public static void unlockRecords(List<Sobject> recordsToUnlock,string objectName){
        
        // Unlock the accounts
        try
        {
            String listType = LISTOBJ1+objectName+LISTOBJ2;
            List<SObject> LockRecords = (List<SObject>)Type.forName(listType).newInstance();
            LockRecords.addAll(recordsToUnlock);
            Approval.UnlockResult[] urList = Approval.unlock(LockRecords, false);   
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeunlockRecords);  
        }
        
    }
}