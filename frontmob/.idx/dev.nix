{ pkgs, ... }: {
  channel = "stable-23.11";
  packages = [
    pkgs.flutter
    pkgs.jdk17
  ];
  idx.previews = {
    enable = true;
    previews = {
      android = {
        command = [ "flutter" "-C" "frontmob" "run" "--machine" "-d" "android" "-d" "emulator-5554" ];
        manager = "flutter";
      };
    };
  };
}