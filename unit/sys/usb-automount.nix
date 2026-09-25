{ pkgs, ... }:
let
  usbAutomount = pkgs.writeShellApplication {
    name = "usb-automount";
    runtimeInputs = with pkgs; [
      coreutils
      util-linux
    ];
    text = ''
      action="''${1:?missing action}"
      device_name="''${2:?missing device name}"

      if [[ ! "$device_name" =~ ^[a-zA-Z0-9._-]+$ ]]; then
        echo "Invalid block device name: $device_name" >&2
        exit 1
      fi

      device="/dev/$device_name"
      state_dir="/run/usb-automount"
      state_file="$state_dir/$device_name"

      mkdir -p "$state_dir"

      case "$action" in
        mount)
          exec 9>"$state_dir/lock"
          flock 9
          if [[ ! -b "$device" ]]; then
            echo "Block device does not exist: $device" >&2
            exit 1
          fi

          if findmnt --noheadings --source "$device" >/dev/null; then
            exit 0
          fi

          slot=1
          while true; do
            mountpoint="/data/usb$slot"

            if [[ ! -L "$mountpoint" && -f "$mountpoint/.usb-automount" ]] &&
              ! mountpoint --quiet "$mountpoint"; then
              shopt -s nullglob dotglob
              entries=("$mountpoint"/*)
              shopt -u nullglob dotglob
              if [[ "''${#entries[@]}" -eq 1 && "''${entries[0]}" == "$mountpoint/.usb-automount" ]]; then
                rm "$mountpoint/.usb-automount"
                rmdir "$mountpoint"
              fi
            fi

            if [[ ! -e "$mountpoint" ]]; then
              break
            fi

            slot=$((slot + 1))
          done

          mkdir "$mountpoint"
          : >"$mountpoint/.usb-automount"
          printf '%s\n' "$mountpoint" >"$state_file"

          if ! mount -o nosuid,nodev "$device" "$mountpoint"; then
            rm -f "$state_file" "$mountpoint/.usb-automount"
            rmdir "$mountpoint"
            exit 1
          fi

          echo "Mounted $device at $mountpoint"
          ;;
        monitor)
          if [[ ! -f "$state_file" ]]; then
            exit 0
          fi

          IFS= read -r mountpoint <"$state_file"
          if [[ ! "$mountpoint" =~ ^/data/usb[1-9][0-9]*$ ]]; then
            echo "Invalid mountpoint state: $mountpoint" >&2
            exit 1
          fi

          # Keep the service active until the mount disappears.
          while mountpoint --quiet "$mountpoint"; do
            findmnt \
              --poll=umount \
              --first-only \
              --timeout 1000 \
              --mountpoint "$mountpoint" \
              --noheadings >/dev/null || true
          done
          ;;
        unmount)
          exec 9>"$state_dir/lock"
          flock 9
          if [[ ! -f "$state_file" ]]; then
            exit 0
          fi

          IFS= read -r mountpoint <"$state_file"
          if [[ ! "$mountpoint" =~ ^/data/usb[1-9][0-9]*$ ]]; then
            echo "Invalid mountpoint state: $mountpoint" >&2
            exit 1
          fi

          if mountpoint --quiet "$mountpoint"; then
            umount "$mountpoint" || umount --lazy "$mountpoint"
          fi

          rm -f "$state_file" "$mountpoint/.usb-automount"
          rmdir "$mountpoint" 2>/dev/null || true
          echo "Unmounted $device from $mountpoint"
          ;;
        *)
          echo "Unknown action: $action" >&2
          exit 1
          ;;
      esac
    '';
  };
in
{
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_BUS}=="usb", ENV{ID_FS_USAGE}=="filesystem", TAG+="systemd", ENV{SYSTEMD_WANTS}+="usb-automount@%k.service"
  '';

  systemd.services."usb-automount@" = {
    description = "Mount USB block device %I";
    bindsTo = [ "dev-%i.device" ];
    after = [ "dev-%i.device" ];
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${usbAutomount}/bin/usb-automount mount %I";
      ExecStart = "${usbAutomount}/bin/usb-automount monitor %I";
      ExecStopPost = "${usbAutomount}/bin/usb-automount unmount %I";
      TimeoutStartSec = 30;
      TimeoutStopSec = 30;
    };
  };

  systemd.tmpfiles.rules = [
    "d /data 0755 root root - -"
  ];
}
