// TODO(integration): style.scss must @import "./styles/notifications".
import App from "ags/gtk4/app";
import { Astal, Gtk } from "ags/gtk4";
import { For } from "ags";
import { timeout } from "ags/time";
import { notifications, type Notification } from "../../services/notifications";
import NotificationRow from "./notification";

const POPUP_NAMESPACE = "ags-notifications";
const POPUP_DISMISS_MS = 6000;

// TODO(agent-B-renames): AstalNotifd urgency values — 0 low, 1 normal, 2 critical.
const URGENCY_CRITICAL = 2;

function isCritical(n: Notification): boolean {
  const u = (n as any).urgency;
  return u === URGENCY_CRITICAL;
}

const timers = new Set<number>();

function schedule(n: Notification) {
  if (isCritical(n)) return; // critical urgency persists until clicked
  const id = (n as any).id;
  if (id === undefined || timers.has(id)) return;
  timers.add(id);
  timeout(POPUP_DISMISS_MS, () => {
    timers.delete(id);
    notifications.dismiss(id);
  });
}

export default function Popups() {
  const { TOP, RIGHT } = Astal.WindowAnchor;
  const popups = notifications.popups();

  return (
    <window
      namespace={POPUP_NAMESPACE}
      cssName="notif-popups-window"
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={TOP | RIGHT}
      marginTop={12}
      marginRight={12}
      application={App}
      visible
    >
      <box orientation={Gtk.Orientation.VERTICAL} cssName="notif-popups" spacing={6}>
        <For each={popups.as((ns) => (ns ?? []).slice(-3))}>
          {(n: Notification) => {
            schedule(n);
            return (
              <box cssName="notif-popup">
                <NotificationRow
                  notification={n}
                  onDismiss={() => notifications.dismiss((n as any).id)}
                />
              </box>
            );
          }}
        </For>
      </box>
    </window>
  );
}
