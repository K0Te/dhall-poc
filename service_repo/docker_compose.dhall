let dkr = https://raw.githubusercontent.com/sbdchd/dhall-docker-compose/master/compose/v3/package.dhall sha256:bff77b825ce0eb3bad0c0bb5e365b10a09f9315da32206e5b8c71682ff985f95
let localVars = ./local_vars.dhall

let db = dkr.Service :: {
    build = Some ( dkr.Build.Object {
        dockerfile="DockerfilePostgres",
        context=".",
        args=dkr.ListOrDict.List ([]: List (Optional dkr.StringOrNumber)),
    }),
    user = Some "postgres",
    restart = Some "unless-stopped",
    environment = Some (dkr.ListOrDict.Dict
        [{mapKey="POSTGRES_HOST_AUTH_METHOD", mapValue="trust"}]),
}

let rabbitmq = dkr.Service :: {
    image = Some "rabbitmq:3.8",
    restart = Some "unless-stopped",
}

let web = dkr.Service :: {
    build = Some ( dkr.Build.Object {
        dockerfile="Dockerfile",
        context=".",
        args=dkr.ListOrDict.Dict 
            [{mapKey="REQUIREMENTS_FILE", mapValue="requirements-dev.txt"},
            {mapKey="VERSION", mapValue="0.0.0-local"}],
    }),
    command = Some (dkr.StringOrList.List ["run"]),
    volumes = Some ["/tmp"],
    restart = Some "unless-stopped",
    environment = Some (dkr.ListOrDict.Dict (toMap localVars)),
    depends_on = Some ["db"],
    stdin_open = Some True,
    tty = Some True,
}

in {
    version = "3.8",
    services = Some (toMap {db=db, rabbitmq=rabbitmq, web=web}),
    networks = None dkr.Networks,
    volumes = None dkr.Volumes,
} : dkr.ComposeConfig