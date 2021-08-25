#! /bin/bash

## This script adds druid-connector to sink data from kafka-topic in confluent

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.accountSettings",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.accountSettings",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.activities",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.activities",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.announcements",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.announcements",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.boards",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.boards",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"   

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.card_comments",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.card_comments",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"   

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.cards",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.cards",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"   

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.checklistItems",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.checklistItems",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"  

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.checklists",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.checklists",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"  

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.invitation_codes",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.invitation_codes",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"  

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.lists",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.lists",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.meteor-migrations",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.meteor-migrations",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.meteor_accounts_loginServiceConfiguration",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.meteor_accounts_loginServiceConfiguration",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.meteor_oauth_pendingCredentials",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.meteor_oauth_pendingCredentials",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.presences",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.presences",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.settings",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.settings",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.swimlanes",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.swimlanes",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.unsaved-edits",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.unsaved-edits",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {
    "type": "kafka",
    "spec": {
      "ioConfig": {
        "type": "kafka",
        "consumerProperties": {
          "bootstrap.servers": "kafka.confluent:9092"
        },
        "topic": "wekan.wekan.users",
        "inputFormat": {
          "type": "json"
        },
        "taskDuration": "PT30H",
        "useEarliestOffset": true
      },
      "tuningConfig": {
        "type": "kafka",
        "logParseExceptions": true
      },
      "dataSchema": {
        "dataSource": "wekan.wekan.users",
        "timestampSpec": {
          "column": "ts_ms",
          "format": "millis"
        },
        "dimensionsSpec": {
          "dimensions": [
            "after",
            "filter",
            "op",
            "patch",
            "transaction"
          ]
        },
        "granularitySpec": {
          "queryGranularity": "none",
          "rollup": false,
          "segmentGranularity": "year"
        }
      }
    }
  }}' http://druid-coordinator.druid:8081/druid/indexer/v1/supervisor -w "\n"