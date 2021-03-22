/*****************************************************************************************
Class Name   : ARV_AP57_GetDependentPicklists 
Date Created : 9-Dec-2019
Created By   : IDC Offshore.
Description  :ARV_AP57_GetDependentPicklists. 
******************************************************************************************/
global without sharing class ARV_AP57_GetDependentPicklists implements vlocity_ins.VlocityOpenInterface2{ 
    public   Map<String, List<String>> controllingInfo;
    private static final string METHODNAME1  ='getDependentValPicklist';
    private static final string OBJECTNAME  ='Package__c';
    private static final string PARENTFIELD  ='ARV_CDH_Package_Combination__c';
    private static final string CHILDFIELD  ='ARV_CDH_Member_Combination__c';
    private static final string CHILDFIELD1  ='ARV_CDH_COMP_Combination__c';
    
    /*************************************************************************************************  
Method name : invokeMethod
Params     : map
Return Type : null
Description :this method is used to invoke the GetDependentPicklist method
******************************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options){           
                                    try{            
                                        if (methodName == METHODNAME1){
                                            getDependentValPicklist(input,output);
                                        }
                                    }catch(Exception e){
                                    }
                                    return true;
                                }
    /**************  
Method name : generateDocument
Params     : map
Return Type : null
Description :This generateDocument method is called from invoke method to call BAAG and SBC services.
*************/
    Global void getDependentValPicklist( Map<String, Object> input, Map<String, Object> output){
        getFieldDependencies(PARENTFIELD,CHILDFIELD);
        Map<String, List<String>> otp = new Map<String, List<String>>();
        Map<String, List<String>> otc = new Map<String, List<String>>();
        list<string> depPckValues = new list<string>();
        //string prntPickList = 'Dependent Care FSA';
        for(string prntPck: controllingInfo.keyset()){
            //depPckValues.addAll(controllingInfo.get(prntPck));
            //output.put(prntPck,controllingInfo.get(prntPck));
            otp.put(prntPck,controllingInfo.get(prntPck));
        }
        output.put('Regular',otp);
        getFieldDependencies(PARENTFIELD,CHILDFIELD1);
        for(string prntPck: controllingInfo.keyset()){
            otc.put(prntPck,controllingInfo.get(prntPck));
        }
        output.put('Comp',otc);
    }
    //By SharSolutions
    public class MyPickListInfo{
        public String validFor;
    }
    /**************  
Method name : getFieldDependencies
Params     : map
Return Type : null
Description :
*************/
    Public void getFieldDependencies(string pp,string cc){
        controllingInfo = new Map<String, List<String>>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(OBJECTNAME);
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(pp).getDescribe();
        Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(cc).getDescribe();
        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
        for(Schema.PicklistEntry currControllingValue : controllingValues){
            controllingInfo.put(currControllingValue.getLabel(), new List<String>());
        }
        for(Schema.PicklistEntry currDependentValue : dependentValues)
        {
            String jsonString = JSON.serialize(currDependentValue);
            MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);
            String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
            Integer baseCount = 0;
            for(Integer curr : hexString.getChars()){
                Integer val = 0;
                if(curr >= 65){
                    val = curr - 65 + 10;
                }
                else{
                    val = curr - 48;
                }
                if((val & 8) == 8){
                    controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
                }
                if((val & 4) == 4){
                    controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
                }
                if((val & 2) == 2){
                    controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
                }
                if((val & 1) == 1){
                    controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    
                }
                baseCount += 4;
            }            
        } 
    }
}