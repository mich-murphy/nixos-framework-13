import AstalBattery from "gi://AstalBattery";
import { createBinding } from "ags";

const battery = AstalBattery.get_default();

function glyphFor(percentage: number, charging: boolean): string {
  if (charging) return "battery_charging_full";
  const pct = percentage * 100;
  if (pct >= 87.5) return "battery_full";
  if (pct >= 62.5) return "battery_5_bar";
  if (pct >= 25) return "battery_2_bar";
  return "battery_alert";
}

export default function Battery() {
  const percentage = createBinding(battery, "percentage");
  const charging = createBinding(battery, "charging");
  const isPresent = createBinding(battery, "isPresent");

  const glyph = percentage.as((p) =>
    glyphFor(p, battery.charging),
  );
  const label = percentage.as((p) => `${Math.round(p * 100)}%`);

  return (
    <box
      cssName="battery"
      visible={isPresent}
    >
      <label cssName="icon" label={glyph} />
      <label label={label} />
    </box>
  );
}
