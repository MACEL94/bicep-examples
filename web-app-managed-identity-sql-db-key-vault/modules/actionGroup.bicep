param appName string
param actionGroupEmailName string = 'Paul McDonald'
param actionGroupEmail string = 'paul.mcdonald@coats.com'

var actionGroupName = 'ag-${appName}-alerts'
var actionGroupShortName = 'ag-${appName}'
var actionRuleName = 'Movies Alerts'

resource actionGroup 'microsoft.insights/actionGroups@2019-06-01' = {
  location: 'global'
  name: actionGroupName
  properties: {
    enabled: true
    groupShortName: actionGroupShortName
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
