JiraWrapper.ProjectWrapper projectWrapper = new JiraWrapper.ProjectWrapper('OBAMA088','OBAMA128','Best president ever and this project will prove it ');

System.debug('projectWrapper:' + projectWrapper);

JiraAPIService.createProject(projectWrapper);

// JiraLogger__c log = new JiraLogger__c();
// log.Log_Type__c = 'INFO';
// log.Message__c = 'Test';
// insert log;