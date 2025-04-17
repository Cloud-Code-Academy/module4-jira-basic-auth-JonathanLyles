/**
 * Queueable class to make asynchronous callouts to Jira API
 */
public class JiraCalloutQueueable implements Queueable, Database.AllowsCallouts {
	// Simple constants instead of enum
	public static final String TYPE_PROJECT = 'PROJECT';
	public static final String TYPE_ISSUE = 'ISSUE';
	public static final Integer QUEUEABLE_LIMIT = 50;

	private String calloutType;
	private Id recordId;
	private JiraWrapper.ProjectWrapper projectWrapper;
	private JiraWrapper.IssueWrapper issueWrapper;

	/**
	 * Constructor for Jira Project callout
	 * @param recordId The Salesforce Jira Project record Id
	 * @param projectName The name of the project
	 * @param projectKey The unique key for the project
	 * @param description Project description
	 */
	public JiraCalloutQueueable(
		Id recordId,
		String projectName,
		String projectKey,
		String description
	) {
		this.calloutType = TYPE_PROJECT;
		this.recordId = recordId;
		this.projectWrapper = new JiraWrapper.ProjectWrapper(projectName, projectKey, description);
	}

	/**
	 * Constructor for Jira Issue callout
	 * @param recordId The Salesforce Jira Issue record Id
	 * @param projectKey The project key where the issue should be created
	 * @param summary The issue summary/title
	 * @param description Issue description
	 * @param issueType The type of issue
	 */
	public JiraCalloutQueueable(
		Id recordId,
		String projectKey,
		String summary,
		String description,
		String issueType
	) {
		this.calloutType = TYPE_ISSUE;
		this.recordId = recordId;
		this.issueWrapper = new JiraWrapper.IssueWrapper(
			projectKey,
			summary,
			description,
			issueType
		);
	}

	/**
	 * Execute the callout based on the callout type
	 * 1. Check the callout type (TYPE_PROJECT or TYPE_ISSUE)
	 * 2. Call the appropriate JiraAPIService method
	 * 3. Update the corresponding Salesforce record with the Jira ID/Key
	 */
	public void execute(QueueableContext context) {
		
		if(projectWrapper != null && calloutType == 'PROJECT'){
				//create project and get the Jira Id
				String jiraProjectId = JiraAPIService.createProject(projectWrapper);
				//update the salesforce record
				if(jiraProjectId != null){
					updateJiraProject(jiraProjectId);
				}else{
					System.debug('project not created');
				}
		}else if(issueWrapper != null && calloutType == 'ISSUE'){
				//create issue and get the key
				System.debug('updating the issue');
				String jiraIssueKey = JiraAPIService.createIssue(issueWrapper);
				System.debug('Jira Issue Key: ' + jiraIssueKey);
				//update the salesforce record		
				if(jiraIssueKey != null){
					System.debug('calling updateJiraIssue');
					updateJiraIssue(jiraIssueKey);
				}else{
					
				}
			}
	}
	

	/**
	 * Update the Jira Project record with the Jira project Id
	 * with the Jira project ID returned from the API
	 */
	private void updateJiraProject(String jiraProjectId) {
		Jira_Project__c project = new Jira_Project__c();
		project.Id = this.recordId;
		project.Project_ID__c = jiraProjectId;
		System.debug(project.Project_ID__c);
		update project;
	}

	/**
	 * Update the Jira Issue record with the Jira issue key
	 * with the Jira issue key returned from the API
	 * Don't forget to update the Last_Updated__c field with the current time
	 */
	private void updateJiraIssue(String jiraIssueKey) {
		System.debug('inside the beast');
		Jira_Issue__c issue = new Jira_Issue__c();
		issue.Id = this.recordId;
		issue.Issue_Key__c = jiraIssueKey;
		issue.Last_Updated__c = Datetime.now();
		update issue;		
	}
}
