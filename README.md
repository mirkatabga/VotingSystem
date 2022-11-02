# Disclaimer

All characters and events depicted in this document are entirely fictitious. Any similarity to actual events or persons, living or dead, is purely coincidental.

# Project Specifics

## Problem Description / Idea

Here in SoftServe, we used to make decisions based on thoughts of our colleagues. That's for we would like you to develop for us a solution, based on voting model, which we will be able to use for various purposes, like:

- voting for idea;
- voting for employee;
- feedback gathering;
- combination of above.

Provided solution should be distributed as an unlocked package and follow UI/UX and development best practices.

## High-level Requirements / Features Description

List of initial requirements is available below.


1 Solution should consist of below modules:
  1. Configuration;
  2. Moderation;
  3. Voting;
  4. Analysis\*.

\* Analysis module has lowest priority.

1.1 Configuration module should allow authorized user to:
  1. Crate different types of voting (for idea/employee/etc);
  2. Create voting campaigns;
  3. Assign one or more voting to campaign;
  4. Assign user or group of users to campaigns as:
    1. moderators;
    2. voters;
    3. analysts.
  5. Configure locations for campaign;
  6. Set campaign start and end dates;
  7. Launch campaign.
 
1.2 Moderation module should allow authorized user to:
  1. View campaigns he need to moderate;
  2. See general voting statistics, but not exact voting results;
  3. Start, pause or stop campaign.
 
 1.3 Voting module should allow authorized user to:
  1. View campaigns where he needs to vote;
  2. Vote at assigned open campaigns;
  3. See his votes for campaigns;
   
1.4 Analysis module should allow authorized user to:
  1. See list of assigned campaigns;
  2. See results of assigned campaigns, excluding basic PII.
 
2 Authorized user assigned to "Configurator" role should:
1. Use configuration application as per req. 1.1;
 
3 Authorized user assigned to "Moderator" role should:
   1. Use moderation application as per req. 1.2;
 
4 Authorized user assigned to "Voter" role should:
   1. Use voting application as per req. 1.3;
   2. Be allowed to vote in open voting assigned to him;
   3. Not be allowed to change his decisions after submission of his vote in voting;
   4. Not see votes of others.
 
5 Authorized user assigned to "Analyst" role should:
   1. Use analytics application as per req. 1.4.
 
6 System should allow one user to be assigned to multiple roles at a time. 

7 Things which are not allowed should be considered as restricted. 

8 System should have an option to accept external campaigns requests using Web2Case (or similar) technology. After external request is submitted, users with "Configurator" role should receive email notification and act correspondingly.

9 System should have automated locations' address resolution into coordinates using OpenCage Geocoding API.

**Important notes:**

1. Above list is not final and may be adjusted during upcoming workshops/mails exchange;
2. Analytics module has lower priority than any other module;
3. You should not use OOTB "Campaign" object. Instead, create a custom one.