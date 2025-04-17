public with sharing class JiraDataController {
    @AuraEnabled(cacheable=true)
    public static List<Jira_Project__c> getProjects(){
        try {
            return [SELECT Id, Project_Name__c, Project_Key__c, Description__c FROM Jira_Project__c];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}