# Sir Sync-A-Lot. An optimised S3 sync tool using the power of *nix!

## Requirements:

* Ruby 1.8.something
* RubyGems
* aws-s3 RubyGem
* OpenSSL
* find and xargs (should be on your *nix straight outta the box)

To configure, run <code>sir-sync-a-lot setup</code> and follow the prompts, you'll
need your S3 keys, the local file path you want to back up, the bucket name
to back up to, and any extra options to pass into find (i.e. for ignoring
filepaths etc). It'll write the config to <code>~/.sir-sync-a-lot.yml</code>.

Then to sync, run <code>sir-sync-a-lot sync</code> and away she goes.

## Why?

This library was written because we needed to be able to back up craploads of
data without having to worry about if we had enough disk space on the remote. 
That's where S3 is nice. 

We tried s3sync but it blew the crap out of our server load (we do in excess of
500,000 requests a day (page views, not including hits for images and what not,
and the server needs to stay responsive). The secret sauce is using the *nix 
'find', 'xargs' and 'openssl' commands to generate md5 checksums for comparison. 
Seems to work quite well for us (we have almost 90,000 files to compare).

Initially the plan was to use find with -ctime but S3 isn't particulary nice about
returning a full list of objects in a bucket (default is 1000, and I want all 
90,000, and it ignores me when I ask for 1,000,000 objects). Manifest generation
on a server under load is fast enough and low enough on resources so we're sticking
with that in the interim.

## Etc

FYI when you run sync, the output will look something like this:

    [Thu Apr 01 11:50:25 +1100 2010] Starting, performing pre-sync checks...
    [Thu Apr 01 11:50:26 +1100 2010] Generating local manifest...
    [Thu Apr 01 11:50:26 +1100 2010] Fetching remote manifest...
    [Thu Apr 01 11:50:27 +1100 2010] Performing checksum comparison...
    [Thu Apr 01 11:50:27 +1100 2010] Pushing /tmp/backups/deep/four...
    [Thu Apr 01 11:50:28 +1100 2010] Pushing /tmp/backups/three...
    [Thu Apr 01 11:50:29 +1100 2010] Pushing /tmp/backups/two...
    [Thu Apr 01 11:50:30 +1100 2010] Pushing local manifest up to remote...
    [Thu Apr 01 11:50:31 +1100 2010] Done like a dinner.

You could pipe sync into a log file, which might be nice, this is what our crontab 
looks like:

    # run sync backups to s3 every day
    0 1 * * * /usr/local/bin/rvm 1.8.7 ruby /root/sir-sync-a-lot/sir-sync-a-lot 1>> /var/log/sir-sync-a-lot.log 2>> /var/log/sir-sync-a-lot.error

Have fun!

Project wholy sponsored by Envato Pty Ltd. They're the shizzy! P.S. We use this
in production environments!
