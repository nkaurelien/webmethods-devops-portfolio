
provider "ansible" {
  # Configuration options
}


resource "ansible_group" "group" {
  name = "webmethods"
  variables = {
    ansible_user                 = "${var.ssh_user}"
    ansible_ssh_private_key_file = "${path.module}/${var.ssh_private_key}"
    cc_admin_password            = "manage123"
  }
}

resource "ansible_host" "host" {
  name   = aws_instance.sag_cc_spm_server.public_dns
  groups = ["${ansible_group.group.name}"]

  variables = {
    ansible_user                 = "${ansible_group.group.variables.ansible_user}"
    ansible_ssh_private_key_file = "${ansible_group.group.variables.ansible_ssh_private_key_file}"
    cc_admin_host = aws_instance.sag_cc_spm_server.public_dns
    # cc_admin_password = "manage123"
  }
}

resource "ansible_playbook" "playbook" {
  playbook   = "../ansible/playbook-with-supervisor.yml"
  name       = aws_instance.sag_cc_spm_server.public_dns
  replayable = true
  groups     = [ansible_group.group.name]

  extra_vars = {
    ansible_user                 = "${ansible_host.host.variables.ansible_user}"
    ansible_ssh_private_key_file = "${ansible_host.host.variables.ansible_ssh_private_key_file}"
    cce_http_port  = "8090"
    cce_https_port = "8091"
    spm_http_port  = "8092"
    spm_https_port = "8093"
    cc_installer_url = "http://192.168.0.29:9001/api/v1/download-shared-object/aHR0cDovLzEyNy4wLjAuMTo5MDAwL3dpbG93L2NjLWRlZi0xMC4xNS1maXg4LWxueGFtZDY0LnNoP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9VzhDTzNQQVJaVUM2UkVMUFQ0OTMlMkYyMDI1MDIxNSUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNTAyMTVUMjI1NzQ5WiZYLUFtei1FeHBpcmVzPTQzMjAwJlgtQW16LVNlY3VyaXR5LVRva2VuPWV5SmhiR2NpT2lKSVV6VXhNaUlzSW5SNWNDSTZJa3BYVkNKOS5leUpoWTJObGMzTkxaWGtpT2lKWE9FTlBNMUJCVWxwVlF6WlNSVXhRVkRRNU15SXNJbVY0Y0NJNk1UY3pPVGN3TVRVeU5pd2ljR0Z5Wlc1MElqb2liV2x1YVc5aFpHMXBiaUo5LnJEaUpwVnRLdV9HbUxSbVZHTVJkTkpzQ2oyMWk4WTBJNGswS2dwR2pqUERSbmFycTBIcDVORW1SVlU1aXZndU9WVTVXVWZ1RWNQczQwM05xemVpYlFnJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZ2ZXJzaW9uSWQ9bnVsbCZYLUFtei1TaWduYXR1cmU9YTcyMTNjYTc4NWQ2MDQxZmM1YmEwMjgwMjcxNTU5ZjFlMjU3YzBiZDJmNTZhZDdkZGI5Y2RiMzFhZjA3NzRkZQ"
  }
}
