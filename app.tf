resource "google_compute_instance" "app_instance" {
  name         = "hello-world-app"
  machine_type = "f1-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network    = module.network.vpc_network
    subnetwork = module.network.subnets[0].subnet_name

    access_config {
      # Include this section to give the VM an external IP address
    }
  }

  metadata_startup_script = <<-EOF
    #! /bin/bash
    apt-get update
    apt-get install -y apache2 php php-mysql
    service apache2 restart
    cat <<'EOT' > /var/www/html/index.php
    <?php
    $servername = "127.0.0.1";
    $username = "user";
    $password = "password";
    $dbname = "hello_world";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Check connection
    if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error);
    }

    $sql = "SELECT message FROM hello_world WHERE id = 1";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
      // output data of each row
      while($row = $result->fetch_assoc()) {
        echo $row["message"];
      }
    } else {
      echo "0 results";
    }
    $conn->close();
    ?>
    EOT
  EOF
}
