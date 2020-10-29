trigger accountTrigger on Account (after insert, after update, before delete) {
    if(Trigger.isInsert){

        List<Id> needInsertRequestIds = new List<Id>();

        for(Account account : Trigger.New) {
            if(account.MyExternal__c == null) {
                //RestClient.makeRequest(account.id);
                needInsertRequestIds.add(account.id);
            }
        }

        if(needInsertRequestIds.size() > 0) {
            RestClient.makeRequest(needInsertRequestIds);
        }

    } else if(Trigger.isUpdate){
        List<Id> idForUpdate = new List<Id>();
        List<Id> idForDelete = new List<Id>();
        List<Id> needUpdateRequestIds = new List<Id>();
        for (Account account: Trigger.new) {
            Account oldAccount = Trigger.oldMap.get(account.Id);
        
            //account.BillingAddress != oldAccount.BillingAddress
            //account.ShippingAddress != account.ShippingAddress
            if((account.Name != oldAccount.Name || account.AccountNumber != oldAccount.AccountNumber || 
            account.Phone != oldAccount.Phone) && !account.FromApi__c) {
                //RestClient.makeRequest(account.id);
                needUpdateRequestIds.add(account.id);
            } 
        
            if(account.FromApi__c) {
                idForUpdate.add(account.Id);
            }

            if(account.MyExternal__c == null) {
                idForDelete.add(account.Id);
            }
        }

        if(needUpdateRequestIds.size() > 0) {
            RestClient.makeRequest(needUpdateRequestIds);
        }

        TriggerHelper.updateAccounts(idForUpdate);
        TriggerHelper.deleteAccounts(idForDelete);
    } else if (Trigger.isDelete){
        List<String> needDeleteRequestIds = new List<String>();

        for(Account account: Trigger.old) {
            if(account.MyExternal__c != null) {
                //RestClient.deleteRequest(account.MyExternal__c);
                needDeleteRequestIds.add(account.MyExternal__c);
            }
        }

        //if size>0?
        RestClient.deleteRequest(needDeleteRequestIds);
    }
}