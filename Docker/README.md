# Docker Help for Future Self

1. Navigate your way down to this folder on your machine
2. Configure the sa password via environment variables
`export MSSQL_SA_PASSWORD=SeePasswordVault`
3. Run the following to compose Tosk SQL Server
`docker-compose -f sql/docker-compose-tosk.yaml up -d`
