class Traecnclaw < Formula
  desc "Local-first MCP server and Agent Skill for TraeCN desktop automation"
  homepage "https://github.com/Luckycat133/traecnclaw-mcp-skill"
  url "https://github.com/Luckycat133/traecnclaw-mcp-skill/releases/download/v0.5.7/traecnclaw-0.5.7.tgz"
  sha256 "4d664e6426175e5e5404ec748b4ea7ed45602edb6b9752cbc48ee7edea68f31f"
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
    assert_match "USAGE", shell_output("#{bin}/traecn help")
  end
end
