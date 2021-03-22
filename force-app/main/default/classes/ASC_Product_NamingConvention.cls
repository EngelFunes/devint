/**
@Author : IDC Offshore
@Name: ASC_Product_NamingConvention
@CreatedDate:  26-Feb-2020 
@Description: ASC_Product_NamingConvention class is for generating Product Code Sequentially.
@version : 1.0  
*/
public class ASC_Product_NamingConvention {
    /*******************************************************************************************************************************
@Description        :   updtProductCode() method 
@Name               :   updtProductCode
@Param              :   list<Product2> prodList
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/    
    public static void updtProductCode(list<Product2> prodList){
        
        List<Product2> product2List = [Select Id, vlocity_ins__Type__c,ProductCode,CreatedDate from Product2 
                                       where vlocity_ins__Type__c ='ASC Product' order by createdDate desc];
        Integer sequence=000001;
        if(product2List != null && product2List.size()>0){
            for(integer i=0;i<product2List.size();i++){
                String productCode = product2List[i].ProductCode; 
                if(productCode != null && !productCode.equals('')){
                    productCode=productCode.substringAfterLast('_');
                }
                else{
                    productCode='';                    
                }                
                if(!productCode.equals('')){
                    sequence = integer.valueOf(productCode)+1;  
                    break;
                }
            }
        }
        for(Product2 eachProd : prodList){
            if(eachProd.vlocity_ins__Type__c !=null && eachProd.vlocity_ins__Type__c.equals('ASC Product') &&
               (eachProd.ProductCode ==null || eachProd.ProductCode.trim().equals('') || !eachProd.ProductCode.startsWith('ASC_'))){
                String productCodeSequence= String.valueOf(sequence);
                if(productCodeSequence.length() == 1){
                    eachProd.ProductCode='ASC_000000'+sequence;
                }
                else if(productCodeSequence.length()== 2){
                    eachProd.ProductCode='ASC_00000'+sequence;
                }
                else if(productCodeSequence.length()==3){
                    eachProd.ProductCode='ASC_0000'+sequence;
                }
                else if(productCodeSequence.length()==4){
                    eachProd.ProductCode='ASC_000'+sequence;
                }
                else if(productCodeSequence.length()==5){
                    eachProd.ProductCode='ASC_00'+sequence;
                }
                else if(productCodeSequence.length()==6){
                    eachProd.ProductCode='ASC_0'+sequence;
                }
                else{
                    eachProd.ProductCode='ASC_'+sequence;
                }                
                sequence = sequence+1;
            }
        }        
    }
}