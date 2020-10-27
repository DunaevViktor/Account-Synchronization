public with sharing class RestClient {
    
    @future(callout = true)
    public static void makeRequest(Id id) {

        String SEND_RECORD_ENDPOINT = 'callout:None9aApiNC/services/data/v49.0/sobjects/Account/';

        Account account = [SELECT Name, AccountNumber, Phone, BillingAddress, ShippingAddress FROM Account WHERE Id = :id];
        Account newAccount = new Account(
            //BillingAddress, ShippingAddress
            Name = account.Name,
            AccountNumber = account.AccountNumber,
            Phone = account.Phone
        );

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
        request.setEndpoint('callout:None9aApiNC/services/data/v49.0/sobjects/Account/' + externalId);  
        request.setMethod('PATCH');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(accountForUpdate)); 
        HttpResponse response = http.send(request);
    }
}