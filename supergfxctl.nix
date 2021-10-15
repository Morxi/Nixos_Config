{ pkgs
, config
, lib
, stdenv
, buildRustCrate
, defaultCrateOverrides
, fetchFromGitHub
, features ? [ ]
}:
with lib;
let 
version = "0.2.4";
  src = builtins.fetchGit {
  url = "https://e.coding.net/morxi/nixpkgs/supergfxctl.git";
  rev = "2c22e6714aba275385cf2bce5f77dddaacc03a8e";
  ref = "refs/heads/main";
  };
  customBuildRustCrateForPkgs = pkgs: buildRustCrate.override {
    defaultCrateOverrides = defaultCrateOverrides // {
      supergfxctl = attrs: {
        src = "${src}";
      };
    };
  };
  cargo_nix = import ./Cargo.nix {
    inherit pkgs;
    buildRustCrateForPkgs = customBuildRustCrateForPkgs;
  };
  supergfxctl_bin = cargo_nix.workspaceMembers."supergfxctl".build.override {
    inherit features;
  };

in
{
  
supergfx = stdenv.mkDerivation {
  pname = "supergfxctl";
  inherit version src;
  dontBuild = true;
  installPhase = ''
  mkdir -p "$out/etc/systemd/system/"

  mkdir -p "$out/etc/systemd/system-preset/"
	mkdir -p "$out/share/dbus-1/system.d/"
	mkdir -p "$out/share/X11/xorg.conf.d/"
	mkdir -p "$out/udev/rules.d/"
  cp -r ${supergfxctl_bin}/bin $out/

	cp "${src}/data/supergfxd.service" "$out/etc/systemd/system/"
	cp "${src}/data/supergfxd.preset" "$out/etc/systemd/system-preset/"
	cp "${src}/data/org.supergfxctl.Daemon.conf" "$out/share/dbus-1/system.d/"
	cp "${src}/data/90-nvidia-screen-G05.conf" "$out/share/X11/xorg.conf.d/"
	cp "${src}/data/90-supergfxd-nvidia-pm.rules" "$out/udev/rules.d/"  '';
  dontCheck = true;
  dontFixup = true;
  meta = with lib; {
    description = "ASUS Laptop Graphics Switching tool ";
    homepage = https://docs.supergfxctl.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ moxi ];
    platforms = [ "x86_64-linux" ];
  };
};

}