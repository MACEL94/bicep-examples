param workspaceId string
param automationAccountId string
param actionGroupId string

var cpuAlertName = 'Windows and Linux CPU'
var windowsMemoryUsageAlertName = 'Windows Memory Usage'
var windowsDiskSpaceAlertName = 'Windows Disk Space'
var heartbeatAlertName = 'Heartbeats'
var updateDeploymentFailureAlertName = 'Update Deployment Failure'

resource cpuAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: cpuAlertName
  location: 'global'
  properties: {
    description: 'CPU of a VM is greater than or equal to 75%'
    severity: 3
    enabled: true
    scopes: [
      workspaceId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    targetResourceType: 'Microsoft.OperationalInsights/workspaces'
    targetResourceRegion: 'westeurope'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          dimensions: [
            {
              name: 'Computer'
              operator: 'Include'
              values: [
                '*'
              ]
            }
            {
              name: 'ObjectName'
              operator: 'Include'
              values: [
                'Processor'
              ]
            }
          ]
          metricName: 'Average_% Processor Time'
          metricNamespace: 'Microsoft.OperationalInsights/workspaces'
          name: 'Metric1'
          operator: 'GreaterThanOrEqual'
          threshold: 75
          timeAggregation: 'Average'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: actionGroupId
      }
    ]
  }
}

resource windowsMemoryUsageAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: windowsMemoryUsageAlertName
  location: 'global'
  properties: {
    description: 'Memory of a Windows VM is greater than or equal to 75%'
    severity: 3
    enabled: true
    scopes: [
      workspaceId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    targetResourceType: 'Microsoft.OperationalInsights/workspaces'
    targetResourceRegion: 'westeurope'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          dimensions: [
            {
              name: 'Computer'
              operator: 'Include'
              values: [
                '*'
              ]
            }
            {
              name: 'ObjectName'
              operator: 'Include'
              values: [
                'Memory'
              ]
            }
          ]
          metricName: 'Average_% Committed Bytes In Use'
          metricNamespace: 'Microsoft.OperationalInsights/workspaces'
          name: 'Metric1'
          operator: 'GreaterThanOrEqual'
          threshold: 75
          timeAggregation: 'Average'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: actionGroupId
      }
    ]
  }
}

resource windowsDiskSpaceAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: windowsDiskSpaceAlertName
  location: 'global'
  properties: {
    description: 'Free disk space is less than or equal to 10%'
    severity: 2
    enabled: true
    scopes: [
      workspaceId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    targetResourceType: 'Microsoft.OperationalInsights/workspaces'
    targetResourceRegion: 'westeurope'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          dimensions: [
            {
              name: 'Computer'
              operator: 'Include'
              values: [
                '*'
              ]
            }
            {
              name: 'ObjectName'
              operator: 'Include'
              values: [
                'LogicalDisk'
              ]
            }
            {
              name: 'InstanceName'
              operator: 'Exclude'
              values: [
                '_Total'
                'D:'
                'HarddiskVolume1'
              ]
            }
          ]
          metricName: 'Average_% Free Space'
          metricNamespace: 'Microsoft.OperationalInsights/workspaces'
          name: 'Metric1'
          operator: 'LessThanOrEqual'
          threshold: 10
          timeAggregation: 'Average'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: actionGroupId
      }
    ]
  }
}

resource heartbeatAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: heartbeatAlertName
  location: 'global'
  properties: {
    description: 'VM is not responding to Heartbeats'
    severity: 0
    enabled: true
    scopes: [
      workspaceId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    targetResourceType: 'Microsoft.OperationalInsights/workspaces'
    targetResourceRegion: 'westeurope'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          dimensions: [
            {
              name: 'Computer'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
          metricName: 'Heartbeat'
          metricNamespace: 'Microsoft.OperationalInsights/workspaces'
          name: 'Metric1'
          operator: 'LessThan'
          threshold: 3
          timeAggregation: 'Total'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: actionGroupId
      }
    ]
  }
}

resource updateDeploymentFailureAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: updateDeploymentFailureAlertName
  location: 'global'
  properties: {
    description: 'Update Deployment has failed'
    severity: 2
    enabled: true
    scopes: [
      automationAccountId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          dimensions: [
            {
              name: 'SoftwareUpdateConfigurationName'
              operator: 'Include'
              values: [
                '*'
              ]
            }
            {
              name: 'Status'
              operator: 'Include'
              values: [
                'Failed'
              ]
            }
          ]
          metricName: 'TotalUpdateDeploymentRuns'
          metricNamespace: 'Microsoft.Automation/automationAccounts'
          name: 'Metric1'
          operator: 'GreaterThan'
          threshold: 0
          timeAggregation: 'Total'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: actionGroupId
      }
    ]
  }
}
