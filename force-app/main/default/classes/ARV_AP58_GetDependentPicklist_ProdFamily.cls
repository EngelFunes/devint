/*****************************************************************************************
Class Name   : ARV_AP58_GetDependentPicklist_ProdFamily 
Date Created : 17-Dec-2019
Created By   : IDC Offshore.
Description  :ARV_AP58_GetDependentPicklist_ProdFamily. 
******************************************************************************************/
global without sharing class ARV_AP58_GetDependentPicklist_ProdFamily implements vlocity_ins.VlocityOpenInterface2{ 
    public   Map<String, List<String>> controllingInfo;
     private static final string METHODNAME1  ='getDependentValPicklist2';
    private static final string OBJECTNAME  ='QuoteLineItem';
    private static final string PARENTFIELD  ='ARV_Product_Family__c';
    private static final string CHILDFIELD  ='ARV_CDH_Package_Combinations__c';

    /*************************************************************************************************  
Method name : invokeMethod
Params     : map
Return Type : null
Description :this method is used to invoke the GetDependentPicklist method
******************************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> input, 
                                Map<String,Object> output, Map<String,Object> options) 
    {           
        
        
        try{            
            if (methodName == METHODNAME1) 
            {
                getDependentValPicklist2(input,output);
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
    Global void getDependentValPicklist2( Map<String, Object> input, Map<String, Object> output){
        getFieldDependencies2();
        list<string> depPckValues = new list<string>();
        //string prntPickList = 'Dependent Care FSA';
        for(string prntPck: controllingInfo.keyset()){
            //depPckValues.addAll(controllingInfo.get(prntPck));
            output.put(prntPck,controllingInfo.get(prntPck));
       }
        //output.put('cdhchildnames',controllingInfo);
        system.debug('output..'+output);
    }
    //By SharSolutions
    public class MyPickListInfo
    {
        public String validFor;
    }
      /**************  
Method name : getFieldDependencies2
Params     : map
Return Type : null
Description :
*************/
    Public void getFieldDependencies2()
    {
        controllingInfo = new Map<String, List<String>>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(OBJECTNAME);
        
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(PARENTFIELD).getDescribe();
        Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(CHILDFIELD).getDescribe();
        
        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
        
        for(Schema.PicklistEntry currControllingValue : controllingValues)
        {
            controllingInfo.put(currControllingValue.getLabel(), new List<String>());
        }
        
        for(Schema.PicklistEntry currDependentValue : dependentValues)
        {
            String jsonString = JSON.serialize(currDependentValue);
            
            MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);
            
            String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
            
            
            Integer baseCount = 0;
            
            for(Integer curr : hexString.getChars())
            {
                Integer val = 0;
                
                if(curr >= 65)
                {
                    val = curr - 65 + 10;
                }
                else
                {
                    val = curr - 48;
                }
                
                if((val & 8) == 8)
                {
                    controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
                }
                if((val & 4) == 4)
                {
                    controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
                }
                if((val & 2) == 2)
                {
                    controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
                }
                if((val & 1) == 1)
                {
                    controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    
                }
                
                baseCount += 4;
            }            
        } 
    }
    
    
}