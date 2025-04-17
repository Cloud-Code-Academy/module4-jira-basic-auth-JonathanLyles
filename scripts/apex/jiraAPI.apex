final String NAMED_CREDENTIAL = 'JiraAPI';
final String JIRA_GET_PROJECTS_URL = '/rest/api/3/project';
HttpRequest request = new HttpRequest();
request.setEndpoint('https://jonathanlyles.atlassian.net/rest/api/3/project');
request.setMethod('GET');
request.setHeader('Content-Type', 'application/json');
request.setHeader('Accept', 'application/json');
request.setHeader('Authorization', 'Basic am9uYXRoYW4ubHlsZXMubGlua2VkaW5AZ21haWwuY29tOkFUQVRUM3hGZkdGMEtERTF5bnJFZFAzcWVlekhENTduel8tcmw1UjZxampUOGdTV19vT1FvOVQ2cDI1T3FoVHhHZTByTWFtRUh0cnF5UlBzU2p5dHJtMDRWRTBXWEs0RnNFYmJhSWhUN2xSYnVwbkFDODNpbHNNVnZLV2lJZ3Y5MlppY19lSkl6dld5SG8wY1YxN29odWRjT2RjMGotUGJuNmEteVl5S0pTbWFmTWdZSXctcjZMaz1FOEJBN0Q2NA==');
httpResponse response = new Http().send(request);   
if (response.getStatusCode() == 200) {
    System.debug('Response: ' + response.getBody());
} else {
    System.debug('Error: ' + response.getStatusCode() + ' - ' + response.getBody());
}
