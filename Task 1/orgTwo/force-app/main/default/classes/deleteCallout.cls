public with sharing class deleteCallout implements Queueable, Database.AllowsCallouts {
    private List<Id> accountIds;

    public deleteCallout(List<Id> accountIds) {
        this.accountIds = accountIds;
    }

    public void execute(QueueableContext context) {
        String finalEndPoint = 'callout:None63ApiNC/services/data/v50.0/composite/sobjects?ids=';

        for(Id accountId: accountIds){
            finalEndPoint = finalEndpoint + accountId + ',';
        }

        finalEndPoint = finalEndPoint.removeEnd(',');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(finalEndPoint);
        request.setMethod('DELETE');

        HTTPResponse response = http.send(request);  
    }
}
