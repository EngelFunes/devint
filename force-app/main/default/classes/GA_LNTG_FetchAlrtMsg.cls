/**
@Author : Prasant Kumar Satpathy
@Name: GA_LNTG_FetchAlrtMsg 
@CreatedDate: 13 - Sep 2018 
@Description: GA_LNTG_FetchAlrtMsg class is fetching alert message in Account record page.
@version : 1.0  
*/
public with sharing class GA_LNTG_FetchAlrtMsg {
    public static final string ClsName  ='GA_LNTG_FetchAlrtMsg';
    public static final string methodNmegetAccntMsg  ='getMsgLst';
    public static final string ErrorMsg = 'Alert Message cant be fetched';
    public static final string excepSepartr = ' : ';
    /**
@Description: getMsgLst() method 
@Name : getMsgLst
@Param : string recId, string obj, string fieldAPInme
@Return : list<msgPosWrapcls>
@throws Exception : N/A;
*/    
   
    @AuraEnabled
    public static list<msgPosWrapcls> getMsgLst(string recId, string obj, string fieldAPInme){
        try{
            string msg='';
            list<msgPosWrapcls> msgLst=new list<msgPosWrapcls>();
            string qury='select '+fieldAPInme+' from '+obj+' where id=\''+recId+'\'';
            
            if(obj=='Account')
            {
                if(fieldAPInme != null && database.query(qury) != null && database.query(qury).size() > 0){                    
                string accType=string.valueof(database.query(qury)[0].get(fieldAPInme));
                if(accType !=null && accType.equals('POD'))
                {
                    msgLst.add(new msgPosWrapcls('This is a POD Account','top:11%;')); 
                    
                }
                list<GA_Alert_Messages__c> alrtmsgLst=[select id,GA_Message__c from GA_Alert_Messages__c where 
                                                       GA_Start_Date__c<=:system.today() 
                                                       and GA_End_Date__c>:system.today() and GA_Account__c=:recId limit 100]; 
                integer i=28;
                for(GA_Alert_Messages__c alrtMsg:alrtmsgLst)
                {
                    msgLst.add(new msgPosWrapcls(alrtMsg.GA_Message__c,'top:'+i+'%;'));
                    i=i+17;
                }
            }
            }
            else
            {
                msg=string.valueof(database.query(qury)[0].get(fieldAPInme));
                
                if(msg !=null)
                {
                    msg=  (string)database.query(qury)[0].get(fieldAPInme);
                    msgLst.add(new msgPosWrapcls(msg,'top:11%;'));   
                }
                
            }
            return msgLst;
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmegetAccntMsg);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    /*Wrapper Class to handle multiple alert message and its position*/
    public class msgPosWrapcls{
        @AuraEnabled
        public string msg;
        @AuraEnabled
        public string pos;
        public msgPosWrapcls(string msgTmp,string posTmp)
        {
            msg=msgTmp;
            pos=posTmp;
        }
    }
}