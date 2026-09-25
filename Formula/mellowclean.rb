class Mellowclean < Formula
  desc "Calm, transparent Mac cleaner with a native window and CLI"
  homepage "https://github.com/KangLeon/MellowClean"
  url "https://github.com/KangLeon/MellowClean/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "b1c29fe01f5f2c732163d57277106afa8028c5eca7760256fcfd788740f5b1d0"
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
    assert_equal "0.2.1", shell_output("#{bin}/mellowclean --version").strip
    assert_match "MellowClean", shell_output("#{bin}/mellowclean --help")
    assert_path_exists prefix/"MellowClean.app/Contents/MacOS/MellowClean"
    assert_path_exists prefix/"MellowClean.app/Contents/Resources/AppIcon.icns"
  end
end
