global with sharing class CloseOpportunityBatch implements Database.Batchable<sObject> {
    global CloseOpportunityBatch() {}

        global Database.QueryLocator start(Database.BatchableContext bc)
    {
        system.debug('start');
        Datetime baseDate = System.today().addDays(-15);
        String query = 'SELECT id FROM Opportunity WHERE StageName IN (\'Prospecting\', \'Qualification\') AND CreatedDate <=: baseDate';
        System.debug(query);

        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext bc, List<Opportunity> scope)
    {
        system.debug('execute');
        for (Opportunity opp : scope){
            system.debug(opp.id);
            opp.StageName = 'Closed Lost';
            opp.Description = label.ClosedOpportunityDescription;
        }
        update scope;
    }

    global void finish (Database.BatchableContext bc)
    {
        //code
    }
}
