import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import NAME_FIELD from '@salesforce/schema/Contact.Name';

export default class CreateRecord extends LightningElement {
    createContact() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Account created',
                variant: 'success'
            })
        );
    }

    createAccount() {
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.name;
        const recordInput = { apiName: CONTACT_OBJECT.objectApiName, fields };
        createRecord(recordInput)
            .then(account => {
                this.accountId = account.id;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Account created',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.message,
                        variant: 'error'
                    })
                );
            });
    }

    handleCancelClick() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    handleSaveClick() {
        this.createContact();
        this.dispatchEvent(new CustomEvent('save'));
    }
}