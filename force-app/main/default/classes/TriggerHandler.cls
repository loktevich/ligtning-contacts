public with sharing class TriggerHandler {
    public static Case getCaseWithFields(Case c, Contact contact, Map<Id,Contact> contactsWithAccs) {
        Case newCase = c;
        newCase.AccountId = contact.AccountId;
        if (contactsWithAccs.containsKey(contact.Id)) {
            newCase.OwnerId = contactsWithAccs.get(contact.Id).Account.OwnerId;
        }

        String contactLevel = contact.Contact_Level__c;
        if (contactLevel != null) {
            if (contactLevel.equals('Primary')) {
                newCase.Priority = 'High';
            } else if (contactLevel.equals('Secondary')) {
                newCase.Priority = 'Medium';
            } else if (contactLevel.equals('Tertiary')) {
                newCase.Priority = 'Low';
            }
        }

        return newCase;
    }
}
