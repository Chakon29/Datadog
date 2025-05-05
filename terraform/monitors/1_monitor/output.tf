# Import existing monitor into terraform state
import {
  to = datadog_monitor.VM_GCP_Uso_de_disco_Critical
  id = "3616409"  # Same ID as in monitors.tfvars
}