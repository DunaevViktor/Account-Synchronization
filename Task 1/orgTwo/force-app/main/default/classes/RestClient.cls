public with sharing class RestClient {
    
    //RestClient.makeRestRequest();
    
    public static HttpResponse makeRestRequest() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:None63ApiNC/services/data/v49.0/sobjects/Account');  
        request.setMethod('GET');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        HttpResponse responce = http.send(request);  
        
        System.debug(responce);
        return responce;
    }
     
}