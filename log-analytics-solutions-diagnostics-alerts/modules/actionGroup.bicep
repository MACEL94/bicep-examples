param appName string
param actionGroupEmailName string = 'Paul McDonald'
param actionGroupEmail string = 'paul@tpmtesting.net'

var actionGroupName = 'ag-${appName}-alerts'
var actionGroupShortName = '${appName}alerts'

resource actionGroup 'microsoft.insights/actionGroups@2019-06-01' = {
  name: actionGroupName
  location: 'global'
  properties: {
    groupShortName: actionGroupShortName
    enabled: true
    emailReceivers: [
      {
        name: actionGroupEmailName
        emailAddress: actionGroupEmail
        useCommonAlertSchema: true
      }
    ]
  }
}

output actionGroupId string = actionGroup.id
