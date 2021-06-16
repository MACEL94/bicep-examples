param location string
param locationShort string
param name string
param environment string

@description('Event log levels')
param eventLevel array = [
  'Error'
  'Warning'
]

@description('Solutions to add to workspace')
param solutions array = [
  {
    name: 'AgentHealthAssessment'
    publisher: 'Microsoft'
    promotionCode: ''
  }
  {
    name: 'AntiMalware'
    publisher: 'Microsoft'
    promotionCode: ''
  }
  {
    name: 'AzureSQLAnalytics'
    publisher: 'Microsoft'
    promotionCode: ''
  }
  {
    name: 'ChangeTracking'
    publisher: 'Microsoft'
    promotionCode: ''
  }
  {
    name: 'ContainerInsights'
    publisher: 'Microsoft'
    promotionCode: ''
  }
  {
    name: 'SecurityCenterFree'
    publisher: 'Microsoft'
    promotionCode: ''
  }
  {
    name: 'SQLAssessment'
    publisher: 'Microsoft'
    promotionCode: ''
  }
  {
    name: 'VMInsights'
    publisher: 'Microsoft'
    promotionCode: ''
  }
]

var workspaceName = toLower('log-${name}-${environment}-${locationShort}')
var automationAccountName = toLower('aa-${name}-${environment}-${locationShort}')
var appInsightsName = toLower('appi-${name}-${environment}-${locationShort}')

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 31
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
  resource systemLogs 'dataSources@2020-08-01' = {
    name: 'System'
    properties: {
      eventLogName: 'System'
      eventTypes: [for Level in eventLevel: {
        eventType: Level
     }]
    }
    kind: 'WindowsEvent'
  }
  resource applicationLogs 'dataSources@2020-08-01' = {
    name: 'Application'
    properties: {
      eventLogName: 'Application'
      eventTypes: [for Level in eventLevel: {
        eventType: Level
     }]
    }
    kind: 'WindowsEvent'
  }
  resource logicalDisk1PerfCounter 'dataSources@2020-08-01' = {
    name: 'LogicalDisk1'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Avg Disk sec/Read'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource logicalDisk2PerfCounter 'dataSources@2020-08-01' = {
    name: 'LogicalDisk2'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Avg Disk sec/Write'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource logicalDisk3PerfCounter 'dataSources@2020-08-01' = {
    name: 'LogicalDisk3'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Current Disk Queue Length'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource logicalDisk4PerfCounter 'dataSources@2020-08-01' = {
    name: 'LogicalDisk4'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Disk Reads/sec'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource logicalDisk5PerfCounter 'dataSources@2020-08-01' = {
    name: 'LogicalDisk5'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Disk Transfers/sec'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource logicalDisk6PerfCounter 'dataSources@2020-08-01' = {
    name: 'LogicalDisk6'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Disk Writes/sec'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource logicalDisk7PerfCounter 'dataSources@2020-08-01' = {
    name: 'LogicalDisk7'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 120
      counterName: 'Free Megabytes'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource logicalDisk8PerfCounter 'dataSources@2020-08-01' = {
    name: 'LogicalDisk8'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 120
      counterName: '% Free Space'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource memory1PerfCounter 'dataSources@2020-08-01' = {
    name: 'Memory1'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Available MBytes'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource memory2PerfCounter 'dataSources@2020-08-01' = {
    name: 'Memory2'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 60
      counterName: '% Committed Bytes In Use'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource network1PerfCounter 'dataSources@2020-08-01' = {
    name: 'Network1'
    properties: {
      objectName: 'Network Adapter'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Bytes Received/sec'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource network2PerfCounter 'dataSources@2020-08-01' = {
    name: 'Network2'
    properties: {
      objectName: 'Network Adapter'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Bytes Sent/sec'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource network3PerfCounter 'dataSources@2020-08-01' = {
    name: 'Network3'
    properties: {
      objectName: 'Network Adapter'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Bytes Total/sec'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource cpu1PerfCounter 'dataSources@2020-08-01' = {
    name: 'CPU1'
    properties: {
      objectName: 'Processor'
      instanceName: '_Total'
      intervalSeconds: 30
      counterName: '% Processor Time'
    }
    kind: 'WindowsPerformanceCounter'
  }
  resource cpu2PerfCounter 'dataSources@2020-08-01' = {
    name: 'CPU2'
    properties: {
      objectName: 'System'
      instanceName: '*'
      intervalSeconds: 30
      counterName: 'Processor Queue Length'
    }
    kind: 'WindowsPerformanceCounter'
  }
}

resource logAnalyticsSolutions 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [for solution in solutions: {
  name: '${solution.name}(${logAnalyticsWorkspace.name})'
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: '${solution.name}(${logAnalyticsWorkspace.name})'
    product: 'OMSGallery/${solution.name}'
    publisher: solution.publisher
    promotionCode: solution.promotionCode
  }
}]

resource automationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
  dependsOn: [
    logAnalyticsWorkspace
  ]
}

resource logAnalyticsAutomation 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-03-01-preview' = {
  name: '${logAnalyticsWorkspace.name}/Automation'
  properties: {
    resourceId: automationAccount.id
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name
output logAnalyticsWorkspaceResourceID string = logAnalyticsWorkspace.id
output automationAccountName string = automationAccount.name
output automationAccountResourceID string = automationAccount.id
