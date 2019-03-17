public class SimpleContact {
    @AuraEnabled public String Id { get; set; }
    @AuraEnabled public String Name { get; set; }
    @AuraEnabled public String Email{ get; set; }
    @AuraEnabled public String ContactLevel{ get; set; }
    @AuraEnabled public String AccountName{ get; set; }
    @AuraEnabled public String OwnerName{ get; set; }
    @AuraEnabled public String CreatedBy{ get; set; }
    @AuraEnabled public Datetime CreatedDate{ get; set; }

    public SimpleContact() {
    }

    public SimpleContact(String id, String name, String email, String contactLevel, String accountName, String ownerName, String createdBy, Datetime createdDate) {
        this.Id = id;
        this.Name = name;
        this.Email = email;
        this.ContactLevel = contactLevel;
        this.AccountName = accountName;
        this.OwnerName = ownerName;
        this.CreatedBy = createdBy;
        this.CreatedDate = createdDate;
    }
}
