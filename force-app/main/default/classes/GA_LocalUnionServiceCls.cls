/*****************************************************************************************
Class Name   : GA_LocalUnionServiceCls
Date Created : 4/18/2018
Created By   : IDC Offshore
Description  : 1. This class is to restrict the creation of Local union record

Change History : 
******************************************************************************************/
public class GA_LocalUnionServiceCls {
    public static boolean isExecuting=false;
    public static final string ClsName  ='GA_LocalUnionServiceCls';
    public static final string methodNmeUnionRel  ='unionRelatnshp';
    public static final string unionRelErrMsg = 'Could not create Local Union :';
      /****************************************************************************************************
Method Name : unionReprsntatn
Parameters  : list<GA_Union_Representation__c> lclUnList
Return type : NA
Description : To update ownere details 
******************************************************************************************************/
    public static void unionReprsntatn(list<GA_Union_Representation__c> lclUnList)
    {
        try{
            for(GA_Union_Representation__c lclUn: lclUnList)
            {
                lclUn.GA_UnionAccOwner__c =   lclUn.GA_UnionOwner__c;
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeUnionRel);
            lclUnList[0].adderror(unionRelErrMsg);
        }
    }
}