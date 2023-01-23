{ inputs, ... }:

/*   Nixpkgs branches   */

/*  Allows for specifying which branches to take packages from.
 *  
 * The branches can be accessed like so:
 * 'pkgs.master.srb2kart'
 * 'pkgs.stable.linuxKernel.kernels.linux_6_0'
 */ 

final: prev:
with inputs; let system = final.system; in
{
	unstable = import unstable { inherit config system; };
	stable   = import stable   { inherit config system; };
	master   = import master   { inherit config system; };
}
