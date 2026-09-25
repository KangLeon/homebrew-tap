class Mellowclean < Formula
  desc "Calm, transparent Mac cleaner with a native window and CLI"
  homepage "https://github.com/KangLeon/MellowClean"
  url "https://github.com/KangLeon/MellowClean/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "1f1152edf25c7ac6033039ab576414e666528ba031706dc37933938ac4e5463c"
  license "MIT"

  depends_on macos: :ventura

  def install
    # Homebrew already isolates the build; nested Swift sandboxing is unsupported.
    system "bash", "scripts/build.sh", "--disable-sandbox", "--build-system", "native"
    prefix.install "dist/MellowClean.app"
    bin.install "dist/bin/mellowclean"
  end

  def caveats
    <<~EOS
      Run `mellowclean` to open the native app, or `mellowclean scan` for a read-only scan.
      Cleanup defaults to Trash. Empty Trash in Finder to reclaim space.
      Requires Swift 5.9+ (Xcode Command Line Tools 15+). No sudo required.
    EOS
  end

  test do
    assert_equal "0.3.0", shell_output("#{bin}/mellowclean --version").strip
    assert_match "MellowClean", shell_output("#{bin}/mellowclean --help")
    assert_path_exists prefix/"MellowClean.app/Contents/MacOS/MellowClean"
    assert_path_exists prefix/"MellowClean.app/Contents/Resources/AppIcon.icns"
  end
end
