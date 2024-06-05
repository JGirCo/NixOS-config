{ pkgs, ... }:
let batteryScript = import ../batteryNotifier.nix { inherit pkgs; };
in {
  # systemd services

  systemd.user.services."battery-notifier" = {
    Unit = { Description = "Systemd user service template"; };
    Service = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "battery-notifier-script" ''
              # Send a notification if the laptop battery is either low
        # or is fully charged.

        export DISPLAY=:0
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

        # Battery percentage at which to notify
        WARNING_LEVEL=10
        BATTERY_DISCHARGING=$(${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep "Battery 0" | ${pkgs.gnugrep}/bin/grep -c "Discharging")
        BATTERY_LEVEL=$(${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep "Battery 0" | ${pkgs.gnugrep}/bin/grep -P -o '[0-9]+(?=%)')

        # Use two files to store whether we've shown a notification or not (to prevent multiple notifications)
        EMPTY_FILE=/tmp/batteryempty
        FULL_FILE=/tmp/batteryfull

        # Reset notifications if the computer is charging/discharging
        if [ "$BATTERY_DISCHARGING" -eq 1 ] && [ -f $FULL_FILE ]; then
        	rm $FULL_FILE
        elif [ "$BATTERY_DISCHARGING" -eq 0 ] && [ -f $EMPTY_FILE ]; then
        	rm $EMPTY_FILE
        fi

        # If the battery is charging and is full (and has not shown notification yet)
        if [ "$BATTERY_LEVEL" -gt 95 ] && [ "$BATTERY_DISCHARGING" -eq 0 ] && [ ! -f $FULL_FILE ]; then
        	${pkgs.dunst}/bin/dunstify -r 9992 -u low "Battery Full" "Battery level is ''${BATTERY_LEVEL}%!"
        	touch $FULL_FILE
        # If the battery is low and is not charging (and has not shown notification yet)
        elif [ "$BATTERY_LEVEL" -le $WARNING_LEVEL ] && [ "$BATTERY_DISCHARGING" -eq 1 ] && [ ! -f $EMPTY_FILE ]; then
        	${pkgs.dunst}/bin/dunstify -r 9992 -u critical "Battery Low" "Battery level is ''${BATTERY_LEVEL}%!"
        	touch $EMPTY_FILE
        fi
      '');
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.timers."battery-notifier" = {
    Unit = { Description = "sysdtimer template"; };
    Timer = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "battery-notifier";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
