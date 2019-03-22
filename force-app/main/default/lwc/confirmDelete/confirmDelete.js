import { LightningElement, api } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class ConfirmDelete extends LightningElement {
    @api recordId;

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
