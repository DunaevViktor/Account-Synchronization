public with sharing class TriggerHelper {
    public static void updateAccounts(List<Id> idForUpdate) {
        if(idForUpdate.size() > 0) {
            List<Account> accountForUpdate = new List<Account>();
        
            for (Account account : [SELECT Id, FromApi__c FROM Account WHERE Id IN :idForUpdate]) {
                account.FromApi__c = false;
                accountForUpdate.add(account);
            }
            
            update accountForUpdate;
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
            RestClient.deleteRequest(accountIds);
        }
    }
}
