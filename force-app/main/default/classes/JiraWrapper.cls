/**
 * Wrapper classes for Jira entities (Project and Issue)
 */
public class JiraWrapper {
	private static final String LEAD_ACCOUNT_ID = '712020:3863faf7-35b9-466a-a958-b67d229b0dff';
	private static final String PROJECT_TEMPLATE_KEY = 'com.pyxis.greenhopper.jira:basic-software-development-template';

	/**
	 * Wrapper for Jira Project
	 */
	public class ProjectWrapper {
		public String name;
		public String key;
		public String description;
		public String leadAccountId;
		public String projectTemplateKey;

		/**
		 * Constructor for ProjectWrapper
		 */
		public ProjectWrapper(String name, String key, String description) {
			this.name = name;
			this.key = key;
			this.description = description;
			this.leadAccountId = LEAD_ACCOUNT_ID;
			this.projectTemplateKey = PROJECT_TEMPLATE_KEY;
		}
	}

	/**
	 * Wrapper for Jira Issue
	 */
	public class IssueWrapper {
		public String name;
		public String key;
		public String description;
		public String projectKey;
		public String summary;
		public String issueType;

		/**
		 * Constructor for IssueWrapper
		 */
		public IssueWrapper(
			String projectKey,
			String summary,
			String description,
			String issueType
		) {
			this.projectKey = projectKey;
			this.summary = summary;
			this.description = description;
			this.issueType = (String.isNotBlank(issueType)) ? issueType : 'Task';
		}

		public Map<String, Object> generateIssuePayloadMap() {
			// The main map for the payload
			Map<String, Object> issuePayloadMap = new Map<String, Object>();
			
			// The fields map
			Map<String, Object> fieldsMap = new Map<String, Object>();

			// Map for project key
			Map<String, String> projectMap = new Map<String, String>();
			projectMap.put('key', this.projectKey);
			fieldsMap.put('project', projectMap);

			// Add summary
			fieldsMap.put('summary', this.summary);

			// Add description
			fieldsMap.put('description', formatDescription(this.description));

			// Add issue type
			Map<String, String> issueTypeMap = new Map<String, String>();
			issueTypeMap.put('name', this.issueType);
			fieldsMap.put('issuetype', issueTypeMap);

			// Add the fields map to the main payload
			issuePayloadMap.put('fields', fieldsMap);

			return issuePayloadMap;
		}

		private Map<String, Object> formatDescription(String descText) {
			// Map that will be returned
			Map<String, Object> descriptionMap = new Map<String, Object>();
			descriptionMap.put('type','doc');
			descriptionMap.put('version', 1);

			// Content list
			List<Map<String,Object>> contentList = new List<Map<String, Object>>();
			// Paragraph map that will be added to contentList
			Map<String, Object> paragraphMap = new Map<String, Object>();
			paragraphMap.put('type', 'paragraph');

			// Content list within paragraphMap
			List<Map<String, Object>> textContentList = new List<Map<String, Object>>();
			Map<String, Object> textContentListMap = new Map<String, Object>();
			textContentListMap.put('type','text');
			textContentListMap.put('text', descText);

			textContentList.add(textContentListMap);

			paragraphMap.put('content', textContentList);

			descriptionMap.put('content', paragraphMap);

			return descriptionMap;
		}
	}
}
