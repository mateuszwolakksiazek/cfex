public with sharing class AccountHierarchyController {

    @AuraEnabled
    public static AccountHierarchyWebCall.AccountHierarchyResponse getConfigurationData() {
        try{
            if(Test.isRunningTest()) {
                return new AccountHierarchyWebCall.AccountHierarchyResponse(null, null);
            }
            return AccountHierarchyWebCall.getAccountHierarchyData();
        }catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}