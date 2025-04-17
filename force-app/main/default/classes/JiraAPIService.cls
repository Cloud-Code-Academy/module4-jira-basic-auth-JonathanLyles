/**
 * Service class for making callouts to the Jira API
 */
public with sharing class JiraAPIService {

	private static final String NAMED_CREDENTIAL = 'callout:JiraAPI'; // https://jonathanlyles.atlassian.net/rest/api/3
	private static final String CREATE_PROJECT_URL = '/project';
	private static final String CREATE_ISSUE_URL = '/issue';

	/**
	 * Creates a project in Jira
	 * @param projectWrapper The project wrapper object containing all necessary data
	 * @return String The Jira project ID
	 *
	 * TODO: Implement this method to make a callout to Jira API to create a project
	 * Reminder: Extract and return the project ID from the response
	 */
	public static String createProject(JiraWrapper.ProjectWrapper projectWrapper) {
		Http http = new Http();
		
		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		req.setEndpoint(NAMED_CREDENTIAL + CREATE_PROJECT_URL);
		req.setHeader('Content-Type','application/json');
		
		Map<String, Object> body = new Map<String, Object>();
		body.put('key', projectWrapper.key);
		body.put('name', projectWrapper.name);
		body.put('projectTemplateKey', projectWrapper.projectTemplateKey);
		body.put('leadAccountId', '712020:3863faf7-35b9-466a-a958-b67d229b0dff');
		req.setBody(JSON.serialize(body));

		HttpResponse res = http.send(req);
		if(res.getStatusCode() == 201){
			Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
			String projectId = String.valueOf(responseBody.get('id'));
			return projectId;
		}else{
			System.debug('A project was not created');
			return null;
		}
		 
	}

	/**
	 * Creates an issue in Jira
	 * @param issueWrapper The issue wrapper object containing all necessary data
	 * @return String The Jira issue key
	 * Reminder: Extract and return the issue key from the response
	 */
	public static String createIssue(JiraWrapper.IssueWrapper issueWrapper) {
		Http http = new http();
		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		req.setEndpoint(NAMED_CREDENTIAL + CREATE_PROJECT_URL);
		req.setHeader('Content-Type','application/json');
		Map<String, Object> body = issueWrapper.generateIssuePayloadMap();
		System.debug('Issue body: ' + body);
		req.setBody(JSON.serialize(body));
		HttpResponse res = http.send(req);
		if(res.getStatusCode() == 201){
			Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
			String issueKey = (String) responseBody.get('key');
			system.debug('hello issueKey: ' + issueKey);
			return issueKey;
		}else{
			return null;
		}
	}
}
