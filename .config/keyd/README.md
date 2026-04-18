keyd is used to remap keys.
I use this config for linux laptop where I sometime don't use an external QMK keyboard.

The adjacent config file (~/.config/keyd/sample.conf) needs to be moved to /etc/keyd/default.conf
```
sudo mv ~/.config/keyd/sample.conf /etc/keyd/default.conf
sudo keyd reload
```

keyd install instructions can be found here: https://github.com/rvaiya/keyd
