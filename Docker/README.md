# Docker Help for Future Self

1. Navigate your way down to this folder on your machine
2. Configure the sa password via environment variables
`export MSSQL_SA_PASSWORD=SeePasswordVault`
3. Run the following to compose Tosk SQL Server
`docker-compose -f sql/docker-compose-tosk.yaml up -d`

## Copy backup file into container

```bash
sudo docker cp AdventureWorks.bak tosk-mssql:/var/opt/mssql/backup
sudo docker cp AdventureWorksDataWarehouse_backup_08102024_180000.bak tosk-mssql:/var/opt/mssql/backup   
sudo docker cp Chinook_backup_08102024_180000.bak tosk-mssql:/var/opt/mssql/backup
sudo docker cp ContosoUniversity_backup_08102024_180000.bak tosk-mssql:/var/opt/mssql/backup
sudo docker cp Northwind_backup_08102024_180000.bak tosk-mssql:/var/opt/mssql/backup
sudo docker cp Pubs_backup_08092024_180001.bak tosk-mssql:/var/opt/mssql/backup
sudo docker cp WideWorldImporters-Full.bak tosk-mssql:/var/opt/mssql/backup
sudo docker cp WideWorldImportersDW-Full.bak tosk-mssql:/var/opt/mssql/backup
sudo docker cp ZipCodeDatabase_backup_08102024_180000.bak tosk-mssql:/var/opt/mssql/backup
```

## Reset permissions on backup folder

We’ll use docker exec to run the appropriate commands inside the container to set the ownership and permissions. Since the container is running as mssql we need to specify the -u 0 parameter to run these commands as root.

1. In the directory listing below, for the files that we copied in, you can see the UID is 501 and the GID is 20. I’m on a Mac and my current user’s UID is 501 and GID is 20. So those are the permissions on the files copied into the container. These files are not accessible by SQL Server since the UID of user mssql is 10001.
2. The first command run is chown, which sets the user and group owner as mssql, UID 10001 inside the container, and GID 0, which is the root user.
3. we’ll need is chmod to set the permissions on the files. Here we’re going to set the permissions to rw using the octal notation of 660 for both the user and group owner.

```bash
docker exec tosk-mssql bash -c 'ls -lan /var/opt/mssql/backup/*.bak'
docker exec -u 0 tosk-mssql bash -c 'chown 10001:0 /var/opt/mssql/backup/*.bak'
docker exec -u 0 tosk-mssql bash -c 'chmod 660 /var/opt/mssql/backup/*.bak'
```
