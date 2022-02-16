# fail2bot

When `fail2ban` bans an IP, `fail2bot` sends a message to a [Matrix](https://matrix.org) room.

# Usage

Create a matrix user to be the bot. :robot-face:

## Local Testing

```shell
cp example_fail2bot.toml fail2bot.toml

./fail2ban --name <name> --ban-time <bantime>  --ip <ip>
```

## Ser
```shell
# Copy provided config to action directory
cp fail2bot.conf /etc/fail2bot/action.d/fail2bot.conf

# Add action to jail definition
echo "action = fail2bot" >> /etc/fail2ban/jail.d/example_jail.conf

# Restart|reload fail2ban
systemctl reload fail2ban
```