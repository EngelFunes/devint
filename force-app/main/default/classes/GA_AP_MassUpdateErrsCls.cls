/*****************************************************************************************
Class Name   : GA_AP_MassUpdateErrsCls
Date Created : 09/12/2018
Created By   : IDC Offshore
Description  : 1. This is controller class to mass update errors
******************************************************************************************/

public class GA_AP_MassUpdateErrsCls {
    public static string ClsName='GA_AP_MassUpdateErrsCls';
    public static string FormatedDataMthd='formatedData';
    public static string UpdtRecsMthd='updtRecs';
    public static string ErrorMsg='There is problem in fetching validations';
    public static string UpErrorMsg='There is problem in updating error validations';
    public static string ExcepSepartr='-';
    public static string mssUpdtField = 'GA_Is_Mass_Updating__c';
    public static string gsObjApiName = 'GA_Group_Segment__c';
    
    /**
@Description: fetchRecs() method 
@Name : fetchRecs
@Param : String formatedData
@Return : string
@throws Exception : AuraHandledException;
*/
    @AuraEnabled
    public static list<frmatCls> fetchRecs(string formatedData)
    {
        try
        {
            List<errormessage> listToSave = (List<errormessage>)JSON.deserialize(formatedData, List<errormessage>.class);
            list<frmatCls> frmClsLst=new list<frmatCls>();
            frmatCls frmtDataRecs;
            string recIdLst;
            map<string,frmatCls> fieldNmeunique=new map<string,frmatCls>();
            for(errormessage err:listToSave)
            {
                
                if(!fieldNmeunique.keySet().contains(err.errfieldNme))
                {
                    recIdLst=''; 
                    frmtDataRecs=new frmatCls();  
                    frmtDataRecs.fieldName=err.errfieldNme;
                    frmtDataRecs.fieldType=err.errfieldType;
                    frmtDataRecs.objType=err.errObjNme;
                    frmtDataRecs.recIds=err.errRecId;
                    frmtDataRecs.fieldLabel=err.errFieldLbl;//err.errfieldNme.substringBetween('GA_', '__c').replace('_', ' ');
                    
                }
                else
                {
                    
                    frmtDataRecs=fieldNmeunique.get(err.errfieldNme);
                    frmtDataRecs.recIds=frmtDataRecs.recIds+','+err.errRecId;
                }
                
                
                
                fieldNmeunique.put(err.errfieldNme,frmtDataRecs);
            }
            for(string fiedlnm: fieldNmeunique.keySet())
            {
                frmClsLst.add(fieldNmeunique.get(fiedlnm));
            }
            
            return frmClsLst;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, FormatedDataMthd);
            throw new AuraHandledException(ErrorMsg+ExcepSepartr+e.getMessage());   
        }
        
    }
    
    /**
@Description: updtRecs() method 
@Name : updtRecs
@Param : String updtedVals
@Return : string
@throws Exception : AuraHandledException;
*/
    @AuraEnabled
    public static void updtRecs(string updtedVals)
    {
        try
        {
            List<frmatCls> updtedDataSet = (List<frmatCls>)JSON.deserialize(updtedVals, List<frmatCls>.class);
            
            map<id,sobject> objMap=new map<id,sobject>();
            SObject obj;
            
                  Schema.SObjectType GrpSgmtn = Schema.getGlobalDescribe().get(gsObjApiName);
            
            for(frmatCls updtedRec:updtedDataSet)
            {
                
                for(string objId:updtedRec.recIds.split(','))
                {
                    if(objMap.keyset().contains(objId))
                    {
                        obj= objMap.get(objId); 
                    }
                    else
                    {
                        Schema.SObjectType t = Schema.getGlobalDescribe().get(updtedRec.objType);
                        obj = t.newSObject();   
                    }
                    obj.put('Id',objId);
                    if(updtedRec.fieldType =='Date')
                    {
                        date dt=date.valueof(updtedRec.inputVal);
                        obj.put(updtedRec.fieldName,dt);
                    }
                    else
                    {
                        obj.put(updtedRec.fieldName,updtedRec.inputVal);
                    }
                    
                   
                    objMap.put(objId,obj);
                      
                }   
            }
            
            

            if(objMap.keyset().size()>0)
            {
                
                for(Sobject sobj : objMap.Values())
                {
                    if(sobj.getSObjectType() == GrpSgmtn){
                        sobj.put(mssUpdtField, true);
                    }
                }
                database.update(objMap.values());
            }  
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, UpdtRecsMthd);
            throw new AuraHandledException(UpErrorMsg+ExcepSepartr+e.getMessage());   
        }
        
    }
    /*frmatCls wrapper class */
    public class frmatCls
    {
        @AuraEnabled
        public string fieldName;
        @AuraEnabled
        public string fieldLabel;
        @AuraEnabled
        public string recIds;
        @AuraEnabled
        public string fieldType;
        @AuraEnabled
        public string inputVal;
        @AuraEnabled
        public string objType;
        
    }
    /*errormessage wrapper class */
    public class errormessage
    {
        @AuraEnabled
        public string errRecId ;
        @AuraEnabled
        public String errRecName;       
        @AuraEnabled
        public String errmessage; 
        @AuraEnabled
        public String errRecIdUrl; 
        @AuraEnabled
        public String errfieldNme; 
        @AuraEnabled
        public String errfieldType; 
        @AuraEnabled
        public String errObjNme; 
        @AuraEnabled
        public String errFieldLbl; 
        
        /*errormessage constructor*/
        public errormessage(string errRecIdTmp,string errRecNameTmp,String errmessageTmp)
        {
            errRecId =errRecIdTmp;
            errRecIdUrl='/'+errRecIdTmp;
            errRecName = errRecNameTmp;
            errmessage=errmessageTmp;
            
        }
    }
}