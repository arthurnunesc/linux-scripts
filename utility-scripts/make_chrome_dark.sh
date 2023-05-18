#!/usr/bin/env sh

### RUN WITH SUDO ###

sed -i 's/^Exec=\/usr\/bin\/google-chrome-stable$/& --enable-features=WebUIDarkMode --force-dark-mode/' /usr/share/applications/google-chrome.desktop
sed -i 's/%U/--enable-features=WebUIDarkMode --force-dark-mode &/' /usr/share/applications/google-chrome.desktop
