@isTest
public with sharing class AccountTriggerTest {
    public AccountTriggerTest() {}

    @isTest static void TestInsertRecords()
    {
        List<Account> accList = new List<Account>();

        for(Integer i = 0; i<200 ; i++)
        {
            Account accounts = new Account(Name = 'Test'+i, BillingState = 'CA');
            accList.add(accounts);
        }

        Test.startTest();
        insert accList;
        Test.stopTest();

        List<Account> TestAccount = [ SELECT ShippingState FROM Account];
        System.assertEquals(200, TestAccount.size());
    }
}
