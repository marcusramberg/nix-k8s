{
  description = "K8s nixhelm experiments";
  inputs = { 
    nixhelm.url = "github:farcaller/nixhelm";
    kubegen.url = "github:farcaller/nix-kube-generators";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 
  };

  outputs = { self, nixpkgs, nixhelm, kubegen }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux.pkgs;
      kubelib = kubegen.lib { inherit pkgs; };
    in {
      argo-res = (kubelib.buildHelmChart {
        name = "argo";
        chart = (nixhelm.charts { inherit pkgs; }).argoproj.argo-cd;
        namespace = "argo";
      });
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "k8s-shell";
        buildInputs = with pkgs; [
         minikube
         kubernetes-helm
        ];
      };
    };
}
