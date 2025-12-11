Create the `web` network manually before running `docker compose` with the command `docker network create web`.

Search for `fill-me` to find all the passwords and sensitive data that need to be set.

## Nextcloud
In Nextcloud's `config.php` file add this options:
```php
'check_data_directory_permissions' => false
```
