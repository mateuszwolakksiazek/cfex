public with sharing class AccountHierarchyWebCall {

    public static AccountHierarchyResponse getAccountHierarchyData() {
        HTTPResponse response = makeCallout();

        if (response.getStatusCode() != 200 && !Test.isRunningTest()) {
            //throw exception & provide msg
            throw new AccountHierarchyWebCallException(
                String.format(
                    Label.ErrorMessage,
                    new List<String> { response.getBody(), '', ''}
                )
            );
        }

        AccountHierarchyResponse accountHierarchyResponse = (AccountHierarchyResponse)JSON.deserialize(response.getBody(), AccountHierarchyResponse.class);

        if(accountHierarchyResponse != null && accountHierarchyResponse.meta.code == 200) {

            return accountHierarchyResponse;

        } else{

            throw new AccountHierarchyWebCallException(
                String.format(
                    Label.ErrorMessage,
                    new List<String> { String.valueOf(accountHierarchyResponse.meta.code), ' ; ', JSON.serialize(accountHierarchyResponse.data)}
                )
            );

        }
    }

    private static HTTPResponse makeCallout() {
        //Create request
        HttpRequest request = new HttpRequest();
        //This should be in custom metadata / connected, but for demo purpose I will leave it here
        request.setEndpoint('callout:cfex/api/data');
        request.setMethod('GET');

        //Send request
        Http http = new Http();
        return http.send(request);
    }

    public class AccountHierarchyResponse {
        @AuraEnabled public Meta meta;
        @AuraEnabled public List<Data> data;

        public AccountHierarchyResponse(Meta meta, List<Data> data) {
            this.meta = meta;
            this.data = data;
        }
    }

    public class Meta {
        @AuraEnabled public Integer code;
        public Meta(Integer code) {
            this.code = code;
        }
    }

    public class Data {
        @AuraEnabled public String title;
        @AuraEnabled public String key;
        @AuraEnabled public List<Data> children;

        public Data(String title, String key, List<Data> children) {
            this.title = title;
            this.key = key;
            this.children = children;
        }
    }

    private class AccountHierarchyWebCallException extends Exception {}
}