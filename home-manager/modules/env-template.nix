{ ... }:
{
  # Create .env.template file in home directory
  home.file.".env.template".text = ''
    # This file contains secrets
    # Copy this to ~/.env and fill in your actual values
    # Make sure to: chmod 600 ~/.env

    # Anthropic API key for Claude AI integration
    ANTHROPIC_API_KEY=sk-ant-api...

    # Google Gemini API Key: https://aistudio.google.com/apikey
    GEMINI_API_KEY="YOUR_API_KEY"

    # Add other secrets below as needed
  '';
}
