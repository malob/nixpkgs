{
  highline = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yclf57n2j3cw8144ania99h1zinf8q3f5zrhqa754j6gl95rp9d";
      type = "gem";
    };
    version = "2.0.3";
  };
  json_pure = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m0j1mfwv0mvw72kzqisb26xjl236ivqypw1741dkis7s63b8439";
      type = "gem";
    };
    version = "2.2.0";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    version = "0.20.3";
  };
  vimgolf = {
    dependencies = ["highline" "json_pure" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qp6fdycxb65ivi3szb9d9xh2cvv36bpkcw3k0a2ggg27l9afbq4";
      type = "gem";
    };
    version = "0.4.8";
  };
}