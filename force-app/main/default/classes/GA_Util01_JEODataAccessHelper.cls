/**
@Author : Prasant Kumar Satpathy
@Name: GA_Util01_JEODataAccessHelper
@CreatedDate: 24- Jul 2017 
@Description: GA_Util01_JEODataAccessHelper class is for creating/updating task whenever Assigned To field in jeopardy record 
is changed
@version : 1.0  
*/
public with sharing class GA_Util01_JEODataAccessHelper {
    public static final String successVal = 'Success';
    public static final string ErrorMsg = 'Unable to Create/Update task';
    public static final string ClsName  ='GA_Util01_JEODataAccessHelper';
    public static final string methodNme  ='createUpdateTsk';
    /*
@Description: ValidateException
@Name : ValidateException
@Param : none
@Return : void
@throws Exception : N/A;
*/ 
    public with sharing class ValidateException extends Exception {}
    /**
@Description: createUpdateTsk() method 
@Name : createUpdateTsk
@Param : list<task> tskLsttoCreate,list<task> tskLsttoUpdte
@Return : void
@throws Exception : throws exception when insert or update of tasks fails;
*/ 
    public static string createUpdateTsk(list<task> tskLsttoCreate,list<task> tskLsttoUpdte)
    {
        try
        {
            if(tskLsttoCreate.size()>0)
            {
                Database.Insert(tskLsttoCreate,false);
            }
            if(tskLsttoUpdte.size()>0)
            {
                Database.update(tskLsttoUpdte,false);
            }  
            return successVal;
        }
        catch(exception e)
        {
            throw new ValidateException(ErrorMsg, e);
        }
        
    }
    
}