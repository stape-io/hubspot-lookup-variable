# HubSpot Lookup Variable for Server-Side GTM

This variable template retrieves contact information from the HubSpot CRM Contact API. It allows you to dynamically enrich your server-side event data with valuable customer properties directly from your HubSpot account.

## Features

- **Direct CRM Integration:** Queries the HubSpot CRM API to fetch up-to-date user data based on unique identifiers like Email or Contact ID.

- **Built-in Caching:** Utilizes Server-Side GTM's `templateDataStorage` to cache responses, preventing redundant API calls for the same user and protecting your HubSpot API quota.

- **Flexible Output:** Extract the entire contact object or strictly filter for specific properties (e.g., `firstname`, `phone`).

## Configuration

### HubSpot Authentication

- **Private App Access Token**: Enter your HuåbSpot Private App Access Token to act as the Bearer token for API authorization. _(Note: Legacy API keys are deprecated; you must use a Private App token )._

### Lookup Parameters

- **Identifier Choice**: Choose the key used to look up the user in HubSpot. Options include:
  - **Email**
  - **Contact ID**
  - **Other unique identifier** (Allows you to specify a custom key)

- **Identifier Value**: The dynamic value (usually an Event Data variable) to search for.
- **Properties to Retrieve (Optional)**: A comma-separated list of contact properties to return from HubSpot (e.g., `email,firstname,lastname,phone`).

### Output Format

- **Return entire object**: The variable will return the complete response object provided by HubSpot.
- **Return custom properties**: Allows you to define a comma-separated list of properties. The variable will return a clean object containing _only_ those specific properties. If only one property is defined, it will return its string value directly.

## Useful Links

- [HubSpot Private Apps Documentation](https://developers.hubspot.com/docs/apps/legacy-apps/private-apps/overview#make-api-calls-with-your-app%E2%80%99s-access-token)

## Open Source

Hubspot Lookup Variable for Google Tag Manager Server Container is developed and maintained by [Stape Team](https://stape.io/) under the Apache 2.0 license.
