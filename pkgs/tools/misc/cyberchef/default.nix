{ lib
, fetchzip
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "cyberchef";
  version = "10.4.0";

  src = fetchzip {
    url = "https://github.com/gchq/CyberChef/releases/download/v${version}/CyberChef_v${version}.zip";
    sha256 = "sha256-BjdeOTVZUMitmInL/kE6a/aw/lH4YwKNWxdi0B51xzc=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p "$out/share/cyberchef"
    mv "CyberChef_v${version}.html" index.html
    mv * "$out/share/cyberchef"
  '';

  description = "The Cyber Swiss Army Knife for encryption, encoding, compression and data analysis.";
  desktopItem = makeDesktopItem rec {
    name = "cyberchef";
    exec = brave $out/share/cyberchef/index.html;
    icon = $out/share/cyberchef/images/cyberchef-128x128.png;
    desktopName = "CyberChef";
    comment = description;
    categories = [ "Development" "Security" "System" ];
  };

    extraInstallCommands = ''
    cp -r ${desktopItem}/share/applications $out/share
  '';

  meta = with lib; {
    description = "The Cyber Swiss Army Knife for encryption, encoding, compression and data analysis.";
    homepage = "https://gchq.github.io/CyberChef";
    changelog = "https://github.com/gchq/CyberChef/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ sebastianblunt ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
