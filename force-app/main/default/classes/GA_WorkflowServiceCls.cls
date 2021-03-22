/*********************************************************************************************************************************************
@Author :IDC offshore
@Name: GA_WorkflowServiceCls
@CreatedDate: 31 - Jul 2017 
@Description: GA_WorkflowServiceCls class is for workflow field updates
@version : 1.0  
**********************************************************************************************************************************************/
public without sharing class GA_WorkflowServiceCls {
    public static boolean isExecuting=false;
    public Static Final string CLSNAME  ='GA_WorkflowServiceCls';
    public Static Final string  METHODNMEWRKFLW ='Workflow';
    public Static Final string  WRKFLWERRMSG = 'Could not create Workflow :';
    public static final String DATEFRMT ='MMMM, YYYY';
    public static final String HYPHN = '-';
    public static final String COMMA = ',';
/**
@Description: wrkflw() method 
@throws Exception : N/A;
*/     
    public static void wrkflw(list<GA_WF_Workflow__c> wfList)
    {
        try{
            set<string> grpSegmentids=new set<string>();
            for(GA_WF_Workflow__c wf: wfList)
            {
                wf.GA_ABR_Specialist_Email__c = wf.GA_ABR_Specialist_Email_Frml__c;
                wf.GA_Associated_Case_Creator_Email__c = wf.GA_Associated_Case_Creator_Email_Frml__c;
                wf.Name =  wf.GA_Type__c + HYPHN + wf.Sub_Type__c + HYPHN +Datetime.now().format( DATEFRMT);
                if(wf.GA_Selected_Group_Segments__c <> null){
                   grpSegmentids.addall(wf.GA_Selected_Group_Segments__c.split(COMMA)); 
                      wf.GA_Number_of_Group_Suffixes__c = grpSegmentids.size();
                }
              
                 
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEWRKFLW);
            wfList[0].adderror(WRKFLWERRMSG);
        }
    }
}