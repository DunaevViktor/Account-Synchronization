public with sharing class TriggerHelper {

    @future(callout=true)
    public static void createPDF(List<Id> Ids) {
        List<Account> accounts = [SELECT Id,  CreatePDF__c FROM Account WHERE Id IN :Ids];

        for (Account account : accounts) {
            account.CreatePDF__c = false;
            savePDF(account.id);
        }

        update accounts;
    }

    public static void savePDF(Id id) {
        Pagereference pdf = Page.AccountPage;
        pdf.getParameters().put('id', id);
    
        Attachment attach = new Attachment();
        Blob body;
    
        try {
            body = pdf.getContentAsPDF(); 
        }
        catch (VisualforceException e) {
            body = Blob.valueOf('Error body');
        }
    
        attach.Body = body;
        Datetime dateTimes = Datetime.now();
        attach.Name = '' + dateTimes.format('d.M.Y h:mm a') + '.pdf';
        attach.IsPrivate = false;
        attach.ParentId = id;
    
        insert attach;
    }
}
