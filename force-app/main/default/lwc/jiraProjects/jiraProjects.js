import { LightningElement, wire } from 'lwc';
import getProjects from '@salesforce/apex/JiraDataController.getProjects';

export default class JiraProjects extends LightningElement {
    projects = [];
    error;

    @wire(getProjects)
    wiredProjects({ data, error }) {
        if (data) {
            this.projects = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.projects = [];
        }
    }
}