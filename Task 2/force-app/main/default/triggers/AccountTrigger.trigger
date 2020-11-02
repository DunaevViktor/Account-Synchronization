trigger AccountTrigger on Account (after update) {
    //after insert,
    //if it means the possibility of creating an account with the CreatePDF__c=true
    List<Id> accountsId = new List<Id>();

    for (Account account : Trigger.new) {
        if(account.CreatePDF__c) {
            accountsId.add(account.Id);
        }
    }
    
    if(accountsId.size() > 0) {
        TriggerHelper generatingJob = new TriggerHelper(accountsId);
        ID jobID = System.enqueueJob(generatingJob);
    }
}