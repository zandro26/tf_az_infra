locals {
  schemas = {
    for val in
    flatten(
      [for dk, dv in var.databases_schemas :
        [for sn, sv in dv :
          {
            database = dk
            schema   = "${dk}_${var.env}|${sn}"
            config   = sv
    }]]) :
    val.schema => val
  }


  warehouses = {
    for val in
    flatten(
      [for name, val in var.compute_groups :
        [for wn, wv in val.warehouses :
          {
            warehouse = "${name}_${wn}",
            group     = name,
            config    = wv
    }]]) :
    val.warehouse => val
  }

  warehouse_grants = distinct(flatten(
    [
      [for name, val in var.compute_groups :
        [for wn, wv in val.warehouses :
          [for r in val.group_members :
            "${name}_${wn}_${var.env}|${r}"
          ]
        ]
      ],
      [for name, val in var.compute_groups :
        [for wn, wv in val.warehouses :
          [for r in val.service_accounts :
            "${name}_${wn}_${var.env}|SVC_${r}_${var.env}"
          ]
        ]
      ]
    ]
  ))

  rm_grants = distinct(flatten(
    [
      [for name, val in var.compute_groups :
        [for r in val.group_members :
          "${name}_LIMIT_${var.env}|${r}"
        ]
      ],
      [for name, val in var.compute_groups :
        [for r in val.service_accounts :
          "${name}_LIMIT_${var.env}|SVC_${r}_${var.env}"
        ]
      ]
    ]
  ))

  database_schema_roles = flatten(
    [for dk, dv in var.databases_schemas :
      [for sn, sv in dv :
        ["${dk}_${var.env}|${sn}|Z_${dk}_${var.env}_${sn}_OWNER",
          "${dk}_${var.env}|${sn}|Z_${dk}_${var.env}_${sn}_RO",
          "${dk}_${var.env}|${sn}|Z_${dk}_${var.env}_${sn}_RVO"
        ]
  ]])

  integration_grants = distinct(flatten([
    for k, v in var.azure_storage_integrations :
    [
      formatlist("%s_%s|%s", k, var.env, v.usage_grants.roles),
      formatlist("%s_%s|SVC_%s_%s", k, var.env, v.usage_grants.service_accounts, var.env)
    ]
  ]))


  schema_future_ownership_grant = distinct(flatten(
    [for dk, dv in var.databases_schemas :
      [for sn, sv in dv :
        [for o in var.schema_object_owernship :
          "${dk}_${var.env}|${sn}|${o}"
        ]
      ]
  ]))

  schema_ro_access = distinct(flatten(
    [for dk, dv in var.databases_schemas :
      [for sn, sv in dv :
        [
          for o in var.schema_ro_access :
          "${dk}_${var.env}|${sn}|${o}"
        ]
      ]
    ]
  ))

  schema_rvo_access = distinct(flatten(
    [for dk, dv in var.databases_schemas :
      [for sn, sv in dv :
        [
          for o in var.schema_rvo_access :
          "${dk}_${var.env}|${sn}|${o}"
        ]
      ]
    ]
  ))

  schema_access_grants = flatten([for dk, dv in var.databases_schemas :
    [for sn, sv in dv :
      {
        schema="${dk}_${var.env}_${sn}"
        owner=distinct(flatten([sv.rw, formatlist("SVC_%s_%s",sv.rw_svc_acct,var.env)]))
        ro=distinct(flatten([sv.ro, formatlist("SVC_%s_%s",sv.rw_svc_acct,var.env)]))
        rvo=distinct(flatten([sv.rvo, formatlist("SVC_%s_%s",sv.rw_svc_acct,var.env)]))
      }
    ]
  ])

  schema_owner_grants = {
    for k,v in local.schema_access_grants:
      "Z_${v.schema}_OWNER"=>v.owner if length(v.owner)>0
  }

  schema_ro_grants = {
    for k,v in local.schema_access_grants:
      "Z_${v.schema}_RO"=>v.ro if length(v.ro)>0
  }

  schema_rvo_grants = {
    for k,v in local.schema_access_grants:
     "Z_${v.schema}_RVO"=>v.rvo if length(v.rvo)>0
  }

  schema_owners = flatten(
      [for dk, dv in var.databases_schemas :
        [for sn, sv in dv :
            "Z_${dk}_${var.env}_${sn}_OWNER"
  ]])  
}