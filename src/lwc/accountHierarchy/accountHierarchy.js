import {LightningElement} from 'lwc';
import getConfigurationData from '@salesforce/apex/AccountHierarchyController.getConfigurationData';

import Account_Hierarchy_Header from '@salesforce/label/c.Account_Hierarchy_Header';
import {handleError} from 'c/utils';

export default class AccountHierarchy extends LightningElement {

    items;
    error;
    showSpinner;

    label = {
        header : {
            name : Account_Hierarchy_Header
        }
    }

    connectedCallback() {
        this.getConfigurationData();
    }

    getConfigurationData() {
        this.showSpinner = true;
        getConfigurationData()
        .then((result) => {
            this.items = result.data.map(element => this.transformData(element));
            this.showSpinner = false;
        }).catch((error) => {
            this.error = handleError(error);
            this.showSpinner = false;
        });
    }

    transformData(account) {
        return {
            label: account.title,
            name: account.key,
            expanded: true,
            items: account.children ? account.children.map(element => this.transformData(element)) : []
        }
    }
}