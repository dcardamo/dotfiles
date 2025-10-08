self: super: {
  clblast = super.clblast.overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or []) ++ ["-DCMAKE_POLICY_VERSION_MINIMUM=3.5"];
  });
}
