{ inputs, ... }:

/*   Nixpkgs branches   */

/*  Allows for specifying which branches to take packages from.
 	*  
 	* The branches can be accessed like so:
 	* 'pkgs.master.srb2kart'
 	* 'pkgs.stable.linuxKernel.kernels.linux_6_0'
 	*/

final: prev:
with inputs; let inherit (final) system; in
{
  unstable = import unstable { inherit system; config = { allowUnfree = true; }; };
  stable = import stable { inherit system; config = { allowUnfree = true; }; };
  master = import master { inherit system; config = { allowUnfree = true; }; };
}
