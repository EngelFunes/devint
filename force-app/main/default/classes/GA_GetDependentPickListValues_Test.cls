/**
@Author : IDC Offshore
@Name: GA_GetDependentPickListValues_Test
@CreatedDate: 8 - June 2018 
@Description: GA_GetDependentPickListValues_Test class is for GA_GetDependentPickListValues class.
@version : 1.0  
*/
@isTest(seealldata=false)
private class GA_GetDependentPickListValues_Test {

    private static testmethod void getDependentPicklistValuesTest() {
        Map<Object, List<String>> result = GA_GetDependentPickListValues.getDependentPicklistValues(Case.GA_SupportRequest_Type__c);
        System.debug(json.serialize(result));
    }
}