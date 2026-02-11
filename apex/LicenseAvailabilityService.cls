public with sharing class LicenseAvailabilityService {

    public static Boolean isLicenseAvailable(String licenseName) {

        List<UserLicense> licenses = [
            SELECT Status, TotalLicenses, UsedLicenses
            FROM UserLicense
            WHERE Name = :licenseName
            LIMIT 1
        ];

        if (licenses.isEmpty()) {
            return false;
        }

        UserLicense ul = licenses[0];

        return ul.Status == 'Active' &&
               ul.UsedLicenses < ul.TotalLicenses;
    }
}
