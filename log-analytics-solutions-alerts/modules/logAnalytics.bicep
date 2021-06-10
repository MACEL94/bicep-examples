param location string
param locationShort string
param appName string
param environment string

var workspaceName = toLower('log-${appName}-${environment}-${locationShort}')
var automationAccountName = toLower('aa-${appName}-${environment}-${locationShort}')

var agentHealthAssessment = {
  name: 'AgentHealthAssessment(${workspaceName})'
  galleryName: 'AgentHealthAssessment'
}
var antiMalware = {
  name: 'AntiMalware(${workspaceName})'
  galleryName: 'AntiMalware'
}
var azureSQLAnalytics = {
  name: 'AzureSQLAnalytics(${workspaceName})'
  galleryName: 'AzureSQLAnalytics'
}
var changeTracking = {
  name: 'ChangeTracking(${workspaceName})'
  galleryName: 'ChangeTracking'
}
var containerInsights = {
  name: 'ContainerInsights(${workspaceName})'
  galleryName: 'ContainerInsights'
}
var securityCenterFree = {
  name: 'SecurityCenterFree(${workspaceName})'
  galleryName: 'SecurityCenterFree'
}
var SQLAssessment = {
  name: 'SQLAssessment(${workspaceName})'
  galleryName: 'SQLAssessment'
}
// var updates = {
//   name: 'Updates(${workspaceName})'
//   galleryName: 'Updates'
// }
var vmInsights = {
  name: 'VMInsights(${workspaceName})'
  galleryName: 'VMInsights'
}

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
      eventTypes: [
          {
            eventType: 'Error'
          }
          {
            eventType: 'Warning'
          }
      ]
    }
    kind: 'WindowsEvent'
  }
  resource applicationLogs 'dataSources@2020-08-01' = {
    name: 'Application'
    properties: {
      eventLogName: 'Application'
      eventTypes: [
          {
            eventType: 'Error'
          }
          {
            eventType: 'Warning'
          }
      ]
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

resource solutionsAgentHealthAssessment 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: agentHealthAssessment.name
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: agentHealthAssessment.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${agentHealthAssessment.galleryName}'
    promotionCode: ''
  }
}

resource solutionsAntiMalware 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: antiMalware.name
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: antiMalware.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${antiMalware.galleryName}'
    promotionCode: ''
  }
}

resource solutionsAzureSQLAnalytics 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: azureSQLAnalytics.name
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: azureSQLAnalytics.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${azureSQLAnalytics.galleryName}'
    promotionCode: ''
  }
}

resource solutionsChangeTracking 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: changeTracking.name
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: changeTracking.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${changeTracking.galleryName}'
    promotionCode: ''
  }
}

resource solutionsContainerInsights 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: containerInsights.name
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: containerInsights.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${containerInsights.galleryName}'
    promotionCode: ''
  }
}

resource solutionsSecurityCenterFree 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: securityCenterFree.name
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: securityCenterFree.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${securityCenterFree.galleryName}'
    promotionCode: ''
  }
}

resource solutionsSQLAssessment 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: SQLAssessment.name
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: SQLAssessment.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${SQLAssessment.galleryName}'
    promotionCode: ''
  }
}

// resource solutionsUpdates 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
//   name: updates.name
//   location: location
//   properties: {
//     workspaceResourceId: logAnalyticsWorkspace.id
//   }
//   plan: {
//     name: updates.name
//     publisher: 'Microsoft'
//     product: 'OMSGallery/${updates.galleryName}'
//     promotionCode: ''
//   }
// }

resource solutionsVMInsights 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: vmInsights.name
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: vmInsights.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${vmInsights.galleryName}'
    promotionCode: ''
  }
}

output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name
output logAnalyticsWorkspaceResourceID string = logAnalyticsWorkspace.id
output automationAccountName string = automationAccount.name
output automationAccountResourceID string = automationAccount.id
