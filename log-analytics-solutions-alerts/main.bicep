@description('Location of the workspace')
param location string = resourceGroup().location

@description('Shortened location of the workspace')
@minLength(3)
@maxLength(4)
param locationShort string

@description('Name of the workspace')
param name string

@description('Environment where the workspace is deployed')
param environment string

module logAnalyticsModule 'modules/logAnalytics.bicep' = {
  name: 'logAnalyticsDeploy'
  params:{
    location: location
    locationShort: locationShort
    name: name
    environment: environment
  }
}

module metricAlertsModule 'modules/metricAlerts.bicep' = {
  name: 'metricAlertsDeploy'
  params:{
    workspaceId: logAnalyticsModule.outputs.logAnalyticsWorkspaceResourceID
    automationAccountId: logAnalyticsModule.outputs.automationAccountResourceID
    actionGroupId: actionGroupModule.outputs.actionGroupId
  }
}

module logQueryAlertsModule 'modules/logQueryAlerts.bicep' = {
  name: 'logQueryAlertsDeploy'
  params: {
    location: location
    workspaceId: logAnalyticsModule.outputs.logAnalyticsWorkspaceResourceID
    actionGroupId: actionGroupModule.outputs.actionGroupId
  }
}

module actionGroupModule 'modules/actionGroup.bicep' = {
  name: 'actionGroupDeploy'
  params:{
    name: name
  }
}
