trigger accountTrigger on Account (after insert, after update, before delete) {
    if(Trigger.isInsert){
        for(Account account : Trigger.New) {
            if(account.MyExternal__c == null) {
                RestClient.makeRequest(account.id);
            }
        }
    } else if(Trigger.isUpdate){
        List<Id> idForUpdate = new List<Id>();
        List<Id> idForDelete = new List<Id>();
        for (Account account: Trigger.new) {
            Account oldAccount = Trigger.oldMap.get(account.Id);
        
            //account.BillingAddress != oldAccount.BillingAddress
            //account.ShippingAddress != account.ShippingAddress
            if((account.Name != oldAccount.Name || account.AccountNumber != oldAccount.AccountNumber || 
            account.Phone != oldAccount.Phone) && !account.FromApi__c) {
                RestClient.makeRequest(account.id);
            } 
        
            if(account.FromApi__c) {
                idForUpdate.add(account.Id);
            }

            if(account.MyExternal__c == null) {
                idForDelete.add(account.Id);
            }
        }

        TriggerHelper.updateAccounts(idForUpdate);
        TriggerHelper.deleteAccounts(idForDelete);
    } else if(Trigger.isDelete){
        for(Account account: Trigger.old) {
            if(account.MyExternal__c != null) {
                RestClient.deleteRequest(account.MyExternal__c);
            }
        }
    }
}