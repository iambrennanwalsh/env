# Environment

The goal with this app is to implement a one command development/deploy environment.

```sh
git clone https://github.com/iambrennanwalsh/environment
cd environment
make app.dev
```

This command `app.production` will do the following..

1. Initialize the chosen environment. `make env.production`

- Retrieve the environment variables from `config/env/.env`.
- Retreieve the environment variables from `config/env/.env.development`.
- Output a single .env file in the root of the application.

2. Initialize the docker environment. `make docker.up`

-
