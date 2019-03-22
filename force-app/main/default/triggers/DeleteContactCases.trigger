trigger DeleteContactCases on Contact (before delete) {
    List<Case> cases = [SELECT Id FROM Case WHERE ContactId IN :Trigger.old];
    if (cases.size() > 0) {
        delete cases;
    }
}
