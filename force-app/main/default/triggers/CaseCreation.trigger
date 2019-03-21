trigger CaseCreation on Contact (after insert) {
    List<Case> cases = new List<Case>();

    // Find contacts with accounts
    Map<Id,Contact> contactsWithAccs = new Map<Id,Contact>([SELECT Id, Account.OwnerId FROM Contact WHERE AccountId!=NULL AND Id IN :Trigger.new]); 

    for (Contact contact : Trigger.new) {
        Case c = new Case();
        c.ContactId = contact.Id;
        c.AccountId = contact.AccountId;
        c.Status = 'Working';
        c.Origin = 'New Contact';
        if (contactsWithAccs.containsKey(contact.Id)) {
            c.OwnerId = contactsWithAccs.get(contact.Id).Account.OwnerId;
        }
        String contactLevel = contact.Contact_Level__c;
        if (contactLevel != null) {
            if (contactLevel.equals('Primary')) {
                c.Priority = 'High';
            } else if (contactLevel.equals('Secondary')) {
                c.Priority = 'Medium';
            } else {
                c.Priority = 'Low';
            }
        }
        cases.add(c);
    }
    insert cases;
}
