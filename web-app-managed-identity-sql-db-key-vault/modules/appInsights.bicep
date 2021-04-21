param location string = resourceGroup().location
param appName string
param environment string
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
@description('Text that the returned HTTP response must contain')
param pingText string = 'Movie App'
param emailActionGroupId string
param keyVaultId string

var appInsightsName = 'appi-${appName}-${environment}'
var appInsightsAvailablityTestName = 'Availability Test - ${appInsightsName}'
var pingURL = (environmentType == 'prod') ? 'https://prodsite.com' : 'https://app-${appName}-${environment}.azurewebsites.net'

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource appInsights_availablityTest 'Microsoft.Insights/webtests@2015-05-01' = {
  name: appInsightsAvailablityTestName
  location: location
  tags: {
    'hidden-link:${appInsights.id}': 'Resource'
    displayName: 'Home Page Availability Test'
  }
  properties: {
    SyntheticMonitorId: appInsightsAvailablityTestName
    Name: 'Home Page Availability Test'
    Enabled: true
    Frequency: 300
    Timeout: 120
    Kind: 'ping'
    RetryEnabled: true
    Locations: [
      {
        Id: 'emea-nl-ams-azr'
      }
      {
        Id: 'apac-sg-sin-azr'
      }
      {
        Id: 'emea-gb-db3-azr'
      }
      {
        Id: 'us-va-ash-azr'
      }
      {
        Id: 'emea-au-syd-edge'
      }
    ]
    Configuration: {
      WebTest: '<WebTest   Name="${appInsightsAvailablityTestName}"   Enabled="True"         CssProjectStructure=""    CssIteration=""  Timeout="120"  WorkItemIds=""         xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"         Description=""  CredentialUserName=""  CredentialPassword=""         PreAuthenticate="True"  Proxy="default"  StopOnError="False"         RecordedResultFile=""  ResultsLocale="">  <Items>  <Request Method="GET"    Version="1.1"  Url="${pingURL}" ThinkTime="0"  Timeout="300" ParseDependentRequests="True"         FollowRedirects="True" RecordResult="True" Cache="False"         ResponseTimeGoal="0"  Encoding="utf-8"  ExpectedHttpStatusCode="200"         ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />        </Items>  <ValidationRules> <ValidationRule  Classname="Microsoft.VisualStudio.TestTools.WebTesting.Rules.ValidationRuleFindText, Microsoft.VisualStudio.QualityTools.WebTestFramework, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" DisplayName="Find Text"         Description="Verifies the existence of the specified text in the response."         Level="High"  ExecutionOrder="BeforeDependents">  <RuleParameters>        <RuleParameter Name="FindText" Value="${pingText}" />  <RuleParameter Name="IgnoreCase" Value="False" />  <RuleParameter Name="UseRegularExpression" Value="False" />  <RuleParameter Name="PassIfTextFound" Value="True" />  </RuleParameters> </ValidationRule>  </ValidationRules>  </WebTest>'
    }
  }
}

resource appInsights_availabilityTestAlert 'Microsoft.Insights/metricalerts@2018-03-01' = {
  name: 'Availability Test - ${appInsights.name}'
  location: 'global'
  tags: {
    'hidden-link:${appInsights.id}': 'Resource'
    'hidden-link:${appInsights_availablityTest.id}': 'Resource'
    displayName: 'Home Page Availability Alert'
  }
  properties: {
    description: '${appInsights} has failed the availability test'
    severity: 1
    enabled: true
    scopes: [
      appInsights.id
      appInsights_availablityTest.id
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      webTestId: appInsights_availablityTest.id
      componentId: appInsights.id
      failedLocationCount: 2
      'odata.type': 'Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria'
    }
    actions: [
      {
        actionGroupId: emailActionGroupId
      }
    ]
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: last(split(keyVaultId, '/'))
  resource appInsightsSecret 'secrets' = {
    name: '${appInsightsName}-ConnectionString'
    properties: {
    value:  appInsights.properties.ConnectionString
   }
  }
}

output appInsightsSecretUri string = keyVault::appInsightsSecret.properties.secretUriWithVersion
