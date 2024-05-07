
run {
show all;
list incarnation of database;
list backup of database;
list copy;
list backup summary;
report unrecoverable;
report schema;
report need backup;
report obsolete;
crosscheck backup;
crosscheck copy;
delete force noprompt obsolete;
delete force noprompt archivelog all backed up 2 times to device type sbt_tape;
delete force noprompt expired backup;
}


run {
backup device type disk as compressed backupset check logical noexclude database;
backup device type disk as compressed backupset archivelog all delete input;
backup device type sbt_tape backupset all not backed up 2 times;
}

run {
recover copy of database with tag 'IMAGE_COPY';
backup device type disk
incremental level 1 cumulative  copies=1
for recover of copy with tag 'IMAGE_COPY'
check logical
noexclude
database;
backup device type sbt_tape copy of database from tag='IMAGE_COPY' keep until time 'SYSDATE+13' logs;
}

run {
sql 'alter system archive log current';
recover copy of database with tag 'IMAGE_COPY';
backup device type disk
incremental level 1 cumulative  copies=1
for recover of copy with tag 'IMAGE_COPY'
check logical
noexclude
database;
backup device type sbt_tape copy of database from tag='IMAGE_COPY' keep until time 'SYSDATE+13' logs;
backup device type sbt_tape archivelog all not backed up 2 times;
}

run {
backup validate database;
backup device type disk as compressed backupset noexclude database;
backup device type disk as compressed backupset archivelog all delete input;
backup device type sbt_tape backupset all not backed up 2 times;
}

CONFIGURE RETENTION POLICY TO REDUNDANCY 1;
CONFIGURE BACKUP OPTIMIZATION ON;
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE SBT_TAPE TO '%F'; # default
CONFIGURE DEVICE TYPE DISK BACKUP TYPE TO COMPRESSED BACKUPSET PARALLELISM 1;
CONFIGURE DEVICE TYPE 'SBT_TAPE' PARALLELISM 1 BACKUP TYPE TO BACKUPSET;
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE SBT_TAPE TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE SBT_TAPE TO 1; # default
CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' PARMS  'ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=D050P,OB2BARLIST=VIV_DAILY_DB_D050P)' FORMAT   'VIV_DAILY_DB_D050P<D050P_%s:%t:%p>.dbf';
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE ARCHIVELOG DELETION POLICY TO NONE; # default
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/u01/app/oracle/product/10.2.0/db_1/dbs/snapcf_D000P2.f'; # default


run {
set maxcorrupt for datafile 6 to 2;
backup device type disk
incremental level 1 cumulative  copies=1
for recover of copy with tag 'IMAGE_COPY'
check logical
noexclude
database;
backup device type sbt_tape copy of database from tag='IMAGE_COPY' keep until time 'SYSDATE+13' logs;
backup device type sbt_tape archivelog all not backed up 2 times;
}

run {
backup device type disk as compressed backupset check logical noexclude database tag 'COMPRESSED_DB';
backup device type sbt_tape backupset all delete input;
}

CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' PARMS  'ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=D050P,OB2BARLIST=VIV_DAILY_DB_D050P)' FORMAT   'VIV_DAILY_DB_D050P<D050P_%s:%t:%p>.dbf';
CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' PARMS  'ENV=(OB2BARTYPE=Oracle8,OB2APPNAME=D100P,OB2BARLIST=VIV_DAILY_DB_D100P)' FORMAT   'VIV_DAILY_DB_D100P<D100P_%s:%t:%p>.dbf';

select t.ts#, t.name, t.INCLUDED_IN_DATABASE_BACKUP, max(b.CHECKPOINT_TIME), e.MARKED_CORRUPT
from v$tablespace t,
     v$datafile d,
     v$backup_datafile b,
     v$backup_datafile_details e
where t.ts# = d.ts#
and   d.file# = b.file#
and   b.file# = e.file#
group by t.ts#, t.name, t.INCLUDED_IN_DATABASE_BACKUP, e.MARKED_CORRUPT
order by 1
/

select t.ts#, t.name, t.INCLUDED_IN_DATABASE_BACKUP, max(b.CHECKPOINT_TIME)
from v$tablespace t,
     v$datafile d,
     v$backup_datafile b
where t.ts# = d.ts#
and   d.file# = b.file#
group by t.ts#, t.name, t.INCLUDED_IN_DATABASE_BACKUP
order by 1
/
