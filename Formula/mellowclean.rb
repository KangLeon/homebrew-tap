class Mellowclean < Formula
  desc "Calm, transparent Mac cleaner with a native window and CLI"
  homepage "https://github.com/KangLeon/MellowClean"
  url "https://github.com/KangLeon/MellowClean/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "82b0903371e1050f31d4a541d36e406e3e3d1b733c9ab94d1e4881710ea63997"
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
    assert_equal "0.2.0", shell_output("#{bin}/mellowclean --version").strip
    assert_match "MellowClean", shell_output("#{bin}/mellowclean --help")
    assert_path_exists prefix/"MellowClean.app/Contents/MacOS/MellowClean"
    assert_path_exists prefix/"MellowClean.app/Contents/Resources/AppIcon.icns"
  end
end
