# pylint: disable=C0111
import yaml
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

# Load config.yml
with (config.configdir / 'config.yml').open() as f:
    yaml_data = yaml.full_load(f)

for k, v in yaml_data.items():
    config.set(k, v)

config.load_autoconfig()

# Load color theme
config.source('base16-qutebrowser/themes/default/base16-default-dark.config.py')
