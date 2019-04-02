# GPFS quota stanza file generator

For use with an SQLite database. Set up and use as in following example:

Create SQLite database `quota.db`. Include table `gpfs_quotas` and define the header fields and default values where appropriate. 

```
$ sqlite3 quota.db
SQLite version 3.7.17 2013-05-20 00:56:22
Enter ".help" for instructions
Enter SQL statements terminated with a ";"
sqlite> CREATE TABLE gpfs_quotas (
   ...> "filesystem" VARCHAR DEFAULT "gpfs1",
   ...> "command" TEXT DEFAULT "setquota",
   ...> "fileset" VARCHAR DEFAULT "home",
   ...> "type" TEXT DEFAULT "USR",
   ...> "id" VARCHAR,
   ...> "soft_quota" VARCHAR DEFAULT "1T",
   ...> "hard_quota" VARCHAR DEFAULT "1T",
   ...> "files_quota" INT DEFAULT 0,
   ...> "hard_files" INT DEFAULT 0);
sqlite> .table
gpfs_quotas
```
Create 3 users with default blocksize quotas, user4 with an increased quota and a group quota for the group ACRC:
```
sqlite> INSERT INTO gpfs_quotas (id)
   ...> VALUES ("user1");
sqlite> INSERT INTO gpfs_quotas (id)
   ...> VALUES ("user2");
sqlite> INSERT INTO gpfs_quotas (id)
   ...> VALUES ("user3");
sqlite> INSERT INTO gpfs_quotas (id,soft_quota,hard_quota)
   ...> VALUES ("user4","2T","2T");
sqlite> INSERT INTO gpfs_quotas (type,id,soft_quota,hard_quota)
   ...> VALUES ("GROUP","ACRC","5T","5T");
sqlite> select * from gpfs_quotas;
gpfs1|setquota|home|USR|user1|1T|1T|0|0
gpfs1|setquota|home|USR|user2|1T|1T|0|0
gpfs1|setquota|home|USR|user3|1T|1T|0|0
gpfs1|setquota|home|USR|user4|2T|2T|0|0
gpfs1|setquota|home|GROUP|ACRC|5T|5T|0|0
```
Run the gpfs_quota_stanza_generator.sh script to generate the GPFS stanza file:
```
$ ./gpfs_quota_stanza_generator.sh
$ cat /tmp/quota_stanza
%quota:
 	device=gpfs1
 	command=setquota
 	fileset=home
 	type=USR
 	id=user1
 	blockQuota=1T
 	blockLimit=1T
 	filesQuota=0
 	filesLimit=0

%quota:
 	device=gpfs1
 	command=setquota
 	fileset=home
 	type=USR
 	id=user2
 	blockQuota=1T
 	blockLimit=1T
 	filesQuota=0
 	filesLimit=0

%quota:
 	device=gpfs1
 	command=setquota
 	fileset=home
 	type=USR
 	id=user3
 	blockQuota=1T
 	blockLimit=1T
 	filesQuota=0
 	filesLimit=0

%quota:
 	device=gpfs1
 	command=setquota
 	fileset=home
 	type=USR
 	id=user4
 	blockQuota=2T
 	blockLimit=2T
 	filesQuota=0
 	filesLimit=0

%quota:
 	device=gpfs1
 	command=setquota
 	fileset=home
 	type=GROUP
 	id=ACRC
 	blockQuota=5T
 	blockLimit=5T
 	filesQuota=0
 	filesLimit=0
```
Update quotas using `mmsetquota -F`
```
mmsetquota -F /tmp/quota_stanza
```
Optional - uncomment the final 2 lines of the script to automatically run `mmsetquota` and update from the new stanza file.
