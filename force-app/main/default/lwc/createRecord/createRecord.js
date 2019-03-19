import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import CONTACT_NAME_FIELD from '@salesforce/schema/Contact.Name';
import CONTACT_EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import CONTACT_CONTACTLEVEL_FIELD from '@salesforce/schema/Contact.Contact_Level__c';
import CONTACT_ACCOUNTID_FIELD from '@salesforce/schema/Contact.AccountId';

export default class CreateRecord extends LightningElement {
    contactObj = CONTACT_OBJECT;
    nameField = CONTACT_NAME_FIELD;
    emailField = CONTACT_EMAIL_FIELD;
    contactLevelField = CONTACT_CONTACTLEVEL_FIELD;
    accountIdField = CONTACT_ACCOUNTID_FIELD;

    handleCancelClick() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    createContact() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Contact created',
                variant: 'success'
            })
        );
        this.dispatchEvent(new CustomEvent('save'));
    }
}