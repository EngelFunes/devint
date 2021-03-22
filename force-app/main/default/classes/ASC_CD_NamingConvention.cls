/**
@Author : IDC Offshore
@Name: ASC_CD_NamingConvention
@CreatedDate:  18-Feb-2020 
@Description: ASC_CD_NamingConvention class is for concatenation with Sequence numeber
@version : 1.0  
*/

public class ASC_CD_NamingConvention {
    
    public static void updtContractDocName(list<ASC_Contractual_Document__c> cdLst,map<id,ASC_Contractual_Document__c> cdoldMap){
        
        Boolean isChange= false;
        Set<id> contractIds = new Set<id>();
        for(ASC_Contractual_Document__c cd :cdLst){            
            String contract = cd.ASC_Contract__c;            
            contractIds.add(contract);      
            if(cdoldMap !=null)
                {
                    ASC_Contractual_Document__c cdOld=cdoldMap.get(cd.Id);
                    if((cdOld.ASC_Document_Type__c !=cd.ASC_Document_Type__c)){
                        isChange=true;     
                    }
                }
            else
            {
                isChange=true;
            }
            
        }
        
        Map<ID,String> contractNumberMap = new Map<ID,String>();   
        Map<ID,Contract> contractIdMap = new Map<ID,Contract>();
        
        if(contractIds !=null)
        {
            contractIdMap = new Map<ID,Contract>([Select Id, ContractNumber,ASC_Carrier__c from Contract where Id in :contractIds 
                                                  Limit :UTIL_SLB.retrieveQueryLimitValue()]);
            for(Contract sno: contractIdMap.values()){
                contractNumberMap.put(sno.Id,sno.ContractNumber+'_'+sno.ASC_Carrier__c);
            }            
            
            for(ASC_Contractual_Document__c cd :cdLst){            
                String contractNumber = contractNumberMap.get(cd.ASC_Contract__c);
                String documentType= cd.ASC_Document_Type__c;
                
               if(isChange){           
                cd.Name=contractNumber+'_'+documentType;            
               }
            }
        }      
    }  
}