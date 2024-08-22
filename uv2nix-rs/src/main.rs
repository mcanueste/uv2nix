use std::{fmt::Debug, path::PathBuf, process::ExitCode};

use anyhow::{Context, Result};
use clap::Parser;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
struct SDist {
    url: String,
    hash: String,
    size: u64,
}

#[derive(Serialize, Deserialize, Debug)]
struct Wheel {
    url: String,
    hash: String,
    size: u64,
}

#[derive(Serialize, Deserialize, Debug)]
struct Source {
    registry: Option<String>,
    editable: Option<PathBuf>,
}

#[derive(Serialize, Deserialize, Debug)]
struct Dependency {
    name: String,
    marker: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
struct Package {
    name: String,
    version: String,
    source: Option<Source>,
    sdist: Option<SDist>,
    wheels: Option<Vec<Wheel>>,
    dependencies: Option<Vec<Dependency>>,
}

#[derive(Serialize, Deserialize, Debug)]
struct LockFile {
    version: u8,

    #[serde(rename = "requires-python")]
    requires_python: String,

    #[serde(rename = "package")]
    packages: Vec<Package>,
}

#[derive(Debug)]
struct NixWheelSrc {
    url: String,
    sha256: String,
}

impl NixWheelSrc {
    fn from_wheel(wheel: &Wheel) -> Result<Self> {
        let sha = wheel.hash.strip_prefix("sha256:").ok_or_else(|| {
            anyhow::anyhow!("Failed to strip sha256 prefix from hash: {:?}", wheel.hash)
        })?;

        Ok(Self {
            url: wheel.url.clone(),
            sha256: sha.to_string(),
        })
    }

    fn to_nix_string(&self) -> String {
        format!(
            "builtins.fetchurl {{ url = \"{}\"; sha256 = \"{}\"; }}",
            self.url, self.sha256
        )
    }
}

#[derive(Debug)]
struct NixWheelPackage {
    pname: String,
    version: String,
    src: NixWheelSrc,
}

impl NixWheelPackage {
    fn from_package(pkg: &Package) -> Result<Self> {
        // TOOD: Select wheel based on arch
        let wheel = pkg
            .wheels
            .as_ref()
            .ok_or(anyhow::anyhow!("No wheels found in package: {:?}", pkg))?
            .first()
            .ok_or(anyhow::anyhow!("No wheels found in package: {:?}", pkg))?;

        let src = NixWheelSrc::from_wheel(wheel)?;

        Ok(Self {
            pname: pkg.name.clone(),
            version: pkg.version.clone(),
            src,
        })
    }

    fn to_nix_string(&self, python_version: String) -> String {
        let python_version = python_version.replace(".", "");
        let nix_pkg_builder = format!("pkgs.python{}Packages.buildPythonPackage", python_version);
        format!(
            "{} {{ pname = \"{}\"; version = \"{}\"; format = \"wheel\"; src = {}; }}",
            nix_pkg_builder,
            self.pname,
            self.version,
            self.src.to_nix_string()
        )
    }
}

fn parse_lockfile(lockfile: &PathBuf) -> Result<LockFile> {
    let lockfile_toml = std::fs::read_to_string(lockfile)
        .with_context(|| format!("Failed to read lockfile: {:?}", lockfile))?;
    log::debug!("Read lockfile. {:?}", lockfile_toml);

    let lockfile = toml::from_str(&lockfile_toml)
        .with_context(|| format!("Failed to parse lockfile: {:?}", lockfile))?;
    log::debug!("Parsed lockfile. {:?}", lockfile);

    Ok(lockfile)
}

fn convert_lockfile_to_nix(lockfile: &LockFile, python_version: &String) -> Result<String> {
    let nix_packages: Vec<NixWheelPackage> = lockfile
        .packages
        .iter()
        .filter(|pkg| pkg.wheels.is_some())
        .map(|pkg| NixWheelPackage::from_package(pkg))
        .collect::<Result<Vec<NixWheelPackage>>>()?;

    let nix_packages_str = nix_packages
        .iter()
        .map(|pkg| format!("({})", pkg.to_nix_string(python_version.to_string())))
        .collect::<Vec<String>>()
        .join("\n");

    Ok(format!("{{ pkgs }}: [ {} ]", nix_packages_str))
}

#[derive(Parser, Debug)]
#[clap(about, version)]
struct Args {
    /// Path to the uv.lock file
    lockfile: PathBuf,

    #[clap(short, long)]
    /// Python version to use. Default: "3.9".
    python_version: Option<String>,

    #[command(flatten)]
    pub verbose: clap_verbosity_flag::Verbosity,
}

fn _main() -> Result<String> {
    let args = Args::parse();
    log::debug!("Parsed arguments. {:?}", args);

    let lockfile_path = &args.lockfile;
    let python_version = &args.python_version.unwrap_or_else(|| "3.9".to_string());

    let lockfile = parse_lockfile(lockfile_path)?;
    let nix_str = convert_lockfile_to_nix(&lockfile, python_version)?;

    Ok(nix_str)
}

fn main() -> ExitCode {
    match _main() {
        Ok(out) => {
            println!("{}", out);
            ExitCode::SUCCESS
        }
        Err(e) => {
            eprintln!("Error: {:?}", e);
            ExitCode::FAILURE
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
}
