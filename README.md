# airtable-grafana

This is a somewhat generic adapter to enable the use of airtable in grafana
dashboards.

You must have the following fields:

* timestamp (Date/Time)
* value (Number)
* labels (multi-select)

A table is a target as far as the query is concerned but I return multiple
targets broken down by the labels in the table - this seemed like a reasonable
way to do it...

## Configuration

Run this app with the following vars:

```
# change to your key/base
export AIRTABLE_KEY=xxx
export AIRTABLE_BASE=xx
# this is use to allow grafana to 'discover' the tables
export AIRTABLE_TABLES=subscriptions
```

I deploy a Datasource like this:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-datasource-airtable
  labels:
    grafana_datasource: "1"
data:
  datasource.yaml: |-
    apiVersion: 1
    deleteDatasources:
    - name: Airtable
      orgId: 1
    datasources:
    - name: Airtable
      type: simpod-json-datasource
      access: proxy
      url: http://airtable-grafana
```

And read it with a panel like this:

```json
{
  "aliasColors": {},
  "bars": false,
  "dashLength": 10,
  "dashes": false,
  "datasource": "Airtable",
  "fill": 1,
  "gridPos": {
    "h": 9,
    "w": 12,
    "x": 0,
    "y": 0
  },
  "id": 2,
  "legend": {
    "alignAsTable": false,
    "avg": false,
    "current": false,
    "max": false,
    "min": false,
    "show": true,
    "total": false,
    "values": false
  },
  "lines": true,
  "linewidth": 1,
  "links": [],
  "nullPointMode": "null",
  "options": {},
  "percentage": false,
  "pluginVersion": "6.2.0",
  "pointradius": 2,
  "points": false,
  "renderer": "flot",
  "seriesOverrides": [],
  "spaceLength": 10,
  "stack": false,
  "steppedLine": false,
  "targets": [
    {
      "data": "",
      "hide": false,
      "refId": "A",
      "target": "TABLENAME",
      "type": "timeseries"
    }
  ],
  "thresholds": [],
  "timeFrom": null,
  "timeRegions": [],
  "timeShift": null,
  "title": "Airtable",
  "tooltip": {
    "shared": true,
    "sort": 0,
    "value_type": "individual"
  },
  "transparent": true,
  "type": "graph",
  "xaxis": {
    "buckets": null,
    "mode": "time",
    "name": null,
    "show": true,
    "values": []
  },
  "yaxes": [
    {
      "format": "short",
      "label": null,
      "logBase": 1,
      "max": null,
      "min": null,
      "show": true
    },
    {
      "format": "short",
      "label": null,
      "logBase": 1,
      "max": null,
      "min": null,
      "show": true
    }
  ],
  "yaxis": {
    "align": false,
    "alignLevel": null
  }
}
```
