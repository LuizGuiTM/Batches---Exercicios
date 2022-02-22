public with sharing class AccountTriggerHandler {
    public AccountTriggerHandler() {}

    public static void CreateAccounts (List<Account> accountList)
    {
        for (Account acc : accountList)
        {
            acc.ShippingState = acc.BIllingState;
        }
    }
}
