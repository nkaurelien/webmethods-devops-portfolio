
provider "ansible" {
  # Configuration options
}


resource "ansible_host" "host" {
  name   = aws_instance.sag_cc_spm_server.public_dns
  groups = ["webmethods"]

  variables = {
    cc_admin_host = aws_instance.sag_cc_spm_server.public_dns
    # cc_admin_password = "manage123"
  }
}

resource "ansible_group" "group" {
  name = "webmethods"
  variables = {
    cc_admin_password = "manage123"
  }
}

resource "ansible_playbook" "playbook" {
  playbook   = "../ansible/playbook-with-supervisor.yml"
  name       = aws_instance.sag_cc_spm_server.public_dns
  replayable = true
  groups     = [ansible_group.group.name]

  extra_vars = {
    cce_http_port  = "8090"
    cce_https_port = "8091"
    spm_http_port  = "8092"
    spm_https_port = "8093"
    # cc_installer_url = ""
    # cc_installer_path: "/installer/cc-def-10.15-fix8-lnxamd64.sh"
  }
}
