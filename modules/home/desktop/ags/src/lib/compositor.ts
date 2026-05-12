import AstalNiri from "gi://AstalNiri";
import { createBinding, Accessor } from "ags";
import { Gdk } from "ags/gtk4";

const niri = AstalNiri.get_default();

export const compositor = {
  workspaces: () =>
    createBinding(niri, "workspaces").as((ws) =>
      [...ws].sort((a, b) => a.idx - b.idx),
    ),

  monitorWorkspaces: (m: Gdk.Monitor) =>
    createBinding(niri, "workspaces").as((ws) =>
      ws.filter((w) => w.output === m.connector).sort((a, b) => a.idx - b.idx),
    ),

  focusedWorkspace: () => createBinding(niri, "focusedWorkspace"),
  focusedWindow: () => createBinding(niri, "focusedWindow"),
  focusWorkspace: (ws: any) => ws?.focus(),
  nextWorkspace: () => AstalNiri.msg.focus_workspace_down(),
  prevWorkspace: () => AstalNiri.msg.focus_workspace_up(),
};
