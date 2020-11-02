public with sharing class TriggerHelper implements Queueable, Database.AllowsCallouts{

    private List<Id> ids;

    public TriggerHelper(List<Id> ids) {
        this.ids = ids;
    }

    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id,  CreatePDF__c FROM Account WHERE Id IN :Ids];

        for (Account account : accounts) {
            account.CreatePDF__c = false;
            this.savePDF(account.id);
        }

        update accounts;
    }

    public void savePDF(Id id) {
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
