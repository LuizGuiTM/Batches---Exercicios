public with sharing class ExampleExecuteBatch {
    public ExampleExecuteBatch() {

    }


    public void ExecuteBatchExemplo()
    {
        SchedulerCloseOpportunityBatch schClass = new SchedulerCloseOpportunityBatch();
        String conExpression = '0 0  * * * ?';
        String conExpression2 = '0 30  * * * ?';
        String jobId = system.schedule('Close Opportunity JOb 00 Apex', conExpression , schClass);
        String jobId2 = system.schedule('Close Opportunity JOb 01 Apex', conExpression2 , schClass);
        System.debug(jobId);
        System.debug(jobId2);
    }
}
