@isTest
private class TestCreatePDF {

    public static String TEST_ACCOUNT_NAME = 'Test Name';
    public static String INVALID_GENERATE_FIELD = 'Expected CreatePDF__c field to be false.';
    public static String IVALID_ATTACHMENTS_AMOUNT = 'Actual amount of attachments does not equal to expected.';

    @TestSetup
    public static void makeData(){
        Account account = new Account(Name = TEST_ACCOUNT_NAME);
        insert account;
    }

    @isTest
    public static void testCreatePdfField() {
        Account account = [SELECT Id, CreatePDF__c FROM Account LIMIT 1];
        account.CreatePDF__c = true;

        Test.startTest();
        update account;
        Test.stopTest();

        Account resultAccount = [SELECT Id, CreatePDF__c FROM Account WHERE Id = :account.Id];
        System.assertEquals(false, resultAccount.CreatePDF__c, INVALID_GENERATE_FIELD);
    }

    @isTest
    public static void testCreatePdf(){
        List<Account> accounts = [SELECT Id, CreatePDF__c FROM Account];
        List<Id> accountIds = new List<Id>();
        for(Account acc: accounts){
            accountIds.add(acc.Id);
        }

        Test.startTest();
        TriggerHelper generatingJob = new TriggerHelper(accountIds);
        ID jobID = System.enqueueJob(generatingJob);
        Test.stopTest(); 
    
        List<Attachment> attachments = [SELECT Id FROM Attachment WHERE ParentId = :accounts[0].id];
        System.assertEquals(1, attachments.size(), IVALID_ATTACHMENTS_AMOUNT);
    }
}
