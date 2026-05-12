import { createState } from "ags";
import { interval } from "ags/time";
import GLib from "gi://GLib";

function now(): string {
  return GLib.DateTime.new_now_local().format("%a %d %b  %H:%M") ?? "";
}

export default function Clock() {
  const [time, setTime] = createState(now());
  interval(30_000, () => setTime(now()));

  return <label cssName="clock" label={time} />;
}
