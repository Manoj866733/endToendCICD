#installing Prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.45.3/prometheus-2.45.3.linux-amd64.tar.gz
tar -xvf prometheus-2.45.3.linux-amd64.tar.gz
rm -rf prometheus-2.45.3.linux-amd64.tar.gz
cd prometheus-2.45.3.linux-amd64/
./prometheus &
echo

#installing Grafana

sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_10.4.0_amd64.deb
sudo dpkg -i grafana-enterprise_10.4.0_amd64.deb
sudo /bin/systemctl start grafana-server


#installaing Blackbox

wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.24.0/blackbox_exporter-0.24.0.linux-amd64.tar.gz
tar -xvf blackbox_exporter-0.24.0.linux-amd64.tar.gz
rm -rf blackbox_exporter-0.24.0.linux-amd64.tar.gz
cd blackbox_exporter-0.24.0.linux-amd64/
./blackbox_exporter &
echo


