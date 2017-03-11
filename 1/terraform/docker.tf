provider "google" {
    credentials = "${file(var.account_file)}"
    project = "${var.project}"
    region = "${var.region}"
}

resource "template_file" "docker" {
    filename = "docker.env"
}

resource "google_compute_firewall" "docker" {
    description = "docker"
    name = "docker"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["80"]
    }

    source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_instance" "docker" {
    count = "${var.worker_count}"

    name = "${var.cluster_name}-docker${count.index}"
    can_ip_forward = true
    machine_type = "f1-micro"
    zone = "${var.zone}"
    tags = ["docker", "perfecto"]

    disk {
        image = "${var.image}"
        size = 10
    }

    network_interface {
        network = "default"
        access_config {
            // Ephemeral IP
        }
    }

    metadata {
        "sshKeys" = "${var.sshkey_metadata}"
    }

    service_account {
      scopes = ["storage-ro"]
    }

    provisioner "remote-exec" {
        inline = [
            "sudo cat <<'EOF' > /tmp/docker.env\n${template_file.docker.rendered}\nEOF",
            "sudo mv /tmp/docker.env /etc/docker.env",
            "sudo systemctl enable docker",
            "sudo systemctl start docker",
            "mkdir ~/mysql",
            "bash ~core/docker_starter.sh"
        ]
        connection {
            user = "core"
            agent = true
        }
    }
    depends_on = [
        "template_file.docker"
    ]
}
