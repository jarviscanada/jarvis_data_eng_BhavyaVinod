--connect to host agent
\c host_agent;

--Creates host_info table only if it does not exists to store hardware specifications
CREATE TABLE iF NOT EXISTS public.host_info
(
    id SERIAL NOT NULL PRIMARY KEY,
    hostname VARCHAR NOT NULL UNIQUE,
    cpu_number INT NOT NULL,
    cpu_architecture VARCHAR NOT NULL,
    cpu_model INT NOT NULL,
    cpu_mhz  INT NOT NULL,
    L2_cache VARCHAR NOT NULL,
    total_mem INT NOT NULL,
    "timestamp" TIMESTAMP NOT NULL
);

--Creates host_usage table only if it does not exist to store resource usage data
CREATE TABLE if NOT EXISTS PUBLIC.host_usage
(
    "timestamp" TIMESTAMP NOT NULL,
    host_id SERIAL NOT NULL REFERENCES host_info(id),
    memory_free INT NOT NULL,
    cpu_idle INT NOT NULL,
    cpu_kernel INT NOT NULL,
    disk_io INT NOT NULL,
    disk_available INT NOT NULL
);