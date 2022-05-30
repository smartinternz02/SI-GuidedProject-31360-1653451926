public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    // Allow trigger to make callout
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){

        // Http endpoint and http method
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        // Check response status
        if (response.getStatusCode() == 200) {
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<Product2> productList = new List<Product2>();
            for(Object obj : results) {
                Map<String,Object> objMap = (Map<string,Object>)obj;
                // Get values from JSON and assign them to corresponding Product fields
                Product2 newProd = new Product2(
                    Cost__c = Integer.valueOf(objMap.get('cost')),
                    Lifespan_Months__c = Integer.valueOf(objMap.get('lifespan')),
                    Maintenance_Cycle__c = Integer.valueOf(objMap.get('maintenanceperiod')),
                    Name = String.valueOf(objMap.get('name')),
                    Current_Inventory__c = Integer.valueOf(objMap.get('quantity')),
                    Replacement_Part__c = Boolean.valueOf(objMap.get('replacement')),
                    Warehouse_SKU__c = String.valueOf(objMap.get('sku'))
                );
                productList.add(newProd);
            }
            upsert productList;
        }
    }
}