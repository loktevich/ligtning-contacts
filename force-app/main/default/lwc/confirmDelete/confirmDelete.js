import { LightningElement, api, wire } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import hasCases from '@salesforce/apex/ContactController.hasCases';

export default class ConfirmDelete extends LightningElement {
    @api recordId;

    @wire(hasCases, { contactId: '@recordId' }) cases;

    handleCancelClick() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    deleteContact() {
        deleteRecord(this.recordId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contact deleted',
                        variant: 'success'
                    })
                );
                this.dispatchEvent(new CustomEvent('delete'));
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.message,
                        variant: 'error'
                    })
                );
            });
    }
}
