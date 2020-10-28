public with sharing class RestClient {
    
    @future(callout = true)
    public static void makeRequest(Id id) {

        String SEND_RECORD_ENDPOINT = 'callout:None63ApiNC/services/data/v49.0/sobjects/Account/';

        Account account = RestClient.getAccountById(id);
        Account newAccount = RestClient.createAccount(account);

        String finalEndPoint = SEND_RECORD_ENDPOINT + 'MyExternal__c/' + id + '?_HttpMethod=PATCH';

        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint(finalEndPoint); 
        request.setMethod('POST');  
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(newAccount));
        HttpResponse response = http.send(request);

        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(response.getBody());
        String recordId = (String)resultObject.get('id');
        account.MyExternal__c = recordId;
        update account;
    }

    @future(callout = true)
    public static void deleteRequest(String externalId) {

        Account accountForUpdate = new Account(
            MyExternal__c = null
        );

        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:None63ApiNC/services/data/v49.0/sobjects/Account/' + externalId);  
        request.setMethod('PATCH');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(accountForUpdate)); 
        HttpResponse response = http.send(request);
    }

    public static Account getAccountById(Id id) {
        Account account = [SELECT Name, AccountNumber, Phone, BillingStreet, 
                                BillingCity, BillingCountry, BillingState, 
                                BillingPostalCode, BillingLatitude, BillingLongitude, 
                                ShippingStreet, ShippingCity, ShippingCountry, 
                                ShippingState, ShippingPostalCode, ShippingLatitude, 
                                ShippingLongitude, MyExternal__c
                                FROM Account WHERE Id = :id];
        return account;
    }

    public static Account createAccount(Account account) {
        Account newAccount = new Account(
            Name = account.Name,
            AccountNumber = account.AccountNumber,
            Phone = account.Phone,
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