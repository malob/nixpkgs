{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption optionalString types;

  cfg = config.programs.neovim.extras;
  nvr = "${pkgs.neovim-remote}/bin/nvr";

  shellConfig = with cfg.nvrAliases; ''
    # START programs.neovim.extras config ----------------------------------------------------------

  '' + optionalString cfg.termBufferAutoChangeDir ''
    # If shell is running in a Neovim terminal buffer, set the PWD of the buffer to `$PWD`.
    if test -n "$NVIM"; nvim-sync-term-buffer-pwd; end

  '' + optionalString cfg.nvrAliases.enable ''
    # Neovim Remote aliases
    if test -n "$NVIM"
      alias ${edit} "${nvr}"
      alias ${split} "${nvr} -o"
      alias ${vsplit} "${nvr} -O"
      alias ${tabedit} "${nvr} --remote-tab"
      alias ${nvim} "command nvim"
      alias nvim "echo 'This shell is running in a Neovim termainal buffer. Use \'${nvim}\' to a nested instance of Neovim, otherwise use ${edit}, ${split}, ${vsplit}, or ${tabedit} to open files in the this Neovim instance.'"
    else
      alias ${edit} "nvim"
    end

  '' + ''
    # END programs.neovim.extras config ------------------------------------------------------------
  '';
in
{
  options.programs.neovim.extras = {
    termBufferAutoChangeDir = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, the <literal>pwd</literal> of terminal buffers in Neovim are automatically
        updated to match <literal>$PWD</literal> of the shell running inside them.

        Note that you cannot use this option if you are using
        <option>programs.neovim.configure</option>, use <option>programs.neovim.extraConfig</option>
        and <option>programs.neovim.plugins</option> instead.

        (Currently only works with Fish shell.)
      '';
    };

    nvrAliases = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          When enabled, shell aliases for helpful Neovim Remote commands are created if the shell is
          running inside a Neovim terminal buffer. Additionally, running <command>nvim</command>
          won't open a nested Neovim instance but instead print a message listing the available
          <command>nvr</command> aliases, as well as the command to run if you actually want to open
          a nested Neovim instance.

          Note that you cannot use this option if you are using
          <option>programs.neovim.configure</option>, use
          <option>programs.neovim.extraConfig</option> and <option>programs.neovim.plugins</option>
          instead.

          (Currently only works with Fish shell.)
        '';
      };

      edit = mkOption {
        type = types.str;
        default = "n";
        description = ''
          Equivalent to Neovim's <command>:edit</command> command, i.e., running
          <command>n [file]</command> will open the file in the current window.

          When not in Neovim this also acts as an alias for <command>nvim</command>.

          (Alias for <command>nvr</command>.)
        '';
      };

      split = mkOption {
        type = types.str;
        default = "ns";
        description = ''
          Equivalent to Neovim's <command>:split/command> command.

          (Alias for <command>nvr -o</command>.)
        '';
      };

      vsplit = mkOption {
        type = types.str;
        default = "nv";
        description = ''
          Equivalent to Neovim's <command>:vsplit/command> command.

          (Alias for <command>nvr -O</command>.)
        '';
      };

      tabedit = mkOption {
        type = types.str;
        default = "nt";
        description = ''
          Equivalent to Neovim's <command>:tabedit</command> command.

          (Alias for <command>nvr --remote-tab</command>.)
        '';
      };

      nvim = mkOption {
        type = types.str;
        default = "neovim";
        description = ''
          Opens a nested Neovim instance.
        '';
      };
    };

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, the <literal>EDITOR</literal> and <literal>VISUAL</literal> environment
        variable are set to <command>nvr --remote-wait-silent</command>, and
        <command>${nvr} -cc split --remote-wait +'set bufhidden=delete'</command> if the shell is
        running inside a Neovim.
      '';
    };
  };

  config = mkIf config.programs.neovim.enable {
    home.sessionVariables = mkIf cfg.defaultEditor {
      EDITOR = "${nvr} --remote-wait-silent";
      VISUAL = "${nvr} --remote-wait-silent";
    };

    programs.fish.functions.nvim-sync-term-buffer-pwd = mkIf cfg.termBufferAutoChangeDir {
      body = ''
        if test -n "$NVIM"
          ${nvr} -c "let g:term_buffer_pwds.$fish_pid = '$PWD' | call Set_term_buffer_pwd() "
        end
      '';
      onVariable = "PWD";
    };

    programs.neovim.extraConfig = mkIf (cfg.termBufferAutoChangeDir || cfg.defaultEditor) (
      optionalString cfg.termBufferAutoChangeDir ''
        " START programs.neovim.extras.termBufferAutoChangeDir config ------------------------------

        " Dictionary used to track the PWD of terminal buffers. Keys should be PIDs and values are
        " is PWD of the shell with that PID. These values are updated from the shell using `nvr`.
        let g:term_buffer_pwds = {}

        " Function to call to update the PWD of the current terminal buffer.
        function Set_term_buffer_pwd() abort
          if &buftype == 'terminal' && exists('g:term_buffer_pwds[b:terminal_job_pid]')
            execute 'lchd ' . g:term_buffer_pwds[b:terminal_job_pid]
          endif
        endfunction

        " Sometimes the PWD the shell in a terminal buffer will change when in another buffer, so
        " when entering a terminal buffer we update try to update it's PWD.
        augroup NvimTermPwd
        au!
        au BufEnter * if &buftype == 'terminal' | call Set_term_buffer_pwd() | endif
        augroup END

        " END programs.neovim.extras.termBufferAutoChangeDir config --------------------------------
      '' + optionalString cfg.defaultEditor ''
        " START programs.neovim.extras.defaultEditor config ----------------------------------------

        let $EDITOR = '${nvr} -cc split -c "set bufhidden=delete" --remote-wait'
        let $VISUAL = $EDITOR

        " END programs.neovim.extras.defaultEditor config ------------------------------------------
      ''
    );

    programs.fish.interactiveShellInit =
    	mkIf (cfg.termBufferAutoChangeDir || cfg.nvrAliases.enable) shellConfig;
  };
}
