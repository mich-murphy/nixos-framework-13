// TODO(integration): style.scss must @import "./styles/quicksettings" and "./styles/notifications".
import App from "ags/gtk4/app";
import { Astal, Gtk } from "ags/gtk4";
import { createBinding, createState, For } from "ags";
import { execAsync } from "ags/process";
import { interval } from "ags/time";
import AstalNetwork from "gi://AstalNetwork";
import AstalBluetooth from "gi://AstalBluetooth";
import AstalPowerProfiles from "gi://AstalPowerProfiles";
import AstalWp from "gi://AstalWp";
import AstalMpris from "gi://AstalMpris";

const NOTIF_CENTER = "ags-notification-center";
const QS_NAMESPACE = "ags-quick-settings";

function Icon({
  name,
  cssClasses,
}: {
  name: any;
  cssClasses?: string[];
}) {
  return <label cssName="icon" cssClasses={cssClasses} label={name} />;
}

function Divider() {
  return <box cssName="qs-divider" />;
}

function WifiSection() {
  const network = AstalNetwork.get_default();
  const wifi = network.wifi;

  const [open, setOpen] = createState(false);

  const enabled = createBinding(wifi, "enabled");
  const ssid = createBinding(wifi, "ssid");
  const accessPoints = createBinding(wifi, "accessPoints");

  return (
    <box vertical cssName="qs-toggle-section">
      <button
        cssName="qs-toggle"
        cssClasses={enabled.as((on) =>
          on ? ["qs-toggle", "active"] : ["qs-toggle"],
        )}
        onClicked={() => setOpen((v) => !v)}
      >
        <box spacing={6}>
          <Icon
            name={enabled.as((on) => (on ? "wifi" : "wifi_off"))}
            cssClasses={enabled.as((on) => (on ? ["icon", "active"] : ["icon", "inactive"]))}
          />
          <label
            cssName="qs-toggle-label"
            label={ssid.as((s) => s ?? "Wi-Fi")}
            ellipsize={3}
            xalign={0}
            hexpand
          />
        </box>
      </button>
      <revealer revealChild={open} transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}>
        <box vertical cssName="qs-submenu">
          <box cssName="qs-submenu-header">
            <label label="Wi-Fi" hexpand xalign={0} />
            <switch
              active={enabled}
              onStateSet={(_self: any, state: boolean) => {
                wifi.enabled = state;
                return false;
              }}
            />
          </box>
          <box vertical cssName="qs-submenu-list">
            <For each={accessPoints.as((aps) => [...(aps ?? [])].sort((a, b) => b.strength - a.strength).slice(0, 8))}>
              {(ap: any) => (
                <button
                  cssName="qs-submenu-item"
                  onClicked={() => {
                    // TODO(agent-B-renames): real connection flow needs NM secrets agent; tap toggles activation if known.
                    execAsync(["nmcli", "device", "wifi", "connect", ap.ssid ?? ap.bssid]).catch(() => {});
                  }}
                >
                  <box spacing={6}>
                    <Icon name="wifi" />
                    <label label={ap.ssid ?? "(hidden)"} hexpand xalign={0} ellipsize={3} />
                  </box>
                </button>
              )}
            </For>
          </box>
        </box>
      </revealer>
    </box>
  );
}

function BluetoothSection() {
  const bt = AstalBluetooth.get_default();
  const [open, setOpen] = createState(false);

  const powered = createBinding(bt, "isPowered");
  const devices = createBinding(bt, "devices");

  return (
    <box vertical cssName="qs-toggle-section">
      <button
        cssName="qs-toggle"
        cssClasses={powered.as((on) =>
          on ? ["qs-toggle", "active"] : ["qs-toggle"],
        )}
        onClicked={() => setOpen((v) => !v)}
      >
        <box spacing={6}>
          <Icon
            name={powered.as((on) => (on ? "bluetooth" : "bluetooth_disabled"))}
            cssClasses={powered.as((on) => (on ? ["icon", "active"] : ["icon", "inactive"]))}
          />
          <label cssName="qs-toggle-label" label="Bluetooth" hexpand xalign={0} />
        </box>
      </button>
      <revealer revealChild={open} transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}>
        <box vertical cssName="qs-submenu">
          <box cssName="qs-submenu-header">
            <label label="Bluetooth" hexpand xalign={0} />
            <switch
              active={powered}
              onStateSet={(_self: any, state: boolean) => {
                bt.adapter?.set_powered(state);
                return false;
              }}
            />
          </box>
          <box vertical cssName="qs-submenu-list">
            <For each={devices.as((ds) => [...(ds ?? [])].filter((d: any) => d.paired || d.connected))}>
              {(dev: any) => (
                <button
                  cssName="qs-submenu-item"
                  onClicked={() => {
                    if (dev.connected) dev.disconnect_device(() => {});
                    else dev.connect_device(() => {});
                  }}
                >
                  <box spacing={6}>
                    <Icon name="bluetooth" />
                    <label label={dev.alias ?? dev.name ?? "device"} hexpand xalign={0} ellipsize={3} />
                  </box>
                </button>
              )}
            </For>
          </box>
        </box>
      </revealer>
    </box>
  );
}

function profileGlyph(p: string): string {
  if (p === "performance") return "bolt";
  if (p === "power-saver") return "eco";
  return "balance";
}

function PowerProfileSection() {
  const pp = AstalPowerProfiles.get_default();
  const [open, setOpen] = createState(false);

  const active = createBinding(pp, "activeProfile");
  const profiles = createBinding(pp, "profiles");

  return (
    <box vertical cssName="qs-toggle-section">
      <button
        cssName="qs-toggle"
        cssClasses={["qs-toggle", "active"]}
        onClicked={() => setOpen((v) => !v)}
      >
        <box spacing={6}>
          <Icon
            name={active.as((p: any) => profileGlyph(String(p ?? "balanced")))}
            cssClasses={["icon", "active"]}
          />
          <label
            cssName="qs-toggle-label"
            label={active.as((p: any) => String(p ?? "balanced"))}
            hexpand
            xalign={0}
          />
        </box>
      </button>
      <revealer revealChild={open} transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}>
        <box vertical cssName="qs-submenu">
          <box vertical cssName="qs-submenu-list">
            <For each={profiles.as((ps: any) => [...(ps ?? [])])}>
              {(p: any) => (
                <button
                  cssName="qs-submenu-item"
                  onClicked={() => {
                    pp.activeProfile = p.profile;
                  }}
                >
                  <box spacing={6}>
                    <Icon name={profileGlyph(p.profile)} />
                    <label label={p.profile} hexpand xalign={0} />
                  </box>
                </button>
              )}
            </For>
          </box>
        </box>
      </revealer>
    </box>
  );
}

function volumeGlyph(v: number, mute: boolean): string {
  if (mute || v <= 0) return "volume_mute";
  if (v < 0.5) return "volume_down";
  return "volume_up";
}

function VolumeSlider() {
  const wp = AstalWp.get_default();
  const speaker: any = wp?.defaultSpeaker;
  if (!speaker) {
    return <box />;
  }
  const volume = createBinding(speaker, "volume");
  const mute = createBinding(speaker, "mute");

  return (
    <box cssName="qs-slider-row" spacing={8}>
      <button
        cssName="qs-slider-icon"
        onClicked={() => {
          speaker.mute = !speaker.mute;
        }}
      >
        <Icon
          name={volume.as((v) => volumeGlyph(v as number, speaker.mute))}
          cssClasses={mute.as((m) => (m ? ["icon", "inactive"] : ["icon"]))}
        />
      </button>
      <slider
        cssName="qs-slider"
        hexpand
        value={volume}
        min={0}
        max={1}
        step={0.01}
        onChangeValue={(self: any) => {
          speaker.volume = self.value;
          if (speaker.mute && self.value > 0) speaker.mute = false;
        }}
      />
      <label
        cssName="qs-slider-percent"
        label={volume.as((v) => `${Math.round((v as number) * 100)}%`)}
      />
    </box>
  );
}

function BrightnessSlider() {
  const [pct, setPct] = createState(50);
  let writing = false;

  const read = () => {
    if (writing) return;
    execAsync(["brightnessctl", "-m", "get"])
      .then((out: string) => {
        // also accept plain integer output from `brightnessctl get` if -m is unavailable
        const parts = out.trim().split(",");
        const raw = parts.length > 1 ? parts[2] : out.trim();
        const val = parseInt(String(raw).replace("%", ""), 10);
        if (!Number.isNaN(val)) setPct(Math.max(1, Math.min(100, val)));
      })
      .catch(() => {});
  };

  read();
  interval(2000, read);

  return (
    <box cssName="qs-slider-row" spacing={8}>
      <box cssName="qs-slider-icon">
        <Icon name="light_mode" />
      </box>
      <slider
        cssName="qs-slider"
        hexpand
        value={pct}
        min={1}
        max={100}
        step={1}
        onChangeValue={(self: any) => {
          const v = Math.round(self.value);
          setPct(v);
          writing = true;
          execAsync(["brightnessctl", "set", `${v}%`])
            .catch(() => {})
            .finally(() => {
              writing = false;
            });
        }}
      />
      <label
        cssName="qs-slider-percent"
        label={pct.as((v) => `${v}%`)}
      />
    </box>
  );
}

function pickPlayer(players: AstalMpris.Player[]): AstalMpris.Player | null {
  if (!players || players.length === 0) return null;
  const playing = players.find((p) => p.playbackStatus === AstalMpris.PlaybackStatus.PLAYING);
  return playing ?? players[0];
}

function MprisSection() {
  const mpris = AstalMpris.get_default();
  const players = createBinding(mpris, "players");

  const visible = players.as((ps) => {
    const p = pickPlayer(ps as any);
    return !!(p && (p.title || p.artist));
  });

  return (
    <revealer revealChild={visible} transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}>
      <box vertical>
        <Divider />
        <box cssName="qs-mpris" spacing={8}>
          <box cssName="qs-mpris-art">
            {/* TODO(agent-B-renames): coverArt may be art_url; using fallback Gtk.Picture-as-box with file binding */}
            <picture
              cssName="qs-mpris-cover"
              file={players.as((ps) => {
                const p = pickPlayer(ps as any);
                return p?.coverArt ?? null;
              })}
            />
          </box>
          <box vertical hexpand>
            <label
              cssName="qs-mpris-title"
              label={players.as((ps) => pickPlayer(ps as any)?.title ?? "")}
              ellipsize={3}
              xalign={0}
            />
            <label
              cssName="qs-mpris-artist"
              label={players.as((ps) => pickPlayer(ps as any)?.artist ?? "")}
              ellipsize={3}
              xalign={0}
            />
            <box cssName="qs-mpris-transport" spacing={4}>
              <button
                cssName="qs-mpris-btn"
                onClicked={() => pickPlayer(mpris.players)?.previous()}
              >
                <Icon name="skip_previous" />
              </button>
              <button
                cssName="qs-mpris-btn"
                onClicked={() => pickPlayer(mpris.players)?.play_pause()}
              >
                <Icon
                  name={players.as((ps) => {
                    const p = pickPlayer(ps as any);
                    return p?.playbackStatus === AstalMpris.PlaybackStatus.PLAYING
                      ? "pause"
                      : "play_arrow";
                  })}
                />
              </button>
              <button
                cssName="qs-mpris-btn"
                onClicked={() => pickPlayer(mpris.players)?.next()}
              >
                <Icon name="skip_next" />
              </button>
            </box>
          </box>
        </box>
      </box>
    </revealer>
  );
}

function SessionRow() {
  const actions: Array<[string, string[]]> = [
    ["lock", ["hyprlock"]],
    ["bedtime", ["systemctl", "suspend"]],
    ["logout", ["niri", "msg", "action", "quit"]],
    ["restart_alt", ["systemctl", "reboot"]],
    ["power_settings_new", ["systemctl", "poweroff"]],
  ];
  return (
    <box cssName="qs-session" spacing={4} homogeneous>
      {actions.map(([glyph, cmd]) => (
        <button
          cssName="qs-session-btn"
          onClicked={() => {
            execAsync(cmd).catch(() => {});
          }}
        >
          <Icon name={glyph} />
        </button>
      ))}
    </box>
  );
}

export default function QuickSettings() {
  const { TOP, RIGHT } = Astal.WindowAnchor;
  return (
    <window
      namespace={QS_NAMESPACE}
      cssName="qs-window"
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={TOP | RIGHT}
      marginTop={12}
      marginRight={12}
      visible={false}
      application={App}
      $={(self: any) => {
        self.connect("notify::visible", () => {
          const visible = self.visible;
          const center = App.get_window(NOTIF_CENTER);
          if (!center) return;
          if (visible) {
            // center.tsx hides itself when empty; just request show.
            center.visible = true;
          } else {
            center.visible = false;
          }
        });
      }}
    >
      <box vertical cssName="qs-panel" spacing={6}>
        <box cssName="qs-toggles" spacing={6} homogeneous>
          <WifiSection />
          <BluetoothSection />
          <PowerProfileSection />
        </box>
        <Divider />
        <VolumeSlider />
        <BrightnessSlider />
        <MprisSection />
        <Divider />
        <SessionRow />
      </box>
    </window>
  );
}
