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

    public static void deleteAccounts(List<Id> idForDelete) {
        if(idForDelete.size() > 0) {
            List<Account> accountForDelete = [SELECT Name FROM Account WHERE Id IN :idForDelete];
            delete accountForDelete;
        }
    }
}
