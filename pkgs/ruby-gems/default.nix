{ bundlerApp }:
{
  vimgolf = bundlerApp {
    pname = "vimgolf";
    gemdir = ./.;
    exes = [ "vimgolf" ];
  };
}
