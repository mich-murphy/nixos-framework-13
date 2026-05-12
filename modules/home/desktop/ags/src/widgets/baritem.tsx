import { Gtk } from "ags/gtk4";

type Props = {
  onClicked?: () => void;
  cssClasses?: string[];
  children?: any;
};

export default function BarItem({ onClicked, cssClasses, children }: Props) {
  if (onClicked) {
    return (
      <button
        cssName="baritem"
        cssClasses={cssClasses}
        onClicked={onClicked}
      >
        {children}
      </button>
    );
  }
  return (
    <box cssName="baritem" cssClasses={cssClasses}>
      {children}
    </box>
  );
}
