# pylint: disable=C0111
import yaml
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

# Load config.yml
with (config.configdir / 'config.yml').open() as f:
    yaml_data = yaml.load(f)

for k, v in yaml_data.items():
    config.set(k, v)

# Load color theme
config.source('base16-qutebrowser/themes/base16-default-dark.config.py')
