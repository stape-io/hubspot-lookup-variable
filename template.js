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
