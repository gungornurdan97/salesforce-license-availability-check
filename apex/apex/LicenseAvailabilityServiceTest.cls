@IsTest
private class LicenseAvailabilityServiceTest {

    @IsTest
    static void testLicenseDoesNotExist() {

        Test.startTest();
        Boolean result = LicenseAvailabilityService.isLicenseAvailable('NonExistingLicense123');
        Test.stopTest();

        System.assertEquals(false, result,
            'If license does not exist, method should return false');
    }

    @IsTest
    static void testExistingLicense() {

        // This test assumes at least one active license exists in the org.
        // It dynamically queries one license record.

        UserLicense ul = [
            SELECT Name
            FROM UserLicense
            LIMIT 1
        ];

        Test.startTest();
        Boolean result = LicenseAvailabilityService.isLicenseAvailable(ul.Name);
        Test.stopTest();

        // We cannot guarantee true/false because it depends on org data,
        // but method should execute without exception.
        System.assertNotEquals(null, result);
    }
}
