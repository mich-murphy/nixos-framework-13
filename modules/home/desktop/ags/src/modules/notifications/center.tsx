// TODO(integration): style.scss must @import "./styles/notifications".
import App from "ags/gtk4/app";
import { Astal, Gtk } from "ags/gtk4";
import { For } from "ags";
import { notifications, type Notification } from "../../services/notifications";
import NotificationRow from "./notification";

const CENTER_NAMESPACE = "ags-notification-center";
const HISTORY_DEPTH = 50;

export default function NotificationCenter() {
  const { TOP, RIGHT } = Astal.WindowAnchor;
  const all = notifications.all();

  const sliced = all.as((ns) => (ns ?? []).slice(-HISTORY_DEPTH).reverse());
  const empty = all.as((ns) => (ns?.length ?? 0) === 0);

  return (
    <window
      namespace={CENTER_NAMESPACE}
      cssName="notif-center-window"
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={TOP | RIGHT}
      // ~QS panel height + 8px gap; refine via CSS var if QS grows past ~400px.
      marginTop={420}
      marginRight={12}
      visible={empty.as((e) => !e)}
      application={App}
    >
      <box orientation={Gtk.Orientation.VERTICAL} cssName="notif-center" spacing={6}>
        <box cssName="notif-center-header" spacing={6}>
          <label cssName="notif-center-title" label="Notifications" hexpand xalign={0} />
          <button
            cssName="notif-center-clear"
            onClicked={() => notifications.clearAll()}
          >
            <label cssName="icon" label="clear_all" />
          </button>
        </box>
        <scrolledwindow cssName="notif-center-scroll" hexpand vexpand>
          <box orientation={Gtk.Orientation.VERTICAL} cssName="notif-center-list" spacing={4}>
            <For each={sliced}>
              {(n: Notification) => (
                <NotificationRow
                  notification={n}
                  onDismiss={() => notifications.dismiss((n as any).id)}
                />
              )}
            </For>
          </box>
        </scrolledwindow>
      </box>
    </window>
  );
}
