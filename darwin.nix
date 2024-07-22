{ config, pkgs, ... }@args:

let 
  username = args.specialArgs.username;
in
{
  services.nix-daemon.enable = true;

  # zsh is the default shell on Mac and we want to make sure that we're
  # configuring the rc correctly with nix-darwin paths.
  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
    '';

  environment.shells = with pkgs; [ bashInteractive zsh ];
  homebrew = {
    enable = true;
    casks  = [
      "arc"
      "cameracontroller"
      "google-japanese-ime"
      "meetingbar"
      "monitorcontrol"
      "logseq"
      "karabiner-elements"
      "keybase"
      "raycast"
      "scroll-reverser"
      "spotify"
      "todoist"
    ];
    masApps = {};
    onActivation = {
      cleanup = "zap";
    };
  };
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };
  time.timeZone = "Asia/Tokyo";
  system = {
    stateVersion = 4;
    defaults = {
      LaunchServices.LSQuarantine = false;
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleMeasurementUnits = "Centimeters";
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "WhenScrolling";
        AppleTemperatureUnit = "Celsius";
        InitialKeyRepeat = 15;
        KeyRepeat = 1;
        NSWindowResizeTime = 0.001;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.trackpad.enableSecondaryClick" = true;
      };
      dock = {
        autohide = false;
        show-recents = false;
        launchanim = true;
        mouse-over-hilite-stack = true;
        orientation = "left";
        tilesize = 48;
        largesize = 80;
        magnification = true;
        persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/Slack.app"
          "/Applications/Spotify.app"
        ];
      };
      finder = {
        _FXShowPosixPathInTitle = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
