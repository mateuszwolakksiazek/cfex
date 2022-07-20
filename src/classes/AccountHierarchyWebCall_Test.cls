@IsTest
public with sharing class AccountHierarchyWebCall_Test {

    @IsTest
    static void getAccountHierarchyData_shouldReturn_dataMocked() {
        AccountHierarchyWebCall.AccountHierarchyResponse accountHierarchyResponse;

        Test.setMock(HttpCalloutMock.class, new AccountHierarchyWebCallMock(200));
        Test.startTest();
        //use correct user on a org where do they exists
        System.runAs(new User(Id = UserInfo.getUserId())) {
            accountHierarchyResponse = AccountHierarchyWebCall.getAccountHierarchyData();
        }
        Test.stopTest();

        System.assertNotEquals(null, accountHierarchyResponse, 'Response should NOT be null');
        System.assert(!accountHierarchyResponse.data.isEmpty(), 'Response data should contain at least one record');
    }


    @IsTest
    static void getAccountHierarchyData_shouldErrorOccur_dataMocked() {
        AccountHierarchyWebCall.AccountHierarchyResponse accountHierarchyResponse;
        Exception ex;
        Test.setMock(HttpCalloutMock.class, new AccountHierarchyWebCallMock(500));
        Test.startTest();
        try{
            //use correct user on a org where do they exists
            System.runAs(new User(Id = UserInfo.getUserId())) {
                accountHierarchyResponse = AccountHierarchyWebCall.getAccountHierarchyData();
            }
        } catch(Exception e) {
            ex = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, ex, 'Exception should be thrown');
    }


    public class AccountHierarchyWebCallMock implements HttpCalloutMock {

        private Integer code;

        public AccountHierarchyWebCallMock(Integer code) {
            this.code = code;
        }

        private AccountHierarchyWebCall.AccountHierarchyResponse mockData() {
            AccountHierarchyWebCall.Meta meta = new AccountHierarchyWebCall.Meta(this.code);
            AccountHierarchyWebCall.Data data = new AccountHierarchyWebCall.Data('Basic Company', '001', null);
            return new AccountHierarchyWebCall.AccountHierarchyResponse(meta, new List<AccountHierarchyWebCall.Data> { data });
        }

        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody(JSON.serialize(this.mockData()));
            response.setStatusCode(this.code);
            return response;
        }
    }
}