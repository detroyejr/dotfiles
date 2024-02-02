final: prev: {
  arrow-cpp = prev.arrow-cpp.overrideAttrs (finalAttrs: oldAttrs: {
    ARROW_TEST_DATA = prev.lib.optionalString finalAttrs.doInstallCheck "${prev.fetchFromGitHub {
    name = "arrow-testing";
    owner = "apache";
    repo = "arrow-testing";
    rev = "ad82a736c170e97b7c8c035ebd8a801c17eec170";
    hash = "sha256-wN0dam0ZXOAJ+D8bGDMhsdaV3llI9LsiCXwqW9mR3gQ=";
  }}/data";
    PARQUET_TEST_DATA = prev.lib.optionalString finalAttrs.doInstallCheck "${prev.fetchFromGitHub {
    name = "parquet-testing";
    owner = "apache";
    repo = "parquet-testing";
    rev = "d69d979223e883faef9dc6fe3cf573087243c28a";
    hash = "sha256-CUckfNjfDW05crWigzMP5b9UynviXKGZUlIr754OoGU=";
  }}/data";
  });
  python310Packages = prev.python310Packages.override (old: {
    moto = old.moto.overrideAttrs (oldAttrs: {
      pytestFlagsArray = oldAttrs.pytestFlagsArray ++ [
        "--deselect=tests/test_core/test_ec2_vpc_endpoint_services.py::test_describe_vpc_endpoint_services_bad_args"
        "--deselect=tests/test_core/test_ec2_vpc_endpoint_services.py::test_describe_vpc_default_endpoint_services"
      ];
    });
  });
}
