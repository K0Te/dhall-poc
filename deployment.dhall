let k8 = https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/master/1.19/package.dhall sha256:6774616f7d9dd3b3fc6ebde2f2efcafabb4a1bf1a68c0671571850c1d138861f

let ma = k8.IntOrString.Int +1
let rollingDep = k8.RollingUpdateDeployment :: { maxSurge = Some ma, maxUnavailable = Some ma }
let strategy = k8.DeploymentStrategy :: {
    rollingUpdate = Some rollingDep
}
let env = k8.EnvVar :: {name = "AWS_REGION", value = Some "us-east-1"}
let container = k8.Container :: {
    name = "service_name",
    image = Some "image_name",
    command = Some ["python", "service_path"],
    env = Some [env],
}
let podSpec = k8.PodSpec :: {
    serviceAccountName = Some "service_account",
    containers = [container]
}
let podTemplateSpec = k8.PodTemplateSpec::{
    spec = Some podSpec
}
let selector = k8.LabelSelector :: {
    matchLabels = Some [{
            mapKey = "tier",
            mapValue = "backend"
        },
        {
            mapKey="name",
            mapValue="service_name"
        }] 
}
let deployment = k8.Deployment :: {
    metadata = k8.ObjectMeta::{
        name = Some "serice_name",
        labels = Some [{
                mapKey="tier",
                mapValue="backend"
            },
            {
                mapKey="name",
                mapValue="service_name"
            }],
    },
    spec = Some k8.DeploymentSpec::{
        replicas = Some +1,
        strategy = Some strategy,
        selector = selector,
        template = podTemplateSpec,
    }
}
in deployment