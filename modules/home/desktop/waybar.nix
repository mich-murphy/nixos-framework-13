{
  pkgs,
  colors,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        modules-left = ["niri/workspaces" "mpris"];
        modules-center = ["clock"];
        modules-right = [
          "group/expand"
          "temperature"
          "cpu"
          "memory"
          "backlight"
          "pulseaudio"
          "battery"
          "custom/menu"
        ];

        clock = {
          format = "󰥔 {:%H:%M - %a %d}";
          tooltip = false;
        };

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "󰮯";
            empty = "";
            default = "";
            urgent = "󰊠";
          };
          disable-markup = true;
        };

        temperature = {
          interval = 10;
          format = "{icon} {temperatureC}°";
          critical-threshold = 80;
          format-icons = ["" "" "" "" ""];
        };

        cpu = {
          interval = 10;
          format = " {}%";
        };

        memory = {
          interval = 30;
          format = " {used:0.1f}G";
        };

        mpris = {
          format = " {artist} - {title}";
          tooltip-format = "{album}";
          format-paused = " {artist} - {title}";
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl previous";
          on-scroll-down = "playerctl next";
          max-length = 45;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "{icon}";
          format-icons = {
            headphone = "";
            headset = "";
            headphone-muted = "󰟎";
            headset-muted = "󰟎";
            default = ["" ""];
            default-muted = "󰖁";
          };
          scroll-step = 2;
          tooltip = false;
          on-click = "pavucontrol";
          ignored-sinks = ["Easy Effects Sink"];
        };

        battery = {
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-icons = ["" "" "" "" ""];
        };

        network = {
          interval = 10;
          format-wifi = " {bandwidthDownBits}  {bandwidthUpBits} ";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          format-disconnected = "";
          tooltip-format = "{ifname} via {gwaddr} 󰈀";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ifname} ";
          tooltip-format-disconnected = "Disconnected";
          menu = "on-click";
          menu-file = "~/.config/waybar/menus/network.xml";
          menu-actions = {
            action-1 = "nm-connection-editor";
          };
        };

        bluetooth = {
          format = "{}";
          format-on = "󰂰";
          format-off = "󰂲";
          format-disabled = "󰂲";
          format-connected = "{device_alias}   {device_battery_percentage}%";
          tooltip-format = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t {device_battery_percentage}%";
          on-click-right = "blueman-manager";
        };

        tray = {
          icon-size = 14;
          spacing = 15;
        };

        power-profiles-daemon = {
          format = "<span size='10pt'>{icon}</span>";
          tooltip-format = "Power profile: {profile}";
          tooltip = true;
          format-icons = {
            default = "󱟢";
            performance = "󰂅";
            balanced = "󱟢";
            power-saver = "󱈏";
          };
        };

        backlight = {
          scroll-step = 2;
          format = "{icon} {percent}%";
          tooltip-format = "{percent}%";
          format-icons = ["" "" "" "" "" "" "" "" "" "" "" "" "" "" ""];
        };

        "custom/expand" = {
          format = "";
          tooltip = false;
        };

        "group/expand" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 300;
            children-class = "expand-child";
            transition-left-to-right = false;
          };
          modules = ["custom/expand" "bluetooth" "tray" "power-profiles-daemon"];
        };

        "custom/menu" = {
          format = "";
          tooltip = false;
          menu = "on-click";
          menu-file = "~/.config/waybar/menus/power.xml";
          menu-actions = {
            shutdown = "systemctl poweroff";
            reboot = "systemctl reboot";
            logout = "niri msg action quit";
            lock = "niri msg action spawn -- hyprlock";
          };
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 0.95rem;
        font-weight: 700;
        min-height: 20px;
      }

      window#waybar {
        background: ${colors.bg};
      }

      tooltip {
        background: ${colors.bg};
        border: 1px solid ${colors.bg3};
      }
      tooltip label {
        color: ${colors.fg};
      }

      #custom-launcher,
      #clock,
      #temperature,
      #cpu,
      #memory,
      #workspaces,
      #custom-notification,
      #mpris,
      #bluetooth,
      #pulseaudio,
      #backlight,
      #power-profiles-daemon,
      #tray,
      #battery,
      #custom-menu,
      #custom-expand,
      #network {
        color: ${colors.fg};
        background-color: ${colors.bg};
        padding: 0 10px;
      }

      #temperature,
      #cpu,
      #memory {
        color: ${colors.aqua};
      }

      #backlight,
      #pulseaudio,
      #battery {
        color: ${colors.blue};
      }

      #clock {
        margin-right: 0;
      }

      #bluetooth.disabled {
        color: ${colors.fg_dark};
      }

      #workspaces button {
        color: ${colors.fg};
        padding: 5px 10px 5px 0;
      }

      #workspaces button.active {
        color: ${colors.purple};
        transition: all 0.3s ease;
      }

      #workspaces button.urgent {
        color: ${colors.red};
        transition: all 0.3s ease;
      }

      menu {
        border-radius: 0px;
        border: ${colors.bg3} 1px solid;
        background: ${colors.bg};
        color: ${colors.fg};
      }
    '';
  };

  xdg.configFile."waybar/menus/network.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
      <object class="GtkMenu" id="menu">
        <child>
          <object class="GtkMenuItem" id="action-1">
            <property name="label"> Network settings</property>
          </object>
        </child>
      </object>
    </interface>
  '';

  xdg.configFile."waybar/menus/power.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
      <object class="GtkMenu" id="menu">
        <child>
          <object class="GtkMenuItem" id="lock">
            <property name="label"> Lock</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="logout">
            <property name="label">󰗼 Logout</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="reboot">
            <property name="label"> Reboot</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="shutdown">
            <property name="label"> Shutdown</property>
          </object>
        </child>
      </object>
    </interface>
  '';
}
