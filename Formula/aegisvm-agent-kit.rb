# Homebrew formula for AegisVM Agent Kit — messaging-driven LLM agent with Telegram integration.
#
# Install: brew tap xfeldman/aegisvm && brew install aegisvm-agent-kit
#
# The release workflow updates the url, sha256, and version automatically.

class AegisvmAgentKit < Formula
  desc "AegisVM Agent Kit — messaging-driven LLM agent with Telegram integration"
  homepage "https://github.com/xfeldman/aegisvm"
  url "https://github.com/xfeldman/aegisvm/releases/download/v0.4.2/aegisvm-agent-kit-v0.4.2-darwin-arm64.tar.gz"
  sha256 "b013fde5c51dc6f3f80cc00670949abdd8440101ef7b4a48d771ff899172bf07"
  version "0.4.2"
  license "Apache-2.0"

  depends_on "xfeldman/aegisvm/aegisvm"
  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "aegis-gateway"
    bin.install "aegis-agent"

    # Install kit manifest
    (prefix/"share/aegisvm/kits").mkpath
    cp "agent.json", prefix/"share/aegisvm/kits/agent.json"
  end

  def caveats
    <<~EOS
      Agent Kit installed. To use:

        # Store your API keys
        aegis secret set OPENAI_API_KEY sk-...
        aegis secret set TELEGRAM_BOT_TOKEN 123456:ABC-...

        # Start an agent instance
        aegis instance start --kit agent --name my-agent --secret OPENAI_API_KEY

        # Configure the gateway
        mkdir -p ~/.aegis/kits/my-agent
        cat > ~/.aegis/kits/my-agent/gateway.json << 'EOF'
        {"telegram":{"bot_token_secret":"TELEGRAM_BOT_TOKEN","allowed_chats":["*"]}}
        EOF

      The gateway starts automatically with the instance and picks up
      the config within seconds. See: aegis instance info my-agent
    EOS
  end

  test do
    assert_match "aegis-gateway", shell_output("ls #{bin}/aegis-gateway")
    assert_match "aegis-agent", shell_output("ls #{bin}/aegis-agent")
  end
end
