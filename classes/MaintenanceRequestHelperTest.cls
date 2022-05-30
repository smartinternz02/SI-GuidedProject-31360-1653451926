@isTest
public class MaintenanceRequestHelperTest {
    @isTest static void testSingleRecord() {
        Integer i = 0;
        
        Vehicle__c vehicle = DataFactory.buildVehicle(i);
        insert vehicle;
        
        Case mr = DataFactory.buildCase(vehicle.Id);
        insert mr;
        
        List<Case> mrList = new List<Case>([SELECT Status FROM Case WHERE Id =: mr.Id]);
        for(Case c : mrList) {
            c.Status = 'Closed';
        }
        update mrList;
        
        List<Case> newList = new List<Case>([SELECT Id FROM Case WHERE Status = 'New']);
        System.assertEquals(1, newList.size());
    }
    
    @isTest static void testBulk() {
        List<Vehicle__c> vehicleList = new List<Vehicle__c>();
        List<Case> mrList = new List<Case>();
        for(Integer i = 0; i < 300; i++) {
            Vehicle__c vehicle = DataFactory.buildVehicle(i);
            vehicleList.add(vehicle);
        
            Case mr = DataFactory.buildCase(vehicle.Id);
            mrList.add(mr);
		}
        insert vehicleList;
        insert mrList;
        
        List<Case> mrToClose = new List<Case>([SELECT Status FROM Case]);
        for(Case c : mrToClose) {
            c.Status = 'Closed';
		}
        update mrToClose;
        
        List<Case> newMRs = new List<Case>([SELECT Id FROM Case WHERE Status = 'New']);
        System.assertEquals(300, newMRs.size());
    }
}