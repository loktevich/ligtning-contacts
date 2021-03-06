public with sharing class PagedResult {
    @AuraEnabled
    public Integer pageSize { get;set; }
    
    @AuraEnabled
    public Integer pageNumber { get;set; }
    
    @AuraEnabled
    public Integer totalRecords { get;set; }
    
    @AuraEnabled
    public List<SimpleContact> records { get;set; }

    public PagedResult() { }
}
