{ pkgs, config, ... }: {

  # NOTE:  reference from this site:
  # https://madison-technologies.com/take-your-nixos-container-config-and-shove-it/

  # we create a systemd service so that we can create a single "pod"
  # for our containers to live inside of. This will mimic how docker compose
  # creates one network for the containers to live inside of
  systemd.services.create-wordpress-network =
    with config.virtualisation.oci-containers; {
      serviceConfig.Type = "oneshot";
      wantedBy =
        [ "podman-homeassistant.service" "podman-zigbee2mqtt.service" ];
      script = ''
        ${pkgs.podman}/bin/podman network exists hass-net || \
        ${pkgs.podman}/bin/podman network create hass-net
      '';
    };

  virtualisation.oci-containers.containers = {
    homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      volumes =
        [ "/containers/hass:/config" "/etc/localtime:/etc/localtime:ro" ];
      autoStart = true;
      ports = [ "8123:8123" ];
      environment = { TZ = "Canada/Toronto"; };
      extraOptions = [ "--network=hass-net" ];
    };

    zigbee2mqtt = {
      image = "zwavejs/zwavejs2mqtt:latest";
      autoStart = true;
      environment = {
        SESSION_SECRET = "72b8ef8c2j30";
        ZWAVEJS_EXTERNAL_CONFIG = "/usr/src/app/store/.config-db";
        TZ = "Canada/Eastern";
      };
      devices

    };
  };

}
