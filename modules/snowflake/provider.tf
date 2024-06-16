terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "~>0.70.0"
    }
    snowsql = {
      source = "aidanmelen/snowsql"
      version = "~>1.3.3"
    } 
  }
}