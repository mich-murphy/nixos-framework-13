import { App } from "ags/gtk4";
import "./style.scss";
import Bar from "./modules/bar/bar";
import QuickSettings from "./modules/quicksettings/quicksettings";
import NotificationCenter from "./modules/notifications/center";
import NotificationPopups from "./modules/notifications/popups";

App.start({
  main() {
    for (const monitor of App.get_monitors()) {
      Bar(monitor);
    }
    QuickSettings();
    NotificationCenter();
    NotificationPopups();
  },
});
