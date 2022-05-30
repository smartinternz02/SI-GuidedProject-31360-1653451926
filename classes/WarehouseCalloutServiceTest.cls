@isTest
private class WarehouseCalloutServiceTest {
	public static testmethod void testWareHouseCallout() {
		String body = '[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"}]';
		WarehouseCalloutServiceMock fakeResponse = new WarehouseCalloutServiceMock(200, 'Complete', body, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		WarehouseCalloutService.runWarehouseEquipmentSync();
		System.assertEquals(fakeResponse.bodyAsString, body);
		}
}