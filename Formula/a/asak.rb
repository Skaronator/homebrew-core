class Asak < Formula
  desc "Cross-platform audio recording/playback CLI tool with TUI"
  homepage "https://github.com/chaosprint/asak"
  url "https://github.com/chaosprint/asak/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "dd18f4c777bdba30a87ff4c2d3062ed6a15b8f4ed44f9a19d24fd3896c65aea6"
  license "MIT"
  head "https://github.com/chaosprint/asak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d34a5b7cee6dcd07bb4d38e93b676203c68fdae4d1cc5e5b5b6426a1acc2d4ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53e25ce893336480ddf387172c204c5e0cbdbf6667192b848de067f8b3884eeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b77b36ae1bcd6c4297fe40350db70f69228cdbc5c86f2fd8099d942ffd9f6951"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8e422a1c9c71946ad6457ab745d0880ef685d2de977e30bf2c7a8ceb6acc880"
    sha256 cellar: :any_skip_relocation, ventura:       "31af89a6fd325f425aae104043edb6bf34d04b20a2b60a8ab8445f4cf777100f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7121900080e4d2c358a3a3f60ade6c11190d3e17e7d5423780f1d91d8384f277"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "jack"

  on_linux do
    depends_on "alsa-lib"
  end

  # release version patch, upstream pr ref, https://github.com/chaosprint/asak/pull/24
  patch do
    url "https://github.com/chaosprint/asak/commit/303c9b916cb339e4371a682cb37b7cdc72fa023c.patch?full_index=1"
    sha256 "e0afa58db64adc57c606aaa0846b7c766a121100e5e574e9a7c4578be439a7c5"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/asak.bash" => "asak"
    fish_completion.install "target/completions/asak.fish" => "asak"
    zsh_completion.install "target/completions/_asak" => "_asak"
    man1.install "target/man/asak.1"
  end

  test do
    output = shell_output("#{bin}/asak play")
    assert_match "No wav files found in current directory", output

    assert_match version.to_s, shell_output("#{bin}/asak --version")
  end
end
