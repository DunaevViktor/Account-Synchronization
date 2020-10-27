public with sharing class RestClient {
    
    @future(callout = true)
    public static void makeInsertRequest(Id id) {

        Account account = [SELECT Name, AccountNumber, Phone, BillingAddress, ShippingAddress FROM Account WHERE Id = :id];
        Account newAccount = new Account(
            //BillingAddress, ShippingAddress
            Name = account.Name,
            AccountNumber = account.AccountNumber,
            Phone = account.Phone,
            MyExternal__c = account.Id
        );

        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:None9aApiNC/services/data/v49.0/sobjects/Account');  
        request.setMethod('POST');  
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(newAccount));
        HttpResponse response = http.send(request);
        
        String responseBody = response.getBody();
        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(responseBody);
        String recordId = (String)resultObject.get('id');
        account.MyExternal__c = recordId;
        update account;  
    }

    @future(callout = true)
    public static void makeUpdateRequest(Id id) {

        Account account = [SELECT Name, AccountNumber, Phone, BillingAddress, ShippingAddress, MyExternal__c FROM Account WHERE Id = :id];
        Account accountForUpdate = new Account(
            //BillingAddress, ShippingAddress
            Name = account.Name,
            AccountNumber = account.AccountNumber,
            Phone = account.Phone,
            FromApi__c = true
        );

        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:None9aApiNC/services/data/v49.0/sobjects/Account/' + account.MyExternal__c);  
        request.setMethod('PATCH');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(accountForUpdate)); 
        HttpResponse response = http.send(request);
    }  
}