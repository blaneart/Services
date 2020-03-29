FROM grafana/grafana
COPY ./grafana.ini /etc/grafana/
COPY ./influxdb.yaml /etc/grafana/provisioning/datasources/
COPY ./dashboards.yaml /etc/grafana/provisioning/dashboards/
COPY ./*.json /var/lib/grafana/dashboards/
ENTRYPOINT /run.sh
