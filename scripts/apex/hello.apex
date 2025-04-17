String randomNumber = String.valueOf(Integer.valueOf(Math.random() * 100)); //generate random number between 0 and 99
// JiraWrapper.ProjectWrapper projectWrapper = new JiraWrapper.ProjectWrapper(
// 	'Test Project ' + randomNumber,
// 	'T' + randomNumber,
// 	'Test Description ' + randomNumber
// );
// JiraAPIService.createProject(projectWrapper);

//create issue
randomNumber = '60';
JiraWrapper.IssueWrapper issueWrapper = new JiraWrapper.IssueWrapper(
	'T' + randomNumber,
	'Test Issue ' + randomNumber,
	'Test Description ' + randomNumber,
	'Task'
);
System.debug(JSON.serialize(issueWrapper));
JiraAPIService.createIssue(issueWrapper);

JiraApiSetting__mdt config = JiraApiSetting__mdt.getInstance('Active');
System.debug(config);