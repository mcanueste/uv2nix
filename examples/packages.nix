{pkgs}: [
  (pkgs.python39Packages.buildPythonPackage {
    pname = "click";
    version = "8.1.7";
    format = "wheel";
    src = builtins.fetchurl {
      url = "https://files.pythonhosted.org/packages/00/2e/d53fa4befbf2cfa713304affc7ca780ce4fc1fd8710527771b58311a3229/click-8.1.7-py3-none-any.whl";
      sha256 = "ae74fb96c20a0277a1d615f1e4d73c8414f5a98db8b799a7931d1582f3390c28";
    };
  })
  (pkgs.python39Packages.buildPythonPackage {
    pname = "colorama";
    version = "0.4.6";
    format = "wheel";
    src = builtins.fetchurl {
      url = "https://files.pythonhosted.org/packages/d1/d6/3965ed04c63042e047cb6a3e6ed1a63a35087b6a609aa3a15ed8ac56c221/colorama-0.4.6-py2.py3-none-any.whl";
      sha256 = "4f1d9991f5acc0ca119f9d443620b77f9d6b33703e51011c16baf57afb285fc6";
    };
  })
  (pkgs.python39Packages.buildPythonPackage {
    pname = "markdown-it-py";
    version = "3.0.0";
    format = "wheel";
    src = builtins.fetchurl {
      url = "https://files.pythonhosted.org/packages/42/d7/1ec15b46af6af88f19b8e5ffea08fa375d433c998b8a7639e76935c14f1f/markdown_it_py-3.0.0-py3-none-any.whl";
      sha256 = "355216845c60bd96232cd8d8c40e8f9765cc86f46880e43a8fd22dc1a1a8cab1";
    };
  })
  (pkgs.python39Packages.buildPythonPackage {
    pname = "mdurl";
    version = "0.1.2";
    format = "wheel";
    src = builtins.fetchurl {
      url = "https://files.pythonhosted.org/packages/b3/38/89ba8ad64ae25be8de66a6d463314cf1eb366222074cfda9ee839c56a4b4/mdurl-0.1.2-py3-none-any.whl";
      sha256 = "84008a41e51615a49fc9966191ff91509e3c40b939176e643fd50a5c2196b8f8";
    };
  })
  (pkgs.python39Packages.buildPythonPackage {
    pname = "pygments";
    version = "2.18.0";
    format = "wheel";
    src = builtins.fetchurl {
      url = "https://files.pythonhosted.org/packages/f7/3f/01c8b82017c199075f8f788d0d906b9ffbbc5a47dc9918a945e13d5a2bda/pygments-2.18.0-py3-none-any.whl";
      sha256 = "b8e6aca0523f3ab76fee51799c488e38782ac06eafcf95e7ba832985c8e7b13a";
    };
  })
  (pkgs.python39Packages.buildPythonPackage {
    pname = "rich";
    version = "13.7.1";
    format = "wheel";
    src = builtins.fetchurl {
      url = "https://files.pythonhosted.org/packages/87/67/a37f6214d0e9fe57f6ae54b2956d550ca8365857f42a1ce0392bb21d9410/rich-13.7.1-py3-none-any.whl";
      sha256 = "4edbae314f59eb482f54e9e30bf00d33350aaa94f4bfcd4e9e3110e64d0d7222";
    };
  })
  (pkgs.python39Packages.buildPythonPackage {
    pname = "shellingham";
    version = "1.5.4";
    format = "wheel";
    src = builtins.fetchurl {
      url = "https://files.pythonhosted.org/packages/e0/f9/0595336914c5619e5f28a1fb793285925a8cd4b432c9da0a987836c7f822/shellingham-1.5.4-py2.py3-none-any.whl";
      sha256 = "7ecfff8f2fd72616f7481040475a65b2bf8af90a56c89140852d1120324e8686";
    };
  })
  (pkgs.python39Packages.buildPythonPackage {
    pname = "typer";
    version = "0.12.4";
    format = "wheel";
    src = builtins.fetchurl {
      url = "https://files.pythonhosted.org/packages/ae/cc/15083dcde1252a663398b1b2a173637a3ec65adadfb95137dc95df1e6adc/typer-0.12.4-py3-none-any.whl";
      sha256 = "819aa03699f438397e876aa12b0d63766864ecba1b579092cc9fe35d886e34b6";
    };
  })
  (pkgs.python39Packages.buildPythonPackage {
    pname = "typing-extensions";
    version = "4.12.2";
    format = "wheel";
    src = builtins.fetchurl {
      url = "https://files.pythonhosted.org/packages/26/9f/ad63fc0248c5379346306f8668cda6e2e2e9c95e01216d2b8ffd9ff037d0/typing_extensions-4.12.2-py3-none-any.whl";
      sha256 = "04e5ca0351e0f3f85c6853954072df659d0d13fac324d0072316b67d7794700d";
    };
  })
]
