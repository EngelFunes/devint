//This class avoids recursive trigger.
public Class GA_CheckRecursive{
    public static boolean run = true;
    public static boolean runOnce(boolean RunTest){
        if(RunTest)  {
            if(run){
                run=false;
                return true;
            }else{
                return run;
            }
        }
        else{
           return false; 
        }
    }
}