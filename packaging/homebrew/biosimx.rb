class Biosimx < Formula
  desc "Deterministic C++ biosimulation engine"
  homepage "https://example.org/biosimx"
  url "https://github.com/ORG/BioSimX/releases/download/v1.0.0/biosimx-macos-universal.tar.gz"
  sha256 "REPLACE_WITH_REAL_SHA256"
  license "MIT"

  def install
    bin.install "biosimx"
  end

  test do
    system "#{
      '<built-in function bin>/' + cli
    }", "--help"
  end
end
