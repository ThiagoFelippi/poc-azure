I had only worked with AKS on Azure, the Kubernetes Ingress Controller creates a load balancer by itself, so I didn't need to create one, and the auto scaling of VMs is also managed by AKS.
the time it took me to perform the POC was because I had to learn and do everything, I didn't have any ready-made templates on my machine, terraform that I could consult, etc. It was trial and error until I got it to work

## what would change in productive environments?

there would be several environments within the environments folder, each with its own configurations, and within the modules, we could use count, to create a feature flag for each resource in each environment, thus making it possible to create things in one environment, and not create them in another, even if the two environments call the same module.

## what was missing?

- I was unable to control traffic coming only from LB to VMs on VMSS, however I enabled traffic coming only from port 80 (I did not configure SSL certificates), and the VMs do not contain a public IP
- I didn't make the architecture diagram due to lack of time, as I focused on delivering all the other must requirements
- VMSS is not autoscaling with CPU and memory thresholds, I did not do this due to lack of time, but I left the terraform code commented out in the VMSS module, there are some adjustments missing that I would need to study a little more to resolve
