class Traecnclaw < Formula
  desc "Local-first MCP server and Agent Skill for TraeCN desktop automation"
  homepage "https://github.com/Luckycat133/traecnclaw-mcp-skill"
  url "https://github.com/Luckycat133/traecnclaw-mcp-skill/releases/download/v0.5.8/traecnclaw-0.5.8.tgz"
  sha256 "c34851d19205e1ca8be6da542b5401a24e29ffb6d92206b3ce64e0652c836ae0"
  license "MIT"

  depends_on "node" => [:build, :run]

  def install
    (libexec/"lib").install Dir["*"]
    cd libexec/"lib" do
      system Formula["node"].opt_bin/"npm", "install", "--omit=dev", "--ignore-scripts",
             "--no-audit", "--no-fund"
    end

    (bin/"traecnclaw-mcp").write_env_script(
      libexec/"lib/mcp-server.js",
      PATH: "#{Formula["node"].opt_bin}:/usr/bin:/bin:/usr/sbin:/sbin"
    )
    chmod 0755, bin/"traecnclaw-mcp"

    (bin/"traecnclaw").write_env_script(
      libexec/"lib/scripts/traecn-cli.js",
      PATH: "#{Formula["node"].opt_bin}:/usr/bin:/bin:/usr/sbin:/sbin"
    )
    chmod 0755, bin/"traecnclaw"
  end

  def caveats
    <<~EOS
      TRAECNclaw drives the TraeCN desktop IDE on this Mac through its local
      gateway. Start the gateway and follow first-use setup with:

        traecn help
        traecn quickstart

      MCP clients connect to the stdio server at:
        #{opt_bin}/traecnclaw-mcp
    EOS
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/traecnclaw help")
  end
end
