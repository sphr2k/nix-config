# kubeswitch: package, config, and Fish wrappers (kswitch, kns)
{
  config,
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.kubeswitch ];

  home.file.".kube/switch-config.yaml" = {
    text = ''
      kind: SwitchConfig
      version: v1alpha1
      kubeconfigStores:
      #- kind: filesystem
      #  kubeconfigName: "config"
      #  paths:
      #  - ~/.kube
      - kind: filesystem
        kubeconfigName: "*.y*ml"
        paths:
        - ~/.kube/projects/
    '';
  };

  programs.fish.functions.kswitch = {
    body = "kubeswitch $argv";
    wraps = "switcher";
  };

  programs.fish.functions.kns = {
    body = "kubeswitch ns $argv";
    wraps = "switcher";
  };
}
