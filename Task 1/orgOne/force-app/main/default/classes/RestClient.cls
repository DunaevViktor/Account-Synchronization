public with sharing class RestClient {
    
    @future(callout = true)
    public static void makeRequest(List<Id> ids) {

        String SEND_RECORD_ENDPOINT = 'callout:None9aApiNC/services/data/v49.0/composite/sobjects/Account/';

        List<Account> accounts = RestClient.getAccountById(ids);
        List<Account> newAccounts = new List<Account>();
        for(Account account: accounts){
            Account newAccount = RestClient.createAccount(account);
            newAccounts.add(newAccount);
        }

        AccountCompositeRequest requestBody = new AccountCompositeRequest(newAccounts);

        String finalEndPoint = SEND_RECORD_ENDPOINT + 'MyExternal__c' + '?_HttpMethod=PATCH';

        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint(finalEndPoint);  
        request.setMethod('POST');  
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(requestBody));
        HttpResponse response = http.send(request);

        List<AccountCompositeResponse> responseList = AccountCompositeResponse.parse(response.getBody()); 
        
        for(Account account: accounts){
            account.MyExternal__c = responseList.get(accounts.indexOf(account)).id;
        }
        
        update accounts; 
    }

    //names
    @future(callout = true)
    public static void deleteRequest(List<String> externalIds) {

        List<Account> accountsForUpdate = new List<Account>();
        for (String id : externalIds) {
            Account accountForUpdate = new Account(
                Id = id,
                MyExternal__c = null
            );
            accountsForUpdate.add(accountForUpdate);
        }
    
        AccountRequestWrapper wrapper = new AccountRequestWrapper(false, accountsForUpdate);

        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:None9aApiNC/services/data/v49.0/composite/sobjects');  
        request.setMethod('PATCH');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(wrapper)); 
        HttpResponse response = http.send(request);
    }

    private static List<Account> getAccountById(List<Id> ids) {
        List<Account> account = [SELECT Name, AccountNumber, Phone, BillingStreet, 
                                BillingCity, BillingCountry, BillingState, 
                                BillingPostalCode, BillingLatitude, BillingLongitude, 
                                ShippingStreet, ShippingCity, ShippingCountry, 
                                ShippingState, ShippingPostalCode, ShippingLatitude, 
                                ShippingLongitude, MyExternal__c
                                FROM Account WHERE Id = :ids];
        return account;
    }

    private static Account createAccount(Account account) {
        Account newAccount = new Account(
            MyExternal__c = account.Id,
            Name = account.Name,
            AccountNumber = account.AccountNumber,
            Phone = account.Phone,
            FromApi__c = true,
            BillingStreet = account.BillingStreet,
            BillingCity = account.BillingCity,
            BillingCountry = account.BillingCountry,
            BillingState = account.BillingState,
            BillingPostalCode = account.BillingPostalCode,
            BillingLatitude = account.BillingLatitude,
            BillingLongitude = account.BillingLongitude,
            ShippingStreet = account.ShippingStreet,
            ShippingCity = account.ShippingCity,
            ShippingCountry = account.ShippingCountry,
            ShippingState = account.ShippingState,
            ShippingPostalCode = account.ShippingPostalCode,
            ShippingLatitude = account.ShippingLatitude,
            ShippingLongitude = account.ShippingLongitude
        );
        return newAccount;
    }
}