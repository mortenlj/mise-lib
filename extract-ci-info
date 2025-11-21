#!/usr/bin/env python
# [MISE] description="Extract CI info"
# [MISE] hide=true
import json
import os
import subprocess
import sys
import tomllib
from io import StringIO


class Output:
    def __init__(self):
        output = os.getenv("GITHUB_OUTPUT")
        if output:
            self._fobj = open(output, "a")
        else:
            self._fobj = StringIO()
        self._outputs = []

    def add_output(self, name, value):
        self._outputs.append(f"{name}={json.dumps(value)}\n")

    def write(self):
        print("Creating outputs")
        for line in self._outputs:
            self._fobj.write(line)
            sys.stdout.write(line)


def load_mise():
    """Load mise.toml"""
    root = os.getenv("MISE_CONFIG_ROOT")
    mise_path = os.path.join(root, "mise.toml")
    with open(mise_path, "rb") as fobj:
        return tomllib.load(fobj)


def ci_tasks(mise_config):
    return mise_config["tasks"]["ci"]["depends"]


def run_publish(mise_config):
    if "publish" not in mise_config["tasks"]:
        print("No publish task")
        return False
    p = subprocess.run(["git", "rev-parse", "--symbolic-full-name", "HEAD"], capture_output=True, text=True)
    rev = ("".join(p.stdout)).strip()
    if "refs/heads/main" != rev:
        print(f"Not on main branch, rev is {rev!r}")
        return False
    return True


def artifacts(mise_config):
    build_config = mise_config["tasks"]["build"]
    return "\n".join(build_config.get("outputs", []))


def main():
    print("Extracting CI info")
    mise_config = load_mise()
    output = Output()
    output.add_output("ci-tasks", ci_tasks(mise_config))
    output.add_output("run-publish", run_publish(mise_config))
    output.add_output("artifacts", artifacts(mise_config))
    output.write()


if __name__ == "__main__":
    main()
