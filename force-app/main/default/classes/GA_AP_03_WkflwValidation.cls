/*****************************************************************************************
Class Name   : GA_AP_03_WkflwValidation
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to To return Boolean true/false based on 
validation condition by calling wfallwdSteps method.
******************************************************************************************/
public with sharing class GA_AP_03_WkflwValidation {
    //  To return Boolean true/false based on validation condition by calling wfallwdSteps method.
    public static map<string,objFieldWap> objFieldWapMap=new map<string,objFieldWap>();
    public static  list<GA_WF_Workflow__c> wrkflowRecLst = New list<GA_WF_Workflow__c>();
    public static List<String> customMessage = New List<String>() ;
    public static map<string,list<string>> FieldcustmMsgMap=new map<string,list<string>>();
    public static final String isNull ='IS NULL';
    public static final String isNotNull ='IS NOT NULL';
    public static final String contains ='CONTAINS';
    public static final String doesNotContain ='DOES NOT CONTAIN';
    public static final String  wfObj = 'GA_WF_Workflow__c';
    public static final String  acntObj = 'GA_Account__r';
    public static final String  suprtObj = 'GA_Support__r';
    public static final String  grpSegmntObj = 'GA_Group_Segment_ID__r';
    public static final String ErrMsg = 'Could not perform validations :';
    public static final String ClsName  ='GA_AP_03_WkflwValidation';
    public static final String method1  ='wfallwdSteps';
    public static final String method2  ='fetchValidationMessage';
    public static final  Set<Id> allGrpIds = New Set<Id>();
    public static final  Set<Id> failGrpIds = New  Set<Id>();
    public static final  String dotVal = '.';
    public static final String sprtr = '~';
    public static final String commaSyb = ',';
    public static final String wfGrpSgmntRel = 'GA_Workflow_Group_Segments__r';
    public static final String wfGrpSgmnt = ' from GA_Workflow_Group_Segments__r';
    public static final String wfFlwId = ' from GA_WF_Workflow__c where id=:wfId';
    public static final String clseCrlBrc = ')' ;
    public static final String FAIL = 'FAIL';
    public static final String PASS = 'PASS';
    public static final String selctQry = '(select id, ';
    public static final String dotId = '.Id,';
    public static final String Id2 = 'id';
    public static final String Name = 'Name';
    public static final String caseNumbr = 'casenumber';
    public static final String Id1 = 'id,';
    public static final String dotName ='.Name';
    public static final String selctQry1 = 'select id,name ';
    
    /**
@Description: wfallwdSteps() method 
@Name : wfallwdSteps
@Param :id wfTmpId, id wfId,Id wfstpId
@Return : List<String>
@throws Exception : AuraHandledException;
*/    
    @AuraEnabled
    public static List<String> wfallwdSteps(id wfTmpId, id wfId,Id wfstpId)
    {
        try
        {
            map<string,map<string,string>> objtFieldMap=new map<string,map<string,string>>();
            map<string,string> fieldNmsValidCndMap;
            list<fieldValidationWp> fieldValLst=new list<fieldValidationWp>();
            list<GA_WFT_Validation__c> validtnLst=new list<GA_WFT_Validation__c>();
            boolean multiValidtnField=false;
            objFieldWap objField;
            fieldValidationWp fieldVal;
            objFieldWapMap.clear();
            for(GA_WFT_Validation__c wftvalidtn:[select Id,Name,GA_Field_Name__c,GA_Object_Name__c,
                                                 GA_Validation_Type__c,GA_Validation_Value__c,
                                                 GA_Validation_Message__c from GA_WFT_Validation__c         
                                                 where GA_WFT_Workflow_ID__c=:wfTmpId  Limit 100])
            {
                if(objFieldWapMap.get(wftvalidtn.GA_Object_Name__c) !=null)
                {
                    objField=objFieldWapMap.get(wftvalidtn.GA_Object_Name__c);
                    fieldValLst=objField.fieldValLst;
                    for(fieldValidationWp fldvlTmp:fieldValLst)
                    {
                        if(wftvalidtn.GA_Field_Name__c==fldvlTmp.fieldNam)
                        {
                            validtnLst=fldvlTmp.validationLst;
                            validtnLst.add(wftvalidtn);
                            fieldValLst.add(fldvlTmp);
                            multiValidtnField=true;
                            break;
                        }
                    }
                    if(!multiValidtnField)
                    {
                        validtnLst=new list<GA_WFT_Validation__c>();
                        validtnLst.add(wftvalidtn);
                        
                        fieldVal=new fieldValidationWp(wftvalidtn.GA_Field_Name__c,validtnLst);
                        fieldValLst.add(fieldVal);   
                    }
                    
                    objField.fieldValLst=fieldValLst;
                }
                else
                {
                    validtnLst=new list<GA_WFT_Validation__c>();
                    validtnLst.add(wftvalidtn);
                    
                    fieldVal=new fieldValidationWp(wftvalidtn.GA_Field_Name__c,validtnLst);
                    fieldValLst=new list<fieldValidationWp>();
                    fieldValLst.add(fieldVal);
                    objField=new objFieldWap(wftvalidtn.GA_Object_Name__c,fieldValLst);
                }
                
                objFieldWapMap.put(wftvalidtn.GA_Object_Name__c,objField);
                
                if(objtFieldMap.get(wftvalidtn.GA_Object_Name__c) !=null)
                {
                    fieldNmsValidCndMap=objtFieldMap.get(wftvalidtn.GA_Object_Name__c);
                }
                else
                {
                    fieldNmsValidCndMap=new map<string,string>();
                }
                fieldNmsValidCndMap.put(wftvalidtn.GA_Field_Name__c,wftvalidtn.GA_Validation_Type__c);
                objtFieldMap.put(wftvalidtn.GA_Object_Name__c,fieldNmsValidCndMap);          
            }
            
            //TODO
            //Need to know how object name is stored in Validation record accordingly change filter conditions
            //May use custom metedatatype once objects for valition rules are finalized
            //need to know how workflow will be related to group segment and prepare validation for group segment accordingly
            string qury= selctQry1;
            
            for(string obj:objFieldWapMap.keyset())
            {
                
                if(obj.equals(wfObj))
                {
                    for(fieldValidationWp flds:objFieldWapMap.get(obj).fieldVallst)
                    {
                        
                        if(!qury.contains(obj+ dotVal +flds.fieldNam)  )
                            qury=qury+commaSyb+flds.fieldNam; 
                    }  
                }
                if(obj.equals(acntObj) )
                {
                    qury=qury+commaSyb+obj+ dotVal +Id1+obj+ dotVal + Name ;
                    for(fieldValidationWp flds:objFieldWapMap.get(obj).fieldVallst)
                    {
                        
                        if(!qury.contains(obj+ dotVal +flds.fieldNam) )
                            qury=qury+commaSyb+obj+ dotVal +flds.fieldNam; 
                    }
                }
                
                if( obj.equals(suprtObj))
                {
                    qury=qury+commaSyb+obj+ dotVal +Id1+obj+ dotVal +caseNumbr;
                    for(fieldValidationWp flds:objFieldWapMap.get(obj).fieldVallst)
                    {
                        
                        if(!qury.contains(obj+ dotVal +flds.fieldNam) )
                            qury=qury+commaSyb+obj+ dotVal +flds.fieldNam; 
                    }
                }
                
                if(obj.equals(grpSegmntObj))
                {
                    integer i=1;
                    qury=qury+commaSyb+ selctQry +obj+dotId+obj+dotName;
                    for(fieldValidationWp flds:objFieldWapMap.get(obj).fieldVallst)
                    {
                        
                        if(!qury.contains(obj+ dotVal +flds.fieldNam)  )
                        {                            
                            qury=qury+commaSyb+obj+ dotVal +flds.fieldNam; 
                            if(i<objtFieldMap.get(obj).keyset().size())
                                qury=qury; 
                        }
                        i++;
                    }
                    qury=qury+ wfGrpSgmnt + clseCrlBrc;
                }
            }
            qury=qury+ wfFlwId;
            
            //database query to fetch record
            wrkflowRecLst=database.query(qury);
            
            for(string obj:objFieldWapMap.keyset())
            {
                if(obj.equals(wfObj))
                {
                    for(fieldValidationWp flds:objFieldWapMap.get(obj).fieldVallst)
                    {
                        SObjectType r = ((SObject)(Type.forName('Schema.GA_WF_Workflow__c').newInstance())).getSObjectType();
                        DescribeSObjectResult d = r.getDescribe();
                        
                        String actualFieldDtls = flds.fieldNam+sprtr+d.fields.getMap().get(flds.fieldNam).getDescribe().getType()+sprtr+'GA_WF_Workflow__c'+sprtr+d.fields.getMap().get(flds.fieldNam).getDescribe().getLabel(); 
                        String actualfieldValue = String.valueOf(wrkflowRecLst[0].get(flds.fieldNam)); 
                        String recordId = String.valueOf(wrkflowRecLst[0].get(Id2)); 
                        String recordName = String.valueOf(wrkflowRecLst[0].get(Name)); 
                        fetchValidationMessage(objFieldWapMap.get(obj),flds.fieldNam,obj,actualfieldValue,recordId +sprtr+recordName,actualFieldDtls); 
                    }  
                }
                
                if(obj.equals(acntObj))
                {
                    for(fieldValidationWp flds:objFieldWapMap.get(obj).fieldVallst)
                    {
                        SObjectType r = ((SObject)(Type.forName('Schema.Account').newInstance())).getSObjectType();
                        DescribeSObjectResult d = r.getDescribe();
                        String actualFieldDtls =flds.fieldNam+sprtr+d.fields.getMap().get(flds.fieldNam).getDescribe().getType()+sprtr+'Account'+sprtr+d.fields.getMap().get(flds.fieldNam).getDescribe().getLabel();
                        String actualfieldValue = String.valueOf(wrkflowRecLst[0].getSobject(obj).get(flds.fieldNam)); 
                        String recordId = String.valueOf(wrkflowRecLst[0].getSobject(obj).get(Id2)); 
                        String recordName = String.valueOf(wrkflowRecLst[0].getSobject(obj).get(Name));
                        fetchValidationMessage(objFieldWapMap.get(obj),flds.fieldNam,obj,actualfieldValue,recordId +sprtr+recordName,actualFieldDtls); 
                    }
                }
                
                if(obj.equals(suprtObj))
                {
                    for(fieldValidationWp flds:objFieldWapMap.get(obj).fieldVallst)
                    {
                        SObjectType r = ((SObject)(Type.forName('Schema.Case').newInstance())).getSObjectType();
                        DescribeSObjectResult d = r.getDescribe();
                        String actualFieldDtls=flds.fieldNam+sprtr+d.fields.getMap().get(flds.fieldNam).getDescribe().getType()+sprtr+'Case'+sprtr+d.fields.getMap().get(flds.fieldNam).getDescribe().getLabel();
                        String actualfieldValue = String.valueOf(wrkflowRecLst[0].getSobject(obj).get(flds.fieldNam)); 
                        String recordId = String.valueOf(wrkflowRecLst[0].getSobject(obj).get(Id2)); 
                        String recordName = String.valueOf(wrkflowRecLst[0].getSobject(obj).get(caseNumbr));
                        fetchValidationMessage(objFieldWapMap.get(obj),flds.fieldNam,obj,actualfieldValue,recordId +sprtr+recordName,actualFieldDtls); 
                    }
                }
                
                if(obj.equals(grpSegmntObj))
                {
                    for(fieldValidationWp flds:objFieldWapMap.get(obj).fieldVallst)
                    {
                        for(integer i=0;i<wrkflowRecLst[0].getSobjects(wfGrpSgmntRel).size();i++)
                        {
                            SObjectType r = ((SObject)(Type.forName('Schema.GA_Group_Segment__c').newInstance())).getSObjectType();
                            DescribeSObjectResult d = r.getDescribe();
                            String actualFieldDtls=flds.fieldNam+sprtr+d.fields.getMap().get(flds.fieldNam).getDescribe().getType()+sprtr+'GA_Group_Segment__c'+sprtr+d.fields.getMap().get(flds.fieldNam).getDescribe().getLabel();
                            String actualfieldValue = String.valueOf(wrkflowRecLst[0].getSobjects(wfGrpSgmntRel)[i].getSobject(obj).get(flds.fieldNam)); 
                            String recordId = String.valueOf(wrkflowRecLst[0].getSobjects(wfGrpSgmntRel)[i].getSobject(obj).get(Id2)); 
                            String recordName = String.valueOf(wrkflowRecLst[0].getSobjects(wfGrpSgmntRel)[i].getSobject(obj).get(Name));
                            fetchValidationMessage(objFieldWapMap.get(obj),flds.fieldNam,obj,actualfieldValue,recordId +sprtr+recordName,actualFieldDtls); 
                        }
                    }
                }
            }
            
            List<GA_WF_Group_Segment__c> updtWfGrpSgmtlst = New  List<GA_WF_Group_Segment__c>();
            
            if(!allGrpIds.isEmpty() && !failGrpIds.isEmpty()){
                allGrpIds.removeAll(failGrpIds);
            }
            
            if(!failGrpIds.isEmpty())   {
                List<GA_WF_Group_Segment__c> wfStpGrpSgmnts = [Select Id,GA_WF_Step_ID__c,GA_Group_Segment_ID__c,GA_Validation_Status__c from 	GA_WF_Group_Segment__c
                                                               where GA_Group_Segment_ID__c in:  failGrpIds and GA_WF_Step_ID__c=:wfstpId Limit 100];
                for(GA_WF_Group_Segment__c wfgs : wfStpGrpSgmnts){
                    wfgs.GA_Validation_Status__c = FAIL;
                    updtWfGrpSgmtlst.add(wfgs);
                }
            } 
            
            IF(!allGrpIds.isEmpty()){
                List<	GA_WF_Group_Segment__c> wfStpGrpSgmnts = [Select Id,GA_WF_Step_ID__c,GA_Group_Segment_ID__c,GA_Validation_Status__c from 	GA_WF_Group_Segment__c
                                                                  where GA_Group_Segment_ID__c in: allGrpIds and GA_WF_Step_ID__c=:wfstpId Limit 100];
                
                for(GA_WF_Group_Segment__c wfgs : wfStpGrpSgmnts){
                    wfgs.GA_Validation_Status__c = PASS;
                    updtWfGrpSgmtlst.add(wfgs);
                }
            }
            
            Database.update(updtWfGrpSgmtlst);
                        
            for(list<string> msg:FieldcustmMsgMap.values())
            {
                customMessage.addAll(msg);
            }
            
            return customMessage; 
        } 
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, method1);
        }
        
        return customMessage; 
    }
    
    /**
@Description: fetchValidationMessage() method 
@Name : fetchValidationMessage
@Param :GA_AP_03_WkflwValidation.objFieldWap tt, string flds,String obj,String actualfieldValue,String recordDetails
@throws Exception : NA;
*/     
    public static void fetchValidationMessage(GA_AP_03_WkflwValidation.objFieldWap tt, string flds,String obj,String actualfieldValue,String recordDetails,String actualFieldDtls)
    {
        try
        {
            List<GA_AP_03_WkflwValidation.fieldValidationWp> flWpLst = tt.fieldVallst;            
            list<string> custMsg;
            
            if(obj.equals(grpSegmntObj))
            {
                allGrpIds.add(Id.valueof(recordDetails.substringBefore(sprtr)));
            }
            
            for(GA_AP_03_WkflwValidation.fieldValidationWp flwp : flWpLst ){
                List<GA_WFT_Validation__c> valLst = flwp.validationLst;
                for(GA_WFT_Validation__c wfvalidation : valLst){
                    String validationTyp =   wfvalidation.GA_Validation_Type__c;   
                    if( flds == wfvalidation.GA_Field_Name__c ){
                        if (validationTyp.equalsIgnoreCase(isNull) )
                        {
                            if(String.isBlank(actualfieldValue) )
                            {
                                
                                if(FieldcustmMsgMap.get(wfvalidation.GA_Field_Name__c) !=null)
                                {
                                    custMsg=FieldcustmMsgMap.get(wfvalidation.GA_Field_Name__c);
                                }
                                else
                                    custMsg=new list<string>();
                                if(!custMsg.contains(recordDetails +sprtr+wfvalidation.GA_Validation_Message__c+sprtr+actualFieldDtls))
                                    custMsg.add(recordDetails +sprtr+wfvalidation.GA_Validation_Message__c+sprtr+actualFieldDtls);
                                FieldcustmMsgMap.put(wfvalidation.GA_Field_Name__c,custMsg);
                                if(obj.equals(grpSegmntObj))
                                {
                                    failGrpIds.add(Id.valueof(recordDetails.substringBefore(sprtr)));
                                }
                            }
                        }
                        
                        if ( validationTyp.equalsIgnoreCase(isNotNull)  )
                        {
                            if( String.isNotBlank(actualfieldValue ) )
                            {
                                if(FieldcustmMsgMap.get(wfvalidation.GA_Field_Name__c) !=null)
                                {
                                    custMsg=FieldcustmMsgMap.get(wfvalidation.GA_Field_Name__c);
                                }
                                else
                                    custMsg=new list<string>();
                                if(!custMsg.contains(recordDetails +sprtr+wfvalidation.GA_Validation_Message__c+sprtr+actualFieldDtls))
                                    custMsg.add(recordDetails +sprtr+wfvalidation.GA_Validation_Message__c+sprtr+actualFieldDtls);
                                FieldcustmMsgMap.put(wfvalidation.GA_Field_Name__c,custMsg);
                                if(obj.equals(grpSegmntObj))
                                {
                                    failGrpIds.add(Id.valueof(recordDetails.substringBefore(sprtr)));
                                }
                            }
                        }
                        
                        if (validationTyp.equalsIgnoreCase(contains) )
                        {
                            
                            if(String.isNotBlank(actualfieldValue) && actualfieldValue.containsIgnoreCase(wfvalidation.GA_Validation_Value__c)   )
                            {
                                if(FieldcustmMsgMap.get(wfvalidation.GA_Field_Name__c) !=null)
                                {
                                    custMsg=FieldcustmMsgMap.get(wfvalidation.GA_Field_Name__c);
                                }
                                else
                                    custMsg=new list<string>();
                                if(!custMsg.contains(recordDetails +sprtr+wfvalidation.GA_Validation_Message__c+sprtr+actualFieldDtls))
                                    custMsg.add(recordDetails +sprtr+wfvalidation.GA_Validation_Message__c+sprtr+actualFieldDtls);
                                FieldcustmMsgMap.put(wfvalidation.GA_Field_Name__c,custMsg);
                                if(obj.equals(grpSegmntObj))
                                {
                                    failGrpIds.add(Id.valueof(recordDetails.substringBefore(sprtr)));
                                }
                            }
                        }
                        
                        if (validationTyp.equalsIgnoreCase(doesNotContain))
                        {
                            if( String.isNotBlank(actualfieldValue) && actualfieldValue.containsNone(wfvalidation.GA_Validation_Value__c)  )
                            {
                                if(FieldcustmMsgMap.get(wfvalidation.GA_Field_Name__c) !=null)
                                {
                                    custMsg=FieldcustmMsgMap.get(wfvalidation.GA_Field_Name__c);
                                }
                                else
                                    custMsg=new list<string>();
                                if(!custMsg.contains(recordDetails +sprtr+wfvalidation.GA_Validation_Message__c+sprtr+actualFieldDtls))
                                    custMsg.add(recordDetails +sprtr+wfvalidation.GA_Validation_Message__c+sprtr+actualFieldDtls);
                                FieldcustmMsgMap.put(wfvalidation.GA_Field_Name__c,custMsg);
                                if(obj.equals(grpSegmntObj))
                                {
                                    failGrpIds.add(Id.valueof(recordDetails.substringBefore(sprtr)));
                                }
                            }
                        }
                    }
                }
            } 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, method2);
        }
    }
    /**
@Description: fieldValidationWp() wrapper class 
@Name : fieldValidationWp
*/     
    public with sharing class fieldValidationWp
    {
        public string fieldNam;
        public list<GA_WFT_Validation__c> validationLst;
        
        /*************************************************************************************************************************************
@Description        :   fieldValidationWp() method 
@Name               :   fieldValidationWp
@Param              :   string fieldNamTmp, list<GA_WFT_Validation__c> validationLstTmp
*****************************************************************************************************************************************/ 
        public fieldValidationWp(string fieldNamTmp, list<GA_WFT_Validation__c> validationLstTmp)
        {
            fieldNam=fieldNamTmp;
            validationLst=validationLstTmp;
        }
    }
    /**
@Description: objFieldWap() wrapper class 
@Name : objFieldWap
*/
    public with sharing class objFieldWap{
        
        public string ObjNam;
        public list<fieldValidationWp> fieldVallst;
        /*************************************************************************************************************************************
@Description        :   objFieldWap() method 
@Name               :   objFieldWap
@Param              :   string ObjNamTmp,list<fieldValidationWp> fieldValTmplst
*****************************************************************************************************************************************/ 
        
        public objFieldWap(string ObjNamTmp,list<fieldValidationWp> fieldValTmplst)
        {
            ObjNam=ObjNamTmp;
            fieldVallst=fieldValTmplst;
        }
    }
}