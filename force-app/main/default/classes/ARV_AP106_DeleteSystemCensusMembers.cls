global without sharing  class ARV_AP106_DeleteSystemCensusMembers implements vlocity_ins.VlocityOpenInterface { 
    public static final string MTHD_DELETECENSUSMEMBERS='deleteCensusMembers';
    private static String contractId;
    private static String systemCensusId;
    Private Static Final String CONTRACTIDVAR='contractId';
    Private Static Final String CUNSUSIDVAR='censusId';
    
    /*****************************************************************************************
    Method Name : invokeMethod. 
    Date Created : 08-FEB-2021
    Created By   : IDC Offshore
    Description  :This is the class for deleting System census members whose end date is less than contract start date
    *******************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options){           
        Boolean success = true;
        try{
            if (MTHD_DELETECENSUSMEMBERS.equals(methodName)){ 
                deleteCensusMembers(input,output,options);
            }
        }catch(Exception e){
            //system.debug('getMessage @@ '+e.getMessage());
        }
        return success;
    }
    
    global void deleteCensusMembers(Map<String, Object> inputMap,Map < String, Object > outMap, 
                                         Map < String, Object > options){
        contractId = (String)options.get(CONTRACTIDVAR);
        systemCensusId = (String)options.get(CUNSUSIDVAR);
        ARV_GWC_CloneGroupSegments.deleteCensusMembers(systemCensusId, contractId);
    }    
    
}