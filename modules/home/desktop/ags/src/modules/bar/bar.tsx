import App from "ags/gtk4/app";
import { Astal, Gtk, Gdk } from "ags/gtk4";
import Workspaces from "./items/workspaces";
import Clock from "./items/clock";
import SysStats from "./items/sysstats";
import Battery from "./items/battery";
import Tray from "./items/tray";
import QSOpener from "./items/qs-opener";

export default function Bar(monitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;
  return (
    <window
      namespace="ags-bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={App}
    >
      <centerbox cssName="bar-content">
        <box halign={Gtk.Align.START} spacing={4}>
          <Workspaces gdkmonitor={monitor} />
        </box>
        <box halign={Gtk.Align.CENTER}>
          <Clock />
        </box>
        <box halign={Gtk.Align.END} spacing={8}>
          <SysStats />
          <Battery />
          <Tray />
          <QSOpener />
        </box>
      </centerbox>
    </window>
  );
}
