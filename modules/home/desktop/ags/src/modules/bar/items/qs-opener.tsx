import App from "ags/gtk4/app";
import { createBinding } from "ags";
import AstalNetwork from "gi://AstalNetwork";
import AstalBluetooth from "gi://AstalBluetooth";
import AstalWp from "gi://AstalWp";
import BarItem from "../../../widgets/baritem";

const network = AstalNetwork.get_default();
const bluetooth = AstalBluetooth.get_default();
const wp = AstalWp.get_default();

function volumeGlyph(volume: number, mute: boolean): string {
  if (mute) return "volume_mute";
  if (volume < 0.5) return "volume_down";
  return "volume_up";
}

export default function QSOpener() {
  const wifiState = createBinding(network, "wifi");
  const btPowered = createBinding(bluetooth, "isPowered");

  const speaker = wp?.defaultSpeaker;
  const speakerVol = speaker
    ? createBinding(speaker, "volume")
    : null;
  const speakerMute = speaker
    ? createBinding(speaker, "mute")
    : null;

  return (
    <BarItem
      cssClasses={["qs-opener"]}
      onClicked={() => App.toggle_window("ags-quick-settings")}
    >
      <box spacing={2}>
        <label
          label="wifi"
          cssClasses={wifiState.as((w: any) =>
            w && w.enabled
              ? ["icon", "active"]
              : ["icon", "inactive"],
          )}
        />
        <label
          label="bluetooth"
          cssClasses={btPowered.as((on) =>
            on ? ["icon", "active"] : ["icon", "inactive"],
          )}
        />
        {speakerVol && speakerMute ? (
          <label
            label={speakerVol.as((v) =>
              volumeGlyph(v, speaker!.mute),
            )}
            cssClasses={speakerMute.as((m) =>
              m ? ["icon", "inactive"] : ["icon", "active"],
            )}
          />
        ) : (
          <label label="volume_up" cssClasses={["icon", "inactive"]} />
        )}
      </box>
    </BarItem>
  );
}
