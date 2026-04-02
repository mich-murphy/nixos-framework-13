{...}: {
  security.sudo.execWheelOnly = true;

  boot.kernel.sysctl = {
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
  };

  programs.ssh.startAgent = true;
}
