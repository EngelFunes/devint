/*****************************************************************************************
Class Name   : GA_Plan_PackageTrgrhndlr
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is trigger handler class for GA_Plan_Package__c insert/Update
******************************************************************************************/
public without sharing class GA_Plan_PackageTrgrhndlr {
    public static final String CLSNAM  ='GA_Plan_PackageTrgrhndlr';
    public static final String AFTERINSERT  ='afterinsert';
    public static final String AFTERUPDATE  ='afterupdate';
    
    /**
@Description: afterinsert() method 
@Name : afterinsert
@Param :list<GA_Plan_Package__c > plnPkgLst
@Return : N/A
@throws Exception : AuraHandledException;*/   
    public static void afterinsert(list<GA_Plan_Package__c > plnPkgLst)
    {
        try{     
            if(plnPkgLst.size()>0)
            {
                GA_ExternalAppealSrvcCls_NASCO.createExternalAppealRecordForNasco(plnPkgLst);
            }            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAM, AFTERINSERT); 
        }
    }
    /**
@Description: afterupdate() method 
@Name : afterupdate
@Param :list<GA_Plan_Package__c > plnPkgLst,map<id,GA_Plan_Package__c > plnPkgOldMap
@Return : N/A
@throws Exception : AuraHandledException;*/       
    public static void afterupdate(list<GA_Plan_Package__c > plnPkgLst,
                                   map<id,GA_Plan_Package__c > plnPkgOldMap)
    {
        try{
            if(plnPkgLst.size()>0)
            {
                GA_ExternalAppealRecdCrtnUpdt.reactivatePreviousEARecordNASCO(plnPkgLst, plnPkgOldMap);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAM, AFTERINSERT); 
        }
    }
}