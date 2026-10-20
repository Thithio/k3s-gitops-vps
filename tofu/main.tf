# Uma VM com k3s de nó único: SSH restrito, HTTP/HTTPS aberto.

resource "mgc_ssh_keys" "admin" {
  name = "${var.name}-admin"
  key  = var.ssh_public_key
}

resource "mgc_network_security_groups" "vm" {
  name        = "${var.name}-sg"
  description = "${var.name}: SSH restrito, HTTP/HTTPS aberto"
}

resource "mgc_network_security_groups_rules" "ssh" {
  for_each          = toset(var.admin_cidrs)
  description       = "SSH administrativo"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = each.value
  security_group_id = mgc_network_security_groups.vm.id
}

resource "mgc_network_security_groups_rules" "web" {
  for_each          = { http = 80, https = 443 }
  description       = "Traefik ${each.key}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = each.value
  port_range_max    = each.value
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.vm.id
}

resource "mgc_virtual_machine_instances" "vm" {
  name                     = var.name
  machine_type             = var.machine_type
  image                    = var.image
  ssh_key_name             = mgc_ssh_keys.admin.name
  allocate_public_ipv4     = true # o IP público não é apagado junto com a VM (cobrança à parte)
  creation_security_groups = [mgc_network_security_groups.vm.id]
}

output "public_ipv4" {
  value = mgc_virtual_machine_instances.vm.ipv4
}

output "ansible_inventory_line" {
  description = "Cole em ansible/inventory/homolog.ini"
  value       = "homolog ansible_host=${mgc_virtual_machine_instances.vm.ipv4} ansible_user=ubuntu"
}
