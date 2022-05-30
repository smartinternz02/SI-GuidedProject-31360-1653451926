@isTest
public class WarehouseSyncScheduleTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @isTest static void testSchedulable() {
        String jobId = System.schedule('ScheduledApexTest',
                                       CRON_EXP, 
                                       new WarehouseSyncSchedule());
	}
}