import { Gtk, Gdk } from "ags/gtk4";
import { For } from "ags";
import { compositor } from "../../../lib/compositor";

type Props = { gdkmonitor: Gdk.Monitor };

export default function Workspaces({ gdkmonitor }: Props) {
  const wsAccessor = compositor.monitorWorkspaces(gdkmonitor);
  const focused = compositor.focusedWorkspace();

  return (
    <box cssName="workspaces" spacing={2}>
      <For each={wsAccessor}>
        {(ws: any) => (
          <button
            cssClasses={focused.as((f: any) =>
              f && f.idx === ws.idx
                ? ["workspace", "focused"]
                : ["workspace"],
            )}
            onClicked={() => compositor.focusWorkspace(ws)}
          />
        )}
      </For>
    </box>
  );
}
