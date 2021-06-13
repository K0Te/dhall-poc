let Schema = { AAA : Text, BBB : Text }

let default = { AAA = "1", }
let MapSchema = {mapKey: Text, mapValue : Text}
let Prelude = https://prelude.dhall-lang.org/v20.2.0/package.dhall sha256:a6036bc38d883450598d1de7c98ead113196fe2db02e9733855668b18096f07b
let map = Prelude.List.map
let k8 = ./k8.dhall
let keyMapToK8 = \(r: {mapKey: Text, mapValue : Text})-> k8.EnvVar :: {name = r.mapKey, value = Some r.mapValue}

let makeK8Var = \(r: Schema) -> map MapSchema k8.EnvVar.Type keyMapToK8 (toMap r)

in  { Type=Schema, default, makeK8Var }
