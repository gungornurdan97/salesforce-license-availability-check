# License Availability Check in an Automated User Creation Flow
## (Approach 1: Using Salesforce Flow Only)

## Introduction

While building an automated user creation flow in Salesforce (for example, creating Community or Partner users automatically), one common issue is license availability.

Salesforce does not automatically prevent a flow from attempting to create a user when no licenses are left.
As a result, the flow may fail at runtime if the license limit has already been reached.

To solve this problem, a license availability check must be added before user creation.

This section explains the first solution:
checking license availability directly inside the Flow, without using Apex.

---

## Why License Availability Needs to Be Checked

Every Salesforce user license has:
- a total quota (how many licenses are available)
- a usage count (how many licenses are already assigned)

If a flow tries to create a user when:
- all licenses are already used, or
- the license type is inactive,

the user creation will fail.

To avoid this, the flow should check license availability before attempting to create the user.

---

## Where Does Salesforce Store License Information?

Salesforce stores license usage data in the UserLicense object.

This object contains key fields such as:
- Status – whether the license type is active or inactive
- TotalLicenses – total number of licenses purchased
- UsedLicenses – number of licenses currently in use

A license is considered available only if:
- the license status is Active
- the number of used licenses is less than the total number of licenses

---

## Approach 1: Checking License Availability Using Flow

This approach uses only standard Flow elements and does not require Apex.

---

### Step 1: Get the License Record

Add a Get Records element to the flow.

Object: UserLicense  
Filter Condition:
Name equals "Replace with your exact UserLicense Name value"

How many records to store:
Store only the first record

After this step, the flow has access to:
- UserLicense.Status
- UserLicense.TotalLicenses
- UserLicense.UsedLicenses

---

### Step 2: Check If the License Is Available

Add a Decision element to evaluate license availability.

Decision logic (ALL conditions must be true):
Status equals "Active"
AND
TotalLicenses > UsedLicenses

This logic ensures that:
- the license is enabled in the org
- at least one license is still available

---

### Step 3: Use the Decision Outcome

If TRUE:
The license is available, and the flow can safely continue to user creation.

If FALSE:
The license is not available, and the flow should stop or handle the situation
(for example, by skipping user creation or notifying an administrator).

---

## Example Scenarios

| Status   | TotalLicenses | UsedLicenses | Result |
|---------|---------------:|-------------:|--------|
| Active  | 10             | 8            | License available |
| Active  | 5              | 5            | No license available |
| Disabled| 10             | 3            | License unavailable |
| Disabled| 0              | 0            | License unavailable |

---

## Summary of the Flow-Based Approach

- License data is retrieved from the UserLicense object.
- Availability is determined by checking status and remaining capacity.
- This solution is fully declarative.
- It is easy to understand and suitable for beginner and admin-level implementations.
- No Apex code is required.

---

## Important Note on Concurrent User Creation

This flow-based approach checks license availability at runtime for each execution.

When multiple users are created at the same time (for example, during bulk data loads or parallel automation runs), license usage may not be updated immediately between executions.

As a result:
- Some user creation attempts may succeed
- Subsequent attempts may fail if the license limit is exceeded

This behavior is expected and should be considered when designing high-volume automation.
