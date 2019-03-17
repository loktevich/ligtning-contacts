import { LightningElement, track } from 'lwc';
import searchContacts from '@salesforce/apex/ContactController.searchContacts';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name', sortable: true },
    { label: 'Email', fieldName: 'Email', type: 'email', sortable: true },
    { label: 'Contact Level', fieldName: 'ContactLevel', sortable: true },
    { label: 'Account', fieldName: 'AccountName', sortable: true },
    { label: 'Owner', fieldName: 'OwnerName', sortable: true },
    { label: 'Created By', fieldName: 'CreatedBy', sortable: true },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date', sortable: true }
];

export default class ContactList extends LightningElement {
    columns = COLUMNS;
    @track error;
    @track searchName = '';
    @track sortedBy = 'Name';
    @track sortDirection = 'asc';

    @track contacts;

    connectedCallback() {
        this.loadContacts(this.sortedBy);
    }

    loadContacts(sortedBy) {
        searchContacts({ searchName: this.searchName, sortedBy: sortedBy, sortDirection: this.sortDirection })
            .then(result => {
                this.contacts = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.contacts = undefined;
            });
    }

    updateColumnSorting(event) {
        const sortDirection = event.detail.sortDirection;
        const fieldName = event.detail.fieldName;
        let sortField = fieldName;
        switch (sortField) {
            case 'ContactLevel':
                sortField = 'Contact_Level__c';
                break;
            case 'AccountName':
                sortField = 'Account.Name';
                break;
            case 'OwnerName':
                sortField = 'Owner.Name';
                break;
            case 'CreatedBy':
                sortField = 'CreatedBy.Name';
                break;
            default:
                break;
        }

        this.sortDirection = sortDirection;
        this.sortedBy = fieldName;
        this.loadContacts(sortField);
    }

    updateSearchName(event) {
        this.searchName = event.target.value;
    }

    searchByName() {
        this.loadContacts(this.sortedBy);
    }

}