public class MaintenanceRequestHelper {
    
    // Create new Maintenance Request for Parts that need to be serviced
    public static void updateWorkOrders(List<Case> caseList){
        List<Case> newMaintenanceRequests = new List<Case>();
        // Gathering Work Part with shortest maintenance cycle
        for(Case c : [
            SELECT 
                Id, 
                Status, 
                Type, 
                Origin, 
                Vehicle__c,
                Equipment__c, 
                Subject, 
                Date_Reported__c, 
                Date_Due__c,
                (SELECT 
                    Equipment__r.Maintenance_Cycle__c 
                FROM Work_Parts__r 
                ORDER BY Equipment__r.Maintenance_Cycle__c ASC LIMIT 1) 
            FROM Case
            WHERE Id IN : caseList]) {

            if(c.Status == 'Closed' && (c.Type == 'Routine Maintenance' || c.Type == 'Repair')) {
                Case newCase = new Case(
                    Status = 'New',
                    Origin = 'Web',
                    Type = 'Routine Maintenance',
                    Vehicle__c = c.Vehicle__c,
                    Equipment__c = c.Equipment__c,
                    Subject = 'New Routine Maintenance Request for ' + String.valueOf(c.Vehicle__c),
                    Date_Reported__c = System.today(),
                    // Setting due date to shortest maintenance cycle of the queried work part
                    Date_Due__c = (c.Work_Parts__r.size() > 0 ? System.today().addDays(Integer.valueOf(c.Work_Parts__r[0].Equipment__r.Maintenance_Cycle__c)) : System.today())
                );
                
                newMaintenanceRequests.add(newCase);
            }
        }
        // Check for empty list and insert new Maintenance Requests
        if(!newMaintenanceRequests.isEmpty()) {
            insert newMaintenanceRequests;
        }
    }        
}