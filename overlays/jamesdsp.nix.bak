{ inputs, ... }:

# JamesDSP broken on upstream Nixpkgs as of writing
# temporary fix from https://github.com/NixOS/nixpkgs/issues/389609#issuecomment-2726424009

final: prev: {
  # https://github.com/wwmm/easyeffects/commit/38bef46bffdb535e2a70c3332719c557ff577e56
  jamesdsp = prev.jamesdsp.overrideAttrs {
    patchPhase = ''
      substituteInPlace src/audio/pipewire/PwPipelineManager.cpp \
        --replace-fail "pw_node_add_listener" "pw_proxy_add_object_listener" \
        --replace-fail "pw_link_add_listener" "pw_proxy_add_object_listener" \
        --replace-fail "pw_module_add_listener" "pw_proxy_add_object_listener" \
        --replace-fail "pw_client_add_listener" "pw_proxy_add_object_listener" \
        --replace-fail "pw_device_add_listener" "pw_proxy_add_object_listener"
    '';
  };
}
