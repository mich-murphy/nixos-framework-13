import { createState } from "ags";
import { interval } from "ags/time";
import GLib from "gi://GLib";

type CpuSample = { idle: number; total: number };

function readFile(path: string): string | null {
  try {
    const [ok, contents] = GLib.file_get_contents(path);
    if (!ok || !contents) return null;
    return new TextDecoder().decode(contents);
  } catch {
    return null;
  }
}

function readCpuSample(): CpuSample | null {
  const stat = readFile("/proc/stat");
  if (!stat) return null;
  const line = stat.split("\n").find((l) => l.startsWith("cpu "));
  if (!line) return null;
  const parts = line.split(/\s+/).slice(1).map((s) => parseInt(s, 10));
  if (parts.some(isNaN)) return null;
  const idle = (parts[3] ?? 0) + (parts[4] ?? 0);
  const total = parts.reduce((a, b) => a + b, 0);
  return { idle, total };
}

function readMemUsedGb(): number | null {
  const mem = readFile("/proc/meminfo");
  if (!mem) return null;
  const total = mem.match(/MemTotal:\s+(\d+)/);
  const avail = mem.match(/MemAvailable:\s+(\d+)/);
  if (!total || !avail) return null;
  const usedKb = parseInt(total[1], 10) - parseInt(avail[1], 10);
  return usedKb / 1024 / 1024;
}

function readCpuTemp(): number | null {
  const candidates = [
    "/sys/class/hwmon/hwmon0/temp1_input",
    "/sys/class/hwmon/hwmon1/temp1_input",
    "/sys/class/hwmon/hwmon2/temp1_input",
    "/sys/class/hwmon/hwmon3/temp1_input",
    "/sys/class/hwmon/hwmon4/temp1_input",
  ];
  for (const path of candidates) {
    const raw = readFile(path);
    if (raw) {
      const v = parseInt(raw.trim(), 10);
      if (!isNaN(v) && v > 0) return v / 1000;
    }
  }
  return null;
}

export default function SysStats() {
  const [text, setText] = createState("--° · --% · --G");
  let prev: CpuSample | null = readCpuSample();

  // Poll because /proc files don't have file-watch semantics worth subscribing to.
  interval(2_000, () => {
    const cur = readCpuSample();
    let cpuPct = 0;
    if (prev && cur) {
      const dIdle = cur.idle - prev.idle;
      const dTotal = cur.total - prev.total;
      cpuPct = dTotal > 0 ? Math.max(0, 100 * (1 - dIdle / dTotal)) : 0;
    }
    prev = cur;

    const temp = readCpuTemp();
    const memGb = readMemUsedGb();

    const tempStr = temp !== null ? `${Math.round(temp)}°` : "--°";
    const cpuStr = `${Math.round(cpuPct)}%`;
    const memStr = memGb !== null ? `${memGb.toFixed(1)}G` : "--G";

    setText(`${tempStr} · ${cpuStr} · ${memStr}`);
  });

  return <label cssName="sysstats-pill" label={text} />;
}
