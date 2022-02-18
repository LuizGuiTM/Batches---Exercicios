global with sharing class SummarizeOrderAmountBatch implements Database.Batchable<SObject>, Database.StateFul{
    global SummarizeOrderAmountBatch() {}


    private AccountInfo accountInfo = null;
    global Database.QueryLocator start(Database.BatchableContext context)
    {
        String query = ' SELECT Key__c FROM ForecastSummary__c WHERE RealizedValue = 0';
        System.debug(query);       

       return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext context, List<ForecastSummary__c> scope)
    {

        Set<Id> ids = new set<Id>();

        for (ForecastSummary__c inicial : scope)
        {
            ids.add(inicial.key__c);

        }


        List<Order> orderList = [
            SELECT Status, AccountId, TotalAmount
            FROM Order
            WHERE AccountId IN: ids AND Status = 'Activated'
        ];
        
        Map<Id,Order> mapOrder  = new Map<Id,Order>([
            SELECT Status, AccountId, TotalAmount
            FROM Order
            WHERE AccountId IN: ids AND Status = 'Activated'
        ]);

        //VIctor
        List<OrderItem> orderItemList = [
            SELECT Product2Id
            FROM OrderItem
            WHERE OrderId in :mapOrder.keySet()
        ];

        //Victor
        /*
        List<OrderItem> orderItemList = [
            SELECT Order.Status, Order.AccountId, Order.TotalAmount, Product2Id
            FROM OrderItem
            WHERE Order.AccountId IN: ids AND Order.Status = 'Activated'
        ]);
        */

        for (OrderItem orderItemIt : orderItemList) {

            ForecastSummaryList.add(new ForecastSummary__c(
                Key__c = (String) orderItemIt.Order.AccountId,
                RealizedValue__c = (Decimal) orderItemIt.Order.TotalAmount,
                Product__c = orderItemIt.Product2Id
            ));

            
        }


        List<AggregateResult> aggregateResultByAccountList = [
            SELECT Id, Account__c
            FROM Forecast__c
            WHERE Account__c IN: ids
            GROUP BY Account__c, Id
        ];

        List<AggregateResult> aggregateResultByAccountProductList = [
            SELECT Id, Account__c,Product__c
            FROM Forecast__c
            WHERE Account__c IN: ids
            GROUP BY Account__c, Product__c, Id
        ];

        
        List<ForecastSummary__c> ForecastSummaryList = new  List<ForecastSummary__c>();

       
        for(Order order : mapOrder.Values() )
        {
               
            
        }

        for(Order order : OrderList )
        {
                ForecastSummaryList.add(new ForecastSummary__c(
                Key__c = (String) order.get('AccountId'),
                RealizedValue__c = (Decimal) order.get('totalAmount')
            ));
            
        }


        for(AggregateResult accountProductResult : aggregateResultByAccountProductList )
        {
            ForecastSummaryList.add(new ForecastSummary__c(
                Key__c = (String) accountProductResult.get('Account__c') + ' ' + (String)accountProductResult.get('Product__c'),
                Value__c = (Decimal) accountProductResult.get('Value__c')
            ));
        }

        update ForecastSummaryList RealizedValue__c;
        
    }


    public class AccountInfo {
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
            new List<Object> {forecastEmailSettings.Body__c, account.Name, this.accountInfo.RealizedValue__c}
        );
        mail.setPlainTextBody(body);

        Messaging.sendEmail(new List<Messaging.SingleEMailMessage>{mail});

    }

}
}
