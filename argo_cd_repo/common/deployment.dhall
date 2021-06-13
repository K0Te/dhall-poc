let k8 = ./k8.dhall
let ma = k8.IntOrString.Int +1
let rollingDep = k8.RollingUpdateDeployment :: { maxSurge = Some ma, maxUnavailable = Some ma }
let strategy = k8.DeploymentStrategy :: {
    rollingUpdate = Some rollingDep
}
-- let env = k8.EnvVar :: {name = "AWS_REGION", value = Some "us-east-1"}
let mkContainer = \(envVars : List k8.EnvVar.Type) -> k8.Container :: {
    name = "service_name",
    image = Some "image_name",
    command = Some ["python", "service_path"],
    env = Some envVars,
}
let mkPodSpec = \(envVars : List k8.EnvVar.Type) -> k8.PodSpec :: {
    serviceAccountName = Some "service_account",
    containers = [mkContainer envVars]
}
let mkPodTemplateSpec =  \(envVars : List k8.EnvVar.Type) -> k8.PodTemplateSpec::{
    spec = Some (mkPodSpec envVars)
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
let makeDeployment = \(envVars : List k8.EnvVar.Type) -> k8.Deployment :: {
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
        template = mkPodTemplateSpec envVars,
    }
}
in makeDeployment