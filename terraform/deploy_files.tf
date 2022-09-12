resource "local_file" "galera_config" {
  count = var.db_instance_count
  content = templatefile("./templates/galera.conf.tmpl", {
      ip_list = "${join(",", formatlist("%v", aws_instance.galera_db[*].private_ip))}"
      node_address = aws_instance.galera_db[count.index].private_ip
      node_name = "galera-test${count.index}"
    })
  filename = "../deploy/config/galera.${count.index}.cnf"
}

resource "local_file" "maxscale_config" {
  content = templatefile("./templates/maxscale.conf.tmpl", {
      db_servers = aws_instance.galera_db
      db_names = "${join(",", formatlist("galera%v", range(var.db_instance_count)))}"
    })
  filename = "../deploy/config/maxscale.conf"
}

resource "local_file" "setup_script" {
  depends_on = [aws_instance.jumpbox]
  filename = "../deploy/setup.sh"
  file_permission = "0755"
  content = templatefile("./templates/setup.sh.tmpl", {
    bastion_ip = aws_instance.jumpbox.public_ip
    ssh_key_path = var.ssh_key_path
  })
}

resource "local_file" "maxscale_setup" {
  filename = "../deploy/maxscale_setup.sh"
  file_permission = "0755"
  content = templatefile("./templates/maxscale_setup.sh.tmpl", {
    db_servers = aws_instance.galera_db
    maxscale_servers = aws_instance.maxscale
    db_user = "centos"
  })
}

resource "local_file" "ssh_config" {
  filename = "../deploy/ssh_config"
  content = templatefile("./templates/ssh_config.tmpl", {
    user = "rocky"
    db_user = "centos"
    bastion_ip = "${aws_instance.jumpbox.public_ip}"
    db_servers = aws_instance.galera_db
    maxscale_servers = aws_instance.maxscale
    ssh_key_path = var.ssh_key_path
  })
}