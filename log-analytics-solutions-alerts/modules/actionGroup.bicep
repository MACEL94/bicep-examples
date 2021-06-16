param name string
param actionGroupEmailName string = 'Paul McDonald'
param actionGroupEmail string = 'paul@tpmtesting.net'

var actionGroupName = 'ag-${name}-alerts'
var actionGroupShortName = '${name}alerts'

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
