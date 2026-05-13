// TODO(integration): style.scss must @import "./styles/notifications".
import { Gtk } from "ags/gtk4";
import { createState } from "ags";
import GLib from "gi://GLib";
import type { Notification } from "../../services/notifications";

type Props = {
  notification: Notification;
  onDismiss: () => void;
};

function formatTime(n: Notification): string {
  // TODO(agent-B-renames): may be `time` (unix seconds) or `timestamp` on AstalNotifd.Notification.
  const t = (n as any).time ?? (n as any).timestamp ?? 0;
  if (!t) return "";
  const dt = GLib.DateTime.new_from_unix_local(t);
  return dt?.format("%H:%M") ?? "";
}

function appIconGlyph(n: Notification): string | null {
  // TODO(agent-B-renames): could be `app_icon`, `appIcon`, or `desktopEntry`.
  const icon = (n as any).appIcon ?? (n as any).app_icon ?? null;
  return icon || null;
}

export default function NotificationRow({ notification, onDismiss }: Props) {
  const [hover, setHover] = createState(false);

  const summary = (notification as any).summary ?? "";
  const body = (notification as any).body ?? "";
  const iconName = appIconGlyph(notification);

  return (
    <button
      cssName="notif-row"
      onClicked={() => {
        // TODO(agent-B-renames): default action key is conventionally "default".
        try {
          (notification as any).invoke?.("default");
        } catch {
          // no-op
        }
        onDismiss();
      }}
    >
      <box
        cssName="notif-inner"
        spacing={8}
        $={(self: any) => {
          const motion = new Gtk.EventControllerMotion();
          motion.connect("enter", () => setHover(true));
          motion.connect("leave", () => setHover(false));
          self.add_controller(motion);
        }}
      >
        <box cssName="notif-icon-slot">
          {iconName ? (
            <image cssName="notif-app-icon" iconName={iconName} pixelSize={32} />
          ) : (
            <label cssName="icon notif-fallback-icon" label="info" />
          )}
        </box>
        <box orientation={Gtk.Orientation.VERTICAL} hexpand cssName="notif-text">
          <box cssName="notif-header" spacing={6}>
            <label
              cssName="notif-title"
              label={summary}
              ellipsize={3}
              xalign={0}
              hexpand
            />
            <label cssName="notif-time" label={formatTime(notification)} />
          </box>
          <label
            cssName="notif-body"
            label={body}
            useMarkup={false}
            wrap
            ellipsize={3}
            xalign={0}
            maxWidthChars={40}
            lines={3}
          />
        </box>
        <revealer
          revealChild={hover}
          transitionType={Gtk.RevealerTransitionType.CROSSFADE}
        >
          <button
            cssName="notif-close"
            onClicked={(_self: any) => {
              onDismiss();
            }}
          >
            <label cssName="icon" label="clear_all" />
          </button>
        </revealer>
      </box>
    </button>
  );
}
