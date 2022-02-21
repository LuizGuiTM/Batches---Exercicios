global with sharing class SummarizeOrderAmountBatch implements Database.Batchable<SObject>, Database.StateFul{
global SummarizeOrderAmountBatch() {}


    private AccountInfo accountInfo = null;
    global Database.QueryLocator start(Database.BatchableContext context)
    {
        String query = ' SELECT Account__c FROM ForecastSummary__c';
        System.debug(query);       

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext context, List<ForecastSummary__c> scope)
    {
        Set<Id> ids = new set<Id>();

        for (ForecastSummary__c inicial : scope)
        {
            ids.add(inicial.Account__c);

        }

    /*Map<Id,Order> mapOrder  = new Map<Id,Order>([
    SELECT AccountId
    FROM Order
    WHERE AccountId IN: ids
    ]);

    List<OrderItem> orderItemList = [
    SELECT Product2Id
    FROM OrderItem
    WHERE OrderId in :mapOrder.keySet()
    ];

    List<AggregateResult> listTotalAmount = [
        SELECT AccountId, SUM(TotalAmount)TotalAmount
        FROM Order
        WHERE AccountId IN: mapOrder.keySet()
        GROUP BY AccountId
    ];
    */

    List<AggregateResult> aggregateResultByAccountList = [
        SELECT AccountId, SUM(TotalAmount) TotalAmount
        FROM Order
        WHERE AccountId IN: ids
        GROUP BY AccountId
    ];

    List<AggregateResult> aggregateResultByAccountProductList = [
        SELECT OrderId, Product2Id
        FROM orderItem
        WHERE OrderId IN: ids
        GROUP BY  OrderId, Product2Id
    ];

//Preciso pegar o Produto do OrderItem e somar o total amount e accountid do order
    List<ForecastSummary__c> ForecastSummaryList = new  List<ForecastSummary__c>();

    for (AggregateResult accountResult : aggregateResultByAccountList) 
    {
        Decimal totalValue = (Decimal)(Decimal) accountResult.get('TotalAmount');
            ForecastSummaryList.add(new ForecastSummary__c(
                Key__c = (String) accountResult.get('AccountId'),
                RealizedValue__c = totalValue
            ));

            if(this.accountInfo == null || totalValue > this.accountInfo.Value)
            {
                this.accountInfo = new AccountInfo(
                    (String)accountResult.get('AccountId'),
                    totalValue
                );
        
             }
    }
        for(AggregateResult accountProductResult : aggregateResultByAccountList )
        {
            for(AggregateResult accountProductResult1 : aggregateResultByAccountProductList )
            {
            ForecastSummaryList.add(new ForecastSummary__c(
                Key__c = (String) accountProductResult.get('AccountId') + ' ' + (String)accountProductResult1.get('Product2Id'),
                RealizedValue__c = (Decimal) accountProductResult.get('TotalAmount')
            ));
            }
        }
    if(ForecastSummaryList.size() > 0)
    {
        upsert ForecastSummaryList ;
    }

}



    public class AccountInfo 
    {
        public Id AccountId {get; set;}
        public Decimal Value {get; set;}

        public AccountInfo( Id AccountId, Decimal value)
        {
            this.AccountId = accountId;
             this.Value = value;
         }
    }



global void finish(Database.BatchableContext context)
{
/*
Account account = [
SELECT Id, Name
FROM Account
WHERE Id =: this.accountInfo.AccountId
];

ForecastEmailNotification__c forecastEmailSettings = ForecastEmailNotification__c.getValues('ForecastAccountProduct');

Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
mail.setToAddresses(new List<String> {forecastEmailSettings.ToAddress__c
});
mail.setSubject(forecastEmailSettings.Subject__c);

String body = String.format(
'{0}. Account {1} had a total forecast of {2}',
new List<Object> {forecastEmailSettings.Body__c, account.Name, this.accountInfo.Value}
);
mail.setPlainTextBody(body);

Messaging.sendEmail(new List<Messaging.SingleEMailMessage>{mail});
*/
}

}

