#!/bin/bash

#backup old stanza file
mv /tmp/quota_stanza /tmp/quota_stanza-bak

quotas=$(sqlite3 quota.db "SELECT * FROM gpfs_quotas")

#extract data from SQLite database
for line in $quotas
  do
#  echo $line
  echo $line | awk -F '|' '{ print "%quota:\n","\tdevice="$1"\n","\tcommand="$2"\n","\tfileset="$3"\n","\ttype="$4"\n","\tid="$5"\n","\tblockQuota="$6"\n","\tblockLimit="$7"\n","\tfilesQuota="$8"\n","\tfilesLimit="$9"\n" }' >> /tmp/quota_stanza
done

echo "quota stanza file generated at /tmp/quota_stanza"

#Uncomment below line to set quotas from stanza file automatically
#mmsetquota -F /tmp/quota_stanza

#echo "quotas updated"
