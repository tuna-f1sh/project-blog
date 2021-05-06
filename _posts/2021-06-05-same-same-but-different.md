---
title: Same Same but Different
date: 2021/05/06
---

I've migrated this blog from Wordpress to Jekyll. Wordpress worked but since I write everything in Markdown before posting it, Jekyll fits into my workflow better. Wordpress become overkill and slow or my needs; it's not really designed for power users and I didn't use most the features.  In addition, Wordpress required plug-ins like Jetpack in order to prevent an overwhelming amount of SPAM and I didn't like having an external analytics tool harvesting data [^1]. I'm a proponent of just not having tracking cookies rather than cookie banners that everyone hates - [it's an easy and intended solution](https://github.blog/2020-12-17-no-cookie-for-you/).

[^1]:I didn't have the time nor inclination to dig into exactly what, but if it's free...

On a similar note, I opted not to include or support comments in the migration. Whilst I have enjoyed the discussion and feedback I've had with readers over the years, it's hard to find a good privacy focused comment host. It is a shame to loose this as the public comments often keep posts up to date or add things I may have missed but unless I find a nice and easy to implement static comments system, it's email only for now.

The blog is almost ten years old now! Going back through the archives, there is some embarrassing stuff and it's certainly not representative of my current skill set but I opted to keep them, as a record of my progression as an engineer if nothing else.

I hope to continue updating this blog with personal projects for at least another ten years. I already have a couple of projects in my backlog I'm excited to write about and the Markdown -> blog post should lower the barrier to this.

## Wordpress to Jekyll Migration

There are a [number of posts](https://nts.strzibny.name/migrating-wordpress-to-jekyll/) around for this so I won't go too deep. It was not quite as simple as running a plugin however!

1. Install the [Wordpress to Jekyll exporter plugin](https://github.com/benbalter/wordpress-to-jekyll-exporter).
2. Find out this doesn't work on the production site and so export the SQL database and spin up a [Docker wordpress](https://hub.docker.com/_/wordpress) container:

```yaml
services:
    wordpress:
      image: wordpress
      restart: always
      ports:
        - 80:80
        - 443:443
      environment:
        WORDPRESS_DB_HOST: db
        WORDPRESS_DB_USER: db_user
        WORDPRESS_DB_PASSWORD: db_password
        WORDPRESS_DB_NAME: db_name
      volumes:
        - ./wp-content/themes/my-theme:/var/www/html/wp-content/themes/my-theme # mapping our custom theme to the container
        - ./wp-content/plugins:/var/www/html/wp-content/plugins # map our plugins to the container
        - ./wp-content/uploads:/var/www/html/wp-content/uploads # map our uploads to the container

    db:
      image: mysql:5.7
      restart: always
      environment:
        MYSQL_DATABASE: db_name
        MYSQL_USER: db_user
        MYSQL_PASSWORD: db_password
        MYSQL_RANDOM_ROOT_PASSWORD: '1'
      volumes:
        # put the exported .sql database in ./docker/ and it will be imported
        - ./docker:/docker-entrypoint-initdb.d
```

3. Realise the local site attemps to re-direct http -> https when using '/wp-admin' so:

```bash
docker exec -it engineer_db_1 bash
mysql --user=root --password=ROOT_PASSWORD # where the password is the root password displayed when the serice is started
use db_name
SELECT * from wp_options WHERE option_name = 'home' OR option_name = 'siteurl';
UPDATE wp_options SET option_value = 'http://localhost' WHERE option_name = 'home' OR option_name = 'siteurl';
```

4. Fix all the exported Markdown post asset links and inline html using a mix of `vim` macros and `fd . _posts/ --type f -e md --exec sed ...`; the exporter does not do this...
