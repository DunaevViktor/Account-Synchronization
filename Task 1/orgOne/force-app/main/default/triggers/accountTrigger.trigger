trigger accountTrigger on Account (after insert) {
    for(Account account : Trigger.New) {
        if(account.MyExternal__c == null) {
            RestClient.makeInsertRequest(account.id);
        }
    }
}