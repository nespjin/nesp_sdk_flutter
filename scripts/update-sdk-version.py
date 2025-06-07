import logging
import sys


def update_sdk_version(version):
    old_version = None
    content = ''
    with open("pubspec.yaml", "r") as f:
        is_in_environment = False
        for line in f:
            if line.startswith("environment:"):
                is_in_environment = True
            elif line.strip().startswith("sdk:") and is_in_environment:
                old_version = line.split(":")[1].strip()
                logging.info("Updating sdk version from %s to %s",
                             old_version, version)
                line = "  sdk: " + version + "\n"
                is_in_environment = False
            content += f"{line}"

    with open("pubspec.yaml", "w") as f:
        f.write(content)


def main():
    if len(sys.argv) != 2:
        logging.error("Usage:\n %s <version>", sys.argv[0])
        sys.exit(1)
    version = sys.argv[1]
    update_sdk_version(version)


if __name__ == "__main__":
    sys.exit(main())
