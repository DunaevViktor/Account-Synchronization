public with sharing class TriggerHelper {

    public void syncUpdateAccount(Map<Id, Account> oldAccounts, Map<Id, Account> newAccounts){
        Boolean isFromApi = String.valueOf(System.URL.getCurrentRequestUrl().getPath()).contains('composite');
        
        String[] compareFields = new String[]{
            'Name', 'AccountNumber', 'Phone', 'BillingStreet',
            'BillingCity', 'BillingCountry', 'BillingState', 'BillingPostalCode',
            'BillingLatitude', 'BillingLongitude', 'ShippingStreet', 'ShippingCity', 
            'ShippingCountry', 'ShippingState', 'ShippingPostalCode', 'ShippingLatitude', 
            'ShippingLongitude'
        };

        Set<Id> accountIds = new Set<Id>();
        for(Id accountId: newAccounts.keySet()){
            Account oldAccount = oldAccounts.get(accountId);
            Account newAccount = newAccounts.get(accountId);

            if(!isFromApi) {
                for(String field: compareFields) {
                    if((String)newAccount.get(field) != (String)oldAccount.get(field)) {
                        accountIds.add(accountId);
                    }
                }
            }
        }

        if(!accountIds.isEmpty()){
            List<Id> forUpdate = new List<Id>(accountIds);
            upsertCallout integrationJob = new upsertCallout(forUpdate);
            ID jobID = System.enqueueJob(integrationJob);
        }
    }

    public void syncInsertAccount(List<Account> newAccounts){
        List<Id> needInsertRequestIds = new List<Id>();

        for(Account account: newAccounts) {
            if(account.MyExternal__c == null) {
                needInsertRequestIds.add(account.id);
            }
        }

        if(needInsertRequestIds.size() > 0) {
            upsertCallout integrationJob = new upsertCallout(needInsertRequestIds);
            ID jobID = System.enqueueJob(integrationJob);
        }
    }

    public void syncDeleteAccount(List<Account> deletedAccounts){
        Boolean isFromApi = String.valueOf(System.URL.getCurrentRequestUrl().getPath()).contains('composite');

        List<Id> accountIds = new List<Id>();
        for(Account account: deletedAccounts){
            if(isFromApi == false){
                accountIds.add(account.MyExternal__c);
            }
        } 
        if(!accountIds.isEmpty()){
            deleteCallout integrationJob = new deleteCallout(accountIds);
            ID jobID = System.enqueueJob(integrationJob);
        }
    }
}