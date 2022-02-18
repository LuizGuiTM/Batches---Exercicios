public with sharing class SchedulerCloseOpportunityBatch implements Schedulable {
    public SchedulerCloseOpportunityBatch() {}

        public void execute (SchedulableContext context)
        {

            CloseOpportunityBatch batch = new CloseOpportunityBatch();

            DataBase.executeBatch(batch, 100);
        }
    
}
