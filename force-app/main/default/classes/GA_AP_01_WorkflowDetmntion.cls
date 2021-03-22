/*****************************************************************************************
Class Name   : GA_AP_01_WorkflowDetmntion
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is class or determination of the workflows. 
******************************************************************************************/
public with sharing class GA_AP_01_WorkflowDetmntion {
    public static final string selectQuery='Select id,GA_File_Type__c,GA_Carrier__c,GA_Method__c,GA_Process_Subtype__c,GA_Process_Type__c from GA_WFT_workflow__c where ';
    public static final string whereClause1='GA_Process_Type__c= ';
    public static final string whereClause2=' and GA_Process_Subtype__c= ';
    public static final string whereClause3=' and GA_Method__c= ';
    public static final string whereClause4=' and GA_Carrier__c= ';
    public static final string limitClause=' limit 1';
    // public static final string WFSTselectQuery='Select id,Name,GA_Sequence__c,GA_WFT_Inventory_Step_ID__c,GA_WFT_Workflow_ID__c from GA_WFT_Step__c where ';
    public static final string WFSTselectQuery='Select id,Name,GA_WFT_Inventory_Step_ID__c,GA_WFT_Workflow_ID__c, GA_WFT_Inventory_Step_ID__r.Name,GA_First_Step__c from GA_WFT_Step__c where ';
    
    public static final string WFSTwhereClause1='GA_WFT_Workflow_ID__c in ';  
    //public static final string WFSTwhereClause2=' and GA_Sequence__c= '; 
    //public static final string seqVal='1';
    
    public static final string WFSTwhereClause2=' and GA_WFT_Inventory_Step_ID__r.Name= '; 
     public static final string WFSTwhereClause3=' and GA_First_Step__c= true'; 
    public static final string stepName='Pre-Processing';
    
    public static final string WFSTlimitClause=' limit 1';
    public static final string StatVal='Status';
    public static final string SuccssVal='true';
    public static final string idVal='Id';
    public static final string errVal='false';
    public static final String ErrMsg = 'Could not perform the actions :';
    public static final String ClsName  ='GA_AP_01_WorkflowDetmntion';
    public static final String method1  ='getreltedwfStep';
    public static final String method2  ='insertWfRec';
    public static final String method3  ='getreltedwfTemplate';
    public static final String method4  ='getRelatedFirstWFStep';
    //To return first step for the workflow by calling getreltedwfStep method.
    /**
@Description: getreltedwfStep() method 
@Name : getreltedwfStep
@Param :string prcssType,string prcssSubtype, string method, string carrier
@Return : GA_WFT_Step__c
@throws Exception : AuraHandledException;
*/   
    @AuraEnabled
    public static GA_WFT_Step__c getreltedwfStep(string prcssType,string prcssSubtype, string method, string carrier)
    {
        try{
            String prcssTypeString = GA_Util08_FilterProcessHelper.FltrString(prcssType);
            String prcssSubtypeString = GA_Util08_FilterProcessHelper.FltrString(prcssSubtype);
            String methodString = GA_Util08_FilterProcessHelper.FltrString(method);
            String carrierString = GA_Util08_FilterProcessHelper.FltrString(carrier);
            list<GA_WFT_workflow__c> wrFlowLst=GA_Util14_WFTmpltDataAccesHelper.fetchwrkflowTmpsMap(selectQuery, 
                                                                                                    whereClause1+prcssTypeString+
                                                                                                    whereClause2+prcssSubtypeString+
                                                                                                    whereClause3+methodString+
                                                                                                    whereClause4+carrierString, 
                                                                                                    GA_Util14_WFTmpltDataAccesHelper.BLANK, 
                                                                                                    limitClause).values();
            if(wrFlowLst.size()>0)
            {
                set<id> curridSet=new set<id>();
                curridSet.add(wrFlowLst[0].id);
                string wftIdString=GA_Util08_FilterProcessHelper.idSet(curridSet);
                String StepNameString = GA_Util08_FilterProcessHelper.FltrString(stepName);
                list<GA_WFT_Step__c> wkstepTmpLst=GA_Util14_WFStepTmpltDataAccesHelper.fetchwrkflowStpTmpsMap(WFSTselectQuery, 
                                                                                                              WFSTwhereClause1+wftIdString+
                                                                                                              WFSTwhereClause2+StepNameString, 
                                                                                                              GA_Util14_WFStepTmpltDataAccesHelper.BLANK, 
                                                                                                              WFSTlimitClause).values();
                if(wkstepTmpLst.size()>0)
                    return wkstepTmpLst[0]; 
                else
                    return null;
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, method1);
        }
        return null;
    }
    //	To save workflow record by calling insertWfRec method from JS controller.
    /**
@Description: insertWfRec() method 
@Name : insertWfRec
@Param :GA_WF_Workflow__c wfRec
@Return : map<string,string>
@throws Exception : AuraHandledException;
*/   
    @AuraEnabled 
    public static map<string,string> insertWfRec(GA_WF_Workflow__c wfRec)
    {
        try{
            list<GA_WF_Workflow__c> wfRecLst=new list<GA_WF_Workflow__c>();
            wfRecLst.add(wfRec);
            list<GA_WF_Workflow__c> wfRecLstLstInsrt=GA_Util03_WrkflwDataAccessHelper.dmlOnwrkflw(wfRecLst,GA_Util03_WrkflwDataAccessHelper.INSERT_OPERATION);
            map<string,string> svReslts = new map<string,string>();
            if (wfRecLstLstInsrt !=null ) {
                if(wfRecLstLstInsrt.size()>0)
                {
                    svReslts.put(StatVal,SuccssVal);
                    svReslts.put(idVal,wfRecLstLstInsrt[0].id); 
                }
                
            }
            else {
                svReslts.put(StatVal,errVal);
            }
            return svReslts;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, method2);
            return null;
        }
    }
    
    
    //added by srinivas sattoor
    //to-do rename the method correctly. This method will return the template.
    /**
@Description: getreltedwfTemplate() method 
@Name : getreltedwfTemplate
@Param :string prcssType,string prcssSubtype, string method, string carrier
@Return : GA_WFT_workflow__c
@throws Exception : AuraHandledException;
*/   
    public static GA_WFT_workflow__c getreltedwfTemplate(string prcssType,string prcssSubtype, string method, string carrier)
    {
        try{
            String prcssTypeString = GA_Util08_FilterProcessHelper.FltrString(prcssType);
            String prcssSubtypeString = GA_Util08_FilterProcessHelper.FltrString(prcssSubtype);
            String methodString = GA_Util08_FilterProcessHelper.FltrString(method);
            String carrierString = GA_Util08_FilterProcessHelper.FltrString(carrier);
            list<GA_WFT_workflow__c> wrFlowLst=GA_Util14_WFTmpltDataAccesHelper.fetchwrkflowTmpsMap(selectQuery, 
                                                                                                    whereClause1+prcssTypeString+
                                                                                                    whereClause2+prcssSubtypeString+
                                                                                                    whereClause3+methodString+
                                                                                                    whereClause4+carrierString, 
                                                                                                    GA_Util14_WFTmpltDataAccesHelper.BLANK, 
                                                                                                    limitClause).values();
            
            if(wrFlowLst.size() > 0){
                return wrFlowLst[0];
            }else{
                return null;
            } 
        }  
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, method3);
            return null;
        }
    }// end of getreltedwfTemplate
    
    //added by srinivas sattoor
    //to-do rename the method correctly. This method will return the first step for the template.
    /**
@Description: getRelatedFirstWFStep() method 
@Name : getRelatedFirstWFStep
@Param :GA_WFT_workflow__c objWorkflowTemplate
@Return : GA_WFT_Step__c
@throws Exception : AuraHandledException;
*/   
    public static GA_WFT_Step__c getRelatedFirstWFStep(GA_WFT_workflow__c objWorkflowTemplate)
    {
        try{
            if(!string.isBlank(objWorkflowTemplate.Id))
            {
                set<id> curridSet=new set<id>();
                curridSet.add(objWorkflowTemplate.Id);
                string wftIdString=GA_Util08_FilterProcessHelper.idSet(curridSet);
                // String SeqValString = GA_Util08_FilterProcessHelper.FltrString(SeqVal);
                String StepNameString = GA_Util08_FilterProcessHelper.FltrString(stepName);
                list<GA_WFT_Step__c> wkstepTmpLst=GA_Util14_WFStepTmpltDataAccesHelper.fetchwrkflowStpTmpsMap(WFSTselectQuery, 
                                                                                                              WFSTwhereClause1+wftIdString+
                                                                                                             WFSTwhereClause3  , //WFSTwhereClause2+StepNameString, -- fetching based on first step check box
                                                                                                              GA_Util14_WFStepTmpltDataAccesHelper.BLANK, 
                                                                                                              WFSTlimitClause).values();
                if(wkstepTmpLst.size()>0)
                    return wkstepTmpLst[0]; 
                else
                    return null;
            }
            return null;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, method4);
            return null;
        }
    }// end of getRelatedFirstWFStep
    /**
@Description: getRelatedFirstWFStepABR() method 
@Name : getRelatedFirstWFStepABR
@Param :GA_WFT_workflow__c objWorkflowTemplate,string stepNameTmp
@Return : GA_WFT_Step__c
@throws Exception : AuraHandledException;
*/   
    public static GA_WFT_Step__c getRelatedFirstWFStepABR(GA_WFT_workflow__c objWorkflowTemplate,string stepNameTmp)
    {
        try{
            if(!string.isBlank(objWorkflowTemplate.Id))
            {
                set<id> curridSet=new set<id>();
                curridSet.add(objWorkflowTemplate.Id);
                string wftIdString=GA_Util08_FilterProcessHelper.idSet(curridSet);
                // String SeqValString = GA_Util08_FilterProcessHelper.FltrString(SeqVal);
                String StepNameString = GA_Util08_FilterProcessHelper.FltrString(stepNameTmp);
                list<GA_WFT_Step__c> wkstepTmpLst=GA_Util14_WFStepTmpltDataAccesHelper.fetchwrkflowStpTmpsMap(WFSTselectQuery, 
                                                                                                              WFSTwhereClause1+wftIdString+
                                                                                                              WFSTwhereClause2+StepNameString, 
                                                                                                              GA_Util14_WFStepTmpltDataAccesHelper.BLANK, 
                                                                                                              WFSTlimitClause).values();
                if(wkstepTmpLst.size()>0)
                    return wkstepTmpLst[0]; 
                else
                    return null;
            }
            return null;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, method4);
            return null;
        }
    }// end of getRelatedFirstWFStep
}