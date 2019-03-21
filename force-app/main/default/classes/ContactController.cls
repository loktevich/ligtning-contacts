public with sharing class ContactController {
    public static List<SimpleContact> getContacts(String queryString) {
        List<Contact> contactList = Database.query(queryString);
        return createSimpleContact(contactList);
    }

    public static Integer getTotalRecords(String queryString) {
        return Database.countQuery(queryString);
    }

    @AuraEnabled(cacheable=true)
    public static PagedResult searchContacts(String searchName, String sortedBy, String sortDirection, Integer pageNumber, Integer pageSize, String searchId) {
        PagedResult pagedResult = new PagedResult();
        pagedResult.pageNumber = pageNumber;
        pagedResult.pageSize = pageSize;
        
        // Base queries
        String baseQueryString = 'SELECT Id, Name, Email, Contact_Level__c, Account.Name, Owner.Name, CreatedBy.Name, CreatedDate FROM Contact';
        String baseCountString = 'SELECT count() FROM Contact';

        searchName = searchName.trim();
        String queryString = baseQueryString;
        String queryCountString = baseCountString;

        // WHERE clause
        if (searchName != '') {
            queryString += ' WHERE Name LIKE \'%' + searchName + '%\'';
            queryCountString += ' WHERE Name LIKE \'%' + searchName + '%\'';
        }

        // Sorting
        queryString += ' ORDER BY ' + sortedBy + ' ' + sortDirection;

        // Paging
        queryString += ' LIMIT ' + pageSize;
        queryString += ' OFFSET ' + (pageNumber - 1) * pageSize;

        pagedResult.records = getContacts(queryString);
        pagedResult.totalRecords = getTotalRecords(queryCountString);

        return pagedResult;
    }

    @AuraEnabled(cacheable=true)
    public static List<Case> hasCases(String contactId){
        List<Case> cases = new List<Case>([SELECT Id FROM Case WHERE ContactId=:contactId]);
        return cases;
    }

    static List<SimpleContact> createSimpleContact(List<Contact> contacts) {
        List<SimpleContact> simpleContacts = new List<SimpleContact>();
        for (Contact c : contacts) {
            simpleContacts.add(new SimpleContact(
               c.Id,
               c.Name,
               '/' + c.Id,
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

// SELECT Id FROM Case WHERE ContactId='0030o00002goitrAAA'