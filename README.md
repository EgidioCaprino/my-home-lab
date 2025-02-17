Create the `web` network manually before running `docker compose` with the command `docker network create web`.

In Nextcloud's `config.php` file add this options:
```php
'check_data_directory_permissions' => false
```
