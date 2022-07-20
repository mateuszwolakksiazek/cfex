@IsTest
public with sharing class AccountHierarchyController_Test {

    @isTest
    static void getConfigurationData_shouldReturnNulls_getOrMock() {
        AccountHierarchyWebCall.AccountHierarchyResponse accountHierarchyResponse;
        Test.startTest();
        //use correct user on a org where do they exists
        System.runAs(new User(Id = UserInfo.getUserId())) {
            accountHierarchyResponse = AccountHierarchyController.getConfigurationData();
        }
        Test.stopTest();
        System.assertNotEquals(null, accountHierarchyResponse, 'Response should BE returned');
        System.assert(accountHierarchyResponse.meta == null && accountHierarchyResponse.data == null, 'Both values should be null');
    }

}