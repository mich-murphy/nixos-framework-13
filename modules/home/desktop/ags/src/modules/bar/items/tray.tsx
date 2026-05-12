import AstalTray from "gi://AstalTray";
import { createBinding, For } from "ags";

const tray = AstalTray.get_default();

export default function Tray() {
  const items = createBinding(tray, "items");
  return (
    <box cssName="tray" spacing={4}>
      <For each={items}>
        {(item: any) => (
          <menubutton
            tooltipMarkup={item.tooltipMarkup}
            menuModel={item.menuModel}
            actionGroup={["dbusmenu", item.actionGroup]}
          >
            <image gicon={item.gicon} pixelSize={16} />
          </menubutton>
        )}
      </For>
    </box>
  );
}
