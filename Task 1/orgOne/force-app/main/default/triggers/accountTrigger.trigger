trigger accountTrigger on Account (after insert, after update, before delete) {

    TriggerHelper helper = new TriggerHelper();

    if(Trigger.isInsert){

        List<Id> needInsertRequestIds = new List<Id>();

        for(Account account : Trigger.New) {
            if(account.MyExternal__c == null) {
                needInsertRequestIds.add(account.id);
            }
        }

        if(needInsertRequestIds.size() > 0) {
            RestClient.makeRequest(needInsertRequestIds);
        }

    } else if(Trigger.isUpdate){

        String[] compareFields = new String[]{
            'Name', 'AccountNumber', 'Phone', 'BillingStreet',
            'BillingCity', 'BillingCountry', 'BillingState', 'BillingPostalCode',
            'BillingLatitude', 'BillingLongitude', 'ShippingStreet', 'ShippingCity', 
            'ShippingCountry', 'ShippingState', 'ShippingPostalCode', 'ShippingLatitude', 
            'ShippingLongitude'
        };

        List<Id> idForUpdate = new List<Id>();
        List<Id> needUpdateRequestIds = new List<Id>();

        for (Account account: Trigger.new) {
            Account oldAccount = Trigger.oldMap.get(account.Id);

            Boolean isHaveChanges = false;

            if(!account.FromApi__c) {
                for(String field : compareFields) {
                    if((String)account.get(field) != (String)oldAccount.get(field)) {
                        isHaveChanges = true;
                    }
                }
        
                if(isHaveChanges) {
                    needUpdateRequestIds.add(account.id);
                }
            }
                
            if(account.FromApi__c) {
                idForUpdate.add(account.Id);
            }

        }

        if(needUpdateRequestIds.size() > 0) {
            RestClient.makeRequest(needUpdateRequestIds);
        }

        TriggerHelper.updateAccounts(idForUpdate);

    } else if(Trigger.isDelete){
        helper.syncDeleteAccount(Trigger.old);
    }
}