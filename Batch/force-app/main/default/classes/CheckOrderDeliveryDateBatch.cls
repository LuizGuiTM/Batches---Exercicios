global with sharing class CheckOrderDeliveryDateBatch implements DataBase.Batchable<SObject> {
    global CheckOrderDeliveryDateBatch() {}

    global Database.QueryLocator start(Database.BatchableContext context)
    {

        Date todayDate = System.today();

        String query = ' SELECT Id, Account.Email__c, OrderNumber, EmailSent__c, OrderDelivered__c FROM Order WHERE DeliveryDate__c =: todayDate ';

        System.debug(query);
        return DataBase.getQueryLocator(query);

    }


    global void execute(Database.BatchableContext context, List<Order> scope)
    {

        List<Messaging.SingleEmailMessage> emailMessageList = new List<Messaging.SingleEmailMessage>();
        OrderEmailNotification__c deliveredOrderSettings = OrderEmailNotification__c.getValues('DeliveredOrder');
        OrderEmailNotification__c undeliveredOrderSettings = OrderEmailNotification__c.getValues('UndeliveredOrder');

        for (Order order : scope)
        {
            if(order.OrderDelivered__c)
            {
                emailMessageList.add(generateEmailMessage(
                    new List<String> {order.Account.Email__c},
                    deliveredOrderSettings.Subject__c + ' - ' + order.OrderNumber,
                    deliveredOrderSettings.Body__c
                ));
            }
            else 
            {
                emailMessageList.add(generateEmailMessage(
                    new List<String> {order.Account.Email__c},
                    undeliveredOrderSettings.Subject__c + ' - ' + order.OrderNumber,
                    undeliveredOrderSettings.Body__c
                ));
            }

            order.EmailSent__c = true;
        }

        Messaging.sendEmail(emailMessageList);
        update scope;
    }

    global Messaging.SingleEmailMessage generateEmailMessage(List<String> toAddresses, String subject, String body)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);

        return mail;
    }

    global void finish (Database.BatchableContext context)
    {
        OrderEmailNotification__c EmailNotificationSettings = OrderEmailNotification__c.getValues('EmailNotification');

        Messaging.SingleEmailMessage mail = generateEmailMessage(
            new List <String> {EmailNotificationSettings.ToAddress__c},
            EmailNotificationSettings.Subject__c,
            EmailNotificationSettings.Body__c
        );
        Messaging.sendEmail(new List <Messaging.SingleEmailMessage> {mail});
    }
}
