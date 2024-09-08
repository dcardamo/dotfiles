{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    escapeTime = 0;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      # tmuxPlugins.vim-tmux-navigator
    ];

    extraConfig = ''
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # Mouse works as expected
      set-option -g mouse on

      # key bindings
      set-window-option -g mode-keys vi
      set -g status-keys vi
      bind-key v split-window -h
      bind-key s split-window -v
      bind-key h split-window -v

      bind-key J resize-pane -D 5
      bind-key K resize-pane -U 5
      bind-key H resize-pane -L 5
      bind-key L resize-pane -R 5

      bind-key -r '+' resize-pane -U 10
      bind-key -r '-' resize-pane -D 10
      bind-key -r '<' resize-pane -L 10
      bind-key -r '>' resize-pane -R 10

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
      bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
      bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
      bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
      bind-key -n 'C-\' if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
      bind-key -T copy-mode-vi C-h select-pane -L
      bind-key -T copy-mode-vi C-j select-pane -D
      bind-key -T copy-mode-vi C-k select-pane -U
      bind-key -T copy-mode-vi C-l select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l


      # new window and retain cwd
      bind c new-window -c "#{pane_current_path}"

      # Rename session and window
      bind r command-prompt -I "#{window_name}" "rename-window '%%'"
      bind R command-prompt -I "#{session_name}" "rename-session '%%'"

      # Split panes
      bind | split-window -h -c "#{pane_current_path}"
      bind _ split-window -v -c "#{pane_current_path}"

      # Select pane and windows
      bind -r C-[ previous-window
      bind -r C-] next-window
      bind -r [ select-pane -t :.-
      bind -r ] select-pane -t :.+
      bind -r Tab last-window   # cycle thru MRU tabs
      bind -r C-o swap-pane -D

      # Zoom pane
      bind + resize-pane -Z

      # Kill pane/window/session shortcuts
      bind x kill-pane
      bind X kill-window
      bind C-x confirm-before -p "kill other windows? (y/n)" "kill-window -a"
      bind Q confirm-before -p "kill-session #S? (y/n)" kill-session

      # Detach from session
      bind d detach
      bind D if -F '#{session_many_attached}' \
          'confirm-before -p "Detach other clients? (y/n)" "detach -a"' \
          'display "Session has only 1 client attached"'


      # Theme
      set -g status-position top
      set -g status-justify "centre"
      set -g status "on"
      set -g status-left-style "none"
      set -g message-command-style "fg=#c6c8d1,bg=#2e3244"
      set -g status-right-style "none"
      set -g pane-active-border-style "fg=#454b68"
      set -g status-style "none,bg=#1e2132"
      set -g message-style "fg=#c6c8d1,bg=#2e3244"
      set -g pane-border-style "fg=#2e3244"
      set -g status-right-length "100"
      set -g status-left-length "100"
      setw -g window-status-activity-style "none,fg=#454b68,bg=#1e2132"
      setw -g window-status-separator ""
      setw -g window-status-style "none,fg=#c6c8d1,bg=#1e2132"
      set -g status-left "#[fg=#c6c8d1,bg=#454b68,bold] #(whoami) #[fg=#454b68,bg=#2e3244,nobold,nounderscore,noitalics]#[fg=#c6c8d1,bg=#2e3244] %R %a #[fg=#2e3244,bg=#1e2132,nobold,nounderscore,noitalics]#[fg=#c6c8d1,bg=#1e2132] #{sysstat_mem} #[fg=#1e2132,bg=#1e2132,nobold,nounderscore,noitalics]"
      set -g status-right "#[fg=#1e2132,bg=#1e2132,nobold,nounderscore,noitalics]#[fg=#c6c8d1,bg=#1e2132] #{sysstat_cpu} #[fg=#2e3244,bg=#1e2132,nobold,nounderscore,noitalics]#[fg=#c6c8d1,bg=#2e3244] #(curl icanhazip.com) #[fg=#454b68,bg=#2e3244,nobold,nounderscore,noitalics]#[fg=#c6c8d1,bg=#454b68,bold] #H #{prefix_highlight} "
      setw -g window-status-format "#[fg=#1e2132,bg=#1e2132,nobold,nounderscore,noitalics]#[fg=#c6c8d1] #I #W  #[fg=#1e2132,bg=#1e2132,nobold,nounderscore,noitalics]"
      setw -g window-status-current-format "#[fg=#1e2132,bg=#2e3244,nobold,nounderscore,noitalics]#[fg=#c6c8d1,bg=#2e3244] ✓#I #W #F #[fg=#2e3244,bg=#1e2132,nobold,nounderscore,noitalics]"
    '';
  };
}
