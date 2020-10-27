public with sharing class RestClient {
    
    //RestClient.makeInsertRequest();
    
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
        request.setEndpoint('callout:None63ApiNC/services/data/v49.0/sobjects/Account'); 
        request.setMethod('POST');  
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(newAccount));
        HttpResponse responce = http.send(request);
        
        String responceBody = responce.getBody();
        System.debug(responceBody);
        Map <String, Object> resultObject = (Map <String, Object>)JSON.deserializeUntyped(responceBody);
        String recordId = (String)resultObject.get('id');
        System.debug(recordId);

        account.MyExternal__c = recordId;
        upsert account;  
    }   
}