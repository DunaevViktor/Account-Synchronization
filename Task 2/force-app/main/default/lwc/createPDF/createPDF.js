import { LightningElement, api, track } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import CREATE_PDF_FIELD from '@salesforce/schema/Account.CreatePDF__c';
import ID_FIELD from '@salesforce/schema/Account.Id';

export default class CreatePDF extends LightningElement {

    SUCCESS_MESSAGE = 'PDF file created successfully!';

    @api recordId;
    @track processing; 
    @track resultMessage;

    connectedCallback() {
        this.processing = true;
        this.createPDF();
    }

    createPDF() {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[CREATE_PDF_FIELD.fieldApiName] = true;
    
        const recordInput = { fields };
    
        updateRecord(recordInput)
        .then(() => {
            this.resultMessage = this.SUCCESS_MESSAGE;
            this.processing = false;
        })
        .catch(error => {
            this.resultMessage = error.body.message;
            this.processing = false;
        });
    }

}