# desired cluster name; default is "kind"

docker container stop registry && docker container rm -v registry

kind_version=$(kind version)
reg_name='kind-registry'
reg_port='5000'
reg_ip_selector='{{.NetworkSettings.Networks.kind.IPAddress}}'
reg_network='kind'
case "${kind_version}" in
  "kind v0.7."* | "kind v0.6."* | "kind v0.5."*)
    reg_ip_selector='{{.NetworkSettings.IPAddress}}'
    reg_network='bridge'
    ;;
esac

# create registry container unless it already exists
running="$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)"

# If the registry already exists, but is in the wrong network, we have to
# re-create it.
if [ "${running}" = 'true' ]; then
  reg_ip="$(docker inspect -f ${reg_ip_selector} "${reg_name}")"
  if [ "${reg_ip}" = '' ]; then
    docker kill ${reg_name}
    docker rm ${reg_name}
    running="false"
  fi
fi

if [ "${running}" != 'true' ]; then
  if [ "${reg_network}" != "bridge" ]; then
    docker network create "${reg_network}" || true
  fi
  
  docker run \
    -d --restart=always -p "${reg_port}:5000" --name "${reg_name}" --net "${reg_network}" \
    registry:2
fi

reg_ip="$(docker inspect -f ${reg_ip_selector} "${reg_name}")"
if [ "${reg_ip}" = "" ]; then
    echo "Error creating registry: no IPAddress found at: ${reg_ip_selector}"
    exit 1
fi
echo "Registry IP: ${reg_ip}"