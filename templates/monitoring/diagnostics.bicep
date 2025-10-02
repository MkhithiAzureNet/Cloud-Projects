param targetResourceId string
param workspaceId string

resource diag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'send-to-loganalytics'
  scope: resourceId(targetResourceId)
  properties: {
    workspaceId: workspaceId
    logs: [
      {
        category: 'SQLInsights'
        enabled: true
      }
      {
        category: 'Errors'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}