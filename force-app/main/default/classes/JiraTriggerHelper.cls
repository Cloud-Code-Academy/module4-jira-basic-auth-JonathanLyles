/**
 * Helper class for Jira triggers
 */
public with sharing class JiraTriggerHelper {
	/**
	 * Process Jira_Project__c records after insert
	 * @param newProjects List of newly inserted Jira_Project__c records
	 */
	public static void processProjectAfterInsert(List<Jira_Project__c> newProjects) {
		List<JiraCalloutQueueable> callouts = new List<JiraCalloutQueueable>();

		// Filter out projects that already have a Jira project ID
		for (Jira_Project__c project : newProjects) {
			if (String.isBlank(project.Project_ID__c)) {
				callouts.add( new JiraCalloutQueueable(
					project.Id,
					project.Project_Name__c,
					project.Project_Key__c,
					project.Description__c
				));
			}
			System.debug('added');
		}
	
		if (!Test.isRunningTest()) {
			Integer jobsEnqueued = 0;
			for (JiraCalloutQueueable callout : callouts) {
				if(jobsEnqueued < JiraCalloutQueueable.QUEUEABLE_LIMIT){
					System.enqueueJob(callout);
					jobsEnqueued++;
				} else {
					System.debug(LoggingLevel.ERROR, 'Reached Queueable job limit for this transaction.');
					break;
				}
			}
		 }
	}


	/**
	 * Process Jira_Issue__c records after insert
	 * @param newIssues List of newly inserted Jira_Issue__c records
	 *
	 * TODO: Implement this method to process new Jira issues
	 * The method should:
	 * 1. Filter out issues that already have a Jira issue key
	 * 2. Ensure the Project_Key__c field is not blank
	 * 3. Create a JiraCalloutQueueable for each issue and enqueue it
	 * 4. Don't enqueue if Test.isRunningTest() is true
	 */
	public static void processIssueAfterInsert(List<Jira_Issue__c> newIssues) {
		List<JiraCalloutQueueable> callouts = new List<JiraCalloutQueueable>();
		for(Jira_Issue__c newIssue : newIssues){
			if(isValidIssue(newIssue)){
				callouts.add( new JiraCalloutQueueable(
					newIssue.Id,
					newIssue.Summary__c,
					newIssue.Description__c,
					newIssue.Project_Key__c
				));
			}else{
				System.debug(LoggingLevel.ERROR, 'Invalid issue: ' + newIssue);
			}

			// if (!Test.isRunningTest()) {
			// 	Integer jobsEnqueued = 0;
			// 	for (JiraCalloutQueueable callout : callouts) {
			// 		//if (jobsEnqueued < Limits.getLimitQueueableJobs() - 1) {
			// 			if (jobsEnqueued < Limits.getLimitQueueableJobs() - 1) {
			// 			System.enqueueJob(callout);
			// 			jobsEnqueued++;
			// 		} else {
			// 			System.debug(LoggingLevel.ERROR, 'Reached Queueable job limit for this transaction.');
			// 			break;
			// 		}
			// 	}
			// }
		}
	}
	
	private static Boolean isValidIssue(Jira_Issue__c issue){
		return issue.Issue_Key__c == null && issue.Project_Key__c != null;
	}
}