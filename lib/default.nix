{lib, namespace, inputs}: {
  homes = self : builtins.filter (x: lib.hasSuffix "@${namespace} x") (lib.attrNames self.homeConfigurations);
}