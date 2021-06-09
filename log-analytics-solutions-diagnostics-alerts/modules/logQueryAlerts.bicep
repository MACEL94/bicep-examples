param location string
param workspaceId string
param actionGroupId string

var breakGlassAccountAlertName = 'Break Glass Account Login Alert'

resource breakGlassAccountAlert 'microsoft.insights/scheduledQueryRules@2018-04-16' = {
  name: breakGlassAccountAlertName
  location: location
  properties: {
    description: 'A login with an account marked as a break glass account was detected'
    enabled: 'true'
    source: {
      query: 'SigninLogs\n| project UserId\n| where UserId contains \'c70ca699-5c28-40c2-9000-96aded021ddb\''
      dataSourceId: workspaceId
      queryType: 'ResultCount'
    }
    schedule: {
      frequencyInMinutes: 60
      timeWindowInMinutes: 60
    }
    action: {
      severity: '0'
      aznsAction: {
        actionGroup: [
          actionGroupId
        ]
      }
      trigger: {
        thresholdOperator: 'GreaterThan'
        threshold: 0
      }
      'odata.type': 'Microsoft.WindowsAzure.Management.Monitoring.Alerts.Models.Microsoft.AppInsights.Nexus.DataContracts.Resources.ScheduledQueryRules.AlertingAction'
    }
  }
}
