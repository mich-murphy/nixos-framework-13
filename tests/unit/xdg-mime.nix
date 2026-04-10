{
  pkgs,
  evalConfig,
}: let
  mime = evalConfig.homeConfig.xdg.mimeApps.defaultApplications;
  helpers = evalConfig.assertHelpers;
  check = "unit-xdg-mime";
  fix = "modules/home/xdg.nix";
in
  pkgs.runCommand check {} ''
    source ${helpers}

    # --- MIME default applications ---
    assert_equals "${check}" "${toString mime."text/html"}" "firefox.desktop" \
      "text/html opens with firefox" "${fix}"
    assert_equals "${check}" "${toString mime."application/pdf"}" "org.pwmt.zathura.desktop" \
      "application/pdf opens with zathura" "${fix}"
    assert_equals "${check}" "${toString mime."image/png"}" "gimp.desktop" \
      "image/png opens with gimp" "${fix}"
    assert_equals "${check}" "${toString mime."video/mp4"}" "mpv.desktop" \
      "video/mp4 opens with mpv" "${fix}"
    assert_equals "${check}" "${toString mime."inode/directory"}" "org.kde.dolphin.desktop" \
      "inode/directory opens with dolphin" "${fix}"

    echo ""
    echo "All ${check} assertions passed."
    touch $out
  ''
