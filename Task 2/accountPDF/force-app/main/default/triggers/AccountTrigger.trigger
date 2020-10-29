trigger AccountTrigger on Account (after update) {
    List<Id> accountsId = new List<Id>();

    for (Account account : Trigger.new) {
        if(account.CreatePDF__c) {
            accountsId.add(account.Id);
        }
    }

    if(accountsId.size() > 0) {
        TriggerHelper.createPDF(accountsId);
    }
}