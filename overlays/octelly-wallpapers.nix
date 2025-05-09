{ inputs, ... }:


final: prev:
let
  wallhaven = { id, ext, sha256 }: builtins.fetchurl {
    inherit sha256;
    url = "https://w.wallhaven.cc/full/${builtins.substring 0 2 id}/wallhaven-${id}.${ext}";
  };

  putTogether = { name, srcs }: prev.stdenv.mkDerivation {
    inherit name srcs;

    dontUnpack = true;
    dontPatch = true;
    dontConfigure = true;

    buildPhase = ''
      mkdir -p $out
      cp -r $srcs $out
    '';

    dontInstall = true;
    dontFixup = true;
  };
in
{
  octelly-wallpapers = (putTogether {
    name = "octelly-wallpapers";
    srcs = [
      ./by.sau.avif
      (wallhaven {
        id = "d6wp7m";
        ext = "png";
        sha256 = "1py2xk1vxpz042g4n77989kl5836mib4syyriq3a74kv7rykbs44";
      })
      (wallhaven {
        id = "exzdxw";
        ext = "jpg";
        sha256 = "0f8ggw94mwh6il78y9gqj6yj33vkjsmyrhhilhwibi1cnzx93246";
      })
      (wallhaven {
        id = "6dj6vl";
        ext = "jpg";
        sha256 = "008sjgzhb5n9zzdxs6i8xs2kc2qjpi9dw0qlvd4f74c262iggdfc";
      })
      (wallhaven {
        id = "85pdp2";
        ext = "jpg";
        sha256 = "1wnfxgq0y1q5why0nrjxryji407b7l9fpmwjr2mq9l311b809v0l";
      })
      (wallhaven {
        id = "kxoqx6";
        ext = "jpg";
        sha256 = "11z5nvydyhrldv55m2jx4s8736hljyc4bq0b6vdc3d5fql6ipinm";
      })
      (wallhaven {
        id = "d6rj3l";
        ext = "jpg";
        sha256 = "08ripb7x35pvpn4xczn7hm1rggqahvbiy6mx70xcbnn3qjwgvsnx";
      })
      (wallhaven {
        id = "o5vmjl";
        ext = "jpg";
        sha256 = "18m8c6qqvyv6z1xzp7g345izy2q3vzf6y5f1mgfwp16121z43sai";
      })
      (wallhaven {
        id = "m3rm11";
        ext = "png";
        sha256 = "1ba24clw6r4g5qfci9g44i8lipnz5bsx2ndnhc5g85hxyqhnn1nr";
      })
      (wallhaven {
        id = "yxe85x";
        ext = "jpg";
        sha256 = "0lvg9xbifj7bv3fy7qrqcnxq8b957wb59hhqg38mj6ywz2vavxng";
      })
      #(wallhaven {
      #  id = "3l6ll9";
      #  ext = "jpg";
      #  sha256 = "0r0xk737jqbw4n0hpc3y9ckdsgy19flbd6j5j9wknygkfzsvlfa5";
      #})
      (wallhaven {
        id = "x8kkd3";
        ext = "jpg";
        sha256 = "04n49hi15nr11iklvmcn6461a2qa30qhvhqdhzc5kywzbhvyrikl";
      })
      (wallhaven {
        id = "z8o1og";
        ext = "jpg";
        sha256 = "0k02j7f1f8sxg3ali8s2hr3r8864ssq1i90jimk0as34ffvsjwn0";
      })
      #(wallhaven {
      #  id = "zyv5qj";
      #  ext = "jpg";
      #  sha256 = "0jy8lhb9a29w55f96rjj5pzbcfhqy7gb9i1i8za9imgyvvn5nirr";
      #})
      (wallhaven {
        id = "yxr83d";
        ext = "jpg";
        sha256 = "03nk3savqylsc38j5cynb4prjrjbzi7pl06yly51sm0h30i8zjwi";
      })
      #(wallhaven {
      #  id = "1pok23";
      #  ext = "jpg";
      #  sha256 = "0qiynj9hc4mdcs3a6s19vqr5ajx7yrp01nimkvclshh5l7ss9n8j";
      #})
      (wallhaven {
        id = "l8r6oy";
        ext = "jpg";
        sha256 = "10zraaxj781wgaz3aa7xvlrg8sjsbllkkgcpl0qksk4q7j349dxs";
      })
      (wallhaven {
        id = "5gj8w9";
        ext = "png";
        sha256 = "0v64sb41lpks148acq1s3k0y24vp2qim1wkqxah4rxq5lqzjsk42";
      })
      (wallhaven {
        id = "x6ojqd";
        ext = "jpg";
        sha256 = "0qrby4fvicy9hys0jpd0zwvfdz20hmw2ahssm464kqgg1mni6rkm";
      })
      (wallhaven {
        id = "p91pjm";
        ext = "jpg";
        sha256 = "0izpvcifawl251j3iprm2g0g4zl8x7rv83q0x9naggf1vbr7h2f0";
      })
      (wallhaven {
        id = "jxrkmm";
        ext = "jpg";
        sha256 = "1la4prcisir2b9gfj5x173mkc3c0z3zm0755vglp7x7svl3kllsb";
      })
    ];
  });
}
