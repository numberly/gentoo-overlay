# gentoo-overlay

## Manual installation
For now, this overlay is not part of layman so registration has to be done manually.

### Clone this repository:
```
$ git clone https://github.com/numberly/gentoo-overlay.git /path/to/local/clone/numberly-overlay
```
### Create `/etc/portage/repos.conf/numberly.conf`:
``` ini
[numberly]
priority = 50
location = /path/to/local/clone/numberly-overlay
sync-type = git
sync-uri = https://github.com/numberly/gentoo-overlay.git
```
### Enable overlay
Via [eselect-repository](https://packages.gentoo.org/packages/app-eselect/eselect-repository)
```
eselect repository enable numberly
```
