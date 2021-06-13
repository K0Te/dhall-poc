let k8 =
      https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.19/package.dhall sha256:6774616f7d9dd3b3fc6ebde2f2efcafabb4a1bf1a68c0671571850c1d138861f

let serviceAccount =
      k8.ServiceAccount::{
      , metadata = k8.ObjectMeta::{
        , name = Some "service_name"
        , annotations = Some
          [ { mapKey = "eks.amazonaws.com/role-arn"
            , mapValue = "arn:aws:iam::<id>:role/service_role"
            }
          ]
        }
      }

in  serviceAccount
