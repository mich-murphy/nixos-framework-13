import AstalNotifd from "gi://AstalNotifd";
import { createBinding, Accessor } from "ags";

const notifd = AstalNotifd.get_default();

export type Notification = AstalNotifd.Notification;

export const notifications = {
  all: (): Accessor<Notification[]> => createBinding(notifd, "notifications"),
  popups: (): Accessor<Notification[]> =>
    createBinding(notifd, "notifications").as((ns) =>
      ns.filter((n) => !n.dismissedByUser).slice(-3),
    ),
  dismiss: (id: number) => notifd.get_notification(id)?.dismiss(),
  clearAll: () => notifd.notifications.forEach((n) => n.dismiss()),
  dontDisturb: (v?: boolean) => {
    if (v !== undefined) notifd.dontDisturb = v;
    return notifd.dontDisturb;
  },
};
