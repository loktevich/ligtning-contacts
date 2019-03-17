public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<SimpleContact> getContacts(String sortedBy, String sortDirection) {

        String queryString = 'SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate FROM Contact ORDER BY ';
        queryString += sortedBy + ' ' + sortDirection;

        List<Contact> contactList = Database.query(queryString);

        return createSimpleContact(contactList);
    }

    // SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate FROM Contact WHERE Name LIKE '%aa%' ORDER BY Name asc

    @AuraEnabled(cacheable=true)
    public static List<SimpleContact> searchContacts(String searchName, String sortedBy, String sortDirection) {
        // Return all contacts when no search name
        searchName = searchName.trim();
        if (searchName == '') {
            return getContacts(sortedBy, sortDirection);
        }
        
        // Search contact name
        searchName = '\'%' + searchName + '%\'';
        String queryString = 'SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate FROM Contact WHERE Name';
        queryString += ' LIKE ' + searchName;
        queryString += ' ORDER BY ' + sortedBy + ' ' + sortDirection;
        List<Contact> searchContactList = Database.query(queryString);
        
        return createSimpleContact(searchContactList);
    }

    static List<SimpleContact> createSimpleContact(List<Contact> contacts) {
        List<SimpleContact> simpleContacts = new List<SimpleContact>();
        for (Contact c : contacts) {
           simpleContacts.add(new SimpleContact(
               c.Id,
               c.Name,
               c.Email,
               c.Contact_Level__c,
               c.Account.Name,
               c.Owner.Name,
               c.CreatedBy.Name,
               c.CreatedDate
            ));
        }
        return simpleContacts;
    }
}