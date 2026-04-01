___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Hubspot Lookup",
  "categories": [
    "CRM",
    "LOOKUP"
  ],
  "description": "Retrieves contact information from HubSpot CRM Contact API.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "configGroup",
    "displayName": "HubSpot Authentication",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "TEXT",
        "name": "apiAccessToken",
        "displayName": "Private App Access Token",
        "simpleValueType": true,
        "help": "Enter your HubSpot Private App Access Token. For more information on how to get your token, check this \u003ca href\u003d\"https://developers.hubspot.com/docs/apps/legacy-apps/private-apps/overview#make-api-calls-with-your-app%E2%80%99s-access-token\"\u003edocumentation\u003c/a\u003e.",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "lookupGroup",
    "displayName": "Lookup Parameters",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "RADIO",
        "name": "identifierChoice",
        "displayName": "Choose the identifier used to lookup user data.",
        "radioItems": [
          {
            "value": "email",
            "displayValue": "Email"
          },
          {
            "value": "id",
            "displayValue": "Contact ID"
          },
          {
            "value": "other",
            "displayValue": "Other unique identifier",
            "subParams": [
              {
                "type": "TEXT",
                "name": "identifierKey",
                "displayName": "Unique identifier",
                "simpleValueType": true
              }
            ]
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "identifierValue",
        "displayName": "Identifier value",
        "simpleValueType": true,
        "help": "",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "propertiesToRetrieve",
        "displayName": "Properties to Retrieve (Optional)",
        "simpleValueType": true,
        "help": "A comma-separated list of contact properties to return (e.g., firstname,lastname,phone,city).",
        "valueHint": "email,firstname,lastname,phone"
      },
      {
        "type": "RADIO",
        "name": "outputFormat",
        "displayName": "Output Format",
        "radioItems": [
          {
            "value": "all",
            "displayValue": "Return entire object"
          },
          {
            "value": "custom",
            "displayValue": "Return custom properties",
            "help": "A comma-separated list of user properties to return as an object (e.g., email,firstname,lastname,phone,city).\u003c/br\u003e\nFor the above example, the returned object would be \u003c/br\u003e\n\u003cb\u003e {\u003c/br\u003e\n  email: \u0027jane_doe@email.com\u0027, \u003c/br\u003e\n  firstname: \u0027Jane\u0027, \u003c/br\u003e\n  lastname: \u0027Doe\u0027, \u003c/br\u003e\n  phone: \u0027+5519981555555\u0027, \u003c/br\u003e\n  city: Testland \u003c/br\u003e\n} \u003c/b\u003e\u003c/br\u003e\nIf only one property is chosen, the variable will return its value instead of an object.",
            "subParams": [
              {
                "type": "TEXT",
                "name": "customProperties",
                "displayName": "",
                "simpleValueType": true,
                "enablingConditions": [
                  {
                    "paramName": "outputFormat",
                    "paramValue": "custom",
                    "type": "EQUALS"
                  }
                ],
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              }
            ]
          }
        ],
        "simpleValueType": true,
        "defaultValue": "all"
      }
    ]
  },
  {
    "displayName": "Logs Settings",
    "name": "logsGroup",
    "groupStyle": "ZIPPY_CLOSED",
    "type": "GROUP",
    "subParams": [
      {
        "type": "RADIO",
        "name": "logType",
        "radioItems": [
          {
            "value": "no",
            "displayValue": "Do not log"
          },
          {
            "value": "debug",
            "displayValue": "Log to console during debug and preview"
          },
          {
            "value": "always",
            "displayValue": "Always log to console"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "debug"
      }
    ]
  },
  {
    "displayName": "BigQuery Logs Settings",
    "name": "bigQueryLogsGroup",
    "groupStyle": "ZIPPY_CLOSED",
    "type": "GROUP",
    "subParams": [
      {
        "type": "RADIO",
        "name": "bigQueryLogType",
        "radioItems": [
          {
            "value": "no",
            "displayValue": "Do not log to BigQuery"
          },
          {
            "value": "always",
            "displayValue": "Log to BigQuery"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "no"
      },
      {
        "type": "GROUP",
        "name": "logsBigQueryConfigGroup",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "TEXT",
            "name": "logBigQueryProjectId",
            "displayName": "BigQuery Project ID",
            "simpleValueType": true,
            "help": "Optional. \u003cbr\u003e\u003cbr\u003eIf omitted, it will be retrieved from the environment variable \u003ci\u003eGOOGLE_CLOUD_PROJECT\u003c/i\u003e."
          },
          {
            "type": "TEXT",
            "name": "logBigQueryDatasetId",
            "displayName": "BigQuery Dataset ID",
            "simpleValueType": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "type": "TEXT",
            "name": "logBigQueryTableId",
            "displayName": "BigQuery Table ID",
            "simpleValueType": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          }
        ],
        "enablingConditions": [
          {
            "paramName": "bigQueryLogType",
            "paramValue": "always",
            "type": "EQUALS"
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const BigQuery = require('BigQuery');
const encodeUriComponent = require('encodeUriComponent');
const getAllEventData = require('getAllEventData');
const getContainerVersion = require('getContainerVersion');
const getRequestHeader = require('getRequestHeader');
const getTimestampMillis = require('getTimestampMillis');
const getType = require('getType');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const makeString = require('makeString');
const sendHttpRequest = require('sendHttpRequest');
const templateDataStorage = require('templateDataStorage');

/*==============================================================================
==============================================================================*/
const eventData = getAllEventData();

if (shouldExitEarly(data, eventData)) return;

return sendRequest();

/*==============================================================================
Vendor related functions
==============================================================================*/

function sendRequest() {
  const identifierKey =
    data.identifierChoice === 'other'
      ? makeString(data.identifierKey)
      : makeString(data.identifierChoice);
  const identifierValue = normalizeIfDefined(makeString(data.identifierValue)) || '';
  const cacheKey = 'hubspot_contact_' + enc(identifierValue);
  const storedUserData = templateDataStorage.getItemCopy(cacheKey);

  if (storedUserData !== null) {
    return formatOutput(storedUserData, data.outputFormat);
  }

  let url = 'https://api.hubapi.com/crm/2026-03/objects/contacts/' + enc(identifierValue);
  let queryParams = [];

  if (data.identifierChoice !== 'id') {
    queryParams.push('idProperty=' + enc(identifierKey));
  }

  if (data.propertiesToRetrieve) {
    const sanitizedProperties = makeString(data.propertiesToRetrieve)
      .split(',')
      .map((property) => normalizeIfDefined(property));
    queryParams.push('properties=' + enc(sanitizedProperties));
  }

  if (queryParams.length) {
    url += '?' + queryParams.join('&');
  }

  log({
    Name: 'HubspotLookup',
    Type: 'Request',
    EventName: 'Lookup',
    RequestMethod: 'GET',
    RequestUrl: url
  });

  return sendHttpRequest(url, {
    method: 'GET',
    headers: {
      Authorization: 'Bearer ' + data.apiAccessToken,
      'Content-Type': 'application/json'
    },
    timeout: 3000
  })
    .then((result) => {
      log({
        Name: 'HubspotLookup',
        Type: 'Response',
        EventName: 'Lookup',
        ResponseStatusCode: result.statusCode,
        ResponseHeaders: result.headers,
        ResponseBody: result.body
      });

      if (result.statusCode >= 200 && result.statusCode < 300) {
        const userData = JSON.parse(result.body || '{}');
        templateDataStorage.setItemCopy(cacheKey, userData);

        return formatOutput(userData, data.outputFormat);
      }

      return undefined;
    })
    .catch((error) => {
      log({
        Name: 'HubspotLookup',
        Type: 'Message',
        EventName: 'Lookup',
        Message: 'API call failed or timed out',
        Reason: JSON.stringify(error)
      });
      return undefined;
    });
}
/*==============================================================================
  Helpers
==============================================================================*/

function shouldExitEarly(data, eventData) {
  const url = eventData.page_location || getRequestHeader('referer');
  if (url && url.lastIndexOf('https://gtm-msr.appspot.com/', 0) === 0) return true;

  if (!data.identifierValue) return true;

  return false;
}

function formatOutput(userData, format) {
  const formattedData = {};
  if (format === 'custom') {
    if (!data.customProperties) return userData;
    const customPropertiesArray = data.customProperties.split(',');

    if (customPropertiesArray.length > 1) {
      customPropertiesArray.forEach((property) => {
        property = normalizeIfDefined(property);
        formattedData[property] = userData.properties[property];
      });
      return formattedData;
    } else return userData.properties[customPropertiesArray[0]];
  }
  return userData;
}

function normalizeIfDefined(value) {
  return value ? makeString(value).toLowerCase().trim() : value;
}

function enc(data) {
  if (['null', 'undefined'].indexOf(getType(data)) !== -1) data = '';
  return encodeUriComponent(makeString(data));
}

function log(rawDataToLog) {
  const logDestinationsHandlers = {};
  if (determinateIsLoggingEnabled()) logDestinationsHandlers.console = logConsole;
  if (determinateIsLoggingEnabledForBigQuery()) logDestinationsHandlers.bigQuery = logToBigQuery;

  rawDataToLog.TraceId = getRequestHeader('trace-id');

  const keyMappings = {
    bigQuery: {
      Name: 'tag_name',
      Type: 'type',
      TraceId: 'trace_id',
      EventName: 'event_name',
      RequestMethod: 'request_method',
      RequestUrl: 'request_url',
      RequestBody: 'request_body',
      ResponseStatusCode: 'response_status_code',
      ResponseHeaders: 'response_headers',
      ResponseBody: 'response_body'
    }
  };

  for (const logDestination in logDestinationsHandlers) {
    const handler = logDestinationsHandlers[logDestination];
    if (!handler) continue;

    const mapping = keyMappings[logDestination];
    const dataToLog = mapping ? {} : rawDataToLog;

    if (mapping) {
      for (const key in rawDataToLog) {
        const mappedKey = mapping[key] || key;
        dataToLog[mappedKey] = rawDataToLog[key];
      }
    }

    handler(dataToLog);
  }
}

function logConsole(dataToLog) {
  logToConsole(JSON.stringify(dataToLog));
}

function logToBigQuery(dataToLog) {
  const connectionInfo = {
    projectId: data.logBigQueryProjectId,
    datasetId: data.logBigQueryDatasetId,
    tableId: data.logBigQueryTableId
  };
  dataToLog.timestamp = getTimestampMillis();

  ['request_body', 'response_headers', 'response_body'].forEach((p) => {
    if (dataToLog[p]) dataToLog[p] = JSON.stringify(dataToLog[p]);
  });
  BigQuery.insert(connectionInfo, [dataToLog], { ignoreUnknownValues: true });
}

function determinateIsLoggingEnabled() {
  const containerVersion = getContainerVersion();
  const isDebug = !!(
    containerVersion &&
    (containerVersion.debugMode || containerVersion.previewMode)
  );

  if (!data.logType) return isDebug;
  if (data.logType === 'no') return false;
  if (data.logType === 'debug') return isDebug;

  return data.logType === 'always';
}

function determinateIsLoggingEnabledForBigQuery() {
  if (data.bigQueryLogType === 'no') return false;
  return data.bigQueryLogType === 'always';
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://api.hubapi.com/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "all"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "headerWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "trace-id"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "referer"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_bigquery",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedTables",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "projectId"
                  },
                  {
                    "type": 1,
                    "string": "datasetId"
                  },
                  {
                    "type": 1,
                    "string": "tableId"
                  },
                  {
                    "type": 1,
                    "string": "operation"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Successful API Call - Returns All Data
  code: "const mockData = {\n  apiAccessToken: 'mock-private-app-token',\n  identifierChoice:\
    \ 'email',\n  identifierValue: 'johndoe@example.com',\n  outputFormat: 'all'\n\
    };\n\nmock('sendHttpRequest', (url, options) => {\n  assertThat(url).isEqualTo('https://api.hubapi.com/crm/2026-03/objects/contacts/johndoe%40example.com?idProperty=email');\n\
    \  assertThat(options.headers.Authorization).isEqualTo('Bearer mock-private-app-token');\n\
    \  \n  return Promise.create((resolve) => {\n    resolve({\n      statusCode:\
    \ 200,\n      body: JSON.stringify({\n        properties: {\n          email:\
    \ 'johndoe@example.com',\n          firstname: 'John',\n          lastname: 'Doe',\n\
    \          phone: '1234567890'\n        }\n      })\n    });\n  });\n});\n\nrunCode(mockData).then((result)\
    \ => {\n  assertThat(result.properties.email).isEqualTo('johndoe@example.com');\n\
    \  assertThat(result.properties.firstname).isEqualTo('John');\n  assertThat(result.properties.lastname).isEqualTo('Doe');\n\
    \  assertThat(result.properties.phone).isEqualTo('1234567890');\n});"
- name: Successful API Call - Returns Custom Properties Object
  code: |-
    const mockData = {
      apiAccessToken: 'test-token',
      identifierChoice: 'id',
      identifierValue: '12345',
      outputFormat: 'custom',
      customProperties: 'email, firstname , Lastname'
    };

    mock('sendHttpRequest', (url, options) => {
       assertThat(url).isEqualTo('https://api.hubapi.com/crm/2026-03/objects/contacts/12345');
      return Promise.create((resolve) => {
        resolve({
          statusCode: 200,
          body: JSON.stringify({
            properties: {
              email: 'janedoe@example.com',
              firstname: 'Jane',
              lastname: 'Doe' // This should be filtered out
            }
          })
        });
      });
    });

    runCode(mockData).then((result) => {
      // Assert that it returns an object with ONLY the requested keys
      assertThat(result).isEqualTo({
        email: 'janedoe@example.com',
        firstname: 'Jane',
        lastname: 'Doe'
      });
      assertThat(result.phone).isUndefined();
    });
- name: Uses Cached Data (Bypasses API)
  code: |-
    const mockData = {
      apiAccessToken: 'test-token',
      identifierChoice: 'email',
      identifierValue: 'johndoe@example.com',
      outputFormat: 'all'
    };

    mockObject('templateDataStorage', {
      getItemCopy: (key) => {
        if (key === 'hubspot_contact_johndoe%40example.com') {
          return {
            id:12345,
            properties: {
              email: 'johndoe@example.com',
              firstname: 'John',
              lastname: 'Doe'
            }
          };
        }
        return null;
      },
      setItemCopy: () => {}
    });

    const result = runCode(mockData);
      assertApi('sendHttpRequest').wasNotCalled();
      assertThat(result.properties.email).isEqualTo('johndoe@example.com');
- name: Checks effectiveness of first guard clause
  code: |-
    const mockData = {
      apiAccessToken: 'test-token',
      identifierChoice: 'email',
      identifierValue: 'test@test.com',
      outputFormat: 'all'
    };

    let mockEventData = {'page_location': 'https://gtm-msr.appspot.com/'};

    mock('getAllEventData', () => mockEventData);

    runCode(mockData);

    assertApi('sendHttpRequest').wasNotCalled();
- name: Checks effectiveness of second guard clause
  code: |-
    const mockData = {
      apiAccessToken: 'test-token',
      identifierChoice: 'email',
      identifierValue: false,
      outputFormat: 'all'
    };

    runCode(mockData);

    assertApi('sendHttpRequest').wasNotCalled();
- name: API Error Returns Undefined Safely
  code: |-
    const mockData = {
      apiAccessToken: 'test-token',
      identifierChoice: 'email',
      identifierValue: 'not-found@example.com',
      outputFormat: 'all'
    };

    mock('sendHttpRequest', (url, options) => {
      return Promise.create((resolve) => {
        resolve({
          statusCode: 404,
          body: JSON.stringify({ message: 'contact not found' })
        });
      });
    });

    runCode(mockData).then((result) => {
      assertThat(result).isUndefined();
    });
setup: |-
  const Promise = require('Promise');
  const JSON = require('JSON');

  mockObject('templateDataStorage', {
    getItemCopy: () => null,
    setItemCopy: () => {}
  });


___NOTES___

Created on 2026


