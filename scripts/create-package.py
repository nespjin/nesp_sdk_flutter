#!/usr/bin/env python3
# Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.



import logging
import os
from shutil import copyfile
import sys
import config

PACKAGE_VERSION = '0.0.1-dev.1'


def update_pubspec(pubspec_file_path):
    sdk_version = config.SDK_VERSION
    content = ''
    with open(pubspec_file_path, "r") as f:
        is_in_environment = False
        for line in f:
            if line.strip().startswith('#') or line.strip().startswith("dependencies:"):
                continue

            if line.startswith("description:"):
                line = f"description: {config.DESCRIPTION}\n"
            elif line.startswith("version:"):
                line = f"version: {PACKAGE_VERSION}\n"
                line += f"repository: {config.REPOSITORY}\n"
            elif line.startswith("environment:"):
                is_in_environment = True
            elif line.strip().startswith("sdk:") and is_in_environment:
                line = f"  sdk: {sdk_version}\n"
                # line += "\nresolution: workspace\n"
                is_in_environment = False
            content += line

    with open(pubspec_file_path, "w") as f:
        f.write(content)


def update_change_log(change_log_file_path, package_name):
    with open(change_log_file_path, "w") as f:
        f.write(f"## {PACKAGE_VERSION}\n")
        f.write(f"- The initial version for {package_name}\n")


def update_readme(readme_file_path, package_name):
    # Convert package name to title case
    title = " ".join(word.capitalize() for word in package_name.split("_"))
    with open(readme_file_path, "w") as f:
        f.write(f"# {title}\n")
        f.write(f"This is the {package_name} package.\n")


def add_license(license_file_path, package_dir_path):
    copyfile(license_file_path, f"{package_dir_path}/LICENSE")


def delete_unused_files(package_dir_path, package_name):
    example_file_path = os.path.join(
        package_dir_path, "example", f"{package_name}_example.dart")
    with open(example_file_path, "w") as f:
        f.write("")

    os.remove(os.path.join(package_dir_path, "lib",
              "src", f"{package_name}_base.dart"))

    library_file_path = os.path.join(
        package_dir_path, "lib", f"{package_name}.dart")
    with open(library_file_path, "w") as f:
        f.write(f"library {package_name};")

    test_file_path = os.path.join(
        package_dir_path, "test", f"{package_name}_test.dart")
    with open(test_file_path, "w") as f:
        f.write("")


def create_package(workspace_dir_path, packages_path, package_name):
    package_dir = os.path.join(packages_path, package_name)
    if os.path.exists(package_dir):
        logging.info("Package already exists: {}".format(package_name))
        return

    logging.info(f"Creating package {package_name}")
    if (os.system(f"flutter create -t package {package_dir}") != 0):
        logging.info(f"Failed to create package {package_name}")
        return

    update_pubspec(os.path.join(package_dir, "pubspec.yaml"))
    update_change_log(os.path.join(package_dir, "CHANGELOG.md"), package_name)
    update_readme(os.path.join(package_dir, "README.md"), package_name)
    license_file_path = os.path.join(workspace_dir_path, "LICENSE")
    add_license(license_file_path, package_dir)
    delete_unused_files(package_dir, package_name)


def main():
    arg_count = len(sys.argv)
    if arg_count == 1:
        logging.info("Usage: create-package.py <package_name ...>")
        sys.exit(1)

    package_names = sys.argv[1:]

    workspace_dir_path = os.path.realpath(__file__)
    for _ in range(3):
        workspace_dir_path = os.path.dirname(workspace_dir_path)

    packages_path = os.path.join(workspace_dir_path, "packages")
    for package_name in package_names:
        create_package(workspace_dir_path, packages_path, package_name)


if __name__ == "__main__":
    main()
