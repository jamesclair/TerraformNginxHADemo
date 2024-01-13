## Terraform: 

Deploys Nginx as a reverse proxy to a few other Nginx instances serving some static content.

### My Experience with Terraform

LogRhythm:

As a founding member of the LRCloud team I helped build and design the Terraform layers that defined our GCP infrastructure for migrating our on-prem enterprise SIEM. Later as the founding member and lead of the LogRhythm Platform Engineering team I designed and built our modular and extensible terraform foundations using terragrunt and AWS.  These layers would host and integrate into our self-managed Kubernetes clusters defined in Kops.  Our TF infrastructure rarely required anything more than externalized config changes, supported multiple cloud providers, and were highly reusable by subsequent projects like our aqcuisition of Mistnet Network Detection products.

Select Star:

Most of the necessary infrastructure as code layers was already in place when I arrived at S*, however as a member of the infrastructure guild and platform team I regularly performed updates and code reviews to our Terraform and Terragrunt AWS and EKS infra.  

### Design
To keep costs and dependency on cloud accounts I decided to use docker as the provider.  Though I probably would opt for either using KinD, Podman, or docker-compose for declarative local infrastructure definition rather than TF in an enterprise setting.

- A [`main.tf`](./main.tf) file describes the docker provider, 3 `webserver` containers, and a `proxy` container that loadbalances http connections to the backend webservices.
- An [`index.html`](./index.html) file that describes the static content that is mounted into each `webserver` container.  Allows for dynamic changes to static content
- A [`proxy.conf`](./proxy.conf) that overrides the nginx default.conf of the `proxy` container.  


I chose to stick with nginx backends for demonstration purposes as any set of webserver services can be loadbalanced and exposed through a proxy like this using the exact same patterns.  You may need to extend the nginx configuration based on the content and endpoint paths of your service.

Terraform state is by default stored locally, in a shared/multi-user environment I would store it in a shared object storage like s3 with a locking mechanism like dynamodb.


### Pre-Reqs

- MacOS
  - **Note:** The current nginx config uses `host.docker.internal` as the hostname for reaching the `webserver`(s) this will keep the solution from working on non-macos systems.  Docker can be configured for host based networking to expose the services locally or an isolated network can be created with the proxy as an entrypoint if this solution were to be extended.
- Docker Desktop
- Internet connection for pulling the images from docker hub

### Usage

From the root of this repo run: `terraform plan` which should look like the following:

```

  # docker_container.proxy will be created
  + resource "docker_container" "proxy" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (known after apply)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + must_run                                    = true
      + name                                        = "proxy"
      + network_data                                = (known after apply)
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + ports {
          + external = 8080
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }

      + volumes {
          + container_path = "/etc/nginx/conf.d/default.conf"
          + host_path      = "/Users/jim/code/TerraformNginxHADemo/proxy.conf"
        }
    }

  # docker_container.webserver[0] will be created
  + resource "docker_container" "webserver" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (known after apply)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + must_run                                    = true
      + name                                        = "webserver0"
      + network_data                                = (known after apply)
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + ports {
          + external = 8000
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }

      + volumes {
          + container_path = "/usr/share/nginx/html/index.html"
          + host_path      = "/Users/jim/code/TerraformNginxHADemo/index.html"
        }
    }

  # docker_container.webserver[1] will be created
  + resource "docker_container" "webserver" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (known after apply)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + must_run                                    = true
      + name                                        = "webserver1"
      + network_data                                = (known after apply)
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + ports {
          + external = 8001
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }

      + volumes {
          + container_path = "/usr/share/nginx/html/index.html"
          + host_path      = "/Users/jim/code/TerraformNginxHADemo/index.html"
        }
    }

  # docker_container.webserver[2] will be created
  + resource "docker_container" "webserver" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (known after apply)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + must_run                                    = true
      + name                                        = "webserver2"
      + network_data                                = (known after apply)
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + ports {
          + external = 8002
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }

      + volumes {
          + container_path = "/usr/share/nginx/html/index.html"
          + host_path      = "/Users/jim/code/TerraformNginxHADemo/index.html"
        }
    }

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" {
      + id          = (known after apply)
      + image_id    = (known after apply)
      + name        = "nginx:latest"
      + repo_digest = (known after apply)
    }

Plan: 5 to add, 0 to change, 0 to destroy.
```

If the plan looks right, you can run: `terraform apply`.  Be sure to doublecheck the plans match before confirming.

Now you can navigate to [http://localhost:8080/](http://localhost:8080/) which will hit the exposed port on the `proxy` and forward the request to one of the `webserver` containers which in turn serves the `index.html`.

You can change the content of the `index.html` and on next reload of webpage the new content will appear.

To destroy the environment: `terraform destroy`
