/**
@Author : Prasant
@Name: GA_AP_FetchDocstarAttbt
@CreatedDate: 3/15/2018
@Description: GA_AP_FetchDocstarAttbt class is for fetching docstar files.
@version : 1.0  
*/
public with sharing class GA_AP_FetchDocstarAttbt {
    public static final string ClsName  ='GA_AP_FetchDocstarAttbt';
    public static final string methodName  ='fetchattbt';
    public static final string methodName1  ='prepareData';
    
    /**
@Description: fetchattbt() method 
@Name : fetchattbt
@Param : string currId,string objNme   
@Return : retrnIdMsgWrap
@throws Exception : N/A;
*/ 
    public static retrnIdMsgWrap fetchattbt(string currId,string objNme)
    {
        try{
            list<Docstar_Config__mdt> docstrConfigLst=[select id,GA_File_Name__c,GA_Filter_Content_Attributes__c,GA_Field_API_Name__c,GA_Input_Name__c,GA_Data_Map_Name__c,GA_Obj_Name__c,GA_Error_Message__c from Docstar_Config__mdt where GA_Obj_Name__c=:objNme limit 1];
            string qStng;
            string atbtVal;
            string dtaNms;
            string inpNms;
            string errMsgs;
            if(docstrConfigLst.size()>0)
                qStng='select '+docstrConfigLst[0].GA_Field_API_Name__c+' from '+docstrConfigLst[0].GA_Obj_Name__c+' where id=\''+currId+'\'';
            list<sobject> objLst=database.query(qStng);
            for(sobject obj:objLst)
            {
                list<string> fieldapis=docstrConfigLst[0].GA_Field_API_Name__c.split(',');
                list<string> inpNmes=docstrConfigLst[0].GA_Input_Name__c.split(',');
                list<string> DataMpNms=docstrConfigLst[0].GA_Data_Map_Name__c.split(',');
                list<string> errMsgVals=docstrConfigLst[0].GA_Error_Message__c.split('~');
                integer i=0;
                for(string fieldapi:fieldapis)
                {
                    
                    if(i==0)
                    {
                        atbtVal=string.valueOf(obj.get(fieldapi));  
                    }
                    else
                        atbtVal=atbtVal+'~'+string.valueOf(obj.get(fieldapi));   
                    i++;
                }
                inpNms=prepareData(inpNmes);
                dtaNms=prepareData(DataMpNms);
                errMsgs=prepareData(errMsgVals);
            }
            retrnIdMsgWrap retnWrp=new retrnIdMsgWrap(atbtVal,inpNms,dtaNms,errMsgs,
                                                      docstrConfigLst[0].GA_Filter_Content_Attributes__c,
                                                      docstrConfigLst[0].GA_File_Name__c);
            return retnWrp;
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName);
        }
        return null;
    }
        /**
@Description: prepareData() method 
@Name : prepareData
@Param : list<string> recLst   
@Return : string
@throws Exception : N/A;
*/ 
    public static string prepareData(list<string> recLst)
    {
        try{
            string recVal;
            integer i=0;
            for(string rec:recLst)
            {
                
                if(i==0)
                {
                    recVal=rec;  
                }
                else
                    recVal=recVal+'~'+rec;   
                i++;
            }
            return recVal;
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName);
        }
        return null;
    }
    public class retrnIdMsgWrap
    {
        @AuraEnabled
        public string retnId;
        @AuraEnabled
        public string inpNm;
        @AuraEnabled
        public string DtaMpNm;
        @AuraEnabled
        public string errMsg;
         @AuraEnabled
        public string cntFltrAttbt;
         @AuraEnabled
        public string filenme;
        public retrnIdMsgWrap(string retnIdTmp,string inpNmTmp,string DtaMpNmTmp,string errMsgTmp,
                             string cntFltrAttbtTmp,string filenmeTmp)
        {
            retnId=retnIdTmp;
            inpNm=inpNmTmp;
            DtaMpNm=DtaMpNmTmp;
            errMsg=errMsgTmp;  
            cntFltrAttbt=cntFltrAttbtTmp;
            filenme=filenmeTmp;
        }
    }
}