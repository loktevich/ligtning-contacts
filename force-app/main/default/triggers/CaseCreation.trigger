trigger CaseCreation on Contact (after insert, after update) {
    List<Case> cases = new List<Case>();

    // Find contacts with accounts
    Map<Id,Contact> contactsWithAccs = new Map<Id,Contact>([SELECT Id, Account.OwnerId FROM Contact WHERE AccountId!=NULL AND Id IN :Trigger.new]); 

    for (Contact contact : Trigger.new) {
        if (Trigger.isInsert) {
            Case c = new Case();
            c.ContactId = contact.Id;
            c.Status = 'Working';
            c.Origin = 'New Contact';
            Case newCase = TriggerHandler.getCaseWithFields(c, contact, contactsWithAccs);
            cases.add(newCase);
        } else if (Trigger.isUpdate) {
            List<Case> existedCases = new List<Case>([SELECT AccountId, Priority FROM Case WHERE ContactId=:contact.Id]);
            if (existedCases.size() > 0) {
                for (Case c : existedCases) {
                    Case newCase = TriggerHandler.getCaseWithFields(c, contact, contactsWithAccs);
                    cases.add(newCase);
                }
            }
        }
    }

    if (Trigger.isInsert) {
        insert cases;
    } else if (Trigger.isUpdate) {
        update cases;
    }
}
