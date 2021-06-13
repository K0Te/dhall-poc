let envVars = ./env_vars.dhall
let mkDeployment = ../common/deployment.dhall
let defaultVars = ../common/env_vars.dhall
let vars = defaultVars.makeK8Var (
    defaultVars.default // envVars
)
in mkDeployment vars