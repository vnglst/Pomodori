cask "pomodori" do
  version "1.0.0"
  sha256 "f3f7233947a1304108d7bebd1530ebe5f447ce456ed5220028fcb763a7ee6530"

  url "https://github.com/vnglst/Pomodori/releases/download/v#{version}/Pomodori-#{version}.zip"
  name "Pomodori"
  desc "Minimal menu bar Pomodoro timer"
  homepage "https://github.com/vnglst/Pomodori"

  depends_on arch: :arm64
  depends_on macos: :monterey

  app "Pomodori.app"

  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Pomodori.app"],
        base:           :appdir,
        writable_paths: ["Pomodori.app"],
        writable_base:  :appdir
  end

  uninstall quit: "com.yourname.pomodori"
end
