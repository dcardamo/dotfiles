# Claude AI Integration in Neovim

## Setup Instructions

Avante.nvim requires an API key to use Claude. With your Claude Max subscription, you can get API access.

### Getting Your API Key

1. **Log in to your Anthropic Console**:
   - Go to https://console.anthropic.com/
   - Sign in with your Claude account

2. **Create an API Key**:
   - Navigate to "API Keys" section
   - Click "Create Key"
   - Copy the key (it starts with `sk-ant-api...`)

3. **Set up the API Key** (choose one method):

   **Option 1: Environment Variable (Recommended)**
   ```bash
   # Add to your ~/.zshrc or shell config
   export ANTHROPIC_API_KEY="sk-ant-api..."
   ```

   **Option 2: Secure File**
   ```bash
   mkdir -p ~/.config/claude
   echo "sk-ant-api..." > ~/.config/claude/api_key
   chmod 600 ~/.config/claude/api_key
   ```
   Then update the config to use: `api_key_name = "cmd:cat ~/.config/claude/api_key"`

   **Option 3: Password Manager**
   If you use 1Password, Bitwarden, etc., update the config accordingly.

4. **Apply the configuration**:
   ```bash
   make update
   ```

### Using Claude in Neovim

#### Basic Commands
- `<Space>aa` - Ask Claude a question (works in normal and visual mode)
- `<Space>ae` - Edit selected code with Claude (visual mode only)
- `<Space>ar` - Refresh the current conversation
- `<Space>at` - Toggle the Claude sidebar
- `<Space>af` - Focus on the Claude window
- `<Space>ac` - Clear the conversation

#### Model Switching
- `<Space>ams` - Switch to Sonnet 4
- `<Space>amo` - Switch to Opus 4

### Features

1. **Code Understanding**: Select code and ask Claude to explain it
2. **Code Generation**: Ask Claude to generate code snippets
3. **Code Refactoring**: Select code and ask Claude to refactor it
4. **Documentation**: Ask Claude to write documentation for your code
5. **Debugging Help**: Paste error messages and get help debugging

### Tips

1. **Visual Mode**: Select code before pressing `<Space>aa` to include it in your question
2. **Context**: Claude can see the current file and selected text
3. **Model Selection**: 
   - **Opus 4** ($15/$75 per M tokens) - Best for complex tasks, long-running agent workflows, can work independently for up to 7 hours
   - **Sonnet 4** ($3/$15 per M tokens) - Excellent for coding and reasoning, more cost-effective for general use
4. **Session Persistence**: Your conversation history is maintained per project

### Troubleshooting

If browser auth isn't working:
1. Make sure you're logged into Claude in your default browser
2. Try clearing Neovim's Claude session: `:lua require("avante").clear_session()`
3. Check if your browser is blocking popups

### Claude 4 Model Information

The Claude 4 models are now available:

- **Claude Opus 4** (`claude-opus-4-20250514`): 
  - The world's best coding model
  - 72.5% on SWE-bench, 43.2% on Terminal-bench
  - Designed for complex, long-horizon tasks
  - Can work independently for up to 7 hours
  
- **Claude Sonnet 4** (`claude-sonnet-4-20250514`):
  - Superior coding and reasoning capabilities
  - 72.7% on SWE-bench
  - More cost-effective than Opus 4
  - Responds more precisely to instructions

Both models support extended thinking mode and can use tools like web search during reasoning.